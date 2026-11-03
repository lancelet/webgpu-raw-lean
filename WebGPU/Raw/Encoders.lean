/-
================================================================================
  GENERATED FILE: DO NOT EDIT BY HAND

  Generator:        webgpu-gen
  Generator commit: 6b642f5 (clean)
  Generated:        2026-11-03 12:18:17 UTC
  Source:           vendor/webgpu-headers/webgpu.yml
  Source repo:      https://github.com/webgpu-native/webgpu-headers
  Source commit:    673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
  Source date:      2026-05-07
  Source pinned by: wgpu-native v29.0.1.1
================================================================================
-/
module

public import WebGPU.Raw.Structs
public import WebGPU.Raw.Internal.Encode
public import WebGPU.Raw.Internal.Reloc

/-!
# Encoders

Each struct of `WebGPU.Raw.Structs` as C lays it out, its pointers 0
for C to fill in (`toBytes`). For each target width, a struct's
fields are the specification (`WebGPU.Raw.Encode.encode`); its
encoder, a poke for each field into a fresh block, is proved the same,
its fields well-formed, and its pointers 0. The C compiler checks the
layouts against `webgpu.h` (`c/generated/layouts.c`).

Where C fills in a struct's pointers is its table (`tables`, at its
`tableIndex`), proved to be its pointers; what it fills each in from,
its targets (`toTargets`), proved to be what walking its table takes
(`walk64`, `walk32`).
-/

@[expose] public section

namespace WebGPU.Raw

open Encode Bytes Reloc

/-! ## Objects

Each object type as an `Object`, the same Lean value: what C fills in a
pointer to one from. -/

/-- `Adapter`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.Adapter.toObject : Adapter → Object

/-- `BindGroup`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.BindGroup.toObject : BindGroup → Object

/-- `BindGroupLayout`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.BindGroupLayout.toObject : BindGroupLayout → Object

/-- `Buffer`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.Buffer.toObject : Buffer → Object

/-- `CommandBuffer`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.CommandBuffer.toObject : CommandBuffer → Object

/-- `CommandEncoder`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.CommandEncoder.toObject : CommandEncoder → Object

/-- `ComputePassEncoder`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.ComputePassEncoder.toObject : ComputePassEncoder → Object

/-- `ComputePipeline`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.ComputePipeline.toObject : ComputePipeline → Object

/-- `Device`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.Device.toObject : Device → Object

/-- `ExternalTexture`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.ExternalTexture.toObject : ExternalTexture → Object

/-- `Instance`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.Instance.toObject : Instance → Object

/-- `PipelineLayout`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.PipelineLayout.toObject : PipelineLayout → Object

/-- `QuerySet`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.QuerySet.toObject : QuerySet → Object

/-- `Queue`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.Queue.toObject : Queue → Object

/-- `RenderBundle`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.RenderBundle.toObject : RenderBundle → Object

/-- `RenderBundleEncoder`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.RenderBundleEncoder.toObject : RenderBundleEncoder → Object

/-- `RenderPassEncoder`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.RenderPassEncoder.toObject : RenderPassEncoder → Object

/-- `RenderPipeline`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.RenderPipeline.toObject : RenderPipeline → Object

/-- `Sampler`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.Sampler.toObject : Sampler → Object

/-- `ShaderModule`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.ShaderModule.toObject : ShaderModule → Object

/-- `Surface`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.Surface.toObject : Surface → Object

/-- `Texture`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.Texture.toObject : Texture → Object

/-- `TextureView`, as an `Object`. -/
@[extern c inline "#1"]
opaque Internal.TextureView.toObject : TextureView → Object

namespace BindGroupEntry

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field BindGroupEntry) := [
  ⟨8, .u32, fun d => (d.binding).toNat⟩,
  ⟨24, .u64, fun d => (d.offset).toNat⟩,
  ⟨32, .u64, fun d => (d.size).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 16, 40, 48]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 56 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 56 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : BindGroupEntry) : ByteArray :=
  let b := Block.fresh 56
  let b := b.pokeU32 8 d.binding (by decide)
  let b := b.pokeU64 24 d.offset (by decide)
  let b := b.pokeU64 32 d.size (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : BindGroupEntry) :
    encode64 d = Encode.encode .bits64 56 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : BindGroupEntry) :
    (encode64 d).size = 56 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : BindGroupEntry) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨16, .optObject⟩, ⟨40, .optObject⟩, ⟨48, .optObject⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  56, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 3,
  0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 3, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 56 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : BindGroupEntry) : Array Target :=
  #[
    .optObject (d.buffer.map Internal.Buffer.toObject),
    .optObject (d.sampler.map Internal.Sampler.toObject),
    .optObject (d.textureView.map Internal.TextureView.toObject)
  ]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : BindGroupEntry) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field BindGroupEntry) := [
  ⟨4, .u32, fun d => (d.binding).toNat⟩,
  ⟨16, .u64, fun d => (d.offset).toNat⟩,
  ⟨24, .u64, fun d => (d.size).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 8, 32, 36]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 40 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 40 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : BindGroupEntry) : ByteArray :=
  let b := Block.fresh 40
  let b := b.pokeU32 4 d.binding (by decide)
  let b := b.pokeU64 16 d.offset (by decide)
  let b := b.pokeU64 24 d.size (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : BindGroupEntry) :
    encode32 d = Encode.encode .bits32 40 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : BindGroupEntry) :
    (encode32 d).size = 40 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : BindGroupEntry) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .optObject⟩, ⟨32, .optObject⟩, ⟨36, .optObject⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  40, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 3, 0,
  0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 36, 0, 0, 0, 3, 0, 0,
  0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 40 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : BindGroupEntry) : Array Target :=
  #[
    .optObject (d.buffer.map Internal.Buffer.toObject),
    .optObject (d.sampler.map Internal.Sampler.toObject),
    .optObject (d.textureView.map Internal.TextureView.toObject)
  ]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : BindGroupEntry) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : BindGroupEntry) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : BindGroupEntry) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 0

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BindGroupEntry) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end BindGroupEntry

namespace BlendComponent

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field BlendComponent) := [
  ⟨0, .u32, fun d => (CEnum.toC d.operation).toNat⟩,
  ⟨4, .u32, fun d => (CEnum.toC d.srcFactor).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.dstFactor).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 12 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : BlendComponent) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 0 (CEnum.toC d.operation) (by decide)
  let b := b.pokeU32 4 (CEnum.toC d.srcFactor) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.dstFactor) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : BlendComponent) :
    encode64 d = Encode.encode .bits64 12 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : BlendComponent) :
    (encode64 d).size = 12 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : BlendComponent) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := []

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  12, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 12 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : BlendComponent) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : BlendComponent) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field BlendComponent) := [
  ⟨0, .u32, fun d => (CEnum.toC d.operation).toNat⟩,
  ⟨4, .u32, fun d => (CEnum.toC d.srcFactor).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.dstFactor).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : BlendComponent) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 0 (CEnum.toC d.operation) (by decide)
  let b := b.pokeU32 4 (CEnum.toC d.srcFactor) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.dstFactor) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : BlendComponent) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : BlendComponent) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : BlendComponent) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := []

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : BlendComponent) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : BlendComponent) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : BlendComponent) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : BlendComponent) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 1

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BlendComponent) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end BlendComponent

namespace BufferBindingLayout

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field BufferBindingLayout) := [
  ⟨8, .u32, fun d => (CEnum.toC d.type).toNat⟩,
  ⟨12, .u32, fun d => (wgpuBool d.hasDynamicOffset).toNat⟩,
  ⟨16, .u64, fun d => (d.minBindingSize).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : BufferBindingLayout) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 (CEnum.toC d.type) (by decide)
  let b := b.pokeU32 12 (wgpuBool d.hasDynamicOffset) (by decide)
  let b := b.pokeU64 16 d.minBindingSize (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : BufferBindingLayout) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : BufferBindingLayout) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : BufferBindingLayout) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : BufferBindingLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : BufferBindingLayout) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field BufferBindingLayout) := [
  ⟨4, .u32, fun d => (CEnum.toC d.type).toNat⟩,
  ⟨8, .u32, fun d => (wgpuBool d.hasDynamicOffset).toNat⟩,
  ⟨16, .u64, fun d => (d.minBindingSize).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : BufferBindingLayout) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 4 (CEnum.toC d.type) (by decide)
  let b := b.pokeU32 8 (wgpuBool d.hasDynamicOffset) (by decide)
  let b := b.pokeU64 16 d.minBindingSize (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : BufferBindingLayout) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : BufferBindingLayout) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : BufferBindingLayout) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : BufferBindingLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : BufferBindingLayout) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : BufferBindingLayout) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : BufferBindingLayout) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 2

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BufferBindingLayout) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end BufferBindingLayout

namespace BufferDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field BufferDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .u64, fun d => (d.usage.bits).toNat⟩,
  ⟨32, .u64, fun d => (d.size).toNat⟩,
  ⟨40, .u32, fun d => (wgpuBool d.mappedAtCreation).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 48 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 48 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : BufferDescriptor) : ByteArray :=
  let b := Block.fresh 48
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU64 24 d.usage.bits (by decide)
  let b := b.pokeU64 32 d.size (by decide)
  let b := b.pokeU32 40 (wgpuBool d.mappedAtCreation) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : BufferDescriptor) :
    encode64 d = Encode.encode .bits64 48 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : BufferDescriptor) :
    (encode64 d).size = 48 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : BufferDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  48, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 48 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : BufferDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : BufferDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field BufferDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨16, .u64, fun d => (d.usage.bits).toNat⟩,
  ⟨24, .u64, fun d => (d.size).toNat⟩,
  ⟨32, .u32, fun d => (wgpuBool d.mappedAtCreation).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 40 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 40 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : BufferDescriptor) : ByteArray :=
  let b := Block.fresh 40
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU64 16 d.usage.bits (by decide)
  let b := b.pokeU64 24 d.size (by decide)
  let b := b.pokeU32 32 (wgpuBool d.mappedAtCreation) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : BufferDescriptor) :
    encode32 d = Encode.encode .bits32 40 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : BufferDescriptor) :
    (encode32 d).size = 40 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : BufferDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  40, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 40 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : BufferDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : BufferDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : BufferDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : BufferDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 3

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BufferDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end BufferDescriptor

namespace Color

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field Color) := [
  ⟨0, .f64, fun d => (d.r).toBits.toNat⟩,
  ⟨8, .f64, fun d => (d.g).toBits.toNat⟩,
  ⟨16, .f64, fun d => (d.b).toBits.toNat⟩,
  ⟨24, .f64, fun d => (d.a).toBits.toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : Color) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeF64 0 d.r (by decide)
  let b := b.pokeF64 8 d.g (by decide)
  let b := b.pokeF64 16 d.b (by decide)
  let b := b.pokeF64 24 d.a (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : Color) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeF64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : Color) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : Color) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := []

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : Color) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : Color) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field Color) := [
  ⟨0, .f64, fun d => (d.r).toBits.toNat⟩,
  ⟨8, .f64, fun d => (d.g).toBits.toNat⟩,
  ⟨16, .f64, fun d => (d.b).toBits.toNat⟩,
  ⟨24, .f64, fun d => (d.a).toBits.toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 32 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : Color) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeF64 0 d.r (by decide)
  let b := b.pokeF64 8 d.g (by decide)
  let b := b.pokeF64 16 d.b (by decide)
  let b := b.pokeF64 24 d.a (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : Color) :
    encode32 d = Encode.encode .bits32 32 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeF64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : Color) :
    (encode32 d).size = 32 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : Color) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := []

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  32, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 32 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : Color) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : Color) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : Color) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : Color) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 4

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : Color) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end Color

namespace CommandBufferDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field CommandBufferDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : CommandBufferDescriptor) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : CommandBufferDescriptor) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : CommandBufferDescriptor) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : CommandBufferDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : CommandBufferDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : CommandBufferDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field CommandBufferDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : CommandBufferDescriptor) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : CommandBufferDescriptor) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : CommandBufferDescriptor) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : CommandBufferDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : CommandBufferDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : CommandBufferDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : CommandBufferDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : CommandBufferDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 5

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : CommandBufferDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end CommandBufferDescriptor

namespace CommandEncoderDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field CommandEncoderDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : CommandEncoderDescriptor) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : CommandEncoderDescriptor) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : CommandEncoderDescriptor) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : CommandEncoderDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : CommandEncoderDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : CommandEncoderDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field CommandEncoderDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : CommandEncoderDescriptor) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : CommandEncoderDescriptor) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : CommandEncoderDescriptor) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : CommandEncoderDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : CommandEncoderDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : CommandEncoderDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : CommandEncoderDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : CommandEncoderDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 6

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : CommandEncoderDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end CommandEncoderDescriptor

namespace CompatibilityModeLimits

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field CompatibilityModeLimits) := [
  ⟨8, .u32, fun _ => (CEnum.toC SType.compatibilityModeLimits).toNat⟩,
  ⟨16, .u32, fun d => (d.maxStorageBuffersInVertexStage).toNat⟩,
  ⟨20, .u32, fun d => (d.maxStorageTexturesInVertexStage).toNat⟩,
  ⟨24, .u32, fun d => (d.maxStorageBuffersInFragmentStage).toNat⟩,
  ⟨28, .u32, fun d => (d.maxStorageTexturesInFragmentStage).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : CompatibilityModeLimits) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 8 (CEnum.toC SType.compatibilityModeLimits) (by decide)
  let b := b.pokeU32 16 d.maxStorageBuffersInVertexStage (by decide)
  let b := b.pokeU32 20 d.maxStorageTexturesInVertexStage (by decide)
  let b := b.pokeU32 24 d.maxStorageBuffersInFragmentStage (by decide)
  let b := b.pokeU32 28 d.maxStorageTexturesInFragmentStage (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : CompatibilityModeLimits) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : CompatibilityModeLimits) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : CompatibilityModeLimits) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : CompatibilityModeLimits) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : CompatibilityModeLimits) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field CompatibilityModeLimits) := [
  ⟨4, .u32, fun _ => (CEnum.toC SType.compatibilityModeLimits).toNat⟩,
  ⟨8, .u32, fun d => (d.maxStorageBuffersInVertexStage).toNat⟩,
  ⟨12, .u32, fun d => (d.maxStorageTexturesInVertexStage).toNat⟩,
  ⟨16, .u32, fun d => (d.maxStorageBuffersInFragmentStage).toNat⟩,
  ⟨20, .u32, fun d => (d.maxStorageTexturesInFragmentStage).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : CompatibilityModeLimits) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 4 (CEnum.toC SType.compatibilityModeLimits) (by decide)
  let b := b.pokeU32 8 d.maxStorageBuffersInVertexStage (by decide)
  let b := b.pokeU32 12 d.maxStorageTexturesInVertexStage (by decide)
  let b := b.pokeU32 16 d.maxStorageBuffersInFragmentStage (by decide)
  let b := b.pokeU32 20 d.maxStorageTexturesInFragmentStage (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : CompatibilityModeLimits) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : CompatibilityModeLimits) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : CompatibilityModeLimits) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : CompatibilityModeLimits) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : CompatibilityModeLimits) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : CompatibilityModeLimits) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : CompatibilityModeLimits) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 7

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : CompatibilityModeLimits) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end CompatibilityModeLimits

namespace ConstantEntry

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field ConstantEntry) := [
  ⟨16, .size, fun d => (d.key.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .f64, fun d => (d.value).toBits.toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : ConstantEntry) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU64 16 d.key.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeF64 24 d.value (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : ConstantEntry) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeF64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : ConstantEntry) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : ConstantEntry) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : ConstantEntry) : Array Target :=
  #[.string d.key]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : ConstantEntry) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field ConstantEntry) := [
  ⟨8, .size, fun d => (d.key.utf8ByteSize.toUInt32).toNat⟩,
  ⟨16, .f64, fun d => (d.value).toBits.toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : ConstantEntry) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 d.key.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeF64 16 d.value (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : ConstantEntry) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeF64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : ConstantEntry) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : ConstantEntry) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : ConstantEntry) : Array Target :=
  #[.string d.key]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : ConstantEntry) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : ConstantEntry) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : ConstantEntry) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 8

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ConstantEntry) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end ConstantEntry

namespace Extent3D

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field Extent3D) := [
  ⟨0, .u32, fun d => (d.width).toNat⟩,
  ⟨4, .u32, fun d => (d.height).toNat⟩,
  ⟨8, .u32, fun d => (d.depthOrArrayLayers).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 12 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : Extent3D) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 0 d.width (by decide)
  let b := b.pokeU32 4 d.height (by decide)
  let b := b.pokeU32 8 d.depthOrArrayLayers (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : Extent3D) :
    encode64 d = Encode.encode .bits64 12 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : Extent3D) :
    (encode64 d).size = 12 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : Extent3D) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := []

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  12, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 12 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : Extent3D) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : Extent3D) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field Extent3D) := [
  ⟨0, .u32, fun d => (d.width).toNat⟩,
  ⟨4, .u32, fun d => (d.height).toNat⟩,
  ⟨8, .u32, fun d => (d.depthOrArrayLayers).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : Extent3D) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 0 d.width (by decide)
  let b := b.pokeU32 4 d.height (by decide)
  let b := b.pokeU32 8 d.depthOrArrayLayers (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : Extent3D) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : Extent3D) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : Extent3D) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := []

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : Extent3D) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : Extent3D) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : Extent3D) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : Extent3D) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 9

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : Extent3D) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end Extent3D

namespace ExternalTextureBindingEntry

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field ExternalTextureBindingEntry) := [
  ⟨8, .u32, fun _ => (CEnum.toC SType.externalTextureBindingEntry).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 16]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (_ : ExternalTextureBindingEntry) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 (CEnum.toC SType.externalTextureBindingEntry) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : ExternalTextureBindingEntry) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : ExternalTextureBindingEntry) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : ExternalTextureBindingEntry) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨16, .object⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 2,
  0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : ExternalTextureBindingEntry) : Array Target :=
  #[.object (Internal.ExternalTexture.toObject d.externalTexture)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : ExternalTextureBindingEntry) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field ExternalTextureBindingEntry) := [
  ⟨4, .u32, fun _ => (CEnum.toC SType.externalTextureBindingEntry).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (_ : ExternalTextureBindingEntry) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 4 (CEnum.toC SType.externalTextureBindingEntry) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : ExternalTextureBindingEntry) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : ExternalTextureBindingEntry) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : ExternalTextureBindingEntry) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .object⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : ExternalTextureBindingEntry) : Array Target :=
  #[.object (Internal.ExternalTexture.toObject d.externalTexture)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : ExternalTextureBindingEntry) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : ExternalTextureBindingEntry) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : ExternalTextureBindingEntry) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 10

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ExternalTextureBindingEntry) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end ExternalTextureBindingEntry

