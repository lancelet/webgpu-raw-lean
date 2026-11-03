import WebGPU.Raw.Internal.Pack

/-!
# Tests for packing

A buffer descriptor packed by its layout (as `c/generated/layouts.c` checks it
against `webgpu.h`), compared byte by byte with one C fills in (the test helper
`WebGPURawTest/c/descriptors.c`), on the width the program runs on; and every
other kind of scalar, compared with the bytes it should be. Packing writes with
the C byte writers, so these run at run time, natively
(`WebGPURawTest/Main.lean`) and on the web (the web self-test).
-/

namespace WebGPURawTest.Internal.Pack
open WebGPU.Raw.Pack

/-- `WGPUBufferDescriptor`'s layout on 64-bit targets. -/
def bufferDescriptor64 : Layout where
  size    := 48
  scalars := [
    (0, .ptr),   -- nextInChain
    (8, .ptr),   -- label.data
    (16, .size), -- label.length
    (24, .u64),  -- usage
    (32, .u64),  -- size
    (40, .u32)   -- mappedAtCreation
  ]

/-- `WGPUBufferDescriptor`'s layout on wasm32. -/
def bufferDescriptor32 : Layout where
  size    := 40
  scalars := [
    (0, .ptr),   -- nextInChain
    (4, .ptr),   -- label.data
    (8, .size),  -- label.length
    (16, .u64),  -- usage
    (24, .u64),  -- size
    (32, .u32)   -- mappedAtCreation
  ]

/-- A layout with every other kind of scalar, each aligned. -/
def mixed : Layout where
  size    := 24
  scalars := [
    (0, .u16),
    (2, .u8),
    (4, .f32),
    (8, .f64)
  ]

-- The layouts are well-formed: in order, aligned, none overlapping, within the
-- struct.
example : bufferDescriptor64.WellFormed .bits64 := by
  unfold Layout.WellFormed; decide
example : bufferDescriptor32.WellFormed .bits32 := by
  unfold Layout.WellFormed; decide
example : mixed.WellFormed .bits64 := by
  unfold Layout.WellFormed; decide

-- An overlapping layout is not, nor is one with a scalar out of alignment.
example : ¬(Layout.mk 8 [(0, .u64), (4, .u32)]).WellFormed .bits64 := by
  unfold Layout.WellFormed; decide
example : ¬(Layout.mk 8 [(2, .u32)]).WellFormed .bits64 := by
  unfold Layout.WellFormed; decide

/-- A buffer descriptor's values: no chain, the label "vertices", and so on. -/
def values : List (Value String) := [
  .ptr "chain",
  .ptr "vertices",
  .size 8,
  .u64 0x28,
  .u64 0x10000,
  .u32 1
]

/--
A buffer descriptor C fills in: no chain, a label of `labelLength` bytes at
NULL, these fields, and its padding zero.
-/
@[extern "lean_wgpu_test_buffer_descriptor"]
opaque cBufferDescriptor (usage size : UInt64) (mappedAtCreation : UInt32)
  (labelLength : USize) : ByteArray

/-- The number `n` in `width` bytes, little-endian. -/
def le (width : Nat) (n : Nat) : List UInt8 :=
  (List.range width).map fun i => (n / 256 ^ i % 256).toUInt8

/-- The bytes `mixed` should pack to. -/
def mixedBytes : List UInt8 :=
  le 2 0xBEEF ++ le 1 7 ++ [0] ++ le 4 (1.5 : Float32).toBits.toNat
    ++ le 8 (0.25 : Float).toBits.toNat ++ List.replicate 8 0

/-- The bytes of a packed struct, if it packed. -/
def bytesOf {α : Type} (packed : Except String (Packed α)) :
    Option (List UInt8) :=
  packed.toOption.map (·.bytes.data.toList)

/-- Each check: what it is, and whether it held. -/
@[noinline]
def checks (w : Width) : List (String × Bool) :=
  let layout := match w with
    | .bits64 => bufferDescriptor64
    | .bits32 => bufferDescriptor32
  let packed := pack w layout values
  let sized (n : UInt64) :=
    pack .bits32 bufferDescriptor32 (values.set 2 (.size n))
  [
    ("its pointers are slots, in order",
      packed.toOption.map (·.slots)
        == some [(0, "chain"), (w.bytes, "vertices")]),
    ("values of other kinds of scalar pack as their bytes",
      bytesOf (pack w mixed ([.u16 0xBEEF, .u8 7, .f32 1.5, .f64 0.25] :
        List (Value String))) == some mixedBytes),
    ("values not of the layout's scalars do not pack",
      (pack w layout (values.drop 1)).toOption.isNone),
    -- A `size_t` on wasm32 must fit in 32 bits, or be the largest `UInt64`,
    -- which stands for `SIZE_MAX`: as for a function's `size_t` argument.
    ("a size too large for a 32-bit size_t does not pack on wasm32",
      (sized 0x1_0000_0005).toOption.isNone),
    ("the largest UInt64 packs as SIZE_MAX on wasm32",
      (bytesOf (sized sizeMax)).map (·.drop 8 |>.take 4)
        == some [255, 255, 255, 255])
  ]

/--
The checks against C: on the width the program runs on, a buffer descriptor
packs as C lays out one with the same fields.
-/
@[noinline]
def cChecks : List (String × Bool) :=
  let w := Width.current
  let layout := match w with
    | .bits64 => bufferDescriptor64
    | .bits32 => bufferDescriptor32
  [
    ("a buffer descriptor packs as C lays it out",
      bytesOf (pack w layout values)
        == some (cBufferDescriptor 0x28 0x10000 1 8).data.toList)
  ]

end WebGPURawTest.Internal.Pack
