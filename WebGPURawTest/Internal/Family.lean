import WebGPURawTest.Internal.Callback

/-!
# Tests for families

The families (`c/family.c`), through test externs (`WebGPURawTest/c/
family_test.c`): a family keeps its closures while anything keeps it, the one
that made it and each of its members, and releases them, exactly once, when
the last is gone; an ID of a family gone names nothing, even when its index
is used again; a member's handle can have several Lean objects; releasing a
closure that holds a member of another family, whose finalizer leaves it,
does not deadlock; and members join and leave from many tasks at once. A
closure's release is seen by a token it holds (`Callback.token`). These run
natively and on the web.
-/

namespace WebGPURawTest.Internal.Family
open WebGPURawTest.Internal.Callback (token touch tokensReleased problemUnless)

/-! ## The families, from Lean -/

@[extern "lean_wgpu_test_family_new"]
opaque new : IO USize

@[extern "lean_wgpu_test_family_retain"]
opaque retain (f : USize) : IO Unit

@[extern "lean_wgpu_test_family_release"]
opaque release (f : USize) : IO Unit

@[extern "lean_wgpu_test_family_hold"]
opaque hold (f ordinal : USize) (closure : @& (Unit → IO Unit)) : IO Unit

/-- Run the closure `f` holds at `ordinal`: whether there was one. -/
@[extern "lean_wgpu_test_family_call"]
opaque call (f ordinal : USize) : IO Bool

@[extern "lean_wgpu_test_family_join"]
opaque join (handle f : USize) : IO Unit

@[extern "lean_wgpu_test_family_of"]
opaque familyOf (handle : USize) : IO USize

@[extern "lean_wgpu_test_family_leave"]
opaque leave (handle : USize) : IO USize

/-- Set the family a fill joins to: the one it replaces. -/
@[extern "lean_wgpu_test_family_set_filling"]
opaque setFilling (f : USize) : IO USize

@[extern "lean_wgpu_test_family_filling"]
opaque filling : IO USize

/-- The type of handles behind `Member`. -/
opaque MemberHandle : NonemptyType

/--
A fake member: a Lean object of a handle, joined to a family when made, which
leaves it, and releases its reference, when finalized.
-/
def Member : Type := NonemptyType.type MemberHandle

instance : Nonempty Member := Subtype.property MemberHandle

@[extern "lean_wgpu_test_family_member"]
opaque member (handle f : USize) : IO Member

/-- Use a member: so a closure that does holds it. -/
@[extern "lean_wgpu_test_family_touch"]
opaque touchMember (m : @& Member) : IO Unit

/-! ## Checks -/

/-- Hold, in `f` at `ordinal`, a closure that holds a new token. -/
@[noinline]
def holdToken (f ordinal : USize) : IO Unit := do
  let t ← token
  hold f ordinal fun _ => touch t

/--
A family keeps its closure while its maker keeps it, and releases it once,
when released; its ID then names nothing.
-/
def kept : IO String := do
  let before ← tokensReleased
  let f ← new
  holdToken f 0
  let held ← tokensReleased
  let ran ← call f 0
  release f
  let after ← tokensReleased
  let gone ← call f 0
  pure (problemUnless (held == before && ran && after == before + 1 && !gone)
    s!"tokens {before}, {held}, {after}; ran {ran}, then {gone}")

/--
Its members keep it: it is released when the last of them leaves, its maker's
reference given back first.
-/
def members : IO String := do
  let before ← tokensReleased
  let f ← new
  holdToken f 1
  join 0x1000 f
  join 0x2000 f
  release f
  let one ← leave 0x1000
  release one
  let kept ← call f 1
  let other ← familyOf 0x2000
  let two ← leave 0x2000
  release two
  let after ← tokensReleased
  let left ← familyOf 0x2000
  pure (problemUnless (one == f && two == f && other == f && kept
      && left == 0 && after == before + 1)
    s!"left {one}, {two} of {f}; kept {kept}; then {left}; \
      tokens {before}, {after}")

/-- Several Lean objects of one handle each join, and each leaves. -/
def sameHandle : IO String := do
  let f ← new
  join 0x3000 f
  join 0x3000 f
  release (← leave 0x3000)
  let still ← familyOf 0x3000
  release (← leave 0x3000)
  let gone ← familyOf 0x3000
  -- And it can join again after all have left, its entry a tombstone.
  join 0x3000 f
  let again ← familyOf 0x3000
  release (← leave 0x3000)
  -- A handle of no family, NULL among them, leaves none.
  let unknown ← leave 0x5000
  let null ← leave 0
  release f
  pure (problemUnless (still == f && gone == 0 && again == f
      && unknown == 0 && null == 0)
    s!"after one left: {still}; after both: {gone}; again: {again}; \
      unknown {unknown}, null {null}")

