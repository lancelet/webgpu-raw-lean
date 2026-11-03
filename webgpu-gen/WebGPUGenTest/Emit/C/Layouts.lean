import WebGPUGen.Emit.C.Layouts
import WebGPUGen.Emit.C.Print
import WebGPUGenTest.Literal

/-!
# Tests for the layout checks

The checks of structs and the macros they use, compared with the exact C
expected. The test driver also compiles the checks of every bound struct of the
real spec against `webgpu.h`.
-/

namespace WebGPUGenTest.Emit.C.Layouts
open WebGPUGen WebGPUGen.Emit.C WebGPUGen.CLayout

/-! ## Checks -/

-- A struct's checks: a comment naming it, each field's offset on 64-bit
-- targets and wasm32, aligned in columns, then its size and alignment.
#guard
  let input : List (String × CType) := [
    ("nextInChain", .scalar .ptr),
    ("label", .struct [.scalar .ptr, .scalar .size]),
    ("usage", .scalar .u64),
    ("size", .scalar .u64),
    ("mappedAtCreation", .scalar .u32)
  ]
  let expected := dedent "
    // WGPUBufferDescriptor
    FIELD(WGPUBufferDescriptor, nextInChain,      0,  0);
    FIELD(WGPUBufferDescriptor, label,            8,  4);
    FIELD(WGPUBufferDescriptor, usage,            24, 16);
    FIELD(WGPUBufferDescriptor, size,             32, 24);
    FIELD(WGPUBufferDescriptor, mappedAtCreation, 40, 32);
    STRUCT(WGPUBufferDescriptor, 48, 40, 8, 8);
    "
  file (structChecks "WGPUBufferDescriptor" input) == expected

/-! ## Macros -/

-- A macro with a one-line body is one line; a longer body starts on a line of
-- its own, each line but the last continued.
#guard
  let input : List Decl := [
    .define "ONE" ["a"] ["(a)"],
    .define "TWO" ["a", "b"] ["first(a);", "second(b)"]
  ]
  let expected := dedent "
    #define ONE(a) (a)
    #define TWO(a, b) \\
        first(a); \\
        second(b)
    "
  file input == expected

end WebGPUGenTest.Emit.C.Layouts
