import WebGPU.Raw
import WebGPU.Raw.Encoders
import WebGPU.Raw.Internal.Reloc
import WebGPURawTest.Internal.Encode

/-!
# Tests for relocations

Tables laid out as `serialize` lays them out, and C filling in pointers by
them (`c/reloc.c`): every kind of pointer, each optional one some and none,
blocks two deep, of two elements, of none, and with no pointers; and a buffer
descriptor's label, read back as WebGPU would, by its pointer and length.
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
#guard [Kind.string, .optString, .object, .optObject, .block 0].map Kind.code
  == [0, 1, 2, 3, 4]

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
elements, of 24 bytes, a string, an optional object and a block (table 1);
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
  serialize 24 [
    ⟨0,  .string⟩,
    ⟨8,  .optObject⟩,
    ⟨16, .block 2⟩
  ],
  serialize 16 []
]

/-- Fill `bytes` by `everyKind`; what C found wrong, or "". -/
@[extern "lean_wgpu_test_fill_every_kind"]
opaque fillEveryKind (bytes : ByteArray) (tables : @& Array ByteArray)
  (targets : @& Array Target) (inst : @& Instance) (some : Bool) : String

/-- Fill an encoded buffer descriptor by `tables`; its label, as C reads it. -/
@[extern "lean_wgpu_test_buffer_descriptor_label"]
opaque bufferDescriptorLabel (bytes : ByteArray) (tables : @& Array ByteArray)
  (targets : @& Array Target) : String

/-- A buffer descriptor's one relocation, its label's data, on each width. -/
def bufferDescriptor : Array ByteArray :=
  if System.Platform.numBits = 64 then #[serialize 48 [⟨8, .string⟩]]
  else #[serialize 40 [⟨4, .string⟩]]

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
  bufferDescriptorLabel
    (descriptorBytes { Encode.descriptor with label } label)
    bufferDescriptor #[.string label]

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
        .block (fresh 48 "elements"),
        .string "the first element's",
        .optObject (some object),
        .block (fresh 16 "the first element's"),
        .string "the second element's",
        .optObject none,
        .block (fresh 0 "the second element's")
      ] inst true),
    ("every kind of pointer, each optional one none, the block empty",
      fillEveryKind (fresh 40 "none") everyKind #[
        .string "a string",
        .optString none,
        .object object,
        .optObject none,
        .block (fresh 0 "no elements")
      ] inst false),
    ("a buffer descriptor's label, read back",
      if labelBack "vertices" == "vertices" then ""
      else "it is not the same"),
    ("an empty label, read back",
      if labelBack "" == "" then "" else "it is not empty"),
    ("a label with a NUL in it, read back whole",
      if labelBack "a\x00b" == "a\x00b" then "" else "it is cut short")
  ]

end WebGPURawTest.Internal.Reloc
