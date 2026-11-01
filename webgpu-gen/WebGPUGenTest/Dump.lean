import WebGPUGen.Spec.Dump
import WebGPUGenTest.Check

/-!
# Tests for the spec dump

Each test renders a small model and compares it line by line with the expected
dump, which pins the format.
-/

namespace WebGPUGenTest.Dump
open WebGPUGen.Spec

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

def withDocs : DumpOptions := { docs := true }

/-- An enum entry with a generated doc. -/
def entry (name : String) (value : Option Nat := none) (ns : Option Name := none) :
    EnumEntry :=
  { name, ns, doc := s!"About {name}.\n", value }

/-- A bitflag entry with a generated doc. -/
def flag (name : String) (value : Option Value64 := none)
    (combination : Option (Array Name) := none) : BitflagEntry :=
  { name, ns := none, doc := s!"About {name}.\n", value, combination }

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

end WebGPUGenTest.Dump
