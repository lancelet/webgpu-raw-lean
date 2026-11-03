import WebGPUGen.Yaml
import WebGPUGen.Parsed.Codec
import WebGPUGen.Resolved.Resolve
import WebGPUGen.Resolved.Unresolve
import WebGPUGen.Resolved.Values
import WebGPUGen.Lowered.CNames
import WebGPUGen.Lowered.Lower
import WebGPUGen.Emit.C.Objects
import WebGPUGen.Emit.C.Functions
import WebGPUGenTest

/-!
# Test driver

Reads the vendored spec, decodes it, checks that it re-encodes to the same spec,
and resolves it. Then checks the C names and the enum and flag values generated
for it against the vendored `webgpu.h`, and compiles the generated C shims. It
prints one line if every check passes, and otherwise the first failure; a
decoding failure stops with its path. (To see what the reader understood, run
`lake exe webgpu-gen dump`.)

Run with `lake test` inside `webgpu-gen`; the built executable
`webgpu-gen/.lake/build/bin/webgpu-gen-test` also works from anywhere.
-/

open WebGPUGen.Yaml WebGPUGen.Common WebGPUGen.Parsed

/--
The vendored spec, found from this executable's location
(`webgpu-gen/.lake/build/bin/`), so the driver works from any directory.
-/
def specPath : IO System.FilePath := do
  let bin := (← IO.appPath).parent.getD "."
  let package := ((bin.parent.bind (·.parent)).bind (·.parent)).getD "."
  return package / ".." / "vendor" / "webgpu-headers" / "webgpu.yml"

/--
The functions wgpu-native leaves unimplemented (`vendor/wgpu-native/stubs`), as
the generator reads them.
-/
def stubs : IO (List (String × List String)) := do
  let path := (← specPath).parent.bind (·.parent) |>.getD "."
  let text ← IO.FS.readFile (path / "wgpu-native" / "stubs")
  return [("wgpu-native", WebGPUGen.parseStubs text)]

/-- The C header upstream generates from the vendored spec, next to it. -/
def headerPath : IO System.FilePath := do
  return (← specPath).withFileName "webgpu.h"

open WebGPUGen.Lowered in
/--
The C names of members or arguments, with the count that goes with each array.
-/
def memberNames {Doc} (ps : Array (Parameter Doc)) : List String :=
  ps.toList.flatMap fun p =>
    let count := match p.type with
      | .refArray .. | .primitive (.array _) => [arrayCountName p.name]
      | _ => []
    memberName p.name :: count

open WebGPUGen.Lowered in
/--
Every C name `webgpu.h` should declare for `s`: types, enum entries and flags,
constants, functions and methods with their pointer types, and the names of
members and arguments.
-/
def cNames (s : WebGPUGen.Parsed.Spec) : List String :=
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

/--
The values `webgpu.h` gives enum entries and flags, by C name, from lines such
as ` WGPUFeatureLevel_Core = 0x00000002,` and `static const WGPUBufferUsage
WGPUBufferUsage_MapRead = 0x0000000000000001;`.
-/
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

/-- The value of every enum entry and flag in the lowered spec, by C name. -/
def computedValues (l : WebGPUGen.Lowered.Spec) : List (String × Nat) :=
  let enums := l.enums.toList.flatMap fun e =>
    e.entries.toList.map fun entry => (entry.names.c, entry.value.toNat)
  let flags := l.bitflags.toList.flatMap fun b =>
    b.flags.toList.map fun flag => (flag.names.c, flag.value.toNat)
  enums ++ flags

/-- The names that occur more than once in `names`. -/
def repeated (names : List String) : List String :=
  (names.filter fun n => names.count n > 1).eraseDups

