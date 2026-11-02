import WebGPUGen.Lowered.Lower
import WebGPUGenTest.Resolved.Resolve

/-!
# Tests for lowering

Each test resolves a small spec, lowers it, and compares a part of the result
with the lowered model written out in full. The test driver also checks the
lowered real spec against `webgpu.h`.
-/

namespace WebGPUGenTest.Lowered.Lower
open WebGPUGen.Lowered WebGPUGen
open WebGPUGenTest.Resolved.Resolve (spec resolveText indent)

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- Resolve and lower a spec file, with the documentation sections given. -/
def lowerText (input : String) (sections : List (String × String) := []) :
    Option Lowered.Spec :=
  match resolveText input with
  | .ok r    => some (lower r sections)
  | .error _ => none

/-! ## Enums -/

-- Names on both sides; a reserved slot is left out but still shifts the
-- values after it; a keyword is quoted on the Lean side.
#guard
  let input := spec (enums := dedent "
    - name: address_mode
      doc: How to address.
      entries:
        - null
        - name: clamp_to_edge
          doc: Clamp.
        - name: repeat
          doc: Repeat.
    ")
  let expected : Lowered.Enum := {
    names    := {
      c    := "WGPUAddressMode"
      lean := "AddressMode"
    }
    doc      := "How to address."
    extended := false
    entries  := #[
      {
        names := {
          c    := "WGPUAddressMode_ClampToEdge"
          lean := "clampToEdge"
        }
        doc   := "Clamp."
        value := 0x00000001
      },
      {
        names := {
          c    := "WGPUAddressMode_Repeat"
          lean := "«repeat»"
        }
        doc   := "Repeat."
        value := 0x00000002
      }
    ]
  }
  (lowerText input).map (·.enums) == some #[expected]

/-! ## Bitflags -/

-- Each flag with its value; a combination's value is the OR of its flags.
#guard
  let input := spec (bitflags := dedent "
    - name: color_write_mask
      doc: Which channels.
      entries:
        - name: none
          doc: None.
        - name: red
          doc: Red.
        - name: green
          doc: Green.
        - name: RG_all
          doc: All.
          value_combination:
            - red
            - green
    ")
  let expected : Lowered.Bitflag := {
    names    := {
      c    := "WGPUColorWriteMask"
      lean := "ColorWriteMask"
    }
    doc      := "Which channels."
    extended := false
    flags    := #[
      {
        names := {
          c    := "WGPUColorWriteMask_None"
          lean := "none"
        }
        doc   := "None."
        value := 0x0000
      },
      {
        names := {
          c    := "WGPUColorWriteMask_Red"
          lean := "red"
        }
        doc   := "Red."
        value := 0x0001
      },
      {
        names := {
          c    := "WGPUColorWriteMask_Green"
          lean := "green"
        }
        doc   := "Green."
        value := 0x0002
      },
      {
        names := {
          c    := "WGPUColorWriteMask_RGAll"
          lean := "rgAll"
        }
        doc   := "All."
        value := 0x0003
      }
    ]
  }
  (lowerText input).map (·.bitflags) == some #[expected]

/-! ## Functions -/

