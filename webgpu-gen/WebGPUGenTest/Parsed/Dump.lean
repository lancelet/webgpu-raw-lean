import WebGPUGen.Parsed.Dump
import WebGPUGenTest.Check

/-!
# Tests for the spec dump

Each test renders a small model and compares it line by line with the expected
dump, which pins the format.
-/

namespace WebGPUGenTest.Parsed.Dump
open WebGPUGen.Common WebGPUGen.Parsed

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

def withDocs : DumpOptions := { docs := true }

/-- An enum entry with a generated doc. -/
def entry (name : String) (value : Option UInt16 := none) (ns : Option Name := none) :
    EnumEntry :=
  { name, ns, doc := s!"About {name}.\n", value }

/-- A bitflag entry with a generated doc. -/
def flag (name : String) (value : Option Value64 := none)
    (combination : Option (Array Name) := none) : BitflagEntry :=
  { name, ns := none, doc := s!"About {name}.\n", value, combination }

/-- A function or callback argument with only a name and a type. -/
def arg (name : String) (type : TypeRef) : Parameter Paragraph := {
  name                := name,
  doc                 := "x",
  type                := type,
  passedWithOwnership := none,
  pointer             := none,
  optional            := false,
  default             := none
}

/-! ## Layout -/

-- Columns are padded to their widest cell; a column empty in every row is
-- dropped; trailing spaces are trimmed.
#guard
  let input := [
    ["a", "", "x"],
    ["long", "", ""]
  ]
  let expected := [
    "  a     x",
    "  long"
  ]
  columns 2 input == expected

/-! ## Constants and typedefs -/

#guard
  let input : Array Constant := #[
    {
      name  := "whole_size",
      ns    := none,
      value := .uint64Max,
      doc   := "Whole size.\n"
    },
    {
      name  := "small",
      ns    := some "wgpu",
      value := .int 3,
      doc   := "Small.\n"
    }
  ]
  let expected := [
    "constants",
    "  whole_size  uint64_max",
    "  small       3           namespace wgpu"
  ]
  dumpConstants {} input == expected

#guard
  let expected := [
    "typedefs",
    "  (none)"
  ]
  dumpTypedefs {} #[] == expected

/-! ## Enums -/

-- Reserved slots, explicit values, namespaces and `extended`.
#guard
  let input : Enum := {
    name     := "feature_name",
    ns       := none,
    doc      := "Features.\n",
    extended := true,
    entries  := #[
      none,
      some (entry "depth_clip_control"),
      some (entry "push_constants" (value := some 3) (ns := some "wgpu"))
    ]
  }
  let expected := [
    "  feature_name  extended",
    "    [0]  (reserved)",
    "    [1]  depth_clip_control",
    "    [2]  push_constants      value 3  namespace wgpu"
  ]
  dumpEnum {} input == expected

-- With docs, each doc line follows its entry, two spaces deeper. Blank doc
-- lines are kept; reserved slots have no doc.
#guard
  let input : Enum := {
    name     := "two",
    ns       := none,
    doc      := "First paragraph.\n\nSecond paragraph.\n",
    extended := false,
    entries  := #[
      some (entry "a"),
      none
    ]
  }
  let expected := [
    "  two",
    "    | First paragraph.",
    "    |",
    "    | Second paragraph.",
    "    [0]  a",
    "      | About a.",
    "    [1]  (reserved)"
  ]
  dumpEnum withDocs input == expected

#guard
  let input : Enum := {
    name     := "empty",
    ns       := none,
    doc      := "",
    extended := false,
    entries  := #[]
  }
  let expected := [
    "  empty",
    "    (no entries)"
  ]
  dumpEnum {} input == expected

/-! ## Bitflags -/

-- Values are in hex; a combination is an OR of names.
#guard
  let input : Bitflag := {
    name     := "color_write_mask",
    ns       := none,
    doc      := "Channels.\n",
    extended := false,
    entries  := #[
      flag "red",
      flag "high" (value := some (.int 0x8000)),
      flag "all" (combination := some #["red", "high"])
    ]
  }
  let expected := [
    "  color_write_mask",
    "    red",
    "    high  value 0x8000",
    "    all   = red | high"
  ]
  dumpBitflag {} input == expected

-- A namespaced, extended bitflag; an entry giving both a value and a
-- combination shows both (resolution rejects it later).
#guard
  let input : Bitflag := {
    name     := "native_flags",
    ns       := some "wgpu",
    doc      := "x",
    extended := true,
    entries  := #[
      flag "both" (value := some (.int 1)) (combination := some #["a"])
    ]
  }
  let expected := [
    "  native_flags  namespace wgpu  extended",
    "    both  value 0x1 = a"
  ]
  dumpBitflag {} input == expected

