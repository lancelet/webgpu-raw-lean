import WebGPUGen.Parsed

/-!
# Dumping the parsed spec

Renders parsed spec entries as compact, aligned text: what the reader
understood, in its own words. Useful for checking the decoder by eye, and for
debugging later stages. Each section is a heading followed by its entries:

```
enums
  optional_bool
    [0] (reserved)
    [1] false
```

Doc strings are left out unless `docs` is set; they then follow their entry,
each line marked with `|`. Trailing whitespace in docs is not shown.
-/

namespace WebGPUGen.Parsed
open WebGPUGen.Common

structure DumpOptions where
  docs : Bool := false

/-! ## Rendering values -/

def hex (n : Nat) : String := "0x" ++ String.ofList ((Nat.toDigits 16 n).map Char.toUpper)

end WebGPUGen.Parsed

namespace WebGPUGen.Common

/-- A value in decimal; `hex` for bitflags, where bits matter. Declared in
`Common` so that `v.render` works on the common `Value64`. -/
def Value64.render (v : Value64) (asHex : Bool := false) : String :=
  match v with
  | .int n => if asHex then Parsed.hex n.toNat else toString n
  | v => spellingOf Value64.spellings v

end WebGPUGen.Common

namespace WebGPUGen.Parsed
open WebGPUGen.Common

/-- A default, labelled with its kind so that, say, the boolean `true` and an
entry named `true` read differently. -/
def Default.render : Default → String
  | .bool b => s!"default {b}"
  | .int n => s!"default {n}"
  | .float text _ => s!"default {text}"
  | .constant name => s!"default constant.{name}"
  | .entry name _ => s!"default entry {name}"
  | .zero => "default zero-init"

/-! ## Layout -/

/-- Pad `s` with spaces to `width`. -/
def pad (s : String) (width : Nat) : String := s.pushn ' ' (width - s.length)

/-- Lay out rows of cells as aligned columns, two spaces apart, each line
indented by `indent`. A column empty in every row is dropped, and trailing
spaces are trimmed. -/
def columns (indent : Nat) (rows : List (List String)) : List String :=
  let cell (row : List String) (i : Nat) := row.getD i ""
  let count := rows.foldl (fun n row => max n row.length) 0
  let used := (List.range count).filter fun i => rows.any fun row => !(cell row i).isEmpty
  let width (i : Nat) := rows.foldl (fun w row => max w (cell row i).length) 0
  rows.map fun row =>
    let text := "  ".intercalate (used.map fun i => pad (cell row i) (width i))
    ("".pushn ' ' indent ++ text).trimAsciiEnd.toString

def nsTag (ns : Option Name) : String :=
  match ns with
  | some n => s!"namespace {n}"
  | none => ""

/-- Doc lines under an entry, if docs are wanted. -/
def docLines (o : DumpOptions) (indent : Nat) (doc : String) : List String :=
  if !o.docs || doc.isEmpty then [] else
  (doc.trimAsciiEnd.toString.splitOn "\n").map fun line =>
    ("".pushn ' ' indent ++ "| " ++ line).trimAsciiEnd.toString

/-- Aligned rows, each followed by its entry's doc lines. -/
def entryLines (o : DumpOptions) (indent : Nat) (rows : List (List String × String)) :
    List String :=
  let lines := columns indent (rows.map (·.1))
  (lines.zip rows).flatMap fun (line, (_, doc)) => line :: docLines o (indent + 2) doc

/-- A section heading and its indented entries; `(none)` if there are none. -/
def dumpSection (heading : String) (body : List String) : List String :=
  heading :: (if body.isEmpty then ["  (none)"] else body)

/-! ## Entries -/

def dumpConstants (o : DumpOptions) (cs : Array Constant) : List String :=
  dumpSection "constants" <| entryLines o 2 <| cs.toList.map fun c =>
    ([c.name.text, c.value.render, nsTag c.ns], c.doc)

def dumpTypedefs (o : DumpOptions) (ts : Array Typedef) : List String :=
  dumpSection "typedefs" <| entryLines o 2 <| ts.toList.map fun t =>
    ([t.name.text, t.type.render, nsTag t.ns], t.doc)

/-- The line naming an enum, bitflag or struct, with its doc lines. -/
def header (o : DumpOptions) (cells : List String) (doc : String) : List String :=
  entryLines o 2 [(cells, doc)]

/-- `text` if `flag` is set, otherwise an empty cell. -/
def flagTag (flag : Bool) (text : String) : String := if flag then text else ""

def dumpEnum (o : DumpOptions) (e : Enum) : List String :=
  let rows := e.entries.toList.zipIdx.map fun (entry, i) =>
    match entry with
    | none => ([s!"[{i}]", "(reserved)"], "")
    | some x =>
      let value := (x.value.map (s!"value {·}")).getD ""
      ([s!"[{i}]", x.name.text, value, nsTag x.ns], x.doc)
  header o [e.name.text, nsTag e.ns, flagTag e.extended "extended"] e.doc ++
    (if rows.isEmpty then ["    (no entries)"] else entryLines o 4 rows)

def dumpEnums (o : DumpOptions) (es : Array Enum) : List String :=
  dumpSection "enums" (es.toList.flatMap (dumpEnum o))