namespace ExternalTextureBindingLayout

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field ExternalTextureBindingLayout) := [
  ⟨8, .u32, fun _ => (CEnum.toC SType.externalTextureBindingLayout).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 16 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (_ : ExternalTextureBindingLayout) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 8
      (CEnum.toC SType.externalTextureBindingLayout)
      (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : ExternalTextureBindingLayout) :
    encode64 d = Encode.encode .bits64 16 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : ExternalTextureBindingLayout) :
    (encode64 d).size = 16 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : ExternalTextureBindingLayout) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 16 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : ExternalTextureBindingLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : ExternalTextureBindingLayout) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field ExternalTextureBindingLayout) := [
  ⟨4, .u32, fun _ => (CEnum.toC SType.externalTextureBindingLayout).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 8 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 8 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (_ : ExternalTextureBindingLayout) : ByteArray :=
  let b := Block.fresh 8
  let b := b.pokeU32 4
      (CEnum.toC SType.externalTextureBindingLayout)
      (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : ExternalTextureBindingLayout) :
    encode32 d = Encode.encode .bits32 8 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : ExternalTextureBindingLayout) :
    (encode32 d).size = 8 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : ExternalTextureBindingLayout) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  8, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 8 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : ExternalTextureBindingLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : ExternalTextureBindingLayout) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : ExternalTextureBindingLayout) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : ExternalTextureBindingLayout) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 11

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ExternalTextureBindingLayout) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end ExternalTextureBindingLayout

namespace Future

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field Future) := [
  ⟨0, .u64, fun d => (d.id).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 8 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 8 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : Future) : ByteArray :=
  let b := Block.fresh 8
  let b := b.pokeU64 0 d.id (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : Future) :
    encode64 d = Encode.encode .bits64 8 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : Future) :
    (encode64 d).size = 8 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : Future) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := []

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  8, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 8 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : Future) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : Future) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field Future) := [
  ⟨0, .u64, fun d => (d.id).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 8 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 8 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : Future) : ByteArray :=
  let b := Block.fresh 8
  let b := b.pokeU64 0 d.id (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : Future) :
    encode32 d = Encode.encode .bits32 8 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : Future) :
    (encode32 d).size = 8 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : Future) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := []

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  8, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 8 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : Future) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : Future) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : Future) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : Future) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 12

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : Future) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end Future

namespace InstanceLimits

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field InstanceLimits) := [
  ⟨8, .size, fun d => (d.timedWaitAnyMaxCount).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 16 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : InstanceLimits) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU64 8 d.timedWaitAnyMaxCount (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : InstanceLimits) :
    encode64 d = Encode.encode .bits64 16 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : InstanceLimits) :
    (encode64 d).size = 16 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : InstanceLimits) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 16 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : InstanceLimits) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : InstanceLimits) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field InstanceLimits) := [
  ⟨4, .size, fun d => (size32 d.timedWaitAnyMaxCount).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 8 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 8 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : InstanceLimits) : ByteArray :=
  let b := Block.fresh 8
  let b := b.pokeU32 4 (size32 d.timedWaitAnyMaxCount) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : InstanceLimits) :
    encode32 d = Encode.encode .bits32 8 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : InstanceLimits) :
    (encode32 d).size = 8 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : InstanceLimits) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  8, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 8 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : InstanceLimits) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : InstanceLimits) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (d : InstanceLimits) : Bool :=
  System.Platform.numBits = 64 || sizeFits d.timedWaitAnyMaxCount

/--
`d` as C lays it out on this target, its pointers 0. The caller checks
`sizesFit d` first: on wasm32, a `size_t` that does not fit is cut to its
low 32 bits.
-/
@[inline]
def toBytes (d : InstanceLimits) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 13

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : InstanceLimits) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end InstanceLimits

namespace Limits

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field Limits) := [
  ⟨8, .u32, fun d => (d.maxTextureDimension1D).toNat⟩,
  ⟨12, .u32, fun d => (d.maxTextureDimension2D).toNat⟩,
  ⟨16, .u32, fun d => (d.maxTextureDimension3D).toNat⟩,
  ⟨20, .u32, fun d => (d.maxTextureArrayLayers).toNat⟩,
  ⟨24, .u32, fun d => (d.maxBindGroups).toNat⟩,
  ⟨28, .u32, fun d => (d.maxBindGroupsPlusVertexBuffers).toNat⟩,
  ⟨32, .u32, fun d => (d.maxBindingsPerBindGroup).toNat⟩,
  ⟨36, .u32, fun d => (d.maxDynamicUniformBuffersPerPipelineLayout).toNat⟩,
  ⟨40, .u32, fun d => (d.maxDynamicStorageBuffersPerPipelineLayout).toNat⟩,
  ⟨44, .u32, fun d => (d.maxSampledTexturesPerShaderStage).toNat⟩,
  ⟨48, .u32, fun d => (d.maxSamplersPerShaderStage).toNat⟩,
  ⟨52, .u32, fun d => (d.maxStorageBuffersPerShaderStage).toNat⟩,
  ⟨56, .u32, fun d => (d.maxStorageTexturesPerShaderStage).toNat⟩,
  ⟨60, .u32, fun d => (d.maxUniformBuffersPerShaderStage).toNat⟩,
  ⟨64, .u64, fun d => (d.maxUniformBufferBindingSize).toNat⟩,
  ⟨72, .u64, fun d => (d.maxStorageBufferBindingSize).toNat⟩,
  ⟨80, .u32, fun d => (d.minUniformBufferOffsetAlignment).toNat⟩,
  ⟨84, .u32, fun d => (d.minStorageBufferOffsetAlignment).toNat⟩,
  ⟨88, .u32, fun d => (d.maxVertexBuffers).toNat⟩,
  ⟨96, .u64, fun d => (d.maxBufferSize).toNat⟩,
  ⟨104, .u32, fun d => (d.maxVertexAttributes).toNat⟩,
  ⟨108, .u32, fun d => (d.maxVertexBufferArrayStride).toNat⟩,
  ⟨112, .u32, fun d => (d.maxInterStageShaderVariables).toNat⟩,
  ⟨116, .u32, fun d => (d.maxColorAttachments).toNat⟩,
  ⟨120, .u32, fun d => (d.maxColorAttachmentBytesPerSample).toNat⟩,
  ⟨124, .u32, fun d => (d.maxComputeWorkgroupStorageSize).toNat⟩,
  ⟨128, .u32, fun d => (d.maxComputeInvocationsPerWorkgroup).toNat⟩,
  ⟨132, .u32, fun d => (d.maxComputeWorkgroupSizeX).toNat⟩,
  ⟨136, .u32, fun d => (d.maxComputeWorkgroupSizeY).toNat⟩,
  ⟨140, .u32, fun d => (d.maxComputeWorkgroupSizeZ).toNat⟩,
  ⟨144, .u32, fun d => (d.maxComputeWorkgroupsPerDimension).toNat⟩,
  ⟨148, .u32, fun d => (d.maxImmediateSize).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 152 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 152 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : Limits) : ByteArray :=
  let b := Block.fresh 152
  let b := b.pokeU32 8 d.maxTextureDimension1D (by decide)
  let b := b.pokeU32 12 d.maxTextureDimension2D (by decide)
  let b := b.pokeU32 16 d.maxTextureDimension3D (by decide)
  let b := b.pokeU32 20 d.maxTextureArrayLayers (by decide)
  let b := b.pokeU32 24 d.maxBindGroups (by decide)
  let b := b.pokeU32 28 d.maxBindGroupsPlusVertexBuffers (by decide)
  let b := b.pokeU32 32 d.maxBindingsPerBindGroup (by decide)
  let b := b.pokeU32 36 d.maxDynamicUniformBuffersPerPipelineLayout (by decide)
  let b := b.pokeU32 40 d.maxDynamicStorageBuffersPerPipelineLayout (by decide)
  let b := b.pokeU32 44 d.maxSampledTexturesPerShaderStage (by decide)
  let b := b.pokeU32 48 d.maxSamplersPerShaderStage (by decide)
  let b := b.pokeU32 52 d.maxStorageBuffersPerShaderStage (by decide)
  let b := b.pokeU32 56 d.maxStorageTexturesPerShaderStage (by decide)
  let b := b.pokeU32 60 d.maxUniformBuffersPerShaderStage (by decide)
  let b := b.pokeU64 64 d.maxUniformBufferBindingSize (by decide)
  let b := b.pokeU64 72 d.maxStorageBufferBindingSize (by decide)
  let b := b.pokeU32 80 d.minUniformBufferOffsetAlignment (by decide)
  let b := b.pokeU32 84 d.minStorageBufferOffsetAlignment (by decide)
  let b := b.pokeU32 88 d.maxVertexBuffers (by decide)
  let b := b.pokeU64 96 d.maxBufferSize (by decide)
  let b := b.pokeU32 104 d.maxVertexAttributes (by decide)
  let b := b.pokeU32 108 d.maxVertexBufferArrayStride (by decide)
  let b := b.pokeU32 112 d.maxInterStageShaderVariables (by decide)
  let b := b.pokeU32 116 d.maxColorAttachments (by decide)
  let b := b.pokeU32 120 d.maxColorAttachmentBytesPerSample (by decide)
  let b := b.pokeU32 124 d.maxComputeWorkgroupStorageSize (by decide)
  let b := b.pokeU32 128 d.maxComputeInvocationsPerWorkgroup (by decide)
  let b := b.pokeU32 132 d.maxComputeWorkgroupSizeX (by decide)
  let b := b.pokeU32 136 d.maxComputeWorkgroupSizeY (by decide)
  let b := b.pokeU32 140 d.maxComputeWorkgroupSizeZ (by decide)
  let b := b.pokeU32 144 d.maxComputeWorkgroupsPerDimension (by decide)
  let b := b.pokeU32 148 d.maxImmediateSize (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : Limits) :
    encode64 d = Encode.encode .bits64 152 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : Limits) :
    (encode64 d).size = 152 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : Limits) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  152, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 152 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : Limits) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : Limits) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field Limits) := [
  ⟨4, .u32, fun d => (d.maxTextureDimension1D).toNat⟩,
  ⟨8, .u32, fun d => (d.maxTextureDimension2D).toNat⟩,
  ⟨12, .u32, fun d => (d.maxTextureDimension3D).toNat⟩,
  ⟨16, .u32, fun d => (d.maxTextureArrayLayers).toNat⟩,
  ⟨20, .u32, fun d => (d.maxBindGroups).toNat⟩,
  ⟨24, .u32, fun d => (d.maxBindGroupsPlusVertexBuffers).toNat⟩,
  ⟨28, .u32, fun d => (d.maxBindingsPerBindGroup).toNat⟩,
  ⟨32, .u32, fun d => (d.maxDynamicUniformBuffersPerPipelineLayout).toNat⟩,
  ⟨36, .u32, fun d => (d.maxDynamicStorageBuffersPerPipelineLayout).toNat⟩,
  ⟨40, .u32, fun d => (d.maxSampledTexturesPerShaderStage).toNat⟩,
  ⟨44, .u32, fun d => (d.maxSamplersPerShaderStage).toNat⟩,
  ⟨48, .u32, fun d => (d.maxStorageBuffersPerShaderStage).toNat⟩,
  ⟨52, .u32, fun d => (d.maxStorageTexturesPerShaderStage).toNat⟩,
  ⟨56, .u32, fun d => (d.maxUniformBuffersPerShaderStage).toNat⟩,
  ⟨64, .u64, fun d => (d.maxUniformBufferBindingSize).toNat⟩,
  ⟨72, .u64, fun d => (d.maxStorageBufferBindingSize).toNat⟩,
  ⟨80, .u32, fun d => (d.minUniformBufferOffsetAlignment).toNat⟩,
  ⟨84, .u32, fun d => (d.minStorageBufferOffsetAlignment).toNat⟩,
  ⟨88, .u32, fun d => (d.maxVertexBuffers).toNat⟩,
  ⟨96, .u64, fun d => (d.maxBufferSize).toNat⟩,
  ⟨104, .u32, fun d => (d.maxVertexAttributes).toNat⟩,
  ⟨108, .u32, fun d => (d.maxVertexBufferArrayStride).toNat⟩,
  ⟨112, .u32, fun d => (d.maxInterStageShaderVariables).toNat⟩,
  ⟨116, .u32, fun d => (d.maxColorAttachments).toNat⟩,
  ⟨120, .u32, fun d => (d.maxColorAttachmentBytesPerSample).toNat⟩,
  ⟨124, .u32, fun d => (d.maxComputeWorkgroupStorageSize).toNat⟩,
  ⟨128, .u32, fun d => (d.maxComputeInvocationsPerWorkgroup).toNat⟩,
  ⟨132, .u32, fun d => (d.maxComputeWorkgroupSizeX).toNat⟩,
  ⟨136, .u32, fun d => (d.maxComputeWorkgroupSizeY).toNat⟩,
  ⟨140, .u32, fun d => (d.maxComputeWorkgroupSizeZ).toNat⟩,
  ⟨144, .u32, fun d => (d.maxComputeWorkgroupsPerDimension).toNat⟩,
  ⟨148, .u32, fun d => (d.maxImmediateSize).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 152 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 152 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : Limits) : ByteArray :=
  let b := Block.fresh 152
  let b := b.pokeU32 4 d.maxTextureDimension1D (by decide)
  let b := b.pokeU32 8 d.maxTextureDimension2D (by decide)
  let b := b.pokeU32 12 d.maxTextureDimension3D (by decide)
  let b := b.pokeU32 16 d.maxTextureArrayLayers (by decide)
  let b := b.pokeU32 20 d.maxBindGroups (by decide)
  let b := b.pokeU32 24 d.maxBindGroupsPlusVertexBuffers (by decide)
  let b := b.pokeU32 28 d.maxBindingsPerBindGroup (by decide)
  let b := b.pokeU32 32 d.maxDynamicUniformBuffersPerPipelineLayout (by decide)
  let b := b.pokeU32 36 d.maxDynamicStorageBuffersPerPipelineLayout (by decide)
  let b := b.pokeU32 40 d.maxSampledTexturesPerShaderStage (by decide)
  let b := b.pokeU32 44 d.maxSamplersPerShaderStage (by decide)
  let b := b.pokeU32 48 d.maxStorageBuffersPerShaderStage (by decide)
  let b := b.pokeU32 52 d.maxStorageTexturesPerShaderStage (by decide)
  let b := b.pokeU32 56 d.maxUniformBuffersPerShaderStage (by decide)
  let b := b.pokeU64 64 d.maxUniformBufferBindingSize (by decide)
  let b := b.pokeU64 72 d.maxStorageBufferBindingSize (by decide)
  let b := b.pokeU32 80 d.minUniformBufferOffsetAlignment (by decide)
  let b := b.pokeU32 84 d.minStorageBufferOffsetAlignment (by decide)
  let b := b.pokeU32 88 d.maxVertexBuffers (by decide)
  let b := b.pokeU64 96 d.maxBufferSize (by decide)
  let b := b.pokeU32 104 d.maxVertexAttributes (by decide)
  let b := b.pokeU32 108 d.maxVertexBufferArrayStride (by decide)
  let b := b.pokeU32 112 d.maxInterStageShaderVariables (by decide)
  let b := b.pokeU32 116 d.maxColorAttachments (by decide)
  let b := b.pokeU32 120 d.maxColorAttachmentBytesPerSample (by decide)
  let b := b.pokeU32 124 d.maxComputeWorkgroupStorageSize (by decide)
  let b := b.pokeU32 128 d.maxComputeInvocationsPerWorkgroup (by decide)
  let b := b.pokeU32 132 d.maxComputeWorkgroupSizeX (by decide)
  let b := b.pokeU32 136 d.maxComputeWorkgroupSizeY (by decide)
  let b := b.pokeU32 140 d.maxComputeWorkgroupSizeZ (by decide)
  let b := b.pokeU32 144 d.maxComputeWorkgroupsPerDimension (by decide)
  let b := b.pokeU32 148 d.maxImmediateSize (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : Limits) :
    encode32 d = Encode.encode .bits32 152 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : Limits) :
    (encode32 d).size = 152 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : Limits) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  152, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 152 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : Limits) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : Limits) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : Limits) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : Limits) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 14

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : Limits) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end Limits

namespace MultisampleState

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field MultisampleState) := [
  ⟨8, .u32, fun d => (d.count).toNat⟩,
  ⟨12, .u32, fun d => (d.mask).toNat⟩,
  ⟨16, .u32, fun d => (wgpuBool d.alphaToCoverageEnabled).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : MultisampleState) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 d.count (by decide)
  let b := b.pokeU32 12 d.mask (by decide)
  let b := b.pokeU32 16 (wgpuBool d.alphaToCoverageEnabled) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : MultisampleState) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : MultisampleState) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : MultisampleState) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : MultisampleState) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : MultisampleState) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field MultisampleState) := [
  ⟨4, .u32, fun d => (d.count).toNat⟩,
  ⟨8, .u32, fun d => (d.mask).toNat⟩,
  ⟨12, .u32, fun d => (wgpuBool d.alphaToCoverageEnabled).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : MultisampleState) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 4 d.count (by decide)
  let b := b.pokeU32 8 d.mask (by decide)
  let b := b.pokeU32 12 (wgpuBool d.alphaToCoverageEnabled) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : MultisampleState) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : MultisampleState) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : MultisampleState) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : MultisampleState) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : MultisampleState) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : MultisampleState) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : MultisampleState) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 15

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : MultisampleState) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end MultisampleState

namespace Origin3D

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field Origin3D) := [
  ⟨0, .u32, fun d => (d.x).toNat⟩,
  ⟨4, .u32, fun d => (d.y).toNat⟩,
  ⟨8, .u32, fun d => (d.z).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 12 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : Origin3D) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 0 d.x (by decide)
  let b := b.pokeU32 4 d.y (by decide)
  let b := b.pokeU32 8 d.z (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : Origin3D) :
    encode64 d = Encode.encode .bits64 12 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : Origin3D) :
    (encode64 d).size = 12 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : Origin3D) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := []

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  12, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 12 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : Origin3D) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : Origin3D) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field Origin3D) := [
  ⟨0, .u32, fun d => (d.x).toNat⟩,
  ⟨4, .u32, fun d => (d.y).toNat⟩,
  ⟨8, .u32, fun d => (d.z).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : Origin3D) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 0 d.x (by decide)
  let b := b.pokeU32 4 d.y (by decide)
  let b := b.pokeU32 8 d.z (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : Origin3D) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : Origin3D) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : Origin3D) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := []

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : Origin3D) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : Origin3D) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : Origin3D) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : Origin3D) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 16

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : Origin3D) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end Origin3D

namespace PassTimestampWrites

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field PassTimestampWrites) := [
  ⟨16, .u32, fun d => (d.beginningOfPassWriteIndex).toNat⟩,
  ⟨20, .u32, fun d => (d.endOfPassWriteIndex).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : PassTimestampWrites) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 16 d.beginningOfPassWriteIndex (by decide)
  let b := b.pokeU32 20 d.endOfPassWriteIndex (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : PassTimestampWrites) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : PassTimestampWrites) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : PassTimestampWrites) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .object⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : PassTimestampWrites) : Array Target :=
  #[.object (Internal.QuerySet.toObject d.querySet)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : PassTimestampWrites) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field PassTimestampWrites) := [
  ⟨8, .u32, fun d => (d.beginningOfPassWriteIndex).toNat⟩,
  ⟨12, .u32, fun d => (d.endOfPassWriteIndex).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : PassTimestampWrites) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 8 d.beginningOfPassWriteIndex (by decide)
  let b := b.pokeU32 12 d.endOfPassWriteIndex (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : PassTimestampWrites) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : PassTimestampWrites) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : PassTimestampWrites) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .object⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : PassTimestampWrites) : Array Target :=
  #[.object (Internal.QuerySet.toObject d.querySet)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : PassTimestampWrites) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : PassTimestampWrites) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : PassTimestampWrites) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 17

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : PassTimestampWrites) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end PassTimestampWrites

