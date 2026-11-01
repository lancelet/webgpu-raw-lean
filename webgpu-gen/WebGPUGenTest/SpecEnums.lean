import WebGPUGen.Spec.Decode
import WebGPUGenTest.Literal
import WebGPUGenTest.Check

/-!
# Tests for decoding enums and bitflags
-/

namespace WebGPUGenTest.SpecEnums
open WebGPUGen.Decode WebGPUGen.Spec

/-! ## Enums -/

-- A reserved slot (`- null`) and a quoted entry name, as in `webgpu.yml`.
#guard
  let input := dedent "
    name: optional_bool
    doc: Tristate.
    entries:
      - null
      - name: \"false\"
        doc: False.
    "
  let expected : Enum := {
    name     := "optional_bool",
    ns       := none,
    doc      := "Tristate.",
    extended := false,
    entries  := #[
      none,
      some {
        name  := "false",
        ns    := none,
        doc   := "False.",
        value := none
      }
    ]
  }
  decodesTo Enum.decode input expected

-- An extension: `extended`, a namespace and an explicit value. Upstream's
-- extension example writes `True`, which the core schema accepts.
#guard
  let input := dedent "
    name: feature_name
    doc: Features.
    extended: True
    entries:
      - name: push_constants
        namespace: wgpu
        doc: Push constants.
        value: 3
    "
  let expected : Enum := {
    name     := "feature_name",
    ns       := none,
    doc      := "Features.",
    extended := true,
    entries  := #[
      some {
        name  := "push_constants",
        ns    := some "wgpu",
        doc   := "Push constants.",
        value := some 3
      }
    ]
  }
  decodesTo Enum.decode input expected

-- A namespace on the enum itself.
#guard
  let input := dedent "
    name: native_feature
    namespace: wgpu
    doc: Native features.
    entries:
      - null
    "
  let expected : Enum := {
    name     := "native_feature",
    ns       := some "wgpu",
    doc      := "Native features.",
    extended := false,
    entries  := #[none]
  }
  decodesTo Enum.decode input expected

-- `entries` may be absent.
#guard
  let input := dedent "
    name: empty
    doc: Nothing yet.
    "
  let expected : Enum := {
    name     := "empty",
    ns       := none,
    doc      := "Nothing yet.",
    extended := false,
    entries  := #[]
  }
  decodesTo Enum.decode input expected

-- Entry values are 16-bit.
#guard
  let input := dedent "
    name: e
    doc: x
    entries:
      - name: big
        doc: x
        value: 65536
    "
  decodeFails Enum.decode input "entries[0].value: integer 65536 does not fit in 16 bits"

/-! ## Bitflags -/

-- Plain flags and a combination, as `color_write_mask` has.
#guard
  let input := dedent "
    name: color_write_mask
    doc: Channels.
    entries:
      - name: red
        doc: Red.
      - name: all
        value_combination:
          - red
          - green
        doc: All.
    "
  let expected : Bitflag := {
    name     := "color_write_mask",
    ns       := none,
    doc      := "Channels.",
    extended := false,
    entries  := #[
      {
        name        := "red",
        ns          := none,
        doc         := "Red.",
        value       := none,
        combination := none
      },
      {
        name        := "all",
        ns          := none,
        doc         := "All.",
        value       := none,
        combination := some #["red", "green"]
      }
    ]
  }
  decodesTo Bitflag.decode input expected

-- An explicit value may be any `Value64`.
#guard
  let input := dedent "
    name: flags
    doc: x
    entries:
      - name: high
        doc: x
        value: 0x8000000000000000
    "
  let expected : Bitflag := {
    name     := "flags",
    ns       := none,
    doc      := "x",
    extended := false,
    entries  := #[
      {
        name        := "high",
        ns          := none,
        doc         := "x",
        value       := some (.int 0x8000000000000000),
        combination := none
      }
    ]
  }
  decodesTo Bitflag.decode input expected

-- `value` and `value_combination` together still decode: the conflict is
-- rejected at resolution, as upstream's generator does.
#guard
  let input := dedent "
    name: flags
    doc: x
    entries:
      - name: both
        doc: x
        value: 1
        value_combination:
          - a
    "
  let expected : Bitflag := {
    name     := "flags",
    ns       := none,
    doc      := "x",
    extended := false,
    entries  := #[
      {
        name        := "both",
        ns          := none,
        doc         := "x",
        value       := some (.int 1),
        combination := some #["a"]
      }
    ]
  }
  decodesTo Bitflag.decode input expected

-- Unlike enums, bitflags have no reserved slots.
#guard
  let input := dedent "
    name: flags
    doc: x
    entries:
      - null
    "
  decodeFails Bitflag.decode input "entries[0]: expected a mapping, found null"

#guard
  let input := dedent "
    name: flags
    doc: x
    entries:
      - name: all
        doc: x
        value_combination:
          - _red
    "
  decodeFails Bitflag.decode input "entries[0].value_combination[0]: invalid name \"_red\""

end WebGPUGenTest.SpecEnums
