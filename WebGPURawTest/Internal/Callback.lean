/-!
# Tests for callbacks

Lean closures run as callbacks through the callback runtime (`c/callback.c`),
by a fake library (`WebGPURawTest/c/fake_library.c`) that runs them as WebGPU
does: during the call that takes them, as wgpu-native's `requestAdapter`
does; later, in a pump, as `processEvents` runs `mapAsync`'s; outside every
call, as the browser's event loop runs a spontaneous one; and in a finalizer,
as releasing an instance runs its waiting callbacks, cancelled. Each callback
runs once, and its closure is released; an error it raises is the error of
the call that ran it, the first if more than one; and a message C passes is
copied as valid UTF-8. These run natively and on the web. That an error
raised outside every call ends the program is checked by the test driver,
natively, in a process of its own.
-/

namespace WebGPURawTest.Internal.Callback

/-! ## The fake library -/

/-- The type of handles behind `Token`. -/
opaque TokenHandle : NonemptyType

/-- A token, whose release C counts. -/
def Token : Type := NonemptyType.type TokenHandle

instance : Nonempty Token := Subtype.property TokenHandle

/-- A new token. -/
@[extern "lean_wgpu_test_token"]
opaque token : IO Token

/-- Use a token, so that a closure using it holds it. -/
@[extern "lean_wgpu_test_touch"]
opaque touch (t : @& Token) : IO Unit

/-- How many tokens have been released. -/
@[extern "lean_wgpu_test_tokens_released_count"]
opaque tokensReleased : IO UInt32

/-- A callback of the fake library: given a code and a message. -/
abbrev Callback := UInt32 → String → IO Unit

/--
Run `f` before returning, given `code` and `message`, passed by `form`: 0,
with its length; 1, NUL-terminated; 2, as the null view.
-/
@[extern "lean_wgpu_test_call_now"]
opaque callNow (f : @& Callback) (code : UInt32) (message : @& ByteArray)
  (form : UInt8) : IO Unit

/-- Run `f` in the next pump, given `code` and `message`. -/
@[extern "lean_wgpu_test_defer"]
opaque defer (f : @& Callback) (code : UInt32) (message : @& ByteArray) :
  IO Unit

/-- Run the callbacks waiting: how many. -/
@[extern "lean_wgpu_test_pump"]
opaque pump : IO UInt32

/-- Run the callbacks waiting outside every call. -/
@[extern "lean_wgpu_test_run_outside"]
opaque runOutside : IO Unit

/-- The type of handles behind `Cancelling`. -/
opaque CancellingHandle : NonemptyType

/-- An object whose finalizer runs a callback, cancelled: code 2. -/
def Cancelling : Type := NonemptyType.type CancellingHandle

instance : Nonempty Cancelling := Subtype.property CancellingHandle

/-- An object whose finalizer runs `f`. -/
@[extern "lean_wgpu_test_cancelling"]
opaque cancelling (f : @& Callback) : IO Cancelling

/-! ## Checks -/

/-- A callback that records each call, its code and message, in `calls`. -/
def recording (calls : IO.Ref (Array (UInt32 × String))) : Callback :=
  fun code message => calls.modify (·.push (code, message))

/-- A callback that raises `message`. -/
def raising (message : String) : Callback :=
  fun _ _ => throw (IO.userError message)

/-- The error `action` raises, or "" if none. -/
def errorOf {α : Type} (action : IO α) : IO String := do
  match ← action.toBaseIO with
  | .ok _    => pure ""
  | .error e => pure (toString e)

/-- "" if `ok`, else `problem`. -/
def problemUnless (ok : Bool) (problem : String) : String :=
  if ok then "" else problem

