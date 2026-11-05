import WebGPU.Raw
import WebGPURawTest.Internal.Bytes
import WebGPURawTest.Internal.Callback
import WebGPURawTest.Internal.Family
import WebGPURawTest.Internal.Encode
import WebGPURawTest.Internal.Reloc
import WebGPURawWebTest.Device
import WebGPURawWebTest.Canvas

/-!
# The web self-test

A program that checks Lean runs correctly as WebAssembly, then calls the
bindings. The checks are of what can go wrong silently there, rather than fail
to build: Lean does not support WebAssembly, and 32-bit targets have
miscompiled static constants before (lean4#15816), such as a name literal whose
hash differs from the same name built at run time.

Every check's inputs pass through `runtime`, which Lean cannot see through, so
that the check runs on the target rather than in the compiler. `web/build.sh`
builds it for WebAssembly, and CI runs it under Node and in a browser; GitHub
Pages publishes it.
-/

namespace WebGPURawWebTest
open WebGPU.Raw

/--
`x`, but out of the compiler's sight: it cannot compute a check from it at
compile time, so the check runs where the program does.
-/
@[noinline]
def runtime {α : Type} (x : α) : α := x

/-- Whether this page has WebGPU, from the test helper. -/
@[extern "lean_wgpu_test_has_webgpu"]
opaque hasWebGPU : Unit → Bool

/-- A name built at run time from its parts, so it is not a static constant. -/
@[noinline]
def runtimeName (parts : List String) : Lean.Name :=
  parts.foldl (fun n s => .str n s) .anonymous

/-- Each check: what it is, and whether it held. -/
def checks : List (String × Bool) :=
  let literal := `WebGPU.Raw.Device
  let built := runtimeName (runtime ["WebGPU", "Raw", "Device"])
  let big := runtime (2 : Nat) ^ 100
  [
    ("name literal equals the name built at run time", literal == built),
    ("their hashes agree", hash literal == hash built),
    ("a 32-bit platform", System.Platform.numBits == 32),
    ("USize is 32 bits", runtime (0 : USize) - 1 == 0xFFFF_FFFF),
    ("a string's length", (runtime "WebGPU in Lean").length == 14),
    ("UTF-8 sizes", (runtime "λ→").utf8ByteSize == 5),
    ("a bignum", toString big == "1267650600228229401496703205376"),
    ("bignum arithmetic", big / runtime (2 ^ 99) == 2),
    ("64-bit integers", runtime (0xFFFF_FFFF : UInt64) + 1 == 0x1_0000_0000),
    ("64-bit overflow",
      runtime (0 : UInt64) - 1 == 0xFFFF_FFFF_FFFF_FFFF),
    ("an enum's code",
      CEnum.toC (runtime TextureFormat.rgba8Unorm) == 0x00000016),
    ("an enum decoded",
      (CEnum.decode (runtime 0x00000016) : Except UInt32 TextureFormat)
        matches .ok .rgba8Unorm),
    ("an unknown code kept",
      (CEnum.decode (runtime 0x7FFF0000) : Except UInt32 TextureFormat)
        matches .error 0x7FFF0000),
    ("the NaN constant is a NaN", (runtime depthClearValueUndefined).isNaN),
    ("SIZE_MAX is the largest UInt64",
      runtime wholeMapSize == 0xFFFF_FFFF_FFFF_FFFF),
    ("the byte writers agree with their Lean definitions",
      (WebGPURawTest.Internal.Bytes.disagreements (runtime 1)).isEmpty),
    ("this target's width is 32 bits",
      WebGPU.Raw.Encode.Width.current == .bits32)
  ] ++ WebGPURawTest.Internal.Encode.checks

/--
Under Node, a request registered `CallbackMode.waitAnyOnly`: its callback run
neither in the call nor by `processEvents`, but by `waitAny` on its future,
in that call. With no WebGPU, emdawnwebgpu completes the request in the
call, unavailable, so its future is ready, and only its callback waits.
-/
def waitAnyOnly (wgpu : Instance) : IO String := do
  let calls ← IO.mkRef 0
  let future ← wgpu.requestAdapter none .waitAnyOnly fun _ _ _ =>
    calls.modify (· + 1)
  wgpu.processEvents
  let before ← calls.get
  let (status, completed) ← wgpu.waitAny #[future]
  let after ← calls.get
  pure (WebGPURawTest.Internal.Callback.problemUnless
    (before == 0 && after == 1
      && status matches .ok .success && completed == #[true])
    s!"calls {before}, {after}; {repr status |>.pretty}, {completed}")

/-- Report how many checks failed: the program's exit code. -/
def finish (failures : Nat) : IO UInt32 := do
  if failures == 0 then
    IO.println "All checks passed."
    return 0
  else
    IO.println s!"{failures} checks failed."
    return 1

end WebGPURawWebTest

/-- Run the checks, then call the bindings; print what happens. -/
def main : IO UInt32 := do
  let results := WebGPURawWebTest.checks
  for (what, ok) in results do
    IO.println s!"{if ok then "ok  " else "FAIL"} {what}"
  let failed := results.filter (!·.2)
  -- The bindings: an instance, and a method called through its shim.
  let bindings ← try
      let wgpu ← WebGPU.Raw.createInstance none
      wgpu.processEvents
      pure "ok   an instance created, and a method called on it"
    catch e => pure s!"FAIL the bindings: {e}"
  IO.println bindings
  -- And with a descriptor, a struct C fills in; but not one with a `size_t`
  -- too large for wasm32, which is refused before the call.
  let descriptor ← try
      let _ ← WebGPU.Raw.createInstance (some {
        requiredLimits := some { timedWaitAnyMaxCount := 0 }
      })
      match ← (WebGPU.Raw.createInstance (some {
        requiredLimits := some {
          timedWaitAnyMaxCount := WebGPURawWebTest.runtime 0x100000000
        }
      })).toBaseIO with
      | .ok _    => pure "FAIL a size_t too large for wasm32, not refused"
      | .error _ => pure "ok   an instance created with a descriptor, and one \
          with a size_t too large refused"
    catch e => pure s!"FAIL an instance with a descriptor: {e}"
  IO.println descriptor
  -- C fills in encoded structs' pointers as their tables say.
  let relocations ← try
      let wgpu ← WebGPU.Raw.createInstance none
      let checks := WebGPURawTest.Internal.Reloc.checks wgpu
      pure (checks.map fun (what, problem) =>
        if problem.isEmpty then s!"ok   {what}" else s!"FAIL {what}: {problem}")
    catch e => pure [s!"FAIL relocations: {e}"]
  relocations.forM IO.println
  -- Lean closures run as callbacks: once, released, their errors raised.
  let callbacks ← try
      let checks ← WebGPURawTest.Internal.Callback.checks
      pure (checks.map fun (what, problem) =>
        if problem.isEmpty then s!"ok   {what}" else s!"FAIL {what}: {problem}")
    catch e => pure [s!"FAIL callbacks: {e}"]
  callbacks.forM IO.println
  -- The families that keep a device's callbacks.
  let families ← try
      let checks ← WebGPURawTest.Internal.Family.checks
      pure (checks.map fun (what, problem) =>
        if problem.isEmpty then s!"ok   {what}" else s!"FAIL {what}: {problem}")
    catch e => pure [s!"FAIL families: {e}"]
  families.forM IO.println
  -- And WebGPU's, `requestAdapter`, where its callback runs by the next
  -- `processEvents`: under Node, which has no WebGPU. A browser runs it from
  -- its event loop, after this.
  let webgpuCallbacks ← if WebGPURawWebTest.hasWebGPU () then pure [] else
    try
      let wgpu ← WebGPU.Raw.createInstance none
      let checks ← WebGPURawTest.Internal.Callback.webgpuChecks wgpu
      let waited := ("a request's callback run only by waitAny, in it",
        ← WebGPURawWebTest.waitAnyOnly wgpu)
      pure ((checks ++ [waited]).map fun (what, problem) =>
        if problem.isEmpty then s!"ok   {what}" else s!"FAIL {what}: {problem}")
    catch e => pure [s!"FAIL WebGPU's callbacks: {e}"]
  webgpuCallbacks.forM IO.println
  -- A function and a method wgpu-native leaves unimplemented, which Dawn
  -- implements: on the web their shims call them.
  -- (The method needs WebGPU, which Node lacks: there, emdawnwebgpu throws a
  -- JavaScript error, which ends the program.)
  let dawn ← try
      let _ ← WebGPU.Raw.hasInstanceFeature .timedWaitAny
      if WebGPURawWebTest.hasWebGPU () then
        let wgpu ← WebGPU.Raw.createInstance none
        let _ ← wgpu.hasWGSLLanguageFeature .readonlyAndReadwriteStorageTextures
        pure "ok   a function and a method wgpu-native leaves unimplemented, \
          called"
      else
        pure "ok   a function wgpu-native leaves unimplemented, called (no \
          WebGPU here for the method)"
    catch e => pure s!"FAIL calling what wgpu-native does not implement: {e}"
  IO.println dawn
  let bindingsFailed :=
    (bindings :: descriptor :: dawn :: relocations ++ callbacks
      ++ families ++ webgpuCallbacks).filter
      (!·.startsWith "ok") |>.length
  let failures := failed.length + bindingsFailed
  -- In a browser, an adapter is requested, and the program goes on in its
  -- callback, which the browser runs from its event loop once `main` has
  -- returned: the program is kept alive while the request is pending, and
  -- the callbacks end it (`web/README.md`). With an adapter, a device's
  -- checks go on in callbacks too (`WebGPURawWebTest/Device.lean`).
  -- Elsewhere it ends here.
  if WebGPURawWebTest.hasWebGPU () then
    let wgpu ← WebGPU.Raw.createInstance none
    let _ ← wgpu.requestAdapter none .allowSpontaneous
      fun status adapter message => do
        let success := status matches .ok .success
        let ok := success == adapter.isSome
        IO.println (if ok then
          s!"ok   requestAdapter called back from the browser's event loop \
            (a success: {success})"
        else s!"FAIL requestAdapter called back with an adapter \
          {adapter.isSome}, a success {success}: {message}")
        let finish (lines : List String) : IO Unit := do
          lines.forM IO.println
          let more := lines.filter (·.startsWith "FAIL") |>.length
          IO.Process.exit (← WebGPURawWebTest.finish
            (failures + more + if ok then 0 else 1)).toUInt8
        match adapter with
        | some adapter =>
          WebGPURawWebTest.Device.run wgpu adapter fun lines =>
            WebGPURawWebTest.Canvas.run wgpu fun more =>
              finish (lines ++ more)
        | none => finish ["note: no adapter here, so no device checked"]
    -- The program ends with this once the callbacks return, if they do not
    -- end it: so a callback that forgets to fails.
    return 1
  else
    WebGPURawWebTest.finish failures
