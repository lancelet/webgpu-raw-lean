import WebGPUGen.Lowered.Docs
import WebGPUGenTest.Literal

/-!
# Tests for docs in Lean terms

Each test translates a doc from the spec with a small context of Lean names and
documentation sections, and compares the result with the doc expected.
-/

namespace WebGPUGenTest.Lowered.Docs
open WebGPUGen.Lowered

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- A few Lean names and documentation sections to translate with. -/
def ctx : DocContext := {
  leanNames := Std.HashMap.ofList [
    ("WGPUMapMode_Read", "MapMode.read"),
    ("WGPUBufferDescriptor", "BufferDescriptor"),
    ("wgpuInstanceWaitAny", "Instance.waitAny")
  ]
  sections := Std.HashMap.ofList [
    ("SentinelValues", "SentinelValues"),
    ("Surface-Presenting", "Surfaces")
  ]
}

/-! ## Sections -/

-- An article's first label names its page; every label is on that page.
#guard
  let input := dedent "
    # Surfaces {#Surfaces}

    ## Presenting {#Surface-Presenting}
    "
  let expected := [
    ("Surfaces", "Surfaces"),
    ("Surface-Presenting", "Surfaces")
  ]
  articleSections input == expected

/-! ## Translating -/

-- A reference to a name in `webgpu.h` becomes a code span with its Lean name;
-- punctuation after it is kept.
#guard
  let input := "Read it (using @ref WGPUMapMode_Read). See @ref wgpuInstanceWaitAny."
  let expected := "Read it (using `MapMode.read`). See `Instance.waitAny`."
  translateDoc ctx input == expected

-- So does a code span holding one; other code spans are kept.
#guard
  let input := "Set `mappedAtCreation` in `WGPUBufferDescriptor`."
  let expected := "Set `mappedAtCreation` in `BufferDescriptor`."
  translateDoc ctx input == expected

-- A member is named through its type.
#guard
  let input := "See @ref WGPUBufferDescriptor::mappedAtCreation."
  let expected := "See `BufferDescriptor.mappedAtCreation`."
  translateDoc ctx input == expected

-- Doxygen's `::X` refers to `X` too.
#guard
  let input := "A call to ::wgpuInstanceWaitAny returns."
  let expected := "A call to `Instance.waitAny` returns."
  translateDoc ctx input == expected

-- A name without a Lean counterpart keeps its C name, in a code span.
#guard
  let input := "Pass @ref WGPU_WHOLE_SIZE."
  let expected := "Pass `WGPU_WHOLE_SIZE`."
  translateDoc ctx input == expected

-- A documentation section becomes a reference-style link, defined once at the
-- end, on the page that holds it.
#guard
  let input := "See @ref SentinelValues and @ref Surface-Presenting, and @ref SentinelValues."
  let expected := dedent "
    See [SentinelValues] and [Surface-Presenting], and [SentinelValues].

    [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
    [Surface-Presenting]: https://webgpu-native.github.io/webgpu-headers/Surfaces.html#Surface-Presenting
    "
  translateDoc ctx input == expected

-- `@note` becomes a bold label.
#guard
  let input := "@note Not required."
  let expected := "**Note:** Not required."
  translateDoc ctx input == expected

end WebGPUGenTest.Lowered.Docs
