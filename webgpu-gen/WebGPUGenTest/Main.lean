import WebGPUGen.Yaml
import WebGPUGenTest

/-!
# Test driver

Checks that need IO: parsing the vendored spec. Run from the `webgpu-gen` directory.
-/

open WebGPUGen.Yaml

def specPath : System.FilePath := "../vendor/webgpu-headers/webgpu.yml"

/-- The top-level keys of `webgpu.yml`, in order. If upstream adds or renames a
section, this fails, and the spec reader must be updated to match. -/
def expectedKeys : List String :=
  ["copyright", "name", "enum_prefix", "doc", "constants", "typedefs", "enums",
   "bitflags", "structs", "callbacks", "functions", "objects"]

def check (ok : Bool) (what : String) : IO Unit :=
  unless ok do throw (IO.userError s!"FAIL: {what}")

def main : IO Unit := do
  let .map entries ← parseFile specPath
    | throw (IO.userError "FAIL: spec is not a mapping")
  let keys := entries.toList.map (·.1)
  check (keys == expectedKeys) s!"top-level keys are {keys}"
  check ((entries.find? (·.1 == "name")).map (·.2) == some (yaml% "webgpu"))
    "name is webgpu"
  -- Every section that holds definitions is a sequence.
  for (key, value) in entries do
    if key ∈ ["constants", "typedefs", "enums", "bitflags", "structs",
              "callbacks", "functions", "objects"] then
      check (value matches .seq _) s!"{key} is a sequence"
  IO.println s!"ok: parsed {specPath} ({entries.size} top-level keys)"
