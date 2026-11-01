import WebGPUGen.Decode
import WebGPUGen.Spec

/-!
# Decoding the spec model

Decoders from YAML nodes to the types in `WebGPUGen.Spec`. Each follows the
matching definition in `schema.json`, and mapping decoders read fields in the
schema's order.
-/

namespace WebGPUGen.Spec
open WebGPUGen.Yaml WebGPUGen.Decode

/-! ## Names and spellings -/

/-- Does `s` match `^[a-zA-Z0-9]([a-zA-Z0-9_]*[a-zA-Z0-9])?$`? -/
def isName (s : String) : Bool :=
  !s.isEmpty
    && s.all (fun c => c.isAlphanum || c == '_')
    && !s.startsWith "_"
    && !s.endsWith "_"

def Name.ofString (s : String) : Decode Name :=
  if isName s then pure ⟨s⟩ else fail s!"invalid name {s.quote}"

def Name.decode (node : Node) : Decode Name :=
  string node >>= Name.ofString

/-- Look `s` up in a table of spellings; `what` names the table in errors. -/
def spelled {α} (what : String) (table : List (String × α)) (s : String) : Decode α :=
  match table.lookup s with
  | some a => pure a
  | none => fail s!"unknown {what} {s.quote}"

/-! ## Types -/

/-- The text inside `array<…>`, if `s` has that form. -/
def arrayElement? (s : String) : Option String :=
  if s.startsWith "array<" && s.endsWith ">" then
    some (((s.drop 6).dropEnd 1).toString)
  else none

/-- A reference `kind.name`, if `s` starts with a reference kind and a dot. -/
def parseRef? (s : String) : Option (Decode (RefKind × Name)) :=
  match s.splitOn "." with
  | [kind, name] =>
    (RefKind.spellings.lookup kind).map fun k => do
      return (k, ← Name.ofString name)
  | _ => none

def PrimitiveType.ofString (s : String) : Decode PrimitiveType :=
  match arrayElement? s with
  | some e => .array <$> spelled "array element type" ArrayElement.spellings e
  | none => .scalar <$> spelled "primitive type" Primitive.spellings s

/-- The name in `callback.name`, if `s` has that form. -/
def callbackRef? (s : String) : Option String :=
  if s.startsWith "callback." then some ((s.drop 9).toString) else none

/-- Parse a `type:` string. A string that is not a reference or a callback must
be a primitive type. -/
def TypeRef.ofString (s : String) : Decode TypeRef := do
  if let some inner := arrayElement? s then
    if let some reference := parseRef? inner then
      let (kind, name) ← reference
      return .refArray kind name
  if let some name := callbackRef? s then
    return .callback (← Name.ofString name)
  if let some reference := parseRef? s then
    let (kind, name) ← reference
    return .ref kind name
  -- A dot outside `array<…>` means a reference was intended; say so.
  if (arrayElement? s).isNone && s.contains '.' then
    fail s!"invalid type reference {s.quote}"
  .primitive <$> PrimitiveType.ofString s

def PrimitiveType.decode (node : Node) : Decode PrimitiveType :=
  string node >>= PrimitiveType.ofString

def TypeRef.decode (node : Node) : Decode TypeRef :=
  string node >>= TypeRef.ofString

/-! ## Values -/

def Value64.decode (node : Node) : Decode Value64 := do
  match ← value node with
  | .int n =>
    if 0 ≤ n && n < 2 ^ 64 then pure (.int n.toNat)
    else fail s!"integer {n} does not fit in 64 bits"
  | .str s => spelled "constant value" Value64.spellings s
  | v => fail s!"expected an integer or a named value, found {v.describe}"

def Default.decode (node : Node) : Decode Default := do
  match ← value node with
  | .bool b => pure (.bool b)
  | .int n => pure (.int n)
  | .float t => pure (.float t)
  | .str "zero" => pure .zero
  | .str s =>
    if s.startsWith "constant." then
      .constant <$> Name.ofString ((s.drop 9).toString)
    else if let some n := parseInt? s then
      pure (.int n)
    else
      .entry <$> Name.ofString s
  | .null => fail "expected a default value, found null"

/-! ## Entries -/

def Constant.decode : Node → Decode Constant :=
  object do
    let name  ← field  "name"      Name.decode
    let ns    ← field? "namespace" Name.decode
    let value ← field  "value"     Value64.decode
    let doc   ← field  "doc"       string
    return { name, ns, value, doc }

def Typedef.decode : Node → Decode Typedef :=
  object do
    let name ← field  "name"      Name.decode
    let ns   ← field? "namespace" Name.decode
    let doc  ← field  "doc"       string
    let type ← field  "type"      PrimitiveType.decode
    return { name, ns, doc, type }

/-! ## Enums and bitflags -/

/-- `Value16`: an integer that fits in 16 bits. -/
def value16 (node : Node) : Decode Nat := do
  let n ← nat node
  if n < 2 ^ 16 then pure n else fail s!"integer {n} does not fit in 16 bits"

def EnumEntry.decode : Node → Decode EnumEntry :=
  object do
    let name  ← field  "name"      Name.decode
    let ns    ← field? "namespace" Name.decode
    let doc   ← field  "doc"       string
    let value ← field? "value"     value16
    return { name, ns, doc, value }

def Enum.decode : Node → Decode Enum :=
  object do
    let name     ← field  "name"      Name.decode
    let ns       ← field? "namespace" Name.decode
    let doc      ← field  "doc"       string
    let extended ← field? "extended"  bool
    let entries  ← field? "entries"   (seq (nullable EnumEntry.decode))
    return {
      name,
      ns,
      doc,
      extended := extended.getD false,
      entries  := entries.getD #[]
    }

