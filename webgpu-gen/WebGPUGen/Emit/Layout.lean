/-!
# Layout

The pieces that make generated code read well: columns aligned across a block
of lines, doc comments wrapped to the line width, and the banner that starts
every generated file. They know nothing about Lean or C beyond comment syntax.

Generated lines are at most `width` (80) characters, except where a single
word is longer.
-/

namespace WebGPUGen.Emit

/-- The width generated code is wrapped to. -/
def width : Nat := 80

/-! ## Columns -/

/-- `s` padded with spaces to `n` characters. -/
def padRight (n : Nat) (s : String) : String :=
  s ++ String.ofList (List.replicate (n - s.length) ' ')

/--
Rows of cells, with each column padded to its widest cell so the columns line
up. The last cell of a row is not padded, so no line ends in spaces.
-/
def columns (rows : List (List String)) : List String :=
  let widths (row : List String) := row.map String.length
  let widest := rows.foldl (init := []) fun acc row =>
    (List.range (max acc.length row.length)).map fun i =>
      max (acc.getD i 0) ((widths row).getD i 0)
  rows.map fun row =>
    let cells := row.zipIdx.map fun (cell, i) =>
      if i + 1 == row.length then cell else padRight (widest.getD i 0) cell
    " ".intercalate cells

/-! ## Wrapping text -/

/--
Words filled greedily into lines: the first line holds at most `first`
characters, the others at most `rest`. A word longer than its line gets a line
of its own.
-/
def fill (first rest : Nat) : List String → List String
  | []            => []
  | word :: words => go first word words
where
  /-- Fill the line `line`, which may hold `room` characters. -/
  go (room : Nat) (line : String) : List String → List String
    | []            => [line]
    | word :: words =>
      if line.length + 1 + word.length ≤ room then go room (line ++ " " ++ word) words
      else line :: go rest word words

/-- The words of `text`, split at any whitespace. -/
def words (text : String) : List String :=
  (text.splitToList Char.isWhitespace).filter (!·.isEmpty)

/--
Is `line` a Markdown link reference definition, `[label]: url`? It is kept as
written, on a line of its own.
-/
def isLinkDefinition (line : String) : Bool :=
  line.startsWith "[" && (line.splitOn "]: ").length > 1

/--
A paragraph's lines in groups: one per list item (a line starting `- ` and the
lines after it), one per link definition, and one for any other lines before
the first of those.
-/
def groups (lines : List String) : List (List String) :=
  lines.foldl (init := []) fun acc line =>
    let last := acc.getLastD []
    if line.startsWith "- " || isLinkDefinition line || acc.isEmpty
      || isLinkDefinition (last.headD "") then acc ++ [[line]]
    else acc.dropLast ++ [last ++ [line]]

/--
A group filled to `room` characters. A list item's later lines are indented
under its text.
-/
def fillGroup (room : Nat) (group : List String) : List String :=
  if isLinkDefinition (group.headD "") then group else
  let ws := words (" ".intercalate group)
  if (group.headD "").startsWith "- " then
    match fill room (room - 2) ws with
    | first :: rest => first :: rest.map ("  " ++ ·)
    | []            => []
  else fill room room ws

/--
`text`'s paragraphs filled to `room` characters, with a blank line between
paragraphs.
-/
def reflow (room : Nat) (text : String) : List String :=
  let paragraphs := (text.splitOn "\n\n").map fun p =>
    ((p.splitOn "\n").map (·.trimAscii.toString)).filter (!·.isEmpty)
  let filled := (paragraphs.filter (!·.isEmpty)).map fun p =>
    (groups p).flatMap (fillGroup room)
  [""].intercalate filled

/-! ## Doc comments -/

/--
A doc's text made safe inside a comment. Lean comments nest, so `/-` or `-/` in
the text would open or close one; escaping the `/` or `-` the Markdown way
(`/\-`, `-\/`) keeps the text as it reads.
-/
def escapeComment (text : String) : String :=
  (text.replace "/-" "/\\-").replace "-/" "-\\/"

/--
Is `doc` a placeholder rather than documentation? The spec writes `TODO` for
most entries it has not documented yet.
-/
def isPlaceholder (doc : String) : Bool :=
  let text := doc.trimAscii.toString
  text.isEmpty || text == "TODO"

/--
`doc` as a doc comment indented by `indent` spaces, in the form Lean's own
library uses: on one line if it fits, and otherwise with `/--` and `-/` on lines
of their own around the text, wrapped to the line width. No lines at all for a
placeholder.
-/
def docComment (indent : Nat) (doc : String) : List String :=
  if isPlaceholder doc then [] else
  let pad := String.ofList (List.replicate indent ' ')
  match reflow (width - indent) (escapeComment doc) with
  | [line] =>
    if indent + 4 + line.length + 3 ≤ width then [pad ++ "/-- " ++ line ++ " -/"]
    else [pad ++ "/--", pad ++ line, pad ++ "-/"]
  | lines =>
    let body := lines.map fun line => if line.isEmpty then line else pad ++ line
    [pad ++ "/--"] ++ body ++ [pad ++ "-/"]

/-! ## The banner -/

/-- Where a generated file came from. -/
structure Provenance where
  /-- The tool that wrote the file. -/
  generator    : String
  /-- When, in UTC: `2026-11-02 17:05:12 UTC`. -/
  time         : String
  /-- The generator repository's commit, abbreviated. -/
  commit       : String
  /-- Whether the generator repository had uncommitted changes. -/
  dirty        : Bool
  /-- The spec file the code was generated from. -/
  source       : String
  /-- The repository the spec file was fetched from. -/
  sourceRepo   : String
  /-- The commit of that repository the spec file was fetched at. -/
  sourceCommit : String
  deriving Repr, DecidableEq

/--
The banner that starts every generated file, as a block comment: a loud warning,
then where the file came from, one field per line.
-/
def banner (p : Provenance) : List String :=
  let rule := String.ofList (List.replicate width '=')
  let fields := columns [
    ["  Generator:",        p.generator],
    ["  Generator commit:", s!"{p.commit} ({if p.dirty then "dirty" else "clean"})"],
    ["  Generated:",        p.time],
    ["  Source:",           p.source],
    ["  Source repo:",      p.sourceRepo],
    ["  Source commit:",    p.sourceCommit]
  ]
  ["/-", rule, "  GENERATED FILE: DO NOT EDIT BY HAND", ""] ++ fields ++ [rule, "-/"]

end WebGPUGen.Emit
