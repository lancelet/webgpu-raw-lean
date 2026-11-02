import WebGPUGen.Lowered
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

/-! ## The file -/

/--
The module of enums and bitflag types: the banner, the imports, then each
declaration, separated by blank lines.
-/
def enumsFile (p : Provenance) (spec : Lowered.Spec) : String :=
  let decls := spec.enums.toList.map enumDecl ++ spec.bitflags.toList.map bitflagDecl
  let lines :=
    banner p
      ++ [
        "module",
        "",
        "public import WebGPU.Raw.CEnum",
        "import WebGPU.Raw.Internal.CEnum",
        "",
        "/-!",
        "# Enums and bitflags",
        "",
        "Every enum and bitflag type in `webgpu.h`, with the codes and values it gives",
        "them.",
        "",
        "Each `c_enum` declares an enum and its `CEnum` instance: `CEnum.toC` gives a",
        "value's code in `webgpu.h`, and `CEnum.ofC?` the value a code stands for. Each",
        "bitflag type wraps its bits, with a constant per flag: combine flags with `|||`",
        "and mask them with `&&&`.",
        "-/",
        "",
        "@[expose] public section",
        "",
        "namespace WebGPU.Raw",
        ""
      ]
      ++ [""].intercalate decls
      ++ ["", "end WebGPU.Raw", "", "end"]
  "\n".intercalate lines ++ "\n"

end WebGPUGen.Emit.Lean
