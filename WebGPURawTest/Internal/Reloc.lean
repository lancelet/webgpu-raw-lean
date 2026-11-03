import WebGPU.Raw
import WebGPU.Raw.Encoders
import WebGPU.Raw.Internal.Reloc
import WebGPURawTest.Internal.Encode

/-!
# Tests for relocations

Tables laid out as `serialize` lays them out, and C filling in pointers by
them (`c/reloc.c`): every kind of pointer, each optional one some and none,
blocks two deep, of two elements, of none, and with no pointers, by tables
written here; and, by the generated tables and targets, a buffer descriptor's
label, read back as WebGPU would, by its pointer and length, and a color target
state's blend state, a block of its own, and a bind group entry's optional
objects.
These run at run time, natively and on the web, and again in the checked
build, where the C checks the table, the targets and the bytes agree.
-/

namespace WebGPURawTest.Internal.Reloc
open WebGPU.Raw WebGPU.Raw.Reloc

/-! ## Tables -/

-- A table: its struct's size and its relocations' count, then each
-- relocation's offset, kind and table.
#guard (serialize 0x10203 [⟨8, .block 5⟩]).data.toList == [
  0x03, 0x02, 0x01, 0, 1, 0, 0, 0,
  8, 0, 0, 0, 4, 0, 0, 0, 5, 0, 0, 0
]

-- Each kind's code.
#guard
  let kinds := [Kind.string, .optString, .object, .optObject, .block 0, .null]
  kinds.map Kind.code == [0, 1, 2, 3, 4, 5]

/-! ## The walk

The Lean specification of the walker (`walk`) refuses what C must not meet,
and takes, of what it accepts, exactly the targets, a block's by its table. -/

/--
Tables for the walk: a struct of 8 bytes, a string (table 0); and one of 16,
a null pointer and a block of table 0 (table 1).
-/
def specs : Array Spec := #[
  (8,  [⟨0, .string⟩]),
  (16, [⟨0, .null⟩, ⟨8, .block 0⟩])
]

/-- `n` bytes of zeros. -/
def zerosOf (n : Nat) : ByteArray := ⟨Array.replicate n 0⟩

/-- They are `n` bytes. -/
theorem size_zerosOf (n : Nat) : (zerosOf n).size = n := by
  simp [zerosOf, ByteArray.size]

-- A string takes a string.
example : walk specs 0 8 [.string "a"] = some [] := by
  simp [walk, specs, step]

-- But not nothing, nor a target of another kind.
example : walk specs 0 8 [] = none := by
  simp [walk, specs, step]
example : walk specs 0 8 [.optString none] = none := by
  simp [walk, specs, step]

-- Bytes that are not whole elements are refused.
example : walk specs 0 12 [.string "a", .string "b"] = none := by
  simp [walk, specs]

-- Each element takes its own: two elements, two strings, after the block.
example :
    walk specs 1 16 [.block (zerosOf 16), .string "a", .string "b"]
      = some [] := by
  rw [walk]
  simp [specs, step, size_zerosOf]
  rw [walk]
  simp [step]

-- An empty block takes nothing.
example : walk specs 1 16 [.block (zerosOf 0)] = some [] := by
  rw [walk]
  simp [specs, step, size_zerosOf]
  rw [walk]
  simp

-- A block whose table does not come before its own is refused: so the walk
-- ends.
example :
    walk #[(8, [⟨0, .block 0⟩])] 0 8 [.block (zerosOf 8)] = none := by
  simp [walk, step]

/-! ## Filling in -/

/-- An instance as an object: the same Lean value. -/
@[extern c inline "#1"]
opaque instanceObject : Instance → Object

/--
A fresh block of zeros, from a call that differs from others by its tag, and
is never made a constant: C fills each in.
-/
@[noinline, never_extract]
def fresh (size : Nat) (_tag : String) : ByteArray :=
  Bytes.freshZeros size

/--
Every kind of pointer, each 8 bytes apart, the last to a block (table 0); its
elements, of 32 bytes, a string, an optional object, a block, and a pointer left
null (table 1);
and those blocks' elements, of 16 bytes, with no pointers (table 2).
-/
def everyKind : Array ByteArray := #[
  serialize 40 [
    ⟨0,  .string⟩,
    ⟨8,  .optString⟩,
    ⟨16, .object⟩,
    ⟨24, .optObject⟩,
    ⟨32, .block 1⟩
  ],
  serialize 32 [
    ⟨0,  .string⟩,
    ⟨8,  .optObject⟩,
    ⟨16, .block 2⟩,
    ⟨24, .null⟩
  ],
  serialize 16 []
]

