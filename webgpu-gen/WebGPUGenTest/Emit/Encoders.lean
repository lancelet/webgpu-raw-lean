import WebGPUGen.Emit.Encoders
import WebGPUGenTest.Literal

/-!
# Tests for the encoders

What an encoder writes for each kind of member, on both widths; how that pairs
with the layout model; and a whole struct's declarations, as printed. The
bindings build every generated encoder, with its proofs, and compare one with C.
-/

namespace WebGPUGenTest.Emit.Encoders
open WebGPUGen WebGPUGen.Lowered WebGPUGen.CLayout WebGPUGen.Emit.Encoders

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- A struct of the kind and members given, undocumented. -/
def struct (c lean : String) (kind : Common.StructKind)
    (members : List Member) (sType : Option Names := none) :
    Lowered.Struct where
  names           := ⟨c, lean⟩
  doc             := ""
  kind            := kind
  extendedStructs := #[]
  sType           := sType
  freeMembers     := false
  members         := members.toArray

/-- An undocumented member with no default, named the same on both sides. -/
def member (name : String) (value : Value) : Member :=
  ⟨⟨name, name⟩, "", value, none⟩

/-! ## Items -/

-- Each kind of member: a number by its expression, a float as itself, a
-- pointer left for C; a string its data then its length, an array its count
-- then its elements, a nested struct its own fields.
#guard
  let inner := struct "WGPUInner" "Inner" .standalone [member "n" .uint32]
  let input := struct "WGPUThing" "Thing" .extensible [
    member "label" (.string false),
    member "name" (.string true),
    member "mode" (.enum ⟨"WGPUMode", "Mode"⟩),
    member "usage" (.bitflag ⟨"WGPUUsage", "Usage"⟩),
    member "on" .bool,
    member "depth" .nullableFloat32,
    member "scale" .float64,
    member "bias" .int32,
    member "count" .usize,
    member "buffer" (.object ⟨"WGPUBuffer", "Buffer"⟩ false),
    member "items" (.array .uint32 "itemCount"),
    member "inner" (.struct inner.names)
  ]
  let expected (w : String) (size : String) : List Item := [
    .pointer,
    .pointer, .int s!"d.label.utf8ByteSize.toUInt{w}",
    .pointer, .int s!"viewLength{w} d.name",
    .int "CEnum.toC d.mode",
    .int "d.usage.bits",
    .int "wgpuBool d.on",
    .int "nanOr d.depth",
    .float "d.scale",
    .int "d.bias.toUInt32",
    .int size,
    .pointer,
    .int s!"d.items.size.toUInt{w}", .pointer,
    .int "d.inner.n"
  ]
  items [inner, input] .bits64 input "d" 3 == some (expected "64" "d.count")
    && items [inner, input] .bits32 input "d" 3
      == some (expected "32" "size32 d.count")

-- An extension starts with its chain: the next pointer, and its SType code.
#guard
  let input := struct "WGPUExtra" "Extra" .extension [member "n" .uint32]
    (sType := some ⟨"WGPUSType_Extra", "extra"⟩)
  items [input] .bits64 input "d" 2
    == some [.pointer, .int "CEnum.toC SType.extra", .int "d.n"]

-- A member that cannot be written gives no items.
#guard
  let input := struct "WGPUBad" "Bad" .standalone
    [member "f" (.unsupported "callback")]
  (items [input] .bits64 input "d" 2).isNone

-- The `size_t` members, however deep, for `sizesFit`.
#guard
  let inner := struct "WGPUInner" "Inner" .standalone [member "n" .usize]
  let input := struct "WGPUOuter" "Outer" .standalone [
    member "count" .usize,
    member "inner" (.struct inner.names),
    member "x" .uint32
  ]
  sizeMembers [inner, input] input "d" 3 == ["d.count", "d.inner.n"]

/-! ## Entries -/

-- Items paired with the layout model's scalars: a buffer descriptor, on both
-- widths, as `layouts.c` checks it against `webgpu.h`.
#guard
  let input := struct "WGPUBufferDescriptor" "BufferDescriptor" .extensible [
    member "label" (.string false),
    member "usage" (.bitflag ⟨"WGPUBufferUsage", "BufferUsage"⟩),
    member "size" .uint64,
    member "mappedAtCreation" .bool
  ]
  let offsets (w : Width) :=
    (structEntries [input] w input).map fun (size, entries) =>
      (size, entries.map (·.1))
  offsets .bits64 == some (48, [0, 8, 16, 24, 32, 40])
    && offsets .bits32 == some (40, [0, 4, 8, 16, 24, 32])

/-! ## Printing -/

-- A struct of one field: its fields, pointers, proofs, and encoders.
#guard
  let input := struct "WGPUOne" "One" .standalone [member "n" .uint32]
  let expected := dedent "
    namespace One

    /-- The scalar fields on 64-bit targets: the specification. -/
    def fields64 : List (Field One) := [
      ⟨0, .u32, fun d => (d.n).toNat⟩
    ]

    /-- The pointers on 64-bit targets, for C to fill in. -/
    def pointers64 : List Nat := []

    /-- The fields are well-formed: in order, apart, within the struct. -/
    theorem fields64_wellFormed : Fields.WellFormed .bits64 4 fields64 := by
      unfold Fields.WellFormed; decide

    /-- The pointers are apart from every field. -/
    theorem pointers64_apart :
        ∀ o ∈ pointers64, ∀ f ∈ fields64,
          f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
      decide

    /-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
    @[noinline]
    def encode64 (d : One) : ByteArray :=
      let b := Block.fresh 4
      let b := b.pokeU32 0 d.n (by decide)
      b.1

    /-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
    theorem encode64_eq (d : One) :
        encode64 d = Encode.encode .bits64 4 fields64 d := by
      simp only [
        encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
        List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

    /-- Its pointers read as 0, for C to fill in. -/
    theorem encode64_pointers (d : One) :
        ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
      fun o ho => by
        rw [encode64_eq]
        exact readLE_encode_apart d o 8 (pointers64_apart o ho)
    "
  (structEncoders [input] input).map (fun d => Emit.Doc.pretty Emit.width d)
    |>.map (fun text => text.startsWith expected) == some true

end WebGPUGenTest.Emit.Encoders
