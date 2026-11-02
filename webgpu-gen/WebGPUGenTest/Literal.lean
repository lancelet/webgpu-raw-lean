import WebGPUGen.Yaml

/-!
# Readable test literals

Two helpers so tests read like the data they describe:

* `dedent` lets YAML input be written as an indented multi-line string.
* `yaml% …` writes an expected `Node` in a JSON-like syntax.
-/

namespace WebGPUGenTest
open WebGPUGen.Yaml

/--
Remove the indentation common to all non-blank lines, and the line break
that opens the literal. This lets YAML be indented along with the code:

    dedent "
      a: 1
      b: 2
      "  -- = "a: 1\nb: 2\n"

Indentation means spaces only (YAML forbids tabs there). The closing quote's
line contributes the final newline.
-/
def dedent (s : String) : String :=
  let blank (l : String) := l.all (· == ' ')
  let ls := match s.splitOn "\n" with
    | first :: rest => if blank first then rest else first :: rest
    | [] => []
  let indent (l : String) : Nat := (l.toList.takeWhile (· == ' ')).length
  let n := ((ls.filter (!blank ·)).map indent).min?.getD 0
  "\n".intercalate (ls.map fun l => String.ofList (l.toList.drop n))

/-! ## `yaml%` literals

* `"text"` is a plain scalar (could be a keyword such as `null`).
* `lit "text"` is a non-plain scalar: quoted, or a block scalar.
* `[a, b]` is a sequence and `{"k" : v}` a mapping, keys kept in order.
-/

declare_syntax_cat yamlNode (behavior := symbol)
syntax str : yamlNode
syntax &"lit " str : yamlNode  -- `&`: `lit` stays usable as an identifier
syntax "[" yamlNode,* "]" : yamlNode
syntax "{" (str " : " yamlNode),* "}" : yamlNode

/-- An expected `Node`, written in the syntax above. -/
syntax "yaml% " yamlNode : term

macro_rules
  | `(yaml% $s:str) =>
    `(Node.scalar { text := $s, plain := true })
  | `(yaml% lit $s:str) =>
    `(Node.scalar { text := $s, plain := false })
  | `(yaml% [ $items:yamlNode,* ]) => do
    let items ← items.getElems.mapM fun item => `(yaml% $item)
    `(Node.seq #[$items,*])
  | `(yaml% { $[$keys : $values],* }) => do
    let entries ← (keys.zip values).mapM fun (k, v) => `(($k, yaml% $v))
    `(Node.map #[$entries,*])

-- `dedent` removes the shared indentation and keeps relative indentation.
#guard
  let input := dedent "
    a:
      - b
    "
  input == "a:\n  - b\n"

-- Blank lines inside the literal survive.
#guard
  let input := dedent "
    a

    b
    "
  input == "a\n\nb\n"

-- `yaml%` builds the same tree as the constructors.
#guard
  let literal := yaml% {
    "a" : "1",
    "b" : [
      lit "x"
    ]
  }
  let constructed : Node := .map #[
    ("a", .scalar { text := "1", plain := true }),
    ("b", .seq #[
      .scalar { text := "x", plain := false }
    ])
  ]
  literal == constructed

end WebGPUGenTest
