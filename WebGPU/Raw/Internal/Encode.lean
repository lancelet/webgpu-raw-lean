module

public import WebGPU.Raw.Internal.Bytes

/-!
# Encoding a struct

A helper for the generated bindings, not part of the API: of the bindings,
only the generated encoders (`WebGPU.Raw.Encoders`) import it publicly, as
their theorems mention it.

A struct of `webgpu.h` is encoded field by field: each `Field` an offset, a
kind of scalar, and the number its bytes hold for a value. `encode` writes each
over a block of zeros of the struct's size. It is the specification: the
generated encoders run as straight-line pokes into a fresh block, and each is
proved the same as `encode` of its fields, by rewriting each poke as the write
it is (`simp only`, with a fixed set of lemmas). So this module's theorems hold
of every generated encoder:

    theorem readLE_encode : every field reads back as its number
    theorem readLE_encode_apart : every byte apart from the fields reads as 0

the bytes apart from the fields being the struct's pointers, for C to fill in,
and its padding. Each struct's fields are well-formed (`Fields.WellFormed`), by
`decide`, which Lean's kernel checks.
-/

@[expose] public section

namespace WebGPU.Raw.Encode
open WebGPU.Raw.Bytes

/-! ## Widths and scalars -/

/-- How wide the target's pointers and `size_t` are. -/
inductive Width where
  /-- wasm32: 4 bytes. -/
  | bits32
  /-- Every native target the bindings support: 8 bytes. -/
  | bits64
  deriving Repr, DecidableEq

/-- The width of the target the program runs on. -/
def Width.current : Width :=
  if System.Platform.numBits = 64 then .bits64 else .bits32

/-- The bytes in a pointer or `size_t`. -/
def Width.bytes : Width → Nat
  | .bits32 => 4
  | .bits64 => 8

/-- A scalar of a struct, by its C type, as the layout model has it. -/
inductive Scalar where
  | u8
  | u16
  | u32
  | u64
  | f32
  | f64
  | ptr
  /-- A `size_t`. -/
  | size
  deriving Repr, DecidableEq

/-- A scalar's size in bytes, and its alignment. -/
def Scalar.bytes (w : Width) : Scalar → Nat
  | .u8          => 1
  | .u16         => 2
  | .u32 | .f32  => 4
  | .u64 | .f64  => 8
  | .ptr | .size => w.bytes

/-! ## Writes that do not overlap -/

/-- A write: an offset, a width in bytes, and the number to write there. -/
abbrev Write := Nat × Nat × Nat

/-- One write ends before the other begins. -/
def Write.Apart (a b : Write) : Prop :=
  a.1 + a.2.1 ≤ b.1 ∨ b.1 + b.2.1 ≤ a.1

/-- `bytes` with each write made, in order, each whole if it fits. -/
def writeAll (bytes : ByteArray) (writes : List Write) : ByteArray :=
  writes.foldl (fun b (offset, width, n) => writeWhole b offset width n) bytes

/-- Making writes one after another. -/
theorem writeAll_cons (bytes : ByteArray) (w : Write) (writes : List Write) :
    writeAll bytes (w :: writes)
      = writeAll (writeWhole bytes w.1 w.2.1 w.2.2) writes := by
  unfold writeAll
  rfl

/-- Making writes keeps the array's size. -/
theorem size_writeAll (bytes : ByteArray) (writes : List Write) :
    (writeAll bytes writes).size = bytes.size := by
  induction writes generalizing bytes with
  | nil => rfl
  | cons w writes ih =>
    simp only [writeAll, List.foldl_cons] at ih ⊢
    rw [ih, size_writeWhole]