/-- A device and a queue, and an enum, for the function tests to refer to. -/
def deviceSpec (methods : String) (functions : String := "[]") : String :=
  spec
    (enums := dedent "
      - name: mode
        doc: x
        entries:
          - name: a
            doc: x
      ")
    (functions := functions)
    (objects := dedent "
      - name: queue
        doc: x
      - name: device
        doc: x
        methods:
      " ++ indent (indent methods))

/-- A spec's `objects`: a device alone, with `methods`. -/
def deviceWith (methods : String) : String :=
  "- name: device\n  doc: x\n  methods:\n" ++ indent (indent methods)

/-- The lowered methods of the device, if the spec lowers. -/
def deviceMethods (methods : String) : Option (Array Lowered.Function) :=
  (lowerText (deviceSpec methods)).bind fun l => l.objects[1]?.map (·.methods)

/-- How each argument of the device's first method crosses, if it lowers. -/
def argValues (methods : String) : Option (List Value) :=
  (deviceMethods methods).bind fun ms =>
    ms[0]?.map (·.args.toList.map (·.value))

/-- How the result of the device's first method crosses, if it lowers. -/
def resultValue? (methods : String) : Option (Option Value) :=
  (deviceMethods methods).bind fun ms => ms[0]?.map (·.result)

-- A method, named after its object type on both sides, with its arguments:
-- each borrowed, an object one possibly NULL, and an owned object result.
#guard
  let input := dedent "
    - name: get_queue_for
      doc: Get a queue.
      returns:
        doc: The queue.
        type: object.queue
        passed_with_ownership: true
      args:
        - name: label
          doc: A label.
          type: string_with_default_empty
        - name: mode
          doc: A mode.
          type: enum.mode
        - name: other
          doc: Another queue.
          type: object.queue
          optional: true
    "
  let queue : Names := {
    c    := "WGPUQueue"
    lean := "Queue"
  }
  let expected : Lowered.Function := {
    names    := {
      c    := "wgpuDeviceGetQueueFor"
      lean := "Device.getQueueFor"
    }
    doc      := "Get a queue."
    receiver := some {
      c    := "WGPUDevice"
      lean := "Device"
    }
    args     := #[
      {
        names := {
          c    := "label"
          lean := "label"
        }
        doc   := "A label."
        value := .string false
      },
      {
        names := {
          c    := "mode"
          lean := "mode"
        }
        doc   := "A mode."
        value := .enum {
          c    := "WGPUMode"
          lean := "Mode"
        }
      },
      {
        names := {
          c    := "other"
          lean := "other"
        }
        doc   := "Another queue."
        value := .object queue true
      }
    ]
    result   := some (.object queue false)
    callback := false
  }
  deviceMethods input == some #[expected] && expected.unsupported == []

-- A function of no object type is named on its own: `wgpuX`, `x`.
#guard
  let functions := dedent "
    - name: get_proc_count
      doc: x
      returns:
        doc: x
        type: uint32
    "
  let names := (lowerText (deviceSpec "[]" functions)).bind fun l =>
    l.functions[0]?.map fun f => (f.names, f.receiver)
  let expected : Names := {
    c    := "wgpuGetProcCount"
    lean := "getProcCount"
  }
  names == some (expected, none)

-- Numbers cross as they are; a `size_t` crosses as a `UInt64`, checked to fit.
#guard
  let input := dedent "
    - name: m
      doc: x
      args:
        - name: a
          doc: x
          type: bool
        - name: b
          doc: x
          type: int32
        - name: c
          doc: x
          type: float32
        - name: d
          doc: x
          type: usize
    "
  argValues input == some [.bool, .int32, .float32, .usize]
    && Value.usize.leanType == some "UInt64"
    && Value.usize.cType == some "size_t"

-- What the bindings cannot pass yet is said, not guessed: a struct behind a
-- pointer, untyped memory, an optional number, and an argument with ownership
-- stated (in the spec, an output struct whose members the caller must free).
#guard
  let input := dedent "
    - name: m
      doc: x
      args:
        - name: a
          doc: x
          type: struct.s
          pointer: immutable
        - name: b
          doc: x
          type: c_void
          pointer: immutable
        - name: c
          doc: x
          type: uint32
          optional: true
        - name: d
          doc: x
          type: object.device
          passed_with_ownership: true
    "
  let methods := (lowerText (spec
    (structs := "- name: s\n  doc: x\n  type: standalone\n")
    (objects := deviceWith input)))
    |>.bind (·.objects[0]?.map (·.methods))
  (methods.bind (·[0]?.map (·.unsupported))) == some [
    "struct (immutable pointer)",
    "c_void (immutable pointer)",
    "uint32",
    "object"
  ]

-- An object result is passed only when the spec says it comes with its own
-- reference: otherwise who releases it is unknown.
#guard
  let input := dedent "
    - name: m
      doc: x
      returns:
        doc: x
        type: object.queue
    "
  let expected := Value.unsupported "an object without ownership stated"
  resultValue? input == some (some expected)

-- A result enum keeps a code the bindings do not know.
#guard
  let input := dedent "
    - name: m
      doc: x
      returns:
        doc: x
        type: enum.mode
    "
  (resultValue? input).map (·.bind Value.resultLeanType)
    == some (some "Except UInt32 Mode")

-- A string result is not passed yet: who frees it, and how, differs.
#guard
  let input := dedent "
    - name: m
      doc: x
      returns:
        doc: x
        type: string_with_default_empty
    "
  resultValue? input == some (some (.unsupported "string_with_default_empty"))

-- A method that takes a callback is not bound yet, whatever its arguments.
#guard
  let methods := dedent "
    - name: m
      doc: x
      callback: callback.done
    "
  let input := spec
    (callbacks := "- name: done\n  doc: x\n  style: callback_mode\n")
    (objects := deviceWith methods)
  ((lowerText input).bind (·.objects[0]?.bind (·.methods[0]?)))
    |>.map (·.unsupported) == some ["takes a callback"]

-- A nullable string is an `Option String`, `none` being the null view.
#guard
  let input := dedent "
    - name: m
      doc: x
      args:
        - name: label
          doc: x
          type: nullable_string
    "
  argValues input == some [.string true]
    && (Value.string true).leanType == some "Option String"

-- An optional object result can be NULL: an `Option`, as `createBuffer`'s is.
#guard
  let input := dedent "
    - name: m
      doc: x
      returns:
        doc: x
        type: object.queue
        passed_with_ownership: true
        optional: true
    "
  (resultValue? input).map (·.bind Value.resultLeanType)
    == some (some "Option Queue")

-- An optional enum has no `none` to stand for: not passed. Nor are arrays and
-- callbacks yet.
#guard
  let input := dedent "
    - name: m
      doc: x
      args:
        - name: a
          doc: x
          type: enum.mode
          optional: true
        - name: b
          doc: x
          type: array<object.queue>
          pointer: immutable
        - name: c
          doc: x
          type: array<uint32>
          pointer: immutable
    "
  argValues input == some [
    .unsupported "enum",
    .unsupported "array (immutable pointer)",
    .unsupported "array<uint32> (immutable pointer)"
  ]

-- A value the bindings cannot pass has no type on either side, so a printer
-- cannot print one by mistake.
#guard
  let v := Value.unsupported "struct"
  v.leanType == none && v.resultLeanType == none && v.cType == none

-- A method named with a keyword is quoted after its type's name.
#guard
  let input := dedent "
    - name: end
      doc: x
    "
  (deviceMethods input).map (·.map (·.names.lean)) == some #["Device.«end»"]

/-! ## Constants -/

-- Each kind of constant, named on both sides.
#guard
  let input := spec (constants := dedent "
    - name: whole_size
      value: uint64_max
      doc: x
    - name: limit_u32_undefined
      value: uint32_max
      doc: x
    - name: whole_map_size
      value: usize_max
      doc: x
    - name: depth_clear_value_undefined
      value: nan
      doc: x
    ")
  (lowerText input).map (·.constants.toList.map fun c => (c.names, c.value))
    == some [
      (⟨"WGPU_WHOLE_SIZE", "wholeSize"⟩, .uint64 0xFFFFFFFFFFFFFFFF),
      (⟨"WGPU_LIMIT_U32_UNDEFINED", "limitU32Undefined"⟩, .uint32 0xFFFFFFFF),
      (⟨"WGPU_WHOLE_MAP_SIZE", "wholeMapSize"⟩, .sizeMax),
      (⟨"WGPU_DEPTH_CLEAR_VALUE_UNDEFINED", "depthClearValueUndefined"⟩, .nan)
    ]

/-! ## Structs -/

/-- A spec with an enum, a bitflag type, a constant, an object and `structs`. -/
def structSpec (structs : String) : String :=
  spec
    (constants := dedent "
      - name: whole_size
        value: uint64_max
        doc: x
      ")
    (enums := dedent "
      - name: mode
        doc: x
        entries:
          - name: undefined
            doc: x
          - name: fast
            doc: x
      ")
    (bitflags := dedent "
      - name: usage
        doc: x
        entries:
          - name: none
            doc: x
          - name: read
            doc: x
      ")
    (structs := dedent "
      - name: inner
        doc: x
        type: standalone
        members:
          - name: n
            doc: x
            type: uint32
            default: 0
      " ++ structs)
    (objects := "- name: buffer\n  doc: x\n")

/-- The struct named `name` of the lowered `structSpec structs`, if any. -/
def lowerStructNamed (structs name : String) : Option Lowered.Struct :=
  (lowerText (structSpec structs)).bind fun l =>
    l.structs.toList.find? (·.names.lean == name)

/-- Each member of that struct: its Lean name, value and default. -/
def membersOf (structs name : String) :
    Option (List (String × Value × Option Lowered.Default)) :=
  (lowerStructNamed structs name).map fun s =>
    s.members.toList.map fun m => (m.names.lean, m.value, m.default)

-- Members of the shapes the bindings pass, with their defaults: a constant, an
-- enum entry, a flag, a boolean, and a nested struct at its own defaults.
#guard
  let input := dedent "
    - name: descriptor
      doc: x
      type: extensible
      members:
        - name: label
          doc: x
          type: string_with_default_empty
        - name: size
          doc: x
          type: uint64
          default: constant.whole_size
        - name: mode
          doc: x
          type: enum.mode
          default: fast
        - name: usage
          doc: x
          type: bitflag.usage
          default: read
        - name: mapped
          doc: x
          type: bool
          default: false
        - name: inner
          doc: x
          type: struct.inner
          default: zero
    "
  let mode : Names := ⟨"WGPUMode", "Mode"⟩
  let usage : Names := ⟨"WGPUUsage", "Usage"⟩
  membersOf input "Descriptor" == some [
    ("label", .string false, some .empty),
    ("size", .uint64, some (.constant ⟨"WGPU_WHOLE_SIZE", "wholeSize"⟩)),
    ("mode", .enum mode, some (.entry mode ⟨"WGPUMode_Fast", "fast"⟩)),
    ("usage", .bitflag usage, some (.entry usage ⟨"WGPUUsage_Read", "read"⟩)),
    ("mapped", .bool, some (.bool false)),
    ("inner", .struct ⟨"WGPUInner", "Inner"⟩, some .zero)
  ]

-- Structs behind pointers (NULL if optional), arrays of each kind, an optional
-- object, and a `float64_supertype`, which C holds as a `double`.
#guard
  let input := dedent "
    - name: holder
      doc: x
      type: standalone
      members:
        - name: one
          doc: x
          type: struct.inner
          pointer: immutable
        - name: maybe
          doc: x
          type: struct.inner
          pointer: immutable
          optional: true
        - name: inners
          doc: x
          type: array<struct.inner>
          pointer: immutable
        - name: modes
          doc: x
          type: array<enum.mode>
          pointer: immutable
        - name: buffers
          doc: x
          type: array<object.buffer>
          pointer: immutable
        - name: counts
          doc: x
          type: array<uint32>
          pointer: immutable
        - name: buffer
          doc: x
          type: object.buffer
          optional: true
        - name: red
          doc: x
          type: float64_supertype
    "
  let inner : Names := ⟨"WGPUInner", "Inner"⟩
  let buffer : Names := ⟨"WGPUBuffer", "Buffer"⟩
  (membersOf input "Holder").map (·.map (·.2.1)) == some [
    .structPointer inner false,
    .structPointer inner true,
    .array (.struct inner) "innerCount",
    .array (.enum ⟨"WGPUMode", "Mode"⟩) "modeCount",
    .array (.object buffer false) "bufferCount",
    .array .uint32 "countCount",
    .object buffer true,
    .float64
  ]

-- What the bindings cannot pass yet is said: an output string, a callback,
-- untyped memory, an optional number.
#guard
  let input := dedent "
    - name: unsure
      doc: x
      type: standalone
      members:
        - name: message
          doc: x
          type: out_string
        - name: handle
          doc: x
          type: c_void
          pointer: mutable
        - name: depth
          doc: x
          type: nullable_float32
    "
  (lowerStructNamed input "Unsure").map (·.unsupported) == some [
    "out_string",
    "c_void (mutable pointer)",
    "nullable_float32"
  ]

-- An extension names the structs it attaches to; a struct whose members C
-- allocates says so.
#guard
  let input := dedent "
    - name: base
      doc: x
      type: extensible
      free_members: true
    - name: extra
      doc: x
      type: extension
      extends:
        - base
    "
  let base := lowerStructNamed input "Base"
  let extra := lowerStructNamed input "Extra"
  base.map (·.freeMembers) == some true
    && extra.map (·.extendedStructs) == some #[⟨"WGPUBase", "Base"⟩]
    && extra.map (·.kind) == some .extension

-- The value types of the new shapes, on both sides. (A unit test of `leanType`:
-- lowering never makes an array of optional objects; the case checks that an
-- element type with spaces is parenthesised.)
#guard
  let inner : Names := ⟨"WGPUInner", "Inner"⟩
  let buffer : Names := ⟨"WGPUBuffer", "Buffer"⟩
  (Value.structPointer inner true).leanType == some "Option Inner"
    && (Value.structPointer inner false).cType == some "WGPUInner const *"
    && (Value.array (.object buffer false) "n").leanType == some "Array Buffer"
    && (Value.array (.object buffer true) "n").leanType
      == some "Array (Option Buffer)"
    && (Value.array .uint32 "n").cType == some "uint32_t const *"

-- The spec's number defaults: an integer, a quoted one (as hex), a float.
#guard
  let input := dedent "
    - name: numbers
      doc: x
      type: standalone
      members:
        - name: count
          doc: x
          type: uint32
          default: 1
        - name: mask
          doc: x
          type: uint32
          default: \"0xFFFFFFFF\"
        - name: bias
          doc: x
          type: float32
          default: 32.0
    "
  (membersOf input "Numbers").map (·.map (·.2.2)) == some [
    some (.int 1),
    some (.int 0xFFFFFFFF),
    some (.float "32.0")
  ]

-- With no default in the spec, a member has the one C's initialiser gives it
-- (upstream's rules): an enum its `undefined` entry; a bitflag type `none`;
-- zero, an empty array or string, `none` for what is optional, and a nested
-- struct at its own defaults.
#guard
  let input := dedent "
    - name: implicit
      doc: x
      type: standalone
      members:
        - name: mode
          doc: x
          type: enum.mode
        - name: usage
          doc: x
          type: bitflag.usage
        - name: count
          doc: x
          type: uint32
        - name: ratio
          doc: x
          type: float32
        - name: on
          doc: x
          type: bool
        - name: label
          doc: x
          type: string_with_default_empty
        - name: name
          doc: x
          type: nullable_string
        - name: buffer
          doc: x
          type: object.buffer
          optional: true
        - name: inner
          doc: x
          type: struct.inner
        - name: modes
          doc: x
          type: array<enum.mode>
          pointer: immutable
    "
  let mode : Names := ⟨"WGPUMode", "Mode"⟩
  let usage : Names := ⟨"WGPUUsage", "Usage"⟩
  (membersOf input "Implicit").map (·.map (·.2.2)) == some [
    some (.entry mode ⟨"WGPUMode_Undefined", "undefined"⟩),
    some (.entry usage ⟨"WGPUUsage_None", "none"⟩),
    some (.int 0),
    some (.float "0.0"),
    some (.bool false),
    some .empty,
    some .null,
    some .null,
    some .nested,
    some .empty
  ]

-- No valid default, so the member must be given: an enum with no `undefined`
-- entry (C would set a code no entry has), an object that is not optional, a
-- struct pointer that is not optional (C would set NULL).
#guard
  let input := dedent "
    - name: required
      doc: x
      type: standalone
      members:
        - name: speed
          doc: x
          type: enum.speed
        - name: buffer
          doc: x
          type: object.buffer
        - name: inner
          doc: x
          type: struct.inner
          pointer: immutable
    "
  let speedSpec := spec
    (enums := dedent "
      - name: speed
        doc: x
        entries:
          - name: slow
            doc: x
      ")
    (structs := dedent "
      - name: inner
        doc: x
        type: standalone
      " ++ input)
    (objects := "- name: buffer\n  doc: x\n")
  let required := (lowerText speedSpec).bind fun l =>
    l.structs.toList.find? (·.names.lean == "Required")
  required.map (·.members.toList.map (·.default)) == some [none, none, none]

-- An extension carries the `SType` entry named after it; one with none is not
-- passed.
#guard
  let input := spec
    (enums := dedent "
      - name: s_type
        doc: x
        entries:
          - name: marked
            doc: x
      ")
    (structs := dedent "
      - name: base
        doc: x
        type: extensible
      - name: marked
        doc: x
        type: extension
        extends:
          - base
      - name: unmarked
        doc: x
        type: extension
        extends:
          - base
      ")
  let structs := (lowerText input).map (·.structs.toList)
  let find (name : String) := structs.bind (·.find? (·.names.lean == name))
  (find "Marked").map (·.sType) == some (some ⟨"WGPUSType_Marked", "marked"⟩)
    && (find "Marked").map (·.unsupported) == some []
    && (find "Unmarked").map (·.unsupported) == some ["no SType entry"]
    && (find "Base").map (·.sType) == some none

-- More of what is not passed yet: an array of strings, an optional struct by
-- value, an optional double, an array not behind a pointer, and an optional
-- array. (Ownership stated on a member does not resolve at all.)
#guard
  let input := dedent "
    - name: unsure
      doc: x
      type: standalone
      members:
        - name: names
          doc: x
          type: array<string>
          pointer: immutable
        - name: maybe
          doc: x
          type: struct.inner
          optional: true
        - name: red
          doc: x
          type: float64_supertype
          optional: true
        - name: bare
          doc: x
          type: array<uint32>
        - name: some
          doc: x
          type: array<uint32>
          pointer: immutable
          optional: true
    "
  (lowerStructNamed input "Unsure").map (·.unsupported) == some [
    "array<string>",
    "struct",
    "float64_supertype",
    "array<uint32>",
    "array<uint32> (immutable pointer)"
  ]

end WebGPUGenTest.Lowered.Lower
