import WebGPU.Raw
import WebGPURawTest.Internal.Callback

/-!
# Tests of a device

A device requested of an adapter, with its own callbacks: the uncaptured-error
callback given each error a call on the device makes, and both kept by the
device's family until the device and every object made from it are gone,
when their closures are released (`c/family.c`). These need an adapter, which
a machine with no GPU may have none of (CI's runners each have one, if only
in software): then they check nothing. They run natively; in a browser, the
web self-test runs its own (`WebGPURawWebTest/Device.lean`).
-/

namespace WebGPURawTest.Internal.Device
open WebGPU.Raw
open WebGPURawTest.Internal.Callback
  (token touch tokensReleased problemUnless errorOf)

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

/--
A buffer descriptor WebGPU refuses, a validation error: mapped both to read
and to write. (Not one mapped at creation of a size not a multiple of 4,
which wgpu-native refuses so, but a browser by an exception in the call.)
-/
def badBuffer : BufferDescriptor := {
  label := "bad"
  usage := .mapRead ||| .mapWrite
  size  := 4
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

/--
An error a device's uncaptured-error closure raises is the error of the call
that made it, as every call is bracketed (wgpu-native calls it in that call).
-/
def raised (wgpu : Instance) (adapter : Adapter) : IO String := do
  let device ← device? wgpu adapter (some {
    uncapturedErrorCallbackInfo := some {
      callback := fun _ message => throw (IO.userError s!"refused: {message}")
    }
  })
  match device with
  | .error e => pure e
  | .ok device =>
    let e ← errorOf (device.createBuffer badBuffer)
    pure (problemUnless (e.startsWith "refused: ") s!"raised {repr e}")

/--
A device with no uncaptured-error callback has the bindings' own handler: the
call that made an error raises it, where wgpu-native's would end the program.
-/
def defaulted (wgpu : Instance) (adapter : Adapter) : IO String := do
  match ← device? wgpu adapter none with
  | .error e => pure e
  | .ok device =>
    let e ← errorOf (device.createBuffer badBuffer)
    pure (problemUnless (e.startsWith "WebGPU validation error: ")
      s!"raised {repr e}")

/--
Run `wgpu`'s events until `done` holds, at most `tries` times, a millisecond
apart: whether it did. What waits on no work, wgpu-native completes in the
call or the next `processEvents`; what waits on submitted work, once the GPU
is done with it, which `processEvents` does not wait for (a blocking poll,
`wgpuDevicePoll`, is not bound).
-/
def pumpUntil (wgpu : Instance) (done : IO Bool) (tries : Nat := 5000) :
    IO Bool := do
  for _ in [0:tries] do
    if ← done then return true
    wgpu.processEvents
    if ← done then return true
    IO.sleep 1
  done

/-- A buffer of 4 bytes of `device`, to map for reading. -/
def readable (device : Device) : IO (Option Buffer) :=
  device.createBuffer { size := 4, usage := .mapRead ||| .copyDst }

/-- A buffer maps, its callback called once, a success, by `processEvents`. -/
def mapped (wgpu : Instance) (adapter : Adapter) : IO String := do
  match ← device? wgpu adapter none with
  | .error e => pure e
  | .ok device =>
    let some buffer ← readable device | pure "no buffer"
    let calls ← IO.mkRef #[]
    let _ ← buffer.mapAsync .read 0 4 .allowProcessEvents fun status _ =>
      calls.modify (·.push (status matches .ok .success))
    let done ← pumpUntil wgpu (return !(← calls.get).isEmpty)
    let got ← calls.get
    pure (problemUnless (done && got == #[true]) s!"called back {got}")

/--
An error a buffer's map callback raises is the error of the call that ran it:
`mapAsync` itself, as wgpu-native completes a map with nothing pending on
the buffer in the call, or the `processEvents` that does. Never the end of
the program, as every call is bracketed. (Of a map that succeeds: a failed
one raises another error.)
-/
def mapRaised (wgpu : Instance) (adapter : Adapter) : IO String := do
  match ← device? wgpu adapter none with
  | .error e => pure e
  | .ok device =>
    let some buffer ← readable device | pure "no buffer"
    let e ← errorOf do
      let _ ← buffer.mapAsync .read 0 4 .allowProcessEvents fun status m =>
        throw (IO.userError (if status matches .ok .success then "map refused"
          else s!"map failed: {m}"))
      let _ ← pumpUntil wgpu (return false) (tries := 100)
    pure (problemUnless (e == "map refused") s!"raised {repr e}")

/-- A queue calls back, once, a success, when its work is done. -/
def workDone (wgpu : Instance) (adapter : Adapter) : IO String := do
  match ← device? wgpu adapter none with
  | .error e => pure e
  | .ok device =>
    let calls ← IO.mkRef #[]
    let _ ← (← device.getQueue).onSubmittedWorkDone .allowProcessEvents
      fun status _ => calls.modify (·.push (status matches .ok .success))
    let done ← pumpUntil wgpu (return !(← calls.get).isEmpty)
    let got ← calls.get
    pure (problemUnless (done && got == #[true]) s!"called back {got}")

/--
An error scope catches a validation error, which its pop gives its callback,
and which the uncaptured-error callback then is not given.
-/
def inScope (wgpu : Instance) (adapter : Adapter) : IO String := do
  let uncaptured ← IO.mkRef 0
  let device ← device? wgpu adapter (some {
    uncapturedErrorCallbackInfo := some {
      callback := fun _ _ => uncaptured.modify (· + 1)
    }
  })
  match device with
  | .error e => pure e
  | .ok device =>
    device.pushErrorScope .validation
    let _ ← device.createBuffer badBuffer
    let popped ← IO.mkRef #[]
    let _ ← device.popErrorScope .allowProcessEvents fun status type _ =>
      popped.modify (·.push
        (status matches .ok .success, type matches .ok .validation))
    let done ← pumpUntil wgpu (return !(← popped.get).isEmpty)
    let got ← popped.get
    let missed ← uncaptured.get
    pure (problemUnless (done && got == #[(true, true)] && missed == 0)
      s!"popped {got}; uncaptured {missed}")

/-! ### Arrays passed to C -/

/-- A command buffer of `device`, recording nothing. -/
def emptyCommands (device : Device) : IO CommandBuffer := do
  (← device.createCommandEncoder none).finish none

/--
A queue runs the command buffers submitted to it, and calls back when it is
done; and none at all may be submitted. (Not one submitted twice: wgpu-native
ends the program on any error in a submission, `docs/Safety.md`.)
-/
def submitted (wgpu : Instance) (adapter : Adapter) : IO String := do
  match ← device? wgpu adapter none with
  | .error e => pure e
  | .ok device =>
    -- Held to the end: releasing a device's last reference destroys it, so
    -- the work never completes, though its queue lives.
    let held ← IO.mkRef (some device)
    let queue ← device.getQueue
    queue.submit #[← emptyCommands device, ← emptyCommands device]
    let calls ← IO.mkRef #[]
    let _ ← queue.onSubmittedWorkDone .allowProcessEvents fun status _ =>
      calls.modify (·.push (status matches .ok .success))
    let done ← pumpUntil wgpu (return !(← calls.get).isEmpty)
    let nothing ← errorOf (queue.submit #[])
    held.set none
    let got ← calls.get
    pure (problemUnless (done && got == #[true] && nothing.isEmpty)
      s!"called back {got}; nothing {repr nothing}")

/--
A compute pass's dynamic offsets reach C, each: a bind group of two uniform
buffers, each with a dynamic offset, takes two offsets, multiples of 256;
one, or a second of 4, is a validation error.
-/
def dynamicOffsets (wgpu : Instance) (adapter : Adapter) : IO String := do
  match ← device? wgpu adapter none with
  | .error e => pure e
  | .ok device =>
    let some buffer ← device.createBuffer { size := 512, usage := .uniform }
      | pure "no buffer"
    let entry (binding : UInt32) : BindGroupLayoutEntry := {
      binding    := binding
      visibility := .compute
      buffer     := { type := .uniform, hasDynamicOffset := true }
    }
    let layout ← device.createBindGroupLayout {
      entries := #[entry 0, entry 1]
    }
    let group ← device.createBindGroup {
      layout  := layout
      entries := #[0, 1].map fun binding =>
        { binding := binding, buffer := some buffer, size := 256 }
    }
    let run (offsets : Array UInt32) : IO Unit := do
      let encoder ← device.createCommandEncoder none
      let pass ← encoder.beginComputePass none
      pass.setBindGroup 0 (some group) offsets
      pass.«end»
      let _ ← encoder.finish none
    let aligned ← errorOf (run #[256, 0])
    let missing ← errorOf (run #[256])
    let misaligned ← errorOf (run #[256, 4])
    let refused (e : String) := e.startsWith "WebGPU validation error: "
    pure (problemUnless
      (aligned.isEmpty && refused missing && refused misaligned)
      s!"{repr aligned}; {repr missing}; {repr misaligned}")

/--
A render pass is given the bundles it executes, each: those of its
attachment's format are accepted; with one of another after them, the pass
is refused, a validation error, when its encoder is finished.
-/
def bundles (wgpu : Instance) (adapter : Adapter) : IO String := do
  match ← device? wgpu adapter none with
  | .error e => pure e
  | .ok device =>
    let texture ← device.createTexture {
      usage  := .renderAttachment
      size   := { width := 4, height := 4 }
      format := .rgba8Unorm
    }
    let view ← texture.createView none
    let bundleOf (format : TextureFormat) : IO RenderBundle := do
      let encoder ← device.createRenderBundleEncoder {
        colorFormats := #[format]
      }
      encoder.finish none
    let run (bundles : Array RenderBundle) : IO Unit := do
      let encoder ← device.createCommandEncoder none
      let pass ← encoder.beginRenderPass { colorAttachments := #[{
        view    := some view
        loadOp  := .clear
        storeOp := .store
      }] }
      pass.executeBundles bundles
      pass.«end»
      let _ ← encoder.finish none
    let same ← errorOf (run #[← bundleOf .rgba8Unorm])
    let other ←
      errorOf (run #[← bundleOf .rgba8Unorm, ← bundleOf .bgra8Unorm])
    pure (problemUnless
      (same.isEmpty && other.startsWith "WebGPU validation error: ")
      s!"{repr same}; {repr other}")

/--
A device's lost future, which wgpu-native leaves unimplemented: an IO error,
not an abort.
-/
def lostFuture (wgpu : Instance) (adapter : Adapter) : IO String := do
  match ← device? wgpu adapter none with
  | .error e => pure e
  | .ok device =>
    let e ← errorOf device.getLostFuture
    pure (problemUnless
      (e == "Device.getLostFuture: not implemented by wgpu-native")
      s!"raised {repr e}")

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
    ("a device requested with no descriptor", noDescriptor wgpu adapter),
    ("an error its uncaptured-error closure raises, the call's",
      raised wgpu adapter),
    ("with no such closure, the bindings' own handler raising it",
      defaulted wgpu adapter),
    ("a buffer mapped, by processEvents", mapped wgpu adapter),
    ("an error a map callback raises, the error of the call that ran it",
      mapRaised wgpu adapter),
    ("a queue's work done, by processEvents", workDone wgpu adapter),
    ("an error scope catching a validation error", inScope wgpu adapter),
    ("a device's lost future, unimplemented, an IO error",
      lostFuture wgpu adapter),
    ("command buffers submitted, each", submitted wgpu adapter),
    ("a compute pass's dynamic offsets, each", dynamicOffsets wgpu adapter),
    ("a render pass's bundles, each", bundles wgpu adapter)
  ]
  some <$> named.mapM fun (what, check) => do pure (what, ← check)

end WebGPURawTest.Internal.Device