/-- Bytes apart from every write read as they were. -/
theorem readLE_writeAll_apart (bytes : ByteArray) (writes : List Write)
    (offset width : Nat) (h : ∀ w ∈ writes, Write.Apart w (offset, width, 0)) :
    readLE (writeAll bytes writes) offset width
      = readLE bytes offset width := by
  induction writes generalizing bytes with
  | nil => rfl
  | cons w writes ih =>
    simp only [writeAll, List.foldl_cons] at ih ⊢
    rw [ih _ fun w' hw' => h w' (List.mem_cons_of_mem _ hw')]
    obtain ⟨o, k, n⟩ := w
    have := h (o, k, n) (List.mem_cons_self ..)
    simp only [Write.Apart] at this
    exact readLE_writeWhole_disjoint _ _ _ _ _ _ this

/--
Of writes that do not overlap, each within the array, each reads back after
all are made.
-/
theorem readLE_writeAll (bytes : ByteArray) (writes : List Write)
    (hapart : writes.Pairwise Write.Apart)
    (hfit : ∀ w ∈ writes, w.1 + w.2.1 ≤ bytes.size) :
    ∀ w ∈ writes,
      readLE (writeAll bytes writes) w.1 w.2.1 = w.2.2 % 256 ^ w.2.1 := by
  induction writes generalizing bytes with
  | nil => simp
  | cons x writes ih =>
    intro w hw
    rw [writeAll_cons]
    obtain ⟨hx, hrest⟩ := List.pairwise_cons.1 hapart
    by_cases hin : w ∈ writes
    · apply ih _ hrest _ w hin
      intro w' hw'
      rw [size_writeWhole]
      exact hfit w' (List.mem_cons_of_mem _ hw')
    · have hwx : w = x := by
        rcases List.mem_cons.1 hw with h | h
        · exact h
        · exact absurd h hin
      subst hwx
      rw [readLE_writeAll_apart _ _ _ _ fun w' hw' => by
        have := hx w' hw'
        obtain ⟨o, k, n⟩ := w
        obtain ⟨o', k', n'⟩ := w'
        simp only [Write.Apart] at this ⊢
        omega]
      exact readLE_writeWhole _ _ _ _ (hfit w (List.mem_cons_self ..))

/-! ## Encoding -/

/-- A scalar field of the struct `T`, and the number its bytes hold. -/
structure Field (T : Type) where
  offset : Nat
  scalar : Scalar
  bits   : T → Nat

/-- A field's write, for the value `d`: its offset, its width, its number. -/
def Field.write {T : Type} (w : Width) (d : T) (f : Field T) : Write :=
  (f.offset, f.scalar.bytes w, f.bits d)

/-- `d` encoded by its fields: each written over zeros of the struct's size. -/
def encode {T : Type} (w : Width) (size : Nat) (fields : List (Field T))
    (d : T) : ByteArray :=
  writeAll (zeros size) (fields.map (·.write w d))

/--
Fields an encoding can write: each within the struct, and each ending before
the next begins.
-/
def Fields.WellFormed {T : Type} (w : Width) (size : Nat)
    (fields : List (Field T)) : Prop :=
  (∀ f ∈ fields, f.offset + f.scalar.bytes w ≤ size)
    ∧ fields.Pairwise fun a b => a.offset + a.scalar.bytes w ≤ b.offset

/-- An encoding is the struct's size. -/
theorem size_encode {T : Type} (w : Width) (size : Nat)
    (fields : List (Field T)) (d : T) :
    (encode w size fields d).size = size := by
  rw [encode, size_writeAll, size_zeros]

/-- Fields in order make writes that do not overlap. -/
theorem pairwise_writes {T : Type} {w : Width} {fields : List (Field T)}
    (h : fields.Pairwise fun a b => a.offset + a.scalar.bytes w ≤ b.offset)
    (d : T) : (fields.map (·.write w d)).Pairwise Write.Apart :=
  List.pairwise_map.2 (h.imp fun hab => Or.inl hab)

