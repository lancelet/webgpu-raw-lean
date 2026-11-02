import WebGPUGen.Emit.Layout
import WebGPUGenTest.Literal

/-!
# Tests for layout

Each test lays something out and compares it with the exact text expected,
written as it should look.
-/

namespace WebGPUGenTest.Emit.Layout
open WebGPUGen.Emit

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- Lines as one text, for comparing with a `dedent` literal. -/
def text (lines : List String) : String := "\n".intercalate lines ++ "\n"

/-! ## Columns -/

-- Every column but the last is padded to its widest cell.
#guard
  let input := [
    ["def", "none", ":", "ColorWriteMask := ⟨0⟩"],
    ["def", "red", ":", "ColorWriteMask := ⟨1⟩"],
    ["def", "green", ":", "ColorWriteMask := ⟨2⟩"]
  ]
  let expected := dedent "
    def none  : ColorWriteMask := ⟨0⟩
    def red   : ColorWriteMask := ⟨1⟩
    def green : ColorWriteMask := ⟨2⟩
    "
  text (columns input) == expected

/-! ## Doc comments -/

-- A short doc fits on one line, at the indent.
#guard
  let input := "The first mode."
  let expected := "  /-- The first mode. -/\n"
  text (docComment 2 input) == expected

-- A longer doc has `/--` and `-/` on lines of their own, as in Lean's own
-- library, with the text between wrapped to 80 columns.
#guard
  let input := dedent "
    Indicates no array layer count is specified. For more info,
    see @ref SentinelValues and the places that use this sentinel value.
    "
  let expected := dedent "
    /--
    Indicates no array layer count is specified. For more info, see @ref
    SentinelValues and the places that use this sentinel value.
    -/
    "
  text (docComment 0 input) == expected

-- Paragraphs stay apart, and each list item is refilled, its later lines
-- indented under its text, however the input was broken.
#guard
  let input := dedent "
    Callbacks created with this mode:
    - fire inside a call to @ref wgpuInstanceProcessEvents
      if the asynchronous operation is complete.
    - **may** fire spontaneously on an arbitrary or application thread, when the WebGPU
      implementations discovers that the asynchronous operation is complete.

    This is the default mode.
    "
  let expected := dedent "
    /--
    Callbacks created with this mode:
    - fire inside a call to @ref wgpuInstanceProcessEvents if the asynchronous
      operation is complete.
    - **may** fire spontaneously on an arbitrary or application thread, when the
      WebGPU implementations discovers that the asynchronous operation is complete.

    This is the default mode.
    -/
    "
  text (docComment 0 input) == expected

-- A link definition keeps a line of its own, as written, even past 80 columns:
-- a URL cannot be broken.
#guard
  let input := dedent "
    Indicates no value is passed for this argument. See [SentinelValues] for
    more.

    [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
    "
  let expected := dedent "
    /--
    Indicates no value is passed for this argument. See [SentinelValues] for more.

    [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
    -/
    "
  text (docComment 0 input) == expected

-- A placeholder is left out altogether.
#guard docComment 2 "TODO\n" == []

-- Comment delimiters in the text are escaped, so they cannot end the comment
-- early or open a nested one.
#guard
  let input := "Ends with -/ and opens /- here."
  let expected := "/-- Ends with -\\/ and opens /\\- here. -/\n"
  text (docComment 0 input) == expected

/-! ## The banner -/

#guard
  let input : Provenance := {
    generator    := "webgpu-gen"
    time         := "2026-11-02 17:05:12 UTC"
    commit       := "3500dab"
    dirty        := true
    source       := "vendor/webgpu-headers/webgpu.yml"
    sourceRepo   := "https://github.com/webgpu-native/webgpu-headers"
    sourceCommit := "673658bc2bd70ec39fc55ebe6bb0173cf6d0a603"
    sourceDate   := "2026-05-07"
    pinnedBy     := "wgpu-native v29.0.1.1"
  }
  let expected := dedent "
    /-
    ================================================================================
      GENERATED FILE: DO NOT EDIT BY HAND

      Generator:        webgpu-gen
      Generator commit: 3500dab (dirty)
      Generated:        2026-11-02 17:05:12 UTC
      Source:           vendor/webgpu-headers/webgpu.yml
      Source repo:      https://github.com/webgpu-native/webgpu-headers
      Source commit:    673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
      Source date:      2026-05-07
      Source pinned by: wgpu-native v29.0.1.1
    ================================================================================
    -/
    "
  text (banner input) == expected

end WebGPUGenTest.Emit.Layout
