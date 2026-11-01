import WebGPUGen.Parsed.Codec
import WebGPUGenTest.Literal
import WebGPUGenTest.Check

/-!
# Tests for decoding structs and their members
-/

namespace WebGPUGenTest.Parsed.Structs
open WebGPUGen.Decode WebGPUGen.Common WebGPUGen.Parsed WebGPUGen

/-! ## Members -/

-- Only the required fields: the optional ones take their defaults.
#guard
  let input := dedent "
    name: label
    doc: A label.
    type: string_with_default_empty
    "
  let expected : Parameter String := {
    name                := "label",
    doc                 := "A label.",
    type                := .primitive (.scalar .stringWithDefaultEmpty),
    passedWithOwnership := none,
    pointer             := none,
    optional            := false,
    default             := none
  }
  decodesTo (Parameter.codec Codec.string).decode input expected

-- Every field, as a member or argument may give them.
#guard
  let input := dedent "
    name: entries
    doc: The entries.
    type: array<struct.bind_group_entry>
    passed_with_ownership: false
    pointer: immutable
    optional: true
    default: zero
    "
  let expected : Parameter String := {
    name                := "entries",
    doc                 := "The entries.",
    type                := .refArray .struct "bind_group_entry",
    passedWithOwnership := some false,
    pointer             := some .immutable,
    optional            := true,
    default             := some .zero
  }
  decodesTo (Parameter.codec Codec.string).decode input expected

-- A mutable pointer passed with ownership, as callback arguments may be.
#guard
  let input := dedent "
    name: data
    doc: x
    type: c_void
    pointer: mutable
    passed_with_ownership: true
    "
  let expected : Parameter String := {
    name                := "data",
    doc                 := "x",
    type                := .primitive (.scalar .cVoid),
    passedWithOwnership := some true,
    pointer             := some .mutable,
    optional            := false,
    default             := none
  }
  decodesTo (Parameter.codec Codec.string).decode input expected

#guard
  let input := dedent "
    name: data
    doc: x
    type: c_void
    pointer: const
    "
  decodeFails (Parameter.codec Codec.string).decode input "pointer: unknown pointer \"const\""

/-! ## Structs -/

-- An extension, as `compatibility_mode_limits` is.
#guard
  let input := dedent "
    name: compatibility_mode_limits
    doc: Extra limits.
    type: extension
    extends:
      - limits
    members:
      - name: max_storage_buffers_in_vertex_stage
        doc: x
        type: uint32
        default: constant.limit_u32_undefined
    "
  let expected : Struct := {
    name            := "compatibility_mode_limits",
    ns              := none,
    doc             := "Extra limits.",
    kind            := .extension,
    extendedStructs := #["limits"],
    freeMembers     := false,
    members         := #[
      {
        name                := "max_storage_buffers_in_vertex_stage",
        doc                 := "x",
        type                := .primitive (.scalar .uint32),
        passedWithOwnership := none,
        pointer             := none,
        optional            := false,
        default             := some (.constant "limit_u32_undefined")
      }
    ]
  }
  decodesTo Struct.codec.decode input expected

-- `free_members`, and a struct with no members listed.
#guard
  let input := dedent "
    name: adapter_info
    doc: x
    type: extensible
    free_members: true
    "
  let expected : Struct := {
    name            := "adapter_info",
    ns              := none,
    doc             := "x",
    kind            := .extensible,
    extendedStructs := #[],
    freeMembers     := true,
    members         := #[]
  }
  decodesTo Struct.codec.decode input expected

-- Every struct kind is accepted.
#guard
  let input := dedent "
    - name: a
      doc: x
      type: extensible
    - name: b
      doc: x
      type: extensible_callback_arg
    - name: c
      doc: x
      type: extension
    - name: d
      doc: x
      type: standalone
    "
  let expected : Array StructKind := #[
    .extensible,
    .extensibleCallbackArg,
    .extension,
    .standalone
  ]
  match decodeText (Codec.seq Struct.codec).decode input with
  | .ok structs => structs.map (·.kind) == expected
  | .error _ => false

#guard
  let input := dedent "
    name: s
    doc: x
    type: chained
    "
  decodeFails Struct.codec.decode input "type: unknown struct type \"chained\""

-- `extends` holds struct names.
#guard
  let input := dedent "
    name: s
    doc: x
    type: extension
    extends:
      - struct.limits
    "
  decodeFails Struct.codec.decode input "extends[0]: invalid name \"struct.limits\""

-- Errors in members name the member.
#guard
  let input := dedent "
    name: s
    doc: x
    type: standalone
    members:
      - name: a
        doc: x
        type: uint32
      - name: b
        doc: x
    "
  decodeFails Struct.codec.decode input "members[1]: missing field type"

end WebGPUGenTest.Parsed.Structs
