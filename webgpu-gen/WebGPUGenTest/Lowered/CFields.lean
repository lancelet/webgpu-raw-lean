import WebGPUGen.Lowered.CFields

/-!
# Tests for a struct's fields in C

Structs of the lowered model, with the fields `webgpu.h` gives them.
-/

namespace WebGPUGenTest.Lowered.CFields
open WebGPUGen WebGPUGen.Lowered WebGPUGen.CLayout

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- A struct of the kind and members given, undocumented. -/
def struct (c : String) (kind : Common.StructKind) (members : List Member) :
    Lowered.Struct where
  names           := ⟨c, c⟩
  doc             := ""
  kind            := kind
  extendedStructs := #[]
  sType           := none
  freeMembers     := false
  members         := members.toArray

/-- An undocumented member with no default, named the same on both sides. -/
def member (name : String) (value : Value) : Member :=
  ⟨⟨name, name⟩, "", value, none⟩

/-- A field's C name and type, to compare. -/
abbrev Field := String × CType

/-! ## Fields -/

-- An extensible struct starts with its chain pointer; a string is a string
-- view, an array its count and then a pointer; enums, flags and booleans are
-- their scalars.
#guard
  let input := struct "WGPUThing" .extensible [
    member "label" (.string false),
    member "mode" (.enum ⟨"WGPUMode", "Mode"⟩),
    member "usage" (.bitflag ⟨"WGPUUsage", "Usage"⟩),
    member "items" (.array .uint32 "itemCount"),
    member "mapped" .bool
  ]
  let expected : List Field := [
    ("nextInChain", .scalar .ptr),
    ("label", stringViewType),
    ("mode", .scalar .u32),
    ("usage", .scalar .u64),
    ("itemCount", .scalar .size),
    ("items", .scalar .ptr),
    ("mapped", .scalar .u32)
  ]
  (input.cFields [input]).map (·.map (·.1)) == some (expected.map (·.1))
    && (input.cFields [input]).map (·.map (·.2.size .bits64))
      == some (expected.map (·.2.size .bits64))

-- An extension starts with its chained struct; a struct by value is its own
-- fields, nested.
#guard
  let inner := struct "WGPUInner" .standalone [member "n" .uint32]
  let input := struct "WGPUExtra" .extension [
    member "inner" (.struct inner.names),
    member "depth" .float64
  ]
  let fields := input.cFields [inner, input]
  fields.map (·.map (·.1)) == some ["chain", "inner", "depth"]
    && fields.map (·.map (·.2.size .bits64)) == some [16, 4, 8]
    && fields.map (·.map (·.2.size .bits32)) == some [8, 4, 8]

-- A standalone struct has no chain field; signed integers and optional
-- pointers are their scalars.
#guard
  let other : Names := ⟨"WGPUOther", "Other"⟩
  let input := struct "WGPUPlain" .standalone [
    member "bias" .int32,
    member "small" .int16,
    member "next" (.structPointer other true)
  ]
  (input.cFields [input]).map (·.map (·.1)) == some ["bias", "small", "next"]
    && (input.cFields [input]).map (·.map (·.2.size .bits32)) == some [4, 2, 4]

-- No fields for a struct with a member that cannot be passed, or one that
-- holds a struct not given.
#guard
  let bad := struct "WGPUBad" .standalone [member "f" (.unsupported "callback")]
  let holder := struct "WGPUHolder" .standalone [
    member "missing" (.struct ⟨"WGPUMissing", "Missing"⟩)
  ]
  (bad.cFields [bad]).isNone && (holder.cFields [holder]).isNone

end WebGPUGenTest.Lowered.CFields