/-! ## Defaults -/

-- Each kind of default is labelled, so an entry named `true` differs from the
-- boolean `true`.
#guard
  let input : List Default := [
    .bool true,
    .entry "true" (by decide),
    .int 50000000,
    .float "32.0" (by decide),
    .constant "whole_size",
    .zero
  ]
  let expected := [
    "default true",
    "default entry true",
    "default 50000000",
    "default 32.0",
    "default constant.whole_size",
    "default zero-init"
  ]
  input.map Default.render == expected

/-! ## Structs -/

-- Members show their type, then everything else they state in one column.
#guard
  let input : Struct := {
    name            := "texture_binding",
    ns              := none,
    doc             := "x",
    kind            := .extension,
    extendedStructs := #["bind_group_entry", "bind_group_layout_entry"],
    freeMembers     := true,
    members         := #[
      {
        name                := "views",
        doc                 := "x",
        type                := .refArray .object "texture_view",
        passedWithOwnership := some true,
        pointer             := some .immutable,
        optional            := true,
        default             := none
      },
      {
        name                := "flag",
        doc                 := "x",
        type                := .ref .enum "optional_bool",
        passedWithOwnership := none,
        pointer             := none,
        optional            := false,
        default             := some (.entry "true" (by decide))
      },
      {
        name                := "on",
        doc                 := "x",
        type                := .primitive (.scalar .bool),
        passedWithOwnership := none,
        pointer             := none,
        optional            := false,
        default             := some (.bool true)
      }
    ]
  }
  let expected := [
    "  texture_binding  extension  extends bind_group_entry, bind_group_layout_entry  free_members",
    "    views  array<object.texture_view>  immutable pointer  optional  with ownership",
    "    flag   enum.optional_bool          default entry true",
    "    on     bool                        default true"
  ]
  dumpStruct {} input == expected

#guard
  let input : Struct := {
    name            := "empty",
    ns              := none,
    doc             := "x",
    kind            := .standalone,
    extendedStructs := #[],
    freeMembers     := false,
    members         := #[]
  }
  let expected := [
    "  empty  standalone",
    "    (no members)"
  ]
  dumpStruct {} input == expected

/-! ## Callbacks, functions and objects -/

/-! ## Dump -/

-- Methods sit under their object, aligned as a group, with arguments under
-- each method. An async method names its callback.
#guard
  let input : Object := {
    name     := "adapter",
    ns       := none,
    doc      := "x",
    extended := false,
    methods  := #[
      {
        name     := "get_info",
        ns       := none,
        doc      := "x",
        returns  := some {
          doc                 := none,
          type                := .ref .enum "status",
          optional            := false,
          passedWithOwnership := some false,
          pointer             := none
        },
        callback := none,
        args     := #[
          {
            arg "info" (.ref .struct "adapter_info") with
            pointer := some .mutable
          }
        ]
      },
      {
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
    ]
  }
  let expected := [
    "  adapter",
    "    get_info        returns enum.status  without ownership",
    "      info  struct.adapter_info  mutable pointer",
    "    request_device  returns struct.future                   callback request_device",
    "      (no arguments)"
  ]
  dumpObject {} input == expected

#guard
  let input : Callback := {
    name  := "device_lost",
    ns    := some "wgpu",
    doc   := "x",
    style := .callbackMode,
    args  := #[
      arg "device" (.ref .object "device"),
      {
        arg "message" (.primitive (.scalar .outString)) with
        passedWithOwnership := some false
      }
    ]
  }
  let expected := [
    "  device_lost  callback_mode  namespace wgpu",
    "    device   object.device",
    "    message  out_string     without ownership"
  ]
  dumpCallback {} input == expected

-- With docs, a return doc follows the function's, marked `Returns:`; a
-- leading line break in it is dropped.
#guard
  let input : Array Function := #[
    {
      name     := "get_proc_address",
      ns       := none,
      doc      := "Look up a procedure.\n",
      returns  := some {
        doc                 := some "\nThe procedure, or null.\n",
        type                := .ref .functionType "proc",
        optional            := true,
        passedWithOwnership := none,
        pointer             := none
      },
      callback := none,
      args     := #[]
    }
  ]
  let expected := [
    "functions",
    "  get_proc_address  returns function_type.proc  optional",
    "    | Look up a procedure.",
    "    | Returns: The procedure, or null.",
    "    (no arguments)"
  ]
  dumpFunctions { docs := true } input == expected


end WebGPUGenTest.Parsed.Dump
