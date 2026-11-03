import WebGPUGen.CLayout

/-!
# Tests for C layouts

Layouts of structs of `webgpu.h`, compared with what the C compiler gives:
`offsetof` and `sizeof` from `cc` on x86-64, and from `clang --target=wasm32`.
-/

namespace WebGPUGenTest.CLayout
open WebGPUGen.CLayout

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- `WGPUStringView`: a pointer and a `size_t`. -/
def stringView : CType := .struct [.scalar .ptr, .scalar .size]

/-- `WGPUColor`: four doubles. -/
def color : CType :=
  .struct [.scalar .f64, .scalar .f64, .scalar .f64, .scalar .f64]

/-- `WGPUBufferDescriptor`'s fields. -/
def bufferDescriptor : List CType := [
  .scalar .ptr,  -- nextInChain
  stringView,    -- label
  .scalar .u64,  -- usage
  .scalar .u64,  -- size
  .scalar .u32   -- mappedAtCreation
]

/-- `WGPURenderPassColorAttachment`'s fields. -/
def colorAttachment : List CType := [
  .scalar .ptr,  -- nextInChain
  .scalar .ptr,  -- view
  .scalar .u32,  -- depthSlice
  .scalar .ptr,  -- resolveTarget
  .scalar .u32,  -- loadOp
  .scalar .u32,  -- storeOp
  color          -- clearValue
]

/-! ## Structs -/

-- A buffer descriptor: a 64-bit field after a string view is aligned to 8 on
-- both widths, so wasm32 pads after the 12 bytes before it.
#guard
  offsets .bits64 bufferDescriptor == [0, 8, 24, 32, 40]
    && (CType.struct bufferDescriptor).size .bits64 == 48
    && (CType.struct bufferDescriptor).align .bits64 == 8
    && offsets .bits32 bufferDescriptor == [0, 4, 16, 24, 32]
    && (CType.struct bufferDescriptor).size .bits32 == 40
    && (CType.struct bufferDescriptor).align .bits32 == 8

-- A colour attachment: a struct of doubles by value, aligned to 8.
#guard
  offsets .bits64 colorAttachment == [0, 8, 16, 24, 32, 36, 40]
    && (CType.struct colorAttachment).size .bits64 == 72
    && offsets .bits32 colorAttachment == [0, 4, 8, 12, 16, 20, 24]
    && (CType.struct colorAttachment).size .bits32 == 56
    && color.size .bits64 == 32

-- A struct ends padded to its alignment: a pointer then a `u32` is 16 bytes on
-- 64-bit, and 8 on wasm32.
#guard
  let input := CType.struct [.scalar .ptr, .scalar .u32]
  input.size .bits64 == 16 && input.size .bits32 == 8

-- A struct with no fields has size 0 and alignment 1: a property of the model,
-- not of C, which has no empty structs; `webgpu.h` has none.
#guard
  (CType.struct []).size .bits64 == 0 && (CType.struct []).align .bits64 == 1

-- A sampler descriptor: a 2-byte field last, so the struct is padded after it
-- to its alignment.
#guard
  let fields := [
    .scalar .ptr,  -- nextInChain
    stringView,    -- label
    .scalar .u32,  -- addressModeU
    .scalar .u32,  -- addressModeV
    .scalar .u32,  -- addressModeW
    .scalar .u32,  -- magFilter
    .scalar .u32,  -- minFilter
    .scalar .u32,  -- mipmapFilter
    .scalar .f32,  -- lodMinClamp
    .scalar .f32,  -- lodMaxClamp
    .scalar .u32,  -- compare
    .scalar .u16   -- maxAnisotropy
  ]
  offsets .bits64 fields == [0, 8, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60]
    && (CType.struct fields).size .bits64 == 64
    && offsets .bits32 fields == [0, 4, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48]
    && (CType.struct fields).size .bits32 == 52

-- A callback info: a function pointer and two userdata pointers.
#guard
  let fields := [
    .scalar .ptr,  -- nextInChain
    .scalar .u32,  -- mode
    .scalar .ptr,  -- callback
    .scalar .ptr,  -- userdata1
    .scalar .ptr   -- userdata2
  ]
  offsets .bits64 fields == [0, 8, 16, 24, 32]
    && (CType.struct fields).size .bits64 == 40
    && offsets .bits32 fields == [0, 4, 8, 12, 16]
    && (CType.struct fields).size .bits32 == 20

/-! ## Scalars, however nested -/

-- A buffer descriptor's scalars: the label's two, then the rest, each at its
-- offset from the base.
#guard
  (CType.struct bufferDescriptor).flatten .bits64 0 == [
    (0, .ptr),
    (8, .ptr),
    (16, .size),
    (24, .u64),
    (32, .u64),
    (40, .u32)
  ]

-- A struct nested by value: its scalars at its offset, on wasm32.
#guard
  ((CType.struct colorAttachment).flatten .bits32 0).drop 6 == [
    (24, .f64),
    (32, .f64),
    (40, .f64),
    (48, .f64)
  ]

-- Nested at an offset, scalars are offset too.
#guard
  stringView.flatten .bits32 100 == [(100, .ptr), (104, .size)]

end WebGPUGenTest.CLayout