namespace PipelineLayoutDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field PipelineLayoutDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .size, fun d => (d.bindGroupLayouts.size.toUInt64).toNat⟩,
  ⟨40, .u32, fun d => (d.immediateSize).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 32]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 48 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 48 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : PipelineLayoutDescriptor) : ByteArray :=
  let b := Block.fresh 48
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU64 24 d.bindGroupLayouts.size.toUInt64 (by decide)
  let b := b.pokeU32 40 d.immediateSize (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : PipelineLayoutDescriptor) :
    encode64 d = Encode.encode .bits64 48 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : PipelineLayoutDescriptor) :
    (encode64 d).size = 48 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : PipelineLayoutDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field PipelineLayoutDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨12, .size, fun d => (d.bindGroupLayouts.size.toUInt32).toNat⟩,
  ⟨20, .u32, fun d => (d.immediateSize).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 16]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : PipelineLayoutDescriptor) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 12 d.bindGroupLayouts.size.toUInt32 (by decide)
  let b := b.pokeU32 20 d.immediateSize (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : PipelineLayoutDescriptor) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : PipelineLayoutDescriptor) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : PipelineLayoutDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : PipelineLayoutDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : PipelineLayoutDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end PipelineLayoutDescriptor

namespace PrimitiveState

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field PrimitiveState) := [
  ⟨8, .u32, fun d => (CEnum.toC d.topology).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.stripIndexFormat).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.frontFace).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.cullMode).toNat⟩,
  ⟨24, .u32, fun d => (wgpuBool d.unclippedDepth).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : PrimitiveState) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 8 (CEnum.toC d.topology) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.stripIndexFormat) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.frontFace) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.cullMode) (by decide)
  let b := b.pokeU32 24 (wgpuBool d.unclippedDepth) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : PrimitiveState) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : PrimitiveState) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : PrimitiveState) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : PrimitiveState) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : PrimitiveState) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field PrimitiveState) := [
  ⟨4, .u32, fun d => (CEnum.toC d.topology).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.stripIndexFormat).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.frontFace).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.cullMode).toNat⟩,
  ⟨20, .u32, fun d => (wgpuBool d.unclippedDepth).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : PrimitiveState) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 4 (CEnum.toC d.topology) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.stripIndexFormat) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.frontFace) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.cullMode) (by decide)
  let b := b.pokeU32 20 (wgpuBool d.unclippedDepth) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : PrimitiveState) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : PrimitiveState) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : PrimitiveState) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : PrimitiveState) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : PrimitiveState) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : PrimitiveState) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : PrimitiveState) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 18

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : PrimitiveState) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end PrimitiveState

namespace QuerySetDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field QuerySetDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .u32, fun d => (CEnum.toC d.type).toNat⟩,
  ⟨28, .u32, fun d => (d.count).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : QuerySetDescriptor) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU32 24 (CEnum.toC d.type) (by decide)
  let b := b.pokeU32 28 d.count (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : QuerySetDescriptor) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : QuerySetDescriptor) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : QuerySetDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : QuerySetDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : QuerySetDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field QuerySetDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.type).toNat⟩,
  ⟨16, .u32, fun d => (d.count).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 20 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 20 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : QuerySetDescriptor) : ByteArray :=
  let b := Block.fresh 20
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.type) (by decide)
  let b := b.pokeU32 16 d.count (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : QuerySetDescriptor) :
    encode32 d = Encode.encode .bits32 20 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : QuerySetDescriptor) :
    (encode32 d).size = 20 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : QuerySetDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  20, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 20 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : QuerySetDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : QuerySetDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : QuerySetDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : QuerySetDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 19

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : QuerySetDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end QuerySetDescriptor

namespace QueueDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field QueueDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : QueueDescriptor) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : QueueDescriptor) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : QueueDescriptor) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : QueueDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : QueueDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : QueueDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field QueueDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : QueueDescriptor) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : QueueDescriptor) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : QueueDescriptor) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : QueueDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : QueueDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : QueueDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : QueueDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : QueueDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 20

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : QueueDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end QueueDescriptor

namespace RenderBundleDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field RenderBundleDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : RenderBundleDescriptor) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : RenderBundleDescriptor) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : RenderBundleDescriptor) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : RenderBundleDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : RenderBundleDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : RenderBundleDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field RenderBundleDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : RenderBundleDescriptor) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : RenderBundleDescriptor) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : RenderBundleDescriptor) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : RenderBundleDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : RenderBundleDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : RenderBundleDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : RenderBundleDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : RenderBundleDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 21

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderBundleDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end RenderBundleDescriptor

namespace RenderBundleEncoderDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field RenderBundleEncoderDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .size, fun d => (d.colorFormats.size.toUInt64).toNat⟩,
  ⟨40, .u32, fun d => (CEnum.toC d.depthStencilFormat).toNat⟩,
  ⟨44, .u32, fun d => (d.sampleCount).toNat⟩,
  ⟨48, .u32, fun d => (wgpuBool d.depthReadOnly).toNat⟩,
  ⟨52, .u32, fun d => (wgpuBool d.stencilReadOnly).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 32]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 56 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 56 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : RenderBundleEncoderDescriptor) : ByteArray :=
  let b := Block.fresh 56
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU64 24 d.colorFormats.size.toUInt64 (by decide)
  let b := b.pokeU32 40 (CEnum.toC d.depthStencilFormat) (by decide)
  let b := b.pokeU32 44 d.sampleCount (by decide)
  let b := b.pokeU32 48 (wgpuBool d.depthReadOnly) (by decide)
  let b := b.pokeU32 52 (wgpuBool d.stencilReadOnly) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : RenderBundleEncoderDescriptor) :
    encode64 d = Encode.encode .bits64 56 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : RenderBundleEncoderDescriptor) :
    (encode64 d).size = 56 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : RenderBundleEncoderDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field RenderBundleEncoderDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨12, .size, fun d => (d.colorFormats.size.toUInt32).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.depthStencilFormat).toNat⟩,
  ⟨24, .u32, fun d => (d.sampleCount).toNat⟩,
  ⟨28, .u32, fun d => (wgpuBool d.depthReadOnly).toNat⟩,
  ⟨32, .u32, fun d => (wgpuBool d.stencilReadOnly).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 16]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 36 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 36 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : RenderBundleEncoderDescriptor) : ByteArray :=
  let b := Block.fresh 36
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 12 d.colorFormats.size.toUInt32 (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.depthStencilFormat) (by decide)
  let b := b.pokeU32 24 d.sampleCount (by decide)
  let b := b.pokeU32 28 (wgpuBool d.depthReadOnly) (by decide)
  let b := b.pokeU32 32 (wgpuBool d.stencilReadOnly) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : RenderBundleEncoderDescriptor) :
    encode32 d = Encode.encode .bits32 36 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : RenderBundleEncoderDescriptor) :
    (encode32 d).size = 36 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : RenderBundleEncoderDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : RenderBundleEncoderDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : RenderBundleEncoderDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end RenderBundleEncoderDescriptor

namespace RenderPassDepthStencilAttachment

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field RenderPassDepthStencilAttachment) := [
  ⟨16, .u32, fun d => (CEnum.toC d.depthLoadOp).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.depthStoreOp).toNat⟩,
  ⟨24, .f32, fun d => (nanOr d.depthClearValue).toNat⟩,
  ⟨28, .u32, fun d => (wgpuBool d.depthReadOnly).toNat⟩,
  ⟨32, .u32, fun d => (CEnum.toC d.stencilLoadOp).toNat⟩,
  ⟨36, .u32, fun d => (CEnum.toC d.stencilStoreOp).toNat⟩,
  ⟨40, .u32, fun d => (d.stencilClearValue).toNat⟩,
  ⟨44, .u32, fun d => (wgpuBool d.stencilReadOnly).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 48 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 48 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : RenderPassDepthStencilAttachment) : ByteArray :=
  let b := Block.fresh 48
  let b := b.pokeU32 16 (CEnum.toC d.depthLoadOp) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.depthStoreOp) (by decide)
  let b := b.pokeU32 24 (nanOr d.depthClearValue) (by decide)
  let b := b.pokeU32 28 (wgpuBool d.depthReadOnly) (by decide)
  let b := b.pokeU32 32 (CEnum.toC d.stencilLoadOp) (by decide)
  let b := b.pokeU32 36 (CEnum.toC d.stencilStoreOp) (by decide)
  let b := b.pokeU32 40 d.stencilClearValue (by decide)
  let b := b.pokeU32 44 (wgpuBool d.stencilReadOnly) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : RenderPassDepthStencilAttachment) :
    encode64 d = Encode.encode .bits64 48 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : RenderPassDepthStencilAttachment) :
    (encode64 d).size = 48 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : RenderPassDepthStencilAttachment) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .object⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  48, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 48 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : RenderPassDepthStencilAttachment) : Array Target :=
  #[.object (Internal.TextureView.toObject d.view)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : RenderPassDepthStencilAttachment) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field RenderPassDepthStencilAttachment) := [
  ⟨8, .u32, fun d => (CEnum.toC d.depthLoadOp).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.depthStoreOp).toNat⟩,
  ⟨16, .f32, fun d => (nanOr d.depthClearValue).toNat⟩,
  ⟨20, .u32, fun d => (wgpuBool d.depthReadOnly).toNat⟩,
  ⟨24, .u32, fun d => (CEnum.toC d.stencilLoadOp).toNat⟩,
  ⟨28, .u32, fun d => (CEnum.toC d.stencilStoreOp).toNat⟩,
  ⟨32, .u32, fun d => (d.stencilClearValue).toNat⟩,
  ⟨36, .u32, fun d => (wgpuBool d.stencilReadOnly).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 40 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 40 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : RenderPassDepthStencilAttachment) : ByteArray :=
  let b := Block.fresh 40
  let b := b.pokeU32 8 (CEnum.toC d.depthLoadOp) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.depthStoreOp) (by decide)
  let b := b.pokeU32 16 (nanOr d.depthClearValue) (by decide)
  let b := b.pokeU32 20 (wgpuBool d.depthReadOnly) (by decide)
  let b := b.pokeU32 24 (CEnum.toC d.stencilLoadOp) (by decide)
  let b := b.pokeU32 28 (CEnum.toC d.stencilStoreOp) (by decide)
  let b := b.pokeU32 32 d.stencilClearValue (by decide)
  let b := b.pokeU32 36 (wgpuBool d.stencilReadOnly) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : RenderPassDepthStencilAttachment) :
    encode32 d = Encode.encode .bits32 40 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : RenderPassDepthStencilAttachment) :
    (encode32 d).size = 40 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : RenderPassDepthStencilAttachment) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .object⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  40, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 40 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : RenderPassDepthStencilAttachment) : Array Target :=
  #[.object (Internal.TextureView.toObject d.view)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : RenderPassDepthStencilAttachment) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : RenderPassDepthStencilAttachment) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : RenderPassDepthStencilAttachment) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 22

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderPassDepthStencilAttachment) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end RenderPassDepthStencilAttachment

namespace RenderPassMaxDrawCount

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field RenderPassMaxDrawCount) := [
  ⟨8, .u32, fun _ => (CEnum.toC SType.renderPassMaxDrawCount).toNat⟩,
  ⟨16, .u64, fun d => (d.maxDrawCount).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : RenderPassMaxDrawCount) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 (CEnum.toC SType.renderPassMaxDrawCount) (by decide)
  let b := b.pokeU64 16 d.maxDrawCount (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : RenderPassMaxDrawCount) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : RenderPassMaxDrawCount) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : RenderPassMaxDrawCount) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : RenderPassMaxDrawCount) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : RenderPassMaxDrawCount) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field RenderPassMaxDrawCount) := [
  ⟨4, .u32, fun _ => (CEnum.toC SType.renderPassMaxDrawCount).toNat⟩,
  ⟨8, .u64, fun d => (d.maxDrawCount).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : RenderPassMaxDrawCount) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 4 (CEnum.toC SType.renderPassMaxDrawCount) (by decide)
  let b := b.pokeU64 8 d.maxDrawCount (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : RenderPassMaxDrawCount) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : RenderPassMaxDrawCount) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : RenderPassMaxDrawCount) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : RenderPassMaxDrawCount) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : RenderPassMaxDrawCount) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : RenderPassMaxDrawCount) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : RenderPassMaxDrawCount) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 23

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderPassMaxDrawCount) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end RenderPassMaxDrawCount

namespace RequestAdapterOptions

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field RequestAdapterOptions) := [
  ⟨8, .u32, fun d => (CEnum.toC d.featureLevel).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.powerPreference).toNat⟩,
  ⟨16, .u32, fun d => (wgpuBool d.forceFallbackAdapter).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.backendType).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 24]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : RequestAdapterOptions) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 8 (CEnum.toC d.featureLevel) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.powerPreference) (by decide)
  let b := b.pokeU32 16 (wgpuBool d.forceFallbackAdapter) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.backendType) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : RequestAdapterOptions) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : RequestAdapterOptions) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : RequestAdapterOptions) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨24, .optObject⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 3,
  0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : RequestAdapterOptions) : Array Target :=
  #[.optObject (d.compatibleSurface.map Internal.Surface.toObject)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : RequestAdapterOptions) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field RequestAdapterOptions) := [
  ⟨4, .u32, fun d => (CEnum.toC d.featureLevel).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.powerPreference).toNat⟩,
  ⟨12, .u32, fun d => (wgpuBool d.forceFallbackAdapter).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.backendType).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 20]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : RequestAdapterOptions) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 4 (CEnum.toC d.featureLevel) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.powerPreference) (by decide)
  let b := b.pokeU32 12 (wgpuBool d.forceFallbackAdapter) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.backendType) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : RequestAdapterOptions) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : RequestAdapterOptions) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : RequestAdapterOptions) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨20, .optObject⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 3,
  0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : RequestAdapterOptions) : Array Target :=
  #[.optObject (d.compatibleSurface.map Internal.Surface.toObject)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : RequestAdapterOptions) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : RequestAdapterOptions) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : RequestAdapterOptions) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 24

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RequestAdapterOptions) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end RequestAdapterOptions

namespace RequestAdapterWebXROptions

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field RequestAdapterWebXROptions) := [
  ⟨8, .u32, fun _ => (CEnum.toC SType.requestAdapterWebXROptions).toNat⟩,
  ⟨16, .u32, fun d => (wgpuBool d.xrCompatible).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : RequestAdapterWebXROptions) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 (CEnum.toC SType.requestAdapterWebXROptions) (by decide)
  let b := b.pokeU32 16 (wgpuBool d.xrCompatible) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : RequestAdapterWebXROptions) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : RequestAdapterWebXROptions) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : RequestAdapterWebXROptions) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : RequestAdapterWebXROptions) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : RequestAdapterWebXROptions) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field RequestAdapterWebXROptions) := [
  ⟨4, .u32, fun _ => (CEnum.toC SType.requestAdapterWebXROptions).toNat⟩,
  ⟨8, .u32, fun d => (wgpuBool d.xrCompatible).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : RequestAdapterWebXROptions) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 4 (CEnum.toC SType.requestAdapterWebXROptions) (by decide)
  let b := b.pokeU32 8 (wgpuBool d.xrCompatible) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : RequestAdapterWebXROptions) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : RequestAdapterWebXROptions) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : RequestAdapterWebXROptions) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : RequestAdapterWebXROptions) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : RequestAdapterWebXROptions) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : RequestAdapterWebXROptions) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : RequestAdapterWebXROptions) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 25

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RequestAdapterWebXROptions) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end RequestAdapterWebXROptions

namespace SamplerBindingLayout

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field SamplerBindingLayout) := [
  ⟨8, .u32, fun d => (CEnum.toC d.type).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 16 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : SamplerBindingLayout) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 8 (CEnum.toC d.type) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : SamplerBindingLayout) :
    encode64 d = Encode.encode .bits64 16 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : SamplerBindingLayout) :
    (encode64 d).size = 16 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : SamplerBindingLayout) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 16 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : SamplerBindingLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : SamplerBindingLayout) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field SamplerBindingLayout) := [
  ⟨4, .u32, fun d => (CEnum.toC d.type).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 8 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 8 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : SamplerBindingLayout) : ByteArray :=
  let b := Block.fresh 8
  let b := b.pokeU32 4 (CEnum.toC d.type) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : SamplerBindingLayout) :
    encode32 d = Encode.encode .bits32 8 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : SamplerBindingLayout) :
    (encode32 d).size = 8 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : SamplerBindingLayout) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  8, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 8 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : SamplerBindingLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : SamplerBindingLayout) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : SamplerBindingLayout) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : SamplerBindingLayout) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 26

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SamplerBindingLayout) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end SamplerBindingLayout

namespace SamplerDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field SamplerDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .u32, fun d => (CEnum.toC d.addressModeU).toNat⟩,
  ⟨28, .u32, fun d => (CEnum.toC d.addressModeV).toNat⟩,
  ⟨32, .u32, fun d => (CEnum.toC d.addressModeW).toNat⟩,
  ⟨36, .u32, fun d => (CEnum.toC d.magFilter).toNat⟩,
  ⟨40, .u32, fun d => (CEnum.toC d.minFilter).toNat⟩,
  ⟨44, .u32, fun d => (CEnum.toC d.mipmapFilter).toNat⟩,
  ⟨48, .f32, fun d => (d.lodMinClamp).toBits.toNat⟩,
  ⟨52, .f32, fun d => (d.lodMaxClamp).toBits.toNat⟩,
  ⟨56, .u32, fun d => (CEnum.toC d.compare).toNat⟩,
  ⟨60, .u16, fun d => (d.maxAnisotropy).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 64 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 64 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : SamplerDescriptor) : ByteArray :=
  let b := Block.fresh 64
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU32 24 (CEnum.toC d.addressModeU) (by decide)
  let b := b.pokeU32 28 (CEnum.toC d.addressModeV) (by decide)
  let b := b.pokeU32 32 (CEnum.toC d.addressModeW) (by decide)
  let b := b.pokeU32 36 (CEnum.toC d.magFilter) (by decide)
  let b := b.pokeU32 40 (CEnum.toC d.minFilter) (by decide)
  let b := b.pokeU32 44 (CEnum.toC d.mipmapFilter) (by decide)
  let b := b.pokeF32 48 d.lodMinClamp (by decide)
  let b := b.pokeF32 52 d.lodMaxClamp (by decide)
  let b := b.pokeU32 56 (CEnum.toC d.compare) (by decide)
  let b := b.pokeU16 60 d.maxAnisotropy (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : SamplerDescriptor) :
    encode64 d = Encode.encode .bits64 64 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, Block.val_pokeF32, Block.val_pokeU16, List.map,
    Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : SamplerDescriptor) :
    (encode64 d).size = 64 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : SamplerDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  64, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 64 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : SamplerDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : SamplerDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field SamplerDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.addressModeU).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.addressModeV).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.addressModeW).toNat⟩,
  ⟨24, .u32, fun d => (CEnum.toC d.magFilter).toNat⟩,
  ⟨28, .u32, fun d => (CEnum.toC d.minFilter).toNat⟩,
  ⟨32, .u32, fun d => (CEnum.toC d.mipmapFilter).toNat⟩,
  ⟨36, .f32, fun d => (d.lodMinClamp).toBits.toNat⟩,
  ⟨40, .f32, fun d => (d.lodMaxClamp).toBits.toNat⟩,
  ⟨44, .u32, fun d => (CEnum.toC d.compare).toNat⟩,
  ⟨48, .u16, fun d => (d.maxAnisotropy).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 52 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 52 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : SamplerDescriptor) : ByteArray :=
  let b := Block.fresh 52
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.addressModeU) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.addressModeV) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.addressModeW) (by decide)
  let b := b.pokeU32 24 (CEnum.toC d.magFilter) (by decide)
  let b := b.pokeU32 28 (CEnum.toC d.minFilter) (by decide)
  let b := b.pokeU32 32 (CEnum.toC d.mipmapFilter) (by decide)
  let b := b.pokeF32 36 d.lodMinClamp (by decide)
  let b := b.pokeF32 40 d.lodMaxClamp (by decide)
  let b := b.pokeU32 44 (CEnum.toC d.compare) (by decide)
  let b := b.pokeU16 48 d.maxAnisotropy (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : SamplerDescriptor) :
    encode32 d = Encode.encode .bits32 52 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeF32, Block.val_pokeU16, List.map, Field.write, writeAll,
    List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : SamplerDescriptor) :
    (encode32 d).size = 52 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : SamplerDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  52, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 52 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : SamplerDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : SamplerDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : SamplerDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : SamplerDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 27

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SamplerDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end SamplerDescriptor