/-- Fill `bytes` by `everyKind`; what C found wrong, or "". -/
@[extern "lean_wgpu_test_fill_every_kind"]
opaque fillEveryKind (bytes : ByteArray) (tables : @& Array ByteArray)
  (targets : @& Array Target) (inst : @& Instance) (some : Bool) : String

/--
Fill an encoded buffer descriptor by table `table` of `tables`; its label, as C
reads it.
-/
@[extern "lean_wgpu_test_buffer_descriptor_label"]
opaque bufferDescriptorLabel (bytes : ByteArray) (tables : @& Array ByteArray)
  (table : USize) (targets : @& Array Target) : String

/--
Fill an encoded color target state by table `table` of `tables`; what C finds
wrong with it, its blend state some if `some`, or "".
-/
@[extern "lean_wgpu_test_color_target_state"]
opaque colorTargetState (bytes : ByteArray) (tables : @& Array ByteArray)
  (table : USize) (targets : @& Array Target) (some : Bool) : String

/-- A buffer descriptor's bytes, from a call that differs by its tag. -/
@[noinline, never_extract]
def descriptorBytes (d : BufferDescriptor) (_tag : String) : ByteArray :=
  BufferDescriptor.toBytes d

/--
The label C reads back from a buffer descriptor with this one: at run time,
never a constant computed as the module loads.
-/
@[noinline, never_extract]
def labelBack (label : String) : String :=
  let d := { Encode.descriptor with label }
  bufferDescriptorLabel (descriptorBytes d label) tables
    BufferDescriptor.tableIndex.toUSize (BufferDescriptor.toTargets d)

/--
Fill an encoded bind group entry by table `table` of `tables`; what C finds
wrong with it, or "".
-/
@[extern "lean_wgpu_test_bind_group_entry"]
opaque bindGroupEntryBack (bytes : ByteArray) (tables : @& Array ByteArray)
  (table : USize) (targets : @& Array Target) : String

/-- A bind group entry, its optional objects none. -/
def bindGroupEntry : BindGroupEntry := {
  binding := 3
  offset  := 256
  size    := 1024
}

/--
What C finds wrong with `bindGroupEntry`, filled in by its generated table and
targets: at run time.
-/
@[noinline, never_extract]
def bindGroupEntryCheck (_ : Unit) : String :=
  bindGroupEntryBack (BindGroupEntry.toBytes bindGroupEntry) tables
    BindGroupEntry.tableIndex.toUSize (BindGroupEntry.toTargets bindGroupEntry)

/-- A color target state, with a blend state if `blend`. -/
def colorTarget (blend : Bool) : ColorTargetState := {
  format := .rgba8Unorm
  blend  := if blend then some {
    color := {
      operation := .subtract
      srcFactor := .srcAlpha
      dstFactor := .oneMinusSrcAlpha
    }
    alpha := {
      operation := .max
      srcFactor := .one
      dstFactor := .zero
    }
  } else none
}

/--
What C finds wrong with a color target state, with a blend state if `blend`,
filled in by its generated table and targets: at run time.
-/
@[noinline, never_extract]
def colorTargetBack (blend : Bool) : String :=
  let d := colorTarget blend
  colorTargetState (ColorTargetState.toBytes d) tables
    ColorTargetState.tableIndex.toUSize (ColorTargetState.toTargets d) blend

/-- Each check, on the instance `inst`: what it is, and whether it held. -/
@[noinline]
def checks (inst : Instance) : List (String × String) :=
  let object := instanceObject inst
  [
    ("every kind of pointer, nested two deep, optional ones some",
      fillEveryKind (fresh 40 "some") everyKind #[
        .string "a string",
        .optString (some "an optional string"),
        .object object,
        .optObject (some object),
        .block (fresh 64 "elements"),
        .string "the first element's",
        .optObject (some object),
        .block (fresh 16 "the first element's"),
        .string "the second element's",
        .optObject none,
        .block .empty
      ] inst true),
    ("every kind of pointer, each optional one none, the block empty",
      fillEveryKind (fresh 40 "none") everyKind #[
        .string "a string",
        .optString none,
        .object object,
        .optObject none,
        .block .empty
      ] inst false),
    ("a buffer descriptor's label, read back",
      if labelBack "vertices" == "vertices" then ""
      else "it is not the same"),
    ("an empty label, read back",
      if labelBack "" == "" then "" else "it is not empty"),
    ("a label with a NUL in it, read back whole",
      if labelBack "a\x00b" == "a\x00b" then "" else "it is cut short"),
    ("a color target state, its blend state a block of its own",
      colorTargetBack true),
    ("a color target state with no blend state", colorTargetBack false),
    ("a bind group entry, its optional objects none", bindGroupEntryCheck ())
  ]

end WebGPURawTest.Internal.Reloc
