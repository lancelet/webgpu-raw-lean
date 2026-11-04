import WebGPU.Raw
import WebGPURawTest

/-!
# Test driver

Building this program builds every test (`#guard` checks run as their modules
build), and the bindings with their C shims, linked against wgpu-native.
Running it calls bound functions through their shims, on an instance the
bindings create (`createInstance`, with no descriptor and with one): this needs
no GPU.

`scripts/check-abi.sh` checks the shims' C types against Lean's own
declarations of them; this checks that calls through them run.
-/

open WebGPU.Raw

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
  let wgpu ← createInstance none
  -- And with a descriptor: a struct C fills in, its limits a struct of its
  -- own, by their tables. (wgpu-native aborts on a timed `waitAny` feature or
  -- limit it does not support, so these ask for none.)
  for (what, descriptor) in [
    ("an empty descriptor", ({} : InstanceDescriptor)),
    ("a descriptor with limits", {
      requiredLimits := some { timedWaitAnyMaxCount := 0 }
    })
  ] do
    match ← (createInstance (some descriptor)).toBaseIO with
    | .ok other => other.processEvents
    | .error e =>
      throw (IO.userError s!"FAIL: createInstance with {what}: {e}")
  -- And a descriptor written here, a constant: its bytes must still be fresh,
  -- not computed once and shared, as C writes into them. (A regression test:
  -- the checked build found them shared.)
  let other ← createInstance (some {
    requiredLimits := some { timedWaitAnyMaxCount := 0 }
  })
  other.processEvents
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
  -- This target is 64-bit, as the encoders' choice of width assumes.
  unless WebGPU.Raw.Encode.Width.current == .bits64 do
    throw (IO.userError "FAIL: this target's width is not 64 bits")
  -- The straight-line encoders give the bytes C holds, as `encode` says.
  for (what, ok) in WebGPURawTest.Internal.Encode.checks do
    unless ok do
      throw (IO.userError s!"FAIL: encoding: {what}")
  -- C fills in encoded structs' pointers as their tables say.
  for (what, problem) in WebGPURawTest.Internal.Reloc.checks wgpu do
    unless problem.isEmpty do
      throw (IO.userError s!"FAIL: relocations: {what}: {problem}")
  -- The instance's reference is released when `wgpu` is freed, at the end.
  IO.println "The WebGPU bindings called through their shims."