namespace ShaderModuleDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field ShaderModuleDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : ShaderModuleDescriptor) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : ShaderModuleDescriptor) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : ShaderModuleDescriptor) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : ShaderModuleDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : ShaderModuleDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : ShaderModuleDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field ShaderModuleDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : ShaderModuleDescriptor) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : ShaderModuleDescriptor) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : ShaderModuleDescriptor) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : ShaderModuleDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : ShaderModuleDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : ShaderModuleDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : ShaderModuleDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : ShaderModuleDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 28

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ShaderModuleDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end ShaderModuleDescriptor

namespace ShaderSourceWGSL

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field ShaderSourceWGSL) := [
  ⟨8, .u32, fun _ => (CEnum.toC SType.shaderSourceWGSL).toNat⟩,
  ⟨24, .size, fun d => (d.code.utf8ByteSize.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 16]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : ShaderSourceWGSL) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 8 (CEnum.toC SType.shaderSourceWGSL) (by decide)
  let b := b.pokeU64 24 d.code.utf8ByteSize.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : ShaderSourceWGSL) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : ShaderSourceWGSL) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : ShaderSourceWGSL) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨16, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : ShaderSourceWGSL) : Array Target :=
  #[.string d.code]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : ShaderSourceWGSL) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field ShaderSourceWGSL) := [
  ⟨4, .u32, fun _ => (CEnum.toC SType.shaderSourceWGSL).toNat⟩,
  ⟨12, .size, fun d => (d.code.utf8ByteSize.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : ShaderSourceWGSL) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 4 (CEnum.toC SType.shaderSourceWGSL) (by decide)
  let b := b.pokeU32 12 d.code.utf8ByteSize.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : ShaderSourceWGSL) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : ShaderSourceWGSL) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : ShaderSourceWGSL) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : ShaderSourceWGSL) : Array Target :=
  #[.string d.code]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : ShaderSourceWGSL) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : ShaderSourceWGSL) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : ShaderSourceWGSL) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 29

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ShaderSourceWGSL) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end ShaderSourceWGSL

namespace StencilFaceState

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field StencilFaceState) := [
  ⟨0, .u32, fun d => (CEnum.toC d.compare).toNat⟩,
  ⟨4, .u32, fun d => (CEnum.toC d.failOp).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.depthFailOp).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.passOp).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 16 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : StencilFaceState) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 0 (CEnum.toC d.compare) (by decide)
  let b := b.pokeU32 4 (CEnum.toC d.failOp) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.depthFailOp) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.passOp) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : StencilFaceState) :
    encode64 d = Encode.encode .bits64 16 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : StencilFaceState) :
    (encode64 d).size = 16 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : StencilFaceState) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := []

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  16, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 16 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : StencilFaceState) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : StencilFaceState) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field StencilFaceState) := [
  ⟨0, .u32, fun d => (CEnum.toC d.compare).toNat⟩,
  ⟨4, .u32, fun d => (CEnum.toC d.failOp).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.depthFailOp).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.passOp).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : StencilFaceState) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 0 (CEnum.toC d.compare) (by decide)
  let b := b.pokeU32 4 (CEnum.toC d.failOp) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.depthFailOp) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.passOp) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : StencilFaceState) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : StencilFaceState) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : StencilFaceState) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := []

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : StencilFaceState) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : StencilFaceState) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : StencilFaceState) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : StencilFaceState) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 30

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : StencilFaceState) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end StencilFaceState

namespace StorageTextureBindingLayout

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field StorageTextureBindingLayout) := [
  ⟨8, .u32, fun d => (CEnum.toC d.access).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.viewDimension).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : StorageTextureBindingLayout) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 (CEnum.toC d.access) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.format) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.viewDimension) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : StorageTextureBindingLayout) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : StorageTextureBindingLayout) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : StorageTextureBindingLayout) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : StorageTextureBindingLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : StorageTextureBindingLayout) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field StorageTextureBindingLayout) := [
  ⟨4, .u32, fun d => (CEnum.toC d.access).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.viewDimension).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : StorageTextureBindingLayout) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 4 (CEnum.toC d.access) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.format) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.viewDimension) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : StorageTextureBindingLayout) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : StorageTextureBindingLayout) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : StorageTextureBindingLayout) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : StorageTextureBindingLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : StorageTextureBindingLayout) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : StorageTextureBindingLayout) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : StorageTextureBindingLayout) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 31

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : StorageTextureBindingLayout) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end StorageTextureBindingLayout

namespace SupportedFeatures

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field SupportedFeatures) := [
  ⟨0, .size, fun d => (d.features.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 16 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : SupportedFeatures) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU64 0 d.features.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : SupportedFeatures) :
    encode64 d = Encode.encode .bits64 16 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : SupportedFeatures) :
    (encode64 d).size = 16 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : SupportedFeatures) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field SupportedFeatures) := [
  ⟨0, .size, fun d => (d.features.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 8 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 8 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : SupportedFeatures) : ByteArray :=
  let b := Block.fresh 8
  let b := b.pokeU32 0 d.features.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : SupportedFeatures) :
    encode32 d = Encode.encode .bits32 8 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : SupportedFeatures) :
    (encode32 d).size = 8 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : SupportedFeatures) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : SupportedFeatures) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : SupportedFeatures) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end SupportedFeatures

namespace SupportedInstanceFeatures

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field SupportedInstanceFeatures) := [
  ⟨0, .size, fun d => (d.features.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 16 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : SupportedInstanceFeatures) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU64 0 d.features.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : SupportedInstanceFeatures) :
    encode64 d = Encode.encode .bits64 16 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : SupportedInstanceFeatures) :
    (encode64 d).size = 16 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : SupportedInstanceFeatures) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field SupportedInstanceFeatures) := [
  ⟨0, .size, fun d => (d.features.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 8 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 8 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : SupportedInstanceFeatures) : ByteArray :=
  let b := Block.fresh 8
  let b := b.pokeU32 0 d.features.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : SupportedInstanceFeatures) :
    encode32 d = Encode.encode .bits32 8 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : SupportedInstanceFeatures) :
    (encode32 d).size = 8 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : SupportedInstanceFeatures) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : SupportedInstanceFeatures) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : SupportedInstanceFeatures) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end SupportedInstanceFeatures

namespace SupportedWGSLLanguageFeatures

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field SupportedWGSLLanguageFeatures) := [
  ⟨0, .size, fun d => (d.features.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 16 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : SupportedWGSLLanguageFeatures) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU64 0 d.features.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : SupportedWGSLLanguageFeatures) :
    encode64 d = Encode.encode .bits64 16 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : SupportedWGSLLanguageFeatures) :
    (encode64 d).size = 16 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : SupportedWGSLLanguageFeatures) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field SupportedWGSLLanguageFeatures) := [
  ⟨0, .size, fun d => (d.features.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 8 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 8 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : SupportedWGSLLanguageFeatures) : ByteArray :=
  let b := Block.fresh 8
  let b := b.pokeU32 0 d.features.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : SupportedWGSLLanguageFeatures) :
    encode32 d = Encode.encode .bits32 8 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : SupportedWGSLLanguageFeatures) :
    (encode32 d).size = 8 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : SupportedWGSLLanguageFeatures) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : SupportedWGSLLanguageFeatures) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : SupportedWGSLLanguageFeatures) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end SupportedWGSLLanguageFeatures

namespace SurfaceCapabilities

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field SurfaceCapabilities) := [
  ⟨8, .u64, fun d => (d.usages.bits).toNat⟩,
  ⟨16, .size, fun d => (d.formats.size.toUInt64).toNat⟩,
  ⟨32, .size, fun d => (d.presentModes.size.toUInt64).toNat⟩,
  ⟨48, .size, fun d => (d.alphaModes.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 24, 40, 56]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 64 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 64 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : SurfaceCapabilities) : ByteArray :=
  let b := Block.fresh 64
  let b := b.pokeU64 8 d.usages.bits (by decide)
  let b := b.pokeU64 16 d.formats.size.toUInt64 (by decide)
  let b := b.pokeU64 32 d.presentModes.size.toUInt64 (by decide)
  let b := b.pokeU64 48 d.alphaModes.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : SurfaceCapabilities) :
    encode64 d = Encode.encode .bits64 64 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : SurfaceCapabilities) :
    (encode64 d).size = 64 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : SurfaceCapabilities) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field SurfaceCapabilities) := [
  ⟨8, .u64, fun d => (d.usages.bits).toNat⟩,
  ⟨16, .size, fun d => (d.formats.size.toUInt32).toNat⟩,
  ⟨24, .size, fun d => (d.presentModes.size.toUInt32).toNat⟩,
  ⟨32, .size, fun d => (d.alphaModes.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 20, 28, 36]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 40 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 40 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : SurfaceCapabilities) : ByteArray :=
  let b := Block.fresh 40
  let b := b.pokeU64 8 d.usages.bits (by decide)
  let b := b.pokeU32 16 d.formats.size.toUInt32 (by decide)
  let b := b.pokeU32 24 d.presentModes.size.toUInt32 (by decide)
  let b := b.pokeU32 32 d.alphaModes.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : SurfaceCapabilities) :
    encode32 d = Encode.encode .bits32 40 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : SurfaceCapabilities) :
    (encode32 d).size = 40 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : SurfaceCapabilities) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : SurfaceCapabilities) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : SurfaceCapabilities) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end SurfaceCapabilities

namespace SurfaceColorManagement

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field SurfaceColorManagement) := [
  ⟨8, .u32, fun _ => (CEnum.toC SType.surfaceColorManagement).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.colorSpace).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.toneMappingMode).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : SurfaceColorManagement) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 (CEnum.toC SType.surfaceColorManagement) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.colorSpace) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.toneMappingMode) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : SurfaceColorManagement) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : SurfaceColorManagement) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : SurfaceColorManagement) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : SurfaceColorManagement) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : SurfaceColorManagement) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field SurfaceColorManagement) := [
  ⟨4, .u32, fun _ => (CEnum.toC SType.surfaceColorManagement).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.colorSpace).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.toneMappingMode).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : SurfaceColorManagement) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 4 (CEnum.toC SType.surfaceColorManagement) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.colorSpace) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.toneMappingMode) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : SurfaceColorManagement) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : SurfaceColorManagement) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : SurfaceColorManagement) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : SurfaceColorManagement) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : SurfaceColorManagement) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : SurfaceColorManagement) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : SurfaceColorManagement) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 32

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SurfaceColorManagement) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end SurfaceColorManagement

namespace SurfaceConfiguration

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field SurfaceConfiguration) := [
  ⟨16, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨24, .u64, fun d => (d.usage.bits).toNat⟩,
  ⟨32, .u32, fun d => (d.width).toNat⟩,
  ⟨36, .u32, fun d => (d.height).toNat⟩,
  ⟨40, .size, fun d => (d.viewFormats.size.toUInt64).toNat⟩,
  ⟨56, .u32, fun d => (CEnum.toC d.alphaMode).toNat⟩,
  ⟨60, .u32, fun d => (CEnum.toC d.presentMode).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 48]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 64 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 64 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : SurfaceConfiguration) : ByteArray :=
  let b := Block.fresh 64
  let b := b.pokeU32 16 (CEnum.toC d.format) (by decide)
  let b := b.pokeU64 24 d.usage.bits (by decide)
  let b := b.pokeU32 32 d.width (by decide)
  let b := b.pokeU32 36 d.height (by decide)
  let b := b.pokeU64 40 d.viewFormats.size.toUInt64 (by decide)
  let b := b.pokeU32 56 (CEnum.toC d.alphaMode) (by decide)
  let b := b.pokeU32 60 (CEnum.toC d.presentMode) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : SurfaceConfiguration) :
    encode64 d = Encode.encode .bits64 64 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : SurfaceConfiguration) :
    (encode64 d).size = 64 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : SurfaceConfiguration) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field SurfaceConfiguration) := [
  ⟨8, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨16, .u64, fun d => (d.usage.bits).toNat⟩,
  ⟨24, .u32, fun d => (d.width).toNat⟩,
  ⟨28, .u32, fun d => (d.height).toNat⟩,
  ⟨32, .size, fun d => (d.viewFormats.size.toUInt32).toNat⟩,
  ⟨40, .u32, fun d => (CEnum.toC d.alphaMode).toNat⟩,
  ⟨44, .u32, fun d => (CEnum.toC d.presentMode).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 36]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 48 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 48 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : SurfaceConfiguration) : ByteArray :=
  let b := Block.fresh 48
  let b := b.pokeU32 8 (CEnum.toC d.format) (by decide)
  let b := b.pokeU64 16 d.usage.bits (by decide)
  let b := b.pokeU32 24 d.width (by decide)
  let b := b.pokeU32 28 d.height (by decide)
  let b := b.pokeU32 32 d.viewFormats.size.toUInt32 (by decide)
  let b := b.pokeU32 40 (CEnum.toC d.alphaMode) (by decide)
  let b := b.pokeU32 44 (CEnum.toC d.presentMode) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : SurfaceConfiguration) :
    encode32 d = Encode.encode .bits32 48 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : SurfaceConfiguration) :
    (encode32 d).size = 48 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : SurfaceConfiguration) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : SurfaceConfiguration) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : SurfaceConfiguration) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end SurfaceConfiguration

namespace SurfaceDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field SurfaceDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : SurfaceDescriptor) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : SurfaceDescriptor) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : SurfaceDescriptor) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : SurfaceDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : SurfaceDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : SurfaceDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field SurfaceDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : SurfaceDescriptor) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : SurfaceDescriptor) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : SurfaceDescriptor) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : SurfaceDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : SurfaceDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : SurfaceDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : SurfaceDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : SurfaceDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 33

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SurfaceDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end SurfaceDescriptor

namespace SurfaceTexture

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field SurfaceTexture) := [
  ⟨16, .u32, fun d => (CEnum.toC d.status).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : SurfaceTexture) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 16 (CEnum.toC d.status) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : SurfaceTexture) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : SurfaceTexture) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : SurfaceTexture) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .object⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : SurfaceTexture) : Array Target :=
  #[.object (Internal.Texture.toObject d.texture)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : SurfaceTexture) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field SurfaceTexture) := [
  ⟨8, .u32, fun d => (CEnum.toC d.status).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : SurfaceTexture) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 8 (CEnum.toC d.status) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : SurfaceTexture) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : SurfaceTexture) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : SurfaceTexture) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .object⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : SurfaceTexture) : Array Target :=
  #[.object (Internal.Texture.toObject d.texture)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : SurfaceTexture) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : SurfaceTexture) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : SurfaceTexture) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 34

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SurfaceTexture) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end SurfaceTexture

namespace TexelCopyBufferLayout

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field TexelCopyBufferLayout) := [
  ⟨0, .u64, fun d => (d.offset).toNat⟩,
  ⟨8, .u32, fun d => (d.bytesPerRow).toNat⟩,
  ⟨12, .u32, fun d => (d.rowsPerImage).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 16 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : TexelCopyBufferLayout) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU64 0 d.offset (by decide)
  let b := b.pokeU32 8 d.bytesPerRow (by decide)
  let b := b.pokeU32 12 d.rowsPerImage (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : TexelCopyBufferLayout) :
    encode64 d = Encode.encode .bits64 16 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : TexelCopyBufferLayout) :
    (encode64 d).size = 16 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : TexelCopyBufferLayout) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := []

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  16, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 16 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : TexelCopyBufferLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : TexelCopyBufferLayout) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field TexelCopyBufferLayout) := [
  ⟨0, .u64, fun d => (d.offset).toNat⟩,
  ⟨8, .u32, fun d => (d.bytesPerRow).toNat⟩,
  ⟨12, .u32, fun d => (d.rowsPerImage).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : TexelCopyBufferLayout) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU64 0 d.offset (by decide)
  let b := b.pokeU32 8 d.bytesPerRow (by decide)
  let b := b.pokeU32 12 d.rowsPerImage (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : TexelCopyBufferLayout) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : TexelCopyBufferLayout) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : TexelCopyBufferLayout) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := []

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : TexelCopyBufferLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : TexelCopyBufferLayout) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : TexelCopyBufferLayout) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : TexelCopyBufferLayout) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 35

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TexelCopyBufferLayout) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end TexelCopyBufferLayout

namespace TextureBindingLayout

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field TextureBindingLayout) := [
  ⟨8, .u32, fun d => (CEnum.toC d.sampleType).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.viewDimension).toNat⟩,
  ⟨16, .u32, fun d => (wgpuBool d.multisampled).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : TextureBindingLayout) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 (CEnum.toC d.sampleType) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.viewDimension) (by decide)
  let b := b.pokeU32 16 (wgpuBool d.multisampled) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : TextureBindingLayout) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : TextureBindingLayout) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : TextureBindingLayout) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : TextureBindingLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : TextureBindingLayout) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field TextureBindingLayout) := [
  ⟨4, .u32, fun d => (CEnum.toC d.sampleType).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.viewDimension).toNat⟩,
  ⟨12, .u32, fun d => (wgpuBool d.multisampled).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : TextureBindingLayout) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 4 (CEnum.toC d.sampleType) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.viewDimension) (by decide)
  let b := b.pokeU32 12 (wgpuBool d.multisampled) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : TextureBindingLayout) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : TextureBindingLayout) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : TextureBindingLayout) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : TextureBindingLayout) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : TextureBindingLayout) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : TextureBindingLayout) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : TextureBindingLayout) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 36

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureBindingLayout) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end TextureBindingLayout

namespace TextureBindingViewDimension

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field TextureBindingViewDimension) := [
  ⟨8, .u32, fun _ => (CEnum.toC SType.textureBindingViewDimension).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.textureBindingViewDimension).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : TextureBindingViewDimension) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 (CEnum.toC SType.textureBindingViewDimension) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.textureBindingViewDimension) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : TextureBindingViewDimension) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : TextureBindingViewDimension) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : TextureBindingViewDimension) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : TextureBindingViewDimension) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : TextureBindingViewDimension) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field TextureBindingViewDimension) := [
  ⟨4, .u32, fun _ => (CEnum.toC SType.textureBindingViewDimension).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.textureBindingViewDimension).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 12 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 12 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : TextureBindingViewDimension) : ByteArray :=
  let b := Block.fresh 12
  let b := b.pokeU32 4 (CEnum.toC SType.textureBindingViewDimension) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.textureBindingViewDimension) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : TextureBindingViewDimension) :
    encode32 d = Encode.encode .bits32 12 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : TextureBindingViewDimension) :
    (encode32 d).size = 12 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : TextureBindingViewDimension) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 12 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : TextureBindingViewDimension) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : TextureBindingViewDimension) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : TextureBindingViewDimension) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : TextureBindingViewDimension) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 37

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureBindingViewDimension) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end TextureBindingViewDimension