/-- In an encoding by well-formed fields, a field reads back as its number. -/
theorem readLE_encode {T : Type} {w : Width} {size : Nat}
    {fields : List (Field T)} (hwf : Fields.WellFormed w size fields) (d : T) :
    ∀ f ∈ fields, readLE (encode w size fields d) f.offset (f.scalar.bytes w)
      = f.bits d % 256 ^ f.scalar.bytes w := by
  intro f hf
  exact readLE_writeAll (zeros size) _ (pairwise_writes hwf.2 d)
    (fun x hx => by
      simp only [List.mem_map] at hx
      obtain ⟨g, hg, rfl⟩ := hx
      rw [size_zeros]
      exact hwf.1 g hg)
    (f.write w d) (List.mem_map_of_mem hf)

/--
In an encoding, every byte apart from every field reads as 0: the struct's
pointers, for C to fill in, and its padding.
-/
theorem readLE_encode_apart {T : Type} {w : Width} {size : Nat}
    {fields : List (Field T)} (d : T) (offset width : Nat)
    (h : ∀ f ∈ fields,
      f.offset + f.scalar.bytes w ≤ offset ∨ offset + width ≤ f.offset) :
    readLE (encode w size fields d) offset width = 0 := by
  rw [encode, readLE_writeAll_apart _ _ _ _ fun x hx => by
    simp only [List.mem_map] at hx
    obtain ⟨f, hf, rfl⟩ := hx
    exact h f hf]
  exact readLE_zeros ..

/-! ## Blocks of a known size -/

