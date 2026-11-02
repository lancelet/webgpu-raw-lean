import WebGPUGen.Lowered
import WebGPUGen.Lowered.CNames
import WebGPUGen.Emit.Layout

/-!
# The Lean printer

Writes the lowered model as Lean source for the bindings package. It decides
nothing: every name and value comes from the model, and the printer only lays
them out, with `Layout`'s columns, doc comments and banner.

Enums are declared with `c_enum` (`WebGPU.Raw.Internal.CEnum`), which the
generated module imports privately so the command never reaches users of the
bindings. Bitflag types are structures around a `UInt64`, with a constant per
flag.

An enum or bitflag type that extends another spec's (`extended`) is not printed
yet: the output says so in its place. The core spec has none.
-/

namespace WebGPUGen.Emit.Lean
open WebGPUGen.Lowered WebGPUGen.Emit

/-! ## Numbers -/

/--
`n` in hex with `digits` digits, upper case, as `webgpu.h` writes codes: `hex 8
1` is `0x00000001`.
-/
def hex (digits : Nat) (n : Nat) : String :=
  let ds := (Nat.toDigits 16 n).map Char.toUpper
  "0x" ++ String.ofList (List.replicate (digits - ds.length) '0' ++ ds)

/-! ## Declarations -/

/-- Rows laid out in aligned columns, each preceded by its doc comment. -/
def documentedRows (indent : Nat) (rows : List (String × List String)) : List String :=
  let pad := String.ofList (List.replicate indent ' ')
  let lines := columns (rows.map (·.2))
  (rows.zip lines).flatMap fun ((doc, _), line) => docComment indent doc ++ [pad ++ line]

/-- What stands in for a type that extends another spec's: not printed yet. -/
def notPrinted (name what : String) : List String :=
  [s!"-- Not printed yet: {name} adds to {what} another spec defines."]

/-- An enum, as a `c_enum` declaration with each value's code. -/
def enumDecl (e : Lowered.Enum) : List String :=
  if e.extended then notPrinted e.names.lean "an enum" else
  docComment 0 e.doc
    ++ [s!"c_enum {e.names.lean} where"]
    ++ documentedRows 2 (e.entries.toList.map fun entry =>
      (entry.doc, ["|", entry.names.lean, "=", hex 8 entry.value.toNat]))

/--
A bitflag type, as a structure around its bits with a constant per flag,
and `|||` and `&&&` to combine and mask them.
-/
def bitflagDecl (b : Lowered.Bitflag) : List String :=
  let type := b.names.lean
  if b.extended then notPrinted type "a bitflag type" else
  docComment 0 b.doc
    ++ [
      s!"structure {type} where",
      "  bits : UInt64",
      "  deriving Repr, DecidableEq, Inhabited",
      "",
      s!"namespace {type}",
      ""
    ]
    ++ documentedRows 0 (b.flags.toList.map fun flag =>
      (flag.doc, ["def", flag.names.lean, ":", type, ":=", s!"⟨{hex 16 flag.value.toNat}⟩"]))
    ++ [""]
    ++ columns [
      ["instance :", s!"OrOp {type}", ":= ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩"],
      ["instance :", s!"AndOp {type}", ":= ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩"]
    ]
    ++ ["", s!"end {type}"]

/-! ## Objects -/

/-- An object type, as a `c_object` declaration. -/
def objectDecl (o : Lowered.Object) : List String :=
  docComment 0 o.doc ++ [s!"c_object {o.names.lean}"]

/--
The bindings' start-up: registers the object types' classes on the C side,
before a program's `main` runs. `builtin_initialize`, unlike `initialize`, does
not run when the compiler imports the module, where there is no C code to call.
-/
def objectsStartup : List String := [
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
Declarations one after another, with a blank line between them, except that
consecutive one-line declarations stay together.
-/
def joinDecls (decls : List (List String)) : List String :=
  (decls.zip ([] :: decls)).flatMap fun (decl, previous) =>
    if previous.isEmpty || (decl.length == 1 && previous.length == 1) then decl
    else "" :: decl

/--
A generated module: the banner, the module header with its imports, the module
doc, then the declarations in `WebGPU.Raw`, laid out by `joinDecls`. Its
declarations are public, and its definitions exposed, so that users can compute
with them.
-/
def moduleFile (p : Provenance) (imports doc : List String) (decls : List (List String)) :
    String :=
  let lines :=
    banner p
      ++ ["module", ""] ++ imports ++ [""]
      ++ ["/-!"] ++ doc ++ ["-/", ""]
      ++ ["@[expose] public section", "", "namespace WebGPU.Raw", ""]
      ++ joinDecls decls
      ++ ["", "end WebGPU.Raw", "", "end"]
  "\n".intercalate lines ++ "\n"

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