namespace TextureComponentSwizzle

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field TextureComponentSwizzle) := [
  ⟨0, .u32, fun d => (CEnum.toC d.r).toNat⟩,
  ⟨4, .u32, fun d => (CEnum.toC d.g).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.b).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.a).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 16 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : TextureComponentSwizzle) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 0 (CEnum.toC d.r) (by decide)
  let b := b.pokeU32 4 (CEnum.toC d.g) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.b) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.a) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : TextureComponentSwizzle) :
    encode64 d = Encode.encode .bits64 16 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : TextureComponentSwizzle) :
    (encode64 d).size = 16 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : TextureComponentSwizzle) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := []

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  16, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 16 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : TextureComponentSwizzle) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : TextureComponentSwizzle) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field TextureComponentSwizzle) := [
  ⟨0, .u32, fun d => (CEnum.toC d.r).toNat⟩,
  ⟨4, .u32, fun d => (CEnum.toC d.g).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.b).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.a).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : TextureComponentSwizzle) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 0 (CEnum.toC d.r) (by decide)
  let b := b.pokeU32 4 (CEnum.toC d.g) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.b) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.a) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : TextureComponentSwizzle) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : TextureComponentSwizzle) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : TextureComponentSwizzle) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := []

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : TextureComponentSwizzle) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : TextureComponentSwizzle) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : TextureComponentSwizzle) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : TextureComponentSwizzle) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 38

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureComponentSwizzle) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end TextureComponentSwizzle

namespace TextureViewDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field TextureViewDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨28, .u32, fun d => (CEnum.toC d.dimension).toNat⟩,
  ⟨32, .u32, fun d => (d.baseMipLevel).toNat⟩,
  ⟨36, .u32, fun d => (d.mipLevelCount).toNat⟩,
  ⟨40, .u32, fun d => (d.baseArrayLayer).toNat⟩,
  ⟨44, .u32, fun d => (d.arrayLayerCount).toNat⟩,
  ⟨48, .u32, fun d => (CEnum.toC d.aspect).toNat⟩,
  ⟨56, .u64, fun d => (d.usage.bits).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 64 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 64 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : TextureViewDescriptor) : ByteArray :=
  let b := Block.fresh 64
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU32 24 (CEnum.toC d.format) (by decide)
  let b := b.pokeU32 28 (CEnum.toC d.dimension) (by decide)
  let b := b.pokeU32 32 d.baseMipLevel (by decide)
  let b := b.pokeU32 36 d.mipLevelCount (by decide)
  let b := b.pokeU32 40 d.baseArrayLayer (by decide)
  let b := b.pokeU32 44 d.arrayLayerCount (by decide)
  let b := b.pokeU32 48 (CEnum.toC d.aspect) (by decide)
  let b := b.pokeU64 56 d.usage.bits (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : TextureViewDescriptor) :
    encode64 d = Encode.encode .bits64 64 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : TextureViewDescriptor) :
    (encode64 d).size = 64 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : TextureViewDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  64, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 64 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : TextureViewDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : TextureViewDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field TextureViewDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.dimension).toNat⟩,
  ⟨20, .u32, fun d => (d.baseMipLevel).toNat⟩,
  ⟨24, .u32, fun d => (d.mipLevelCount).toNat⟩,
  ⟨28, .u32, fun d => (d.baseArrayLayer).toNat⟩,
  ⟨32, .u32, fun d => (d.arrayLayerCount).toNat⟩,
  ⟨36, .u32, fun d => (CEnum.toC d.aspect).toNat⟩,
  ⟨40, .u64, fun d => (d.usage.bits).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 48 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 48 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : TextureViewDescriptor) : ByteArray :=
  let b := Block.fresh 48
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.format) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.dimension) (by decide)
  let b := b.pokeU32 20 d.baseMipLevel (by decide)
  let b := b.pokeU32 24 d.mipLevelCount (by decide)
  let b := b.pokeU32 28 d.baseArrayLayer (by decide)
  let b := b.pokeU32 32 d.arrayLayerCount (by decide)
  let b := b.pokeU32 36 (CEnum.toC d.aspect) (by decide)
  let b := b.pokeU64 40 d.usage.bits (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : TextureViewDescriptor) :
    encode32 d = Encode.encode .bits32 48 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : TextureViewDescriptor) :
    (encode32 d).size = 48 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : TextureViewDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  48, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 48 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : TextureViewDescriptor) : Array Target :=
  #[.string d.label]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : TextureViewDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : TextureViewDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : TextureViewDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 39

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureViewDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end TextureViewDescriptor

namespace VertexAttribute

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field VertexAttribute) := [
  ⟨8, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨16, .u64, fun d => (d.offset).toNat⟩,
  ⟨24, .u32, fun d => (d.shaderLocation).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : VertexAttribute) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 8 (CEnum.toC d.format) (by decide)
  let b := b.pokeU64 16 d.offset (by decide)
  let b := b.pokeU32 24 d.shaderLocation (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : VertexAttribute) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : VertexAttribute) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : VertexAttribute) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : VertexAttribute) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : VertexAttribute) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field VertexAttribute) := [
  ⟨4, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨8, .u64, fun d => (d.offset).toNat⟩,
  ⟨16, .u32, fun d => (d.shaderLocation).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : VertexAttribute) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 4 (CEnum.toC d.format) (by decide)
  let b := b.pokeU64 8 d.offset (by decide)
  let b := b.pokeU32 16 d.shaderLocation (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : VertexAttribute) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : VertexAttribute) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : VertexAttribute) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : VertexAttribute) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : VertexAttribute) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : VertexAttribute) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : VertexAttribute) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 40

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : VertexAttribute) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end VertexAttribute

namespace BindGroupDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field BindGroupDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨32, .size, fun d => (d.entries.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 24, 40]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 48 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 48 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : BindGroupDescriptor) : ByteArray :=
  let b := Block.fresh 48
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU64 32 d.entries.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : BindGroupDescriptor) :
    encode64 d = Encode.encode .bits64 48 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : BindGroupDescriptor) :
    (encode64 d).size = 48 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : BindGroupDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field BindGroupDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨16, .size, fun d => (d.entries.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 12, 20]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : BindGroupDescriptor) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 16 d.entries.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : BindGroupDescriptor) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : BindGroupDescriptor) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : BindGroupDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : BindGroupDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : BindGroupDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end BindGroupDescriptor

namespace BindGroupLayoutEntry

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field BindGroupLayoutEntry) := [
  ⟨8, .u32, fun d => (d.binding).toNat⟩,
  ⟨16, .u64, fun d => (d.visibility.bits).toNat⟩,
  ⟨24, .u32, fun d => (d.bindingArraySize).toNat⟩,
  ⟨40, .u32, fun d => (CEnum.toC d.buffer.type).toNat⟩,
  ⟨44, .u32, fun d => (wgpuBool d.buffer.hasDynamicOffset).toNat⟩,
  ⟨48, .u64, fun d => (d.buffer.minBindingSize).toNat⟩,
  ⟨64, .u32, fun d => (CEnum.toC d.sampler.type).toNat⟩,
  ⟨80, .u32, fun d => (CEnum.toC d.texture.sampleType).toNat⟩,
  ⟨84, .u32, fun d => (CEnum.toC d.texture.viewDimension).toNat⟩,
  ⟨88, .u32, fun d => (wgpuBool d.texture.multisampled).toNat⟩,
  ⟨104, .u32, fun d => (CEnum.toC d.storageTexture.access).toNat⟩,
  ⟨108, .u32, fun d => (CEnum.toC d.storageTexture.format).toNat⟩,
  ⟨112, .u32, fun d => (CEnum.toC d.storageTexture.viewDimension).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 32, 56, 72, 96]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 120 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 120 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : BindGroupLayoutEntry) : ByteArray :=
  let b := Block.fresh 120
  let b := b.pokeU32 8 d.binding (by decide)
  let b := b.pokeU64 16 d.visibility.bits (by decide)
  let b := b.pokeU32 24 d.bindingArraySize (by decide)
  let b := b.pokeU32 40 (CEnum.toC d.buffer.type) (by decide)
  let b := b.pokeU32 44 (wgpuBool d.buffer.hasDynamicOffset) (by decide)
  let b := b.pokeU64 48 d.buffer.minBindingSize (by decide)
  let b := b.pokeU32 64 (CEnum.toC d.sampler.type) (by decide)
  let b := b.pokeU32 80 (CEnum.toC d.texture.sampleType) (by decide)
  let b := b.pokeU32 84 (CEnum.toC d.texture.viewDimension) (by decide)
  let b := b.pokeU32 88 (wgpuBool d.texture.multisampled) (by decide)
  let b := b.pokeU32 104 (CEnum.toC d.storageTexture.access) (by decide)
  let b := b.pokeU32 108 (CEnum.toC d.storageTexture.format) (by decide)
  let b := b.pokeU32 112 (CEnum.toC d.storageTexture.viewDimension) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : BindGroupLayoutEntry) :
    encode64 d = Encode.encode .bits64 120 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : BindGroupLayoutEntry) :
    (encode64 d).size = 120 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : BindGroupLayoutEntry) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨32, .null⟩, ⟨56, .null⟩, ⟨72, .null⟩, ⟨96, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  120, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 5,
  0, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 5, 0,
  0, 0, 0, 0, 0, 0, 96, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 120 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : BindGroupLayoutEntry) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : BindGroupLayoutEntry) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field BindGroupLayoutEntry) := [
  ⟨4, .u32, fun d => (d.binding).toNat⟩,
  ⟨8, .u64, fun d => (d.visibility.bits).toNat⟩,
  ⟨16, .u32, fun d => (d.bindingArraySize).toNat⟩,
  ⟨28, .u32, fun d => (CEnum.toC d.buffer.type).toNat⟩,
  ⟨32, .u32, fun d => (wgpuBool d.buffer.hasDynamicOffset).toNat⟩,
  ⟨40, .u64, fun d => (d.buffer.minBindingSize).toNat⟩,
  ⟨52, .u32, fun d => (CEnum.toC d.sampler.type).toNat⟩,
  ⟨60, .u32, fun d => (CEnum.toC d.texture.sampleType).toNat⟩,
  ⟨64, .u32, fun d => (CEnum.toC d.texture.viewDimension).toNat⟩,
  ⟨68, .u32, fun d => (wgpuBool d.texture.multisampled).toNat⟩,
  ⟨76, .u32, fun d => (CEnum.toC d.storageTexture.access).toNat⟩,
  ⟨80, .u32, fun d => (CEnum.toC d.storageTexture.format).toNat⟩,
  ⟨84, .u32, fun d => (CEnum.toC d.storageTexture.viewDimension).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 24, 48, 56, 72]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 88 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 88 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : BindGroupLayoutEntry) : ByteArray :=
  let b := Block.fresh 88
  let b := b.pokeU32 4 d.binding (by decide)
  let b := b.pokeU64 8 d.visibility.bits (by decide)
  let b := b.pokeU32 16 d.bindingArraySize (by decide)
  let b := b.pokeU32 28 (CEnum.toC d.buffer.type) (by decide)
  let b := b.pokeU32 32 (wgpuBool d.buffer.hasDynamicOffset) (by decide)
  let b := b.pokeU64 40 d.buffer.minBindingSize (by decide)
  let b := b.pokeU32 52 (CEnum.toC d.sampler.type) (by decide)
  let b := b.pokeU32 60 (CEnum.toC d.texture.sampleType) (by decide)
  let b := b.pokeU32 64 (CEnum.toC d.texture.viewDimension) (by decide)
  let b := b.pokeU32 68 (wgpuBool d.texture.multisampled) (by decide)
  let b := b.pokeU32 76 (CEnum.toC d.storageTexture.access) (by decide)
  let b := b.pokeU32 80 (CEnum.toC d.storageTexture.format) (by decide)
  let b := b.pokeU32 84 (CEnum.toC d.storageTexture.viewDimension) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : BindGroupLayoutEntry) :
    encode32 d = Encode.encode .bits32 88 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : BindGroupLayoutEntry) :
    (encode32 d).size = 88 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : BindGroupLayoutEntry) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨24, .null⟩, ⟨48, .null⟩, ⟨56, .null⟩, ⟨72, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  88, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 5,
  0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 5, 0,
  0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 88 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : BindGroupLayoutEntry) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : BindGroupLayoutEntry) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : BindGroupLayoutEntry) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : BindGroupLayoutEntry) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 41

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BindGroupLayoutEntry) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end BindGroupLayoutEntry

namespace BlendState

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field BlendState) := [
  ⟨0, .u32, fun d => (CEnum.toC d.color.operation).toNat⟩,
  ⟨4, .u32, fun d => (CEnum.toC d.color.srcFactor).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.color.dstFactor).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.alpha.operation).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.alpha.srcFactor).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.alpha.dstFactor).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : BlendState) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 0 (CEnum.toC d.color.operation) (by decide)
  let b := b.pokeU32 4 (CEnum.toC d.color.srcFactor) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.color.dstFactor) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.alpha.operation) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.alpha.srcFactor) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.alpha.dstFactor) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : BlendState) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : BlendState) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : BlendState) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := []

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : BlendState) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : BlendState) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field BlendState) := [
  ⟨0, .u32, fun d => (CEnum.toC d.color.operation).toNat⟩,
  ⟨4, .u32, fun d => (CEnum.toC d.color.srcFactor).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.color.dstFactor).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.alpha.operation).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.alpha.srcFactor).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.alpha.dstFactor).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : BlendState) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 0 (CEnum.toC d.color.operation) (by decide)
  let b := b.pokeU32 4 (CEnum.toC d.color.srcFactor) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.color.dstFactor) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.alpha.operation) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.alpha.srcFactor) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.alpha.dstFactor) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : BlendState) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : BlendState) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : BlendState) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := []

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : BlendState) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : BlendState) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : BlendState) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : BlendState) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 42

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BlendState) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end BlendState

namespace ComputePassDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field ComputePassDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 24]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : ComputePassDescriptor) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : ComputePassDescriptor) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : ComputePassDescriptor) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : ComputePassDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩, ⟨24, .block 17⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 4, 0, 0, 0, 17, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : ComputePassDescriptor) : Array Target :=
  #[.string d.label]
  ++ (d.timestampWrites.elim #[.block .empty] PassTimestampWrites.block64)

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : ComputePassDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field ComputePassDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 12]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : ComputePassDescriptor) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : ComputePassDescriptor) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : ComputePassDescriptor) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : ComputePassDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩, ⟨12, .block 17⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 4, 0, 0, 0, 17, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : ComputePassDescriptor) : Array Target :=
  #[.string d.label]
  ++ (d.timestampWrites.elim #[.block .empty] PassTimestampWrites.block32)

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : ComputePassDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : ComputePassDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : ComputePassDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 43

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ComputePassDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end ComputePassDescriptor

namespace ComputeState

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field ComputeState) := [
  ⟨24, .size, fun d => (viewLength64 d.entryPoint).toNat⟩,
  ⟨32, .size, fun d => (d.constants.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 16, 40]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 48 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 48 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : ComputeState) : ByteArray :=
  let b := Block.fresh 48
  let b := b.pokeU64 24 (viewLength64 d.entryPoint) (by decide)
  let b := b.pokeU64 32 d.constants.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : ComputeState) :
    encode64 d = Encode.encode .bits64 48 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : ComputeState) :
    (encode64 d).size = 48 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : ComputeState) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field ComputeState) := [
  ⟨12, .size, fun d => (viewLength32 d.entryPoint).toNat⟩,
  ⟨16, .size, fun d => (d.constants.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 8, 20]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : ComputeState) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 12 (viewLength32 d.entryPoint) (by decide)
  let b := b.pokeU32 16 d.constants.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : ComputeState) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : ComputeState) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : ComputeState) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : ComputeState) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : ComputeState) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end ComputeState

namespace DepthStencilState

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field DepthStencilState) := [
  ⟨8, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.depthWriteEnabled).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.depthCompare).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.stencilFront.compare).toNat⟩,
  ⟨24, .u32, fun d => (CEnum.toC d.stencilFront.failOp).toNat⟩,
  ⟨28, .u32, fun d => (CEnum.toC d.stencilFront.depthFailOp).toNat⟩,
  ⟨32, .u32, fun d => (CEnum.toC d.stencilFront.passOp).toNat⟩,
  ⟨36, .u32, fun d => (CEnum.toC d.stencilBack.compare).toNat⟩,
  ⟨40, .u32, fun d => (CEnum.toC d.stencilBack.failOp).toNat⟩,
  ⟨44, .u32, fun d => (CEnum.toC d.stencilBack.depthFailOp).toNat⟩,
  ⟨48, .u32, fun d => (CEnum.toC d.stencilBack.passOp).toNat⟩,
  ⟨52, .u32, fun d => (d.stencilReadMask).toNat⟩,
  ⟨56, .u32, fun d => (d.stencilWriteMask).toNat⟩,
  ⟨60, .u32, fun d => (d.depthBias.toUInt32).toNat⟩,
  ⟨64, .f32, fun d => (d.depthBiasSlopeScale).toBits.toNat⟩,
  ⟨68, .f32, fun d => (d.depthBiasClamp).toBits.toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 72 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 72 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : DepthStencilState) : ByteArray :=
  let b := Block.fresh 72
  let b := b.pokeU32 8 (CEnum.toC d.format) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.depthWriteEnabled) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.depthCompare) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.stencilFront.compare) (by decide)
  let b := b.pokeU32 24 (CEnum.toC d.stencilFront.failOp) (by decide)
  let b := b.pokeU32 28 (CEnum.toC d.stencilFront.depthFailOp) (by decide)
  let b := b.pokeU32 32 (CEnum.toC d.stencilFront.passOp) (by decide)
  let b := b.pokeU32 36 (CEnum.toC d.stencilBack.compare) (by decide)
  let b := b.pokeU32 40 (CEnum.toC d.stencilBack.failOp) (by decide)
  let b := b.pokeU32 44 (CEnum.toC d.stencilBack.depthFailOp) (by decide)
  let b := b.pokeU32 48 (CEnum.toC d.stencilBack.passOp) (by decide)
  let b := b.pokeU32 52 d.stencilReadMask (by decide)
  let b := b.pokeU32 56 d.stencilWriteMask (by decide)
  let b := b.pokeU32 60 d.depthBias.toUInt32 (by decide)
  let b := b.pokeF32 64 d.depthBiasSlopeScale (by decide)
  let b := b.pokeF32 68 d.depthBiasClamp (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : DepthStencilState) :
    encode64 d = Encode.encode .bits64 72 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeF32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : DepthStencilState) :
    (encode64 d).size = 72 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : DepthStencilState) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  72, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 72 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : DepthStencilState) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : DepthStencilState) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field DepthStencilState) := [
  ⟨4, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.depthWriteEnabled).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.depthCompare).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.stencilFront.compare).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.stencilFront.failOp).toNat⟩,
  ⟨24, .u32, fun d => (CEnum.toC d.stencilFront.depthFailOp).toNat⟩,
  ⟨28, .u32, fun d => (CEnum.toC d.stencilFront.passOp).toNat⟩,
  ⟨32, .u32, fun d => (CEnum.toC d.stencilBack.compare).toNat⟩,
  ⟨36, .u32, fun d => (CEnum.toC d.stencilBack.failOp).toNat⟩,
  ⟨40, .u32, fun d => (CEnum.toC d.stencilBack.depthFailOp).toNat⟩,
  ⟨44, .u32, fun d => (CEnum.toC d.stencilBack.passOp).toNat⟩,
  ⟨48, .u32, fun d => (d.stencilReadMask).toNat⟩,
  ⟨52, .u32, fun d => (d.stencilWriteMask).toNat⟩,
  ⟨56, .u32, fun d => (d.depthBias.toUInt32).toNat⟩,
  ⟨60, .f32, fun d => (d.depthBiasSlopeScale).toBits.toNat⟩,
  ⟨64, .f32, fun d => (d.depthBiasClamp).toBits.toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 68 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 68 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : DepthStencilState) : ByteArray :=
  let b := Block.fresh 68
  let b := b.pokeU32 4 (CEnum.toC d.format) (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.depthWriteEnabled) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.depthCompare) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.stencilFront.compare) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.stencilFront.failOp) (by decide)
  let b := b.pokeU32 24 (CEnum.toC d.stencilFront.depthFailOp) (by decide)
  let b := b.pokeU32 28 (CEnum.toC d.stencilFront.passOp) (by decide)
  let b := b.pokeU32 32 (CEnum.toC d.stencilBack.compare) (by decide)
  let b := b.pokeU32 36 (CEnum.toC d.stencilBack.failOp) (by decide)
  let b := b.pokeU32 40 (CEnum.toC d.stencilBack.depthFailOp) (by decide)
  let b := b.pokeU32 44 (CEnum.toC d.stencilBack.passOp) (by decide)
  let b := b.pokeU32 48 d.stencilReadMask (by decide)
  let b := b.pokeU32 52 d.stencilWriteMask (by decide)
  let b := b.pokeU32 56 d.depthBias.toUInt32 (by decide)
  let b := b.pokeF32 60 d.depthBiasSlopeScale (by decide)
  let b := b.pokeF32 64 d.depthBiasClamp (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : DepthStencilState) :
    encode32 d = Encode.encode .bits32 68 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeF32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : DepthStencilState) :
    (encode32 d).size = 68 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : DepthStencilState) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  68, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 68 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : DepthStencilState) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : DepthStencilState) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : DepthStencilState) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : DepthStencilState) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 44

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : DepthStencilState) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end DepthStencilState

