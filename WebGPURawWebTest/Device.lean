import WebGPU.Raw
import WebGPURawTest.Internal.Callback
import WebGPURawTest.Internal.Device

/-!
# A device, in a browser

The device checks a browser runs, where WebGPU calls each callback from its
event loop, after the call that registered it has returned: so each step goes
on in the callback of the step before (as `main` goes on in `requestAdapter`'s),
and the last gives every check's line to `finish`, which ends the program.

The steps: a device is requested, with both its callbacks; a call on it makes
a validation error, which its uncaptured-error callback is given; that
destroys it, so that its device-lost callback is called; and a later turn of
the event loop checks it was called once, and that the device's family kept
both closures until the device was dropped.
-/

namespace WebGPURawWebTest.Device
open WebGPU.Raw
open WebGPURawTest.Internal.Callback (token touch tokensReleased problemUnless)
open WebGPURawTest.Internal.Device (badBuffer)

/-- What the device's callbacks were given, in order. -/
structure Seen where
  /-- Each uncaptured error: whether a validation error, and its message. -/
  errors : Array (Bool × String) := #[]
  /-- Each loss: whether by `destroy`, and its message. -/
  losses : Array (Bool × String) := #[]

/-- A check's line, as the self-test prints it. -/
def line (what problem : String) : String :=
  if problem.isEmpty then s!"ok   {what}" else s!"FAIL {what}: {problem}"

/--
`step`, but an error it raises ends the checks, a failure: raised by a
callback the event loop runs, it would end the program, unreported.
-/
def guarded (finish : List String → IO Unit) (step : IO Unit) : IO Unit :=
  try step catch e => finish [line "the device checks" (toString e)]

/--
The checks, once the device is lost and a later turn of the event loop has
come: its error given its callback once, it lost once, by `destroy`; and the
closures, which hold a token, kept until `device`, the last reference to it,
is dropped (no token released since `start`), then released.
-/
def results (start : UInt32) (seen : IO.Ref Seen)
    (device : IO.Ref (Option Device)) : IO (List String) := do
  let s ← seen.get
  let kept ← tokensReleased
  device.set none
  let after ← tokensReleased
  pure [
    line "a device's uncaptured error, given its callback by the event loop"
      (problemUnless (s.errors.size == 1 && s.errors.all (·.1))
        s!"errors {s.errors}"),
    line "a device destroyed, lost once"
      (problemUnless (s.losses.size == 1 && s.losses.all (·.1))
        s!"losses {s.losses}"),
    line "its callbacks kept by its family till it is gone, then released"
      (problemUnless (kept == start && after == start + 1)
        s!"tokens {start}, {kept}, {after}")
  ]

/--
Keep the program alive, if `hold`, else stop: no request is pending while it
waits for the device's own callbacks, which keep nothing alive.
-/
@[extern "lean_wgpu_test_keep_alive"]
opaque keepAlive (hold : Bool) : IO Unit

/--
Run the steps, on a device of `adapter`, the program kept alive till the last;
`report` is given the lines.
-/
def run (wgpu : Instance) (adapter : Adapter)
    (report : List String → IO Unit) : IO Unit := do
  keepAlive true
  let finish lines := do keepAlive false; report lines
  guarded finish do
    let seen ← IO.mkRef ({} : Seen)
    -- The device, once made: the callbacks, made before it, reach it here.
    let device ← IO.mkRef (none : Option Device)
    -- Whether the queue's work is done: until then, its request keeps the
    -- device's family, and so its closures.
    let workDone ← IO.mkRef false
    let t ← token
    let start ← tokensReleased
    -- The checks, from a later turn of the event loop (another adapter's
    -- request calls back after every callback already due), once the device
    -- is lost and the queue's work done, in either order: so only one of
    -- their callbacks finds both, and goes on.
    let proceed : IO Unit := do
      if (← seen.get).losses.size == 1 && (← workDone.get) then
        let _ ← wgpu.requestAdapter none .allowSpontaneous fun _ _ _ =>
          guarded finish do finish (← results start seen device)
    let lost : DeviceLostCallback := fun reason message => guarded finish do
      touch t
      seen.modify fun s => { s with
        losses := s.losses.push (reason matches .ok .destroyed, message) }
      proceed
    let uncaptured : UncapturedErrorCallback := fun type message =>
      guarded finish do
        touch t
        seen.modify fun s => { s with
          errors := s.errors.push (type matches .ok .validation, message) }
        if (← seen.get).errors.size == 1 then
          (← device.get).forM (·.destroy)
    let _ ← adapter.requestDevice (some {
        deviceLostCallbackInfo      := some { callback := lost }
        uncapturedErrorCallbackInfo := some { callback := uncaptured }
      }) .allowSpontaneous fun status made message => guarded finish do
        match status, made with
        | .ok .success, some d =>
          device.set (some d)
          let _ ← d.createBuffer badBuffer
          -- In headless Chrome, the buffer's error reached its callback only
          -- while a request was pending (observed, not documented): so one is,
          -- the queue's work done.
          let _ ← (← d.getQueue).onSubmittedWorkDone .allowSpontaneous
            fun _ _ => do workDone.set true; proceed
        | _, _ => finish [line "a device requested" s!"none: {message}"]

end WebGPURawWebTest.Device
