import WebGPUGen.Parsed.Codec
import WebGPUGenTest.Literal
import WebGPUGenTest.Check

/-!
# Tests for the whole-file codec, and for how values are encoded
-/

namespace WebGPUGenTest.Parsed.File
open WebGPUGen.Decode WebGPUGen.Common WebGPUGen.Parsed WebGPUGen

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- A spec file with every section empty, plus `extra` lines at the end. -/
def emptySpec (enumPrefix : String := "0x0000") (extra : String := "") : String :=
  dedent s!"
    copyright: x
    name: webgpu
    enum_prefix: {enumPrefix}
    doc: x
    constants: []
    typedefs: []
    enums: []
    bitflags: []
    structs: []
    callbacks: []
    functions: []
    objects: []
    " ++ extra

/-! ## The whole file -/

#guard
  let input := emptySpec
  let expected : Spec := {
    copyright  := "x",
    name       := "webgpu",
    enumPrefix := 0,
    doc        := "x",
    constants  := #[],
    typedefs   := #[],
    enums      := #[],
    bitflags   := #[],
    structs    := #[],
    callbacks  := #[],
    functions  := #[],
    objects    := #[]
  }
  decodesTo Spec.codec.decode input expected

-- Every section is required.
#guard
  let input := dedent "
    copyright: x
    name: webgpu
    enum_prefix: 0
    doc: x
    "
  decodeFails Spec.codec.decode input "missing field constants"

-- Unknown top-level keys are rejected.
#guard
  let input := emptySpec (extra := "extra: 1\n")
  decodeFails Spec.codec.decode input "unknown field extra"

-- The enum prefix is below 0x8000; upstream's extension example uses 0x7FFF.
#guard
  let input := emptySpec (enumPrefix := "0x7FFF")
  match decodeText Spec.codec.decode input with
  | .ok spec => spec.enumPrefix == 0x7FFF
  | .error _ => false

#guard
  let input := emptySpec (enumPrefix := "0x8000")
  decodeFails Spec.codec.decode input
    "enum_prefix: integer 32768 does not fit in the enum prefix range"

/-! ## Encoding defaults

The encoder writes booleans, numbers and floats plain, and names quoted, so an
entry named `true` reads back as an entry, not as the boolean. -/

#guard
  let input : List Default := [
    .bool true,
    .entry "true" (by decide),
    .int (-1),
    .float "32.0" (by decide),
    .constant "whole_size",
    .zero
  ]
  let expected : List Yaml.Node := [
    yaml% "true",
    yaml% lit "true",
    yaml% "-1",
    yaml% "32.0",
    yaml% lit "constant.whole_size",
    yaml% lit "zero"
  ]
  input.map Default.codec.encode == expected

end WebGPUGenTest.Parsed.File
