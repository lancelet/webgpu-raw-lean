import WebGPUGen.Emit.Pretty
import WebGPUGenTest.Literal

/-!
# Tests for pretty printing

Each test prints a document to a width and compares it with the exact text
expected. The documents are shaped like the code the C printer will make.
-/

namespace WebGPUGenTest.Emit.Pretty
open WebGPUGen.Emit WebGPUGen.Emit.Doc

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/--
A call `f(a, b, …)`: on one line if it fits, otherwise one argument per line,
indented, with the closing parenthesis back at the start.
-/
def call (f : String) (args : List Doc) : Doc :=
  group (text (f ++ "(") ++ nest 4 (softline ++ join (text "," ++ space) args) ++ softline ++ ")")

/-! ## Groups -/

-- A group that fits takes none of its breaks: a soft line becomes nothing.
#guard
  let input := call "wgpuDeviceCreateBuffer" ["device", "&desc"]
  let expected := "wgpuDeviceCreateBuffer(device, &desc)"
  pretty 80 input == expected

-- A group that does not fit takes all of them.
#guard
  let input := call "wgpuDeviceCreateBuffer" ["lean_wgpu_device_unbox(device)", "&descriptor"]
  let expected := dedent "
    wgpuDeviceCreateBuffer(
        lean_wgpu_device_unbox(device),
        &descriptor
    )
    "
  pretty 40 input ++ "\n" == expected

-- Groups are decided from the outside in: when the outer call breaks, an inner
-- call that now fits on its own line stays whole.
#guard
  let input := call "lean_io_result_mk_ok" [call "lean_wgpu_buffer_box" ["buffer"], "extra"]
  let expected := dedent "
    lean_io_result_mk_ok(
        lean_wgpu_buffer_box(buffer),
        extra
    )
    "
  pretty 40 input ++ "\n" == expected

-- A hard line always breaks, so its group never fits on one line.
#guard
  let input := group (text "{" ++ nest 4 (hardline ++ "return x;") ++ hardline ++ "}")
  let expected := dedent "
    {
        return x;
    }
    "
  pretty 80 input ++ "\n" == expected

-- A table lines up its columns, and indents with the document around it.
#guard
  let input := group (text "{" ++ nest 4 (hardline ++ table [
    [".label", "=", "label,"],
    [".size", "=", "size,"],
    [".mappedAtCreation", "=", "false,"]
  ]) ++ hardline ++ "}")
  let expected := dedent "
    {
        .label            = label,
        .size             = size,
        .mappedAtCreation = false,
    }
    "
  pretty 80 input ++ "\n" == expected

-- No line ends in spaces, even where a break follows a space.
#guard
  let input := text "a " ++ hardline ++ "b"
  pretty 80 input == "a\nb"

/-! ## Choices -/

-- `alt` takes its first layout if it fits on the line, otherwise its second.
#guard pretty 80 (alt (text "short") (text "long")) == "short"
#guard pretty 3 (alt (text "short") (text "long")) == "long"

-- Inside a group that is flat, `alt` takes its first layout without checking.
#guard pretty 80 (group (text "f(" ++ alt (text "a") (text "b") ++ text ")")) == "f(a)"

-- A choice that breaks breaks the groups around it too, as its hard lines do.
#guard
  let long := text (String.ofList (List.replicate 90 'a'))
  let input := call "f" [alt long (text "{" ++ hardline ++ text "}")]
  pretty 80 input == "f(\n    {\n    }\n)"

/-! ## Edges -/

-- Text after a group counts against it: the group breaks if the text would not
-- fit on its last line.
#guard
  let input := call "f" ["a", "b"] ++ text ";" ++ text (String.ofList (List.replicate 74 'x'))
  (pretty 80 input).startsWith "f(\n"

-- A group exactly as wide as the line fits; one character more does not.
#guard pretty 10 (call "abcdef" ["g"]) == "abcdef(g)"
#guard pretty 8 (call "abcdef" ["g"]) == "abcdef(\n    g\n)"

-- A flat group's groups are flat too.
#guard pretty 80 (call "f" [call "g" ["x"], call "h" ["y"]]) == "f(g(x), h(y))"

-- Characters, not bytes, are counted.
#guard pretty 9 (call "αβγ" ["δ", "ε"]) == "αβγ(δ, ε)"

-- Text with new lines breaks there, indented like any other line.
#guard
  let input := text "{" ++ nest 4 (hardline ++ ofString "a;\nb;") ++ hardline ++ "}"
  pretty 80 input == "{\n    a;\n    b;\n}"

-- Empty lists make empty documents.
#guard pretty 80 (join space []) == "" && pretty 80 (table []) == ""

-- A long document prints without running out of stack.
#guard
  let input := lines ((List.range 10000).map fun i => s!"int x{i} = {i};")
  ((pretty 80 input).splitOn "\n").length == 10000

end WebGPUGenTest.Emit.Pretty