/--
Lean names that clash in the lowered spec: type names shared by two types (enum,
bitflag, object or struct), entry or flag names shared within one type, function
and method names shared by two functions, argument names shared within one
function, and member names shared within one struct or taken by its chain.
-/
def leanClashes (l : WebGPUGen.Lowered.Spec) : List String :=
  let types :=
    l.enums.toList.map (·.names.lean) ++ l.bitflags.toList.map (·.names.lean)
      ++ l.objects.toList.map (·.names.lean)
      ++ l.structs.toList.map (·.names.lean)
  -- Member names shared within a struct, and any taken by what the printer adds
  -- to every chained struct.
  let members := l.structs.toList.map fun s =>
    let names := s.members.toList.map (·.names.lean)
    (repeated names ++ names.filter (["nextInChain", "chain"].contains ·)).map
      (s.names.lean ++ "." ++ ·)
  let functions :=
    l.functions.toList ++ l.objects.toList.flatMap (·.methods.toList)
  let args := functions.map fun f =>
    (repeated (f.args.toList.map (·.names.lean))).map (f.names.lean ++ " " ++ ·)
  let enums := l.enums.toList.map fun e =>
    (repeated (e.entries.toList.map (·.names.lean))).map (e.names.lean ++ "." ++ ·)
  let flags := l.bitflags.toList.map fun b =>
    (repeated (b.flags.toList.map (·.names.lean))).map (b.names.lean ++ "." ++ ·)
  repeated types ++ enums.flatten ++ flags.flatten
    ++ repeated (functions.map (·.names.lean)) ++ args.flatten
    ++ members.flatten

open WebGPUGen.Emit.C in
/--
A probe of every conversion the shims make: a method of `WGPUBuffer` taking an
argument of every kind, and a function returning each kind of result, with the
prototypes of the C functions they call (which `webgpu.h` does not declare).
Compiled with the real shims, so every conversion, check and helper is
compiled, though the spec may not use it yet.
-/
def probeSource (buffer : WebGPUGen.Lowered.Object) : String :=
  let format : WebGPUGen.Lowered.Names := ⟨"WGPUTextureFormat", "TextureFormat"⟩
  let usage : WebGPUGen.Lowered.Names := ⟨"WGPUBufferUsage", "BufferUsage"⟩
  let kinds : List (String × WebGPUGen.Lowered.Value) := [
    ("Flag", .bool), ("U16", .uint16), ("U32", .uint32), ("U64", .uint64),
    ("I16", .int16), ("I32", .int32), ("F32", .float32), ("F64", .float64),
    ("Size", .usize), ("Format", .enum format), ("Usage", .bitflag usage),
    ("Buffer", .object buffer.names false),
    ("Maybe", .object buffer.names true),
    ("Label", .string false), ("Name", .string true)
  ]
  let function (name : String) (receiver : Bool)
      (args : List (String × WebGPUGen.Lowered.Value))
      (result : Option WebGPUGen.Lowered.Value) :
      WebGPUGen.Lowered.Function := {
    names    := ⟨"wgpuProbe" ++ name, "probe" ++ name⟩
    doc      := ""
    receiver := if receiver then some buffer.names else none
    args     := args.toArray.map fun (n, v) => ⟨⟨"arg" ++ n, "arg" ++ n⟩, "", v⟩
    result   := result
    callback := false
  }
  let functions :=
    function "Args" true kinds none
      :: (kinds.filter fun (_, v) => !v matches .string _).map fun (n, v) =>
        function n false [] (some v)
  let prototype (f : WebGPUGen.Lowered.Function) : Decl := .prototype {
    doc    := ""
    attrs  := []
    result := (f.result.bind (·.cType)).getD "void"
    name   := f.names.c
    params := (if f.receiver.isSome then [⟨"WGPUBuffer", "self"⟩] else [])
      ++ f.args.toList.map fun a => ⟨(a.value.cType).getD "void", a.names.c⟩
    body   := []
  }
  let spec : WebGPUGen.Lowered.Spec := {
    constants := #[]
    enums     := #[]
    bitflags  := #[]
    structs   := #[]
    objects   := #[buffer]
    functions := functions.toArray
  }
  let decls := functionsSource spec
  file (decls.take 2 ++ functions.map prototype ++ decls.drop 2)

