import WebGPUGen.Spec.Decode
import WebGPUGenTest.Literal
import WebGPUGenTest.Check

/-!
# Tests for decoding the spec model: names, types, values, constants, typedefs
-/

namespace WebGPUGenTest.Spec
open WebGPUGen.Decode WebGPUGen.Spec

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- Does each string parse as the type paired with it? -/
def typesParse (cases : List (String × TypeRef)) : Bool :=
  cases.all fun (text, expected) =>
    match (TypeRef.ofString text).run with
    | .ok actual => actual == expected
    | .error _ => false

/-- Does parsing `text` as a type fail with exactly `message`? -/
def typeFails (text : String) (message : String) : Bool :=
  match (TypeRef.ofString text).run with
  | .ok _ => false
  | .error e => toString e == message

/-- Does each YAML scalar decode to the default paired with it? -/
def defaultsDecode (cases : List (String × Default)) : Bool :=
  cases.all fun (input, expected) => decodesTo Default.decode input expected

/-! ## Names -/

#guard ["whole_size", "a", "uint32", "R8Unorm", "2d"].all isName

-- Underscores may not start or end a name; only ASCII letters and digits.
#guard !(["", "_a", "a_", "a.b", "a-b", "a b", "é"].any isName)

/-! ## Types -/

#guard typesParse [
  ("uint32",               .primitive (.scalar .uint32)),
  ("c_void",               .primitive (.scalar .cVoid)),
  ("out_string",           .primitive (.scalar .outString)),
  ("float64_supertype",    .primitive (.scalar .float64Supertype)),
  ("array<uint32>",        .primitive (.array .uint32)),
  ("array<string>",        .primitive (.array .string)),
  ("enum.texture_format",  .ref .enum "texture_format"),
  ("struct.limits",        .ref .struct "limits"),
  ("object.device",        .ref .object "device"),
  ("function_type.proc",   .ref .functionType "proc"),
  ("array<struct.limits>", .refArray .struct "limits"),
  ("callback.request",     .callback "request")
]

-- `string` is only allowed inside `array<…>`.
#guard typeFails "string" "unknown primitive type \"string\""

#guard typeFails "array<c_void>" "unknown array element type \"c_void\""

-- Arrays do not nest, and callbacks cannot be array elements.
#guard typeFails "array<array<uint32>>" "unknown array element type \"array<uint32>\""

#guard typeFails "array<callback.x>" "unknown array element type \"callback.x\""

#guard typeFails "struct._x" "invalid name \"_x\""

-- Malformed references are reported as references.
#guard typeFails "unknown.x" "invalid type reference \"unknown.x\""

#guard typeFails "struct.a.b" "invalid type reference \"struct.a.b\""

#guard typeFails "array<struct.x" "invalid type reference \"array<struct.x\""

#guard typeFails "callback." "invalid name \"\""

/-! ## Constant values -/

#guard
  let input := dedent "
    - 0
    - 18446744073709551615
    - usize_max
    - uint32_max
    - uint64_max
    - nan
    "
  let expected : Array Value64 := #[
    .int 0,
    .int 18446744073709551615,
    .usizeMax,
    .uint32Max,
    .uint64Max,
    .nan
  ]
  decodesTo (seq Value64.decode) input expected

#guard
  let input := dedent "
    18446744073709551616
    "
  decodeFails Value64.decode input "integer 18446744073709551616 does not fit in 64 bits"

#guard
  let input := dedent "
    infinity
    "
  decodeFails Value64.decode input "unknown constant value \"infinity\""

/-! ## Defaults

Every form of `default` that `webgpu.yml` uses. -/

#guard defaultsDecode [
  ("false",                        .bool false),
  ("0",                            .int 0),
  ("50000000",                     .int 50000000),
  ("\"0xFFFFFFFF\"",               .int 4294967295),
  ("32.0",                         .float "32.0"),
  ("constant.limit_u32_undefined", .constant "limit_u32_undefined"),
  ("zero",                         .zero),
  ("none",                         .entry "none"),
  ("render_attachment",            .entry "render_attachment")
]

#guard
  let input := dedent "
    null
    "
  decodeFails Default.decode input "expected a default value, found null"

#guard
  let input := dedent "
    \"1.5\"
    "
  decodeFails Default.decode input "invalid name \"1.5\""

/-! ## Constants and typedefs -/

#guard
  let input := dedent "
    name: whole_size
    value: uint64_max
    doc: |
      Whole size.
    "
  let expected : Constant := {
    name  := "whole_size",
    ns    := none,
    value := .uint64Max,
    doc   := "Whole size.\n"
  }
  decodesTo Constant.decode input expected

#guard
  let input := dedent "
    name: whole_size
    namespace: wgpu
    value: 3
    doc: x
    "
  let expected : Constant := {
    name  := "whole_size",
    ns    := some "wgpu",
    value := .int 3,
    doc   := "x"
  }
  decodesTo Constant.decode input expected

#guard
  let input := dedent "
    name: flags
    doc: x
    type: array<uint32>
    "
  let expected : Typedef := {
    name := "flags",
    ns   := none,
    doc  := "x",
    type := .array .uint32
  }
  decodesTo Typedef.decode input expected

-- A typedef aliases a primitive type, never a reference.
#guard
  let input := dedent "
    name: flags
    doc: x
    type: struct.limits
    "
  decodeFails Typedef.decode input "type: unknown primitive type \"struct.limits\""

#guard
  let input := dedent "
    name: whole_size
    value: 3
    "
  decodeFails Constant.decode input "missing field doc"

end WebGPUGenTest.Spec
