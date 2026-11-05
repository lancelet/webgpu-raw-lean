/-
================================================================================
  GENERATED FILE: DO NOT EDIT BY HAND

  Generator:        webgpu-gen
  Generator commit: 14888c0 (clean)
  Generated:        2026-11-05 11:34:27 UTC
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

Where C fills in a struct's pointers is its table (`currentTables`, at
`tableIndex`), proved to be its pointers; what it fills each in from,
its targets (`toTargets`), proved to be what walking its table takes
(`walk_encode64`, `walk_encode32`).
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

/-! ### `BlendComponent` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 2

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BlendComponent) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end BlendComponent

/-! ### `BufferBindingLayout` -/

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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 3

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BufferBindingLayout) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end BufferBindingLayout

/-! ### `BufferDescriptor` -/

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
  48, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  40, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 4

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BufferDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end BufferDescriptor

/-! ### `Color` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 5

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : Color) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end Color

/-! ### `CommandBufferDescriptor` -/

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
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 6

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : CommandBufferDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end CommandBufferDescriptor

/-! ### `CommandEncoderDescriptor` -/

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
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 7

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : CommandEncoderDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end CommandEncoderDescriptor

/-! ### `CompatibilityModeLimits` -/

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
  32, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 8

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : CompatibilityModeLimits) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end CompatibilityModeLimits

/-! ### `ConstantEntry` -/

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
  32, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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

/-- `d` poked into `b` at `off`, as `encode64` lays it out. -/
@[inline]
def encodeInto64 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 32 ≤ total) (d : ConstantEntry) :
    Block total :=
  let b := b.pokeU64 (off + 16) d.key.utf8ByteSize.toUInt64 (by omega)
  let b := b.pokeF64 (off + 24) d.value (by omega)
  b

/-- An array of them, encoded in turn into one block, on 64-bit targets. -/
@[noinline, never_extract]
def encodeAll64 (xs : Array ConstantEntry) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 32))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 32)) :
      Block (xs.size * 32) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto64 b (i * 32) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll64 (xs : Array ConstantEntry) :
    (encodeAll64 xs).size = xs.size * 32 :=
  (encodeAll64.go xs 0 (Block.fresh (xs.size * 32))).2

/-- What C fills in an array of them's pointers from on 64-bit targets. -/
@[never_extract]
def targetsAll64 (xs : Array ConstantEntry) : Array Target :=
  targetsOfAll targets64 xs

/-- An array of them as a block on 64-bit targets, and its targets. -/
@[never_extract]
def array64 (xs : Array ConstantEntry) : Array Target :=
  #[.block (encodeAll64 xs)] ++ targetsAll64 xs

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
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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

/-- `d` poked into `b` at `off`, as `encode32` lays it out. -/
@[inline]
def encodeInto32 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 24 ≤ total) (d : ConstantEntry) :
    Block total :=
  let b := b.pokeU32 (off + 8) d.key.utf8ByteSize.toUInt32 (by omega)
  let b := b.pokeF64 (off + 16) d.value (by omega)
  b

/-- An array of them, encoded in turn into one block, on wasm32. -/
@[noinline, never_extract]
def encodeAll32 (xs : Array ConstantEntry) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 24))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 24)) :
      Block (xs.size * 24) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto32 b (i * 24) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll32 (xs : Array ConstantEntry) :
    (encodeAll32 xs).size = xs.size * 24 :=
  (encodeAll32.go xs 0 (Block.fresh (xs.size * 24))).2

/-- What C fills in an array of them's pointers from on wasm32. -/
@[never_extract]
def targetsAll32 (xs : Array ConstantEntry) : Array Target :=
  targetsOfAll targets32 xs

/-- An array of them as a block on wasm32, and its targets. -/
@[never_extract]
def array32 (xs : Array ConstantEntry) : Array Target :=
  #[.block (encodeAll32 xs)] ++ targetsAll32 xs

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 9

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ConstantEntry) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end ConstantEntry

/-! ### `Extent3D` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 10

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : Extent3D) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end Extent3D

/-! ### `ExternalTextureBindingEntry` -/

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
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 2,
  0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 11

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ExternalTextureBindingEntry) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end ExternalTextureBindingEntry

/-! ### `ExternalTextureBindingLayout` -/

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
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  8, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 12

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ExternalTextureBindingLayout) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end ExternalTextureBindingLayout

/-! ### `Future` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 13

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : Future) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end Future

/-! ### `InstanceLimits` -/

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
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  8, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  Width.is64 () || sizeFits d.timedWaitAnyMaxCount

/--
`d` as C lays it out on this target, its pointers 0. The caller checks
`sizesFit d` first: on wasm32, a `size_t` that does not fit is cut to its
low 32 bits.
-/
@[inline]
def toBytes (d : InstanceLimits) : ByteArray :=
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 14

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : InstanceLimits) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end InstanceLimits

/-! ### `MultisampleState` -/

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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 15

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : MultisampleState) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end MultisampleState

/-! ### `Origin3D` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 16

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : Origin3D) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end Origin3D

/-! ### `PassTimestampWrites` -/

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
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  16, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 17

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : PassTimestampWrites) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end PassTimestampWrites

/-! ### `PipelineLayoutDescriptor` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩, ⟨32, .block 1⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  48, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 48 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : PipelineLayoutDescriptor) : Array Target :=
  #[.string d.label, .block (objectsBlock 8 d.bindGroupLayouts)]
  ++ objectsOf Internal.BindGroupLayout.toObject d.bindGroupLayouts

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : PipelineLayoutDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩, ⟨16, .block 1⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : PipelineLayoutDescriptor) : Array Target :=
  #[.string d.label, .block (objectsBlock 4 d.bindGroupLayouts)]
  ++ objectsOf Internal.BindGroupLayout.toObject d.bindGroupLayouts

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : PipelineLayoutDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 18

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : PipelineLayoutDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end PipelineLayoutDescriptor

/-! ### `PrimitiveState` -/

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
  32, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 19

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : PrimitiveState) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end PrimitiveState

/-! ### `QuerySetDescriptor` -/

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
  32, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  20, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 20

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : QuerySetDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end QuerySetDescriptor

/-! ### `QueueDescriptor` -/

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
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 21

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : QueueDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end QueueDescriptor

/-! ### `RenderBundleDescriptor` -/

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
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 22

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderBundleDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end RenderBundleDescriptor

/-! ### `RenderBundleEncoderDescriptor` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩, ⟨32, .block 0⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  56, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 56 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : RenderBundleEncoderDescriptor) : Array Target :=
  #[.string d.label, .block (encodeU32s CEnum.toC d.colorFormats)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : RenderBundleEncoderDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩, ⟨16, .block 0⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  36, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 36 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : RenderBundleEncoderDescriptor) : Array Target :=
  #[.string d.label, .block (encodeU32s CEnum.toC d.colorFormats)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : RenderBundleEncoderDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 23

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderBundleEncoderDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end RenderBundleEncoderDescriptor

/-! ### `RenderPassDepthStencilAttachment` -/

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
  48, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  40, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 24

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderPassDepthStencilAttachment) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end RenderPassDepthStencilAttachment

/-! ### `RenderPassMaxDrawCount` -/

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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 25

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderPassMaxDrawCount) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end RenderPassMaxDrawCount

/-! ### `RequestAdapterWebXROptions` -/

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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  12, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 26

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RequestAdapterWebXROptions) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end RequestAdapterWebXROptions

/-! ### `SamplerBindingLayout` -/

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
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  8, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 27

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SamplerBindingLayout) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end SamplerBindingLayout

/-! ### `SamplerDescriptor` -/

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
  64, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  52, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 28

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SamplerDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end SamplerDescriptor

/-! ### `ShaderSourceWGSL` -/

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
  32, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  16, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 29

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ShaderSourceWGSL) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end ShaderSourceWGSL

/-! ### `StencilFaceState` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 30

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : StencilFaceState) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end StencilFaceState

/-! ### `StorageTextureBindingLayout` -/

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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 31

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : StorageTextureBindingLayout) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end StorageTextureBindingLayout

/-! ### `SupportedFeatures` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨8, .block 0⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 8, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 16 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : SupportedFeatures) : Array Target :=
  #[.block (encodeU32s CEnum.toC d.features)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : SupportedFeatures) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨4, .block 0⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  8, 0, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 8 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : SupportedFeatures) : Array Target :=
  #[.block (encodeU32s CEnum.toC d.features)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : SupportedFeatures) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 32

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SupportedFeatures) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end SupportedFeatures

/-! ### `SupportedInstanceFeatures` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨8, .block 0⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 8, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 16 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : SupportedInstanceFeatures) : Array Target :=
  #[.block (encodeU32s CEnum.toC d.features)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : SupportedInstanceFeatures) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨4, .block 0⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  8, 0, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 8 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : SupportedInstanceFeatures) : Array Target :=
  #[.block (encodeU32s CEnum.toC d.features)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : SupportedInstanceFeatures) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 33

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SupportedInstanceFeatures) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end SupportedInstanceFeatures

/-! ### `SupportedWGSLLanguageFeatures` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨8, .block 0⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  16, 0, 0, 0, 1, 0, 0, 0, 8, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 16 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : SupportedWGSLLanguageFeatures) : Array Target :=
  #[.block (encodeU32s CEnum.toC d.features)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : SupportedWGSLLanguageFeatures) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨4, .block 0⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  8, 0, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 8 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : SupportedWGSLLanguageFeatures) : Array Target :=
  #[.block (encodeU32s CEnum.toC d.features)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : SupportedWGSLLanguageFeatures) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 34

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SupportedWGSLLanguageFeatures) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end SupportedWGSLLanguageFeatures

/-! ### `SurfaceCapabilities` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨24, .block 0⟩, ⟨40, .block 0⟩, ⟨56, .block 0⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  64, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 4,
  0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 4, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 64 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : SurfaceCapabilities) : Array Target :=
  #[
    .block (encodeU32s CEnum.toC d.formats),
    .block (encodeU32s CEnum.toC d.presentModes),
    .block (encodeU32s CEnum.toC d.alphaModes)
  ]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : SurfaceCapabilities) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨20, .block 0⟩, ⟨28, .block 0⟩, ⟨36, .block 0⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  40, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 4,
  0, 0, 0, 0, 0, 0, 0, 28, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 36, 0, 0, 0, 4, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 40 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : SurfaceCapabilities) : Array Target :=
  #[
    .block (encodeU32s CEnum.toC d.formats),
    .block (encodeU32s CEnum.toC d.presentModes),
    .block (encodeU32s CEnum.toC d.alphaModes)
  ]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : SurfaceCapabilities) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 35

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SurfaceCapabilities) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end SurfaceCapabilities

/-! ### `SurfaceColorManagement` -/

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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 36

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SurfaceColorManagement) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end SurfaceColorManagement

/-! ### `SurfaceConfiguration` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .object⟩, ⟨48, .block 0⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  64, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 64 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : SurfaceConfiguration) : Array Target :=
  #[
    .object (Internal.Device.toObject d.device),
    .block (encodeU32s CEnum.toC d.viewFormats)
  ]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : SurfaceConfiguration) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .object⟩, ⟨36, .block 0⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  48, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0, 36, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 48 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : SurfaceConfiguration) : Array Target :=
  #[
    .object (Internal.Device.toObject d.device),
    .block (encodeU32s CEnum.toC d.viewFormats)
  ]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : SurfaceConfiguration) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 37

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SurfaceConfiguration) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end SurfaceConfiguration

/-! ### `SurfaceDescriptor` -/

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
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 38

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SurfaceDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end SurfaceDescriptor

/-! ### `SurfaceTexture` -/

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
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 39

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : SurfaceTexture) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end SurfaceTexture

/-! ### `TexelCopyBufferLayout` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 40

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TexelCopyBufferLayout) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end TexelCopyBufferLayout

/-! ### `TextureBindingLayout` -/

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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 41

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureBindingLayout) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end TextureBindingLayout

/-! ### `TextureBindingViewDimension` -/

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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  12, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 42

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureBindingViewDimension) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end TextureBindingViewDimension

/-! ### `TextureComponentSwizzle` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 43

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureComponentSwizzle) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end TextureComponentSwizzle

/-! ### `VertexAttribute` -/

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
  32, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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

/-- `d` poked into `b` at `off`, as `encode64` lays it out. -/
@[inline]
def encodeInto64 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 32 ≤ total) (d : VertexAttribute) :
    Block total :=
  let b := b.pokeU32 (off + 8) (CEnum.toC d.format) (by omega)
  let b := b.pokeU64 (off + 16) d.offset (by omega)
  let b := b.pokeU32 (off + 24) d.shaderLocation (by omega)
  b

/-- An array of them, encoded in turn into one block, on 64-bit targets. -/
@[noinline, never_extract]
def encodeAll64 (xs : Array VertexAttribute) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 32))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 32)) :
      Block (xs.size * 32) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto64 b (i * 32) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll64 (xs : Array VertexAttribute) :
    (encodeAll64 xs).size = xs.size * 32 :=
  (encodeAll64.go xs 0 (Block.fresh (xs.size * 32))).2

/-- What C fills in an array of them's pointers from on 64-bit targets. -/
@[never_extract]
def targetsAll64 (xs : Array VertexAttribute) : Array Target :=
  targetsOfAll targets64 xs

/-- An array of them as a block on 64-bit targets, and its targets. -/
@[never_extract]
def array64 (xs : Array VertexAttribute) : Array Target :=
  #[.block (encodeAll64 xs)] ++ targetsAll64 xs

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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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

/-- `d` poked into `b` at `off`, as `encode32` lays it out. -/
@[inline]
def encodeInto32 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 24 ≤ total) (d : VertexAttribute) :
    Block total :=
  let b := b.pokeU32 (off + 4) (CEnum.toC d.format) (by omega)
  let b := b.pokeU64 (off + 8) d.offset (by omega)
  let b := b.pokeU32 (off + 16) d.shaderLocation (by omega)
  b

/-- An array of them, encoded in turn into one block, on wasm32. -/
@[noinline, never_extract]
def encodeAll32 (xs : Array VertexAttribute) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 24))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 24)) :
      Block (xs.size * 24) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto32 b (i * 24) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll32 (xs : Array VertexAttribute) :
    (encodeAll32 xs).size = xs.size * 24 :=
  (encodeAll32.go xs 0 (Block.fresh (xs.size * 24))).2

/-- What C fills in an array of them's pointers from on wasm32. -/
@[never_extract]
def targetsAll32 (xs : Array VertexAttribute) : Array Target :=
  targetsOfAll targets32 xs

/-- An array of them as a block on wasm32, and its targets. -/
@[never_extract]
def array32 (xs : Array VertexAttribute) : Array Target :=
  #[.block (encodeAll32 xs)] ++ targetsAll32 xs

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 44

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : VertexAttribute) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end VertexAttribute

/-! ### `BindGroupEntry` -/

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

/-- An element of its chain on 64-bit targets: its bytes, and its table. -/
@[never_extract]
def chainLink64 : Chained → ByteArray × Nat
  | .externalTextureBindingEntry x =>
    (ExternalTextureBindingEntry.encode64 x,
      ExternalTextureBindingEntry.tableIndex)

/-- What C fills in an element of its chain from on 64-bit targets. -/
@[never_extract]
def chainTargets64 : Chained → Array Target
  | .externalTextureBindingEntry x => ExternalTextureBindingEntry.targets64 x

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .chain⟩, ⟨16, .optObject⟩, ⟨40, .optObject⟩, ⟨48, .optObject⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  56, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 3,
  0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 3, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  chainTargetsOf chainLink64 chainTargets64 d.chain
  ++ #[
    .optObject (d.buffer.map Internal.Buffer.toObject),
    .optObject (d.sampler.map Internal.Sampler.toObject),
    .optObject (d.textureView.map Internal.TextureView.toObject)
  ]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : BindGroupEntry) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- `d` poked into `b` at `off`, as `encode64` lays it out. -/
@[inline]
def encodeInto64 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 56 ≤ total) (d : BindGroupEntry) :
    Block total :=
  let b := b.pokeU32 (off + 8) d.binding (by omega)
  let b := b.pokeU64 (off + 24) d.offset (by omega)
  let b := b.pokeU64 (off + 32) d.size (by omega)
  b

/-- An array of them, encoded in turn into one block, on 64-bit targets. -/
@[noinline, never_extract]
def encodeAll64 (xs : Array BindGroupEntry) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 56))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 56)) :
      Block (xs.size * 56) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto64 b (i * 56) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll64 (xs : Array BindGroupEntry) :
    (encodeAll64 xs).size = xs.size * 56 :=
  (encodeAll64.go xs 0 (Block.fresh (xs.size * 56))).2

/-- What C fills in an array of them's pointers from on 64-bit targets. -/
@[never_extract]
def targetsAll64 (xs : Array BindGroupEntry) : Array Target :=
  targetsOfAll targets64 xs

/-- An array of them as a block on 64-bit targets, and its targets. -/
@[never_extract]
def array64 (xs : Array BindGroupEntry) : Array Target :=
  #[.block (encodeAll64 xs)] ++ targetsAll64 xs

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

/-- An element of its chain on wasm32: its bytes, and its table. -/
@[never_extract]
def chainLink32 : Chained → ByteArray × Nat
  | .externalTextureBindingEntry x =>
    (ExternalTextureBindingEntry.encode32 x,
      ExternalTextureBindingEntry.tableIndex)

/-- What C fills in an element of its chain from on wasm32. -/
@[never_extract]
def chainTargets32 : Chained → Array Target
  | .externalTextureBindingEntry x => ExternalTextureBindingEntry.targets32 x

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .chain⟩, ⟨8, .optObject⟩, ⟨32, .optObject⟩, ⟨36, .optObject⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  40, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 3, 0,
  0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 36, 0, 0, 0, 3, 0, 0,
  0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  chainTargetsOf chainLink32 chainTargets32 d.chain
  ++ #[
    .optObject (d.buffer.map Internal.Buffer.toObject),
    .optObject (d.sampler.map Internal.Sampler.toObject),
    .optObject (d.textureView.map Internal.TextureView.toObject)
  ]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : BindGroupEntry) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/-- `d` poked into `b` at `off`, as `encode32` lays it out. -/
@[inline]
def encodeInto32 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 40 ≤ total) (d : BindGroupEntry) :
    Block total :=
  let b := b.pokeU32 (off + 4) d.binding (by omega)
  let b := b.pokeU64 (off + 16) d.offset (by omega)
  let b := b.pokeU64 (off + 24) d.size (by omega)
  b

/-- An array of them, encoded in turn into one block, on wasm32. -/
@[noinline, never_extract]
def encodeAll32 (xs : Array BindGroupEntry) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 40))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 40)) :
      Block (xs.size * 40) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto32 b (i * 40) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll32 (xs : Array BindGroupEntry) :
    (encodeAll32 xs).size = xs.size * 40 :=
  (encodeAll32.go xs 0 (Block.fresh (xs.size * 40))).2

/-- What C fills in an array of them's pointers from on wasm32. -/
@[never_extract]
def targetsAll32 (xs : Array BindGroupEntry) : Array Target :=
  targetsOfAll targets32 xs

/-- An array of them as a block on wasm32, and its targets. -/
@[never_extract]
def array32 (xs : Array BindGroupEntry) : Array Target :=
  #[.block (encodeAll32 xs)] ++ targetsAll32 xs

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 45

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BindGroupEntry) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end BindGroupEntry

/-! ### `BindGroupLayoutEntry` -/

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

/-- An element of its chain on 64-bit targets: its bytes, and its table. -/
@[never_extract]
def chainLink64 : Chained → ByteArray × Nat
  | .externalTextureBindingLayout x =>
    (ExternalTextureBindingLayout.encode64 x,
      ExternalTextureBindingLayout.tableIndex)

