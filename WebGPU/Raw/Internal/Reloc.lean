module

/-!
# Relocations

A helper for the generated bindings, not part of the API.

An encoded struct (`WebGPU.Raw.Encode`) leaves its pointers 0, for C to fill
in. Where each goes, and what it points to, is a struct's relocations: each an
offset in the struct and a kind of pointer. They are the same for every value
of the struct, so they are a table, made once: `serialize` lays one out in
bytes for C to read. What each pointer is filled from is a value's targets,
one for each relocation but a null one, in order: a string, an object, or a
block of bytes, another encoded struct, or an array's elements, whose own
relocations follow from its own table, its targets next in order.

One C function, `lean_wgpu_fill` (`c/reloc.c`), walks a table over the bytes,
and each element of a block, taking each target in turn. A table's header is
the size of the struct it is for, and the number of its relocations; each
relocation, 12 bytes, is its offset, its kind's code, and, for a block, the
index of the block's table:

    u32 size, u32 count, then count × (u32 offset, u8 kind, u8[3] 0, u32 table)

all little-endian. A block's elements are the size of its table's struct, and
an empty block is a null pointer: an optional struct that is none, or an empty
array.
-/

@[expose] public section

namespace WebGPU.Raw.Reloc

/-- The type of handles behind `Object`. -/
opaque ObjectHandle : NonemptyType

/--
Any WebGPU object, of any of the `c_object` types: each is a Lean external
object whose data is its handle, so C reads any one's handle the same way. An
object becomes one by a conversion that is the same Lean value, `#1` in C.
-/
def Object : Type := NonemptyType.type ObjectHandle

instance : Nonempty Object := Subtype.property ObjectHandle

-- (As `c_object Object` would declare it, without importing the command.)

/-- What a pointer of a struct points to, as C fills it in. -/
inductive Kind where
  /-- A string's bytes. -/
  | string
  /-- An optional string's bytes; null for none. -/
  | optString
  /-- An object's handle. -/
  | object
  /-- An optional object's handle; null for none. -/
  | optObject
  /-- A block of bytes, filled in by table number `table`; null if empty. -/
  | block (table : Nat)
  /-- A pointer left null, taking no target: a struct chain's, for now. -/
  | null
  deriving Repr, DecidableEq

/--
A kind's code, in C: the same as its target's constructor's index, and
`null`'s, which takes no target, after them.
-/
def Kind.code : Kind → UInt8
  | .string    => 0
  | .optString => 1
  | .object    => 2
  | .optObject => 3
  | .block _   => 4
  | .null      => 5

/-- A pointer of a struct: its offset, and what it points to. -/
structure Reloc where
  offset : Nat
  kind   : Kind
  deriving Repr, DecidableEq

/--
Whether a relocation's numbers fit the 4 bytes `serialize` gives each, so that
the table says what it is.
-/
def Reloc.fits (r : Reloc) : Bool :=
  r.offset < 2 ^ 32 && match r.kind with
    | .block t => t < 2 ^ 32
    | _        => true

/-- What a pointer is filled from: one for each kind but `null`. -/
inductive Target where
  | string    (s : String)
  | optString (s : Option String)
  | object    (o : Object)
  | optObject (o : Option Object)
  | block     (bytes : ByteArray)

/-- The number `n` in 4 bytes, little-endian. -/
def le32 (n : Nat) : List UInt8 :=
  [n, n >>> 8, n >>> 16, n >>> 24].map (·.toUInt8)

/-- A relocation's 12 bytes. -/
def Reloc.bytes (r : Reloc) : List UInt8 :=
  let table := match r.kind with
    | .block t => t
    | _        => 0
  le32 r.offset ++ [r.kind.code, 0, 0, 0] ++ le32 table

/-- The table of a struct of `size` bytes, with these relocations. -/
def serialize (size : Nat) (relocs : List Reloc) : ByteArray :=
  ⟨(le32 size ++ le32 relocs.length ++ relocs.flatMap Reloc.bytes).toArray⟩

/-- A relocation is 12 bytes. -/
theorem length_bytes (r : Reloc) : r.bytes.length = 12 := by
  simp [Reloc.bytes, le32]

/-- A table is its header, 8 bytes, and 12 for each relocation. -/
theorem size_serialize (size : Nat) (relocs : List Reloc) :
    (serialize size relocs).size = 8 + 12 * relocs.length := by
  induction relocs with
  | nil => simp [serialize, le32, ByteArray.size]
  | cons r rs ih =>
    simp only [serialize, ByteArray.size, List.size_toArray, List.length_append,
      List.flatMap_cons, length_bytes] at ih ⊢
    simp [le32] at ih ⊢
    omega


/-! ## The walk

Which targets `lean_wgpu_fill` takes, in which order, and of which kinds, as
Lean: the specification it implements (by review and test). A table, as the
walk reads it, is its struct's size and its relocations; each element of the
bytes takes, for each relocation but a null one, the next target, which must
be of its kind, and a block's own targets come next, by its own table. The
walk is none if a target is missing or of the wrong kind, if the bytes are
not whole elements, or if a block's table does not come before its own, as
every generated one does: so it ends.

It says nothing of where C writes each pointer (each struct's pointers are
proved within it, `pointers64_within`), of alignment, or of a block being
held by nothing else (both checked in the checked build); nor that C reads
the table `serialize` lays out, or that a kind's code is its target's
constructor's index (both by review and test).
-/

/-- A table as the walk reads it: its struct's size, and its relocations. -/
abbrev Spec := Nat × List Reloc

/-- One relocation's step: the targets after it, if the next is of its kind. -/
def step (walk : Nat → Nat → List Target → Option (List Target)) (r : Reloc)
    (ts : List Target) : Option (List Target) :=
  match r.kind, ts with
  | .null,      ts                 => some ts
  | .string,    .string _ :: ts    => some ts
  | .optString, .optString _ :: ts => some ts
  | .object,    .object _ :: ts    => some ts
  | .optObject, .optObject _ :: ts => some ts
  | .block j,   .block bytes :: ts => walk j bytes.size ts
  | _,          _                  => none

/--
The targets left after filling in `size` bytes by table `table` of `specs`,
from `targets`; none if they do not agree.
-/
def walk (specs : Array Spec) (table size : Nat) (targets : List Target) :
    Option (List Target) := do
  let (stride, relocs) ← specs[table]?
  if stride = 0 ∨ size % stride ≠ 0 then none
  else
    (List.replicate (size / stride) ()).foldlM (init := targets) fun ts _ =>
      relocs.foldlM (init := ts) fun ts r =>
        step (fun j size ts => if j < table then walk specs j size ts
          else none) r ts
termination_by table


/-- An empty block takes no targets: an optional struct that is none. -/
theorem walk_empty {specs : Array Spec} {table stride : Nat}
    {relocs : List Reloc} (h : specs[table]? = some (stride, relocs))
    (hstride : stride ≠ 0) (ts : List Target) :
    walk specs table 0 ts = some ts := by
  rw [walk, h]
  simp [hstride]

end WebGPU.Raw.Reloc

end
