import WebGPUGen.Resolved.Values
import WebGPUGenTest.Resolved.Resolve

/-!
# Tests for enum and flag values

Each test resolves a small spec and lists the values of its first enum's
entries, or its first bitflag type's flags. The test driver also checks every
value in the real spec against the values printed in `webgpu.h`.
-/

namespace WebGPUGenTest.Resolved.Values
open WebGPUGen.Common WebGPUGen.Resolved WebGPUGen
open WebGPUGenTest.Resolved.Resolve (spec resolveText)

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- The values of the first enum's entries, reserved slots left out. -/
def enumValues (input : String) : Option (List UInt32) :=
  match resolveText input with
  | .error _ => none
  | .ok r => r.enums[0]?.map fun e =>
    e.entries.toList.zipIdx.filterMap fun (slot, i) => slot.map (enumValue r i)

/-- The values of the first bitflag type's flags. -/
def flagValues (input : String) : Option (List UInt64) :=
  match resolveText input with
  | .error _ => none
  | .ok r => r.bitflags[0]?.map fun b =>
    (List.range b.entries.size).map (flagValue b)

/-! ## Enums -/

-- Entries are numbered by position, reserved slots included, unless they give
-- a value.
#guard
  let input := spec (enums := dedent "
    - name: mode
      doc: x
      entries:
        - null
        - name: fast
          doc: x
        - name: slow
          doc: x
          value: 7
    ")
  let expected := [
    0x00000001,
    0x00000007
  ]
  enumValues input == some expected

-- The spec's enum prefix is the high 16 bits.
#guard
  let input := (spec (enums := dedent "
    - name: mode
      doc: x
      entries:
        - name: fast
          doc: x
    ")).replace "enum_prefix: 0" "enum_prefix: 3"
  let expected := [
    0x00030000
  ]
  enumValues input == some expected

-- A namespaced entry uses its namespace's block instead.
#guard
  let input := spec (enums := dedent "
    - name: mode
      doc: x
      entries:
        - name: fast
          doc: x
        - name: compat
          namespace: compatibility_mode
          doc: x
          value: 1
    ")
  let expected := [
    0x00000000,
    0x20000001
  ]
  enumValues input == some expected

/-! ## Flags -/

-- By position: 0 for the first flag, then 1, 2, 4, …; a written value is kept;
-- a combination ORs the flags it names.
#guard
  let input := spec (bitflags := dedent "
    - name: mask
      doc: x
      entries:
        - name: none
          doc: x
        - name: red
          doc: x
        - name: green
          doc: x
        - name: high
          doc: x
          value: 0x8000
        - name: red_high
          doc: x
          value_combination:
            - red
            - high
    ")
  let expected := [
    0x0000,
    0x0001,
    0x0002,
    0x8000,
    0x8001
  ]
  flagValues input == some expected

-- Upstream's quirk, kept: a combination that names another combination takes
-- that combination's value by position, not the flags it combines. Here `rg`
-- is red | green, 3, but by position it is 4, so `rg_again` is 4.
#guard
  let input := spec (bitflags := dedent "
    - name: mask
      doc: x
      entries:
        - name: none
          doc: x
        - name: red
          doc: x
        - name: green
          doc: x
        - name: rg
          doc: x
          value_combination:
            - red
            - green
        - name: rg_again
          doc: x
          value_combination:
            - rg
    ")
  let expected := [
    0x0000,
    0x0001,
    0x0002,
    0x0003,
    0x0004
  ]
  flagValues input == some expected

-- Like upstream, an empty combination counts as none: the flag is numbered by
-- position.
#guard
  let input := spec (bitflags := dedent "
    - name: mask
      doc: x
      entries:
        - name: none
          doc: x
        - name: red
          doc: x
        - name: empty
          doc: x
          value_combination: []
    ")
  let expected := [
    0x0000,
    0x0001,
    0x0002
  ]
  flagValues input == some expected

end WebGPUGenTest.Resolved.Values