/--
An ID of a family gone names nothing, even when its index is used again: a
new family's closure is neither run nor released through it.
-/
def stale : IO String := do
  let old ← new
  release old
  let before ← tokensReleased
  let f ← new
  holdToken f 0
  retain old
  release old
  release old
  let ranOld ← call old 0
  let ranNew ← call f 0
  let kept ← tokensReleased
  release f
  pure (problemUnless (old != f && !ranOld && ranNew && kept == before)
    s!"ids {old}, {f}; ran {ranOld}, {ranNew}; tokens {before}, {kept}")

/-- Holding a closure where one was releases the one before. -/
def replaced : IO String := do
  let before ← tokensReleased
  let f ← new
  holdToken f 2
  holdToken f 2
  let once ← tokensReleased
  release f
  let after ← tokensReleased
  pure (problemUnless (once == before + 1 && after == before + 2)
    s!"tokens {before}, {once}, {after}")

/-- Hold, in `f`, a closure that holds a member of `g`. -/
@[noinline]
def holdMember (f g : USize) : IO Unit := do
  let m ← member 0x4000 g
  hold f 0 fun _ => touchMember m

/--
Releasing a closure that holds a member of another family, whose finalizer
leaves it, does not deadlock: closures are released outside the lock.
-/
def releaseRunsFinalizers : IO String := do
  let before ← tokensReleased
  let f ← new
  let g ← new
  holdToken g 0
  holdMember f g
  let joined ← familyOf 0x4000
  release g
  release f
  let left ← familyOf 0x4000
  let after ← tokensReleased
  pure (problemUnless (joined == g && left == 0 && after == before + 1)
    s!"member of {joined}, then {left}; tokens {before}, {after}")

/--
Many families made and released, and many members of one: each closure is
released once, and the table holds them all.
-/
def many : IO String := do
  let before ← tokensReleased
  for _ in [0:1000] do
    let f ← new
    holdToken f 0
    release f
  let f ← new
  holdToken f 0
  for k in [1:2001] do
    join (k * 16).toUSize f
  release f
  for k in [1:2001] do
    release (← leave (k * 16).toUSize)
  let after ← tokensReleased
  pure (problemUnless (after == before + 1001) s!"tokens {before}, {after}")

/--
Members join and leave from many tasks at once (natively on threads), and the
family is released once, when the last has left.
-/
def tasks : IO String := do
  let before ← tokensReleased
  let f ← new
  holdToken f 0
  -- A member throughout, which no rehash may lose.
  join 0x7000 f
  let work ← (List.range 8).mapM fun t => IO.asTask do
    for k in [0:500] do
      let handle := ((t * 1000 + k + 1) * 16).toUSize
      join handle f
      release (← leave handle)
  for w in work do
    let _ ← IO.ofExcept w.get
  let survived ← familyOf 0x7000
  release (← leave 0x7000)
  let kept ← tokensReleased
  release f
  let after ← tokensReleased
  pure (problemUnless (survived == f && kept == before && after == before + 1)
    s!"member {survived}; tokens {before}, {kept}, {after}")

/--
The family a fill joins closures to is per thread, set around the fill: a
fill inside another sets it again after.
-/
def fillingFamily : IO String := do
  let none ← filling
  let _ ← setFilling 42
  let outer ← setFilling 43
  let inner ← filling
  let _ ← setFilling outer
  let restored ← filling
  let _ ← setFilling 0
  pure (problemUnless (none == 0 && outer == 42 && inner == 43
      && restored == 42)
    s!"{none}, then {outer}, {inner}, {restored}")

/-- Each check: what it checks, and the problem, or "" if none. -/
def checks : IO (List (String × String)) := do
  let named := [
    ("a family kept by its maker, its closure released once", kept),
    ("a family kept by its members, released when the last leaves",
      members),
    ("several objects of one handle, each joining and leaving", sameHandle),
    ("an ID of a family gone naming nothing, its index used again", stale),
    ("a closure held where one was, releasing the one before", replaced),
    ("a closure released, its finalizers leaving families, no deadlock",
      releaseRunsFinalizers),
    ("many families and members, each closure released once", many),
    ("members joining and leaving from many tasks", tasks),
    ("the family a fill joins to, set per thread", fillingFamily)
  ]
  named.mapM fun (what, check) => do pure (what, ← check)

end WebGPURawTest.Internal.Family
