import WebGPUGen.Emit.C.Print
import WebGPUGenTest.Literal

/-!
# Tests for printing C

Each test prints a piece of C syntax and compares it with the exact text
expected. The last prints a whole file with a shim shaped like the ones the
bindings will need.
-/

namespace WebGPUGenTest.Emit.C.Print
open WebGPUGen.Emit WebGPUGen.Emit.C

/-! ## Expressions -/

-- A call on one line if it fits.
#guard
  let input := Expr.call "wgpuBufferGetSize" [.name "buffer"]
  Doc.pretty 80 (expr input) == "wgpuBufferGetSize(buffer)"

-- An initialiser always has one field per line, the `=` signs aligned, even
-- when it would fit on one line: struct contents read best as a column.
#guard
  let input := Expr.init [("width", .lit "4"), ("height", .lit "4")]
  let expected := dedent "
    {
        .width  = 4,
        .height = 4,
    }
    "
  Doc.pretty 80 (expr input) ++ "\n" == expected

-- At any width.
#guard
  let input := Expr.init [("width", .lit "4"), ("depthOrArrayLayers", .lit "1")]
  let expected := dedent "
    {
        .width              = 4,
        .depthOrArrayLayers = 1,
    }
    "
  Doc.pretty 20 (expr input) ++ "\n" == expected

/-! ## Statements -/

-- An `if` with an `else`, and a comment.
#guard
  let input := Stmt.ifElse (.name "ok")
    [.comment "It worked.", .ret (some (.lit "1"))]
    [.ret (some (.lit "0"))]
  let expected := dedent "
    if (ok) {
        // It worked.
        return 1;
    } else {
        return 0;
    }
    "
  Doc.pretty 80 (stmt input) ++ "\n" == expected

/-! ## Functions -/

-- Two or more parameters are always one per line, as a table of types and
-- names, even when they would fit on one line: a signature reads best as a
-- column, and every function then looks alike.
#guard
  let input : Function := {
    doc    := ""
    attrs  := ["static"]
    result := "int"
    name   := "add"
    params := [⟨"int", "a"⟩, ⟨"int", "b"⟩]
    body   := [.ret (some (.binary "+" (.name "a") (.name "b")))]
  }
  let expected := dedent "
    static int add(
        int a,
        int b
    ) {
        return a + b;
    }
    "
  Doc.pretty 80 (function input) ++ "\n" == expected

-- One parameter stays on the line.
#guard
  let input : Function := {
    doc    := ""
    attrs  := ["static"]
    result := "void"
    name   := "release"
    params := [⟨"void *", "p"⟩]
    body   := [.expr (.call "free" [.name "p"])]
  }
  Doc.pretty 80 (function input) == "static void release(void * p) {\n    free(p);\n}"

-- No parameters is `(void)`.
#guard
  let input : Function := {
    doc    := ""
    attrs  := ["static"]
    result := "void"
    name   := "init"
    params := []
    body   := [.ret none]
  }
  Doc.pretty 80 (function input) == "static void init(void) {\n    return;\n}"

/-! ## Regression tests

Defects found in review, each tested before it was fixed. -/

-- A value in a broken initialiser breaks as it needs to, so no line passes the
-- width; before, each value was printed on one line however long.
#guard
  let input := Stmt.decl "WGPUTextureDescriptor" "descriptor" (some (.init [
    ("label", .call "lean_wgpu_string_view" [.name "label"]),
    ("size", .init [
      ("width", .call "lean_wgpu_uint32" [.name "width"]),
      ("height", .call "lean_wgpu_uint32" [.name "height"]),
      ("depthOrArrayLayers", .call "lean_wgpu_uint32" [.name "layers"])
    ]),
    ("format", .call "lean_wgpu_texture_format_to_c" [.name "format"])
  ]))
  ((Doc.pretty 80 (stmt input)).splitOn "\n").all (·.length ≤ 80)

-- And it is laid out as a person would: nested, aligned at each level.
#guard
  let input := Stmt.decl "WGPUTextureDescriptor" "descriptor" (some (.init [
    ("label", .call "lean_wgpu_string_view" [.name "label"]),
    ("size", .init [
      ("width", .call "lean_wgpu_uint32" [.name "width"]),
      ("height", .call "lean_wgpu_uint32" [.name "height"]),
      ("depthOrArrayLayers", .call "lean_wgpu_uint32" [.name "layers"])
    ]),
    ("format", .call "lean_wgpu_texture_format_to_c" [.name "format"])
  ]))
  let expected := dedent "
    WGPUTextureDescriptor descriptor = {
        .label  = lean_wgpu_string_view(label),
        .size   = {
            .width              = lean_wgpu_uint32(width),
            .height             = lean_wgpu_uint32(height),
            .depthOrArrayLayers = lean_wgpu_uint32(layers),
        },
        .format = lean_wgpu_texture_format_to_c(format),
    };
    "
  Doc.pretty 80 (stmt input) ++ "\n" == expected