namespace FutureWaitInfo

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field FutureWaitInfo) := [
  ⟨0, .u64, fun d => (d.future.id).toNat⟩,
  ⟨8, .u32, fun d => (wgpuBool d.completed).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 16 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : FutureWaitInfo) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU64 0 d.future.id (by decide)
  let b := b.pokeU32 8 (wgpuBool d.completed) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : FutureWaitInfo) :
    encode64 d = Encode.encode .bits64 16 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : FutureWaitInfo) :
    (encode64 d).size = 16 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : FutureWaitInfo) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := []

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  16, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 16 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : FutureWaitInfo) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : FutureWaitInfo) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field FutureWaitInfo) := [
  ⟨0, .u64, fun d => (d.future.id).toNat⟩,
  ⟨8, .u32, fun d => (wgpuBool d.completed).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := []

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : FutureWaitInfo) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU64 0 d.future.id (by decide)
  let b := b.pokeU32 8 (wgpuBool d.completed) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : FutureWaitInfo) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : FutureWaitInfo) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : FutureWaitInfo) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := []

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : FutureWaitInfo) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : FutureWaitInfo) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : FutureWaitInfo) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : FutureWaitInfo) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 45

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : FutureWaitInfo) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end FutureWaitInfo

namespace InstanceDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field InstanceDescriptor) := [
  ⟨8, .size, fun d => (d.requiredFeatures.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 16, 24]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : InstanceDescriptor) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU64 8 d.requiredFeatures.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : InstanceDescriptor) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : InstanceDescriptor) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : InstanceDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field InstanceDescriptor) := [
  ⟨4, .size, fun d => (d.requiredFeatures.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 8, 12]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 16 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 16 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : InstanceDescriptor) : ByteArray :=
  let b := Block.fresh 16
  let b := b.pokeU32 4 d.requiredFeatures.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : InstanceDescriptor) :
    encode32 d = Encode.encode .bits32 16 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : InstanceDescriptor) :
    (encode32 d).size = 16 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : InstanceDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (d : InstanceDescriptor) : Bool :=
  System.Platform.numBits = 64 ||
      (d.requiredLimits.all fun x0 => sizeFits x0.timedWaitAnyMaxCount)

/--
`d` as C lays it out on this target, its pointers 0. The caller checks
`sizesFit d` first: on wasm32, a `size_t` that does not fit is cut to its
low 32 bits.
-/
@[inline]
def toBytes (d : InstanceDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end InstanceDescriptor

namespace RenderPassColorAttachment

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field RenderPassColorAttachment) := [
  ⟨16, .u32, fun d => (d.depthSlice).toNat⟩,
  ⟨32, .u32, fun d => (CEnum.toC d.loadOp).toNat⟩,
  ⟨36, .u32, fun d => (CEnum.toC d.storeOp).toNat⟩,
  ⟨40, .f64, fun d => (d.clearValue.r).toBits.toNat⟩,
  ⟨48, .f64, fun d => (d.clearValue.g).toBits.toNat⟩,
  ⟨56, .f64, fun d => (d.clearValue.b).toBits.toNat⟩,
  ⟨64, .f64, fun d => (d.clearValue.a).toBits.toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 24]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 72 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 72 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : RenderPassColorAttachment) : ByteArray :=
  let b := Block.fresh 72
  let b := b.pokeU32 16 d.depthSlice (by decide)
  let b := b.pokeU32 32 (CEnum.toC d.loadOp) (by decide)
  let b := b.pokeU32 36 (CEnum.toC d.storeOp) (by decide)
  let b := b.pokeF64 40 d.clearValue.r (by decide)
  let b := b.pokeF64 48 d.clearValue.g (by decide)
  let b := b.pokeF64 56 d.clearValue.b (by decide)
  let b := b.pokeF64 64 d.clearValue.a (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : RenderPassColorAttachment) :
    encode64 d = Encode.encode .bits64 72 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeF64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : RenderPassColorAttachment) :
    (encode64 d).size = 72 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : RenderPassColorAttachment) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .optObject⟩, ⟨24, .optObject⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  72, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 3, 0,
  0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 72 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : RenderPassColorAttachment) : Array Target :=
  #[
    .optObject (d.view.map Internal.TextureView.toObject),
    .optObject (d.resolveTarget.map Internal.TextureView.toObject)
  ]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : RenderPassColorAttachment) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field RenderPassColorAttachment) := [
  ⟨8, .u32, fun d => (d.depthSlice).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.loadOp).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.storeOp).toNat⟩,
  ⟨24, .f64, fun d => (d.clearValue.r).toBits.toNat⟩,
  ⟨32, .f64, fun d => (d.clearValue.g).toBits.toNat⟩,
  ⟨40, .f64, fun d => (d.clearValue.b).toBits.toNat⟩,
  ⟨48, .f64, fun d => (d.clearValue.a).toBits.toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 12]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 56 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 56 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : RenderPassColorAttachment) : ByteArray :=
  let b := Block.fresh 56
  let b := b.pokeU32 8 d.depthSlice (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.loadOp) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.storeOp) (by decide)
  let b := b.pokeF64 24 d.clearValue.r (by decide)
  let b := b.pokeF64 32 d.clearValue.g (by decide)
  let b := b.pokeF64 40 d.clearValue.b (by decide)
  let b := b.pokeF64 48 d.clearValue.a (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : RenderPassColorAttachment) :
    encode32 d = Encode.encode .bits32 56 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeF64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : RenderPassColorAttachment) :
    (encode32 d).size = 56 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : RenderPassColorAttachment) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .optObject⟩, ⟨12, .optObject⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  56, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 3, 0,
  0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 56 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : RenderPassColorAttachment) : Array Target :=
  #[
    .optObject (d.view.map Internal.TextureView.toObject),
    .optObject (d.resolveTarget.map Internal.TextureView.toObject)
  ]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : RenderPassColorAttachment) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : RenderPassColorAttachment) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : RenderPassColorAttachment) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 46

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderPassColorAttachment) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end RenderPassColorAttachment

namespace TexelCopyBufferInfo

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field TexelCopyBufferInfo) := [
  ⟨0, .u64, fun d => (d.layout.offset).toNat⟩,
  ⟨8, .u32, fun d => (d.layout.bytesPerRow).toNat⟩,
  ⟨12, .u32, fun d => (d.layout.rowsPerImage).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [16]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 24 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : TexelCopyBufferInfo) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU64 0 d.layout.offset (by decide)
  let b := b.pokeU32 8 d.layout.bytesPerRow (by decide)
  let b := b.pokeU32 12 d.layout.rowsPerImage (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : TexelCopyBufferInfo) :
    encode64 d = Encode.encode .bits64 24 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : TexelCopyBufferInfo) :
    (encode64 d).size = 24 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : TexelCopyBufferInfo) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨16, .object⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 16, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 24 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : TexelCopyBufferInfo) : Array Target :=
  #[.object (Internal.Buffer.toObject d.buffer)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : TexelCopyBufferInfo) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field TexelCopyBufferInfo) := [
  ⟨0, .u64, fun d => (d.layout.offset).toNat⟩,
  ⟨8, .u32, fun d => (d.layout.bytesPerRow).toNat⟩,
  ⟨12, .u32, fun d => (d.layout.rowsPerImage).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [16]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : TexelCopyBufferInfo) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU64 0 d.layout.offset (by decide)
  let b := b.pokeU32 8 d.layout.bytesPerRow (by decide)
  let b := b.pokeU32 12 d.layout.rowsPerImage (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : TexelCopyBufferInfo) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : TexelCopyBufferInfo) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : TexelCopyBufferInfo) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨16, .object⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 16, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : TexelCopyBufferInfo) : Array Target :=
  #[.object (Internal.Buffer.toObject d.buffer)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : TexelCopyBufferInfo) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : TexelCopyBufferInfo) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : TexelCopyBufferInfo) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 47

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TexelCopyBufferInfo) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end TexelCopyBufferInfo

namespace TexelCopyTextureInfo

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field TexelCopyTextureInfo) := [
  ⟨8, .u32, fun d => (d.mipLevel).toNat⟩,
  ⟨12, .u32, fun d => (d.origin.x).toNat⟩,
  ⟨16, .u32, fun d => (d.origin.y).toNat⟩,
  ⟨20, .u32, fun d => (d.origin.z).toNat⟩,
  ⟨24, .u32, fun d => (CEnum.toC d.aspect).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : TexelCopyTextureInfo) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 8 d.mipLevel (by decide)
  let b := b.pokeU32 12 d.origin.x (by decide)
  let b := b.pokeU32 16 d.origin.y (by decide)
  let b := b.pokeU32 20 d.origin.z (by decide)
  let b := b.pokeU32 24 (CEnum.toC d.aspect) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : TexelCopyTextureInfo) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : TexelCopyTextureInfo) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : TexelCopyTextureInfo) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .object⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : TexelCopyTextureInfo) : Array Target :=
  #[.object (Internal.Texture.toObject d.texture)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : TexelCopyTextureInfo) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field TexelCopyTextureInfo) := [
  ⟨4, .u32, fun d => (d.mipLevel).toNat⟩,
  ⟨8, .u32, fun d => (d.origin.x).toNat⟩,
  ⟨12, .u32, fun d => (d.origin.y).toNat⟩,
  ⟨16, .u32, fun d => (d.origin.z).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.aspect).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : TexelCopyTextureInfo) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 4 d.mipLevel (by decide)
  let b := b.pokeU32 8 d.origin.x (by decide)
  let b := b.pokeU32 12 d.origin.y (by decide)
  let b := b.pokeU32 16 d.origin.z (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.aspect) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : TexelCopyTextureInfo) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : TexelCopyTextureInfo) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : TexelCopyTextureInfo) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .object⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : TexelCopyTextureInfo) : Array Target :=
  #[.object (Internal.Texture.toObject d.texture)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : TexelCopyTextureInfo) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : TexelCopyTextureInfo) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : TexelCopyTextureInfo) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 48

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TexelCopyTextureInfo) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end TexelCopyTextureInfo

namespace TextureComponentSwizzleDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field TextureComponentSwizzleDescriptor) := [
  ⟨8, .u32, fun _ => (CEnum.toC SType.textureComponentSwizzleDescriptor).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.swizzle.r).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.swizzle.g).toNat⟩,
  ⟨24, .u32, fun d => (CEnum.toC d.swizzle.b).toNat⟩,
  ⟨28, .u32, fun d => (CEnum.toC d.swizzle.a).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : TextureComponentSwizzleDescriptor) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 8
      (CEnum.toC SType.textureComponentSwizzleDescriptor)
      (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.swizzle.r) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.swizzle.g) (by decide)
  let b := b.pokeU32 24 (CEnum.toC d.swizzle.b) (by decide)
  let b := b.pokeU32 28 (CEnum.toC d.swizzle.a) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : TextureComponentSwizzleDescriptor) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : TextureComponentSwizzleDescriptor) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : TextureComponentSwizzleDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (_ : TextureComponentSwizzleDescriptor) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : TextureComponentSwizzleDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field TextureComponentSwizzleDescriptor) := [
  ⟨4, .u32, fun _ => (CEnum.toC SType.textureComponentSwizzleDescriptor).toNat⟩,
  ⟨8, .u32, fun d => (CEnum.toC d.swizzle.r).toNat⟩,
  ⟨12, .u32, fun d => (CEnum.toC d.swizzle.g).toNat⟩,
  ⟨16, .u32, fun d => (CEnum.toC d.swizzle.b).toNat⟩,
  ⟨20, .u32, fun d => (CEnum.toC d.swizzle.a).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : TextureComponentSwizzleDescriptor) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 4
      (CEnum.toC SType.textureComponentSwizzleDescriptor)
      (by decide)
  let b := b.pokeU32 8 (CEnum.toC d.swizzle.r) (by decide)
  let b := b.pokeU32 12 (CEnum.toC d.swizzle.g) (by decide)
  let b := b.pokeU32 16 (CEnum.toC d.swizzle.b) (by decide)
  let b := b.pokeU32 20 (CEnum.toC d.swizzle.a) (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : TextureComponentSwizzleDescriptor) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : TextureComponentSwizzleDescriptor) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : TextureComponentSwizzleDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (_ : TextureComponentSwizzleDescriptor) : Array Target :=
  #[]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : TextureComponentSwizzleDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : TextureComponentSwizzleDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : TextureComponentSwizzleDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 49

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureComponentSwizzleDescriptor) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end TextureComponentSwizzleDescriptor

namespace TextureDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field TextureDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .u64, fun d => (d.usage.bits).toNat⟩,
  ⟨32, .u32, fun d => (CEnum.toC d.dimension).toNat⟩,
  ⟨36, .u32, fun d => (d.size.width).toNat⟩,
  ⟨40, .u32, fun d => (d.size.height).toNat⟩,
  ⟨44, .u32, fun d => (d.size.depthOrArrayLayers).toNat⟩,
  ⟨48, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨52, .u32, fun d => (d.mipLevelCount).toNat⟩,
  ⟨56, .u32, fun d => (d.sampleCount).toNat⟩,
  ⟨64, .size, fun d => (d.viewFormats.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 72]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 80 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 80 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : TextureDescriptor) : ByteArray :=
  let b := Block.fresh 80
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU64 24 d.usage.bits (by decide)
  let b := b.pokeU32 32 (CEnum.toC d.dimension) (by decide)
  let b := b.pokeU32 36 d.size.width (by decide)
  let b := b.pokeU32 40 d.size.height (by decide)
  let b := b.pokeU32 44 d.size.depthOrArrayLayers (by decide)
  let b := b.pokeU32 48 (CEnum.toC d.format) (by decide)
  let b := b.pokeU32 52 d.mipLevelCount (by decide)
  let b := b.pokeU32 56 d.sampleCount (by decide)
  let b := b.pokeU64 64 d.viewFormats.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : TextureDescriptor) :
    encode64 d = Encode.encode .bits64 80 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : TextureDescriptor) :
    (encode64 d).size = 80 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : TextureDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field TextureDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨16, .u64, fun d => (d.usage.bits).toNat⟩,
  ⟨24, .u32, fun d => (CEnum.toC d.dimension).toNat⟩,
  ⟨28, .u32, fun d => (d.size.width).toNat⟩,
  ⟨32, .u32, fun d => (d.size.height).toNat⟩,
  ⟨36, .u32, fun d => (d.size.depthOrArrayLayers).toNat⟩,
  ⟨40, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨44, .u32, fun d => (d.mipLevelCount).toNat⟩,
  ⟨48, .u32, fun d => (d.sampleCount).toNat⟩,
  ⟨52, .size, fun d => (d.viewFormats.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 56]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 64 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 64 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : TextureDescriptor) : ByteArray :=
  let b := Block.fresh 64
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU64 16 d.usage.bits (by decide)
  let b := b.pokeU32 24 (CEnum.toC d.dimension) (by decide)
  let b := b.pokeU32 28 d.size.width (by decide)
  let b := b.pokeU32 32 d.size.height (by decide)
  let b := b.pokeU32 36 d.size.depthOrArrayLayers (by decide)
  let b := b.pokeU32 40 (CEnum.toC d.format) (by decide)
  let b := b.pokeU32 44 d.mipLevelCount (by decide)
  let b := b.pokeU32 48 d.sampleCount (by decide)
  let b := b.pokeU32 52 d.viewFormats.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : TextureDescriptor) :
    encode32 d = Encode.encode .bits32 64 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : TextureDescriptor) :
    (encode32 d).size = 64 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : TextureDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : TextureDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : TextureDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end TextureDescriptor

namespace VertexBufferLayout

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field VertexBufferLayout) := [
  ⟨8, .u32, fun d => (CEnum.toC d.stepMode).toNat⟩,
  ⟨16, .u64, fun d => (d.arrayStride).toNat⟩,
  ⟨24, .size, fun d => (d.attributes.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 32]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 40 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 40 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : VertexBufferLayout) : ByteArray :=
  let b := Block.fresh 40
  let b := b.pokeU32 8 (CEnum.toC d.stepMode) (by decide)
  let b := b.pokeU64 16 d.arrayStride (by decide)
  let b := b.pokeU64 24 d.attributes.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : VertexBufferLayout) :
    encode64 d = Encode.encode .bits64 40 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : VertexBufferLayout) :
    (encode64 d).size = 40 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : VertexBufferLayout) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field VertexBufferLayout) := [
  ⟨4, .u32, fun d => (CEnum.toC d.stepMode).toNat⟩,
  ⟨8, .u64, fun d => (d.arrayStride).toNat⟩,
  ⟨16, .size, fun d => (d.attributes.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 20]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : VertexBufferLayout) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 4 (CEnum.toC d.stepMode) (by decide)
  let b := b.pokeU64 8 d.arrayStride (by decide)
  let b := b.pokeU32 16 d.attributes.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : VertexBufferLayout) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : VertexBufferLayout) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : VertexBufferLayout) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : VertexBufferLayout) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : VertexBufferLayout) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end VertexBufferLayout