/-- A callback run during its call runs once, given its code and message. -/
def calledDuring : IO String := do
  let calls ← IO.mkRef #[]
  callNow (recording calls) 7 "found".toUTF8 0
  let got ← calls.get
  pure (problemUnless (got == #[(7, "found")]) s!"called with {got}")

/-- An error a callback raises during its call is the call's. -/
def raisedDuring : IO String := do
  let e ← errorOf (callNow (raising "no adapter") 1 .empty 0)
  pure (problemUnless (e == "no adapter") s!"the call raised {repr e}")

/--
A message is copied as valid UTF-8, each invalid byte U+FFFD; one C passes
NUL-terminated ends at the NUL; and the null view is "".
-/
def messages : IO String := do
  let calls ← IO.mkRef #[]
  callNow (recording calls) 0 ⟨#[0x61, 0xFF, 0x62]⟩ 0
  callNow (recording calls) 0 "abc\x00def".toUTF8 1
  callNow (recording calls) 0 "unread".toUTF8 2
  let got ← calls.get
  pure (problemUnless (got == #[(0, "a\uFFFDb"), (0, "abc"), (0, "")])
    s!"copied {got}")

/-- Callbacks deferred run in the next pump, each once, in order. -/
def deferred : IO String := do
  let calls ← IO.mkRef #[]
  defer (recording calls) 1 "one".toUTF8
  defer (recording calls) 2 "two".toUTF8
  let early ← calls.get
  let first ← pump
  let second ← pump
  let got ← calls.get
  pure (problemUnless (early.isEmpty && first == 2 && second == 0
    && got == #[(1, "one"), (2, "two")])
    s!"ran {first} then {second}, called with {got}")

/-- The first error of a pump's callbacks is the pump's; the rest still run. -/
def firstError : IO String := do
  let runs ← IO.mkRef 0
  let counting (f : Callback) : Callback := fun c m => do
    runs.modify (· + 1)
    f c m
  defer (counting fun _ _ => pure ()) 0 .empty
  defer (counting (raising "first")) 0 .empty
  defer (counting (raising "second")) 0 .empty
  defer (counting fun _ _ => pure ()) 0 .empty
  let e ← errorOf pump
  let ran ← runs.get
  pure (problemUnless (e == "first" && ran == 4) s!"raised {repr e}, ran {ran}")

/--
A pump inside a callback raises its own callbacks' errors, not those of the
pump running it, which raises its own.
-/
def nested : IO String := do
  let inner ← IO.mkRef ""
  defer (raising "outer") 0 .empty
  defer (fun _ _ => do
    defer (raising "inner") 0 .empty
    inner.set (← errorOf pump)) 0 .empty
  let outer ← errorOf pump
  let inner ← inner.get
  pure (problemUnless (outer == "outer" && inner == "inner")
    s!"the outer pump raised {repr outer}, the inner {repr inner}")

/-- Defer a callback that holds a new token. -/
@[noinline]
def deferHolding : IO Unit := do
  let t ← token
  defer (fun _ _ => touch t) 0 .empty

/-- A callback's closure is released once it has run, not before. -/
def released : IO String := do
  let before ← tokensReleased
  deferHolding
  let held ← tokensReleased
  let _ ← pump
  let after ← tokensReleased
  pure (problemUnless (held == before && after == before + 1)
    s!"tokens released: {before}, then {held}, then {after}")

/-- A callback run outside every call runs. -/
def outside : IO String := do
  let calls ← IO.mkRef #[]
  defer (recording calls) 3 "spontaneous".toUTF8
  runOutside
  let got ← calls.get
  pure (problemUnless (got == #[(3, "spontaneous")]) s!"called with {got}")

/-- Make an object whose finalizer runs a callback that holds a new token. -/
@[noinline]
def dropCancelling (calls : IO.Ref (Array (UInt32 × String))) : IO Unit := do
  let t ← token
  let _ ← cancelling fun code message => do
    touch t
    recording calls code message

/-- A callback a finalizer runs runs once, and its closure is released. -/
def finalized : IO String := do
  let calls ← IO.mkRef #[]
  let before ← tokensReleased
  dropCancelling calls
  let after ← tokensReleased
  let got ← calls.get
  pure (problemUnless (got == #[(2, "cancelled")] && after == before + 1)
    s!"called with {got}; tokens released: {before}, then {after}")

/-- Each check: what it checks, and the problem, or "" if none. -/
def checks : IO (List (String × String)) := do
  let named := [
    ("a callback run during its call, once", calledDuring),
    ("an error a callback raises during its call, the call's", raisedDuring),
    ("a message copied as valid UTF-8: sized, NUL-terminated or null",
      messages),
    ("callbacks deferred, run in the next pump, each once", deferred),
    ("the first error of a pump's callbacks, the pump's", firstError),
    ("a pump inside a callback, raising its own callbacks' errors", nested),
    ("a callback's closure released once it has run", released),
    ("a callback run outside every call", outside),
    ("a callback a finalizer runs, once, its closure released", finalized)
  ]
  named.mapM fun (what, check) => do pure (what, ← check)

end WebGPURawTest.Internal.Callback
