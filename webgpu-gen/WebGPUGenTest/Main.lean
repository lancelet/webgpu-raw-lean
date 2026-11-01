import WebGPUGen.Yaml
import WebGPUGen.Spec.Decode
import WebGPUGenTest

/-!
# Test driver

Checks that need IO: reading the vendored spec. Run from the `webgpu-gen` directory.
-/

open WebGPUGen.Yaml WebGPUGen.Decode WebGPUGen.Spec

def specPath : System.FilePath := "../vendor/webgpu-headers/webgpu.yml"

/-- The top-level keys of `webgpu.yml`, in order. If upstream adds or renames a
section, this fails, and the spec reader must be updated to match. -/
def expectedKeys : List String :=
  ["copyright", "name", "enum_prefix", "doc", "constants", "typedefs", "enums",
   "bitflags", "structs", "callbacks", "functions", "objects"]

def check (ok : Bool) (what : String) : IO Unit :=
  unless ok do throw (IO.userError s!"FAIL: {what}")

/-- Decode the top-level section `key` as a list of entries. -/
def decodeSection {α} (entries : Array (String × Node)) (key : String)
    (decode : Node → Decode α) : IO (Array α) := do
  let some node := (entries.find? (·.1 == key)).map (·.2)
    | throw (IO.userError s!"FAIL: no section {key}")
  match (within key (seq decode node)).run with
  | .ok items => pure items
  | .error e => throw (IO.userError s!"FAIL: {e}")

def main : IO Unit := do
  let .map entries ← parseFile specPath
    | throw (IO.userError "FAIL: spec is not a mapping")
  let keys := entries.toList.map (·.1)
  check (keys == expectedKeys) s!"top-level keys are {keys}"
  check ((entries.find? (·.1 == "name")).map (·.2) == some (yaml% "webgpu"))
    "name is webgpu"

  let constants ← decodeSection entries "constants" Constant.decode
  check (constants.size == 11) s!"11 constants, found {constants.size}"
  check (constants.any fun c => c.name.text == "whole_size" && c.value == .uint64Max)
    "whole_size is uint64_max"

  let typedefs ← decodeSection entries "typedefs" Typedef.decode
  check typedefs.isEmpty "no typedefs"

  IO.println s!"ok: decoded {constants.size} constants, {typedefs.size} typedefs"
