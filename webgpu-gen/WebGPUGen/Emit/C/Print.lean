import WebGPUGen.Emit.C
import WebGPUGen.Emit.Pretty

/-!
# Printing C

Lays out the C syntax tree with `Doc`, in one consistent style:

* four spaces of indentation, and braces on the line that opens the block;
* a call on one line if it fits, and otherwise one argument per line, with the
  closing bracket back at the start;
* an initialiser always one field per line, its `=` signs aligned, and two or
  more parameters always one per line, their names aligned, even where they
  would fit on one line;
* parentheses around an operand that is itself an operation or a cast, so the
  tree's meaning is kept whatever the operators' precedence.
-/

namespace WebGPUGen.Emit.C
open WebGPUGen.Emit Doc

/--
Items in brackets: on one line if they fit, otherwise one per line, indented,
with the closing bracket on a line of its own.
-/
def bracketed (opening closing : String) (items : List Doc) : Doc :=
  group (text opening ++ nest 4 (softline ++ join (text "," ++ space) items) ++ softline
    ++ text closing)

/-- Does `e`, as the operand of another operation, need parentheses? -/
def Expr.needsParens : Expr → Bool
  | .binary .. | .cast .. => true
  | _                     => false

/-- `d`, the document of `e`, in parentheses if `e` needs them as an operand. -/
def operand (e : Expr) (d : Doc) : Doc :=
  if e.needsParens then text "(" ++ d ++ text ")" else d

/-- An expression. -/
def expr : Expr → Doc
  | .name n         => text n
  | .lit t          => text t
  | .call f args    => bracketed (f ++ "(") ")" (args.attach.map fun ⟨a, _⟩ => expr a)
  | .addr e         => text "&" ++ operand e (expr e)
  | .member e field => operand e (expr e) ++ text ("." ++ field)
  | .arrow e field  => operand e (expr e) ++ text ("->" ++ field)
  | .cast type e    => text ("(" ++ type ++ ")") ++ operand e (expr e)
  | .binary op a b  => operand a (expr a) ++ text (" " ++ op ++ " ") ++ operand b (expr b)
  | .init []        => text "{ 0 }"
  | .init fields    =>
    let values := fields.attach.map fun ⟨(field, value), _⟩ => ("." ++ field, expr value)
    -- Only the field column is padded, so that each value can break as it needs.
    let widest := (values.map (·.1.length)).foldl max 0
    let rows := values.map fun (f, v) => text (padRight widest f ++ " = ") ++ v ++ text ","
    text "{" ++ nest 4 (hardline ++ join hardline rows) ++ hardline ++ text "}"
decreasing_by
  all_goals simp_wf
  all_goals
    first
    | have := List.sizeOf_lt_of_mem ‹_ ∈ _›; simp_all; omega
    | omega

/-- A comment: each line of `s`, after `//`, wrapped to the line width. -/
def comment (s : String) : Doc :=
  lines ((reflow (width - 3) s).map fun line => if line.isEmpty then "//" else "// " ++ line)

/-- Statements in braces, indented; no statements, just the braces. -/
def block (body : List Doc) : Doc :=
  if body.isEmpty then text "{" ++ hardline ++ text "}"
  else text "{" ++ nest 4 (hardline ++ join hardline body) ++ hardline ++ text "}"

/-- A statement. -/
def stmt : Stmt → Doc
  | .decl type name none       => text (type ++ " " ++ name ++ ";")
  | .decl type name (some e)   => text (type ++ " " ++ name ++ " = ") ++ expr e ++ text ";"
  | .expr e                    => expr e ++ text ";"
  | .ret none                  => text "return;"
  | .ret (some e)              => text "return " ++ expr e ++ text ";"
  | .comment t                 => comment t
  | .ifElse cond thenBody elseBody =>
    let thenDoc := block (thenBody.attach.map fun ⟨s, _⟩ => stmt s)
    let elseDoc := block (elseBody.attach.map fun ⟨s, _⟩ => stmt s)
    text "if (" ++ expr cond ++ text ") " ++ thenDoc
      ++ (if elseBody.isEmpty then nil else text " else " ++ elseDoc)
decreasing_by
  all_goals simp_wf
  all_goals have := List.sizeOf_lt_of_mem ‹_ ∈ _›
  all_goals omega

/--
A function's signature: its result type, name and parameters. Two or more
parameters are always laid out as a table of types and names, one per line.
-/
def signature (f : Function) : Doc :=
  let head := " ".intercalate (f.attrs ++ [f.result, f.name])
  let params := match f.params with
    | []  => text "(void)"
    | [p] => text ("(" ++ p.type ++ " " ++ p.name ++ ")")
    | ps  =>
      let rows := ps.zipIdx.map fun (p, i) =>
        [p.type, if i + 1 == ps.length then p.name else p.name ++ ","]
      text "(" ++ nest 4 (hardline ++ table rows) ++ hardline ++ text ")"
  text head ++ params

/-- A function's comment, if it has one, on the lines before it. -/
def docBefore (f : Function) : Doc :=
  if f.doc.isEmpty then nil else comment f.doc ++ hardline

/-- A function: its comment, its signature, then its body. -/
def function (f : Function) : Doc :=
  docBefore f ++ signature f ++ text " " ++ block (f.body.map stmt)

/-- A function's declaration, as in a header: its comment and signature. -/
def prototype (f : Function) : Doc :=
  docBefore f ++ signature f ++ text ";"

/-- A top-level declaration. -/
def decl : Decl → Doc
  | .pragma t                        => text ("#pragma " ++ t)
  | .include header                  => text ("#include <" ++ header ++ ">")
  | .includeLocal header             => text ("#include \"" ++ header ++ "\"")
  | .variable attrs type name init   =>
    text (" ".intercalate (attrs ++ [type, name]))
      ++ (match init with | some e => text " = " ++ expr e | none => nil) ++ text ";"
  | .prototype f                     => prototype f
  | .function f                      => function f

/-- Declarations of one kind that stay together, with no blank line between. -/
def Decl.together : Decl → Decl → Bool
  | .include _,      .include _      => true
  | .include _,      .includeLocal _ => true
  | .includeLocal _, .include _      => true
  | .includeLocal _, .includeLocal _ => true
  | .variable ..,    .variable ..    => true
  | _,               _               => false

/--
Declarations that stay together, in runs: each run is one declaration, or
several that `Decl.together` keeps together.
-/
def runs (decls : List Decl) : List (List Decl) :=
  decls.foldl (init := []) fun acc d =>
    match acc.getLast? with
    | some run =>
      if run.getLast?.any (Decl.together · d) then acc.dropLast ++ [run ++ [d]]
      else acc ++ [[d]]
    | none => [[d]]

/--
A run of declarations, one per line. A run of variables is aligned: their names
end, and their `=` signs start, in one column.
-/
def run (decls : List Decl) : Doc :=
  let heads := decls.map fun
    | .variable attrs type name _ => some (" ".intercalate (attrs ++ [type, name]))
    | _                           => none
  if heads.all (·.isSome) then
    let widest := (heads.map fun h => (h.getD "").length).foldl max 0
    join hardline ((decls.zip heads).map fun
      | (.variable _ _ _ (some e), some h) =>
        text (padRight widest h ++ " = ") ++ expr e ++ text ";"
      | (_, h) => text ((h.getD "") ++ ";"))
  else join hardline (decls.map decl)

/--
A C file: its declarations, with a blank line between each two, except that
includes stay together, and so do variables, aligned.
-/
def file (decls : List Decl) : String :=
  pretty width (join (hardline ++ hardline) ((runs decls).map run)) ++ "\n"

end WebGPUGen.Emit.C