/--
Compile the generated C shims, with warnings as errors, against the vendored
`webgpu.h` (at `headerPath`) and Lean's `lean.h`, with the system C compiler
(`cc`, or the one `CC` names), as the bindings' build does: Lean's bundled
compiler lacks the C library's headers, which `webgpu.h` includes.
Only compiling, not linking: nothing here needs wgpu-native.
-/
def compileShims (spec : WebGPUGen.Lowered.Spec) (header : System.FilePath) :
    IO (Option String) :=
  IO.FS.withTempDir fun dir => do
    IO.FS.createDirAll (dir / "webgpu")
    IO.FS.writeFile (dir / "webgpu" / "webgpu.h") (← IO.FS.readFile header)
    let provenance : WebGPUGen.Emit.Provenance := {
      generator    := "webgpu-gen-test"
      time         := ""
      commit       := ""
      dirty        := false
      source       := ""
      sourceRepo   := ""
      sourceCommit := ""
      sourceDate   := ""
      pinnedBy     := ""
    }
    let files :=
      WebGPUGen.Emit.C.objectsFiles provenance spec
        ++ WebGPUGen.Emit.C.functionsFiles provenance spec
    for (name, text) in files do
      IO.FS.writeFile (dir / name) text
    let leanPrefix := (← IO.Process.output { cmd := "lean", args := #["--print-prefix"] }).stdout
    let leanInclude := System.FilePath.mk leanPrefix.trimAscii.toString / "include"
    let mut errors := ""
    if let some buffer := spec.objects.find? (·.names.c == "WGPUBuffer") then
      IO.FS.writeFile (dir / "probe.c") (probeSource buffer)
    -- The shims both ways: built against Dawn, and not.
    let builds := [
      ("objects", #[]),
      ("functions", #[]),
      ("functions", #["-DWEBGPU_RAW_DAWN"]),
      ("probe", #[])
    ]
    for (source, defines) in builds do
      let out ← IO.Process.output {
        cmd  := (← IO.getEnv "CC").getD "cc"
        args := #[
          "-c", "-std=c11", "-Wall", "-Wextra", "-Werror",
          "-I", dir.toString, "-I", leanInclude.toString
        ] ++ defines ++ #[
          (dir / s!"{source}.c").toString, "-o", (dir / s!"{source}.o").toString
        ]
      }
      errors := errors ++ out.stderr
      unless out.exitCode == 0 do
        return some errors
    return none

/--
The header's initialisers: for each `WGPU_X_INIT` macro, its struct's C name
and each member's initialiser, as written (`/*.size=*/WGPU_WHOLE_SIZE`).
-/
def headerInits (header : String) : List (String × List (String × String)) :=
  let step (acc : List (String × List (String × String))) (line : String) :=
    let line := line.trimAscii.toString
    -- A macro starts a struct; a nested one, as an extension's chain, does not.
    let parts := line.splitOn "_wgpu_MAKE_INIT_STRUCT("
    match line.startsWith "#define WGPU_", parts with
    | true, [_, rest] => (rest.takeWhile (· != ',') |>.toString, []) :: acc
    | _, _ =>
      match acc, line.splitOn "/*." with
      | (s, members) :: more, [_, rest] =>
        match rest.splitOn "=*/" with
        | [name, value] =>
          let value := (value.splitOn " _wgpu_COMMA").head!.trimAscii.toString
          let value := (value.dropSuffix "\\").trimAscii.toString
          (s, members ++ [(name, value)]) :: more
        | _ => acc
      | _, _ => acc
  ((header.splitOn "\n").foldl step []).reverse

/-- A number as C writes it, in decimal or hex, if it is one. -/
def cNumber? (text : String) : Option Nat :=
  if text.startsWith "0x" then
    (text.drop 2).foldl (init := some 0) fun acc c => acc.bind fun n =>
      if c.isDigit then some (16 * n + (c.toNat - '0'.toNat))
      else if 'A' ≤ c.toUpper && c.toUpper ≤ 'F' then
        some (16 * n + (c.toUpper.toNat - 'A'.toNat + 10))
      else none
  else text.toNat?

/--
A float as C or the spec writes it, normalised for comparison: `32.f`, `32.0`
and `32.` are all `32.`.
-/
def floatText (text : String) : String :=
  let text := (text.dropSuffix "f").toString
  match text.splitOn "." with
  | [whole, fraction] =>
    whole ++ "." ++ (fraction.dropEndWhile (· == '0')).toString
  | _ => text

open WebGPUGen.Lowered in
/--
The initialisers C's `WGPU_X_INIT` gives each member of `s`, by the lowered
model: what the header should say, member by member. An array is two members,
its count and its pointer. Members the bindings cannot pass are left out.
`initName` gives a nested struct's initialiser macro.
-/
def expectedInits (initName : String → Option String)
    (s : WebGPUGen.Lowered.Struct) :
    List (String × String) :=
  s.members.toList.flatMap fun m =>
    match m.value with
    | .unsupported _ => []
    | .array _ count => [(count, "0"), (m.names.c, "NULL")]
    | v => [(m.names.c, render v m.default)]
where
  render (v : WebGPUGen.Lowered.Value) :
      Option WebGPUGen.Lowered.Default → String
    | some (.bool true)      => "WGPU_TRUE"
    | some (.bool false)     => "WGPU_FALSE"
    | some (.int n)          => toString n
    | some (.float text)     => floatText text
    | some (.constant names) => names.c
    | some (.entry _ entry)  => entry.c
    | some .zero             => "_wgpu_STRUCT_ZERO_INIT"
    -- Lowering writes out a `zero` default's field values.
    | some (.fields ..)      => "_wgpu_STRUCT_ZERO_INIT"
    | some .nested           => match v with
      | .struct names => (initName names.c).getD "?"
      | _ => "?"
    | some .null             => match v with
      | .string _ => "WGPU_STRING_VIEW_INIT"
      | .nullableFloat32 => "(NAN)"
      | _ => "NULL"
    | some .empty            => "WGPU_STRING_VIEW_INIT"
    | none                   => match v with
      | .enum names => s!"_wgpu_ENUM_ZERO_INIT({names.c})"
      -- Required in Lean, since it needs something given; C still sets it
      -- to its own defaults.
      | .struct names => (initName names.c).getD "?"
      | _ => "NULL"

/-- Do the header's initialiser and the expected one agree? -/
def initsAgree (header expected : String) : Bool :=
  header == expected
    || (cNumber? header).isSome && cNumber? header == cNumber? expected
    || floatText header == expected

def failWith {α} (message : String) : IO α := throw (IO.userError s!"FAIL: {message}")

def main : IO Unit := do
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

  -- Every function wgpu-native leaves unimplemented is one webgpu.h declares:
  -- one renamed would otherwise lose its guard silently.
  let stubNames := (← stubs).flatMap (·.2)
  let unknown := stubNames.filter (!declared.contains ·)
  unless unknown.isEmpty do
    failWith s!"stubs webgpu.h does not declare: {unknown}"

  -- Every enum entry and flag has the value upstream's header gives it.
  let values := headerValues header
  let lowered := WebGPUGen.Lowered.lower resolved (stubs := ← stubs)
  let computed := computedValues lowered
  let wrong := computed.filter fun (name, v) => values.get? name != some v
  unless wrong.isEmpty do
    failWith s!"values differing from webgpu.h: {wrong}"
  -- And every value the header gives is one we compute, except the `_Force32`
  -- entry upstream adds to each enum to make it 32 bits wide.
  let names := Std.HashSet.ofList (computed.map (·.1))
  let extra := values.keys.filter fun n => !n.endsWith "_Force32" && !names.contains n
  unless extra.isEmpty do
    failWith s!"values in webgpu.h not computed: {extra}"

  -- Every constant is what webgpu.h defines it as.
  let defines := header.splitOn "\n" |>.filterMap fun line =>
    match line.trimAscii.toString.splitOn " " with
    | ["#define", name, value] => some (name, value)
    | _ => none
  let wrongConstants := lowered.constants.toList.filterMap fun c =>
    let expected := match c.value with
      | .uint32 0xFFFFFFFF => "(UINT32_MAX)"
      | .uint64 0xFFFFFFFFFFFFFFFF => "(UINT64_MAX)"
      -- The spec has no plain integer constant: one would need its C type
      -- checked, so it fails here until then.
      | .uint64 n | .uint32 n => s!"(an integer constant {n}: check its C type)"
      | .sizeMax => "(SIZE_MAX)"
      | .nan => "(NAN)"
    match defines.lookup c.names.c with
    | some actual => if actual == expected then none
      else some s!"{c.names.c}: {actual}, not {expected}"
    | none => some s!"{c.names.c}: not defined"
  unless wrongConstants.isEmpty do
    failWith s!"constants differing from webgpu.h: {wrongConstants}"

  -- The lowered model's own C names for structs are declared: array counts
  -- and extensions' SType entries.
  let structNames := lowered.structs.toList.flatMap fun s =>
    s.sType.toList.map (·.c) ++ s.members.toList.filterMap fun m =>
      match m.value with
      | .array _ count => some count
      | _ => none
  let undeclared := structNames.filter (!declared.contains ·)
  unless undeclared.isEmpty do
    failWith s!"lowered struct names not in webgpu.h: {undeclared}"

  -- Every struct member's default is the one webgpu.h's initialiser gives it.
  let inits := headerInits header
  let initName (c : String) : Option String :=
    resolved.structs.toList.find? (WebGPUGen.Lowered.typeName ·.name == c)
      |>.map fun s => WebGPUGen.Lowered.constantName s.name ++ "_INIT"
  let wrongDefaults := lowered.structs.toList.flatMap fun s =>
    match inits.lookup s.names.c with
    | none => [s!"{s.names.c}: no initialiser in webgpu.h"]
    | some members =>
      (expectedInits initName s).filterMap fun (name, expected) =>
      match members.lookup name with
      | some actual =>
        -- A nullable float's `none` is NaN, which the header may give by a
        -- #define's name: compare that one's value, and only that one's.
        let defined := if expected != "(NAN)" then actual
          else (defines.lookup actual).getD actual
        if initsAgree actual expected || initsAgree defined expected then none
        else some s!"{s.names.c}.{name}: {actual}, not {expected}"
      | none => some s!"{s.names.c}.{name}: not in its initialiser"
  unless wrongDefaults.isEmpty do
    let lines := "\n".intercalate wrongDefaults
    failWith s!"defaults differing from webgpu.h:\n{lines}"

  -- Lean names do not clash.
  let clashes := leanClashes lowered
  unless clashes.isEmpty do
    failWith s!"Lean names that clash: {clashes}"

  -- The generated C shims compile.
  -- Every function lowering says can be bound has a shim: none is lost.
  let shimmed := (WebGPUGen.Emit.C.boundFunctions lowered).map (·.1.names.c)
  let lost := (WebGPUGen.Emit.C.allFunctions lowered).filter fun f =>
    f.unsupported.isEmpty && !shimmed.contains f.names.c
  unless lost.isEmpty do
    failWith s!"bindable functions with no shim: {lost.map (·.names.c)}"

  if let some errors ← compileShims lowered (← headerPath) then
    failWith s!"the generated C shims do not compile:\n{errors}"

  IO.println "webgpu-gen-test: every check passed on the vendored spec."
