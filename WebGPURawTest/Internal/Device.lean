import WebGPU.Raw
import WebGPURawTest.Internal.Callback

/-!
# Tests of a device

A device requested of an adapter, with its own callbacks: the uncaptured-error
callback given each error a call on the device makes, and both kept by the
device's family until the device and every object made from it are gone,
when their closures are released (`c/family.c`). These need an adapter, which
a machine with no GPU has none of (as CI's runners, but for a software one):
then each says so, and checks nothing. They run natively; in a browser, the
web self-test requests its own.
-/

namespace WebGPURawTest.Internal.Device
open WebGPU.Raw
open WebGPURawTest.Internal.Callback (token touch tokensReleased problemUnless)

/-- An adapter of `wgpu`, if it has one, waiting for it by `processEvents`. -/
def adapter? (wgpu : Instance) : IO (Option Adapter) := do
  let found ← IO.mkRef none
  let _ ← wgpu.requestAdapter none .allowProcessEvents fun _ adapter _ =>
    found.set adapter
  wgpu.processEvents
  found.get

/--
A device of `adapter`, by `descriptor`, waiting for it by `processEvents`:
none if the request fails, with its message.
-/
def device? (wgpu : Instance) (adapter : Adapter)
    (descriptor : Option DeviceDescriptor) :
    IO (Except String Device) := do
  let found ← IO.mkRef (.error "not called back")
  let _ ← adapter.requestDevice descriptor .allowProcessEvents
    fun status device message =>
      found.set (match status, device with
        | .ok .success, some d => .ok d
        | _, _ => .error s!"no device: {message}")
  wgpu.processEvents
  found.get

/-- A buffer descriptor C refuses: mapped at creation, of 3 bytes, not 4. -/
def badBuffer : BufferDescriptor := {
  label            := "bad"
  usage            := ⟨0x8⟩
  size             := 3
  mappedAtCreation := true
}

/--
A device's uncaptured-error callback is given the error a call on it makes,
once, a validation error, during the call (as wgpu-native calls it).
-/
def uncaptured (wgpu : Instance) (adapter : Adapter) : IO String := do
  let errors ← IO.mkRef #[]
  let device ← device? wgpu adapter (some {
    uncapturedErrorCallbackInfo := some {
      callback := fun type message => errors.modify (·.push (type, message))
    }
  })
  match device with
  | .error e => pure e
  | .ok device =>
    let _ ← device.createBuffer badBuffer
    let got ← errors.get
    pure (problemUnless (got.size == 1
        && got.all fun (type, _) => type matches .ok .validation)
      s!"errors: {got.map fun (t, m) => (repr t |>.pretty, m)}")

/--
Make a device whose two callbacks hold a token, and a buffer of it; return
the buffer only, the device dropped.
-/
@[noinline]
def deviceHolding (wgpu : Instance) (adapter : Adapter) :
    IO (Except String (Option Buffer)) := do
  let t ← token
  let device ← device? wgpu adapter (some {
    deviceLostCallbackInfo := some { callback := fun _ _ => touch t }
    uncapturedErrorCallbackInfo := some { callback := fun _ _ => touch t }
  })
  match device with
  | .error e => pure (.error e)
  | .ok device =>
    pure (.ok (← device.createBuffer { size := 4, usage := ⟨0x8⟩ }))

/--
A device's callbacks are kept by its family: while any object made from it
lives, though the device itself is gone; and released, once, when the last
is gone.
-/
def family (wgpu : Instance) (adapter : Adapter) : IO String := do
  let before ← tokensReleased
  match ← deviceHolding wgpu adapter with
  | .error e => pure e
  | .ok buffer =>
    let made := buffer.isSome
    -- Held by a reference, which the compiler keeps until it is cleared; a
    -- function that ignores it would see it freed after its last use.
    let held ← IO.mkRef buffer
    let kept ← tokensReleased
    held.set none
    let after ← tokensReleased
    pure (problemUnless (made && kept == before && after == before + 1)
      s!"buffer {made}; tokens {before}, {kept}, {after}")

/-- A device requested with no descriptor, which is given one of defaults. -/
def noDescriptor (wgpu : Instance) (adapter : Adapter) : IO String := do
  match ← device? wgpu adapter none with
  | .error e => pure e
  | .ok _    => pure ""

/--
Each check: what it checks, and the problem, or "" if none; none if there is
no adapter, so none can be made.
-/
def checks (wgpu : Instance) : IO (Option (List (String × String))) := do
  let some adapter ← adapter? wgpu
    | pure none
  let named := [
    ("a device's uncaptured-error callback given its call's error",
      uncaptured wgpu adapter),
    ("a device's callbacks kept by its family till its objects are gone",
      family wgpu adapter),
    ("a device requested with no descriptor", noDescriptor wgpu adapter)
  ]
  some <$> named.mapM fun (what, check) => do pure (what, ← check)

end WebGPURawTest.Internal.Device