def BitflagEntry.decode : Node → Decode BitflagEntry :=
  object do
    let name        ← field  "name"              Name.decode
    let ns          ← field? "namespace"         Name.decode
    let doc         ← field  "doc"               string
    let value       ← field? "value"             Value64.decode
    let combination ← field? "value_combination" (seq Name.decode)
    return { name, ns, doc, value, combination }

def Bitflag.decode : Node → Decode Bitflag :=
  object do
    let name     ← field  "name"      Name.decode
    let ns       ← field? "namespace" Name.decode
    let doc      ← field  "doc"       string
    let extended ← field? "extended"  bool
    let entries  ← field? "entries"   (seq BitflagEntry.decode)
    return {
      name,
      ns,
      doc,
      extended := extended.getD false,
      entries  := entries.getD #[]
    }

/-! ## Structs -/

def Pointer.decode (node : Node) : Decode Pointer :=
  string node >>= spelled "pointer" Pointer.spellings

def StructKind.decode (node : Node) : Decode StructKind :=
  string node >>= spelled "struct type" StructKind.spellings

def Parameter.decode : Node → Decode Parameter :=
  object do
    let name                ← field  "name"                  Name.decode
    let doc                 ← field  "doc"                   string
    let type                ← field  "type"                  TypeRef.decode
    let passedWithOwnership ← field? "passed_with_ownership" bool
    let pointer             ← field? "pointer"               Pointer.decode
    let optional            ← field? "optional"              bool
    let default             ← field? "default"               Default.decode
    return {
      name,
      doc,
      type,
      passedWithOwnership,
      pointer,
      optional := optional.getD false,
      default
    }

def Struct.decode : Node → Decode Struct :=
  object do
    let name            ← field  "name"         Name.decode
    let ns              ← field? "namespace"    Name.decode
    let doc             ← field  "doc"          string
    let kind            ← field  "type"         StructKind.decode
    let extendedStructs ← field? "extends"      (seq Name.decode)
    let freeMembers     ← field? "free_members" bool
    let members         ← field? "members"      (seq Parameter.decode)
    return {
      name,
      ns,
      doc,
      kind,
      extendedStructs := extendedStructs.getD #[],
      freeMembers     := freeMembers.getD false,
      members         := members.getD #[]
    }

/-! ## Callbacks, functions and objects -/

/-- Does `doc` match `^\n?.+(\n.+)*\n?$`: one or more non-empty lines, with at
most one line break before and after? The schema requires this of argument and
return docs, which Doxygen cannot show as several paragraphs. -/
def isSingleParagraph (doc : String) : Bool :=
  let body := if doc.startsWith "\n" then (doc.drop 1).toString else doc
  let body := if body.endsWith "\n" then (body.dropEnd 1).toString else body
  !body.isEmpty && (body.splitOn "\n").all (!·.isEmpty)

/-- A single-paragraph doc; `allowEmpty` also accepts `""`. -/
def paragraph (allowEmpty : Bool) (node : Node) : Decode String := do
  let doc ← string node
  if (allowEmpty && doc.isEmpty) || isSingleParagraph doc then pure doc
  else fail "expected a single-paragraph doc"

/-- A function or callback argument (`FunctionParameterType`): a `Parameter`
whose doc is a single paragraph. -/
def FunctionParameter.decode (node : Node) : Decode Parameter := do
  let p ← Parameter.decode node
  if isSingleParagraph p.doc then pure p
  else within "doc" (fail "expected a single-paragraph doc")

def CallbackStyle.decode (node : Node) : Decode CallbackStyle :=
  string node >>= spelled "callback style" CallbackStyle.spellings

/-- `callback.name`, as a function's `callback` field writes it. -/
def callbackName (node : Node) : Decode Name := do
  let s ← string node
  match callbackRef? s with
  | some name => Name.ofString name
  | none => fail s!"expected callback.<name>, found {s.quote}"

def Callback.decode : Node → Decode Callback :=
  object do
    let name  ← field  "name"      Name.decode
    let ns    ← field? "namespace" Name.decode
    let doc   ← field  "doc"       string
    let style ← field  "style"     CallbackStyle.decode
    let args  ← field? "args"      (seq FunctionParameter.decode)
    return {
      name,
      ns,
      doc,
      style,
      args := args.getD #[]
    }

def Return.decode : Node → Decode Return :=
  object do
    let doc                 ← field  "doc"                   (paragraph (allowEmpty := true))
    let type                ← field  "type"                  TypeRef.decode
    let optional            ← field? "optional"              bool
    let passedWithOwnership ← field? "passed_with_ownership" bool
    let pointer             ← field? "pointer"               Pointer.decode
    return {
      doc,
      type,
      optional := optional.getD false,
      passedWithOwnership,
      pointer
    }

def Function.decode : Node → Decode Function :=
  object do
    let name     ← field  "name"      Name.decode
    let ns       ← field? "namespace" Name.decode
    let doc      ← field  "doc"       string
    let returns  ← field? "returns"   Return.decode
    let callback ← field? "callback"  callbackName
    let args     ← field? "args"      (seq FunctionParameter.decode)
    return {
      name,
      ns,
      doc,
      returns,
      callback,
      args := args.getD #[]
    }

/-- The schema lists no required fields for objects; like upstream's generator,
this requires `name` and `doc`, as for every other entry. -/
def Object.decode : Node → Decode Object :=
  object do
    let name     ← field  "name"      Name.decode
    let ns       ← field? "namespace" Name.decode
    let doc      ← field  "doc"       string
    let extended ← field? "extended"  bool
    let methods  ← field? "methods"   (seq Function.decode)
    return {
      name,
      ns,
      doc,
      extended := extended.getD false,
      methods  := methods.getD #[]
    }

end WebGPUGen.Spec