/-- What C fills in an element of its chain from on 64-bit targets. -/
@[never_extract]
def chainTargets64 : Chained → Array Target
  | .externalTextureBindingLayout x => ExternalTextureBindingLayout.targets64 x

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .chain⟩, ⟨32, .null⟩, ⟨56, .null⟩, ⟨72, .null⟩, ⟨96, .null⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  120, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 7,
  0, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 7, 0,
  0, 0, 0, 0, 0, 0, 96, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 120 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : BindGroupLayoutEntry) : Array Target :=
  chainTargetsOf chainLink64 chainTargets64 d.chain

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : BindGroupLayoutEntry) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- `d` poked into `b` at `off`, as `encode64` lays it out. -/
@[inline]
def encodeInto64 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 120 ≤ total) (d : BindGroupLayoutEntry) :
    Block total :=
  let b := b.pokeU32 (off + 8) d.binding (by omega)
  let b := b.pokeU64 (off + 16) d.visibility.bits (by omega)
  let b := b.pokeU32 (off + 24) d.bindingArraySize (by omega)
  let b := b.pokeU32 (off + 40) (CEnum.toC d.buffer.type) (by omega)
  let b := b.pokeU32 (off + 44) (wgpuBool d.buffer.hasDynamicOffset) (by omega)
  let b := b.pokeU64 (off + 48) d.buffer.minBindingSize (by omega)
  let b := b.pokeU32 (off + 64) (CEnum.toC d.sampler.type) (by omega)
  let b := b.pokeU32 (off + 80) (CEnum.toC d.texture.sampleType) (by omega)
  let b := b.pokeU32 (off + 84) (CEnum.toC d.texture.viewDimension) (by omega)
  let b := b.pokeU32 (off + 88) (wgpuBool d.texture.multisampled) (by omega)
  let b := b.pokeU32 (off + 104) (CEnum.toC d.storageTexture.access) (by omega)
  let b := b.pokeU32 (off + 108) (CEnum.toC d.storageTexture.format) (by omega)
  let b := b.pokeU32 (off + 112)
      (CEnum.toC d.storageTexture.viewDimension)
      (by omega)
  b

/-- An array of them, encoded in turn into one block, on 64-bit targets. -/
@[noinline, never_extract]
def encodeAll64 (xs : Array BindGroupLayoutEntry) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 120))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 120)) :
      Block (xs.size * 120) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto64 b (i * 120) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll64 (xs : Array BindGroupLayoutEntry) :
    (encodeAll64 xs).size = xs.size * 120 :=
  (encodeAll64.go xs 0 (Block.fresh (xs.size * 120))).2

/-- What C fills in an array of them's pointers from on 64-bit targets. -/
@[never_extract]
def targetsAll64 (xs : Array BindGroupLayoutEntry) : Array Target :=
  targetsOfAll targets64 xs

/-- An array of them as a block on 64-bit targets, and its targets. -/
@[never_extract]
def array64 (xs : Array BindGroupLayoutEntry) : Array Target :=
  #[.block (encodeAll64 xs)] ++ targetsAll64 xs

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

/-- An element of its chain on wasm32: its bytes, and its table. -/
@[never_extract]
def chainLink32 : Chained → ByteArray × Nat
  | .externalTextureBindingLayout x =>
    (ExternalTextureBindingLayout.encode32 x,
      ExternalTextureBindingLayout.tableIndex)

/-- What C fills in an element of its chain from on wasm32. -/
@[never_extract]
def chainTargets32 : Chained → Array Target
  | .externalTextureBindingLayout x => ExternalTextureBindingLayout.targets32 x

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .chain⟩, ⟨24, .null⟩, ⟨48, .null⟩, ⟨56, .null⟩, ⟨72, .null⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  88, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 7,
  0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 7, 0,
  0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 88 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : BindGroupLayoutEntry) : Array Target :=
  chainTargetsOf chainLink32 chainTargets32 d.chain

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : BindGroupLayoutEntry) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/-- `d` poked into `b` at `off`, as `encode32` lays it out. -/
@[inline]
def encodeInto32 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 88 ≤ total) (d : BindGroupLayoutEntry) :
    Block total :=
  let b := b.pokeU32 (off + 4) d.binding (by omega)
  let b := b.pokeU64 (off + 8) d.visibility.bits (by omega)
  let b := b.pokeU32 (off + 16) d.bindingArraySize (by omega)
  let b := b.pokeU32 (off + 28) (CEnum.toC d.buffer.type) (by omega)
  let b := b.pokeU32 (off + 32) (wgpuBool d.buffer.hasDynamicOffset) (by omega)
  let b := b.pokeU64 (off + 40) d.buffer.minBindingSize (by omega)
  let b := b.pokeU32 (off + 52) (CEnum.toC d.sampler.type) (by omega)
  let b := b.pokeU32 (off + 60) (CEnum.toC d.texture.sampleType) (by omega)
  let b := b.pokeU32 (off + 64) (CEnum.toC d.texture.viewDimension) (by omega)
  let b := b.pokeU32 (off + 68) (wgpuBool d.texture.multisampled) (by omega)
  let b := b.pokeU32 (off + 76) (CEnum.toC d.storageTexture.access) (by omega)
  let b := b.pokeU32 (off + 80) (CEnum.toC d.storageTexture.format) (by omega)
  let b := b.pokeU32 (off + 84)
      (CEnum.toC d.storageTexture.viewDimension)
      (by omega)
  b

/-- An array of them, encoded in turn into one block, on wasm32. -/
@[noinline, never_extract]
def encodeAll32 (xs : Array BindGroupLayoutEntry) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 88))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 88)) :
      Block (xs.size * 88) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto32 b (i * 88) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll32 (xs : Array BindGroupLayoutEntry) :
    (encodeAll32 xs).size = xs.size * 88 :=
  (encodeAll32.go xs 0 (Block.fresh (xs.size * 88))).2

/-- What C fills in an array of them's pointers from on wasm32. -/
@[never_extract]
def targetsAll32 (xs : Array BindGroupLayoutEntry) : Array Target :=
  targetsOfAll targets32 xs

/-- An array of them as a block on wasm32, and its targets. -/
@[never_extract]
def array32 (xs : Array BindGroupLayoutEntry) : Array Target :=
  #[.block (encodeAll32 xs)] ++ targetsAll32 xs

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 46

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BindGroupLayoutEntry) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end BindGroupLayoutEntry

/-! ### `BlendState` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 47

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BlendState) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end BlendState

/-! ### `ComputePassDescriptor` -/

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
  32, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 4, 0, 0, 0, 17, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  #[.string d.label] ++ optBlock PassTimestampWrites.block64 d.timestampWrites

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
  16, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 4, 0, 0, 0, 17, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  #[.string d.label] ++ optBlock PassTimestampWrites.block32 d.timestampWrites

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 48

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ComputePassDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end ComputePassDescriptor

/-! ### `ComputeState` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .object⟩, ⟨16, .optString⟩, ⟨40, .block 9⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  48, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 4, 0, 0,
  0, 9, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 48 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : ComputeState) : Array Target :=
  #[.object (Internal.ShaderModule.toObject d.module), .optString d.entryPoint]
  ++ ConstantEntry.array64 d.constants

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : ComputeState) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .object⟩, ⟨8, .optString⟩, ⟨20, .block 9⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 4, 0, 0, 0,
  9, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : ComputeState) : Array Target :=
  #[.object (Internal.ShaderModule.toObject d.module), .optString d.entryPoint]
  ++ ConstantEntry.array32 d.constants

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : ComputeState) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 49

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ComputeState) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end ComputeState

/-! ### `DepthStencilState` -/

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
  72, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  68, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 50

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : DepthStencilState) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end DepthStencilState

/-! ### `FutureWaitInfo` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 51

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : FutureWaitInfo) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end FutureWaitInfo

/-! ### `InstanceDescriptor` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨16, .block 0⟩, ⟨24, .block 14⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 4,
  0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 4, 0, 0, 0, 14, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 32 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : InstanceDescriptor) : Array Target :=
  #[.block (encodeU32s CEnum.toC d.requiredFeatures)]
  ++ optBlock InstanceLimits.block64 d.requiredLimits

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : InstanceDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .block 0⟩, ⟨12, .block 14⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  16, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 4, 0,
  0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 4, 0, 0, 0, 14, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 16 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : InstanceDescriptor) : Array Target :=
  #[.block (encodeU32s CEnum.toC d.requiredFeatures)]
  ++ optBlock InstanceLimits.block32 d.requiredLimits

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : InstanceDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (d : InstanceDescriptor) : Bool :=
  Width.is64 () ||
      (d.requiredLimits.all fun x0 => sizeFits x0.timedWaitAnyMaxCount)

/--
`d` as C lays it out on this target, its pointers 0. The caller checks
`sizesFit d` first: on wasm32, a `size_t` that does not fit is cut to its
low 32 bits.
-/
@[inline]
def toBytes (d : InstanceDescriptor) : ByteArray :=
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 52

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : InstanceDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end InstanceDescriptor

/-! ### `Limits` -/

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

/-- An element of its chain on 64-bit targets: its bytes, and its table. -/
@[never_extract]
def chainLink64 : Chained → ByteArray × Nat
  | .compatibilityModeLimits x =>
    (CompatibilityModeLimits.encode64 x, CompatibilityModeLimits.tableIndex)

/-- What C fills in an element of its chain from on 64-bit targets. -/
@[never_extract]
def chainTargets64 : Chained → Array Target
  | .compatibilityModeLimits x => CompatibilityModeLimits.targets64 x

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .chain⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  152, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 152 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : Limits) : Array Target :=
  chainTargetsOf chainLink64 chainTargets64 d.chain

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

/-- An element of its chain on wasm32: its bytes, and its table. -/
@[never_extract]
def chainLink32 : Chained → ByteArray × Nat
  | .compatibilityModeLimits x =>
    (CompatibilityModeLimits.encode32 x, CompatibilityModeLimits.tableIndex)

/-- What C fills in an element of its chain from on wasm32. -/
@[never_extract]
def chainTargets32 : Chained → Array Target
  | .compatibilityModeLimits x => CompatibilityModeLimits.targets32 x

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .chain⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  152, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 152 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : Limits) : Array Target :=
  chainTargetsOf chainLink32 chainTargets32 d.chain

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 53

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : Limits) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end Limits

/-! ### `RenderPassColorAttachment` -/

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
  72, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 3, 0,
  0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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

/-- `d` poked into `b` at `off`, as `encode64` lays it out. -/
@[inline]
def encodeInto64 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 72 ≤ total) (d : RenderPassColorAttachment) :
    Block total :=
  let b := b.pokeU32 (off + 16) d.depthSlice (by omega)
  let b := b.pokeU32 (off + 32) (CEnum.toC d.loadOp) (by omega)
  let b := b.pokeU32 (off + 36) (CEnum.toC d.storeOp) (by omega)
  let b := b.pokeF64 (off + 40) d.clearValue.r (by omega)
  let b := b.pokeF64 (off + 48) d.clearValue.g (by omega)
  let b := b.pokeF64 (off + 56) d.clearValue.b (by omega)
  let b := b.pokeF64 (off + 64) d.clearValue.a (by omega)
  b

/-- An array of them, encoded in turn into one block, on 64-bit targets. -/
@[noinline, never_extract]
def encodeAll64 (xs : Array RenderPassColorAttachment) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 72))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 72)) :
      Block (xs.size * 72) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto64 b (i * 72) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll64 (xs : Array RenderPassColorAttachment) :
    (encodeAll64 xs).size = xs.size * 72 :=
  (encodeAll64.go xs 0 (Block.fresh (xs.size * 72))).2

/-- What C fills in an array of them's pointers from on 64-bit targets. -/
@[never_extract]
def targetsAll64 (xs : Array RenderPassColorAttachment) : Array Target :=
  targetsOfAll targets64 xs

/-- An array of them as a block on 64-bit targets, and its targets. -/
@[never_extract]
def array64 (xs : Array RenderPassColorAttachment) : Array Target :=
  #[.block (encodeAll64 xs)] ++ targetsAll64 xs

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
  56, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 3, 0,
  0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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

/-- `d` poked into `b` at `off`, as `encode32` lays it out. -/
@[inline]
def encodeInto32 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 56 ≤ total) (d : RenderPassColorAttachment) :
    Block total :=
  let b := b.pokeU32 (off + 8) d.depthSlice (by omega)
  let b := b.pokeU32 (off + 16) (CEnum.toC d.loadOp) (by omega)
  let b := b.pokeU32 (off + 20) (CEnum.toC d.storeOp) (by omega)
  let b := b.pokeF64 (off + 24) d.clearValue.r (by omega)
  let b := b.pokeF64 (off + 32) d.clearValue.g (by omega)
  let b := b.pokeF64 (off + 40) d.clearValue.b (by omega)
  let b := b.pokeF64 (off + 48) d.clearValue.a (by omega)
  b

/-- An array of them, encoded in turn into one block, on wasm32. -/
@[noinline, never_extract]
def encodeAll32 (xs : Array RenderPassColorAttachment) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 56))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 56)) :
      Block (xs.size * 56) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto32 b (i * 56) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll32 (xs : Array RenderPassColorAttachment) :
    (encodeAll32 xs).size = xs.size * 56 :=
  (encodeAll32.go xs 0 (Block.fresh (xs.size * 56))).2

/-- What C fills in an array of them's pointers from on wasm32. -/
@[never_extract]
def targetsAll32 (xs : Array RenderPassColorAttachment) : Array Target :=
  targetsOfAll targets32 xs

/-- An array of them as a block on wasm32, and its targets. -/
@[never_extract]
def array32 (xs : Array RenderPassColorAttachment) : Array Target :=
  #[.block (encodeAll32 xs)] ++ targetsAll32 xs

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 54

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderPassColorAttachment) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end RenderPassColorAttachment

/-! ### `RequestAdapterOptions` -/

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

/-- An element of its chain on 64-bit targets: its bytes, and its table. -/
@[never_extract]
def chainLink64 : Chained → ByteArray × Nat
  | .requestAdapterWebXROptions x =>
    (RequestAdapterWebXROptions.encode64 x,
      RequestAdapterWebXROptions.tableIndex)

/-- What C fills in an element of its chain from on 64-bit targets. -/
@[never_extract]
def chainTargets64 : Chained → Array Target
  | .requestAdapterWebXROptions x => RequestAdapterWebXROptions.targets64 x

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .chain⟩, ⟨24, .optObject⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 3,
  0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  chainTargetsOf chainLink64 chainTargets64 d.chain
  ++ #[.optObject (d.compatibleSurface.map Internal.Surface.toObject)]

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

/-- An element of its chain on wasm32: its bytes, and its table. -/
@[never_extract]
def chainLink32 : Chained → ByteArray × Nat
  | .requestAdapterWebXROptions x =>
    (RequestAdapterWebXROptions.encode32 x,
      RequestAdapterWebXROptions.tableIndex)

/-- What C fills in an element of its chain from on wasm32. -/
@[never_extract]
def chainTargets32 : Chained → Array Target
  | .requestAdapterWebXROptions x => RequestAdapterWebXROptions.targets32 x

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .chain⟩, ⟨20, .optObject⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 3,
  0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  chainTargetsOf chainLink32 chainTargets32 d.chain
  ++ #[.optObject (d.compatibleSurface.map Internal.Surface.toObject)]

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 55

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RequestAdapterOptions) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end RequestAdapterOptions

/-! ### `ShaderModuleDescriptor` -/

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

/-- An element of its chain on 64-bit targets: its bytes, and its table. -/
@[never_extract]
def chainLink64 : Chained → ByteArray × Nat
  | .shaderSourceWGSL x =>
    (ShaderSourceWGSL.encode64 x, ShaderSourceWGSL.tableIndex)

/-- What C fills in an element of its chain from on 64-bit targets. -/
@[never_extract]
def chainTargets64 : Chained → Array Target
  | .shaderSourceWGSL x => ShaderSourceWGSL.targets64 x

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .chain⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  chainTargetsOf chainLink64 chainTargets64 d.chain ++ #[.string d.label]

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

/-- An element of its chain on wasm32: its bytes, and its table. -/
@[never_extract]
def chainLink32 : Chained → ByteArray × Nat
  | .shaderSourceWGSL x =>
    (ShaderSourceWGSL.encode32 x, ShaderSourceWGSL.tableIndex)

/-- What C fills in an element of its chain from on wasm32. -/
@[never_extract]
def chainTargets32 : Chained → Array Target
  | .shaderSourceWGSL x => ShaderSourceWGSL.targets32 x

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .chain⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  chainTargetsOf chainLink32 chainTargets32 d.chain ++ #[.string d.label]

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 56

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ShaderModuleDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end ShaderModuleDescriptor

/-! ### `TexelCopyBufferInfo` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 57

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TexelCopyBufferInfo) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end TexelCopyBufferInfo

/-! ### `TexelCopyTextureInfo` -/

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

set_option maxRecDepth 4096 in
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

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 58

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TexelCopyTextureInfo) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end TexelCopyTextureInfo

/-! ### `TextureComponentSwizzleDescriptor` -/

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
  32, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  24, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 59

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureComponentSwizzleDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end TextureComponentSwizzleDescriptor

/-! ### `TextureDescriptor` -/

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

/-- An element of its chain on 64-bit targets: its bytes, and its table. -/
@[never_extract]
def chainLink64 : Chained → ByteArray × Nat
  | .textureBindingViewDimension x =>
    (TextureBindingViewDimension.encode64 x,
      TextureBindingViewDimension.tableIndex)

/-- What C fills in an element of its chain from on 64-bit targets. -/
@[never_extract]
def chainTargets64 : Chained → Array Target
  | .textureBindingViewDimension x => TextureBindingViewDimension.targets64 x

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .chain⟩, ⟨8, .string⟩, ⟨72, .block 0⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  80, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 80 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : TextureDescriptor) : Array Target :=
  chainTargetsOf chainLink64 chainTargets64 d.chain
  ++ #[.string d.label, .block (encodeU32s CEnum.toC d.viewFormats)]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : TextureDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- An element of its chain on wasm32: its bytes, and its table. -/
@[never_extract]
def chainLink32 : Chained → ByteArray × Nat
  | .textureBindingViewDimension x =>
    (TextureBindingViewDimension.encode32 x,
      TextureBindingViewDimension.tableIndex)

/-- What C fills in an element of its chain from on wasm32. -/
@[never_extract]
def chainTargets32 : Chained → Array Target
  | .textureBindingViewDimension x => TextureBindingViewDimension.targets32 x

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .chain⟩, ⟨4, .string⟩, ⟨56, .block 0⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  64, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 64 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : TextureDescriptor) : Array Target :=
  chainTargetsOf chainLink32 chainTargets32 d.chain
  ++ #[.string d.label, .block (encodeU32s CEnum.toC d.viewFormats)]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : TextureDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 60

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end TextureDescriptor

/-! ### `VertexBufferLayout` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨32, .block 44⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  40, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 4,
  0, 0, 0, 44, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 40 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : VertexBufferLayout) : Array Target :=
  VertexAttribute.array64 d.attributes

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : VertexBufferLayout) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- `d` poked into `b` at `off`, as `encode64` lays it out. -/
@[inline]
def encodeInto64 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 40 ≤ total) (d : VertexBufferLayout) :
    Block total :=
  let b := b.pokeU32 (off + 8) (CEnum.toC d.stepMode) (by omega)
  let b := b.pokeU64 (off + 16) d.arrayStride (by omega)
  let b := b.pokeU64 (off + 24) d.attributes.size.toUInt64 (by omega)
  b

/-- An array of them, encoded in turn into one block, on 64-bit targets. -/
@[noinline, never_extract]
def encodeAll64 (xs : Array VertexBufferLayout) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 40))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 40)) :
      Block (xs.size * 40) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto64 b (i * 40) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll64 (xs : Array VertexBufferLayout) :
    (encodeAll64 xs).size = xs.size * 40 :=
  (encodeAll64.go xs 0 (Block.fresh (xs.size * 40))).2

/-- What C fills in an array of them's pointers from on 64-bit targets. -/
@[never_extract]
def targetsAll64 (xs : Array VertexBufferLayout) : Array Target :=
  targetsOfAll targets64 xs

