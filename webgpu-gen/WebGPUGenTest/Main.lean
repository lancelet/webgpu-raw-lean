import WebGPUGen.Yaml
import WebGPUGen.Spec.Codec
import WebGPUGen.Spec.Dump
import WebGPUGenTest

/-!
# Test driver

Reads the vendored spec, decodes it, checks that it re-encodes to the same spec,
and prints a dump of the result. A decoding failure stops with its path.

Run with `lake test` (or `lake test -- --docs`) inside `webgpu-gen`; the built
executable `webgpu-gen/.lake/build/bin/webgpu-gen-test` also works from anywhere.
-/

open WebGPUGen.Yaml WebGPUGen.Spec

/-- The vendored spec, found from this executable's location
(`webgpu-gen/.lake/build/bin/`), so the driver works from any directory. -/
def specPath : IO System.FilePath := do
  let bin := (← IO.appPath).parent.getD "."
  let package := ((bin.parent.bind (·.parent)).bind (·.parent)).getD "."
  return package / ".." / "vendor" / "webgpu-headers" / "webgpu.yml"

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
