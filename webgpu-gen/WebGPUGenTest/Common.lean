import WebGPUGen.Common

/-!
# Tests for the common types

The checks behind `Name` and `Paragraph`, which both the parsed and resolved
specs use.
-/

namespace WebGPUGenTest.Common
open WebGPUGen.Common

/-! ## Names -/

#guard
  let input := [
    "whole_size",
    "a",
    "uint32",
    "R8Unorm",
    "2d"
  ]
  input.all isName

-- Underscores may not start or end a name; only ASCII letters and digits.
#guard
  let input := [
    "",
    "_a",
    "a_",
    "a.b",
    "a-b",
    "a b",
    "é"
  ]
  !(input.any isName)


/-! ## Single-paragraph docs -/

-- Non-empty lines, with at most one line break at either end.
#guard
  let input := [
    "TODO",
    "TODO\n",
    "\nTODO",
    "Line one.\nLine two.\n"
  ]
  input.all isSingleParagraph

-- Not empty, no blank lines, no doubled line break at either end.
#guard
  let input := [
    "",
    "\n",
    "A.\n\nB.",
    "A.\n\n",
    "\n\nA."
  ]
  !(input.any isSingleParagraph)

end WebGPUGenTest.Common