/-- An array of them as a block on 64-bit targets, and its targets. -/
@[never_extract]
def array64 (xs : Array VertexBufferLayout) : Array Target :=
  #[.block (encodeAll64 xs)] ++ targetsAll64 xs

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨20, .block 44⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 4,
  0, 0, 0, 44, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : VertexBufferLayout) : Array Target :=
  VertexAttribute.array32 d.attributes

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : VertexBufferLayout) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/-- `d` poked into `b` at `off`, as `encode32` lays it out. -/
@[inline]
def encodeInto32 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 24 ≤ total) (d : VertexBufferLayout) :
    Block total :=
  let b := b.pokeU32 (off + 4) (CEnum.toC d.stepMode) (by omega)
  let b := b.pokeU64 (off + 8) d.arrayStride (by omega)
  let b := b.pokeU32 (off + 16) d.attributes.size.toUInt32 (by omega)
  b

/-- An array of them, encoded in turn into one block, on wasm32. -/
@[noinline, never_extract]
def encodeAll32 (xs : Array VertexBufferLayout) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 24))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 24)) :
      Block (xs.size * 24) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto32 b (i * 24) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll32 (xs : Array VertexBufferLayout) :
    (encodeAll32 xs).size = xs.size * 24 :=
  (encodeAll32.go xs 0 (Block.fresh (xs.size * 24))).2

/-- What C fills in an array of them's pointers from on wasm32. -/
@[never_extract]
def targetsAll32 (xs : Array VertexBufferLayout) : Array Target :=
  targetsOfAll targets32 xs

/-- An array of them as a block on wasm32, and its targets. -/
@[never_extract]
def array32 (xs : Array VertexBufferLayout) : Array Target :=
  #[.block (encodeAll32 xs)] ++ targetsAll32 xs

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 61

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : VertexBufferLayout) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end VertexBufferLayout

/-! ### `BindGroupDescriptor` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩, ⟨24, .object⟩, ⟨40, .block 45⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  48, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 4, 0, 0,
  0, 45, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 48 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : BindGroupDescriptor) : Array Target :=
  #[.string d.label, .object (Internal.BindGroupLayout.toObject d.layout)]
  ++ BindGroupEntry.array64 d.entries

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : BindGroupDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩, ⟨12, .object⟩, ⟨20, .block 45⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 4, 0, 0,
  0, 45, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 24 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : BindGroupDescriptor) : Array Target :=
  #[.string d.label, .object (Internal.BindGroupLayout.toObject d.layout)]
  ++ BindGroupEntry.array32 d.entries

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : BindGroupDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 62

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BindGroupDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end BindGroupDescriptor

/-! ### `BindGroupLayoutDescriptor` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩, ⟨32, .block 46⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  40, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 4, 0, 0, 0, 46, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 40 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : BindGroupLayoutDescriptor) : Array Target :=
  #[.string d.label] ++ BindGroupLayoutEntry.array64 d.entries

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : BindGroupLayoutDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩, ⟨16, .block 46⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  20, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 4, 0, 0, 0, 46, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 20 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : BindGroupLayoutDescriptor) : Array Target :=
  #[.string d.label] ++ BindGroupLayoutEntry.array32 d.entries

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : BindGroupLayoutDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 63

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : BindGroupLayoutDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end BindGroupLayoutDescriptor

/-! ### `ColorTargetState` -/

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
  ⟨0, .null⟩, ⟨16, .block 47⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  32, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 4,
  0, 0, 0, 47, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  optBlock BlendState.block64 d.blend

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : ColorTargetState) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- `d` poked into `b` at `off`, as `encode64` lays it out. -/
@[inline]
def encodeInto64 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 32 ≤ total) (d : ColorTargetState) :
    Block total :=
  let b := b.pokeU32 (off + 8) (CEnum.toC d.format) (by omega)
  let b := b.pokeU64 (off + 24) d.writeMask.bits (by omega)
  b

/-- An array of them, encoded in turn into one block, on 64-bit targets. -/
@[noinline, never_extract]
def encodeAll64 (xs : Array ColorTargetState) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 32))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 32)) :
      Block (xs.size * 32) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto64 b (i * 32) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll64 (xs : Array ColorTargetState) :
    (encodeAll64 xs).size = xs.size * 32 :=
  (encodeAll64.go xs 0 (Block.fresh (xs.size * 32))).2

/-- What C fills in an array of them's pointers from on 64-bit targets. -/
@[never_extract]
def targetsAll64 (xs : Array ColorTargetState) : Array Target :=
  targetsOfAll targets64 xs

/-- An array of them as a block on 64-bit targets, and its targets. -/
@[never_extract]
def array64 (xs : Array ColorTargetState) : Array Target :=
  #[.block (encodeAll64 xs)] ++ targetsAll64 xs

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
  ⟨0, .null⟩, ⟨8, .block 47⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  24, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 4, 0,
  0, 0, 47, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  optBlock BlendState.block32 d.blend

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : ColorTargetState) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/-- `d` poked into `b` at `off`, as `encode32` lays it out. -/
@[inline]
def encodeInto32 {total : Nat} (b : Block total) (off : Nat)
    (h : off + 24 ≤ total) (d : ColorTargetState) :
    Block total :=
  let b := b.pokeU32 (off + 4) (CEnum.toC d.format) (by omega)
  let b := b.pokeU64 (off + 16) d.writeMask.bits (by omega)
  b

/-- An array of them, encoded in turn into one block, on wasm32. -/
@[noinline, never_extract]
def encodeAll32 (xs : Array ColorTargetState) : ByteArray :=
  (go 0 (Block.fresh (xs.size * 24))).1
where
  /-- Each element from the `i`th on, encoded into `b`. -/
  go (i : Nat) (b : Block (xs.size * 24)) :
      Block (xs.size * 24) :=
    if h : i < xs.size then
      go (i + 1) (encodeInto32 b (i * 24) (by omega) xs[i])
    else b
  termination_by xs.size - i

/-- An array of them is their size. -/
theorem size_encodeAll32 (xs : Array ColorTargetState) :
    (encodeAll32 xs).size = xs.size * 24 :=
  (encodeAll32.go xs 0 (Block.fresh (xs.size * 24))).2

/-- What C fills in an array of them's pointers from on wasm32. -/
@[never_extract]
def targetsAll32 (xs : Array ColorTargetState) : Array Target :=
  targetsOfAll targets32 xs

/-- An array of them as a block on wasm32, and its targets. -/
@[never_extract]
def array32 (xs : Array ColorTargetState) : Array Target :=
  #[.block (encodeAll32 xs)] ++ targetsAll32 xs

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 64

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ColorTargetState) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end ColorTargetState

/-! ### `ComputePipelineDescriptor` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩, ⟨24, .optObject⟩, ⟨32, .null⟩, ⟨40, .object⟩,
  ⟨48, .optString⟩, ⟨72, .block 9⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  80, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 7, 0, 0,
  0, 0, 0, 0, 0, 40, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 1, 0, 0, 0,
  0, 0, 0, 0, 72, 0, 0, 0, 4, 0, 0, 0, 9, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 80 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : ComputePipelineDescriptor) : Array Target :=
  #[
    .string d.label,
    .optObject (d.layout.map Internal.PipelineLayout.toObject),
    .object (Internal.ShaderModule.toObject d.compute.module),
    .optString d.compute.entryPoint
  ]
  ++ ConstantEntry.array64 d.compute.constants

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : ComputePipelineDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩, ⟨12, .optObject⟩, ⟨16, .null⟩, ⟨20, .object⟩,
  ⟨24, .optString⟩, ⟨36, .block 9⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  40, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 7, 0, 0,
  0, 0, 0, 0, 0, 20, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 1, 0, 0, 0,
  0, 0, 0, 0, 36, 0, 0, 0, 4, 0, 0, 0, 9, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 40 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : ComputePipelineDescriptor) : Array Target :=
  #[
    .string d.label,
    .optObject (d.layout.map Internal.PipelineLayout.toObject),
    .object (Internal.ShaderModule.toObject d.compute.module),
    .optString d.compute.entryPoint
  ]
  ++ ConstantEntry.array32 d.compute.constants

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : ComputePipelineDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 65

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : ComputePipelineDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end ComputePipelineDescriptor

/-! ### `DeviceDescriptor` -/

namespace DeviceDescriptor

/-- The scalar fields on 64-bit targets: the specification. -/
def fields64 : List (Field DeviceDescriptor) := [
  ⟨16, .size, fun d => (d.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨24, .size, fun d => (d.requiredFeatures.size.toUInt64).toNat⟩,
  ⟨64, .size, fun d => (d.defaultQueue.label.utf8ByteSize.toUInt64).toNat⟩,
  ⟨80, .u32, fun d => (keptMode d.deviceLostCallbackInfo).toNat⟩,
  ⟨88, .size, fun d => (keptAddress d.deviceLostCallbackInfo).toNat⟩,
  ⟨104, .size, fun d => (keptOrdinal 0 d.deviceLostCallbackInfo).toNat⟩,
  ⟨120, .size, fun d => (keptAddress d.uncapturedErrorCallbackInfo).toNat⟩,
  ⟨136, .size, fun d => (keptOrdinal 1 d.uncapturedErrorCallbackInfo).toNat⟩
]

/-- The pointers on 64-bit targets, for C to fill in. -/
def pointers64 : List Nat := [0, 8, 32, 40, 48, 56, 72, 96, 112, 128]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields64_wellFormed : Fields.WellFormed .bits64 144 fields64 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers64_within :
    ∀ o ∈ pointers64, o + 8 ≤ 144 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers64_apart :
    ∀ o ∈ pointers64, ∀ f ∈ fields64,
      f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
  decide

/-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
@[noinline, never_extract]
def encode64 (d : DeviceDescriptor) : ByteArray :=
  let b := Block.fresh 144
  let b := b.pokeU64 16 d.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU64 24 d.requiredFeatures.size.toUInt64 (by decide)
  let b := b.pokeU64 64 d.defaultQueue.label.utf8ByteSize.toUInt64 (by decide)
  let b := b.pokeU32 80 (keptMode d.deviceLostCallbackInfo) (by decide)
  let b := b.pokeU64 88 (keptAddress d.deviceLostCallbackInfo) (by decide)
  let b := b.pokeU64 104 (keptOrdinal 0 d.deviceLostCallbackInfo) (by decide)
  let b := b.pokeU64 120 (keptAddress d.uncapturedErrorCallbackInfo) (by decide)
  let b := b.pokeU64 136
      (keptOrdinal 1 d.uncapturedErrorCallbackInfo)
      (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode64_eq (d : DeviceDescriptor) :
    encode64 d = Encode.encode .bits64 144 fields64 d := by
  simp only [
    encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU64,
    Block.val_pokeU32, List.map, Field.write, writeAll, List.foldl,
    Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode64 (d : DeviceDescriptor) :
    (encode64 d).size = 144 := by
  rw [encode64_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode64_pointers (d : DeviceDescriptor) :
    ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
  fun o ho => by
    rw [encode64_eq]
    exact readLE_encode_apart d o 8 (pointers64_apart o ho)

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩, ⟨32, .block 0⟩, ⟨40, .block 53⟩, ⟨48, .null⟩,
  ⟨56, .string⟩, ⟨72, .null⟩, ⟨96, .optClosure 0⟩, ⟨112, .null⟩,
  ⟨128, .optClosure 1⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  144, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 4, 0,
  0, 0, 53, 0, 0, 0, 48, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 72, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 96, 0, 0, 0, 6, 0, 0, 0,
  0, 0, 0, 0, 112, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 6, 0, 0, 0, 1,
  0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 144 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : DeviceDescriptor) : Array Target :=
  #[.string d.label, .block (encodeU32s CEnum.toC d.requiredFeatures)]
  ++ optBlock Limits.block64 d.requiredLimits
  ++ #[
    .string d.defaultQueue.label,
    .optClosure (keptClosure d.deviceLostCallbackInfo),
    .optClosure (keptClosure d.uncapturedErrorCallbackInfo)
  ]

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : DeviceDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

/-- The scalar fields on wasm32: the specification. -/
def fields32 : List (Field DeviceDescriptor) := [
  ⟨8, .size, fun d => (d.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨12, .size, fun d => (d.requiredFeatures.size.toUInt32).toNat⟩,
  ⟨32, .size, fun d => (d.defaultQueue.label.utf8ByteSize.toUInt32).toNat⟩,
  ⟨40, .u32, fun d => (keptMode d.deviceLostCallbackInfo).toNat⟩,
  ⟨44, .size, fun d => ((keptAddress d.deviceLostCallbackInfo).toUInt32).toNat⟩,
  ⟨52, .size,
      fun d => ((keptOrdinal 0 d.deviceLostCallbackInfo).toUInt32).toNat⟩,
  ⟨60, .size,
      fun d => ((keptAddress d.uncapturedErrorCallbackInfo).toUInt32).toNat⟩,
  ⟨68, .size,
      fun d => ((keptOrdinal 1 d.uncapturedErrorCallbackInfo).toUInt32).toNat⟩
]

/-- The pointers on wasm32, for C to fill in. -/
def pointers32 : List Nat := [0, 4, 16, 20, 24, 28, 36, 48, 56, 64]

/-- The fields are well-formed: in order, apart, within the struct. -/
theorem fields32_wellFormed : Fields.WellFormed .bits32 72 fields32 := by
  unfold Fields.WellFormed; decide

/-- The pointers are within the struct. -/
theorem pointers32_within :
    ∀ o ∈ pointers32, o + 4 ≤ 72 := by
  decide

/-- The pointers are apart from every field. -/
theorem pointers32_apart :
    ∀ o ∈ pointers32, ∀ f ∈ fields32,
      f.offset + f.scalar.bytes .bits32 ≤ o ∨ o + 4 ≤ f.offset := by
  decide

/-- `d` as C lays it out on wasm32, its pointers 0. -/
@[noinline, never_extract]
def encode32 (d : DeviceDescriptor) : ByteArray :=
  let b := Block.fresh 72
  let b := b.pokeU32 8 d.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 12 d.requiredFeatures.size.toUInt32 (by decide)
  let b := b.pokeU32 32 d.defaultQueue.label.utf8ByteSize.toUInt32 (by decide)
  let b := b.pokeU32 40 (keptMode d.deviceLostCallbackInfo) (by decide)
  let b := b.pokeU32 44
      ((keptAddress d.deviceLostCallbackInfo).toUInt32)
      (by decide)
  let b := b.pokeU32 52
      ((keptOrdinal 0 d.deviceLostCallbackInfo).toUInt32)
      (by decide)
  let b := b.pokeU32 60
      ((keptAddress d.uncapturedErrorCallbackInfo).toUInt32)
      (by decide)
  let b := b.pokeU32 68
      ((keptOrdinal 1 d.uncapturedErrorCallbackInfo).toUInt32)
      (by decide)
  b.1

/-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
theorem encode32_eq (d : DeviceDescriptor) :
    encode32 d = Encode.encode .bits32 72 fields32 d := by
  simp only [
    encode32, Encode.encode, fields32, Block.val_fresh, Block.val_pokeU32,
    List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

/-- Its encoding is its size. -/
theorem size_encode32 (d : DeviceDescriptor) :
    (encode32 d).size = 72 := by
  rw [encode32_eq, size_encode]

/-- Its pointers read as 0, for C to fill in. -/
theorem encode32_pointers (d : DeviceDescriptor) :
    ∀ o ∈ pointers32, readLE (encode32 d) o 4 = 0 :=
  fun o ho => by
    rw [encode32_eq]
    exact readLE_encode_apart d o 4 (pointers32_apart o ho)

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩, ⟨16, .block 0⟩, ⟨20, .block 53⟩, ⟨24, .null⟩,
  ⟨28, .string⟩, ⟨36, .null⟩, ⟨48, .optClosure 0⟩, ⟨56, .null⟩,
  ⟨64, .optClosure 1⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  72, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 4, 0,
  0, 0, 53, 0, 0, 0, 24, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 28, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 36, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 6, 0, 0, 0,
  0, 0, 0, 0, 56, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 6, 0, 0, 0, 1,
  0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 72 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : DeviceDescriptor) : Array Target :=
  #[.string d.label, .block (encodeU32s CEnum.toC d.requiredFeatures)]
  ++ optBlock Limits.block32 d.requiredLimits
  ++ #[
    .string d.defaultQueue.label,
    .optClosure (keptClosure d.deviceLostCallbackInfo),
    .optClosure (keptClosure d.uncapturedErrorCallbackInfo)
  ]

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : DeviceDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

/--
Whether each `size_t` of `d` fits the target: on wasm32, in 32 bits, or
as the largest `UInt64`, `SIZE_MAX`. A caller refuses one that does not,
as for a `size_t` argument.
-/
def sizesFit (_ : DeviceDescriptor) : Bool :=
  true

/-- `d` as C lays it out on this target, its pointers 0. -/
@[inline]
def toBytes (d : DeviceDescriptor) : ByteArray :=
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 66

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : DeviceDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end DeviceDescriptor

/-! ### `RenderPassDescriptor` -/

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

/-- An element of its chain on 64-bit targets: its bytes, and its table. -/
@[never_extract]
def chainLink64 : Chained → ByteArray × Nat
  | .renderPassMaxDrawCount x =>
    (RenderPassMaxDrawCount.encode64 x, RenderPassMaxDrawCount.tableIndex)

/-- What C fills in an element of its chain from on 64-bit targets. -/
@[never_extract]
def chainTargets64 : Chained → Array Target
  | .renderPassMaxDrawCount x => RenderPassMaxDrawCount.targets64 x

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .chain⟩, ⟨8, .string⟩, ⟨32, .block 54⟩, ⟨40, .block 24⟩, ⟨48, .optObject⟩,
  ⟨56, .block 17⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  64, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 4, 0, 0, 0, 54, 0, 0, 0, 40, 0, 0, 0, 4, 0, 0,
  0, 24, 0, 0, 0, 48, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 4, 0, 0, 0,
  17, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 64 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : RenderPassDescriptor) : Array Target :=
  chainTargetsOf chainLink64 chainTargets64 d.chain
  ++ #[.string d.label]
  ++ RenderPassColorAttachment.array64 d.colorAttachments
  ++ optBlock RenderPassDepthStencilAttachment.block64 d.depthStencilAttachment
  ++ #[.optObject (d.occlusionQuerySet.map Internal.QuerySet.toObject)]
  ++ optBlock PassTimestampWrites.block64 d.timestampWrites

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : RenderPassDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- An element of its chain on wasm32: its bytes, and its table. -/
@[never_extract]
def chainLink32 : Chained → ByteArray × Nat
  | .renderPassMaxDrawCount x =>
    (RenderPassMaxDrawCount.encode32 x, RenderPassMaxDrawCount.tableIndex)

/-- What C fills in an element of its chain from on wasm32. -/
@[never_extract]
def chainTargets32 : Chained → Array Target
  | .renderPassMaxDrawCount x => RenderPassMaxDrawCount.targets32 x

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .chain⟩, ⟨4, .string⟩, ⟨16, .block 54⟩, ⟨20, .block 24⟩, ⟨24, .optObject⟩,
  ⟨28, .block 17⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  32, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 4, 0, 0, 0, 54, 0, 0, 0, 20, 0, 0, 0, 4, 0, 0,
  0, 24, 0, 0, 0, 24, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 28, 0, 0, 0, 4, 0, 0, 0,
  17, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 32 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : RenderPassDescriptor) : Array Target :=
  chainTargetsOf chainLink32 chainTargets32 d.chain
  ++ #[.string d.label]
  ++ RenderPassColorAttachment.array32 d.colorAttachments
  ++ optBlock RenderPassDepthStencilAttachment.block32 d.depthStencilAttachment
  ++ #[.optObject (d.occlusionQuerySet.map Internal.QuerySet.toObject)]
  ++ optBlock PassTimestampWrites.block32 d.timestampWrites

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : RenderPassDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 67

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderPassDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end RenderPassDescriptor

/-! ### `TextureViewDescriptor` -/

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

/-- An element of its chain on 64-bit targets: its bytes, and its table. -/
@[never_extract]
def chainLink64 : Chained → ByteArray × Nat
  | .textureComponentSwizzleDescriptor x =>
    (TextureComponentSwizzleDescriptor.encode64 x,
      TextureComponentSwizzleDescriptor.tableIndex)

/-- What C fills in an element of its chain from on 64-bit targets. -/
@[never_extract]
def chainTargets64 : Chained → Array Target
  | .textureComponentSwizzleDescriptor x =>
    TextureComponentSwizzleDescriptor.targets64 x

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .chain⟩, ⟨8, .string⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  64, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  chainTargetsOf chainLink64 chainTargets64 d.chain ++ #[.string d.label]

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

