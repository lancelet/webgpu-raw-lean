import Std.Data.HashMap
import WebGPUGen.Resolved
import WebGPUGen.Lowered.CNames
import WebGPUGen.Lowered.LeanNames

/-!
# Docs in Lean terms

The spec's docs are written for `webgpu.h`, in Doxygen. This turns them into
Markdown about the Lean bindings:

* `@ref X`, or `` `X` ``, where `X` is a name in `webgpu.h` with a Lean
  counterpart, becomes a code span with the Lean name: `@ref WGPUMapMode_Read`
  is `` `MapMode.read` ``. A name without one yet (constants, callback types)
  stays as a code span with its C name.
* `@ref Label`, where `Label` is a section of upstream's documentation, becomes
  a reference-style Markdown link, `[Label]`, with its definition at the end of
  the doc, so that the long URL sits on a line of its own.
* `@note` becomes `**Note:**`.
-/

namespace WebGPUGen.Lowered
open WebGPUGen.Common

/-- Upstream's documentation site, where the articles are published. -/
def docsSite : String := "https://webgpu-native.github.io/webgpu-headers"

/-! ## What the docs refer to -/

/--
The sections an article defines, each with the page it is on. An article marks
each section `{#Label}`; the first label is the article's own, and names its
page.
-/
def articleSections (article : String) : List (String × String) :=
  let labels := ((article.splitOn "{#").drop 1).filterMap fun rest =>
    match rest.splitOn "}" with
    | label :: _ :: _ => some label
    | _               => none
  match labels with
  | page :: _ => labels.map fun label => (label, page)
  | []        => []

/-- The URL of a documentation section on upstream's site. -/
def sectionUrl (label page : String) : String :=
  if label == page then s!"{docsSite}/{page}.html"
  else s!"{docsSite}/{page}.html#{label}"

/--
The Lean name of every name in `webgpu.h` that has one: types, enum entries,
flags, functions and methods.
-/
def leanNamesOfC (r : Resolved.Spec) : Std.HashMap String String :=
  let type (n : Name) := (typeName n, leanTypeName n)
  let entry (t e : Name) := (entryName t e, leanTypeName t ++ "." ++ leanName e)
  let pairs :=
    r.typedefs.toList.map (type ·.name)
      ++ r.enums.toList.flatMap (fun e =>
        type e.name :: e.entries.toList.filterMap (·.map (entry e.name ·.name)))
      ++ r.bitflags.toList.flatMap (fun b =>
        type b.name :: b.entries.toList.map (entry b.name ·.name))
      ++ r.structs.toList.map (type ·.name)
      ++ r.functions.toList.map (fun f => (functionName f.name, leanName f.name))
      ++ r.objects.toList.flatMap (fun o =>
        type o.name :: o.methods.toList.map fun m =>
          (methodName o.name m.name, leanTypeName o.name ++ "." ++ leanName m.name))
  Std.HashMap.ofList pairs

/-- What a doc is translated with: the Lean names, and the documentation sections. -/
structure DocContext where
  leanNames : Std.HashMap String String
  sections  : Std.HashMap String String
  deriving Inhabited

/-! ## Translating -/

/-- Can `c` be part of a reference's target? -/
def isTargetChar (c : Char) : Bool := c.isAlphanum || c == '_' || c == '-'

/--
A reference to `target`, and the label it links if it is a documentation
section. A member of a type, `X::member`, is named through its type.
-/
def reference (ctx : DocContext) (target : String) (member : Option String) :
    String × Option String :=
  match ctx.leanNames.get? target, member with
  | some lean, some m => (s!"`{lean}.{m}`", none)
  | some lean, none   => (s!"`{lean}`", none)
  | none,      some m => (s!"`{target}::{m}`", none)
  | none,      none   =>
    if ctx.sections.contains target then (s!"[{target}]", some target)
    else (s!"`{target}`", none)

/-- The name at the start of `text`, and the rest. -/
def takeName (text : String) : String × String :=
  let name := String.ofList (text.toList.takeWhile isTargetChar)
  (name, text.drop name.length |>.toString)

/--
References replaced, with the section labels linked, in order: `@ref X`,
`@ref X::member`, and Doxygen's `::X`, which refers to `X` too.
-/
def replaceRefs (ctx : DocContext) (doc : String) : String × List String :=
  let doc := " @ref ".intercalate (doc.splitOn " ::")
  let doc := if doc.startsWith "::" then "@ref " ++ (doc.drop 2).toString else doc
  match doc.splitOn "@ref " with
  | [] => (doc, [])  -- not reached: `splitOn` gives at least one piece
  | first :: rest =>
    rest.foldl (init := (first, [])) fun (text, labels) piece =>
      let (target, after) := takeName piece
      let (member, after) :=
        if after.startsWith "::" then
          let (m, rest) := takeName (after.drop 2).toString
          (some m, rest)
        else (none, after)
      let (shown, label?) := reference ctx target member
      (text ++ shown ++ after, labels ++ label?.toList)

/--
Code spans that are exactly a name in `webgpu.h` with a Lean counterpart, in
their Lean name. Every other code span is kept as written. A doc whose
backticks do not pair up simply (an odd count, or a double-backtick span) is
left as it is, rather than risk mistaking text for code.
-/
def replaceCodeSpans (ctx : DocContext) (doc : String) : String :=
  let pieces := doc.splitOn "`"
  if pieces.length % 2 == 0 || (doc.splitOn "``").length > 1 then doc else
  "`".intercalate (pieces.zipIdx.map fun (piece, i) =>
    if i % 2 == 1 then (ctx.leanNames.get? piece).getD piece else piece)

/-- A doc from the spec, in Lean terms. -/
def translateDoc (ctx : DocContext) (doc : String) : String :=
  let doc := replaceCodeSpans ctx doc
  let (doc, labels) := replaceRefs ctx doc
  let doc := doc.replace "@note " "**Note:** "
  let labels := labels.eraseDups
  if labels.isEmpty then doc
  else
    let definitions := labels.map fun label =>
      s!"[{label}]: {sectionUrl label ((ctx.sections.get? label).getD label)}"
    doc.trimAsciiEnd.toString ++ "\n\n" ++ "\n".intercalate definitions ++ "\n"

end WebGPUGen.Lowered
