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
state's blend state, a block of its own, a bind group entry's optional
objects, and a shader module's chain of two WGSL sources.
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
  let kinds :=
    [Kind.string, .optString, .object, .optObject, .block 0, .chain, .null]
  kinds.map Kind.code == [0, 1, 2, 3, 4, 5, 6]

/-! ## The walk

The Lean specification of the walker (`walk`) refuses what C must not meet,
and takes, of what it accepts, exactly the targets, a block's by its table. -/

/--
Tables for the walk: a struct of 8 bytes, a string (table 0); and one of 16,
a null pointer and a block of table 0 (table 1).
-/
def walkSpecs : Array Spec := #[
  (8,  [⟨0, .string⟩]),
  (16, [⟨0, .null⟩, ⟨8, .block 0⟩])
]

/-- `n` bytes of zeros. -/
def zerosOf (n : Nat) : ByteArray := ⟨Array.replicate n 0⟩

/-- They are `n` bytes. -/
theorem size_zerosOf (n : Nat) : (zerosOf n).size = n := by
  simp [zerosOf, ByteArray.size]

-- A string takes a string.
example : walk walkSpecs 0 8 [.string "a"] = some [] := by
  simp [walk, walkSpecs, step]

-- But not nothing, nor a target of another kind.
example : walk walkSpecs 0 8 [] = none := by
  simp [walk, walkSpecs, step]
example : walk walkSpecs 0 8 [.optString none] = none := by
  simp [walk, walkSpecs, step]

-- Bytes that are not whole elements are refused.
example : walk walkSpecs 0 12 [.string "a", .string "b"] = none := by
  simp [walk, walkSpecs]

-- Each element takes its own: two elements, two strings, after the block.
example :
    walk walkSpecs 1 16 [.block (zerosOf 16), .string "a", .string "b"]
      = some [] := by
  rw [walk]
  simp [walkSpecs, step, size_zerosOf]
  rw [walk]
  simp [step]

-- An empty block takes nothing.
example : walk walkSpecs 1 16 [.block (zerosOf 0)] = some [] := by
  rw [walk]
  simp [walkSpecs, step, size_zerosOf]
  rw [walk]
  simp

-- A block whose table does not come before its own is refused: so the walk
-- ends.
example :
    walk #[(8, [⟨0, .block 0⟩])] 0 8 [.block (zerosOf 8)] = none := by
  simp [walk, step]

/--
Tables for chains: an extension of 16 bytes, its `next` null, then a string
(table 0); a struct of 8 bytes, a string first (table 1), which cannot be
linked; and a struct of 8 bytes, its chain (table 2).
-/
def linkSpecs : Array Spec := #[
  (16, [⟨0, .null⟩, ⟨8, .string⟩]),
  (8,  [⟨0, .string⟩]),
  (8,  [⟨0, .chain⟩])
]