/-- An element of its chain on wasm32: its bytes, and its table. -/
@[never_extract]
def chainLink32 : Chained → ByteArray × Nat
  | .textureComponentSwizzleDescriptor x =>
    (TextureComponentSwizzleDescriptor.encode32 x,
      TextureComponentSwizzleDescriptor.tableIndex)

/-- What C fills in an element of its chain from on wasm32. -/
@[never_extract]
def chainTargets32 : Chained → Array Target
  | .textureComponentSwizzleDescriptor x =>
    TextureComponentSwizzleDescriptor.targets32 x

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .chain⟩, ⟨4, .string⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  48, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
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
  chainTargetsOf chainLink32 chainTargets32 d.chain ++ #[.string d.label]

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 68

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : TextureViewDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end TextureViewDescriptor

/-! ### `VertexState` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .object⟩, ⟨16, .optString⟩, ⟨40, .block 9⟩, ⟨56, .block 61⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  64, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 4, 0, 0,
  0, 9, 0, 0, 0, 56, 0, 0, 0, 4, 0, 0, 0, 61, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 64 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : VertexState) : Array Target :=
  #[.object (Internal.ShaderModule.toObject d.module), .optString d.entryPoint]
  ++ ConstantEntry.array64 d.constants
  ++ VertexBufferLayout.array64 d.buffers

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : VertexState) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .object⟩, ⟨8, .optString⟩, ⟨20, .block 9⟩, ⟨28, .block 61⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  32, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 4, 0, 0, 0,
  9, 0, 0, 0, 28, 0, 0, 0, 4, 0, 0, 0, 61, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 32 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : VertexState) : Array Target :=
  #[.object (Internal.ShaderModule.toObject d.module), .optString d.entryPoint]
  ++ ConstantEntry.array32 d.constants
  ++ VertexBufferLayout.array32 d.buffers

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : VertexState) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 69

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : VertexState) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end VertexState

/-! ### `FragmentState` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .object⟩, ⟨16, .optString⟩, ⟨40, .block 9⟩, ⟨56, .block 64⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  64, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 4, 0, 0,
  0, 9, 0, 0, 0, 56, 0, 0, 0, 4, 0, 0, 0, 64, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 64 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : FragmentState) : Array Target :=
  #[.object (Internal.ShaderModule.toObject d.module), .optString d.entryPoint]
  ++ ConstantEntry.array64 d.constants
  ++ ColorTargetState.array64 d.targets

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : FragmentState) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .object⟩, ⟨8, .optString⟩, ⟨20, .block 9⟩, ⟨28, .block 64⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  32, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2, 0,
  0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 4, 0, 0, 0,
  9, 0, 0, 0, 28, 0, 0, 0, 4, 0, 0, 0, 64, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 32 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : FragmentState) : Array Target :=
  #[.object (Internal.ShaderModule.toObject d.module), .optString d.entryPoint]
  ++ ConstantEntry.array32 d.constants
  ++ ColorTargetState.array32 d.targets

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : FragmentState) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 70

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : FragmentState) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end FragmentState

/-! ### `RenderPipelineDescriptor` -/

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

/-- Its pointers' relocations on 64-bit targets: what C fills each in from. -/
noncomputable def relocs64 : List Reloc := [
  ⟨0, .null⟩, ⟨8, .string⟩, ⟨24, .optObject⟩, ⟨32, .null⟩, ⟨40, .object⟩,
  ⟨48, .optString⟩, ⟨72, .block 9⟩, ⟨88, .block 61⟩, ⟨96, .null⟩,
  ⟨128, .block 50⟩, ⟨136, .null⟩, ⟨160, .block 70⟩
]

/-- Its table on 64-bit targets, for C: `serialize` of its relocations. -/
def table64 : ByteArray := ⟨#[
  168, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 7, 0,
  0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 1, 0, 0,
  0, 0, 0, 0, 0, 72, 0, 0, 0, 4, 0, 0, 0, 9, 0, 0, 0, 88, 0, 0, 0, 4, 0, 0, 0,
  61, 0, 0, 0, 96, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 4, 0, 0, 0,
  50, 0, 0, 0, 136, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 160, 0, 0, 0, 4, 0, 0, 0,
  70, 0, 0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table64_eq : table64 = serialize 168 relocs64 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs64_offsets : relocs64.map (·.offset) = pointers64 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs64_fit : relocs64.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on 64-bit targets, in order. -/
@[never_extract]
def targets64 (d : RenderPipelineDescriptor) : Array Target :=
  #[
    .string d.label,
    .optObject (d.layout.map Internal.PipelineLayout.toObject),
    .object (Internal.ShaderModule.toObject d.vertex.module),
    .optString d.vertex.entryPoint
  ]
  ++ ConstantEntry.array64 d.vertex.constants
  ++ VertexBufferLayout.array64 d.vertex.buffers
  ++ optBlock DepthStencilState.block64 d.depthStencil
  ++ optBlock FragmentState.block64 d.fragment

/-- `d` as the block a pointer to it points to on 64-bit targets. -/
@[never_extract]
def block64 (d : RenderPipelineDescriptor) : Array Target :=
  #[.block (encode64 d)] ++ targets64 d

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

/-- Its pointers' relocations on wasm32: what C fills each in from. -/
noncomputable def relocs32 : List Reloc := [
  ⟨0, .null⟩, ⟨4, .string⟩, ⟨12, .optObject⟩, ⟨16, .null⟩, ⟨20, .object⟩,
  ⟨24, .optString⟩, ⟨36, .block 9⟩, ⟨44, .block 61⟩, ⟨48, .null⟩,
  ⟨72, .block 50⟩, ⟨76, .null⟩, ⟨92, .block 70⟩
]

/-- Its table on wasm32, for C: `serialize` of its relocations. -/
def table32 : ByteArray := ⟨#[
  96, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 7, 0,
  0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 1, 0, 0,
  0, 0, 0, 0, 0, 36, 0, 0, 0, 4, 0, 0, 0, 9, 0, 0, 0, 44, 0, 0, 0, 4, 0, 0, 0,
  61, 0, 0, 0, 48, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 4, 0, 0, 0, 50,
  0, 0, 0, 76, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 92, 0, 0, 0, 4, 0, 0, 0, 70, 0,
  0, 0
]⟩

set_option maxRecDepth 4096 in
/-- The table is its relocations. -/
theorem table32_eq : table32 = serialize 96 relocs32 := rfl

/-- Every pointer has a relocation, and only a pointer. -/
theorem relocs32_offsets : relocs32.map (·.offset) = pointers32 :=
  rfl

/-- Its relocations' numbers fit its table. -/
theorem relocs32_fit : relocs32.all Reloc.fits := by decide

/-- What C fills in `d`'s pointers from on wasm32, in order. -/
@[never_extract]
def targets32 (d : RenderPipelineDescriptor) : Array Target :=
  #[
    .string d.label,
    .optObject (d.layout.map Internal.PipelineLayout.toObject),
    .object (Internal.ShaderModule.toObject d.vertex.module),
    .optString d.vertex.entryPoint
  ]
  ++ ConstantEntry.array32 d.vertex.constants
  ++ VertexBufferLayout.array32 d.vertex.buffers
  ++ optBlock DepthStencilState.block32 d.depthStencil
  ++ optBlock FragmentState.block32 d.fragment

/-- `d` as the block a pointer to it points to on wasm32. -/
@[never_extract]
def block32 (d : RenderPipelineDescriptor) : Array Target :=
  #[.block (encode32 d)] ++ targets32 d

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
  if Width.is64 () then encode64 d else encode32 d

/-- Its table's index in `tables64` and `tables32`. -/
def tableIndex : Nat := 71

/-- What C fills in `d`'s pointers from on this target. -/
@[inline]
def toTargets (d : RenderPipelineDescriptor) : Array Target :=
  if Width.is64 () then targets64 d else targets32 d

end RenderPipelineDescriptor

/-! ## Tables -/

/-- Every struct's table on 64-bit targets, by its index. -/
def tables64 : Array ByteArray := #[
  serialize 4 [], serialize 8 [⟨0, .object⟩], BlendComponent.table64,
  BufferBindingLayout.table64, BufferDescriptor.table64, Color.table64,
  CommandBufferDescriptor.table64, CommandEncoderDescriptor.table64,
  CompatibilityModeLimits.table64, ConstantEntry.table64, Extent3D.table64,
  ExternalTextureBindingEntry.table64, ExternalTextureBindingLayout.table64,
  Future.table64, InstanceLimits.table64, MultisampleState.table64,
  Origin3D.table64, PassTimestampWrites.table64,
  PipelineLayoutDescriptor.table64, PrimitiveState.table64,
  QuerySetDescriptor.table64, QueueDescriptor.table64,
  RenderBundleDescriptor.table64, RenderBundleEncoderDescriptor.table64,
  RenderPassDepthStencilAttachment.table64, RenderPassMaxDrawCount.table64,
  RequestAdapterWebXROptions.table64, SamplerBindingLayout.table64,
  SamplerDescriptor.table64, ShaderSourceWGSL.table64, StencilFaceState.table64,
  StorageTextureBindingLayout.table64, SupportedFeatures.table64,
  SupportedInstanceFeatures.table64, SupportedWGSLLanguageFeatures.table64,
  SurfaceCapabilities.table64, SurfaceColorManagement.table64,
  SurfaceConfiguration.table64, SurfaceDescriptor.table64,
  SurfaceTexture.table64, TexelCopyBufferLayout.table64,
  TextureBindingLayout.table64, TextureBindingViewDimension.table64,
  TextureComponentSwizzle.table64, VertexAttribute.table64,
  BindGroupEntry.table64, BindGroupLayoutEntry.table64, BlendState.table64,
  ComputePassDescriptor.table64, ComputeState.table64,
  DepthStencilState.table64, FutureWaitInfo.table64, InstanceDescriptor.table64,
  Limits.table64, RenderPassColorAttachment.table64,
  RequestAdapterOptions.table64, ShaderModuleDescriptor.table64,
  TexelCopyBufferInfo.table64, TexelCopyTextureInfo.table64,
  TextureComponentSwizzleDescriptor.table64, TextureDescriptor.table64,
  VertexBufferLayout.table64, BindGroupDescriptor.table64,
  BindGroupLayoutDescriptor.table64, ColorTargetState.table64,
  ComputePipelineDescriptor.table64, DeviceDescriptor.table64,
  RenderPassDescriptor.table64, TextureViewDescriptor.table64,
  VertexState.table64, FragmentState.table64, RenderPipelineDescriptor.table64
]

/-- Every struct's table on 64-bit targets, as the walk reads it. -/
noncomputable def specs64 : Array Spec := #[
  wordsSpec, objectsSpec 8, (12, BlendComponent.relocs64),
  (24, BufferBindingLayout.relocs64), (48, BufferDescriptor.relocs64),
  (32, Color.relocs64), (24, CommandBufferDescriptor.relocs64),
  (24, CommandEncoderDescriptor.relocs64),
  (32, CompatibilityModeLimits.relocs64), (32, ConstantEntry.relocs64),
  (12, Extent3D.relocs64), (24, ExternalTextureBindingEntry.relocs64),
  (16, ExternalTextureBindingLayout.relocs64), (8, Future.relocs64),
  (16, InstanceLimits.relocs64), (24, MultisampleState.relocs64),
  (12, Origin3D.relocs64), (24, PassTimestampWrites.relocs64),
  (48, PipelineLayoutDescriptor.relocs64), (32, PrimitiveState.relocs64),
  (32, QuerySetDescriptor.relocs64), (24, QueueDescriptor.relocs64),
  (24, RenderBundleDescriptor.relocs64),
  (56, RenderBundleEncoderDescriptor.relocs64),
  (48, RenderPassDepthStencilAttachment.relocs64),
  (24, RenderPassMaxDrawCount.relocs64),
  (24, RequestAdapterWebXROptions.relocs64),
  (16, SamplerBindingLayout.relocs64), (64, SamplerDescriptor.relocs64),
  (32, ShaderSourceWGSL.relocs64), (16, StencilFaceState.relocs64),
  (24, StorageTextureBindingLayout.relocs64), (16, SupportedFeatures.relocs64),
  (16, SupportedInstanceFeatures.relocs64),
  (16, SupportedWGSLLanguageFeatures.relocs64),
  (64, SurfaceCapabilities.relocs64), (24, SurfaceColorManagement.relocs64),
  (64, SurfaceConfiguration.relocs64), (24, SurfaceDescriptor.relocs64),
  (24, SurfaceTexture.relocs64), (16, TexelCopyBufferLayout.relocs64),
  (24, TextureBindingLayout.relocs64),
  (24, TextureBindingViewDimension.relocs64),
  (16, TextureComponentSwizzle.relocs64), (32, VertexAttribute.relocs64),
  (56, BindGroupEntry.relocs64), (120, BindGroupLayoutEntry.relocs64),
  (24, BlendState.relocs64), (32, ComputePassDescriptor.relocs64),
  (48, ComputeState.relocs64), (72, DepthStencilState.relocs64),
  (16, FutureWaitInfo.relocs64), (32, InstanceDescriptor.relocs64),
  (152, Limits.relocs64), (72, RenderPassColorAttachment.relocs64),
  (32, RequestAdapterOptions.relocs64), (24, ShaderModuleDescriptor.relocs64),
  (24, TexelCopyBufferInfo.relocs64), (32, TexelCopyTextureInfo.relocs64),
  (32, TextureComponentSwizzleDescriptor.relocs64),
  (80, TextureDescriptor.relocs64), (40, VertexBufferLayout.relocs64),
  (48, BindGroupDescriptor.relocs64), (40, BindGroupLayoutDescriptor.relocs64),
  (32, ColorTargetState.relocs64), (80, ComputePipelineDescriptor.relocs64),
  (144, DeviceDescriptor.relocs64), (64, RenderPassDescriptor.relocs64),
  (64, TextureViewDescriptor.relocs64), (64, VertexState.relocs64),
  (64, FragmentState.relocs64), (168, RenderPipelineDescriptor.relocs64)
]

set_option maxRecDepth 16384 in
/-- The tables C reads are the tables the walk reads. -/
theorem tables64_eq :
    tables64.toList = specs64.toList.map fun (size, relocs) =>
      serialize size relocs :=
  rfl

/-- The shared table of arrays of numbers is the first. -/
theorem getElem?_specs64_words : specs64[0]? = some wordsSpec :=
  rfl

/-- The shared table of arrays of objects is the second. -/
theorem getElem?_specs64_objects : specs64[1]? = some (objectsSpec 8) := rfl

/-- Every struct's table on wasm32, by its index. -/
def tables32 : Array ByteArray := #[
  serialize 4 [], serialize 4 [⟨0, .object⟩], BlendComponent.table32,
  BufferBindingLayout.table32, BufferDescriptor.table32, Color.table32,
  CommandBufferDescriptor.table32, CommandEncoderDescriptor.table32,
  CompatibilityModeLimits.table32, ConstantEntry.table32, Extent3D.table32,
  ExternalTextureBindingEntry.table32, ExternalTextureBindingLayout.table32,
  Future.table32, InstanceLimits.table32, MultisampleState.table32,
  Origin3D.table32, PassTimestampWrites.table32,
  PipelineLayoutDescriptor.table32, PrimitiveState.table32,
  QuerySetDescriptor.table32, QueueDescriptor.table32,
  RenderBundleDescriptor.table32, RenderBundleEncoderDescriptor.table32,
  RenderPassDepthStencilAttachment.table32, RenderPassMaxDrawCount.table32,
  RequestAdapterWebXROptions.table32, SamplerBindingLayout.table32,
  SamplerDescriptor.table32, ShaderSourceWGSL.table32, StencilFaceState.table32,
  StorageTextureBindingLayout.table32, SupportedFeatures.table32,
  SupportedInstanceFeatures.table32, SupportedWGSLLanguageFeatures.table32,
  SurfaceCapabilities.table32, SurfaceColorManagement.table32,
  SurfaceConfiguration.table32, SurfaceDescriptor.table32,
  SurfaceTexture.table32, TexelCopyBufferLayout.table32,
  TextureBindingLayout.table32, TextureBindingViewDimension.table32,
  TextureComponentSwizzle.table32, VertexAttribute.table32,
  BindGroupEntry.table32, BindGroupLayoutEntry.table32, BlendState.table32,
  ComputePassDescriptor.table32, ComputeState.table32,
  DepthStencilState.table32, FutureWaitInfo.table32, InstanceDescriptor.table32,
  Limits.table32, RenderPassColorAttachment.table32,
  RequestAdapterOptions.table32, ShaderModuleDescriptor.table32,
  TexelCopyBufferInfo.table32, TexelCopyTextureInfo.table32,
  TextureComponentSwizzleDescriptor.table32, TextureDescriptor.table32,
  VertexBufferLayout.table32, BindGroupDescriptor.table32,
  BindGroupLayoutDescriptor.table32, ColorTargetState.table32,
  ComputePipelineDescriptor.table32, DeviceDescriptor.table32,
  RenderPassDescriptor.table32, TextureViewDescriptor.table32,
  VertexState.table32, FragmentState.table32, RenderPipelineDescriptor.table32
]

/-- Every struct's table on wasm32, as the walk reads it. -/
noncomputable def specs32 : Array Spec := #[
  wordsSpec, objectsSpec 4, (12, BlendComponent.relocs32),
  (24, BufferBindingLayout.relocs32), (40, BufferDescriptor.relocs32),
  (32, Color.relocs32), (12, CommandBufferDescriptor.relocs32),
  (12, CommandEncoderDescriptor.relocs32),
  (24, CompatibilityModeLimits.relocs32), (24, ConstantEntry.relocs32),
  (12, Extent3D.relocs32), (12, ExternalTextureBindingEntry.relocs32),
  (8, ExternalTextureBindingLayout.relocs32), (8, Future.relocs32),
  (8, InstanceLimits.relocs32), (16, MultisampleState.relocs32),
  (12, Origin3D.relocs32), (16, PassTimestampWrites.relocs32),
  (24, PipelineLayoutDescriptor.relocs32), (24, PrimitiveState.relocs32),
  (20, QuerySetDescriptor.relocs32), (12, QueueDescriptor.relocs32),
  (12, RenderBundleDescriptor.relocs32),
  (36, RenderBundleEncoderDescriptor.relocs32),
  (40, RenderPassDepthStencilAttachment.relocs32),
  (16, RenderPassMaxDrawCount.relocs32),
  (12, RequestAdapterWebXROptions.relocs32), (8, SamplerBindingLayout.relocs32),
  (52, SamplerDescriptor.relocs32), (16, ShaderSourceWGSL.relocs32),
  (16, StencilFaceState.relocs32), (16, StorageTextureBindingLayout.relocs32),
  (8, SupportedFeatures.relocs32), (8, SupportedInstanceFeatures.relocs32),
  (8, SupportedWGSLLanguageFeatures.relocs32),
  (40, SurfaceCapabilities.relocs32), (16, SurfaceColorManagement.relocs32),
  (48, SurfaceConfiguration.relocs32), (12, SurfaceDescriptor.relocs32),
  (12, SurfaceTexture.relocs32), (16, TexelCopyBufferLayout.relocs32),
  (16, TextureBindingLayout.relocs32),
  (12, TextureBindingViewDimension.relocs32),
  (16, TextureComponentSwizzle.relocs32), (24, VertexAttribute.relocs32),
  (40, BindGroupEntry.relocs32), (88, BindGroupLayoutEntry.relocs32),
  (24, BlendState.relocs32), (16, ComputePassDescriptor.relocs32),
  (24, ComputeState.relocs32), (68, DepthStencilState.relocs32),
  (16, FutureWaitInfo.relocs32), (16, InstanceDescriptor.relocs32),
  (152, Limits.relocs32), (56, RenderPassColorAttachment.relocs32),
  (24, RequestAdapterOptions.relocs32), (12, ShaderModuleDescriptor.relocs32),
  (24, TexelCopyBufferInfo.relocs32), (24, TexelCopyTextureInfo.relocs32),
  (24, TextureComponentSwizzleDescriptor.relocs32),
  (64, TextureDescriptor.relocs32), (24, VertexBufferLayout.relocs32),
  (24, BindGroupDescriptor.relocs32), (20, BindGroupLayoutDescriptor.relocs32),
  (24, ColorTargetState.relocs32), (40, ComputePipelineDescriptor.relocs32),
  (72, DeviceDescriptor.relocs32), (32, RenderPassDescriptor.relocs32),
  (48, TextureViewDescriptor.relocs32), (32, VertexState.relocs32),
  (32, FragmentState.relocs32), (96, RenderPipelineDescriptor.relocs32)
]

