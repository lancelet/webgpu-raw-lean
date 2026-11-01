import WebGPUGen.Yaml
import WebGPUGen.Spec.Decode
import WebGPUGen.Spec.Dump
import WebGPUGenTest

/-!
# Test driver

Reads the vendored spec, decodes every section the reader supports so far, and
prints a dump of the result. A decoding failure stops with its path.

Run with `lake test` (or `lake test -- --docs`) inside `webgpu-gen`; the built
executable `webgpu-gen/.lake/build/bin/webgpu-gen-test` also works from anywhere.
-/

open WebGPUGen.Yaml WebGPUGen.Decode WebGPUGen.Spec

/-- The vendored spec, found from this executable's location
(`webgpu-gen/.lake/build/bin/`), so the driver works from any directory. -/
def specPath : IO System.FilePath := do
  let bin := (← IO.appPath).parent.getD "."
  let package := ((bin.parent.bind (·.parent)).bind (·.parent)).getD "."
  return package / ".." / "vendor" / "webgpu-headers" / "webgpu.yml"

/-- The top-level keys of `webgpu.yml`, in order. If upstream adds or renames a
section, this fails, and the spec reader must be updated to match. -/
def expectedKeys : List String :=
  ["copyright", "name", "enum_prefix", "doc", "constants", "typedefs", "enums",
   "bitflags", "structs", "callbacks", "functions", "objects"]

def failWith {α} (message : String) : IO α := throw (IO.userError s!"FAIL: {message}")

/-- Decode the top-level section `key` as a list of entries. -/
def decodeSection {α} (entries : Array (String × Node)) (key : String)
    (decode : Node → Decode α) : IO (Array α) := do
  let some node := (entries.find? (·.1 == key)).map (·.2)
    | failWith s!"no section {key}"
  match (within key (seq decode node)).run with
  | .ok items => pure items
  | .error e => failWith (toString e)

def main (args : List String) : IO Unit := do
  let options : DumpOptions := { docs := args.contains "--docs" }
  let .map entries ← parseFile (← specPath)
    | failWith "spec is not a mapping"
  let keys := entries.toList.map (·.1)
  unless keys == expectedKeys do failWith s!"top-level keys are {keys}"

  let constants ← decodeSection entries "constants" Constant.decode
  let typedefs  ← decodeSection entries "typedefs"  Typedef.decode
  let enums     ← decodeSection entries "enums"     Enum.decode
  let bitflags  ← decodeSection entries "bitflags"  Bitflag.decode
  let structs   ← decodeSection entries "structs"   Struct.decode
  let callbacks ← decodeSection entries "callbacks" Callback.decode
  let functions ← decodeSection entries "functions" Function.decode
  let objects   ← decodeSection entries "objects"   Object.decode

  let dump :=
    dumpConstants options constants
      ++ dumpTypedefs options typedefs
      ++ dumpEnums options enums
      ++ dumpBitflags options bitflags
      ++ dumpStructs options structs
      ++ dumpCallbacks options callbacks
      ++ dumpFunctions options functions
      ++ dumpObjects options objects
  for line in dump do
    IO.println line
