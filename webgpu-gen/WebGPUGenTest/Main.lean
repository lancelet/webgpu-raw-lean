import WebGPUGen.Yaml
import WebGPUGen.Parsed.Codec
import WebGPUGen.Parsed.Dump
import WebGPUGen.Resolved.Resolve
import WebGPUGen.Resolved.Unresolve
import WebGPUGen.Resolved.Values
import WebGPUGen.Lowered.CNames
import WebGPUGenTest

/-!
# Test driver

Reads the vendored spec, decodes it, checks that it re-encodes to the same spec,
and resolves it. Then checks the C names and the enum and flag values generated
for it against the vendored `webgpu.h`, and prints a dump of the result. A
decoding failure stops with its path.

Run with `lake test` (or `lake test -- --docs`) inside `webgpu-gen`; the built
executable `webgpu-gen/.lake/build/bin/webgpu-gen-test` also works from anywhere.
-/

open WebGPUGen.Yaml WebGPUGen.Common WebGPUGen.Parsed

/-- The vendored spec, found from this executable's location
(`webgpu-gen/.lake/build/bin/`), so the driver works from any directory. -/
def specPath : IO System.FilePath := do
  let bin := (← IO.appPath).parent.getD "."
  let package := ((bin.parent.bind (·.parent)).bind (·.parent)).getD "."
  return package / ".." / "vendor" / "webgpu-headers" / "webgpu.yml"

/-- The C header upstream generates from the vendored spec, next to it. -/
def headerPath : IO System.FilePath := do
  return (← specPath).withFileName "webgpu.h"

open WebGPUGen.Lowered in
/-- The C names of members or arguments. -/
def memberNames {Doc} (ps : Array (Parameter Doc)) : List String :=
  ps.toList.map (memberName ·.name)

open WebGPUGen.Lowered in
/-- Every C name `webgpu.h` should declare for `s`: types, enum entries and
flags, constants, functions and methods with their pointer types, and the
names of members and arguments. -/
def cNames (s : Spec) : List String :=
  s.constants.toList.map (constantName ·.name)
    ++ s.typedefs.toList.map (typeName ·.name)
    ++ s.enums.toList.flatMap (fun e =>
      typeName e.name :: e.entries.toList.filterMap (·.map (entryName e.name ·.name)))
    ++ s.bitflags.toList.flatMap (fun b =>
      typeName b.name :: b.entries.toList.map (entryName b.name ·.name))
    ++ s.structs.toList.flatMap (fun st => typeName st.name :: memberNames st.members)
    ++ s.callbacks.toList.flatMap (fun c =>
      callbackTypeName c.name :: callbackInfoName c.name :: memberNames c.args)
    ++ s.functions.toList.flatMap (fun f =>
      functionName f.name :: functionProcName f.name :: memberNames f.args)
    ++ s.objects.toList.flatMap (fun o =>
      typeName o.name :: o.methods.toList.flatMap (fun m =>
        methodName o.name m.name :: methodProcName o.name m.name :: memberNames m.args))

/-- The identifiers in C source text. -/
def identifiers (text : String) : Std.HashSet String :=
  Std.HashSet.ofList (text.splitToList (fun c => !(c.isAlphanum || c == '_')))

/-- The values `webgpu.h` gives enum entries and flags, by C name, from lines such
as `    WGPUFeatureLevel_Core = 0x00000002,` and
`static const WGPUBufferUsage WGPUBufferUsage_MapRead = 0x0000000000000001;`. -/
def headerValues (text : String) : Std.HashMap String Nat :=
  (text.splitOn "\n").foldl (init := {}) fun values line =>
    match line.splitOn " = 0x" with
    | [lhs, rhs] =>
      let name := ((lhs.splitOn " ").getLast?).getD ""
      let digits := rhs.toList.takeWhile fun c => c.isDigit || ('A' ≤ c && c ≤ 'F')
      match WebGPUGen.Yaml.parseInt? ("0x" ++ String.ofList digits) with
      | some v => values.insert name v.toNat
      | none   => values
    | _ => values

open WebGPUGen.Lowered WebGPUGen.Resolved in
/-- The value of every enum entry and flag in `r`, by C name. -/
def computedValues (r : WebGPUGen.Resolved.Spec) : List (String × Nat) :=
  let enums := r.enums.toList.flatMap fun e =>
    e.entries.toList.zipIdx.filterMap fun (slot, i) =>
      slot.map fun entry => (entryName e.name entry.name, (enumValue r i entry).toNat)
  let flags := r.bitflags.toList.flatMap fun b =>
    b.entries.toList.zipIdx.map fun (f, i) => (entryName b.name f.name, (flagValue b i).toNat)
  enums ++ flags

def failWith {α} (message : String) : IO α := throw (IO.userError s!"FAIL: {message}")

def main (args : List String) : IO Unit := do
  let options : DumpOptions := { docs := args.contains "--docs" }
  let node ← parseFile (← specPath)
  let spec ← match (Spec.codec.decode node).run with
    | .ok spec => pure spec
    | .error e => failWith (toString e)

  -- The round trip is proved for every spec; checking it on the real one also
  -- exercises the encoder on real data.
  match (Spec.codec.decode (Spec.codec.encode spec)).run with
  | .ok again => unless again == spec do failWith "re-encoded spec decoded differently"
  | .error e => failWith s!"re-encoded spec failed to decode: {e}"

  -- Every reference must resolve; warnings are printed but do not fail.
  for w in WebGPUGen.Resolved.warnings spec do IO.eprintln s!"warning: {w}"
  let resolved ← match WebGPUGen.Resolved.resolve spec with
    | .ok r => pure r
    | .error problems => do
      for p in problems do IO.eprintln p
      failWith s!"{problems.length} problems resolving the spec"
  -- Unresolving gives back the parsed spec, as faithfulness proves for every spec.
  unless WebGPUGen.Resolved.unresolve resolved == spec do
    failWith "unresolving the resolved spec did not give back the parsed spec"

  -- Every C name we generate is declared in upstream's header. This is a check of
  -- identifiers only, so a short member name such as `label` passes wherever it
  -- is declared; checking each member inside its own struct comes with the
  -- lowered model.
  let header ← IO.FS.readFile (← headerPath)
  let declared := identifiers header
  let missing := (cNames spec).filter (!declared.contains ·)
  unless missing.isEmpty do
    failWith s!"C names not in webgpu.h: {missing}"

  -- Every enum entry and flag has the value upstream's header gives it.
  let values := headerValues header
  let computed := computedValues resolved
  let wrong := computed.filter fun (name, v) => values.get? name != some v
  unless wrong.isEmpty do
    failWith s!"values differing from webgpu.h: {wrong}"
  -- And every value the header gives is one we compute, except the `_Force32`
  -- entry upstream adds to each enum to make it 32 bits wide.
  let names := Std.HashSet.ofList (computed.map (·.1))
  let extra := values.keys.filter fun n => !n.endsWith "_Force32" && !names.contains n
  unless extra.isEmpty do
    failWith s!"values in webgpu.h not computed: {extra}"

  let dump :=
    dumpConstants options spec.constants
      ++ dumpTypedefs options spec.typedefs
      ++ dumpEnums options spec.enums
      ++ dumpBitflags options spec.bitflags
      ++ dumpStructs options spec.structs
      ++ dumpCallbacks options spec.callbacks
      ++ dumpFunctions options spec.functions
      ++ dumpObjects options spec.objects
  for line in dump do
    IO.println line