set_option maxRecDepth 16384 in
/-- The tables C reads are the tables the walk reads. -/
theorem tables32_eq :
    tables32.toList = specs32.toList.map fun (size, relocs) =>
      serialize size relocs :=
  rfl

/-- The shared table of arrays of numbers is the first. -/
theorem getElem?_specs32_words : specs32[0]? = some wordsSpec :=
  rfl

/-- The shared table of arrays of objects is the second. -/
theorem getElem?_specs32_objects : specs32[1]? = some (objectsSpec 4) := rfl

/-- Every table on this target. -/
@[inline]
def currentTables : Array ByteArray :=
  if Width.is64 () then tables64 else tables32

/-- The tables on this target, and no others: what a shim takes. -/
abbrev CurrentTablesOf := {ts : Array ByteArray // ts = currentTables}

/-- Every table on this target, as the walk reads it. -/
noncomputable def currentSpecs : Array Spec :=
  if Width.is64 () then specs64 else specs32

/-- The tables C reads on this target are the tables the walk reads. -/
theorem currentTables_eq :
    currentTables.toList = currentSpecs.toList.map fun (size, relocs) =>
      serialize size relocs := by
  by_cases h : Width.is64 () = true
  · simp only [currentTables, currentSpecs, h, ↓reduceIte]
    exact tables64_eq
  · simp only [currentTables, currentSpecs, h, Bool.false_eq_true,
      ↓reduceIte]
    exact tables32_eq

/-! ### `BlendComponent`: its walk -/

namespace BlendComponent

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[2]? = some (12, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : BlendComponent) (ts : List Target) :
    element specs64 2 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : BlendComponent) (ts : List Target) :
    walk specs64 2 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : BlendComponent) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[2]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : BlendComponent) (ts : List Target) :
    element specs32 2 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : BlendComponent) (ts : List Target) :
    walk specs32 2 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : BlendComponent) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : BlendComponent) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : BlendComponent) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct BlendComponent :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs BlendComponent :=
  ⟨size_toBytes, walk_toBytes⟩

end BlendComponent

/-! ### `BufferBindingLayout`: its walk -/

namespace BufferBindingLayout

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[3]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : BufferBindingLayout) (ts : List Target) :
    element specs64 3 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : BufferBindingLayout) (ts : List Target) :
    walk specs64 3 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : BufferBindingLayout) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[3]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : BufferBindingLayout) (ts : List Target) :
    element specs32 3 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : BufferBindingLayout) (ts : List Target) :
    walk specs32 3 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : BufferBindingLayout) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : BufferBindingLayout) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : BufferBindingLayout) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct BufferBindingLayout :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs BufferBindingLayout :=
  ⟨size_toBytes, walk_toBytes⟩

end BufferBindingLayout

/-! ### `BufferDescriptor`: its walk -/

namespace BufferDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[4]? = some (48, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : BufferDescriptor) (ts : List Target) :
    element specs64 4 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : BufferDescriptor) (ts : List Target) :
    walk specs64 4 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : BufferDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[4]? = some (40, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : BufferDescriptor) (ts : List Target) :
    element specs32 4 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : BufferDescriptor) (ts : List Target) :
    walk specs32 4 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : BufferDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : BufferDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : BufferDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct BufferDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs BufferDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end BufferDescriptor

/-! ### `Color`: its walk -/

namespace Color

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[5]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : Color) (ts : List Target) :
    element specs64 5 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : Color) (ts : List Target) :
    walk specs64 5 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : Color) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[5]? = some (32, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : Color) (ts : List Target) :
    element specs32 5 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : Color) (ts : List Target) :
    walk specs32 5 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : Color) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : Color) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : Color) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct Color :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs Color :=
  ⟨size_toBytes, walk_toBytes⟩

end Color

/-! ### `CommandBufferDescriptor`: its walk -/

namespace CommandBufferDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[6]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : CommandBufferDescriptor) (ts : List Target) :
    element specs64 6 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : CommandBufferDescriptor) (ts : List Target) :
    walk specs64 6 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : CommandBufferDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[6]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : CommandBufferDescriptor) (ts : List Target) :
    element specs32 6 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : CommandBufferDescriptor) (ts : List Target) :
    walk specs32 6 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : CommandBufferDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : CommandBufferDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : CommandBufferDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct CommandBufferDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs CommandBufferDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end CommandBufferDescriptor

/-! ### `CommandEncoderDescriptor`: its walk -/

namespace CommandEncoderDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[7]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : CommandEncoderDescriptor) (ts : List Target) :
    element specs64 7 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : CommandEncoderDescriptor) (ts : List Target) :
    walk specs64 7 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : CommandEncoderDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[7]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : CommandEncoderDescriptor) (ts : List Target) :
    element specs32 7 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : CommandEncoderDescriptor) (ts : List Target) :
    walk specs32 7 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : CommandEncoderDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : CommandEncoderDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : CommandEncoderDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct CommandEncoderDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs CommandEncoderDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end CommandEncoderDescriptor

/-! ### `CompatibilityModeLimits`: its walk -/

namespace CompatibilityModeLimits

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[8]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : CompatibilityModeLimits) (ts : List Target) :
    element specs64 8 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : CompatibilityModeLimits) (ts : List Target) :
    walk specs64 8 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : CompatibilityModeLimits)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[8]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : CompatibilityModeLimits) (ts : List Target) :
    element specs32 8 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : CompatibilityModeLimits) (ts : List Target) :
    walk specs32 8 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : CompatibilityModeLimits)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : CompatibilityModeLimits) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : CompatibilityModeLimits) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct CompatibilityModeLimits :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs CompatibilityModeLimits :=
  ⟨size_toBytes, walk_toBytes⟩

end CompatibilityModeLimits

/-! ### `ConstantEntry`: its walk -/

namespace ConstantEntry

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[9]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : ConstantEntry) (ts : List Target) :
    element specs64 9 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : ConstantEntry) (ts : List Target) :
    walk specs64 9 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : ConstantEntry) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll64 (xs : Array ConstantEntry) (ts : List Target) :
    walk specs64 9 (encodeAll64 xs).size
      ((targetsAll64 xs).toList ++ ts) = some ts := by
  rw [targetsAll64, toList_targetsOfAll]
  exact walk_elements getElem?_specs64 (by decide) xs.toList
    (fun d => (targets64 d).toList) _
    (by rw [size_encodeAll64, Array.length_toList])
    (fun d _ => element_targets64 d) ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[9]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : ConstantEntry) (ts : List Target) :
    element specs32 9 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : ConstantEntry) (ts : List Target) :
    walk specs32 9 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : ConstantEntry) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll32 (xs : Array ConstantEntry) (ts : List Target) :
    walk specs32 9 (encodeAll32 xs).size
      ((targetsAll32 xs).toList ++ ts) = some ts := by
  rw [targetsAll32, toList_targetsOfAll]
  exact walk_elements getElem?_specs32 (by decide) xs.toList
    (fun d => (targets32 d).toList) _
    (by rw [size_encodeAll32, Array.length_toList])
    (fun d _ => element_targets32 d) ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : ConstantEntry) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : ConstantEntry) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct ConstantEntry :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs ConstantEntry :=
  ⟨size_toBytes, walk_toBytes⟩

end ConstantEntry

/-! ### `Extent3D`: its walk -/

namespace Extent3D

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[10]? = some (12, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : Extent3D) (ts : List Target) :
    element specs64 10 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : Extent3D) (ts : List Target) :
    walk specs64 10 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : Extent3D) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[10]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : Extent3D) (ts : List Target) :
    element specs32 10 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : Extent3D) (ts : List Target) :
    walk specs32 10 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : Extent3D) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : Extent3D) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : Extent3D) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct Extent3D :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs Extent3D :=
  ⟨size_toBytes, walk_toBytes⟩

end Extent3D

/-! ### `ExternalTextureBindingEntry`: its walk -/

namespace ExternalTextureBindingEntry

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[11]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : ExternalTextureBindingEntry) (ts : List Target) :
    element specs64 11 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : ExternalTextureBindingEntry) (ts : List Target) :
    walk specs64 11 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : ExternalTextureBindingEntry)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[11]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : ExternalTextureBindingEntry) (ts : List Target) :
    element specs32 11 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : ExternalTextureBindingEntry) (ts : List Target) :
    walk specs32 11 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : ExternalTextureBindingEntry)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : ExternalTextureBindingEntry) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : ExternalTextureBindingEntry) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct ExternalTextureBindingEntry :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs ExternalTextureBindingEntry :=
  ⟨size_toBytes, walk_toBytes⟩

end ExternalTextureBindingEntry

/-! ### `ExternalTextureBindingLayout`: its walk -/

namespace ExternalTextureBindingLayout

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[12]? = some (16, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : ExternalTextureBindingLayout)
    (ts : List Target) :
    element specs64 12 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : ExternalTextureBindingLayout) (ts : List Target) :
    walk specs64 12 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : ExternalTextureBindingLayout)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[12]? = some (8, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : ExternalTextureBindingLayout)
    (ts : List Target) :
    element specs32 12 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : ExternalTextureBindingLayout) (ts : List Target) :
    walk specs32 12 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : ExternalTextureBindingLayout)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : ExternalTextureBindingLayout) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : ExternalTextureBindingLayout) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct ExternalTextureBindingLayout :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs ExternalTextureBindingLayout :=
  ⟨size_toBytes, walk_toBytes⟩

end ExternalTextureBindingLayout

/-! ### `Future`: its walk -/

namespace Future

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[13]? = some (8, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : Future) (ts : List Target) :
    element specs64 13 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : Future) (ts : List Target) :
    walk specs64 13 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : Future) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[13]? = some (8, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : Future) (ts : List Target) :
    element specs32 13 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : Future) (ts : List Target) :
    walk specs32 13 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : Future) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : Future) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : Future) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct Future :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs Future :=
  ⟨size_toBytes, walk_toBytes⟩

end Future

/-! ### `InstanceLimits`: its walk -/

namespace InstanceLimits

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[14]? = some (16, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : InstanceLimits) (ts : List Target) :
    element specs64 14 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : InstanceLimits) (ts : List Target) :
    walk specs64 14 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : InstanceLimits) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[14]? = some (8, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : InstanceLimits) (ts : List Target) :
    element specs32 14 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : InstanceLimits) (ts : List Target) :
    walk specs32 14 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : InstanceLimits) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : InstanceLimits) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : InstanceLimits) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct InstanceLimits :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs InstanceLimits :=
  ⟨size_toBytes, walk_toBytes⟩

end InstanceLimits

/-! ### `MultisampleState`: its walk -/

namespace MultisampleState

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[15]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : MultisampleState) (ts : List Target) :
    element specs64 15 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : MultisampleState) (ts : List Target) :
    walk specs64 15 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : MultisampleState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[15]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : MultisampleState) (ts : List Target) :
    element specs32 15 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : MultisampleState) (ts : List Target) :
    walk specs32 15 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : MultisampleState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : MultisampleState) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : MultisampleState) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct MultisampleState :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs MultisampleState :=
  ⟨size_toBytes, walk_toBytes⟩

end MultisampleState

/-! ### `Origin3D`: its walk -/

namespace Origin3D

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[16]? = some (12, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : Origin3D) (ts : List Target) :
    element specs64 16 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : Origin3D) (ts : List Target) :
    walk specs64 16 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : Origin3D) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[16]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : Origin3D) (ts : List Target) :
    element specs32 16 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : Origin3D) (ts : List Target) :
    walk specs32 16 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : Origin3D) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : Origin3D) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : Origin3D) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct Origin3D :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs Origin3D :=
  ⟨size_toBytes, walk_toBytes⟩

end Origin3D

/-! ### `PassTimestampWrites`: its walk -/

namespace PassTimestampWrites

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[17]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : PassTimestampWrites) (ts : List Target) :
    element specs64 17 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : PassTimestampWrites) (ts : List Target) :
    walk specs64 17 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : PassTimestampWrites) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[17]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : PassTimestampWrites) (ts : List Target) :
    element specs32 17 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : PassTimestampWrites) (ts : List Target) :
    walk specs32 17 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : PassTimestampWrites) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : PassTimestampWrites) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : PassTimestampWrites) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct PassTimestampWrites :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs PassTimestampWrites :=
  ⟨size_toBytes, walk_toBytes⟩

end PassTimestampWrites

/-! ### `PipelineLayoutDescriptor`: its walk -/

namespace PipelineLayoutDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[18]? = some (48, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : PipelineLayoutDescriptor) (ts : List Target) :
    element specs64 18 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step,
    walk_objects getElem?_specs64_objects (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : PipelineLayoutDescriptor) (ts : List Target) :
    walk specs64 18 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : PipelineLayoutDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[18]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : PipelineLayoutDescriptor) (ts : List Target) :
    element specs32 18 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step,
    walk_objects getElem?_specs32_objects (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : PipelineLayoutDescriptor) (ts : List Target) :
    walk specs32 18 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : PipelineLayoutDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : PipelineLayoutDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : PipelineLayoutDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct PipelineLayoutDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs PipelineLayoutDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end PipelineLayoutDescriptor

/-! ### `PrimitiveState`: its walk -/

namespace PrimitiveState

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[19]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : PrimitiveState) (ts : List Target) :
    element specs64 19 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : PrimitiveState) (ts : List Target) :
    walk specs64 19 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : PrimitiveState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[19]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : PrimitiveState) (ts : List Target) :
    element specs32 19 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : PrimitiveState) (ts : List Target) :
    walk specs32 19 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : PrimitiveState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : PrimitiveState) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : PrimitiveState) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct PrimitiveState :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs PrimitiveState :=
  ⟨size_toBytes, walk_toBytes⟩

end PrimitiveState

/-! ### `QuerySetDescriptor`: its walk -/

namespace QuerySetDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[20]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : QuerySetDescriptor) (ts : List Target) :
    element specs64 20 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : QuerySetDescriptor) (ts : List Target) :
    walk specs64 20 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : QuerySetDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[20]? = some (20, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : QuerySetDescriptor) (ts : List Target) :
    element specs32 20 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : QuerySetDescriptor) (ts : List Target) :
    walk specs32 20 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : QuerySetDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : QuerySetDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : QuerySetDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct QuerySetDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs QuerySetDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end QuerySetDescriptor

/-! ### `QueueDescriptor`: its walk -/

namespace QueueDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[21]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : QueueDescriptor) (ts : List Target) :
    element specs64 21 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : QueueDescriptor) (ts : List Target) :
    walk specs64 21 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : QueueDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[21]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : QueueDescriptor) (ts : List Target) :
    element specs32 21 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : QueueDescriptor) (ts : List Target) :
    walk specs32 21 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : QueueDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : QueueDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : QueueDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct QueueDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs QueueDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end QueueDescriptor

/-! ### `RenderBundleDescriptor`: its walk -/

namespace RenderBundleDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[22]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : RenderBundleDescriptor) (ts : List Target) :
    element specs64 22 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : RenderBundleDescriptor) (ts : List Target) :
    walk specs64 22 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : RenderBundleDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[22]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : RenderBundleDescriptor) (ts : List Target) :
    element specs32 22 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : RenderBundleDescriptor) (ts : List Target) :
    walk specs32 22 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : RenderBundleDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : RenderBundleDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : RenderBundleDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct RenderBundleDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs RenderBundleDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end RenderBundleDescriptor

/-! ### `RenderBundleEncoderDescriptor`: its walk -/

namespace RenderBundleEncoderDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[23]? = some (56, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : RenderBundleEncoderDescriptor)
    (ts : List Target) :
    element specs64 23 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step, walk_words getElem?_specs64_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : RenderBundleEncoderDescriptor) (ts : List Target) :
    walk specs64 23 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : RenderBundleEncoderDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[23]? = some (36, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : RenderBundleEncoderDescriptor)
    (ts : List Target) :
    element specs32 23 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step, walk_words getElem?_specs32_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : RenderBundleEncoderDescriptor) (ts : List Target) :
    walk specs32 23 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : RenderBundleEncoderDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : RenderBundleEncoderDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : RenderBundleEncoderDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct RenderBundleEncoderDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs RenderBundleEncoderDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end RenderBundleEncoderDescriptor

/-! ### `RenderPassDepthStencilAttachment`: its walk -/

namespace RenderPassDepthStencilAttachment

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[24]? = some (48, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : RenderPassDepthStencilAttachment)
    (ts : List Target) :
    element specs64 24 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : RenderPassDepthStencilAttachment)
    (ts : List Target) :
    walk specs64 24 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : RenderPassDepthStencilAttachment)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[24]? = some (40, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : RenderPassDepthStencilAttachment)
    (ts : List Target) :
    element specs32 24 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : RenderPassDepthStencilAttachment)
    (ts : List Target) :
    walk specs32 24 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : RenderPassDepthStencilAttachment)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : RenderPassDepthStencilAttachment) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : RenderPassDepthStencilAttachment) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct RenderPassDepthStencilAttachment :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs RenderPassDepthStencilAttachment :=
  ⟨size_toBytes, walk_toBytes⟩

end RenderPassDepthStencilAttachment

/-! ### `RenderPassMaxDrawCount`: its walk -/

namespace RenderPassMaxDrawCount

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[25]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : RenderPassMaxDrawCount) (ts : List Target) :
    element specs64 25 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : RenderPassMaxDrawCount) (ts : List Target) :
    walk specs64 25 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : RenderPassMaxDrawCount)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[25]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : RenderPassMaxDrawCount) (ts : List Target) :
    element specs32 25 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : RenderPassMaxDrawCount) (ts : List Target) :
    walk specs32 25 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : RenderPassMaxDrawCount)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : RenderPassMaxDrawCount) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : RenderPassMaxDrawCount) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct RenderPassMaxDrawCount :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs RenderPassMaxDrawCount :=
  ⟨size_toBytes, walk_toBytes⟩

end RenderPassMaxDrawCount

/-! ### `RequestAdapterWebXROptions`: its walk -/

namespace RequestAdapterWebXROptions

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[26]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : RequestAdapterWebXROptions) (ts : List Target) :
    element specs64 26 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : RequestAdapterWebXROptions) (ts : List Target) :
    walk specs64 26 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : RequestAdapterWebXROptions)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[26]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : RequestAdapterWebXROptions) (ts : List Target) :
    element specs32 26 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : RequestAdapterWebXROptions) (ts : List Target) :
    walk specs32 26 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : RequestAdapterWebXROptions)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : RequestAdapterWebXROptions) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : RequestAdapterWebXROptions) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct RequestAdapterWebXROptions :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs RequestAdapterWebXROptions :=
  ⟨size_toBytes, walk_toBytes⟩

end RequestAdapterWebXROptions

/-! ### `SamplerBindingLayout`: its walk -/

namespace SamplerBindingLayout

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[27]? = some (16, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : SamplerBindingLayout) (ts : List Target) :
    element specs64 27 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : SamplerBindingLayout) (ts : List Target) :
    walk specs64 27 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : SamplerBindingLayout) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[27]? = some (8, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : SamplerBindingLayout) (ts : List Target) :
    element specs32 27 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : SamplerBindingLayout) (ts : List Target) :
    walk specs32 27 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : SamplerBindingLayout) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : SamplerBindingLayout) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : SamplerBindingLayout) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct SamplerBindingLayout :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs SamplerBindingLayout :=
  ⟨size_toBytes, walk_toBytes⟩

end SamplerBindingLayout

/-! ### `SamplerDescriptor`: its walk -/