namespace BindGroupLayoutDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field BindGroupLayoutDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .size, fun d => (d.entries.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 32]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 40 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 40 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : BindGroupLayoutDescriptor) : ByteArray :=
  let b := Block.fresh 40
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU64 24 d.entries.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : BindGroupLayoutDescriptor) :
    encode64 d = Encode.encode .bits64 40 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : BindGroupLayoutDescriptor) :
    (encode64 d).size = 40 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : BindGroupLayoutDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field BindGroupLayoutDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨12, .size, fun d => (d.entries.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 16]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 20 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 20 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : BindGroupLayoutDescriptor) : ByteArray :=
  let b := Block.fresh 20
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 12 d.entries.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : BindGroupLayoutDescriptor) :
    encode32 d = Encode.encode .bits32 20 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : BindGroupLayoutDescriptor) :
    (encode32 d).size = 20 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : BindGroupLayoutDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : BindGroupLayoutDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : BindGroupLayoutDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end BindGroupLayoutDescriptor

namespace ColorTargetState

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field ColorTargetState) := [
  ⟨8, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨24, .u64, fun d => (d.writeMask.bits).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 16]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 32 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : ColorTargetState) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 8 (CEnum.toC d.format) (by decide)
  let b := b.pokeU64 24 d.writeMask.bits (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : ColorTargetState) :
    encode64 d = Encode.encode .bits64 32 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : ColorTargetState) :
    (encode64 d).size = 32 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : ColorTargetState) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨16, .block 42⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 4,
  0, 0, 0, 42, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : ColorTargetState) : Array Target :=
  (d.blend.elim #[.block .empty] BlendState.block64)

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : ColorTargetState) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field ColorTargetState) := [
  ⟨4, .u32, fun d => (CEnum.toC d.format).toNat⟩,
  ⟨16, .u64, fun d => (d.writeMask.bits).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 8]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 24 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 24 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : ColorTargetState) : ByteArray :=
  let b := Block.fresh 24
  let b := b.pokeU32 4 (CEnum.toC d.format) (by decide)
  let b := b.pokeU64 16 d.writeMask.bits (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : ColorTargetState) :
    encode32 d = Encode.encode .bits32 24 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    Block.val_pokeU64, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : ColorTargetState) :
    (encode32 d).size = 24 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : ColorTargetState) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .block 42⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 4, 0,
  0, 0, 42, 0, 0, 0
]⟩

/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : ColorTargetState) : Array Target :=
  (d.blend.elim #[.block .empty] BlendState.block32)

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : ColorTargetState) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : ColorTargetState) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : ColorTargetState) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 50

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ColorTargetState) : Array Target :=
  if System.Platform.numBits = 64 then targets64 d else targets32 d

end ColorTargetState

namespace ComputePipelineDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field ComputePipelineDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨56, .size, fun d => (viewLength64 d.compute.entryPoint).toNat⟩,
  ⟨64, .size, fun d => (d.compute.constants.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 24, 32, 40, 48, 72]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 80 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 80 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : ComputePipelineDescriptor) : ByteArray :=
  let b := Block.fresh 80
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU64 56 (viewLength64 d.compute.entryPoint) (by decide)
  let b := b.pokeU64 64 d.compute.constants.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : ComputePipelineDescriptor) :
    encode64 d = Encode.encode .bits64 80 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : ComputePipelineDescriptor) :
    (encode64 d).size = 80 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : ComputePipelineDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field ComputePipelineDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨28, .size, fun d => (viewLength32 d.compute.entryPoint).toNat⟩,
  ⟨32, .size, fun d => (d.compute.constants.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 12, 16, 20, 24, 36]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 40 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 40 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : ComputePipelineDescriptor) : ByteArray :=
  let b := Block.fresh 40
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 28 (viewLength32 d.compute.entryPoint) (by decide)
  let b := b.pokeU32 32 d.compute.constants.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : ComputePipelineDescriptor) :
    encode32 d = Encode.encode .bits32 40 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : ComputePipelineDescriptor) :
    (encode32 d).size = 40 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : ComputePipelineDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : ComputePipelineDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : ComputePipelineDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end ComputePipelineDescriptor

namespace RenderPassDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field RenderPassDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .size, fun d => (d.colorAttachments.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 32, 40, 48, 56]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 64 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 64 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : RenderPassDescriptor) : ByteArray :=
  let b := Block.fresh 64
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU64 24 d.colorAttachments.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : RenderPassDescriptor) :
    encode64 d = Encode.encode .bits64 64 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : RenderPassDescriptor) :
    (encode64 d).size = 64 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : RenderPassDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field RenderPassDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨12, .size, fun d => (d.colorAttachments.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 16, 20, 24, 28]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 32 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : RenderPassDescriptor) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 12 d.colorAttachments.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : RenderPassDescriptor) :
    encode32 d = Encode.encode .bits32 32 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : RenderPassDescriptor) :
    (encode32 d).size = 32 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : RenderPassDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : RenderPassDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : RenderPassDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end RenderPassDescriptor

namespace VertexState

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field VertexState) := [
  ⟨24, .size, fun d => (viewLength64 d.entryPoint).toNat⟩,
  ⟨32, .size, fun d => (d.constants.size.toUInt64).toNat⟩,
  ⟨48, .size, fun d => (d.buffers.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 16, 40, 56]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 64 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 64 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : VertexState) : ByteArray :=
  let b := Block.fresh 64
  let b := b.pokeU64 24 (viewLength64 d.entryPoint) (by decide)
  let b := b.pokeU64 32 d.constants.size.toUInt64 (by decide)
  let b := b.pokeU64 48 d.buffers.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : VertexState) :
    encode64 d = Encode.encode .bits64 64 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : VertexState) :
    (encode64 d).size = 64 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : VertexState) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field VertexState) := [
  ⟨12, .size, fun d => (viewLength32 d.entryPoint).toNat⟩,
  ⟨16, .size, fun d => (d.constants.size.toUInt32).toNat⟩,
  ⟨24, .size, fun d => (d.buffers.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 8, 20, 28]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 32 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : VertexState) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 12 (viewLength32 d.entryPoint) (by decide)
  let b := b.pokeU32 16 d.constants.size.toUInt32 (by decide)
  let b := b.pokeU32 24 d.buffers.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : VertexState) :
    encode32 d = Encode.encode .bits32 32 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : VertexState) :
    (encode32 d).size = 32 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : VertexState) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : VertexState) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : VertexState) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end VertexState

namespace FragmentState

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field FragmentState) := [
  ⟨24, .size, fun d => (viewLength64 d.entryPoint).toNat⟩,
  ⟨32, .size, fun d => (d.constants.size.toUInt64).toNat⟩,
  ⟨48, .size, fun d => (d.targets.size.toUInt64).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 16, 40, 56]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 64 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 64 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : FragmentState) : ByteArray :=
  let b := Block.fresh 64
  let b := b.pokeU64 24 (viewLength64 d.entryPoint) (by decide)
  let b := b.pokeU64 32 d.constants.size.toUInt64 (by decide)
  let b := b.pokeU64 48 d.targets.size.toUInt64 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : FragmentState) :
    encode64 d = Encode.encode .bits64 64 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : FragmentState) :
    (encode64 d).size = 64 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : FragmentState) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field FragmentState) := [
  ⟨12, .size, fun d => (viewLength32 d.entryPoint).toNat⟩,
  ⟨16, .size, fun d => (d.constants.size.toUInt32).toNat⟩,
  ⟨24, .size, fun d => (d.targets.size.toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 8, 20, 28]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 32 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 32 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : FragmentState) : ByteArray :=
  let b := Block.fresh 32
  let b := b.pokeU32 12 (viewLength32 d.entryPoint) (by decide)
  let b := b.pokeU32 16 d.constants.size.toUInt32 (by decide)
  let b := b.pokeU32 24 d.targets.size.toUInt32 (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : FragmentState) :
    encode32 d = Encode.encode .bits32 32 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : FragmentState) :
    (encode32 d).size = 32 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : FragmentState) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : FragmentState) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : FragmentState) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end FragmentState

namespace RenderPipelineDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field RenderPipelineDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨56, .size, fun d => (viewLength64 d.vertex.entryPoint).toNat⟩,
  ⟨64, .size, fun d => (d.vertex.constants.size.toUInt64).toNat⟩,
  ⟨80, .size, fun d => (d.vertex.buffers.size.toUInt64).toNat⟩,
  ⟨104, .u32, fun d => (CEnum.toC d.primitive.topology).toNat⟩,
  ⟨108, .u32, fun d => (CEnum.toC d.primitive.stripIndexFormat).toNat⟩,
  ⟨112, .u32, fun d => (CEnum.toC d.primitive.frontFace).toNat⟩,
  ⟨116, .u32, fun d => (CEnum.toC d.primitive.cullMode).toNat⟩,
  ⟨120, .u32, fun d => (wgpuBool d.primitive.unclippedDepth).toNat⟩,
  ⟨144, .u32, fun d => (d.multisample.count).toNat⟩,
  ⟨148, .u32, fun d => (d.multisample.mask).toNat⟩,
  ⟨152, .u32, fun d => (wgpuBool d.multisample.alphaToCoverageEnabled).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 24, 32, 40, 48, 72, 88, 96, 128, 136, 160]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 168 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 168 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : RenderPipelineDescriptor) : ByteArray :=
  let b := Block.fresh 168
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU64 56 (viewLength64 d.vertex.entryPoint) (by decide)
  let b := b.pokeU64 64 d.vertex.constants.size.toUInt64 (by decide)
  let b := b.pokeU64 80 d.vertex.buffers.size.toUInt64 (by decide)
  let b := b.pokeU32 104 (CEnum.toC d.primitive.topology) (by decide)
  let b := b.pokeU32 108 (CEnum.toC d.primitive.stripIndexFormat) (by decide)
  let b := b.pokeU32 112 (CEnum.toC d.primitive.frontFace) (by decide)
  let b := b.pokeU32 116 (CEnum.toC d.primitive.cullMode) (by decide)
  let b := b.pokeU32 120 (wgpuBool d.primitive.unclippedDepth) (by decide)
  let b := b.pokeU32 144 d.multisample.count (by decide)
  let b := b.pokeU32 148 d.multisample.mask (by decide)
  let b := b.pokeU32 152
      (wgpuBool d.multisample.alphaToCoverageEnabled)
      (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : RenderPipelineDescriptor) :
    encode64 d = Encode.encode .bits64 168 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : RenderPipelineDescriptor) :
    (encode64 d).size = 168 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : RenderPipelineDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field RenderPipelineDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨28, .size, fun d => (viewLength32 d.vertex.entryPoint).toNat⟩,
  ⟨32, .size, fun d => (d.vertex.constants.size.toUInt32).toNat⟩,
  ⟨40, .size, fun d => (d.vertex.buffers.size.toUInt32).toNat⟩,
  ⟨52, .u32, fun d => (CEnum.toC d.primitive.topology).toNat⟩,
  ⟨56, .u32, fun d => (CEnum.toC d.primitive.stripIndexFormat).toNat⟩,
  ⟨60, .u32, fun d => (CEnum.toC d.primitive.frontFace).toNat⟩,
  ⟨64, .u32, fun d => (CEnum.toC d.primitive.cullMode).toNat⟩,
  ⟨68, .u32, fun d => (wgpuBool d.primitive.unclippedDepth).toNat⟩,
  ⟨80, .u32, fun d => (d.multisample.count).toNat⟩,
  ⟨84, .u32, fun d => (d.multisample.mask).toNat⟩,
  ⟨88, .u32, fun d => (wgpuBool d.multisample.alphaToCoverageEnabled).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 12, 16, 20, 24, 36, 44, 48, 72, 76, 92]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 96 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 96 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : RenderPipelineDescriptor) : ByteArray :=
  let b := Block.fresh 96
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 28 (viewLength32 d.vertex.entryPoint) (by decide)
  let b := b.pokeU32 32 d.vertex.constants.size.toUInt32 (by decide)
  let b := b.pokeU32 40 d.vertex.buffers.size.toUInt32 (by decide)
  let b := b.pokeU32 52 (CEnum.toC d.primitive.topology) (by decide)
  let b := b.pokeU32 56 (CEnum.toC d.primitive.stripIndexFormat) (by decide)
  let b := b.pokeU32 60 (CEnum.toC d.primitive.frontFace) (by decide)
  let b := b.pokeU32 64 (CEnum.toC d.primitive.cullMode) (by decide)
  let b := b.pokeU32 68 (wgpuBool d.primitive.unclippedDepth) (by decide)
  let b := b.pokeU32 80 d.multisample.count (by decide)
  let b := b.pokeU32 84 d.multisample.mask (by decide)
  let b := b.pokeU32 88
      (wgpuBool d.multisample.alphaToCoverageEnabled)
      (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : RenderPipelineDescriptor) :
    encode32 d = Encode.encode .bits32 96 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : RenderPipelineDescriptor) :
    (encode32 d).size = 96 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : RenderPipelineDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : RenderPipelineDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : RenderPipelineDescriptor) : ByteArray :=
  if System.Platform.numBits = 64 then encode64 d else encode32 d

end RenderPipelineDescriptor

/-! ## Tables -/

/-- Every struct's table on 64-bit targets, by its index. -/
def tables64 : Array ByteArray := #[
  BindGroupEntry.table64, BlendComponent.table64, BufferBindingLayout.table64,
  BufferDescriptor.table64, Color.table64, CommandBufferDescriptor.table64,
  CommandEncoderDescriptor.table64, CompatibilityModeLimits.table64,
  ConstantEntry.table64, Extent3D.table64, ExternalTextureBindingEntry.table64,
  ExternalTextureBindingLayout.table64, Future.table64, InstanceLimits.table64,
  Limits.table64, MultisampleState.table64, Origin3D.table64,
  PassTimestampWrites.table64, PrimitiveState.table64,
  QuerySetDescriptor.table64, QueueDescriptor.table64,
  RenderBundleDescriptor.table64, RenderPassDepthStencilAttachment.table64,
  RenderPassMaxDrawCount.table64, RequestAdapterOptions.table64,
  RequestAdapterWebXROptions.table64, SamplerBindingLayout.table64,
  SamplerDescriptor.table64, ShaderModuleDescriptor.table64,
  ShaderSourceWGSL.table64, StencilFaceState.table64,
  StorageTextureBindingLayout.table64, SurfaceColorManagement.table64,
  SurfaceDescriptor.table64, SurfaceTexture.table64,
  TexelCopyBufferLayout.table64, TextureBindingLayout.table64,
  TextureBindingViewDimension.table64, TextureComponentSwizzle.table64,
  TextureViewDescriptor.table64, VertexAttribute.table64,
  BindGroupLayoutEntry.table64, BlendState.table64,
  ComputePassDescriptor.table64, DepthStencilState.table64,
  FutureWaitInfo.table64, RenderPassColorAttachment.table64,
  TexelCopyBufferInfo.table64, TexelCopyTextureInfo.table64,
  TextureComponentSwizzleDescriptor.table64, ColorTargetState.table64
]

/-- Every struct's table on 64-bit targets, as the walk reads it. -/
noncomputable def specs64 : Array Spec := #[
  (56, BindGroupEntry.relocs64), (12, BlendComponent.relocs64),
  (24, BufferBindingLayout.relocs64), (48, BufferDescriptor.relocs64),
  (32, Color.relocs64), (24, CommandBufferDescriptor.relocs64),
  (24, CommandEncoderDescriptor.relocs64),
  (32, CompatibilityModeLimits.relocs64), (32, ConstantEntry.relocs64),
  (12, Extent3D.relocs64), (24, ExternalTextureBindingEntry.relocs64),
  (16, ExternalTextureBindingLayout.relocs64), (8, Future.relocs64),
  (16, InstanceLimits.relocs64), (152, Limits.relocs64),
  (24, MultisampleState.relocs64), (12, Origin3D.relocs64),
  (24, PassTimestampWrites.relocs64), (32, PrimitiveState.relocs64),
  (32, QuerySetDescriptor.relocs64), (24, QueueDescriptor.relocs64),
  (24, RenderBundleDescriptor.relocs64),
  (48, RenderPassDepthStencilAttachment.relocs64),
  (24, RenderPassMaxDrawCount.relocs64), (32, RequestAdapterOptions.relocs64),
  (24, RequestAdapterWebXROptions.relocs64),
  (16, SamplerBindingLayout.relocs64), (64, SamplerDescriptor.relocs64),
  (24, ShaderModuleDescriptor.relocs64), (32, ShaderSourceWGSL.relocs64),
  (16, StencilFaceState.relocs64), (24, StorageTextureBindingLayout.relocs64),
  (24, SurfaceColorManagement.relocs64), (24, SurfaceDescriptor.relocs64),
  (24, SurfaceTexture.relocs64), (16, TexelCopyBufferLayout.relocs64),
  (24, TextureBindingLayout.relocs64),
  (24, TextureBindingViewDimension.relocs64),
  (16, TextureComponentSwizzle.relocs64), (64, TextureViewDescriptor.relocs64),
  (32, VertexAttribute.relocs64), (120, BindGroupLayoutEntry.relocs64),
  (24, BlendState.relocs64), (32, ComputePassDescriptor.relocs64),
  (72, DepthStencilState.relocs64), (16, FutureWaitInfo.relocs64),
  (72, RenderPassColorAttachment.relocs64), (24, TexelCopyBufferInfo.relocs64),
  (32, TexelCopyTextureInfo.relocs64),
  (32, TextureComponentSwizzleDescriptor.relocs64),
  (32, ColorTargetState.relocs64)
]

/-- The tables C reads are the tables the walk reads. -/
theorem tables64_eq :
    tables64.toList = specs64.toList.map fun (size, relocs) =>
      serialize size relocs :=
  rfl

/-- Every struct's table on wasm32, by its index. -/
def tables32 : Array ByteArray := #[
  BindGroupEntry.table32, BlendComponent.table32, BufferBindingLayout.table32,
  BufferDescriptor.table32, Color.table32, CommandBufferDescriptor.table32,
  CommandEncoderDescriptor.table32, CompatibilityModeLimits.table32,
  ConstantEntry.table32, Extent3D.table32, ExternalTextureBindingEntry.table32,
  ExternalTextureBindingLayout.table32, Future.table32, InstanceLimits.table32,
  Limits.table32, MultisampleState.table32, Origin3D.table32,
  PassTimestampWrites.table32, PrimitiveState.table32,
  QuerySetDescriptor.table32, QueueDescriptor.table32,
  RenderBundleDescriptor.table32, RenderPassDepthStencilAttachment.table32,
  RenderPassMaxDrawCount.table32, RequestAdapterOptions.table32,
  RequestAdapterWebXROptions.table32, SamplerBindingLayout.table32,
  SamplerDescriptor.table32, ShaderModuleDescriptor.table32,
  ShaderSourceWGSL.table32, StencilFaceState.table32,
  StorageTextureBindingLayout.table32, SurfaceColorManagement.table32,
  SurfaceDescriptor.table32, SurfaceTexture.table32,
  TexelCopyBufferLayout.table32, TextureBindingLayout.table32,
  TextureBindingViewDimension.table32, TextureComponentSwizzle.table32,
  TextureViewDescriptor.table32, VertexAttribute.table32,
  BindGroupLayoutEntry.table32, BlendState.table32,
  ComputePassDescriptor.table32, DepthStencilState.table32,
  FutureWaitInfo.table32, RenderPassColorAttachment.table32,
  TexelCopyBufferInfo.table32, TexelCopyTextureInfo.table32,
  TextureComponentSwizzleDescriptor.table32, ColorTargetState.table32
]

