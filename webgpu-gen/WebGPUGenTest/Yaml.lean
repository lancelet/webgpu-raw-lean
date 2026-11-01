import WebGPUGen.Yaml
import WebGPUGenTest.Literal

/-!
# Tests for the YAML boundary

These pin down the L4YAML behaviour the spec reader relies on. They run as
`#guard`s, so a failure stops the build. Each input mirrors a construct used in
`webgpu.yml`.
-/

namespace WebGPUGenTest.Yaml
open WebGPUGen.Yaml

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- Does `input` parse to exactly `expected`? -/
def parsesTo (input : String) (expected : Node) : Bool :=
  match parse input with
  | .ok node => node == expected
  | .error _ => false

/-- Does parsing `input` fail with exactly `message`? -/
def failsWith (input : String) (message : String) : Bool :=
  match parse input with
  | .ok _ => false
  | .error e => e.message == message

/-! ## What is accepted -/

-- Mappings keep keys in source order.
#guard
  let input := dedent "
    b: 1
    a: 2
    "
  let expected := yaml% {
    "b" : "1",
    "a" : "2"
  }
  parsesTo input expected

-- Scalars stay as text: hex and booleans are not interpreted, and quoting is
-- recorded. Deciding what `0x0000` or `true` means is the decoder's job.
#guard
  let input := dedent "
    enum_prefix: 0x0000
    optional: true
    default: \"0xFFFFFFFF\"
    "
  let expected := yaml% {
    "enum_prefix" : "0x0000",
    "optional" : "true",
    "default" : lit "0xFFFFFFFF"
  }
  parsesTo input expected

-- Only plain scalars are marked plain: `null` could be a keyword, the quoted
-- forms are strings. An empty value is a plain empty scalar.
#guard
  let input := dedent "
    a: null
    b: \"null\"
    c: 'x'
    d: \"\"
    e:
    "
  let expected := yaml% {
    "a" : "null",
    "b" : lit "null",
    "c" : lit "x",
    "d" : lit "",
    "e" : ""
  }
  parsesTo input expected

-- An empty flow sequence, as in `typedefs: []`.
#guard
  let input := dedent "
    typedefs: []
    "
  let expected := yaml% {
    "typedefs" : []
  }
  parsesTo input expected

-- A literal block scalar keeps its line breaks, with one trailing newline
-- (clip chomping). This matches the "doc" strings in upstream's webgpu.json.
#guard
  let input := dedent "
    doc: |
      Line one.

      Line two.
    "
  let expected := yaml% {
    "doc" : lit "Line one.\n\nLine two.\n"
  }
  parsesTo input expected

-- A block scalar containing `key: value` text, followed by another key, as in
-- the spec's `copyright` header. (L4YAML's indexed parser rejects this.)
#guard
  let input := dedent "
    copyright: |
      SPDX-License-Identifier: BSD-3-Clause
    name: webgpu
    "
  let expected := yaml% {
    "copyright" : lit "SPDX-License-Identifier: BSD-3-Clause\n",
    "name" : "webgpu"
  }
  parsesTo input expected

-- The spec's most common shape: a list of entries, each with a block-scalar
-- doc, followed by the next entry.
#guard
  let input := dedent "
    entries:
      - name: a
        doc: |
          First.
      - name: b
        doc: |
          Second.
    "
  let expected := yaml% {
    "entries" : [
      {
        "name" : "a",
        "doc" : lit "First.\n"
      },
      {
        "name" : "b",
        "doc" : lit "Second.\n"
      }
    ]
  }
  parsesTo input expected

-- Comments between nested keys are ignored.
#guard
  let input := dedent "
    member:
      type: uint32
      # A comment between keys.
      default: 0
    "
  let expected := yaml% {
    "member" : {
      "type" : "uint32",
      "default" : "0"
    }
  }
  parsesTo input expected

-- Aliases are resolved before conversion.
#guard
  let input := dedent "
    a: &x v
    b: *x
    "
  let expected := yaml% {
    "a" : "v",
    "b" : "v"
  }
  parsesTo input expected

/-! ## What is rejected

`Node` cannot represent these faithfully, so they fail rather than lose meaning.
-/

#guard
  let input := dedent "
    ? [k]
    : v
    "
  failsWith input "mapping key is not a scalar"

#guard
  let input := dedent "
    a: 1
    a: 2
    "
  failsWith input "duplicate key a"

#guard
  let input := dedent "
    a: !!str 1
    "
  failsWith input "explicit tag !!str is not supported"

#guard
  let input := dedent "
    a: !!null \"\"
    "
  failsWith input "explicit tag !!null is not supported"

#guard
  let input := ""
  failsWith input "empty document"

-- A document that is just `null` is not empty.
#guard
  let input := dedent "
    null
    "
  let expected := yaml% "null"
  parsesTo input expected

#guard
  let input := dedent "
    a: 1
    ---
    b: 2
    "
  failsWith input "expected one document, found 2"

-- Malformed input is an error, not a partial result.
#guard
  let input := dedent "
    a: [1, 2
    "
  !(parse input matches .ok _)

end WebGPUGenTest.Yaml
