import WebGPUGen.Decode
import WebGPUGenTest.Literal
import WebGPUGenTest.Check

/-!
# Tests for the decoding toolkit

The tests decode YAML into `Entry`, a small record shaped like the spec's own
entries, and check results and error messages, including the error path.
-/

namespace WebGPUGenTest.Decode
open WebGPUGen.Yaml WebGPUGen.Decode

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- A record shaped like a spec entry: required, optional and list fields. -/
structure Entry where
  name  : String
  value : Option Nat
  flags : Array Bool
  deriving BEq

def entry : Node → Decode Entry :=
  object do
    let name  ← field  "name"  string
    let value ← field? "value" nat
    let flags ← field  "flags" (seq bool)
    return { name, value, flags }

/-- A list of entries under `entries`, to exercise nested paths. -/
def entries : Node → Decode (Array Entry) :=
  object (field "entries" (seq entry))

/-! ## Successful decoding -/

-- Required, optional and list fields; key order in the input does not matter.
#guard
  let input := dedent "
    flags: [true, false]
    value: 3
    name: a
    "
  let expected : Entry := {
    name := "a",
    value := some 3,
    flags := #[true, false]
  }
  decodesTo entry input expected

-- An absent optional field is `none`.
#guard
  let input := dedent "
    name: a
    flags: []
    "
  let expected : Entry := {
    name := "a",
    value := none,
    flags := #[]
  }
  decodesTo entry input expected

/-! ## Errors and their paths -/

#guard
  let input := dedent "
    name: a
    "
  decodeFails entry input "missing field flags"

-- Unknown keys are rejected, mirroring `additionalProperties: false`.
#guard
  let input := dedent "
    name: a
    flags: []
    extra: 1
    "
  decodeFails entry input "unknown field extra"

-- A quoted value is a string even when its text looks like a number.
#guard
  let input := dedent "
    name: a
    value: \"3\"
    flags: []
    "
  decodeFails entry input "value: expected an integer, found string \"3\""

-- A plain keyword is not a string.
#guard
  let input := dedent "
    name: null
    flags: []
    "
  decodeFails entry input "name: expected a string, found null"

#guard
  let input := dedent "
    name: a
    value: -1
    flags: []
    "
  decodeFails entry input "value: expected a non-negative integer, found -1"

-- Errors deep in the tree name the full path, with indices.
#guard
  let input := dedent "
    entries:
      - name: a
        flags: []
      - name: b
        flags: [true, 0]
    "
  decodeFails entries input "entries[1].flags[1]: expected a boolean, found integer 0"

#guard
  let input := dedent "
    entries:
      name: a
    "
  decodeFails entries input "entries: expected a sequence, found a mapping"

-- A scalar where a mapping is expected.
#guard
  let input := dedent "
    entries:
      - just a string
    "
  decodeFails entries input "entries[0]: expected a mapping, found string \"just a string\""

-- A collection where a scalar is expected.
#guard
  let input := dedent "
    name: [a]
    flags: []
    "
  decodeFails entry input "name: expected a scalar, found a sequence"

#guard
  let input := dedent "
    name: a
    value: 1.5
    flags: []
    "
  decodeFails entry input "value: expected an integer, found float 1.5"

-- A decoder that reads no fields still rejects every key.
#guard
  let input := dedent "
    a: 1
    "
  decodeFails (object (pure ())) input "unknown field a"

/-! ## Nullable entries -/

-- A bare `null` reserves a slot; anything else is decoded.
#guard
  let input := dedent "
    - a
    - null
    - b
    "
  let expected : Array (Option String) := #[
    some "a",
    none,
    some "b"
  ]
  decodesTo (seq (nullable string)) input expected

-- A quoted "null" is a string, not a reserved slot.
#guard
  let input := dedent "
    - \"null\"
    "
  let expected : Array (Option String) := #[
    some "null"
  ]
  decodesTo (seq (nullable string)) input expected

end WebGPUGenTest.Decode