/-- Every struct's table on wasm32, as the walk reads it. -/
noncomputable def specs32 : Array Spec := #[
  (40, BindGroupEntry.relocs32), (12, BlendComponent.relocs32),
  (24, BufferBindingLayout.relocs32), (40, BufferDescriptor.relocs32),
  (32, Color.relocs32), (12, CommandBufferDescriptor.relocs32),
  (12, CommandEncoderDescriptor.relocs32),
  (24, CompatibilityModeLimits.relocs32), (24, ConstantEntry.relocs32),
  (12, Extent3D.relocs32), (12, ExternalTextureBindingEntry.relocs32),
  (8, ExternalTextureBindingLayout.relocs32), (8, Future.relocs32),
  (8, InstanceLimits.relocs32), (152, Limits.relocs32),
  (16, MultisampleState.relocs32), (12, Origin3D.relocs32),
  (16, PassTimestampWrites.relocs32), (24, PrimitiveState.relocs32),
  (20, QuerySetDescriptor.relocs32), (12, QueueDescriptor.relocs32),
  (12, RenderBundleDescriptor.relocs32),
  (40, RenderPassDepthStencilAttachment.relocs32),
  (16, RenderPassMaxDrawCount.relocs32), (24, RequestAdapterOptions.relocs32),
  (12, RequestAdapterWebXROptions.relocs32), (8, SamplerBindingLayout.relocs32),
  (52, SamplerDescriptor.relocs32), (12, ShaderModuleDescriptor.relocs32),
  (16, ShaderSourceWGSL.relocs32), (16, StencilFaceState.relocs32),
  (16, StorageTextureBindingLayout.relocs32),
  (16, SurfaceColorManagement.relocs32), (12, SurfaceDescriptor.relocs32),
  (12, SurfaceTexture.relocs32), (16, TexelCopyBufferLayout.relocs32),
  (16, TextureBindingLayout.relocs32),
  (12, TextureBindingViewDimension.relocs32),
  (16, TextureComponentSwizzle.relocs32), (48, TextureViewDescriptor.relocs32),
  (24, VertexAttribute.relocs32), (88, BindGroupLayoutEntry.relocs32),
  (24, BlendState.relocs32), (16, ComputePassDescriptor.relocs32),
  (68, DepthStencilState.relocs32), (16, FutureWaitInfo.relocs32),
  (56, RenderPassColorAttachment.relocs32), (24, TexelCopyBufferInfo.relocs32),
  (24, TexelCopyTextureInfo.relocs32),
  (24, TextureComponentSwizzleDescriptor.relocs32),
  (24, ColorTargetState.relocs32)
]

/-- The tables C reads are the tables the walk reads. -/
theorem tables32_eq :
    tables32.toList = specs32.toList.map fun (size, relocs) =>
      serialize size relocs :=
  rfl

/-- Every table on this target. -/
@[inline]
def tables : Array ByteArray :=
  if System.Platform.numBits = 64 then tables64 else tables32

namespace BindGroupEntry

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[0]? = some (56, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : BindGroupEntry) (ts : List Target) :
    walk specs64 0 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : BindGroupEntry) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[0]? = some (40, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : BindGroupEntry) (ts : List Target) :
    walk specs32 0 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : BindGroupEntry) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end BindGroupEntry

namespace BlendComponent

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[1]? = some (12, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : BlendComponent) (ts : List Target) :
    walk specs64 1 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : BlendComponent) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[1]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : BlendComponent) (ts : List Target) :
    walk specs32 1 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : BlendComponent) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end BlendComponent

namespace BufferBindingLayout

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[2]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : BufferBindingLayout) (ts : List Target) :
    walk specs64 2 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : BufferBindingLayout) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[2]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : BufferBindingLayout) (ts : List Target) :
    walk specs32 2 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : BufferBindingLayout) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end BufferBindingLayout

namespace BufferDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[3]? = some (48, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : BufferDescriptor) (ts : List Target) :
    walk specs64 3 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : BufferDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[3]? = some (40, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : BufferDescriptor) (ts : List Target) :
    walk specs32 3 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : BufferDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end BufferDescriptor

namespace Color

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[4]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : Color) (ts : List Target) :
    walk specs64 4 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : Color) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[4]? = some (32, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : Color) (ts : List Target) :
    walk specs32 4 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : Color) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end Color

namespace CommandBufferDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[5]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : CommandBufferDescriptor) (ts : List Target) :
    walk specs64 5 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : CommandBufferDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[5]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : CommandBufferDescriptor) (ts : List Target) :
    walk specs32 5 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : CommandBufferDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end CommandBufferDescriptor

namespace CommandEncoderDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[6]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : CommandEncoderDescriptor) (ts : List Target) :
    walk specs64 6 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : CommandEncoderDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[6]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : CommandEncoderDescriptor) (ts : List Target) :
    walk specs32 6 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : CommandEncoderDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end CommandEncoderDescriptor

namespace CompatibilityModeLimits

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[7]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : CompatibilityModeLimits) (ts : List Target) :
    walk specs64 7 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : CompatibilityModeLimits) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[7]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : CompatibilityModeLimits) (ts : List Target) :
    walk specs32 7 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : CompatibilityModeLimits) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end CompatibilityModeLimits

namespace ConstantEntry

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[8]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : ConstantEntry) (ts : List Target) :
    walk specs64 8 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : ConstantEntry) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[8]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : ConstantEntry) (ts : List Target) :
    walk specs32 8 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : ConstantEntry) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end ConstantEntry

namespace Extent3D

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[9]? = some (12, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : Extent3D) (ts : List Target) :
    walk specs64 9 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : Extent3D) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[9]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : Extent3D) (ts : List Target) :
    walk specs32 9 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : Extent3D) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end Extent3D

namespace ExternalTextureBindingEntry

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[10]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : ExternalTextureBindingEntry) (ts : List Target) :
    walk specs64 10 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : ExternalTextureBindingEntry) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[10]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : ExternalTextureBindingEntry) (ts : List Target) :
    walk specs32 10 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : ExternalTextureBindingEntry) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end ExternalTextureBindingEntry

namespace ExternalTextureBindingLayout

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[11]? = some (16, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : ExternalTextureBindingLayout) (ts : List Target) :
    walk specs64 11 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : ExternalTextureBindingLayout)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[11]? = some (8, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : ExternalTextureBindingLayout) (ts : List Target) :
    walk specs32 11 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : ExternalTextureBindingLayout)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end ExternalTextureBindingLayout

namespace Future

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[12]? = some (8, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : Future) (ts : List Target) :
    walk specs64 12 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : Future) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[12]? = some (8, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : Future) (ts : List Target) :
    walk specs32 12 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : Future) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end Future

namespace InstanceLimits

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[13]? = some (16, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : InstanceLimits) (ts : List Target) :
    walk specs64 13 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : InstanceLimits) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[13]? = some (8, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : InstanceLimits) (ts : List Target) :
    walk specs32 13 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : InstanceLimits) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end InstanceLimits

namespace Limits

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[14]? = some (152, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : Limits) (ts : List Target) :
    walk specs64 14 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : Limits) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[14]? = some (152, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : Limits) (ts : List Target) :
    walk specs32 14 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : Limits) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end Limits

namespace MultisampleState

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[15]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : MultisampleState) (ts : List Target) :
    walk specs64 15 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : MultisampleState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[15]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : MultisampleState) (ts : List Target) :
    walk specs32 15 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : MultisampleState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end MultisampleState

namespace Origin3D

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[16]? = some (12, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : Origin3D) (ts : List Target) :
    walk specs64 16 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : Origin3D) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[16]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : Origin3D) (ts : List Target) :
    walk specs32 16 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : Origin3D) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end Origin3D

namespace PassTimestampWrites

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[17]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : PassTimestampWrites) (ts : List Target) :
    walk specs64 17 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : PassTimestampWrites) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[17]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : PassTimestampWrites) (ts : List Target) :
    walk specs32 17 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : PassTimestampWrites) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end PassTimestampWrites

namespace PrimitiveState

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[18]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : PrimitiveState) (ts : List Target) :
    walk specs64 18 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : PrimitiveState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[18]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : PrimitiveState) (ts : List Target) :
    walk specs32 18 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : PrimitiveState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end PrimitiveState

namespace QuerySetDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[19]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : QuerySetDescriptor) (ts : List Target) :
    walk specs64 19 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : QuerySetDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[19]? = some (20, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : QuerySetDescriptor) (ts : List Target) :
    walk specs32 19 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : QuerySetDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end QuerySetDescriptor

namespace QueueDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[20]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : QueueDescriptor) (ts : List Target) :
    walk specs64 20 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : QueueDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[20]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : QueueDescriptor) (ts : List Target) :
    walk specs32 20 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : QueueDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end QueueDescriptor

namespace RenderBundleDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[21]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : RenderBundleDescriptor) (ts : List Target) :
    walk specs64 21 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : RenderBundleDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[21]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : RenderBundleDescriptor) (ts : List Target) :
    walk specs32 21 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : RenderBundleDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end RenderBundleDescriptor

namespace RenderPassDepthStencilAttachment

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[22]? = some (48, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : RenderPassDepthStencilAttachment) (ts : List Target) :
    walk specs64 22 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : RenderPassDepthStencilAttachment)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[22]? = some (40, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : RenderPassDepthStencilAttachment) (ts : List Target) :
    walk specs32 22 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : RenderPassDepthStencilAttachment)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end RenderPassDepthStencilAttachment

namespace RenderPassMaxDrawCount

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[23]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : RenderPassMaxDrawCount) (ts : List Target) :
    walk specs64 23 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : RenderPassMaxDrawCount) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[23]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : RenderPassMaxDrawCount) (ts : List Target) :
    walk specs32 23 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : RenderPassMaxDrawCount) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end RenderPassMaxDrawCount

namespace RequestAdapterOptions

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[24]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : RequestAdapterOptions) (ts : List Target) :
    walk specs64 24 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : RequestAdapterOptions) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[24]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : RequestAdapterOptions) (ts : List Target) :
    walk specs32 24 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : RequestAdapterOptions) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end RequestAdapterOptions

namespace RequestAdapterWebXROptions

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[25]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : RequestAdapterWebXROptions) (ts : List Target) :
    walk specs64 25 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : RequestAdapterWebXROptions) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[25]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : RequestAdapterWebXROptions) (ts : List Target) :
    walk specs32 25 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : RequestAdapterWebXROptions) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end RequestAdapterWebXROptions

namespace SamplerBindingLayout

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[26]? = some (16, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : SamplerBindingLayout) (ts : List Target) :
    walk specs64 26 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : SamplerBindingLayout) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[26]? = some (8, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : SamplerBindingLayout) (ts : List Target) :
    walk specs32 26 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : SamplerBindingLayout) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end SamplerBindingLayout

namespace SamplerDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[27]? = some (64, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : SamplerDescriptor) (ts : List Target) :
    walk specs64 27 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : SamplerDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[27]? = some (52, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : SamplerDescriptor) (ts : List Target) :
    walk specs32 27 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : SamplerDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end SamplerDescriptor

namespace ShaderModuleDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[28]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : ShaderModuleDescriptor) (ts : List Target) :
    walk specs64 28 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : ShaderModuleDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[28]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : ShaderModuleDescriptor) (ts : List Target) :
    walk specs32 28 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : ShaderModuleDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end ShaderModuleDescriptor

namespace ShaderSourceWGSL

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[29]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : ShaderSourceWGSL) (ts : List Target) :
    walk specs64 29 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : ShaderSourceWGSL) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[29]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : ShaderSourceWGSL) (ts : List Target) :
    walk specs32 29 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : ShaderSourceWGSL) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end ShaderSourceWGSL

namespace StencilFaceState

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[30]? = some (16, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : StencilFaceState) (ts : List Target) :
    walk specs64 30 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : StencilFaceState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[30]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : StencilFaceState) (ts : List Target) :
    walk specs32 30 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : StencilFaceState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end StencilFaceState

namespace StorageTextureBindingLayout

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[31]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : StorageTextureBindingLayout) (ts : List Target) :
    walk specs64 31 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : StorageTextureBindingLayout) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[31]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : StorageTextureBindingLayout) (ts : List Target) :
    walk specs32 31 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : StorageTextureBindingLayout) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end StorageTextureBindingLayout

namespace SurfaceColorManagement

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[32]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : SurfaceColorManagement) (ts : List Target) :
    walk specs64 32 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : SurfaceColorManagement) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[32]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : SurfaceColorManagement) (ts : List Target) :
    walk specs32 32 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : SurfaceColorManagement) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end SurfaceColorManagement

namespace SurfaceDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[33]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : SurfaceDescriptor) (ts : List Target) :
    walk specs64 33 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : SurfaceDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[33]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : SurfaceDescriptor) (ts : List Target) :
    walk specs32 33 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : SurfaceDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end SurfaceDescriptor

namespace SurfaceTexture

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[34]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : SurfaceTexture) (ts : List Target) :
    walk specs64 34 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : SurfaceTexture) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[34]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : SurfaceTexture) (ts : List Target) :
    walk specs32 34 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : SurfaceTexture) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end SurfaceTexture

namespace TexelCopyBufferLayout

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[35]? = some (16, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : TexelCopyBufferLayout) (ts : List Target) :
    walk specs64 35 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : TexelCopyBufferLayout) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[35]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : TexelCopyBufferLayout) (ts : List Target) :
    walk specs32 35 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : TexelCopyBufferLayout) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end TexelCopyBufferLayout

namespace TextureBindingLayout

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[36]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : TextureBindingLayout) (ts : List Target) :
    walk specs64 36 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : TextureBindingLayout) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[36]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : TextureBindingLayout) (ts : List Target) :
    walk specs32 36 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : TextureBindingLayout) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end TextureBindingLayout

namespace TextureBindingViewDimension

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[37]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : TextureBindingViewDimension) (ts : List Target) :
    walk specs64 37 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : TextureBindingViewDimension) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[37]? = some (12, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : TextureBindingViewDimension) (ts : List Target) :
    walk specs32 37 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : TextureBindingViewDimension) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end TextureBindingViewDimension

namespace TextureComponentSwizzle

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[38]? = some (16, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : TextureComponentSwizzle) (ts : List Target) :
    walk specs64 38 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : TextureComponentSwizzle) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[38]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : TextureComponentSwizzle) (ts : List Target) :
    walk specs32 38 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : TextureComponentSwizzle) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end TextureComponentSwizzle

namespace TextureViewDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[39]? = some (64, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : TextureViewDescriptor) (ts : List Target) :
    walk specs64 39 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : TextureViewDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[39]? = some (48, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : TextureViewDescriptor) (ts : List Target) :
    walk specs32 39 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : TextureViewDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end TextureViewDescriptor

namespace VertexAttribute

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[40]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : VertexAttribute) (ts : List Target) :
    walk specs64 40 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : VertexAttribute) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[40]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : VertexAttribute) (ts : List Target) :
    walk specs32 40 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : VertexAttribute) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end VertexAttribute

namespace BindGroupLayoutEntry

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[41]? = some (120, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : BindGroupLayoutEntry) (ts : List Target) :
    walk specs64 41 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : BindGroupLayoutEntry) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[41]? = some (88, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : BindGroupLayoutEntry) (ts : List Target) :
    walk specs32 41 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : BindGroupLayoutEntry) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end BindGroupLayoutEntry

namespace BlendState

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[42]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : BlendState) (ts : List Target) :
    walk specs64 42 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : BlendState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[42]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : BlendState) (ts : List Target) :
    walk specs32 42 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : BlendState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end BlendState

namespace ComputePassDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[43]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : ComputePassDescriptor) (ts : List Target) :
    walk specs64 43 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  cases h0 : d.timestampWrites <;>
    simp [
      relocs64, targets64, step, h0, PassTimestampWrites.block64,
      PassTimestampWrites.walk64,
      walk_empty PassTimestampWrites.specs64_index (by decide)]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : ComputePassDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[43]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : ComputePassDescriptor) (ts : List Target) :
    walk specs32 43 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  cases h0 : d.timestampWrites <;>
    simp [
      relocs32, targets32, step, h0, PassTimestampWrites.block32,
      PassTimestampWrites.walk32,
      walk_empty PassTimestampWrites.specs32_index (by decide)]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : ComputePassDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end ComputePassDescriptor

namespace DepthStencilState

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[44]? = some (72, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : DepthStencilState) (ts : List Target) :
    walk specs64 44 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : DepthStencilState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[44]? = some (68, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : DepthStencilState) (ts : List Target) :
    walk specs32 44 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : DepthStencilState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end DepthStencilState

namespace FutureWaitInfo

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[45]? = some (16, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : FutureWaitInfo) (ts : List Target) :
    walk specs64 45 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : FutureWaitInfo) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[45]? = some (16, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : FutureWaitInfo) (ts : List Target) :
    walk specs32 45 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : FutureWaitInfo) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end FutureWaitInfo

namespace RenderPassColorAttachment

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[46]? = some (72, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : RenderPassColorAttachment) (ts : List Target) :
    walk specs64 46 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : RenderPassColorAttachment) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[46]? = some (56, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : RenderPassColorAttachment) (ts : List Target) :
    walk specs32 46 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : RenderPassColorAttachment) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end RenderPassColorAttachment

namespace TexelCopyBufferInfo

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[47]? = some (24, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : TexelCopyBufferInfo) (ts : List Target) :
    walk specs64 47 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : TexelCopyBufferInfo) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[47]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : TexelCopyBufferInfo) (ts : List Target) :
    walk specs32 47 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : TexelCopyBufferInfo) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end TexelCopyBufferInfo

namespace TexelCopyTextureInfo

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[48]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : TexelCopyTextureInfo) (ts : List Target) :
    walk specs64 48 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : TexelCopyTextureInfo) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[48]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : TexelCopyTextureInfo) (ts : List Target) :
    walk specs32 48 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : TexelCopyTextureInfo) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end TexelCopyTextureInfo

namespace TextureComponentSwizzleDescriptor

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[49]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : TextureComponentSwizzleDescriptor) (ts : List Target) :
    walk specs64 49 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  simp [relocs64, targets64, step]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : TextureComponentSwizzleDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[49]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : TextureComponentSwizzleDescriptor) (ts : List Target) :
    walk specs32 49 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  simp [relocs32, targets32, step]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : TextureComponentSwizzleDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end TextureComponentSwizzleDescriptor

namespace ColorTargetState

/-- Its index finds its tables. -/
theorem tables_index :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem specs64_index : specs64[50]? = some (32, relocs64) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk64 (d : ColorTargetState) (ts : List Target) :
    walk specs64 50 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts := by
  rw [walk, specs64_index, size_encode64]
  cases h0 : d.blend <;>
    simp [
      relocs64, targets64, step, h0, BlendState.block64, BlendState.walk64,
      walk_empty BlendState.specs64_index (by decide)]

/-- The same, at its index. -/
theorem walk64_tableIndex (d : ColorTargetState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem specs32_index : specs32[50]? = some (24, relocs32) :=
  rfl

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk32 (d : ColorTargetState) (ts : List Target) :
    walk specs32 50 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts := by
  rw [walk, specs32_index, size_encode32]
  cases h0 : d.blend <;>
    simp [
      relocs32, targets32, step, h0, BlendState.block32, BlendState.walk32,
      walk_empty BlendState.specs32_index (by decide)]

/-- The same, at its index. -/
theorem walk32_tableIndex (d : ColorTargetState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk32 d ts

end ColorTargetState

end WebGPU.Raw

end
