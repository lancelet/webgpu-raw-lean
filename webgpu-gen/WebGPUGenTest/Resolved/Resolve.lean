import WebGPUGen.Parsed.Codec
import WebGPUGen.Resolved.Resolve
import WebGPUGenTest.Literal
import WebGPUGenTest.Check

/-!
# Tests for resolution

Each test writes a small spec in YAML, decodes it, and resolves it: either
checking the IDs that resolution produced, or the problems it reported.
-/

namespace WebGPUGenTest.Resolved.Resolve
open WebGPUGen.Common WebGPUGen.Resolved WebGPUGen

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- `block` indented by two spaces, for nesting under a key. -/
def indent (block : String) : String :=
  "\n".intercalate ((block.splitOn "\n").map fun line =>
    if line.isEmpty then line else "  " ++ line)

/--
A spec file whose sections are the given YAML blocks (each a list of entries,
written with `dedent`), and empty otherwise.
-/
def spec (constants typedefs enums bitflags structs callbacks functions objects : String := "[]") :
    String :=
  let part (key block : String) :=
    if block == "[]" then s!"{key}: []\n" else s!"{key}:\n{indent block}"
  "copyright: x\nname: webgpu\nenum_prefix: 0\ndoc: x\n"
    ++ part "constants" constants
    ++ part "typedefs" typedefs
    ++ part "enums" enums
    ++ part "bitflags" bitflags
    ++ part "structs" structs
    ++ part "callbacks" callbacks
    ++ part "functions" functions
    ++ part "objects" objects

/--
Decode and resolve a spec file. Decoding errors and resolution problems both
become their messages.
-/
def resolveText (input : String) : Except (List String) Spec :=
  match decodeText Parsed.Spec.codec.decode input with
  | .error e => .error [s!"decode error: {e}"]
  | .ok parsed => (resolve parsed).mapError (·.map toString)

/-- Does `input` resolve, and does `test` hold of the result? -/
def resolvesTo (input : String) (test : Spec → Bool) : Bool :=
  match resolveText input with
  | .ok r => test r
  | .error _ => false

/-- Does resolving `input` report exactly `expected`, in order? -/
def problems (input : String) (expected : List String) : Bool :=
  match resolveText input with
  | .ok _ => false
  | .error actual => actual == expected

/-- Two structs, `a` (ID 0) and `b` (ID 1), for tests to refer to. -/
def twoStructs : String := dedent "
  - name: a
    doc: x
    type: standalone
  - name: b
    doc: x
    type: standalone
  "

/-! ## Building IDs -/

