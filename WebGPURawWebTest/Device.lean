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
the event loop checks it was called once, that its lost future completed
then and not before, as `waitAny` finds, and that the device's family kept
both closures until the device was dropped. Last, a request registered
`waitAnyOnly` has its callback run by `waitAny`, in a later turn.
-/

namespace WebGPURawWebTest.Device
open WebGPU.Raw
open WebGPURawTest.Internal.Callback
  (token touch tokensReleased problemUnless errorOf)
open WebGPURawTest.Internal.Device (badBuffer)

/-- What the device's callbacks were given, in order. -/
structure Seen where
  /-- Each uncaptured error: whether a validation error, and its message. -/
  errors : Array (Bool × String) := #[]
  /-- Each loss: whether by `destroy`, and its message. -/
  losses : Array (Bool × String) := #[]

/-- What `waitAny` found: its status, and of each future whether completed. -/
abbrev Waited := Except UInt32 WaitStatus × Array Bool

/-- What `waitAny` found, to print. -/
def Waited.show (w : Waited) : String :=
  s!"{repr w.1 |>.pretty}, {w.2}"

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
come: its error given its callback once, it lost once, by `destroy`; its
lost future completed, as `waitAny` finds, but not while it lived (`alive`,
what `waitAny` found then: it finds a future it does not know completed, so
only both tell); and the closures, which hold a token, kept until `device`,
the last reference to it, is dropped (no token released since `start`), then
released.
-/
def results (wgpu : Instance) (start : UInt32) (seen : IO.Ref Seen)
    (alive : IO.Ref (Option Waited)) (device : IO.Ref (Option Device)) :
    IO (List String) := do
  let s ← seen.get
  let early ← alive.get
  let waited ← (← device.get).mapM fun d => do
    wgpu.waitAny #[← d.getLostFuture]
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
    line "its lost future completed once lost, as waitAny finds"
      (problemUnless (early matches some (.ok .timedOut, #[false])
          && waited matches some (.ok .success, #[true]))
        s!"waited {early.map Waited.show}, then {waited.map Waited.show}"),
    line "its callbacks kept by its family till it is gone, then released"
      (problemUnless (kept == start && after == start + 1)
        s!"tokens {start}, {kept}, {after}")
  ]

/--
A request registered `CallbackMode.waitAnyOnly`: its callback run not by the
event loop, but by a `waitAny` on its future once the request is done (from a
later turn), in that call. Then `finish`, with `lines` and its own.
-/
def waitOnly (wgpu : Instance) (finish : List String → IO Unit)
    (lines : List String) : IO Unit := do
  let calls ← IO.mkRef 0
  let future ← wgpu.requestAdapter none .waitAnyOnly fun _ _ _ =>
    calls.modify (· + 1)
  let _ ← wgpu.requestAdapter none .allowSpontaneous fun _ _ _ =>
    guarded finish do
      let before ← calls.get
      let (status, completed) ← wgpu.waitAny #[future]
      let after ← calls.get
      finish (lines ++ [
        line "a request's callback run only by waitAny, in it"
          (problemUnless (before == 0 && after == 1
              && status matches .ok .success && completed == #[true])
            s!"calls {before}, {after}; {repr status |>.pretty}, \
              {completed}")
      ])

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
    -- What `waitAny` finds of the device's lost future while it lives.
    let alive ← IO.mkRef none
    -- The lines of checks made along the way, for the end.
    let along ← IO.mkRef ([] : List String)
    let t ← token
    let start ← tokensReleased
    -- The checks, from a later turn of the event loop (another adapter's
    -- request calls back after every callback already due), once the device
    -- is lost and the queue's work done, in either order: so only one of
    -- their callbacks finds both, and goes on.
    let proceed : IO Unit := do
      if (← seen.get).losses.size == 1 && (← workDone.get) then
        let _ ← wgpu.requestAdapter none .allowSpontaneous fun _ _ _ =>
          guarded finish do
            waitOnly wgpu finish
              ((← results wgpu start seen alive device) ++ (← along.get))
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
        -- Spontaneous, as the checks assume: `waitAny` would run it otherwise.
        deviceLostCallbackInfo      := some {
          mode     := .allowSpontaneous
          callback := lost
        }
        uncapturedErrorCallbackInfo := some { callback := uncaptured }
      }) .allowSpontaneous fun status made message => guarded finish do
        match status, made with
        | .ok .success, some d =>
          device.set (some d)
          alive.set (some (← wgpu.waitAny #[← d.getLostFuture]))
          -- `setImmediates`, which Dawn lacks: the shim's error.
          let e ← errorOf do
            let pass ← (← d.createCommandEncoder none).beginComputePass none
            pass.setImmediates 0 (ByteArray.mk #[0, 0, 0, 0])
          along.modify (· ++ [line "setImmediates, which Dawn lacks, refused"
            (problemUnless (e.endsWith "not implemented by dawn")
              s!"raised {repr e}")])
          let _ ← d.createBuffer badBuffer
          -- In headless Chrome, the buffer's error reached its callback only
          -- while a request was pending (observed, not documented): so one is,
          -- the queue's work done; the work, an empty command buffer, whose
          -- handle C passes in an array, a 4-byte pointer on wasm32 (were it
          -- not passed, an error would be one more given its callback).
          let queue ← d.getQueue
          queue.submit #[← (← d.createCommandEncoder none).finish none]
          let _ ← queue.onSubmittedWorkDone .allowSpontaneous
            fun _ _ => do workDone.set true; proceed
        | _, _ => finish [line "a device requested" s!"none: {message}"]

end WebGPURawWebTest.Device