-- An operand that is an operation or a cast keeps its parentheses; before,
-- none were printed, changing the meaning.
#guard
  let input := Expr.cast "uint32_t" (.binary "+" (.name "a") (.name "b"))
  Doc.pretty 80 (expr input) == "(uint32_t)(a + b)"

#guard
  let input := Expr.binary "*" (.binary "+" (.name "a") (.name "b")) (.name "c")
  Doc.pretty 80 (expr input) == "(a + b) * c"

#guard
  let input := Expr.member (.cast "WGPUChainedStruct *" (.name "next")) "sType"
  Doc.pretty 80 (expr input) == "((WGPUChainedStruct *)next).sType"

-- An empty initialiser is C99's `{ 0 }`; before, `{  }`, which C99 rejects.
#guard Doc.pretty 80 (expr (.init [])) == "{ 0 }"

-- An empty body is just the braces; before, a blank line between them.
#guard
  let input : Function := {
    doc    := ""
    attrs  := ["static"]
    result := "void"
    name   := "nothing"
    params := []
    body   := []
  }
  Doc.pretty 80 (function input) == "static void nothing(void) {\n}"

-- A comment keeps its paragraphs apart with an empty comment line.
#guard
  let input := Stmt.comment "First.\n\nSecond."
  Doc.pretty 80 (stmt input) == "// First.\n//\n// Second."

/-! ## A whole file -/

-- Includes together, a blank line around each function; a long signature as a
-- table of parameters, a long initialiser aligned, a long call broken.
#guard
  let shim : Function := {
    doc    := "Lean's `Device.createBuffer`: wgpuDeviceCreateBuffer, with the buffer "
      ++ "descriptor built from its Lean fields."
    attrs  := ["LEAN_EXPORT"]
    result := "lean_obj_res"
    name   := "lean_wgpu_device_create_buffer"
    params := [
      ⟨"b_lean_obj_arg", "device"⟩,
      ⟨"b_lean_obj_arg", "label"⟩,
      ⟨"uint64_t", "usage"⟩,
      ⟨"uint64_t", "size"⟩,
      ⟨"uint8_t", "mappedAtCreation"⟩,
      ⟨"lean_obj_arg", "world"⟩
    ]
    body   := [
      .decl "WGPUBufferDescriptor" "desc" (some (.init [
        ("label", .call "lean_wgpu_string_view" [.name "label"]),
        ("usage", .name "usage"),
        ("size", .name "size"),
        ("mappedAtCreation", .name "mappedAtCreation")
      ])),
      .decl "WGPUExtent3D" "extent" (some (.init [("width", .lit "4"), ("height", .lit "4")])),
      .decl "WGPUBuffer" "buffer" (some (.call "wgpuDeviceCreateBuffer" [
        .call "lean_wgpu_device_unbox" [.name "device"],
        .addr (.name "desc")
      ])),
      .ifElse (.binary "==" (.name "buffer") (.lit "NULL"))
        [
          .comment "The device is lost or the descriptor invalid.",
          .ret (some (.call "lean_io_result_mk_error" [
            .call "lean_mk_string" [.lit "\"wgpuDeviceCreateBuffer failed\""]
          ]))
        ]
        [],
      .ret (some (.call "lean_io_result_mk_ok" [.call "lean_wgpu_buffer_box" [.name "buffer"]]))
    ]
  }
  let small : Function := {
    doc    := ""
    attrs  := ["static"]
    result := "void"
    name   := "f"
    params := [⟨"int", "x"⟩]
    body   := [.expr (.call "g" [.name "x"])]
  }
  let input := [.include "lean/lean.h", .include "webgpu/webgpu.h", .function small, .function shim]
  let expected := dedent "
    #include <lean/lean.h>
    #include <webgpu/webgpu.h>

    static void f(int x) {
        g(x);
    }

    // Lean's `Device.createBuffer`: wgpuDeviceCreateBuffer, with the buffer
    // descriptor built from its Lean fields.
    LEAN_EXPORT lean_obj_res lean_wgpu_device_create_buffer(
        b_lean_obj_arg device,
        b_lean_obj_arg label,
        uint64_t       usage,
        uint64_t       size,
        uint8_t        mappedAtCreation,
        lean_obj_arg   world
    ) {
        WGPUBufferDescriptor desc = {
            .label            = lean_wgpu_string_view(label),
            .usage            = usage,
            .size             = size,
            .mappedAtCreation = mappedAtCreation,
        };
        WGPUExtent3D extent = {
            .width  = 4,
            .height = 4,
        };
        WGPUBuffer buffer = wgpuDeviceCreateBuffer(
            lean_wgpu_device_unbox(device),
            &desc
        );
        if (buffer == NULL) {
            // The device is lost or the descriptor invalid.
            return lean_io_result_mk_error(
                lean_mk_string(\"wgpuDeviceCreateBuffer failed\")
            );
        }
        return lean_io_result_mk_ok(lean_wgpu_buffer_box(buffer));
    }
    "
  file input == expected

end WebGPUGenTest.Emit.C.Print
