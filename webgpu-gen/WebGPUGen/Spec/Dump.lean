import WebGPUGen.Spec

/-!
# Dumping the spec model

Renders decoded spec entries as compact, aligned text: what the reader
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

namespace WebGPUGen.Spec

structure DumpOptions where
  docs : Bool := false

/-! ## Rendering values -/

/-- The spelling of `x` in a spelling table. -/
def spellingOf {α} [BEq α] (table : List (String × α)) (x : α) : String :=
  ((table.find? (·.2 == x)).map (·.1)).getD "?"

def PrimitiveType.render : PrimitiveType → String
  | .scalar p => spellingOf Primitive.spellings p
  | .array e => s!"array<{spellingOf ArrayElement.spellings e}>"

def hex (n : Nat) : String := "0x" ++ String.ofList ((Nat.toDigits 16 n).map Char.toUpper)

/-- A value in decimal; `hex` for bitflags, where bits matter. -/
def Value64.render (v : Value64) (asHex : Bool := false) : String :=
  match v with
  | .int n => if asHex then hex n else toString n
  | v => spellingOf Value64.spellings v

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

/-- The line naming an enum or bitflag, with its doc lines. -/
def typeHeader (o : DumpOptions) (name : Name) (ns : Option Name) (extended : Bool)
    (doc : String) : List String :=
  entryLines o 2 [([name.text, nsTag ns, if extended then "extended" else ""], doc)]

def dumpEnum (o : DumpOptions) (e : Enum) : List String :=
  let rows := e.entries.toList.zipIdx.map fun (entry, i) =>
    match entry with
    | none => ([s!"[{i}]", "(reserved)"], "")
    | some x =>
      let value := (x.value.map (s!"value {·}")).getD ""
      ([s!"[{i}]", x.name.text, value, nsTag x.ns], x.doc)
  typeHeader o e.name e.ns e.extended e.doc ++ 
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
  typeHeader o b.name b.ns b.extended b.doc ++ 
    (if rows.isEmpty then ["    (no entries)"] else entryLines o 4 rows)

def dumpBitflags (o : DumpOptions) (bs : Array Bitflag) : List String :=
  dumpSection "bitflags" (bs.toList.flatMap (dumpBitflag o))

end WebGPUGen.Spec