-- A chain takes each link's targets, by its own table, after it.
example :
    walk linkSpecs 2 8
      [.chain #[(zerosOf 16, 0), (zerosOf 16, 0)], .string "a", .string "b"]
      = some [] := by
  rw [walk]
  simp [linkSpecs, step, walkLinks, Spec.isLink, size_zerosOf]
  rw [walk]
  simp [step]
  rw [walk]
  simp [step]

-- C writes each link's `next`, so a link must be one element of its own
-- table, whose first pointer is its `next`: not empty, nor two, nor of a
-- table whose first pointer is another.
example : walk linkSpecs 2 8 [.chain #[(zerosOf 0, 0)]] = none := by
  rw [walk]
  simp [linkSpecs, step, walkLinks, Spec.isLink, size_zerosOf]
example :
    walk linkSpecs 2 8 [.chain #[(zerosOf 32, 0)], .string "a", .string "b"]
      = none := by
  rw [walk]
  simp [linkSpecs, step, walkLinks, Spec.isLink, size_zerosOf]
example :
    walk linkSpecs 2 8 [.chain #[(zerosOf 8, 1)], .string "a"] = none := by
  rw [walk]
  simp [linkSpecs, step, walkLinks, Spec.isLink, size_zerosOf]

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
  bufferDescriptorLabel (descriptorBytes d label) currentTables
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
  bindGroupEntryBack (BindGroupEntry.toBytes bindGroupEntry) currentTables
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
  colorTargetState (ColorTargetState.toBytes d) currentTables
    ColorTargetState.tableIndex.toUSize (ColorTargetState.toTargets d) blend

/-! ## Arrays -/

/--
Fill an encoded instance descriptor by table `table` of `tables`; what C finds
wrong with it, its features and limits there if `full`, or "".
-/
@[extern "lean_wgpu_test_instance_descriptor"]
opaque instanceDescriptorBack (bytes : ByteArray)
  (tables : @& Array ByteArray) (table : USize) (targets : @& Array Target)
  (full : Bool) : String

/-- An instance descriptor: two features and limits if `full`, else none. -/
def instanceDescriptor (full : Bool) : InstanceDescriptor :=
  if full then {
    requiredFeatures := #[.shaderSourceSPIRV, .timedWaitAny]
    requiredLimits   := some { timedWaitAnyMaxCount := 7 }
  } else {}

/--
What C finds wrong with `instanceDescriptor full`, filled in by its generated
table and targets: at run time.
-/
@[noinline, never_extract]
def instanceDescriptorCheck (full : Bool) : String :=
  let d := instanceDescriptor full
  instanceDescriptorBack (InstanceDescriptor.toBytes d) currentTables
    InstanceDescriptor.tableIndex.toUSize (InstanceDescriptor.toTargets d) full

/--
Fill an encoded bind group layout descriptor by table `table` of `tables`;
what C finds wrong with it, or "".
-/
@[extern "lean_wgpu_test_bind_group_layout"]
opaque bindGroupLayoutBack (bytes : ByteArray) (tables : @& Array ByteArray)
  (table : USize) (targets : @& Array Target) : String

/-- A bind group layout descriptor: a label, and two entries. -/
def bindGroupLayout : BindGroupLayoutDescriptor := {
  label   := "layout"
  entries := #[
    {
      binding    := 0
      visibility := .fragment
    },
    {
      binding          := 5
      visibility       := .vertex
      bindingArraySize := 3
    }
  ]
}

/--
A struct C fills in, by its class (`CStruct`), as a shim takes it: if each
of its `size_t`s fits, its bytes, the tables, its table's index and its
targets, given to `back`.
-/
@[inline]
def viaClass {T : Type} [CStruct T] [CStruct.Fills currentSpecs T] (d : T)
    (back : ByteArray → Array ByteArray → USize → Array Target → String) :
    String :=
  if !CStruct.sizesFit d then "a size_t that does not fit" else
  back (CStruct.toBytes d) currentTables
    (CStruct.tableIndex T).toUSize
    (CStruct.toTargets d)

/--
What C finds wrong with `bindGroupLayout`, filled in by its generated table
and targets: at run time.
-/
@[noinline, never_extract]
def bindGroupLayoutCheck (_ : Unit) : String :=
  viaClass bindGroupLayout bindGroupLayoutBack

/--
Fill an encoded bind group layout descriptor with no entries by table `table`
of `tables`; what C finds wrong with it, or "".
-/
@[extern "lean_wgpu_test_empty_bind_group_layout"]
opaque emptyBindGroupLayoutBack (bytes : ByteArray)
  (tables : @& Array ByteArray) (table : USize) (targets : @& Array Target) :
  String

/-- What C finds wrong with a bind group layout with no entries: at run time. -/
@[noinline, never_extract]
def emptyBindGroupLayoutCheck (_ : Unit) : String :=
  let d : BindGroupLayoutDescriptor := {}
  emptyBindGroupLayoutBack (BindGroupLayoutDescriptor.toBytes d) currentTables
    BindGroupLayoutDescriptor.tableIndex.toUSize
    (BindGroupLayoutDescriptor.toTargets d)

/--
Fill an encoded pipeline layout descriptor with no bind group layouts by table
`table` of `tables`; what C finds wrong with it, or "".
-/
@[extern "lean_wgpu_test_pipeline_layout"]
opaque pipelineLayoutBack (bytes : ByteArray) (tables : @& Array ByteArray)
  (table : USize) (targets : @& Array Target) : String

/--
What C finds wrong with a pipeline layout descriptor with no bind group
layouts, its empty array of objects by the generated table: at run time.
-/
@[noinline, never_extract]
def pipelineLayoutCheck (_ : Unit) : String :=
  let d : PipelineLayoutDescriptor := { immediateSize := 16 }
  pipelineLayoutBack (PipelineLayoutDescriptor.toBytes d) currentTables
    PipelineLayoutDescriptor.tableIndex.toUSize
    (PipelineLayoutDescriptor.toTargets d)

/--
Fill an encoded vertex buffer layout by table `table` of `tables`; what C finds
wrong with it, or "".
-/
@[extern "lean_wgpu_test_vertex_buffer_layout"]
opaque vertexBufferBack (bytes : ByteArray) (tables : @& Array ByteArray)
  (table : USize) (targets : @& Array Target) : String

/-- A vertex buffer layout: two attributes, an array of structs. -/
def vertexBuffer : VertexBufferLayout := {
  stepMode    := .vertex
  arrayStride := 24
  attributes  := #[
    {
      format         := .float32x2
      offset         := 0
      shaderLocation := 0
    },
    {
      format         := .float32x4
      offset         := 8
      shaderLocation := 1
    }
  ]
}

/--
What C finds wrong with `vertexBuffer`, filled in by its generated table and
targets: at run time.
-/
@[noinline, never_extract]
def vertexBufferCheck (_ : Unit) : String :=
  vertexBufferBack (VertexBufferLayout.toBytes vertexBuffer) currentTables
    VertexBufferLayout.tableIndex.toUSize
    (VertexBufferLayout.toTargets vertexBuffer)

/-- A pointer's bytes on this target. -/
def ptrBytes : Nat := if System.Platform.numBits = 64 then 8 else 4

/--
An array of objects (table 0, the shared one), and a struct of one pointer, to
it (table 1).
-/
def objectTables : Array ByteArray := #[
  serialize ptrBytes [⟨0, .object⟩],
  serialize 8 [⟨0, .block 0⟩]
]

/-- Fill `bytes` by `objectTables`; what C finds wrong, or "". -/
@[extern "lean_wgpu_test_fill_objects"]
opaque fillObjects (bytes : ByteArray) (tables : @& Array ByteArray)
  (targets : @& Array Target) (inst : @& Instance) : String

/-- An array of two objects, each `inst`, filled in: what C finds wrong. -/
@[noinline, never_extract]
def objectsCheck (inst : Instance) : String :=
  let insts := #[inst, inst]
  fillObjects (fresh 8 "an array of objects") objectTables
    (#[.block (objectsBlock ptrBytes insts)]
      ++ objectsOf instanceObject insts) inst

/-! ## Chains -/

/--
Fill an encoded shader module descriptor by table `table` of `tables`; what C
finds wrong with its chain, two sources if `chained`, else none; or "".
-/
@[extern "lean_wgpu_test_shader_module"]
opaque shaderModuleBack (bytes : ByteArray) (tables : @& Array ByteArray)
  (table : USize) (targets : @& Array Target) (chained : Bool) : String

/-- A shader module descriptor: two WGSL sources chained, if `chained`. -/
def shaderModule (chained : Bool) : ShaderModuleDescriptor := {
  label := "module"
  chain := if chained then #[
    .shaderSourceWGSL { code := "first" },
    .shaderSourceWGSL { code := "second" }
  ] else #[]
}

