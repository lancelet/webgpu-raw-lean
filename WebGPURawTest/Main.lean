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
open WebGPURawTest.Internal.Callback (defer raising runOutside)

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

/--
Run a callback that raises an error outside every call: the program ends,
printing it, as an error `main` raises does. Run by `main` as a process of its
own.
-/
def spontaneousError : IO Unit := do
  defer (raising "spontaneous") 0 .empty
  runOutside
  IO.println "FAIL: the program went on"

/--
Join a handle to a family when it is a member of another: the program stops,
as over-releasing the first would free its closures while it is in use. Run by
`main` as a process of its own.
-/
def joinTwice : IO Unit := do
  let f ← WebGPURawTest.Internal.Family.new
  let g ← WebGPURawTest.Internal.Family.new
  WebGPURawTest.Internal.Family.join 0x6000 f
  WebGPURawTest.Internal.Family.join 0x6000 g
  IO.println "FAIL: the program went on"

/-- Check that `joinTwice` stops its process, saying why. -/
def checkJoinTwice : IO Unit := do
  let out ← IO.Process.output {
    cmd  := (← IO.appPath).toString
    args := #["join-twice"]
  }
  let said := (out.stderr.splitOn "of another family").length > 1
  unless out.exitCode != 0 && said && out.stdout.isEmpty do
    throw (IO.userError s!"FAIL: a handle joined to two families: \
      exit {out.exitCode}, {repr out.stderr}, {repr out.stdout}")

/-- Check that `spontaneousError` ends its process, printing the error. -/
def checkSpontaneousError : IO Unit := do
  let out ← IO.Process.output {
    cmd  := (← IO.appPath).toString
    args := #["spontaneous-error"]
  }
  -- Whether the error was printed: its message is in what the process wrote.
  let printed := (out.stderr.splitOn "spontaneous").length > 1
  unless out.exitCode == 1 && printed && out.stdout.isEmpty do
    throw (IO.userError s!"FAIL: a callback's error outside every call: \
      exit {out.exitCode}, {repr out.stderr}, {repr out.stdout}")

def main (args : List String) : IO Unit := do
  if args == ["spontaneous-error"] then
    return ← spontaneousError
  if args == ["join-twice"] then
    return ← joinTwice
  -- Lean closures run as callbacks: once, released, their errors raised.
  for (what, problem) in ← WebGPURawTest.Internal.Callback.checks do
    unless problem.isEmpty do
      throw (IO.userError s!"FAIL: callbacks: {what}: {problem}")
  checkSpontaneousError
  -- The families that keep a device's callbacks.
  for (what, problem) in ← WebGPURawTest.Internal.Family.checks do
    unless problem.isEmpty do
      throw (IO.userError s!"FAIL: families: {what}: {problem}")
  checkJoinTwice
  let wgpu ← createInstance none
  -- And WebGPU's: `requestAdapter`, through its shim and trampoline.
  for (what, problem) in ← WebGPURawTest.Internal.Callback.webgpuChecks wgpu do
    unless problem.isEmpty do
      throw (IO.userError s!"FAIL: callbacks: {what}: {problem}")
  -- And a device, if there is an adapter, its callbacks kept by its family.
  match ← WebGPURawTest.Internal.Device.checks wgpu with
  | none =>
    -- Where one is required (in CI, whose runners all have one), a failure.
    if (← IO.getEnv "WEBGPU_RAW_REQUIRE_ADAPTER").isSome then
      throw (IO.userError "FAIL: no adapter, though one is required")
    IO.println "note: no adapter here, so no device checked"
  | some checks =>
    for (what, problem) in checks do
      unless problem.isEmpty do
        throw (IO.userError s!"FAIL: device: {what}: {problem}")
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
  -- And `waitAny`, whose shim is written by hand.
  expectNotImplemented "Instance.waitAny" (wgpu.waitAny #[])
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
