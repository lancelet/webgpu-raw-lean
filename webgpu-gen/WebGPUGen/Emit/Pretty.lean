import WebGPUGen.Emit.Layout

/-!
# Pretty printing

A small pretty printer in the style of Wadler's "A prettier printer": a `Doc`
describes text with places where a line may break, and printing it to a width
breaks only the groups that do not fit.

Lean's own `Std.Format` is built the same way, but each of its breaks becomes a
space when its group fits. Code needs a second kind, which becomes nothing:

    f(a, b)        — the group fits

    f(             — it does not
        a,
        b
    )

so `Doc` has both: `space` (a space or a new line) and `softline` (nothing or a
new line), and `hardline`, which always breaks. `alt` chooses between two
layouts of the same thing, such as a list on one line or as an aligned table.

Printing is total, linear in the size of the output, and needs no stack: it
takes the document apart a node at a time, and builds the text as it goes.
-/

namespace WebGPUGen.Emit

/-- A document: text, with places where a line may break. -/
inductive Doc where
  /-- Nothing. -/
  | nil
  /-- Text, which never breaks. It has no new lines: `Doc.ofString` splits them. -/
  | text (s : String)
  /-- A line break, printed as `flat` when its group fits on the line. -/
  | line (flat : String)
  /-- A line break that is always taken. Its groups never fit on one line. -/
  | hardline
  /-- `d`, with lines that break indented `n` more. -/
  | nest (n : Nat) (d : Doc)
  /-- One document after the other. -/
  | concat (a b : Doc)
  /-- `d`'s breaks, all taken or none: none if `d` fits on the rest of the line. -/
  | group (d : Doc)
  /--
  `flat` if it fits on the rest of the line, otherwise `broken`: two layouts of
  the same thing, such as a list on one line or as an aligned table.
  -/
  | alt (flat broken : Doc)
  deriving Repr, Inhabited

namespace Doc

instance : Append Doc := ⟨concat⟩

/-- A break that is a space when its group fits. -/
def space : Doc := line " "

/-- A break that is nothing when its group fits. -/
def softline : Doc := line ""

/-- The documents one after the other, `sep` between each two. -/
def join (sep : Doc) : List Doc → Doc
  | []      => nil
  | [d]     => d
  | d :: ds => d ++ sep ++ join sep ds

/-- Text that may have new lines: each becomes a `hardline`. -/
def ofString (s : String) : Doc :=
  join hardline ((s.splitOn "\n").map text)

instance : Coe String Doc := ⟨ofString⟩

/-- Lines of text, each on a line of its own. -/
def lines (ls : List String) : Doc :=
  join hardline (ls.map ofString)

/--
Rows of cells, laid out as a table: each column padded to its widest cell, so
the columns line up (`Layout`'s `columns`). It indents with the document around
it. Its cells never break, and its rows are separated by hard lines, so a
group around a table of more than one row always breaks.
-/
def table (rows : List (List String)) : Doc :=
  lines (columns rows)

/-- How much a document is made of: printing takes it apart a node at a time. -/
def size : Doc → Nat
  | nest _ d   => size d + 1
  | concat a b => size a + size b + 1
  | group d    => size d + 1
  | alt a b    => size a + size b + 1
  | _          => 1

/-! ## Printing -/

/-- A document still to print: its indent, whether its group is flat, and it. -/
abbrev Item := Nat × Bool × Doc

/-- The size of everything still to print. -/
def itemsSize (items : List Item) : Nat :=
  (items.map fun (_, _, d) => d.size).sum

/--
Does printing `items` fit in `room` characters before the first line break that
is taken? The group being decided is the first item, marked flat; the rest
carry their own marks, and the first taken break among them ends the check.
-/
def fits (room : Int) (items : List Item) : Bool :=
  if room < 0 then false else
  match items with
  | []                          => true
  | (_, _, .nil) :: rest        => fits room rest
  | (_, _, .text s) :: rest     => fits (room - s.length) rest
  | (_, true, .line f) :: rest  => fits (room - f.length) rest
  | (_, false, .line _) :: _    => true
  | (_, true, .hardline) :: _   => false
  | (_, false, .hardline) :: _  => true
  | (i, b, .nest n d) :: rest   => fits room ((i + n, b, d) :: rest)
  | (i, b, .concat x y) :: rest => fits room ((i, b, x) :: (i, b, y) :: rest)
  | (i, b, .group d) :: rest    => fits room ((i, b, d) :: rest)
  | (i, true, .alt a _) :: rest  => fits room ((i, true, a) :: rest)
  | (i, false, .alt _ b) :: rest => fits room ((i, false, b) :: rest)
termination_by itemsSize items
decreasing_by
  all_goals simp [itemsSize, size]
  all_goals omega

/-- The spaces that indent a new line by `i`. -/
def indentation (i : Nat) : String := String.ofList (List.replicate i ' ')

/--
Print `items` after the text `out`, whose last line is `col` characters long,
in lines of at most `width` characters where the breaks allow.
-/
def render (width : Nat) (out : String) (col : Nat) : List Item → String
  | []                             => out
  | (_, _, .nil) :: rest           => render width out col rest
  | (_, _, .text s) :: rest        => render width (out ++ s) (col + s.length) rest
  | (i, flat, .line f) :: rest     =>
    if flat then render width (out ++ f) (col + f.length) rest
    else render width (out ++ "\n" ++ indentation i) i rest
  | (i, _, .hardline) :: rest      => render width (out ++ "\n" ++ indentation i) i rest
  | (i, flat, .nest n d) :: rest   => render width out col ((i + n, flat, d) :: rest)
  | (i, flat, .concat a b) :: rest => render width out col ((i, flat, a) :: (i, flat, b) :: rest)
  | (i, flat, .group d) :: rest    =>
    let flat := flat || fits (width - col) ((i, true, d) :: rest)
    render width out col ((i, flat, d) :: rest)
  | (i, flat, .alt a b) :: rest    =>
    if flat || fits (width - col) ((i, true, a) :: rest) then
      render width out col ((i, true, a) :: rest)
    else render width out col ((i, false, b) :: rest)
termination_by items => itemsSize items
decreasing_by
  all_goals simp [itemsSize, size]
  all_goals omega

/--
`d` printed in lines of at most `width` characters where its breaks allow, with
no spaces at the ends of lines.
-/
def pretty (width : Nat) (d : Doc) : String :=
  let text := render width "" 0 [(0, false, d)]
  "\n".intercalate ((text.splitOn "\n").map (·.trimAsciiEnd.toString))

end Doc

end WebGPUGen.Emit