namespace SamplerDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[28]? = some (64, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : SamplerDescriptor) (ts : List Target) :
    element specs64 28 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : SamplerDescriptor) (ts : List Target) :
    walk specs64 28 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : SamplerDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[28]? = some (52, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : SamplerDescriptor) (ts : List Target) :
    element specs32 28 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : SamplerDescriptor) (ts : List Target) :
    walk specs32 28 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : SamplerDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : SamplerDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : SamplerDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct SamplerDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs SamplerDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end SamplerDescriptor

/-! ### `ShaderSourceWGSL`: its walk -/

namespace ShaderSourceWGSL

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[29]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : ShaderSourceWGSL) (ts : List Target) :
    element specs64 29 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : ShaderSourceWGSL) (ts : List Target) :
    walk specs64 29 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : ShaderSourceWGSL) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[29]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : ShaderSourceWGSL) (ts : List Target) :
    element specs32 29 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : ShaderSourceWGSL) (ts : List Target) :
    walk specs32 29 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : ShaderSourceWGSL) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : ShaderSourceWGSL) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : ShaderSourceWGSL) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct ShaderSourceWGSL :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs ShaderSourceWGSL :=
  ⟨size_toBytes, walk_toBytes⟩

end ShaderSourceWGSL

/-! ### `StencilFaceState`: its walk -/

namespace StencilFaceState

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[30]? = some (16, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : StencilFaceState) (ts : List Target) :
    element specs64 30 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : StencilFaceState) (ts : List Target) :
    walk specs64 30 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : StencilFaceState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[30]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : StencilFaceState) (ts : List Target) :
    element specs32 30 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : StencilFaceState) (ts : List Target) :
    walk specs32 30 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : StencilFaceState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : StencilFaceState) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : StencilFaceState) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct StencilFaceState :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs StencilFaceState :=
  ⟨size_toBytes, walk_toBytes⟩

end StencilFaceState

/-! ### `StorageTextureBindingLayout`: its walk -/

namespace StorageTextureBindingLayout

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[31]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : StorageTextureBindingLayout) (ts : List Target) :
    element specs64 31 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : StorageTextureBindingLayout) (ts : List Target) :
    walk specs64 31 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : StorageTextureBindingLayout)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[31]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : StorageTextureBindingLayout) (ts : List Target) :
    element specs32 31 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : StorageTextureBindingLayout) (ts : List Target) :
    walk specs32 31 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : StorageTextureBindingLayout)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : StorageTextureBindingLayout) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : StorageTextureBindingLayout) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct StorageTextureBindingLayout :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs StorageTextureBindingLayout :=
  ⟨size_toBytes, walk_toBytes⟩

end StorageTextureBindingLayout

/-! ### `SupportedFeatures`: its walk -/

namespace SupportedFeatures

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[32]? = some (16, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : SupportedFeatures) (ts : List Target) :
    element specs64 32 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step, walk_words getElem?_specs64_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : SupportedFeatures) (ts : List Target) :
    walk specs64 32 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : SupportedFeatures) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[32]? = some (8, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : SupportedFeatures) (ts : List Target) :
    element specs32 32 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step, walk_words getElem?_specs32_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : SupportedFeatures) (ts : List Target) :
    walk specs32 32 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : SupportedFeatures) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : SupportedFeatures) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : SupportedFeatures) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct SupportedFeatures :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs SupportedFeatures :=
  ⟨size_toBytes, walk_toBytes⟩

end SupportedFeatures

/-! ### `SupportedInstanceFeatures`: its walk -/

namespace SupportedInstanceFeatures

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[33]? = some (16, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : SupportedInstanceFeatures) (ts : List Target) :
    element specs64 33 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step, walk_words getElem?_specs64_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : SupportedInstanceFeatures) (ts : List Target) :
    walk specs64 33 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : SupportedInstanceFeatures)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[33]? = some (8, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : SupportedInstanceFeatures) (ts : List Target) :
    element specs32 33 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step, walk_words getElem?_specs32_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : SupportedInstanceFeatures) (ts : List Target) :
    walk specs32 33 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : SupportedInstanceFeatures)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : SupportedInstanceFeatures) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : SupportedInstanceFeatures) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct SupportedInstanceFeatures :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs SupportedInstanceFeatures :=
  ⟨size_toBytes, walk_toBytes⟩

end SupportedInstanceFeatures

/-! ### `SupportedWGSLLanguageFeatures`: its walk -/

namespace SupportedWGSLLanguageFeatures

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[34]? = some (16, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : SupportedWGSLLanguageFeatures)
    (ts : List Target) :
    element specs64 34 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step, walk_words getElem?_specs64_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : SupportedWGSLLanguageFeatures) (ts : List Target) :
    walk specs64 34 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : SupportedWGSLLanguageFeatures)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[34]? = some (8, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : SupportedWGSLLanguageFeatures)
    (ts : List Target) :
    element specs32 34 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step, walk_words getElem?_specs32_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : SupportedWGSLLanguageFeatures) (ts : List Target) :
    walk specs32 34 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : SupportedWGSLLanguageFeatures)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : SupportedWGSLLanguageFeatures) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : SupportedWGSLLanguageFeatures) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct SupportedWGSLLanguageFeatures :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs SupportedWGSLLanguageFeatures :=
  ⟨size_toBytes, walk_toBytes⟩

end SupportedWGSLLanguageFeatures

/-! ### `SurfaceCapabilities`: its walk -/

namespace SurfaceCapabilities

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[35]? = some (64, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : SurfaceCapabilities) (ts : List Target) :
    element specs64 35 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step, walk_words getElem?_specs64_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : SurfaceCapabilities) (ts : List Target) :
    walk specs64 35 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : SurfaceCapabilities) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[35]? = some (40, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : SurfaceCapabilities) (ts : List Target) :
    element specs32 35 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step, walk_words getElem?_specs32_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : SurfaceCapabilities) (ts : List Target) :
    walk specs32 35 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : SurfaceCapabilities) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : SurfaceCapabilities) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : SurfaceCapabilities) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct SurfaceCapabilities :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs SurfaceCapabilities :=
  ⟨size_toBytes, walk_toBytes⟩

end SurfaceCapabilities

/-! ### `SurfaceColorManagement`: its walk -/

namespace SurfaceColorManagement

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[36]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : SurfaceColorManagement) (ts : List Target) :
    element specs64 36 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : SurfaceColorManagement) (ts : List Target) :
    walk specs64 36 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : SurfaceColorManagement)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[36]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : SurfaceColorManagement) (ts : List Target) :
    element specs32 36 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : SurfaceColorManagement) (ts : List Target) :
    walk specs32 36 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : SurfaceColorManagement)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : SurfaceColorManagement) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : SurfaceColorManagement) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct SurfaceColorManagement :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs SurfaceColorManagement :=
  ⟨size_toBytes, walk_toBytes⟩

end SurfaceColorManagement

/-! ### `SurfaceConfiguration`: its walk -/

namespace SurfaceConfiguration

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[37]? = some (64, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : SurfaceConfiguration) (ts : List Target) :
    element specs64 37 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step, walk_words getElem?_specs64_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : SurfaceConfiguration) (ts : List Target) :
    walk specs64 37 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : SurfaceConfiguration) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[37]? = some (48, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : SurfaceConfiguration) (ts : List Target) :
    element specs32 37 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step, walk_words getElem?_specs32_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : SurfaceConfiguration) (ts : List Target) :
    walk specs32 37 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : SurfaceConfiguration) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : SurfaceConfiguration) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : SurfaceConfiguration) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct SurfaceConfiguration :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs SurfaceConfiguration :=
  ⟨size_toBytes, walk_toBytes⟩

end SurfaceConfiguration

/-! ### `SurfaceDescriptor`: its walk -/

namespace SurfaceDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[38]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : SurfaceDescriptor) (ts : List Target) :
    element specs64 38 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : SurfaceDescriptor) (ts : List Target) :
    walk specs64 38 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : SurfaceDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[38]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : SurfaceDescriptor) (ts : List Target) :
    element specs32 38 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : SurfaceDescriptor) (ts : List Target) :
    walk specs32 38 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : SurfaceDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : SurfaceDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : SurfaceDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct SurfaceDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs SurfaceDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end SurfaceDescriptor

/-! ### `SurfaceTexture`: its walk -/

namespace SurfaceTexture

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[39]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : SurfaceTexture) (ts : List Target) :
    element specs64 39 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : SurfaceTexture) (ts : List Target) :
    walk specs64 39 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : SurfaceTexture) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[39]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : SurfaceTexture) (ts : List Target) :
    element specs32 39 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : SurfaceTexture) (ts : List Target) :
    walk specs32 39 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : SurfaceTexture) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : SurfaceTexture) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : SurfaceTexture) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct SurfaceTexture :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs SurfaceTexture :=
  ⟨size_toBytes, walk_toBytes⟩

end SurfaceTexture

/-! ### `TexelCopyBufferLayout`: its walk -/

namespace TexelCopyBufferLayout

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[40]? = some (16, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : TexelCopyBufferLayout) (ts : List Target) :
    element specs64 40 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : TexelCopyBufferLayout) (ts : List Target) :
    walk specs64 40 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : TexelCopyBufferLayout)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[40]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : TexelCopyBufferLayout) (ts : List Target) :
    element specs32 40 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : TexelCopyBufferLayout) (ts : List Target) :
    walk specs32 40 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : TexelCopyBufferLayout)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : TexelCopyBufferLayout) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : TexelCopyBufferLayout) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct TexelCopyBufferLayout :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs TexelCopyBufferLayout :=
  ⟨size_toBytes, walk_toBytes⟩

end TexelCopyBufferLayout

/-! ### `TextureBindingLayout`: its walk -/

namespace TextureBindingLayout

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[41]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : TextureBindingLayout) (ts : List Target) :
    element specs64 41 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : TextureBindingLayout) (ts : List Target) :
    walk specs64 41 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : TextureBindingLayout) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[41]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : TextureBindingLayout) (ts : List Target) :
    element specs32 41 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : TextureBindingLayout) (ts : List Target) :
    walk specs32 41 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : TextureBindingLayout) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : TextureBindingLayout) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : TextureBindingLayout) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct TextureBindingLayout :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs TextureBindingLayout :=
  ⟨size_toBytes, walk_toBytes⟩

end TextureBindingLayout

/-! ### `TextureBindingViewDimension`: its walk -/

namespace TextureBindingViewDimension

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[42]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : TextureBindingViewDimension) (ts : List Target) :
    element specs64 42 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : TextureBindingViewDimension) (ts : List Target) :
    walk specs64 42 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : TextureBindingViewDimension)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[42]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : TextureBindingViewDimension) (ts : List Target) :
    element specs32 42 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : TextureBindingViewDimension) (ts : List Target) :
    walk specs32 42 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : TextureBindingViewDimension)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : TextureBindingViewDimension) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : TextureBindingViewDimension) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct TextureBindingViewDimension :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs TextureBindingViewDimension :=
  ⟨size_toBytes, walk_toBytes⟩

end TextureBindingViewDimension

/-! ### `TextureComponentSwizzle`: its walk -/

namespace TextureComponentSwizzle

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[43]? = some (16, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : TextureComponentSwizzle) (ts : List Target) :
    element specs64 43 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : TextureComponentSwizzle) (ts : List Target) :
    walk specs64 43 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : TextureComponentSwizzle)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[43]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : TextureComponentSwizzle) (ts : List Target) :
    element specs32 43 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : TextureComponentSwizzle) (ts : List Target) :
    walk specs32 43 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : TextureComponentSwizzle)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : TextureComponentSwizzle) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : TextureComponentSwizzle) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct TextureComponentSwizzle :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs TextureComponentSwizzle :=
  ⟨size_toBytes, walk_toBytes⟩

end TextureComponentSwizzle

/-! ### `VertexAttribute`: its walk -/

namespace VertexAttribute

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[44]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : VertexAttribute) (ts : List Target) :
    element specs64 44 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : VertexAttribute) (ts : List Target) :
    walk specs64 44 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : VertexAttribute) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll64 (xs : Array VertexAttribute) (ts : List Target) :
    walk specs64 44 (encodeAll64 xs).size
      ((targetsAll64 xs).toList ++ ts) = some ts := by
  rw [targetsAll64, toList_targetsOfAll]
  exact walk_elements getElem?_specs64 (by decide) xs.toList
    (fun d => (targets64 d).toList) _
    (by rw [size_encodeAll64, Array.length_toList])
    (fun d _ => element_targets64 d) ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[44]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : VertexAttribute) (ts : List Target) :
    element specs32 44 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : VertexAttribute) (ts : List Target) :
    walk specs32 44 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : VertexAttribute) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll32 (xs : Array VertexAttribute) (ts : List Target) :
    walk specs32 44 (encodeAll32 xs).size
      ((targetsAll32 xs).toList ++ ts) = some ts := by
  rw [targetsAll32, toList_targetsOfAll]
  exact walk_elements getElem?_specs32 (by decide) xs.toList
    (fun d => (targets32 d).toList) _
    (by rw [size_encodeAll32, Array.length_toList])
    (fun d _ => element_targets32 d) ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : VertexAttribute) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : VertexAttribute) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct VertexAttribute :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs VertexAttribute :=
  ⟨size_toBytes, walk_toBytes⟩

end VertexAttribute

/-! ### `BindGroupEntry`: its walk -/

namespace BindGroupEntry

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Each link's table comes before its own. -/
theorem chainLink64_lt_tableIndex (c : Chained) :
    (chainLink64 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink64, tableIndex, ExternalTextureBindingEntry.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink64_isLink (c : Chained) :
    specs64[(chainLink64 c).2]?.any
      (·.isLink (chainLink64 c).1.size) := by
  cases c <;>
    simp [
      chainLink64, Spec.isLink, ExternalTextureBindingEntry.tableIndex,
      ExternalTextureBindingEntry.getElem?_specs64,
      ExternalTextureBindingEntry.size_encode64,
      ExternalTextureBindingEntry.relocs64]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain64 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs64 (fun j size ts =>
        if j < table then walk specs64 j size ts else none)
      (cs.map chainLink64)
      ((targetsOfAll chainTargets64 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink64_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink64_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink64, chainTargets64,
      ExternalTextureBindingEntry.walk_encode64_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[45]? = some (56, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : BindGroupEntry) (ts : List Target) :
    element specs64 45 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, chainTargetsOf_eq,
    BindGroupEntry.walk_chain64 (table := 45) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : BindGroupEntry) (ts : List Target) :
    walk specs64 45 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : BindGroupEntry) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll64 (xs : Array BindGroupEntry) (ts : List Target) :
    walk specs64 45 (encodeAll64 xs).size
      ((targetsAll64 xs).toList ++ ts) = some ts := by
  rw [targetsAll64, toList_targetsOfAll]
  exact walk_elements getElem?_specs64 (by decide) xs.toList
    (fun d => (targets64 d).toList) _
    (by rw [size_encodeAll64, Array.length_toList])
    (fun d _ => element_targets64 d) ts

/-- Each link's table comes before its own. -/
theorem chainLink32_lt_tableIndex (c : Chained) :
    (chainLink32 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink32, tableIndex, ExternalTextureBindingEntry.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink32_isLink (c : Chained) :
    specs32[(chainLink32 c).2]?.any
      (·.isLink (chainLink32 c).1.size) := by
  cases c <;>
    simp [
      chainLink32, Spec.isLink, ExternalTextureBindingEntry.tableIndex,
      ExternalTextureBindingEntry.getElem?_specs32,
      ExternalTextureBindingEntry.size_encode32,
      ExternalTextureBindingEntry.relocs32]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain32 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs32 (fun j size ts =>
        if j < table then walk specs32 j size ts else none)
      (cs.map chainLink32)
      ((targetsOfAll chainTargets32 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink32_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink32_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink32, chainTargets32,
      ExternalTextureBindingEntry.walk_encode32_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[45]? = some (40, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : BindGroupEntry) (ts : List Target) :
    element specs32 45 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, chainTargetsOf_eq,
    BindGroupEntry.walk_chain32 (table := 45) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : BindGroupEntry) (ts : List Target) :
    walk specs32 45 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : BindGroupEntry) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll32 (xs : Array BindGroupEntry) (ts : List Target) :
    walk specs32 45 (encodeAll32 xs).size
      ((targetsAll32 xs).toList ++ ts) = some ts := by
  rw [targetsAll32, toList_targetsOfAll]
  exact walk_elements getElem?_specs32 (by decide) xs.toList
    (fun d => (targets32 d).toList) _
    (by rw [size_encodeAll32, Array.length_toList])
    (fun d _ => element_targets32 d) ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : BindGroupEntry) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : BindGroupEntry) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct BindGroupEntry :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs BindGroupEntry :=
  ⟨size_toBytes, walk_toBytes⟩

end BindGroupEntry

/-! ### `BindGroupLayoutEntry`: its walk -/

namespace BindGroupLayoutEntry

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Each link's table comes before its own. -/
theorem chainLink64_lt_tableIndex (c : Chained) :
    (chainLink64 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink64, tableIndex, ExternalTextureBindingLayout.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink64_isLink (c : Chained) :
    specs64[(chainLink64 c).2]?.any
      (·.isLink (chainLink64 c).1.size) := by
  cases c <;>
    simp [
      chainLink64, Spec.isLink, ExternalTextureBindingLayout.tableIndex,
      ExternalTextureBindingLayout.getElem?_specs64,
      ExternalTextureBindingLayout.size_encode64,
      ExternalTextureBindingLayout.relocs64]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain64 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs64 (fun j size ts =>
        if j < table then walk specs64 j size ts else none)
      (cs.map chainLink64)
      ((targetsOfAll chainTargets64 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink64_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink64_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink64, chainTargets64,
      ExternalTextureBindingLayout.walk_encode64_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[46]? = some (120, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : BindGroupLayoutEntry) (ts : List Target) :
    element specs64 46 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, chainTargetsOf_eq,
    BindGroupLayoutEntry.walk_chain64 (table := 46) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : BindGroupLayoutEntry) (ts : List Target) :
    walk specs64 46 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : BindGroupLayoutEntry) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll64 (xs : Array BindGroupLayoutEntry) (ts : List Target) :
    walk specs64 46 (encodeAll64 xs).size
      ((targetsAll64 xs).toList ++ ts) = some ts := by
  rw [targetsAll64, toList_targetsOfAll]
  exact walk_elements getElem?_specs64 (by decide) xs.toList
    (fun d => (targets64 d).toList) _
    (by rw [size_encodeAll64, Array.length_toList])
    (fun d _ => element_targets64 d) ts

/-- Each link's table comes before its own. -/
theorem chainLink32_lt_tableIndex (c : Chained) :
    (chainLink32 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink32, tableIndex, ExternalTextureBindingLayout.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink32_isLink (c : Chained) :
    specs32[(chainLink32 c).2]?.any
      (·.isLink (chainLink32 c).1.size) := by
  cases c <;>
    simp [
      chainLink32, Spec.isLink, ExternalTextureBindingLayout.tableIndex,
      ExternalTextureBindingLayout.getElem?_specs32,
      ExternalTextureBindingLayout.size_encode32,
      ExternalTextureBindingLayout.relocs32]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain32 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs32 (fun j size ts =>
        if j < table then walk specs32 j size ts else none)
      (cs.map chainLink32)
      ((targetsOfAll chainTargets32 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink32_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink32_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink32, chainTargets32,
      ExternalTextureBindingLayout.walk_encode32_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[46]? = some (88, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : BindGroupLayoutEntry) (ts : List Target) :
    element specs32 46 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, chainTargetsOf_eq,
    BindGroupLayoutEntry.walk_chain32 (table := 46) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : BindGroupLayoutEntry) (ts : List Target) :
    walk specs32 46 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : BindGroupLayoutEntry) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll32 (xs : Array BindGroupLayoutEntry) (ts : List Target) :
    walk specs32 46 (encodeAll32 xs).size
      ((targetsAll32 xs).toList ++ ts) = some ts := by
  rw [targetsAll32, toList_targetsOfAll]
  exact walk_elements getElem?_specs32 (by decide) xs.toList
    (fun d => (targets32 d).toList) _
    (by rw [size_encodeAll32, Array.length_toList])
    (fun d _ => element_targets32 d) ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : BindGroupLayoutEntry) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : BindGroupLayoutEntry) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct BindGroupLayoutEntry :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs BindGroupLayoutEntry :=
  ⟨size_toBytes, walk_toBytes⟩

