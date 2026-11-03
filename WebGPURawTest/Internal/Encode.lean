import WebGPU.Raw
import WebGPU.Raw.Internal.Encode
import WebGPURawTest.Internal.Pack

/-!
# Tests for encoding

A buffer descriptor's encoders, written by hand as the generator is to write
every struct's: its fields, for the specification (`encode`), and a
straight-line encoder of pokes, the same as `encode` of its fields. The encoders
are compared with C at run time, natively and on the web; the rest is checked as
this module builds.
-/

namespace WebGPURawTest.Internal.Encode
open WebGPU.Raw WebGPU.Raw.Bytes WebGPU.Raw.Pack WebGPU.Raw.Encode

/-! ## A buffer descriptor, on 64-bit targets -/

/--
`WGPUBufferDescriptor`'s scalar fields on 64-bit targets; `nextInChain` (0) and
`label.data` (8) are pointers, for C to fill in.
-/
def bufferDescriptorFields64 : List (Field BufferDescriptor) := [
  ⟨16, .size, fun d => d.label.utf8ByteSize.toUInt64.toNat⟩,
  ⟨24, .u64, fun d => d.usage.bits.toNat⟩,
  ⟨32, .u64, fun d => d.size.toNat⟩,
  ⟨40, .u32, fun d => (if d.mappedAtCreation then 1 else 0 : UInt32).toNat⟩
]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem bufferDescriptorFields64_wellFormed :
    Fields.WellFormed .bits64 48 bufferDescriptorFields64 := by
  unfold Fields.WellFormed; decide

/-- A buffer descriptor encoded for 64-bit targets: a poke for each field. -/
@[noinline]
def encodeBufferDescriptor64 (d : BufferDescriptor) : ByteArray :=
  let b := freshZeros 48
  let b := pokeU64 b 16 d.label.utf8ByteSize.toUInt64
    (by simp +zetaDelta [size_freshZeros])
  let b := pokeU64 b 24 d.usage.bits
    (by simp +zetaDelta [size_pokeU64, size_freshZeros])
  let b := pokeU64 b 32 d.size
    (by simp +zetaDelta [size_pokeU64, size_freshZeros])
  pokeU32 b 40 (if d.mappedAtCreation then 1 else 0)
    (by simp +zetaDelta [size_pokeU64, size_freshZeros])

/-- The encoder is `encode` of the fields: so `readLE_encode` holds of it. -/
theorem encodeBufferDescriptor64_eq (d : BufferDescriptor) :
    encodeBufferDescriptor64 d
      = encode .bits64 48 bufferDescriptorFields64 d := by
  simp only [encodeBufferDescriptor64, encode, bufferDescriptorFields64,
    List.map, Field.write, writeAll, List.foldl, pokeU64_eq, pokeU32_eq,
    freshZeros, Scalar.bytes, Width.bytes]

/-- Its pointers, `nextInChain` and `label.data`, read as 0, for C to fill. -/
theorem encodeBufferDescriptor64_pointers (d : BufferDescriptor) :
    readLE (encodeBufferDescriptor64 d) 0 8 = 0
      ∧ readLE (encodeBufferDescriptor64 d) 8 8 = 0 := by
  rw [encodeBufferDescriptor64_eq]
  exact ⟨readLE_encode_apart d 0 8 (by unfold bufferDescriptorFields64; decide),
    readLE_encode_apart d 8 8 (by unfold bufferDescriptorFields64; decide)⟩

/-! ## A buffer descriptor, on wasm32 -/

/--
`WGPUBufferDescriptor`'s scalar fields on wasm32; `nextInChain` (0) and
`label.data` (4) are pointers, for C to fill in. The label's length is a 32-bit
`size_t`: no string on wasm32 can be 2^32 bytes, so its length always fits.
-/
def bufferDescriptorFields32 : List (Field BufferDescriptor) := [
  ⟨8, .size, fun d => d.label.utf8ByteSize.toUInt32.toNat⟩,
  ⟨16, .u64, fun d => d.usage.bits.toNat⟩,
  ⟨24, .u64, fun d => d.size.toNat⟩,
  ⟨32, .u32, fun d => (if d.mappedAtCreation then 1 else 0 : UInt32).toNat⟩
]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem bufferDescriptorFields32_wellFormed :
    Fields.WellFormed .bits32 40 bufferDescriptorFields32 := by
  unfold Fields.WellFormed; decide

/-- A buffer descriptor encoded for wasm32: a poke for each field. -/
@[noinline]
def encodeBufferDescriptor32 (d : BufferDescriptor) : ByteArray :=
  let b := freshZeros 40
  let b := pokeU32 b 8 d.label.utf8ByteSize.toUInt32
    (by simp +zetaDelta [size_freshZeros])
  let b := pokeU64 b 16 d.usage.bits
    (by simp +zetaDelta [size_pokeU32, size_freshZeros])
  let b := pokeU64 b 24 d.size
    (by simp +zetaDelta [size_pokeU64, size_pokeU32, size_freshZeros])
  pokeU32 b 32 (if d.mappedAtCreation then 1 else 0)
    (by simp +zetaDelta [size_pokeU64, size_pokeU32, size_freshZeros])

/-- The encoder is `encode` of the fields: so `readLE_encode` holds of it. -/
theorem encodeBufferDescriptor32_eq (d : BufferDescriptor) :
    encodeBufferDescriptor32 d
      = encode .bits32 40 bufferDescriptorFields32 d := by
  simp only [encodeBufferDescriptor32, encode, bufferDescriptorFields32,
    List.map, Field.write, writeAll, List.foldl, pokeU64_eq, pokeU32_eq,
    freshZeros, Scalar.bytes, Width.bytes]

/-- Its pointers, `nextInChain` and `label.data`, read as 0, for C to fill. -/
theorem encodeBufferDescriptor32_pointers (d : BufferDescriptor) :
    readLE (encodeBufferDescriptor32 d) 0 4 = 0
      ∧ readLE (encodeBufferDescriptor32 d) 4 4 = 0 := by
  rw [encodeBufferDescriptor32_eq]
  exact ⟨readLE_encode_apart d 0 4 (by unfold bufferDescriptorFields32; decide),
    readLE_encode_apart d 4 4 (by unfold bufferDescriptorFields32; decide)⟩

/-! ## The encoders against C -/

/-- A buffer descriptor's values for the comparison with C. -/
def descriptor : BufferDescriptor :=
  { label := "vertices", usage := ⟨0x28⟩, size := 0x10000,
    mappedAtCreation := true }

/-- Each check: what it is, and whether it held. -/
@[noinline]
def checks : List (String × Bool) :=
  match Width.current with
  | .bits64 => [
      ("a buffer descriptor encodes as C lays it out",
        (encodeBufferDescriptor64 descriptor).data.toList
          == (WebGPURawTest.Internal.Pack.cBufferDescriptor 0x28 0x10000 1
            8).data.toList)
    ]
  | .bits32 => [
      ("a buffer descriptor encodes as C lays it out",
        (encodeBufferDescriptor32 descriptor).data.toList
          == (WebGPURawTest.Internal.Pack.cBufferDescriptor 0x28 0x10000 1
            8).data.toList)
    ]

end WebGPURawTest.Internal.Encode