/--
A block of `size` bytes, with its size: what the generated encoders poke into.
A poke keeps its size, so each poke's bound is arithmetic on numbers alone
(`by decide`). Lean represents a block as its bytes alone, so this costs
nothing at run time.
-/
abbrev Block (size : Nat) := {bytes : ByteArray // bytes.size = size}

/-- A fresh block of `size` bytes, each 0: an encoder makes one. -/
@[inline]
def Block.fresh (size : Nat) : Block size :=
  ⟨freshZeros size, size_freshZeros size⟩

/-- The block with `v` at `offset`, where it fits: 1 byte. -/
@[inline]
def Block.pokeU8 {size : Nat} (b : Block size) (offset : Nat) (v : UInt8)
    (h : offset + 1 ≤ size) : Block size :=
  ⟨Bytes.pokeU8 b.1 offset v (b.2.symm ▸ h), by rw [size_pokeU8, b.2]⟩

/-- The block with `v` at `offset`, where it fits: 2 bytes. -/
@[inline]
def Block.pokeU16 {size : Nat} (b : Block size) (offset : Nat) (v : UInt16)
    (h : offset + 2 ≤ size) : Block size :=
  ⟨Bytes.pokeU16 b.1 offset v (b.2.symm ▸ h), by rw [size_pokeU16, b.2]⟩

/-- The block with `v` at `offset`, where it fits: 4 bytes. -/
@[inline]
def Block.pokeU32 {size : Nat} (b : Block size) (offset : Nat) (v : UInt32)
    (h : offset + 4 ≤ size) : Block size :=
  ⟨Bytes.pokeU32 b.1 offset v (b.2.symm ▸ h), by rw [size_pokeU32, b.2]⟩

/-- The block with `v` at `offset`, where it fits: 8 bytes. -/
@[inline]
def Block.pokeU64 {size : Nat} (b : Block size) (offset : Nat) (v : UInt64)
    (h : offset + 8 ≤ size) : Block size :=
  ⟨Bytes.pokeU64 b.1 offset v (b.2.symm ▸ h), by rw [size_pokeU64, b.2]⟩

/-- The block with `v` at `offset`, where it fits, as a C `float`. -/
@[inline]
def Block.pokeF32 {size : Nat} (b : Block size) (offset : Nat) (v : Float32)
    (h : offset + 4 ≤ size) : Block size :=
  ⟨Bytes.pokeF32 b.1 offset v (b.2.symm ▸ h), by rw [size_pokeF32, b.2]⟩

/-- The block with `v` at `offset`, where it fits, as a C `double`. -/
@[inline]
def Block.pokeF64 {size : Nat} (b : Block size) (offset : Nat) (v : Float)
    (h : offset + 8 ≤ size) : Block size :=
  ⟨Bytes.pokeF64 b.1 offset v (b.2.symm ▸ h), by rw [size_pokeF64, b.2]⟩

/-! ### A block's bytes

What each poke leaves in a block's bytes, so proofs about an encoder rewrite its
bytes poke by poke, never unfolding a block's proof of its size: which mentions
the block before it, so unfolding every poke would double the term with each. -/

/-- A fresh block's bytes are zeros. -/
theorem Block.val_fresh (size : Nat) : (Block.fresh size).1 = zeros size := rfl

/-- A poke's bytes. -/
theorem Block.val_pokeU8 {size : Nat} (b : Block size) (offset : Nat)
    (v : UInt8) (h) :
    (b.pokeU8 offset v h).1 = writeWhole b.1 offset 1 v.toNat :=
  rfl

/-- A poke's bytes. -/
theorem Block.val_pokeU16 {size : Nat} (b : Block size) (offset : Nat)
    (v : UInt16) (h) :
    (b.pokeU16 offset v h).1 = writeWhole b.1 offset 2 v.toNat :=
  rfl

/-- A poke's bytes. -/
theorem Block.val_pokeU32 {size : Nat} (b : Block size) (offset : Nat)
    (v : UInt32) (h) :
    (b.pokeU32 offset v h).1 = writeWhole b.1 offset 4 v.toNat :=
  rfl

/-- A poke's bytes. -/
theorem Block.val_pokeU64 {size : Nat} (b : Block size) (offset : Nat)
    (v : UInt64) (h) :
    (b.pokeU64 offset v h).1 = writeWhole b.1 offset 8 v.toNat :=
  rfl

/-- A poke's bytes. -/
theorem Block.val_pokeF32 {size : Nat} (b : Block size) (offset : Nat)
    (v : Float32) (h) :
    (b.pokeF32 offset v h).1 = writeWhole b.1 offset 4 v.toBits.toNat :=
  rfl

/-- A poke's bytes. -/
theorem Block.val_pokeF64 {size : Nat} (b : Block size) (offset : Nat)
    (v : Float) (h) :
    (b.pokeF64 offset v h).1 = writeWhole b.1 offset 8 v.toBits.toNat :=
  rfl

/-! ## Values as C holds them -/

/-- A `WGPUBool`: 1 for true. -/
@[inline]
def wgpuBool (b : Bool) : UInt32 :=
  if b then 1 else 0

/-- A string view's length on 64-bit targets: `SIZE_MAX` for the null view. -/
@[inline]
def viewLength64 : Option String → UInt64
  | none   => 0xFFFFFFFFFFFFFFFF
  | some s => s.utf8ByteSize.toUInt64

/-- A string view's length on wasm32: `SIZE_MAX` for the null view. -/
@[inline]
def viewLength32 : Option String → UInt32
  | none   => 0xFFFFFFFF
  | some s => s.utf8ByteSize.toUInt32

/-- A nullable `float`'s bits: C's NaN, `0x7FC00000`, for none. -/
@[inline]
def nanOr : Option Float32 → UInt32
  | none   => 0x7FC00000
  | some f => f.toBits

/-- Whether a `size_t` fits on wasm32: in 32 bits, or as `SIZE_MAX`. -/
@[inline]
def sizeFits (n : UInt64) : Bool :=
  n.toNat < 2 ^ 32 || n = 0xFFFFFFFFFFFFFFFF

/--
A `size_t` on wasm32: `SIZE_MAX` for the largest `UInt64`, else its low 32 bits,
which are it, as the caller checks it fits (`sizesFit`).
-/
@[inline]
def size32 (n : UInt64) : UInt32 :=
  if n = 0xFFFFFFFFFFFFFFFF then 0xFFFFFFFF else n.toUInt32

end WebGPU.Raw.Encode

end