/--
What C finds wrong with `shaderModule chained`, filled in by its generated
table and targets: at run time.
-/
@[noinline, never_extract]
def shaderModuleCheck (chained : Bool) : String :=
  let d := shaderModule chained
  shaderModuleBack (ShaderModuleDescriptor.toBytes d) currentTables
    ShaderModuleDescriptor.tableIndex.toUSize
    (ShaderModuleDescriptor.toTargets d) chained

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
    ("a bind group entry, its optional objects none", bindGroupEntryCheck ()),
    ("an instance descriptor, its features an array of enums, its limits a "
      ++ "block", instanceDescriptorCheck true),
    ("an instance descriptor with no features, nor limits",
      instanceDescriptorCheck false),
    ("a bind group layout descriptor, its entries an array of structs",
      bindGroupLayoutCheck ()),
    ("a bind group layout descriptor with no entries, a null pointer",
      emptyBindGroupLayoutCheck ()),
    ("a pipeline layout descriptor, its objects an empty array",
      pipelineLayoutCheck ()),
    ("a vertex buffer layout, its attributes an array of structs",
      vertexBufferCheck ()),
    ("an array of objects, a block of handles", objectsCheck inst),
    ("a chain of two extensions, each linked to the next",
      shaderModuleCheck true),
    ("an empty chain, a null pointer", shaderModuleCheck false)
  ]

end WebGPURawTest.Internal.Reloc
