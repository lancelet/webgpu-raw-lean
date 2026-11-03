module

public import WebGPU.Raw.Internal.Pack

/-!
# Encoding a struct

A helper for the generated bindings, not part of the API: the bindings import
this module privately, so it never reaches their users.

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
open WebGPU.Raw.Bytes WebGPU.Raw.Pack

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

end WebGPU.Raw.Encode

end
