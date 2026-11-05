import WebGPUGen.Lowered
import WebGPUGen.CLayout

/-!
# A struct's fields in C

The fields a struct of the lowered model has in `webgpu.h`, each named as C
names it, with its C type for the layout model (`CLayout`). Most members are one
field each; the rest of C's fields follow from upstream's rules:

- an extensible struct starts with `nextInChain`, a pointer, and an extension
  with `chain`, a `WGPUChainedStruct` (a pointer and an `SType`);
- an array is two fields, its count (`size_t`) and then a pointer to it;
- a string is a `WGPUStringView` by value: a pointer and a `size_t`.

None if a member cannot be passed, so a struct that is not bound has no fields
here.
-/

namespace WebGPUGen.Lowered
open WebGPUGen.CLayout

/-- `WGPUStringView`'s fields: its data and its length. -/
def stringViewFields : List (String × CType) :=
  [("data", .scalar .ptr), ("length", .scalar .size)]

/-- `WGPUStringView`. -/
def stringViewType : CType :=
  .struct (stringViewFields.map (·.2))

/-- `WGPUChainedStruct`'s fields: the next struct in the chain, and its type. -/
def chainedStructFields : List (String × CType) :=
  [("next", .scalar .ptr), ("sType", .scalar .u32)]

/-- `WGPUChainedStruct`. -/
def chainedStructType : CType :=
  .struct (chainedStructFields.map (·.2))

/-- The fields that start a struct of this kind, by how it joins chains. -/
def chainFields : Common.StructKind → List (String × CType)
  | .extensible | .extensibleCallbackArg => [("nextInChain", .scalar .ptr)]
  | .extension                           => [("chain", chainedStructType)]
  | .standalone                          => []

/--
A struct's fields in C, each with its C name, found among `structs` by its C
name; none if it is not there, or a member cannot be passed. `fuel` bounds the
nesting of structs by value: structs do not contain themselves.
-/
def cFields (structs : List Struct) (s : Struct) :
    Nat → Option (List (String × CType))
  | 0 => none
  | fuel + 1 => do
    let members ← s.members.toList.mapM fun m =>
      match m.value with
      -- C gives an array as its count, then a pointer to its elements.
      | .array element count =>
        if element.unsupported?.isSome then none
        else some [(count, .scalar .size), (m.names.c, .scalar .ptr)]
      | v => (cType fuel v).map fun t => [(m.names.c, t)]
    pure (chainFields s.kind ++ members.flatten)
where
  /-- The C type of a value, as one field. -/
  cType (fuel : Nat) : Value → Option CType
    | .bool                          => some (.scalar .u32)
    | .uint16 | .int16               => some (.scalar .u16)
    | .uint32 | .int32               => some (.scalar .u32)
    | .uint64                        => some (.scalar .u64)
    | .usize                         => some (.scalar .size)
    | .float32 | .nullableFloat32    => some (.scalar .f32)
    | .float64                       => some (.scalar .f64)
    | .enum _                        => some (.scalar .u32)
    | .bitflag _                     => some (.scalar .u64)
    | .object .. | .structPointer .. => some (.scalar .ptr)
    | .string _                      => some stringViewType
    | .struct names => do
      let nested ← structs.find? (·.names.c == names.c)
      let fields ← cFields structs nested fuel
      pure (.struct (fields.map (·.2)))
    -- A callback's info: its chain, its mode if it has one, its function
    -- pointer, and its two userdata pointers. The function pointer and the
    -- second userdata, an ordinal, are written as integers: `size`, which is
    -- a pointer's size and alignment on both widths.
    | .callbackInfo _ hasMode _      => some (.struct ([.scalar .ptr]
      ++ (if hasMode then [.scalar .u32] else [])
      ++ [.scalar .size, .scalar .ptr, .scalar .size]))
    | .array .. | .future | .lentObject _ | .unsupported _ => none

/-- A struct's fields in C, among `structs`. -/
def Struct.cFields (structs : List Struct) (s : Struct) :
    Option (List (String × CType)) :=
  Lowered.cFields structs s (structs.length + 1)

end WebGPUGen.Lowered