-- A member's type names a struct by its position in `structs`.
#guard
  let input := spec (structs := twoStructs ++ dedent "
    - name: c
      doc: x
      type: standalone
      members:
        - name: m
          doc: x
          type: array<struct.b>
    ")
  resolvesTo input fun r =>
    (r.structs[2]?.bind (·.members[0]?)).map (·.type) == some (.arrayOf (.struct ⟨1⟩))

-- An entry default names the member's enum and the entry's slot; reserved
-- slots count.
#guard
  let input := spec
    (enums := dedent "
      - name: mode
        doc: x
        entries:
          - null
          - name: fast
            doc: x
      ")
    (structs := dedent "
      - name: s
        doc: x
        type: standalone
        members:
          - name: m
            doc: x
            type: enum.mode
            default: fast
      ")
  resolvesTo input fun r =>
    (r.structs[0]?.bind (·.members[0]?)).bind (·.default)
      == some (.entry (.enumEntry ⟨0⟩ ⟨1⟩))

-- A combination names flags of the same bitflag by position.
#guard
  let input := spec (bitflags := dedent "
    - name: mask
      doc: x
      entries:
        - name: none
          doc: x
        - name: red
          doc: x
        - name: all
          doc: x
          value_combination:
            - red
    ")
  resolvesTo input fun r =>
    (r.bitflags[0]?.bind (·.entries[2]?)).map (·.value) == some (.combination #[⟨1⟩])

-- Explicit and implicit flag values, and a default naming a flag.
#guard
  let input := spec
    (bitflags := dedent "
      - name: mask
        doc: x
        entries:
          - name: none
            doc: x
          - name: high
            doc: x
            value: 0x8000
      ")
    (structs := dedent "
      - name: s
        doc: x
        type: standalone
        members:
          - name: m
            doc: x
            type: bitflag.mask
            default: high
      ")
  resolvesTo input fun r =>
    let values := (r.bitflags[0]?.map (·.entries.map (·.value))).getD #[]
    let default := (r.structs[0]?.bind (·.members[0]?)).bind (·.default)
    values == #[.implicit, .explicit 0x8000]
      && default == some (.entry (.flag ⟨0⟩ ⟨1⟩))

-- `extends` and a function's callback resolve to IDs too.
#guard
  let input := spec
    (structs := twoStructs ++ dedent "
      - name: c
        doc: x
        type: extension
        extends:
          - b
      ")
    (callbacks := dedent "
      - name: done
        doc: x
        style: callback_mode
      ")
    (functions := dedent "
      - name: f
        doc: x
        callback: callback.done
      ")
  resolvesTo input fun r =>
    (r.structs[2]?.map (·.extendedStructs)) == some #[⟨1⟩]
      && (r.functions[0]?.bind (·.callback)) == some ⟨0⟩

/-! ## Problems -/

-- Every kind of reference is checked, as a type and as an array element type.
#guard
  let input := spec (structs := dedent "
    - name: s
      doc: x
      type: standalone
      members:
        - name: a
          doc: x
          type: typedef.t
        - name: b
          doc: x
          type: enum.e
        - name: c
          doc: x
          type: bitflag.f
        - name: d
          doc: x
          type: object.o
        - name: e
          doc: x
          type: array<struct.s2>
        - name: f
          doc: x
          type: callback.c
    ")
  problems input [
    "structs[0].members[0].type: unknown typedef \"t\"",
    "structs[0].members[1].type: unknown enum \"e\"",
    "structs[0].members[2].type: unknown bitflag \"f\"",
    "structs[0].members[3].type: unknown object \"o\"",
    "structs[0].members[4].type: unknown struct \"s2\"",
    "structs[0].members[5].type: unknown callback \"c\""
  ]

-- Names must be unique in every list of named things.
#guard
  let input := spec
    (bitflags := dedent "
      - name: mask
        doc: x
        entries:
          - name: red
            doc: x
          - name: red
            doc: x
      ")
    (callbacks := dedent "
      - name: done
        doc: x
        style: immediate
        args:
          - name: a
            doc: x
            type: uint32
          - name: a
            doc: x
            type: uint32
      ")
    (objects := dedent "
      - name: o
        doc: x
        methods:
          - name: m
            doc: x
          - name: m
            doc: x
      - name: o
        doc: x
      ")
  problems input [
    "bitflags[0].entries[1].name: duplicate name \"red\"",
    "callbacks[0].args[1].name: duplicate name \"a\"",
    "objects[1].name: duplicate name \"o\"",
    "objects[0].methods[1].name: duplicate name \"m\""
  ]

-- A flag default must name a flag of the member's bitflag.
#guard
  let input := spec
    (bitflags := dedent "
      - name: mask
        doc: x
        entries:
          - name: red
            doc: x
      ")
    (structs := dedent "
      - name: s
        doc: x
        type: standalone
        members:
          - name: m
            doc: x
            type: bitflag.mask
            default: blue
      ")
  problems input [
    "structs[0].members[0].default: unknown flag \"blue\" of bitflag \"mask\""
  ]

-- An entry default on an array of enums is not an enum member.
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
      - name: s
        doc: x
        type: standalone
        members:
          - name: m
            doc: x
            type: array<enum.mode>
            default: fast
      ")
  problems input [
    "structs[0].members[0].default: entry default \"fast\" needs an enum or bitflag member, not array<enum.mode>"
  ]

#guard
  let input := spec (structs := dedent "
    - name: s
      doc: x
      type: standalone
      members:
        - name: m
          doc: x
          type: struct.missing
    ")
  problems input [
    "structs[0].members[0].type: unknown struct \"missing\""
  ]

-- Nothing in a spec defines function types.
#guard
  let input := spec (functions := dedent "
    - name: f
      doc: x
      returns:
        doc: x
        type: function_type.proc
    ")
  problems input [
    "functions[0].returns.type: function types are not supported: \"function_type.proc\""
  ]

#guard
  let input := spec (functions := dedent "
    - name: f
      doc: x
      callback: callback.missing
    ")
  problems input [
    "functions[0].callback: unknown callback \"missing\""
  ]

#guard
  let input := spec (structs := twoStructs ++ dedent "
    - name: a
      doc: x
      type: extension
      extends:
        - c
    ")
  problems input [
    "structs[2].name: duplicate name \"a\"",
    "structs[2].extends[0]: unknown struct \"c\""
  ]

-- Defaults: a constant must exist, and an entry must belong to the member's
-- enum, which must be an enum or bitflag at all.
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
      - name: s
        doc: x
        type: standalone
        members:
          - name: a
            doc: x
            type: uint32
            default: constant.missing
          - name: b
            doc: x
            type: enum.mode
            default: slow
          - name: c
            doc: x
            type: uint32
            default: fast
      ")
  problems input [
    "structs[0].members[0].default: unknown constant \"missing\"",
    "structs[0].members[1].default: unknown entry \"slow\" of enum \"mode\"",
    "structs[0].members[2].default: entry default \"fast\" needs an enum or bitflag member, not uint32"
  ]

-- Reserved enum slots have no name, so they never clash.
#guard
  let input := spec (enums := dedent "
    - name: mode
      doc: x
      entries:
        - null
        - null
        - name: fast
          doc: x
        - name: fast
          doc: x
    ")
  problems input [
    "enums[0].entries[3].name: duplicate name \"fast\""
  ]

-- What the resolved spec cannot express: a named bitflag value, or a value
-- together with a combination; and combinations name flags of the same type.
#guard
  let input := spec (bitflags := dedent "
    - name: mask
      doc: x
      entries:
        - name: a
          doc: x
          value: uint32_max
        - name: b
          doc: x
          value: 1
          value_combination:
            - a
        - name: c
          doc: x
          value_combination:
            - z
    ")
  problems input [
    "bitflags[0].entries[0].value: a bitflag value must be an integer",
    "bitflags[0].entries[1]: value and value_combination cannot both be given",
    "bitflags[0].entries[2].value_combination[0]: unknown flag \"z\""
  ]

/-! ## Rules for parameters -/

-- `passed_with_ownership`: struct members may not set it, function arguments
-- and returns only to `true`; callback arguments may use either.
#guard
  let input := spec
    (structs := dedent "
      - name: s
        doc: x
        type: standalone
        members:
          - name: m
            doc: x
            type: uint32
            passed_with_ownership: true
      ")
    (callbacks := dedent "
      - name: done
        doc: x
        style: callback_mode
        args:
          - name: message
            doc: x
            type: out_string
            passed_with_ownership: false
      ")
    (functions := dedent "
      - name: f
        doc: x
        returns:
          doc: x
          type: out_string
          passed_with_ownership: false
        args:
          - name: a
            doc: x
            type: out_string
            passed_with_ownership: false
      ")
  problems input [
    "structs[0].members[0].passed_with_ownership: struct members cannot set passed_with_ownership",
    "functions[0].returns.passed_with_ownership: a return value cannot be passed without ownership",
    "functions[0].args[0].passed_with_ownership: a function argument cannot be passed without ownership"
  ]

-- Defaults suit their member's type, as upstream's generator requires.
#guard
  let input := spec (structs := dedent "
    - name: s
      doc: x
      type: standalone
      members:
        - name: a
          doc: x
          type: bool
          default: 1
        - name: b
          doc: x
          type: int16
          default: 1
        - name: c
          doc: x
          type: uint32
          default: zero
        - name: d
          doc: x
          type: nullable_string
          default: false
        - name: e
          doc: x
          type: c_void
          pointer: mutable
          default: zero
    ")
  problems input [
    "structs[0].members[0].default: default integer 1 does not suit a member of type bool",
    "structs[0].members[1].default: default integer 1 does not suit a member of type int16",
    "structs[0].members[2].default: default zero does not suit a member of type uint32",
    "structs[0].members[3].default: default boolean false does not suit a member of type nullable_string",
    "structs[0].members[4].default: a pointer member cannot have a default"
  ]

-- Each kind of default that suits its type, as `webgpu.yml` uses them.
#guard
  let input := spec
    (constants := dedent "
      - name: whole_size
        value: uint64_max
        doc: x
      ")
    (structs := twoStructs ++ dedent "
      - name: s
        doc: x
        type: standalone
        members:
          - name: a
            doc: x
            type: bool
            default: false
          - name: b
            doc: x
            type: uint64
            default: constant.whole_size
          - name: c
            doc: x
            type: float32
            default: 1
          - name: d
            doc: x
            type: float64
            default: 32.0
          - name: e
            doc: x
            type: struct.a
            default: zero
      ")
  resolvesTo input fun _ => true

-- Only struct members have defaults: they exist for the C `INIT` macros.
#guard
  let input := spec (functions := dedent "
    - name: f
      doc: x
      args:
        - name: a
          doc: x
          type: uint32
          default: 0
    ")
  problems input [
    "functions[0].args[0].default: only struct members can have defaults"
  ]

/-! ## Warnings -/

-- An extension that extends nothing is allowed, as upstream allows it, but
-- reported.
#guard
  let input := spec (structs := dedent "
    - name: lonely
      doc: x
      type: extension
    ")
  match decodeText Parsed.Spec.codec.decode input with
  | .ok parsed =>
    (warnings parsed).map toString == ["structs[0]: an extension struct that extends nothing"]
      && check parsed == []
  | .error _ => false

end WebGPUGenTest.Resolved.Resolve
