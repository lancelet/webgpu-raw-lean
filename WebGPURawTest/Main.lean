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

/--
Check that calling `action`, the Lean function `name`, raises the IO error for
a function wgpu-native leaves unimplemented.
-/
def expectNotImplemented {α : Type} (name : String) (action : IO α) :
    IO Unit := do
  match ← action.toBaseIO with
  | .ok _ => throw (IO.userError s!"FAIL: {name} returned")
  | .error e =>
    let expected := s!"{name}: not implemented by wgpu-native"
    unless toString e == expected do
      throw (IO.userError s!"FAIL: {name} raised {e}, not {expected}")

def main : IO Unit := do
  let wgpu ← createInstance
  -- A method with no result: the object is passed borrowed, and `()` returned.
  wgpu.processEvents
  -- A function wgpu-native leaves unimplemented is an IO error, not an abort,
  -- for a function and for a method. (A regression test: calling one through
  -- its shim aborted the program.)
  expectNotImplemented "hasInstanceFeature"
    (hasInstanceFeature .timedWaitAny)
  expectNotImplemented "Instance.hasWGSLLanguageFeature"
    (wgpu.hasWGSLLanguageFeature .readonlyAndReadwriteStorageTextures)
  -- The byte writers' C fast paths agree with their Lean definitions.
  let wrong := WebGPURawTest.Internal.Bytes.disagreements 1
  unless wrong.isEmpty do
    throw (IO.userError s!"FAIL: byte writers: {wrong.take 5}")
  -- The instance's reference is released when `wgpu` is freed, at the end.
  IO.println "The WebGPU bindings called through their shims."
