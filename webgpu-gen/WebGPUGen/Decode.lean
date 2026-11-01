import WebGPUGen.CoreSchema

/-!
# Decoding YAML into typed values

A small toolkit for turning a `Yaml.Node` into the spec model. Decoders track
where they are, so an error reads `structs[12].members[3].default: expected a
boolean, found integer 1` rather than just the message.

Mappings are decoded strictly: every key must be read by the decoder, and any
key left over is an error. This mirrors `additionalProperties: false` in
`schema.json`, so a key added upstream cannot be silently ignored.
-/

namespace WebGPUGen.Decode
open WebGPUGen.Yaml

/-- A decoding failure and where it happened. -/
structure DecodeError where
  /-- Keys and indices from the root, e.g. `#["structs", "[12]", "name"]`. -/
  path : Array String
  message : String
  deriving Repr, BEq

/-- The path written as `structs[12].name`. -/
def DecodeError.location (e : DecodeError) : String :=
  e.path.foldl (init := "") fun acc seg =>
    if acc.isEmpty || seg.startsWith "[" then acc ++ seg else acc ++ "." ++ seg

instance : ToString DecodeError where
  toString e := if e.path.isEmpty then e.message else s!"{e.location}: {e.message}"

/-- A decoder: reads the current path, may fail. -/
abbrev Decode := ReaderT (Array String) (Except DecodeError)

/-- Run a decoder from the root. -/
def Decode.run {α} (d : Decode α) : Except DecodeError α := ReaderT.run d #[]

/-- Fail at the current path. -/
def fail {α} (message : String) : Decode α := do
  throw { path := ← read, message }

/-- Run `d` one step further down the path. -/
def within {α} (segment : String) (d : Decode α) : Decode α :=
  withReader (·.push segment) d

/-- How a node is named in error messages. -/
def describe : Node → String
  | .scalar s => s.value.describe
  | .seq _ => "a sequence"
  | .map _ => "a mapping"

/-! ## Scalars -/

/-- Any scalar, interpreted by the core schema. -/
def value : Node → Decode Value
  | .scalar s => pure s.value
  | node => fail s!"expected a scalar, found {describe node}"

def string (node : Node) : Decode String := do
  match ← value node with
  | .str s => pure s
  | v => fail s!"expected a string, found {v.describe}"

def bool (node : Node) : Decode Bool := do
  match ← value node with
  | .bool b => pure b
  | v => fail s!"expected a boolean, found {v.describe}"

/-- A non-negative integer. -/
def nat (node : Node) : Decode Nat := do
  match ← value node with
  | .int n =>
    if n < 0 then fail s!"expected a non-negative integer, found {n}" else pure n.toNat
  | v => fail s!"expected an integer, found {v.describe}"

/-- Look `s` up in a table of spellings; `what` names the table in errors. -/
def spelled {α} (what : String) (table : List (String × α)) (s : String) : Decode α :=
  match table.lookup s with
  | some a => pure a
  | none => fail s!"unknown {what} {s.quote}"

/-- `none` for a null scalar, otherwise `decode`. For entries such as enum
slots that the spec reserves with a bare `null`. -/
def nullable {α} (decode : Node → Decode α) (node : Node) : Decode (Option α) :=
  match node with
  | .scalar s => if s.value == .null then pure none else some <$> decode node
  | _ => some <$> decode node

/-! ## Collections -/

/-- Decode a list of items, numbering paths `[start]`, `[start+1]`, …. -/
def items {α} (item : Node → Decode α) : Nat → List Node → Decode (List α)
  | _, [] => pure []
  | i, n :: ns => do
    let a ← within s!"[{i}]" (item n)
    let as ← items item (i + 1) ns
    pure (a :: as)

/-- A sequence, decoding each item with `item`. Paths gain `[i]`. -/
def seq {α} (item : Node → Decode α) : Node → Decode (Array α)
  | .seq ns => List.toArray <$> items item 0 ns.toList
  | node => fail s!"expected a sequence, found {describe node}"

/-- Reads the fields of one mapping. The state holds the entries not yet read;
each field read removes its entry. -/
abbrev Fields := StateT (List (String × Node)) Decode

/-- Remove and return the entry for `key`, if present. Keys are unique. -/
def take? (key : String) : Fields (Option Node) := fun entries =>
  pure ((entries.find? (·.1 == key)).map (·.2), entries.filter (·.1 != key))

/-- A required field. -/
def field {α} (key : String) (decode : Node → Decode α) : Fields α := do
  match ← take? key with
  | some node => within key (decode node)
  | none => fail s!"missing field {key}"

/-- An optional field. -/
def field? {α} (key : String) (decode : Node → Decode α) : Fields (Option α) := do
  match ← take? key with
  | some node => some <$> within key (decode node)
  | none => pure none

/-- Decode a mapping with `fields`, failing on any key it did not read. -/
def object {α} (fields : Fields α) : Node → Decode α
  | .map entries => do
    let (result, unread) ← fields.run entries.toList
    if let (key, _) :: _ := unread then
      fail s!"unknown field {key}"
    pure result
  | node => fail s!"expected a mapping, found {describe node}"

end WebGPUGen.Decode
