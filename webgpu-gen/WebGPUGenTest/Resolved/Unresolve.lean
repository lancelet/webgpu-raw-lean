import WebGPUGen.Resolved.Unresolve
import WebGPUGenTest.Resolved.Resolve

/-!
# Tests for unresolving

Each test writes a resolvable spec in YAML and checks both directions:
unresolving the resolved spec gives back the parsed one, and resolving the
unresolved spec gives back the resolved one. These are the equations the
faithfulness and reverse-direction theorems will prove for every spec.
-/

namespace WebGPUGenTest.Resolved.Unresolve
open WebGPUGen.Common WebGPUGen.Resolved WebGPUGen
open WebGPUGenTest.Resolved.Resolve (spec twoStructs)

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- Does `input` decode, pass `check`, and round-trip both ways? -/
def roundTrips (input : String) : Bool :=
  match decodeText Parsed.Spec.codec.decode input with
  | .error _ => false
  | .ok s =>
    let r := build s
    check s == []
      && unresolve r == s
      && check (unresolve r) == []
      && build (unresolve r) == r

/-! ## Round trips -/

-- Every kind of reference: named types and arrays of them, callbacks, constant
-- and entry defaults (enum, with a reserved slot, and flag), `extends`, flag
-- combinations, explicit flag values, and a function's callback and return.
#guard
  let input := spec
    (constants := dedent "
      - name: whole_size
        value: uint64_max
        doc: x
      ")
    (enums := dedent "
      - name: mode
        doc: x
        entries:
          - null
          - name: fast
            doc: x
      ")
    (bitflags := dedent "
      - name: mask
        doc: x
        entries:
          - name: none
            doc: x
          - name: red
            doc: x
          - name: high
            doc: x
            value: 0x8000
          - name: all
            doc: x
            value_combination:
              - red
              - high
      ")
    (structs := twoStructs ++ dedent "
      - name: s
        doc: x
        type: extension
        extends:
          - b
        members:
          - name: m
            doc: x
            type: enum.mode
            default: fast
          - name: f
            doc: x
            type: bitflag.mask
            default: red
          - name: size
            doc: x
            type: uint64
            default: constant.whole_size
          - name: inner
            doc: x
            type: struct.a
            default: zero
          - name: list
            doc: x
            type: array<struct.b>
            pointer: immutable
          - name: on_done
            doc: x
            type: callback.done
      ")
    (callbacks := dedent "
      - name: done
        doc: x
        style: callback_mode
        args:
          - name: status
            doc: x
            type: enum.mode
      ")
    (functions := dedent "
      - name: f
        doc: x
        returns:
          doc: x
          type: object.device
        callback: callback.done
        args:
          - name: s
            doc: x
            type: struct.s
            pointer: immutable
      ")
    (objects := dedent "
      - name: device
        doc: x
        methods:
          - name: get_mode
            doc: x
            returns:
              doc: x
              type: enum.mode
      ")
  roundTrips input

-- The rest: typedef references, arrays of enums, bitflags and objects,
-- namespaces, `optional`, ownership, `free_members`, `extended`, and boolean
-- and integer defaults.
#guard
  let input := spec
    (typedefs := dedent "
      - name: flags
        doc: x
        type: uint32
      ")
    (enums := dedent "
      - name: mode
        namespace: wgpu
        doc: x
        extended: true
        entries:
          - name: fast
            doc: x
      ")
    (bitflags := dedent "
      - name: mask
        doc: x
        entries:
          - name: red
            doc: x
      ")
    (structs := dedent "
      - name: s
        namespace: wgpu
        doc: x
        type: standalone
        free_members: true
        members:
          - name: t
            doc: x
            type: typedef.flags
          - name: ts
            doc: x
            type: array<typedef.flags>
            pointer: immutable
          - name: modes
            doc: x
            type: array<enum.mode>
            pointer: immutable
          - name: masks
            doc: x
            type: array<bitflag.mask>
            pointer: immutable
          - name: devices
            doc: x
            type: array<object.device>
            pointer: immutable
            optional: true
          - name: on
            doc: x
            type: bool
            default: true
          - name: count
            doc: x
            type: uint32
            default: 4
      ")
    (callbacks := dedent "
      - name: done
        doc: x
        style: immediate
        args:
          - name: message
            doc: x
            type: out_string
            passed_with_ownership: false
      ")
    (objects := dedent "
      - name: device
        namespace: wgpu
        doc: x
        extended: true
        methods:
          - name: create
            doc: x
            returns:
              doc: x
              type: object.device
              passed_with_ownership: true
              optional: true
            args:
              - name: d
                doc: x
                type: object.device
                passed_with_ownership: true
      ")
  roundTrips input

-- An empty spec.
#guard
  let input := spec
  roundTrips input

-- Names are found by position even when entries of different kinds share
-- them: an enum and a struct both called `mode`.
#guard
  let input := spec
    (enums := dedent "
      - name: mode
        doc: x
        entries:
          - name: fast
            doc: x
      ")
    (structs := dedent "
      - name: mode
        doc: x
        type: standalone
        members:
          - name: m
            doc: x
            type: enum.mode
      ")
  roundTrips input

end WebGPUGenTest.Resolved.Unresolve
