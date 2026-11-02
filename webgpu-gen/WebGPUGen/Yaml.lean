import L4YAML.Parser.Composition

/-!
# YAML boundary

The only module that talks to the YAML library. It parses text with L4YAML and
converts the result into `Yaml.Node`, a small tree that keeps just what the spec
reader needs. Code downstream depends on `Node`, never on L4YAML, so the parser
can be replaced by changing this file alone.

`Node` deliberately drops presentation details (block vs flow style, chomping,
comments) and keeps scalars as their text: deciding that `0x0000` is a number
is the spec decoder's job, not this module's.
-/

namespace WebGPUGen.Yaml

/--
A YAML scalar: its text, and whether it was written plain (unquoted, not a
block scalar). Only plain scalars can be keywords: `null` is null, while `"null"`
and a `|` block containing `null` are strings.
-/
structure Scalar where
  text : String
  plain : Bool := true
  deriving Repr, BEq, Inhabited

/--
A YAML node, with anchors and aliases already resolved. Mapping keys are
scalars, unique, and kept in source order.
-/
inductive Node where
  | scalar (s : Scalar)
  | seq (items : Array Node)
  | map (entries : Array (String × Node))
  deriving Repr, BEq, Inhabited

/-- A failure to read YAML, from the parser or from converting its output. -/
structure Error where
  message : String
  deriving Repr, BEq

instance : ToString Error := ⟨Error.message⟩

/--
Reject an explicit tag such as `!!str`: `Node` cannot represent it, and silently
dropping it would change what the value means.
-/
private def noTag (tag : Option String) : Except Error Unit :=
  match tag with
  | some t => throw ⟨s!"explicit tag {t} is not supported"⟩
  | none => pure ()

/--
The first key that occurs twice, if any. YAML forbids duplicate keys, but L4YAML
does not check.
-/
private def duplicateKey? (entries : Array (String × Node)) : Option String :=
  go entries.toList []
where
  go : List (String × Node) → List String → Option String
    | [], _ => none
    | (k, _) :: rest, seen => if k ∈ seen then some k else go rest (k :: seen)

open L4YAML in
/--
Convert L4YAML's value into a `Node`. Fails on anything `Node` cannot represent
faithfully: tags, non-scalar keys, duplicate keys, and aliases (which
composition should already have resolved).
-/
private def ofYamlValue : YamlValue → Except Error Node
  | .scalar s => do
    noTag s.tag
    return .scalar { text := s.content, plain := s.style matches .plain }
  | .sequence _ items tag _ => do
    noTag tag
    .seq <$> items.attach.mapM fun ⟨item, _⟩ => ofYamlValue item
  | .mapping _ pairs tag _ => do
    noTag tag
    let entries ← pairs.attach.mapM fun ⟨(key, value), mem⟩ => do
      -- Termination: a pair's value is smaller than the array holding the pair.
      have : sizeOf value < sizeOf pairs := by
        have := Array.sizeOf_lt_of_mem mem; simp at this; omega
      let .scalar k := key
        | throw ⟨"mapping key is not a scalar"⟩
      noTag k.tag
      return (k.content, ← ofYamlValue value)
    if let some k := duplicateKey? entries then
      throw ⟨s!"duplicate key {k}"⟩
    return .map entries
  | .alias name => throw ⟨s!"unresolved alias *{name}"⟩

/--
Parse a YAML string holding exactly one document.

Uses L4YAML's main (non-indexed) parser, the one its soundness proofs cover. It
applies no resource limits, which is fine for our own vendored input. The "safe"
indexed parser in v0.5.2 rejects a block scalar followed by another key, which
`webgpu.yml` does throughout.
-/
def parse (input : String) : Except Error Node := do
  let docs ← match L4YAML.TokenParser.parseYaml input with
    | .ok docs => pure docs
    | .error e => throw ⟨toString e⟩
  match docs.toList with
  | [doc] => ofYamlValue doc.value
  | [] => throw ⟨"empty document"⟩
  | _ => throw ⟨s!"expected one document, found {docs.size}"⟩

/-- Read and parse a YAML file. Errors name the file. -/
def parseFile (path : System.FilePath) : IO Node := do
  match parse (← IO.FS.readFile path) with
  | .ok node => pure node
  | .error e => throw (IO.userError s!"{path}: {e}")

end WebGPUGen.Yaml