end BindGroupLayoutEntry

/-! ### `BlendState`: its walk -/

namespace BlendState

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[47]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : BlendState) (ts : List Target) :
    element specs64 47 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : BlendState) (ts : List Target) :
    walk specs64 47 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : BlendState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[47]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : BlendState) (ts : List Target) :
    element specs32 47 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : BlendState) (ts : List Target) :
    walk specs32 47 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : BlendState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : BlendState) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : BlendState) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct BlendState :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs BlendState :=
  ⟨size_toBytes, walk_toBytes⟩

end BlendState

/-! ### `ComputePassDescriptor`: its walk -/

namespace ComputePassDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[48]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : ComputePassDescriptor) (ts : List Target) :
    element specs64 48 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  cases h0 : d.timestampWrites <;>
    simp [
      element, relocs64, targets64, step, optBlock, h0,
      PassTimestampWrites.block64, PassTimestampWrites.walk_encode64,
      walk_empty PassTimestampWrites.getElem?_specs64 (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : ComputePassDescriptor) (ts : List Target) :
    walk specs64 48 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : ComputePassDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[48]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : ComputePassDescriptor) (ts : List Target) :
    element specs32 48 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  cases h0 : d.timestampWrites <;>
    simp [
      element, relocs32, targets32, step, optBlock, h0,
      PassTimestampWrites.block32, PassTimestampWrites.walk_encode32,
      walk_empty PassTimestampWrites.getElem?_specs32 (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : ComputePassDescriptor) (ts : List Target) :
    walk specs32 48 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : ComputePassDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : ComputePassDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : ComputePassDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct ComputePassDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs ComputePassDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end ComputePassDescriptor

/-! ### `ComputeState`: its walk -/

namespace ComputeState

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[49]? = some (48, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : ComputeState) (ts : List Target) :
    element specs64 49 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, ConstantEntry.array64,
    ConstantEntry.walk_encodeAll64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : ComputeState) (ts : List Target) :
    walk specs64 49 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : ComputeState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[49]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : ComputeState) (ts : List Target) :
    element specs32 49 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, ConstantEntry.array32,
    ConstantEntry.walk_encodeAll32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : ComputeState) (ts : List Target) :
    walk specs32 49 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : ComputeState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : ComputeState) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : ComputeState) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct ComputeState :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs ComputeState :=
  ⟨size_toBytes, walk_toBytes⟩

end ComputeState

/-! ### `DepthStencilState`: its walk -/

namespace DepthStencilState

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[50]? = some (72, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : DepthStencilState) (ts : List Target) :
    element specs64 50 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : DepthStencilState) (ts : List Target) :
    walk specs64 50 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : DepthStencilState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[50]? = some (68, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : DepthStencilState) (ts : List Target) :
    element specs32 50 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : DepthStencilState) (ts : List Target) :
    walk specs32 50 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : DepthStencilState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : DepthStencilState) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : DepthStencilState) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct DepthStencilState :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs DepthStencilState :=
  ⟨size_toBytes, walk_toBytes⟩

end DepthStencilState

/-! ### `FutureWaitInfo`: its walk -/

namespace FutureWaitInfo

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[51]? = some (16, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : FutureWaitInfo) (ts : List Target) :
    element specs64 51 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : FutureWaitInfo) (ts : List Target) :
    walk specs64 51 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : FutureWaitInfo) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[51]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : FutureWaitInfo) (ts : List Target) :
    element specs32 51 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : FutureWaitInfo) (ts : List Target) :
    walk specs32 51 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : FutureWaitInfo) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : FutureWaitInfo) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : FutureWaitInfo) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct FutureWaitInfo :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs FutureWaitInfo :=
  ⟨size_toBytes, walk_toBytes⟩

end FutureWaitInfo

/-! ### `InstanceDescriptor`: its walk -/

namespace InstanceDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[52]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : InstanceDescriptor) (ts : List Target) :
    element specs64 52 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  cases h0 : d.requiredLimits <;>
    simp [
      element, relocs64, targets64, step, optBlock, h0, InstanceLimits.block64,
      InstanceLimits.walk_encode64,
      walk_empty InstanceLimits.getElem?_specs64 (by decide),
      walk_words getElem?_specs64_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : InstanceDescriptor) (ts : List Target) :
    walk specs64 52 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : InstanceDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[52]? = some (16, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : InstanceDescriptor) (ts : List Target) :
    element specs32 52 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  cases h0 : d.requiredLimits <;>
    simp [
      element, relocs32, targets32, step, optBlock, h0, InstanceLimits.block32,
      InstanceLimits.walk_encode32,
      walk_empty InstanceLimits.getElem?_specs32 (by decide),
      walk_words getElem?_specs32_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : InstanceDescriptor) (ts : List Target) :
    walk specs32 52 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : InstanceDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : InstanceDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : InstanceDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct InstanceDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs InstanceDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end InstanceDescriptor

/-! ### `Limits`: its walk -/

namespace Limits

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Each link's table comes before its own. -/
theorem chainLink64_lt_tableIndex (c : Chained) :
    (chainLink64 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink64, tableIndex, CompatibilityModeLimits.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink64_isLink (c : Chained) :
    specs64[(chainLink64 c).2]?.any
      (·.isLink (chainLink64 c).1.size) := by
  cases c <;>
    simp [
      chainLink64, Spec.isLink, CompatibilityModeLimits.tableIndex,
      CompatibilityModeLimits.getElem?_specs64,
      CompatibilityModeLimits.size_encode64, CompatibilityModeLimits.relocs64]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain64 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs64 (fun j size ts =>
        if j < table then walk specs64 j size ts else none)
      (cs.map chainLink64)
      ((targetsOfAll chainTargets64 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink64_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink64_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink64, chainTargets64,
      CompatibilityModeLimits.walk_encode64_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[53]? = some (152, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : Limits) (ts : List Target) :
    element specs64 53 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, chainTargetsOf_eq,
    Limits.walk_chain64 (table := 53) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : Limits) (ts : List Target) :
    walk specs64 53 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : Limits) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Each link's table comes before its own. -/
theorem chainLink32_lt_tableIndex (c : Chained) :
    (chainLink32 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink32, tableIndex, CompatibilityModeLimits.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink32_isLink (c : Chained) :
    specs32[(chainLink32 c).2]?.any
      (·.isLink (chainLink32 c).1.size) := by
  cases c <;>
    simp [
      chainLink32, Spec.isLink, CompatibilityModeLimits.tableIndex,
      CompatibilityModeLimits.getElem?_specs32,
      CompatibilityModeLimits.size_encode32, CompatibilityModeLimits.relocs32]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain32 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs32 (fun j size ts =>
        if j < table then walk specs32 j size ts else none)
      (cs.map chainLink32)
      ((targetsOfAll chainTargets32 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink32_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink32_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink32, chainTargets32,
      CompatibilityModeLimits.walk_encode32_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[53]? = some (152, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : Limits) (ts : List Target) :
    element specs32 53 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, chainTargetsOf_eq,
    Limits.walk_chain32 (table := 53) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : Limits) (ts : List Target) :
    walk specs32 53 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : Limits) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : Limits) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : Limits) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct Limits :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs Limits :=
  ⟨size_toBytes, walk_toBytes⟩

end Limits

/-! ### `RenderPassColorAttachment`: its walk -/

namespace RenderPassColorAttachment

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[54]? = some (72, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : RenderPassColorAttachment) (ts : List Target) :
    element specs64 54 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : RenderPassColorAttachment) (ts : List Target) :
    walk specs64 54 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : RenderPassColorAttachment)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll64 (xs : Array RenderPassColorAttachment)
    (ts : List Target) :
    walk specs64 54 (encodeAll64 xs).size
      ((targetsAll64 xs).toList ++ ts) = some ts := by
  rw [targetsAll64, toList_targetsOfAll]
  exact walk_elements getElem?_specs64 (by decide) xs.toList
    (fun d => (targets64 d).toList) _
    (by rw [size_encodeAll64, Array.length_toList])
    (fun d _ => element_targets64 d) ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[54]? = some (56, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : RenderPassColorAttachment) (ts : List Target) :
    element specs32 54 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : RenderPassColorAttachment) (ts : List Target) :
    walk specs32 54 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : RenderPassColorAttachment)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll32 (xs : Array RenderPassColorAttachment)
    (ts : List Target) :
    walk specs32 54 (encodeAll32 xs).size
      ((targetsAll32 xs).toList ++ ts) = some ts := by
  rw [targetsAll32, toList_targetsOfAll]
  exact walk_elements getElem?_specs32 (by decide) xs.toList
    (fun d => (targets32 d).toList) _
    (by rw [size_encodeAll32, Array.length_toList])
    (fun d _ => element_targets32 d) ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : RenderPassColorAttachment) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : RenderPassColorAttachment) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct RenderPassColorAttachment :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs RenderPassColorAttachment :=
  ⟨size_toBytes, walk_toBytes⟩

end RenderPassColorAttachment

/-! ### `RequestAdapterOptions`: its walk -/

namespace RequestAdapterOptions

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Each link's table comes before its own. -/
theorem chainLink64_lt_tableIndex (c : Chained) :
    (chainLink64 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink64, tableIndex, RequestAdapterWebXROptions.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink64_isLink (c : Chained) :
    specs64[(chainLink64 c).2]?.any
      (·.isLink (chainLink64 c).1.size) := by
  cases c <;>
    simp [
      chainLink64, Spec.isLink, RequestAdapterWebXROptions.tableIndex,
      RequestAdapterWebXROptions.getElem?_specs64,
      RequestAdapterWebXROptions.size_encode64,
      RequestAdapterWebXROptions.relocs64]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain64 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs64 (fun j size ts =>
        if j < table then walk specs64 j size ts else none)
      (cs.map chainLink64)
      ((targetsOfAll chainTargets64 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink64_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink64_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink64, chainTargets64,
      RequestAdapterWebXROptions.walk_encode64_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[55]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : RequestAdapterOptions) (ts : List Target) :
    element specs64 55 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, chainTargetsOf_eq,
    RequestAdapterOptions.walk_chain64 (table := 55) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : RequestAdapterOptions) (ts : List Target) :
    walk specs64 55 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : RequestAdapterOptions)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Each link's table comes before its own. -/
theorem chainLink32_lt_tableIndex (c : Chained) :
    (chainLink32 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink32, tableIndex, RequestAdapterWebXROptions.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink32_isLink (c : Chained) :
    specs32[(chainLink32 c).2]?.any
      (·.isLink (chainLink32 c).1.size) := by
  cases c <;>
    simp [
      chainLink32, Spec.isLink, RequestAdapterWebXROptions.tableIndex,
      RequestAdapterWebXROptions.getElem?_specs32,
      RequestAdapterWebXROptions.size_encode32,
      RequestAdapterWebXROptions.relocs32]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain32 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs32 (fun j size ts =>
        if j < table then walk specs32 j size ts else none)
      (cs.map chainLink32)
      ((targetsOfAll chainTargets32 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink32_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink32_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink32, chainTargets32,
      RequestAdapterWebXROptions.walk_encode32_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[55]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : RequestAdapterOptions) (ts : List Target) :
    element specs32 55 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, chainTargetsOf_eq,
    RequestAdapterOptions.walk_chain32 (table := 55) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : RequestAdapterOptions) (ts : List Target) :
    walk specs32 55 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : RequestAdapterOptions)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : RequestAdapterOptions) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : RequestAdapterOptions) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct RequestAdapterOptions :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs RequestAdapterOptions :=
  ⟨size_toBytes, walk_toBytes⟩

end RequestAdapterOptions

/-! ### `ShaderModuleDescriptor`: its walk -/

namespace ShaderModuleDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Each link's table comes before its own. -/
theorem chainLink64_lt_tableIndex (c : Chained) :
    (chainLink64 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink64, tableIndex, ShaderSourceWGSL.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink64_isLink (c : Chained) :
    specs64[(chainLink64 c).2]?.any
      (·.isLink (chainLink64 c).1.size) := by
  cases c <;>
    simp [
      chainLink64, Spec.isLink, ShaderSourceWGSL.tableIndex,
      ShaderSourceWGSL.getElem?_specs64, ShaderSourceWGSL.size_encode64,
      ShaderSourceWGSL.relocs64]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain64 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs64 (fun j size ts =>
        if j < table then walk specs64 j size ts else none)
      (cs.map chainLink64)
      ((targetsOfAll chainTargets64 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink64_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink64_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink64, chainTargets64, ShaderSourceWGSL.walk_encode64_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[56]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : ShaderModuleDescriptor) (ts : List Target) :
    element specs64 56 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, chainTargetsOf_eq,
    ShaderModuleDescriptor.walk_chain64 (table := 56) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : ShaderModuleDescriptor) (ts : List Target) :
    walk specs64 56 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : ShaderModuleDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Each link's table comes before its own. -/
theorem chainLink32_lt_tableIndex (c : Chained) :
    (chainLink32 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink32, tableIndex, ShaderSourceWGSL.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink32_isLink (c : Chained) :
    specs32[(chainLink32 c).2]?.any
      (·.isLink (chainLink32 c).1.size) := by
  cases c <;>
    simp [
      chainLink32, Spec.isLink, ShaderSourceWGSL.tableIndex,
      ShaderSourceWGSL.getElem?_specs32, ShaderSourceWGSL.size_encode32,
      ShaderSourceWGSL.relocs32]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain32 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs32 (fun j size ts =>
        if j < table then walk specs32 j size ts else none)
      (cs.map chainLink32)
      ((targetsOfAll chainTargets32 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink32_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink32_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink32, chainTargets32, ShaderSourceWGSL.walk_encode32_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[56]? = some (12, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : ShaderModuleDescriptor) (ts : List Target) :
    element specs32 56 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, chainTargetsOf_eq,
    ShaderModuleDescriptor.walk_chain32 (table := 56) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : ShaderModuleDescriptor) (ts : List Target) :
    walk specs32 56 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : ShaderModuleDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : ShaderModuleDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : ShaderModuleDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct ShaderModuleDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs ShaderModuleDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end ShaderModuleDescriptor

/-! ### `TexelCopyBufferInfo`: its walk -/

namespace TexelCopyBufferInfo

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[57]? = some (24, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : TexelCopyBufferInfo) (ts : List Target) :
    element specs64 57 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : TexelCopyBufferInfo) (ts : List Target) :
    walk specs64 57 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : TexelCopyBufferInfo) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[57]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : TexelCopyBufferInfo) (ts : List Target) :
    element specs32 57 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : TexelCopyBufferInfo) (ts : List Target) :
    walk specs32 57 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : TexelCopyBufferInfo) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : TexelCopyBufferInfo) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : TexelCopyBufferInfo) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct TexelCopyBufferInfo :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs TexelCopyBufferInfo :=
  ⟨size_toBytes, walk_toBytes⟩

end TexelCopyBufferInfo

/-! ### `TexelCopyTextureInfo`: its walk -/

namespace TexelCopyTextureInfo

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[58]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : TexelCopyTextureInfo) (ts : List Target) :
    element specs64 58 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : TexelCopyTextureInfo) (ts : List Target) :
    walk specs64 58 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : TexelCopyTextureInfo) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[58]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : TexelCopyTextureInfo) (ts : List Target) :
    element specs32 58 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : TexelCopyTextureInfo) (ts : List Target) :
    walk specs32 58 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : TexelCopyTextureInfo) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : TexelCopyTextureInfo) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : TexelCopyTextureInfo) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct TexelCopyTextureInfo :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs TexelCopyTextureInfo :=
  ⟨size_toBytes, walk_toBytes⟩

end TexelCopyTextureInfo

/-! ### `TextureComponentSwizzleDescriptor`: its walk -/

namespace TextureComponentSwizzleDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[59]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : TextureComponentSwizzleDescriptor)
    (ts : List Target) :
    element specs64 59 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [element, relocs64, targets64, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : TextureComponentSwizzleDescriptor)
    (ts : List Target) :
    walk specs64 59 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : TextureComponentSwizzleDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[59]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : TextureComponentSwizzleDescriptor)
    (ts : List Target) :
    element specs32 59 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [element, relocs32, targets32, step]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : TextureComponentSwizzleDescriptor)
    (ts : List Target) :
    walk specs32 59 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : TextureComponentSwizzleDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : TextureComponentSwizzleDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : TextureComponentSwizzleDescriptor)
    (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct TextureComponentSwizzleDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs TextureComponentSwizzleDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end TextureComponentSwizzleDescriptor

/-! ### `TextureDescriptor`: its walk -/

namespace TextureDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Each link's table comes before its own. -/
theorem chainLink64_lt_tableIndex (c : Chained) :
    (chainLink64 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink64, tableIndex, TextureBindingViewDimension.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink64_isLink (c : Chained) :
    specs64[(chainLink64 c).2]?.any
      (·.isLink (chainLink64 c).1.size) := by
  cases c <;>
    simp [
      chainLink64, Spec.isLink, TextureBindingViewDimension.tableIndex,
      TextureBindingViewDimension.getElem?_specs64,
      TextureBindingViewDimension.size_encode64,
      TextureBindingViewDimension.relocs64]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain64 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs64 (fun j size ts =>
        if j < table then walk specs64 j size ts else none)
      (cs.map chainLink64)
      ((targetsOfAll chainTargets64 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink64_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink64_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink64, chainTargets64,
      TextureBindingViewDimension.walk_encode64_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[60]? = some (80, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : TextureDescriptor) (ts : List Target) :
    element specs64 60 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, walk_words getElem?_specs64_words,
    chainTargetsOf_eq, TextureDescriptor.walk_chain64 (table := 60) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : TextureDescriptor) (ts : List Target) :
    walk specs64 60 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : TextureDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Each link's table comes before its own. -/
theorem chainLink32_lt_tableIndex (c : Chained) :
    (chainLink32 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink32, tableIndex, TextureBindingViewDimension.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink32_isLink (c : Chained) :
    specs32[(chainLink32 c).2]?.any
      (·.isLink (chainLink32 c).1.size) := by
  cases c <;>
    simp [
      chainLink32, Spec.isLink, TextureBindingViewDimension.tableIndex,
      TextureBindingViewDimension.getElem?_specs32,
      TextureBindingViewDimension.size_encode32,
      TextureBindingViewDimension.relocs32]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain32 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs32 (fun j size ts =>
        if j < table then walk specs32 j size ts else none)
      (cs.map chainLink32)
      ((targetsOfAll chainTargets32 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink32_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink32_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink32, chainTargets32,
      TextureBindingViewDimension.walk_encode32_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[60]? = some (64, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : TextureDescriptor) (ts : List Target) :
    element specs32 60 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, walk_words getElem?_specs32_words,
    chainTargetsOf_eq, TextureDescriptor.walk_chain32 (table := 60) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : TextureDescriptor) (ts : List Target) :
    walk specs32 60 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : TextureDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : TextureDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : TextureDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct TextureDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs TextureDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end TextureDescriptor

/-! ### `VertexBufferLayout`: its walk -/

namespace VertexBufferLayout

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[61]? = some (40, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : VertexBufferLayout) (ts : List Target) :
    element specs64 61 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, VertexAttribute.array64,
    VertexAttribute.walk_encodeAll64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : VertexBufferLayout) (ts : List Target) :
    walk specs64 61 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : VertexBufferLayout) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll64 (xs : Array VertexBufferLayout) (ts : List Target) :
    walk specs64 61 (encodeAll64 xs).size
      ((targetsAll64 xs).toList ++ ts) = some ts := by
  rw [targetsAll64, toList_targetsOfAll]
  exact walk_elements getElem?_specs64 (by decide) xs.toList
    (fun d => (targets64 d).toList) _
    (by rw [size_encodeAll64, Array.length_toList])
    (fun d _ => element_targets64 d) ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[61]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : VertexBufferLayout) (ts : List Target) :
    element specs32 61 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, VertexAttribute.array32,
    VertexAttribute.walk_encodeAll32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : VertexBufferLayout) (ts : List Target) :
    walk specs32 61 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : VertexBufferLayout) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll32 (xs : Array VertexBufferLayout) (ts : List Target) :
    walk specs32 61 (encodeAll32 xs).size
      ((targetsAll32 xs).toList ++ ts) = some ts := by
  rw [targetsAll32, toList_targetsOfAll]
  exact walk_elements getElem?_specs32 (by decide) xs.toList
    (fun d => (targets32 d).toList) _
    (by rw [size_encodeAll32, Array.length_toList])
    (fun d _ => element_targets32 d) ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : VertexBufferLayout) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : VertexBufferLayout) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct VertexBufferLayout :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs VertexBufferLayout :=
  ⟨size_toBytes, walk_toBytes⟩

