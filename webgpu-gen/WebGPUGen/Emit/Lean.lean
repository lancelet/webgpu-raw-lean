import WebGPUGen.Lowered
import WebGPUGen.Lowered.CNames
import WebGPUGen.Emit.Pretty

/-!
# The Lean printer

Writes the lowered model as Lean source for the bindings package. It decides
nothing: every name and value comes from the model, and the printer only lays
them out, as `Doc`s, with `Layout`'s columns, doc comments and banner.

Enums are declared with `c_enum` (`WebGPU.Raw.Internal.CEnum`), which the
generated module imports privately so the command never reaches users of the
bindings. Bitflag types are structures around a `UInt64`, with a constant per
flag.

An enum or bitflag type that extends another spec's (`extended`) is not printed
yet: the output says so in its place. The core spec has none.
-/

namespace WebGPUGen.Emit.Lean
open WebGPUGen.Lowered WebGPUGen.Emit Doc

/-! ## Numbers -/

/--
`n` in hex with `digits` digits, upper case, as `webgpu.h` writes codes: `hex 8
1` is `0x00000001`.
-/
def hex (digits : Nat) (n : Nat) : String :=
  let ds := (Nat.toDigits 16 n).map Char.toUpper
  "0x" ++ String.ofList (List.replicate (digits - ds.length) '0' ++ ds)

/-! ## Declarations -/

/--
`doc` as a doc comment for a line indented `indent` spaces, then a new line:
nothing for a placeholder. It ends in a hard line, so a group around it never
fits: put it before a group (`docBefore i doc ++ group d`), not inside one.
-/
def docBefore (indent : Nat) (doc : String) : Doc :=
  match docLines indent doc with
  | []    => nil
  | lines => Doc.lines lines ++ hardline

/--
Rows laid out in aligned columns, each preceded by its doc comment, for lines
indented `indent` spaces.
-/
def documentedRows (indent : Nat) (rows : List (String × List String)) : Doc :=
  let laidOut := columns (rows.map (·.2))
  join hardline ((rows.zip laidOut).map fun ((doc, _), row) =>
    docBefore indent doc ++ text row)

/--
`d` on the lines after, indented `n` spaces. Make `d` with `n` too, where it
wraps text to fit the indented lines.
-/
def indented (n : Nat) (d : Doc) : Doc :=
  nest n (hardline ++ d)

/-- What stands in for a type that extends another spec's: not printed yet. -/
def notPrinted (name what : String) : Doc :=
  text s!"-- Not printed yet: {name} adds to {what} another spec defines."

/-- An enum, as a `c_enum` declaration with each value's code. -/
def enumDecl (e : Lowered.Enum) : Doc :=
  if e.extended then notPrinted e.names.lean "an enum" else
  let rows := e.entries.toList.map fun entry =>
    (entry.doc, ["|", entry.names.lean, "=", hex 8 entry.value.toNat])
  let indent := 2
  docBefore 0 e.doc ++ text s!"c_enum {e.names.lean} where"
    ++ if rows.isEmpty then nil
       else indented indent (documentedRows indent rows)

/--
A bitflag type, as a structure around its bits with a constant per flag,
and `|||` and `&&&` to combine and mask them.
-/
def bitflagDecl (b : Lowered.Bitflag) : Doc :=
  let type := b.names.lean
  if b.extended then notPrinted type "a bitflag type" else
  let header := Doc.lines [
    s!"structure {type} where",
    "  bits : UInt64",
    "  deriving Repr, DecidableEq, Inhabited"
  ]
  let flags := b.flags.toList.map fun flag =>
    let value := s!"⟨{hex 16 flag.value.toNat}⟩"
    (flag.doc, ["def", flag.names.lean, ":", type, ":=", value])
  let instances := table [
    ["instance :", s!"OrOp {type}", ":= ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩"],
    ["instance :", s!"AndOp {type}", ":= ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩"]
  ]
  let blocks :=
    [header, text s!"namespace {type}"]
      ++ (if flags.isEmpty then [] else [documentedRows 0 flags])
      ++ [instances, text s!"end {type}"]
  docBefore 0 b.doc ++ join (hardline ++ hardline) blocks

/-! ## Signatures -/

/-- An explicit parameter: its name and its type. -/
structure Binder where
  name : String
  type : String

/-- A declaration's head: its keyword, its name, its parameters and its type. -/
structure Signature where
  keyword : String
  name    : String
  binders : List Binder
  result  : String

/--
A signature on one line if it fits, counting the text before and after it on
that line, and otherwise broken: each parameter on a line of its own, their `:`
aligned, and the result type on the line after the last, all indented four
spaces.

    opaque Device.createBuffer
        (device     : @& Device)
        (descriptor : @& BufferDescriptor) :
        IO Buffer

