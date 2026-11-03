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

end WebGPU.Raw.Reloc

end
