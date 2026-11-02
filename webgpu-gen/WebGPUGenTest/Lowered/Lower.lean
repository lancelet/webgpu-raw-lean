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

end WebGPUGenTest.Lowered.Lower
