import WebGPUGen.Parsed.Codec
import WebGPUGenTest.Literal
import WebGPUGenTest.Check

/-!
# Tests for decoding callbacks, functions and objects
-/

namespace WebGPUGenTest.Parsed.Functions
open WebGPUGen.Decode WebGPUGen.Common WebGPUGen.Parsed WebGPUGen

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- An argument with only a name and a type. -/
def arg (name : String) (type : TypeRef) : Parameter Paragraph := {
  name                := name,
  doc                 := "x",
  type                := type,
  passedWithOwnership := none,
  pointer             := none,
  optional            := false,
  default             := none
}

/-! ## Callbacks -/

#guard
  let input := dedent "
    name: buffer_map
    doc: Mapping finished.
    style: callback_mode
    args:
      - name: status
        doc: |
          The outcome.
        type: enum.map_async_status
    "
  let expected : Callback := {
    name  := "buffer_map",
    ns    := none,
    doc   := "Mapping finished.",
    style := .callbackMode,
    args  := #[
      {
        arg "status" (.ref .enum "map_async_status") with
        doc := "The outcome.\n"
      }
    ]
  }
  decodesTo Callback.codec.decode input expected

-- Argument docs must be a single paragraph.
#guard
  let input := dedent "
    name: c
    doc: x
    style: immediate
    args:
      - name: a
        doc: |
          First.

          Second.
        type: uint32
    "
  decodeFails Callback.codec.decode input "args[0].doc: expected a single-paragraph doc"

/-! ## Functions -/

-- A return with attributes, and arguments.
#guard
  let input := dedent "
    name: create_instance
    doc: Create a WGPUInstance
    returns:
      doc: The instance.
      type: object.instance
      passed_with_ownership: true
    args:
      - name: descriptor
        doc: x
        type: struct.instance_descriptor
        pointer: immutable
        optional: true
    "
  let expected : Function := {
    name     := "create_instance",
    ns       := none,
    doc      := "Create a WGPUInstance",
    returns  := some {
      doc                 := some "The instance.",
      type                := .ref .object "instance",
      optional            := false,
      passedWithOwnership := some true,
      pointer             := none
    },
    callback := none,
    args     := #[
      {
        arg "descriptor" (.ref .struct "instance_descriptor") with
        pointer  := some .immutable,
        optional := true
      }
    ]
  }
  decodesTo Function.codec.decode input expected

-- An asynchronous method names its callback; a return doc may be empty.
#guard
  let input := dedent "
    name: request_device
    doc: x
    returns:
      doc: \"\"
      type: struct.future
    callback: callback.request_device
    "
  let expected : Function := {
    name     := "request_device",
    ns       := none,
    doc      := "x",
    returns  := some {
      doc                 := none,
      type                := .ref .struct "future",
      optional            := false,
      passedWithOwnership := none,
      pointer             := none
    },
    callback := some "request_device",
    args     := #[]
  }
  decodesTo Function.codec.decode input expected

#guard
  let input := dedent "
    name: f
    doc: x
    callback: request_device
    "
  decodeFails Function.codec.decode input
    "callback: expected callback.<name>, found \"request_device\""

#guard
  let input := dedent "
    name: f
    doc: x
    returns:
      doc: |
        First.

        Second.
      type: bool
    "
  decodeFails Function.codec.decode input "returns.doc: expected a single-paragraph doc"

-- A return's optional fields.
#guard
  let input := dedent "
    name: get_proc_address
    doc: x
    returns:
      doc: The procedure.
      type: function_type.proc
      optional: true
      pointer: immutable
    "
  let expected : Function := {
    name     := "get_proc_address",
    ns       := none,
    doc      := "x",
    returns  := some {
      doc                 := some "The procedure.",
      type                := .ref .functionType "proc",
      optional            := true,
      passedWithOwnership := none,
      pointer             := some .immutable
    },
    callback := none,
    args     := #[]
  }
  decodesTo Function.codec.decode input expected

-- A return has no name or default.
#guard
  let input := dedent "
    name: f
    doc: x
    returns:
      doc: x
      type: bool
      default: false
    "
  decodeFails Function.codec.decode input "returns: unknown field default"

-- A namespaced callback.
#guard
  let input := dedent "
    name: log
    namespace: wgpu
    doc: x
    style: immediate
    "
  let expected : Callback := {
    name  := "log",
    ns    := some "wgpu",
    doc   := "x",
    style := .immediate,
    args  := #[]
  }
  decodesTo Callback.codec.decode input expected

/-! ## Objects -/

#guard
  let input := dedent "
    name: bind_group
    doc: x
    methods:
      - name: set_label
        doc: x
        args:
          - name: label
            doc: x
            type: string_with_default_empty
    "
  let expected : Object := {
    name     := "bind_group",
    ns       := none,
    doc      := "x",
    extended := false,
    methods  := #[
      {
        name     := "set_label",
        ns       := none,
        doc      := "x",
        returns  := none,
        callback := none,
        args     := #[
          arg "label" (.primitive (.scalar .stringWithDefaultEmpty))
        ]
      }
    ]
  }
  decodesTo Object.codec.decode input expected

-- Errors inside methods name the method and argument.
#guard
  let input := dedent "
    name: o
    doc: x
    methods:
      - name: m
        doc: x
        args:
          - name: a
            doc: x
            type: struct.
    "
  decodeFails Object.codec.decode input "methods[0].args[0].type: invalid name \"\""

-- An extension adding methods to an existing object.
#guard
  let input := dedent "
    name: device
    namespace: wgpu
    doc: x
    extended: true
    "
  let expected : Object := {
    name     := "device",
    ns       := some "wgpu",
    doc      := "x",
    extended := true,
    methods  := #[]
  }
  decodesTo Object.codec.decode input expected

end WebGPUGenTest.Parsed.Functions