end VertexBufferLayout

/-! ### `BindGroupDescriptor`: its walk -/

namespace BindGroupDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[62]? = some (48, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : BindGroupDescriptor) (ts : List Target) :
    element specs64 62 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, BindGroupEntry.array64,
    BindGroupEntry.walk_encodeAll64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : BindGroupDescriptor) (ts : List Target) :
    walk specs64 62 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : BindGroupDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[62]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : BindGroupDescriptor) (ts : List Target) :
    element specs32 62 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, BindGroupEntry.array32,
    BindGroupEntry.walk_encodeAll32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : BindGroupDescriptor) (ts : List Target) :
    walk specs32 62 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : BindGroupDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : BindGroupDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : BindGroupDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct BindGroupDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs BindGroupDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end BindGroupDescriptor

/-! ### `BindGroupLayoutDescriptor`: its walk -/

namespace BindGroupLayoutDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[63]? = some (40, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : BindGroupLayoutDescriptor) (ts : List Target) :
    element specs64 63 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, BindGroupLayoutEntry.array64,
    BindGroupLayoutEntry.walk_encodeAll64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : BindGroupLayoutDescriptor) (ts : List Target) :
    walk specs64 63 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : BindGroupLayoutDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[63]? = some (20, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : BindGroupLayoutDescriptor) (ts : List Target) :
    element specs32 63 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, BindGroupLayoutEntry.array32,
    BindGroupLayoutEntry.walk_encodeAll32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : BindGroupLayoutDescriptor) (ts : List Target) :
    walk specs32 63 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : BindGroupLayoutDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : BindGroupLayoutDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : BindGroupLayoutDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct BindGroupLayoutDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs BindGroupLayoutDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end BindGroupLayoutDescriptor

/-! ### `ColorTargetState`: its walk -/

namespace ColorTargetState

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[64]? = some (32, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : ColorTargetState) (ts : List Target) :
    element specs64 64 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  cases h0 : d.blend <;>
    simp [
      element, relocs64, targets64, step, optBlock, h0, BlendState.block64,
      BlendState.walk_encode64,
      walk_empty BlendState.getElem?_specs64 (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : ColorTargetState) (ts : List Target) :
    walk specs64 64 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : ColorTargetState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll64 (xs : Array ColorTargetState) (ts : List Target) :
    walk specs64 64 (encodeAll64 xs).size
      ((targetsAll64 xs).toList ++ ts) = some ts := by
  rw [targetsAll64, toList_targetsOfAll]
  exact walk_elements getElem?_specs64 (by decide) xs.toList
    (fun d => (targets64 d).toList) _
    (by rw [size_encodeAll64, Array.length_toList])
    (fun d _ => element_targets64 d) ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[64]? = some (24, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : ColorTargetState) (ts : List Target) :
    element specs32 64 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  cases h0 : d.blend <;>
    simp [
      element, relocs32, targets32, step, optBlock, h0, BlendState.block32,
      BlendState.walk_encode32,
      walk_empty BlendState.getElem?_specs32 (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : ColorTargetState) (ts : List Target) :
    walk specs32 64 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : ColorTargetState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Walking an array of them takes exactly their targets, in turn. -/
theorem walk_encodeAll32 (xs : Array ColorTargetState) (ts : List Target) :
    walk specs32 64 (encodeAll32 xs).size
      ((targetsAll32 xs).toList ++ ts) = some ts := by
  rw [targetsAll32, toList_targetsOfAll]
  exact walk_elements getElem?_specs32 (by decide) xs.toList
    (fun d => (targets32 d).toList) _
    (by rw [size_encodeAll32, Array.length_toList])
    (fun d _ => element_targets32 d) ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : ColorTargetState) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : ColorTargetState) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct ColorTargetState :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs ColorTargetState :=
  ⟨size_toBytes, walk_toBytes⟩

end ColorTargetState

/-! ### `ComputePipelineDescriptor`: its walk -/

namespace ComputePipelineDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[65]? = some (80, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : ComputePipelineDescriptor) (ts : List Target) :
    element specs64 65 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, ConstantEntry.array64,
    ConstantEntry.walk_encodeAll64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : ComputePipelineDescriptor) (ts : List Target) :
    walk specs64 65 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : ComputePipelineDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[65]? = some (40, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : ComputePipelineDescriptor) (ts : List Target) :
    element specs32 65 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, ConstantEntry.array32,
    ConstantEntry.walk_encodeAll32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : ComputePipelineDescriptor) (ts : List Target) :
    walk specs32 65 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : ComputePipelineDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : ComputePipelineDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : ComputePipelineDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct ComputePipelineDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs ComputePipelineDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end ComputePipelineDescriptor

/-! ### `DeviceDescriptor`: its walk -/

namespace DeviceDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[66]? = some (144, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : DeviceDescriptor) (ts : List Target) :
    element specs64 66 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  cases h0 : d.requiredLimits <;>
    simp [
      element, relocs64, targets64, step, closures, optBlock, h0,
      Limits.block64, Limits.walk_encode64,
      walk_empty Limits.getElem?_specs64 (by decide),
      walk_words getElem?_specs64_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : DeviceDescriptor) (ts : List Target) :
    walk specs64 66 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : DeviceDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[66]? = some (72, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : DeviceDescriptor) (ts : List Target) :
    element specs32 66 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  cases h0 : d.requiredLimits <;>
    simp [
      element, relocs32, targets32, step, closures, optBlock, h0,
      Limits.block32, Limits.walk_encode32,
      walk_empty Limits.getElem?_specs32 (by decide),
      walk_words getElem?_specs32_words]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : DeviceDescriptor) (ts : List Target) :
    walk specs32 66 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : DeviceDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : DeviceDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : DeviceDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct DeviceDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs DeviceDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end DeviceDescriptor

/-! ### `RenderPassDescriptor`: its walk -/

namespace RenderPassDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Each link's table comes before its own. -/
theorem chainLink64_lt_tableIndex (c : Chained) :
    (chainLink64 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink64, tableIndex, RenderPassMaxDrawCount.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink64_isLink (c : Chained) :
    specs64[(chainLink64 c).2]?.any
      (·.isLink (chainLink64 c).1.size) := by
  cases c <;>
    simp [
      chainLink64, Spec.isLink, RenderPassMaxDrawCount.tableIndex,
      RenderPassMaxDrawCount.getElem?_specs64,
      RenderPassMaxDrawCount.size_encode64, RenderPassMaxDrawCount.relocs64]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain64 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs64 (fun j size ts =>
        if j < table then walk specs64 j size ts else none)
      (cs.map chainLink64)
      ((targetsOfAll chainTargets64 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink64_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink64_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink64, chainTargets64,
      RenderPassMaxDrawCount.walk_encode64_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[67]? = some (64, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : RenderPassDescriptor) (ts : List Target) :
    element specs64 67 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  cases h0 : d.depthStencilAttachment <;>
  cases h1 : d.timestampWrites <;>
    simp [
      element, relocs64, targets64, step, optBlock, h0, h1,
      RenderPassDepthStencilAttachment.block64,
      RenderPassDepthStencilAttachment.walk_encode64,
      PassTimestampWrites.block64, PassTimestampWrites.walk_encode64,
      walk_empty RenderPassDepthStencilAttachment.getElem?_specs64 (by decide),
      walk_empty PassTimestampWrites.getElem?_specs64 (by decide),
      RenderPassColorAttachment.array64,
      RenderPassColorAttachment.walk_encodeAll64, chainTargetsOf_eq,
      RenderPassDescriptor.walk_chain64 (table := 67) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : RenderPassDescriptor) (ts : List Target) :
    walk specs64 67 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : RenderPassDescriptor) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Each link's table comes before its own. -/
theorem chainLink32_lt_tableIndex (c : Chained) :
    (chainLink32 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink32, tableIndex, RenderPassMaxDrawCount.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink32_isLink (c : Chained) :
    specs32[(chainLink32 c).2]?.any
      (·.isLink (chainLink32 c).1.size) := by
  cases c <;>
    simp [
      chainLink32, Spec.isLink, RenderPassMaxDrawCount.tableIndex,
      RenderPassMaxDrawCount.getElem?_specs32,
      RenderPassMaxDrawCount.size_encode32, RenderPassMaxDrawCount.relocs32]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain32 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs32 (fun j size ts =>
        if j < table then walk specs32 j size ts else none)
      (cs.map chainLink32)
      ((targetsOfAll chainTargets32 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink32_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink32_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink32, chainTargets32,
      RenderPassMaxDrawCount.walk_encode32_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[67]? = some (32, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : RenderPassDescriptor) (ts : List Target) :
    element specs32 67 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  cases h0 : d.depthStencilAttachment <;>
  cases h1 : d.timestampWrites <;>
    simp [
      element, relocs32, targets32, step, optBlock, h0, h1,
      RenderPassDepthStencilAttachment.block32,
      RenderPassDepthStencilAttachment.walk_encode32,
      PassTimestampWrites.block32, PassTimestampWrites.walk_encode32,
      walk_empty RenderPassDepthStencilAttachment.getElem?_specs32 (by decide),
      walk_empty PassTimestampWrites.getElem?_specs32 (by decide),
      RenderPassColorAttachment.array32,
      RenderPassColorAttachment.walk_encodeAll32, chainTargetsOf_eq,
      RenderPassDescriptor.walk_chain32 (table := 67) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : RenderPassDescriptor) (ts : List Target) :
    walk specs32 67 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : RenderPassDescriptor) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : RenderPassDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : RenderPassDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct RenderPassDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs RenderPassDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end RenderPassDescriptor

/-! ### `TextureViewDescriptor`: its walk -/

namespace TextureViewDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Each link's table comes before its own. -/
theorem chainLink64_lt_tableIndex (c : Chained) :
    (chainLink64 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink64, tableIndex, TextureComponentSwizzleDescriptor.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink64_isLink (c : Chained) :
    specs64[(chainLink64 c).2]?.any
      (·.isLink (chainLink64 c).1.size) := by
  cases c <;>
    simp [
      chainLink64, Spec.isLink, TextureComponentSwizzleDescriptor.tableIndex,
      TextureComponentSwizzleDescriptor.getElem?_specs64,
      TextureComponentSwizzleDescriptor.size_encode64,
      TextureComponentSwizzleDescriptor.relocs64]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain64 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs64 (fun j size ts =>
        if j < table then walk specs64 j size ts else none)
      (cs.map chainLink64)
      ((targetsOfAll chainTargets64 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink64_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink64_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink64, chainTargets64,
      TextureComponentSwizzleDescriptor.walk_encode64_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[68]? = some (64, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : TextureViewDescriptor) (ts : List Target) :
    element specs64 68 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, chainTargetsOf_eq,
    TextureViewDescriptor.walk_chain64 (table := 68) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : TextureViewDescriptor) (ts : List Target) :
    walk specs64 68 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : TextureViewDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Each link's table comes before its own. -/
theorem chainLink32_lt_tableIndex (c : Chained) :
    (chainLink32 c).2 < tableIndex := by
  cases c <;>
    simp [chainLink32, tableIndex, TextureComponentSwizzleDescriptor.tableIndex]

/-- Each link is one element of its own table, its `next` first. -/
theorem chainLink32_isLink (c : Chained) :
    specs32[(chainLink32 c).2]?.any
      (·.isLink (chainLink32 c).1.size) := by
  cases c <;>
    simp [
      chainLink32, Spec.isLink, TextureComponentSwizzleDescriptor.tableIndex,
      TextureComponentSwizzleDescriptor.getElem?_specs32,
      TextureComponentSwizzleDescriptor.size_encode32,
      TextureComponentSwizzleDescriptor.relocs32]

/--
Walking its chain, from a table not before its own, takes exactly its
links' targets, in turn.
-/
theorem walk_chain32 {table : Nat}
    (h : tableIndex ≤ table) (cs : Array Chained)
    (ts : List Target) :
    walkLinks specs32 (fun j size ts =>
        if j < table then walk specs32 j size ts else none)
      (cs.map chainLink32)
      ((targetsOfAll chainTargets32 cs).toList ++ ts) = some ts :=
  walkLinks_map _ _ chainLink32_isLink (fun c ts => by
    have := Nat.lt_of_lt_of_le (chainLink32_lt_tableIndex c) h
    cases c <;> simp_all [
      chainLink32, chainTargets32,
      TextureComponentSwizzleDescriptor.walk_encode32_tableIndex]
  ) cs ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[68]? = some (48, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : TextureViewDescriptor) (ts : List Target) :
    element specs32 68 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, chainTargetsOf_eq,
    TextureViewDescriptor.walk_chain32 (table := 68) (by decide)]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : TextureViewDescriptor) (ts : List Target) :
    walk specs32 68 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : TextureViewDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : TextureViewDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : TextureViewDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct TextureViewDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs TextureViewDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end TextureViewDescriptor

/-! ### `VertexState`: its walk -/

namespace VertexState

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[69]? = some (64, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : VertexState) (ts : List Target) :
    element specs64 69 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, ConstantEntry.array64,
    ConstantEntry.walk_encodeAll64, VertexBufferLayout.array64,
    VertexBufferLayout.walk_encodeAll64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : VertexState) (ts : List Target) :
    walk specs64 69 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : VertexState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[69]? = some (32, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : VertexState) (ts : List Target) :
    element specs32 69 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, ConstantEntry.array32,
    ConstantEntry.walk_encodeAll32, VertexBufferLayout.array32,
    VertexBufferLayout.walk_encodeAll32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : VertexState) (ts : List Target) :
    walk specs32 69 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : VertexState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : VertexState) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : VertexState) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct VertexState :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs VertexState :=
  ⟨size_toBytes, walk_toBytes⟩

end VertexState

/-! ### `FragmentState`: its walk -/

namespace FragmentState

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[70]? = some (64, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : FragmentState) (ts : List Target) :
    element specs64 70 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  simp [
    element, relocs64, targets64, step, ConstantEntry.array64,
    ConstantEntry.walk_encodeAll64, ColorTargetState.array64,
    ColorTargetState.walk_encodeAll64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : FragmentState) (ts : List Target) :
    walk specs64 70 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : FragmentState) (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[70]? = some (32, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : FragmentState) (ts : List Target) :
    element specs32 70 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  simp [
    element, relocs32, targets32, step, ConstantEntry.array32,
    ConstantEntry.walk_encodeAll32, ColorTargetState.array32,
    ColorTargetState.walk_encodeAll32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : FragmentState) (ts : List Target) :
    walk specs32 70 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : FragmentState) (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : FragmentState) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : FragmentState) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct FragmentState :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs FragmentState :=
  ⟨size_toBytes, walk_toBytes⟩

end FragmentState

/-! ### `RenderPipelineDescriptor`: its walk -/

namespace RenderPipelineDescriptor

/-- Its index finds its tables. -/
theorem getElem?_tables_tableIndex :
    tables64[tableIndex]? = some table64 ∧
      tables32[tableIndex]? = some table32 :=
  ⟨rfl, rfl⟩

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs64 :
    specs64[71]? = some (168, relocs64) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets64 (d : RenderPipelineDescriptor) (ts : List Target) :
    element specs64 71 relocs64
      ((targets64 d).toList ++ ts) = some ts := by
  cases h0 : d.depthStencil <;>
  cases h1 : d.fragment <;>
    simp [
      element, relocs64, targets64, step, optBlock, h0, h1,
      DepthStencilState.block64, DepthStencilState.walk_encode64,
      FragmentState.block64, FragmentState.walk_encode64,
      walk_empty DepthStencilState.getElem?_specs64 (by decide),
      walk_empty FragmentState.getElem?_specs64 (by decide),
      ConstantEntry.array64, ConstantEntry.walk_encodeAll64,
      VertexBufferLayout.array64, VertexBufferLayout.walk_encodeAll64]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode64 (d : RenderPipelineDescriptor) (ts : List Target) :
    walk specs64 71 (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs64 (by decide) d (fun d => (targets64 d).toList) _
    (size_encode64 d) (element_targets64 d) ts

/-- The same, at its index. -/
theorem walk_encode64_tableIndex (d : RenderPipelineDescriptor)
    (ts : List Target) :
    walk specs64 tableIndex (encode64 d).size
      ((targets64 d).toList ++ ts) = some ts :=
  walk_encode64 d ts

/-- Its index finds its table as the walk reads it. -/
theorem getElem?_specs32 :
    specs32[71]? = some (96, relocs32) :=
  rfl

/-- An element's walk takes exactly its targets. -/
theorem element_targets32 (d : RenderPipelineDescriptor) (ts : List Target) :
    element specs32 71 relocs32
      ((targets32 d).toList ++ ts) = some ts := by
  cases h0 : d.depthStencil <;>
  cases h1 : d.fragment <;>
    simp [
      element, relocs32, targets32, step, optBlock, h0, h1,
      DepthStencilState.block32, DepthStencilState.walk_encode32,
      FragmentState.block32, FragmentState.walk_encode32,
      walk_empty DepthStencilState.getElem?_specs32 (by decide),
      walk_empty FragmentState.getElem?_specs32 (by decide),
      ConstantEntry.array32, ConstantEntry.walk_encodeAll32,
      VertexBufferLayout.array32, VertexBufferLayout.walk_encodeAll32]

/-- Walking its table over its bytes takes exactly its targets. -/
theorem walk_encode32 (d : RenderPipelineDescriptor) (ts : List Target) :
    walk specs32 71 (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_one getElem?_specs32 (by decide) d (fun d => (targets32 d).toList) _
    (size_encode32 d) (element_targets32 d) ts

/-- The same, at its index. -/
theorem walk_encode32_tableIndex (d : RenderPipelineDescriptor)
    (ts : List Target) :
    walk specs32 tableIndex (encode32 d).size
      ((targets32 d).toList ++ ts) = some ts :=
  walk_encode32 d ts

/-- Its bytes are one struct, on this target. -/
theorem size_toBytes (d : RenderPipelineDescriptor) :
    ∃ relocs,
      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, h, ↓reduceIte]
    exact ⟨_, by rw [size_encode64]; exact getElem?_specs64⟩
  · simp only [currentSpecs, toBytes, h, Bool.false_eq_true, ↓reduceIte]
    exact ⟨_, by rw [size_encode32]; exact getElem?_specs32⟩

/-- Walking its table over its bytes takes its targets, on this target. -/
theorem walk_toBytes (d : RenderPipelineDescriptor) (ts : List Target) :
    walk currentSpecs tableIndex (toBytes d).size
      ((toTargets d).toList ++ ts) = some ts := by
  by_cases h : Width.is64 () = true
  · simp only [currentSpecs, toBytes, toTargets, h, ↓reduceIte]
    exact walk_encode64_tableIndex d ts
  · simp only [
      currentSpecs, toBytes, toTargets, h, Bool.false_eq_true, ↓reduceIte]
    exact walk_encode32_tableIndex d ts

/-- It is a struct C fills in. -/
instance : CStruct RenderPipelineDescriptor :=
  ⟨toBytes, toTargets, tableIndex, sizesFit⟩

/-- C fills it in as its table says, on this target. -/
instance : CStruct.Fills currentSpecs RenderPipelineDescriptor :=
  ⟨size_toBytes, walk_toBytes⟩

end RenderPipelineDescriptor

end WebGPU.Raw

end
