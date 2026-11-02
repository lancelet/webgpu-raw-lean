import WebGPU.Raw
import WebGPURawTest

/-!
# Test driver

Building this program builds every test (`#guard` checks run as their modules
build), and the bindings with their C shims, linked against wgpu-native.
Running it calls bound functions through their shims, on an instance a test
helper creates (`WebGPURawTest/c/instance.c`): this needs no GPU.

`scripts/check-abi.sh` checks the shims' C types against Lean's own
declarations of them; this checks that calls through them run.
-/

open WebGPU.Raw

/-- A new instance, from the test helper. -/
@[extern "lean_wgpu_test_create_instance"]
opaque createInstance : IO Instance

def main : IO Unit := do
  let wgpu ← createInstance
  -- A method with no result: the object is passed borrowed, and `()` returned.
  wgpu.processEvents
  -- (Calls with enum arguments and results wait for functions wgpu-native
  -- implements: `hasInstanceFeature` and `hasWGSLLanguageFeature` abort there.)
  -- The instance's reference is released when `wgpu` is freed, at the end.
  IO.println "The WebGPU bindings called through their shims."