The result type on a line of its own, after a `:` ending the line before, is
how Lean's style guides move it; the parameters, one per line and aligned, are
this project's layout (Lean's guides fill them several to a line). A parameter
or result type is never broken itself, so a very long one makes its line longer
than the width.
-/
def signature (s : Signature) : Doc :=
  let head := s.keyword ++ " " ++ s.name
  let params := s.binders.map fun b => s!" ({b.name} : {b.type})"
  let flat := text (head ++ String.join params ++ " : " ++ s.result)
  let cells := s.binders.map fun b => ["(" ++ b.name, ": " ++ b.type ++ ")"]
  let rows := columns cells
  let broken := match rows.getLast? with
    | none      => text (head ++ " :") ++ indented 4 (text s.result)
    | some last =>
      text head
        ++ indented 4 (Doc.lines (rows.dropLast ++ [last ++ " :"]) ++ hardline
          ++ text s.result)
  alt flat broken

/-! ## Objects -/

/-- An object type, as a `c_object` declaration. -/
def objectDecl (o : Lowered.Object) : Doc :=
  docBefore 0 o.doc ++ text s!"c_object {o.names.lean}"

/--
The bindings' start-up: registers the object types' classes on the C side,
before a program's `main` runs. `builtin_initialize`, unlike `initialize`, does
not run when the compiler imports the module, where there is no C code to call.
-/
def objectsStartup : Doc := Doc.lines [
  "namespace Internal",
  "",
  "/-- Register the object types' classes, so the C side can box handles. -/",
  s!"@[extern \"{objectsInitName}\"]",
  "private opaque startObjects : IO Unit",
  "",
  "builtin_initialize startObjects",
  "",
  "end Internal"
]

/-! ## Files -/

/--
Does `d` print on one line, at the margin? (Declarations always start there.)
-/
def isOneLine (d : Doc) : Bool :=
  !(pretty width d).contains '\n'

/--
Declarations one after another, with a blank line between them, except that
consecutive one-line declarations stay together.
-/
def joinDecls : List Doc → Doc
  | []      => nil
  | d :: ds => d ++ go (isOneLine d) ds
where
  /-- The rest, after a declaration that was one line if `previous`. -/
  go (previous : Bool) : List Doc → Doc
    | []      => nil
    | d :: ds =>
      let oneLine := isOneLine d
      let sep := if previous && oneLine then hardline else hardline ++ hardline
      sep ++ d ++ go oneLine ds

/--
A generated module: the banner, the module header with its imports, the module
doc, then the declarations in `WebGPU.Raw`, laid out by `joinDecls`. Its
declarations are public, and its definitions exposed, so that users can compute
with them.
-/
def moduleFile (p : Provenance) (imports doc : List String) (decls : List Doc) :
    String :=
  let blocks := [
    Doc.lines (banner p ++ ["module"]),
    Doc.lines imports,
    Doc.lines (["/-!"] ++ doc ++ ["-/"]),
    text "@[expose] public section",
    text "namespace WebGPU.Raw"
  ] ++ (if decls.isEmpty then [] else [joinDecls decls]) ++ [
    text "end WebGPU.Raw",
    text "end"
  ]
  pretty width (join (hardline ++ hardline) blocks) ++ "\n"

/-- The module of enums and bitflag types. -/
def enumsFile (p : Provenance) (spec : Lowered.Spec) : String :=
  moduleFile p
    [
      "public import WebGPU.Raw.CEnum",
      "import WebGPU.Raw.Internal.CEnum"
    ]
    [
      "# Enums and bitflags",
      "",
      "Every enum and bitflag type in `webgpu.h`, with the codes and values it gives",
      "them.",
      "",
      "Each `c_enum` declares an enum and its `CEnum` instance: `CEnum.toC` gives a",
      "value's code in `webgpu.h`, and `CEnum.ofC?` the value a code stands for. Each",
      "bitflag type wraps its bits, with a constant per flag: combine flags with `|||`",
      "and mask them with `&&&`."
    ]
    (spec.enums.toList.map enumDecl ++ spec.bitflags.toList.map bitflagDecl)

/-- The module of object types. -/
def objectsFile (p : Provenance) (spec : Lowered.Spec) : String :=
  moduleFile p
    [
      "import WebGPU.Raw.Internal.CObject"
    ]
    [
      "# Objects",
      "",
      "Every object type in `webgpu.h`. Each `c_object` declares an opaque type: Lean",
      "code can hold a handle to the object and pass it on, but only the C side can",
      "make one or look inside it."
    ]
    (spec.objects.toList.map objectDecl ++ [objectsStartup])

end WebGPUGen.Emit.Lean