def dumpBitflag (o : DumpOptions) (b : Bitflag) : List String :=
  let rows := b.entries.toList.map fun x =>
    let value := (x.value.map (s!"value {·.render (asHex := true)}")).getD ""
    let combination := (x.combination.map fun names =>
      "= " ++ " | ".intercalate (names.toList.map (·.text))).getD ""
    -- Normally one or the other; both are shown if both are given.
    let definition := " ".intercalate ([value, combination].filter (!·.isEmpty))
    ([x.name.text, definition, nsTag x.ns], x.doc)
  header o [b.name.text, nsTag b.ns, flagTag b.extended "extended"] b.doc ++
    (if rows.isEmpty then ["    (no entries)"] else entryLines o 4 rows)

def dumpBitflags (o : DumpOptions) (bs : Array Bitflag) : List String :=
  dumpSection "bitflags" (bs.toList.flatMap (dumpBitflag o))

/-- How a pointer is described; empty if there is none. -/
def pointerTag : Option Pointer → String
  | some .immutable => "immutable pointer"
  | some .mutable => "mutable pointer"
  | none => ""

/-- How ownership is described; empty if not stated. -/
def ownershipTag : Option Bool → String
  | some true => "with ownership"
  | some false => "without ownership"
  | none => ""

/-- Attributes in one cell, two spaces apart, so that rows mixing different
attributes stay compact. -/
def attributeCell (attributes : List String) : String :=
  "  ".intercalate (attributes.filter (!·.isEmpty))

/-- The cells describing a parameter: name, type, then whatever else it states. -/
def Parameter.cells {Doc} (p : Parameter Doc) : List String :=
  [p.name.text, p.type.render, attributeCell [pointerTag p.pointer,
    flagTag p.optional "optional", ownershipTag p.passedWithOwnership,
    (p.default.map Default.render).getD ""]]

def dumpStruct (o : DumpOptions) (s : Struct) : List String :=
  let extended :=
    if s.extendedStructs.isEmpty then ""
    else "extends " ++ ", ".intercalate (s.extendedStructs.toList.map (·.text))
  let cells := [s.name.text, spellingOf StructKind.spellings s.kind, nsTag s.ns, extended,
    flagTag s.freeMembers "free_members"]
  let rows := s.members.toList.map fun m => (m.cells, m.doc)
  header o cells s.doc ++
    (if rows.isEmpty then ["    (no members)"] else entryLines o 4 rows)

def dumpStructs (o : DumpOptions) (ss : Array Struct) : List String :=
  dumpSection "structs" (ss.toList.flatMap (dumpStruct o))

/-! ## Callbacks, functions and objects -/

/-- Argument rows at `indent`, or `(no arguments)`. -/
def argLines (o : DumpOptions) (indent : Nat) (args : Array (Parameter Paragraph)) :
    List String :=
  if args.isEmpty then ["".pushn ' ' indent ++ "(no arguments)"]
  else entryLines o indent (args.toList.map fun a => (a.cells, a.doc.text))

def dumpCallback (o : DumpOptions) (c : Callback) : List String :=
  header o [c.name.text, spellingOf CallbackStyle.spellings c.style, nsTag c.ns] c.doc
    ++ argLines o 4 c.args

def dumpCallbacks (o : DumpOptions) (cs : Array Callback) : List String :=
  dumpSection "callbacks" (cs.toList.flatMap (dumpCallback o))

/-- `returns T` and the return's other attributes. -/
def Return.render (r : Return) : String :=
  attributeCell [s!"returns {r.type.render}", pointerTag r.pointer,
    flagTag r.optional "optional", ownershipTag r.passedWithOwnership]

/-- Functions at `indent`, their names and returns aligned as a group. Each is
followed by its docs (with docs on, a return doc is marked `Returns:`) and its
arguments, two spaces deeper. -/
def dumpFunctionList (o : DumpOptions) (indent : Nat) (fs : List Function) : List String :=
  let headers := columns indent <| fs.map fun f =>
    [f.name.text, nsTag f.ns, (f.returns.map Return.render).getD "",
      (f.callback.map (s!"callback {·}")).getD ""]
  (headers.zip fs).flatMap fun (header, f) =>
    let returnDoc := match f.returns with
      | some { doc := some d, .. } =>
        let doc := if d.text.startsWith "\n" then (d.text.drop 1).toString else d.text
        docLines o (indent + 2) s!"Returns: {doc}"
      | _ => []
    header :: docLines o (indent + 2) f.doc ++ returnDoc ++ argLines o (indent + 2) f.args

def dumpFunctions (o : DumpOptions) (fs : Array Function) : List String :=
  dumpSection "functions" (dumpFunctionList o 2 fs.toList)

def dumpObject (o : DumpOptions) (x : Object) : List String :=
  header o [x.name.text, nsTag x.ns, flagTag x.extended "extended"] x.doc ++
    (if x.methods.isEmpty then ["    (no methods)"]
     else dumpFunctionList o 4 x.methods.toList)

def dumpObjects (o : DumpOptions) (xs : Array Object) : List String :=
  dumpSection "objects" (xs.toList.flatMap (dumpObject o))

end WebGPUGen.Parsed
