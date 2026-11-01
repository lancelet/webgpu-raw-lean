import WebGPUGen.Codec
import WebGPUGen.Parsed

/-!
# Codecs for the parsed spec

How each type in `WebGPUGen.Parsed`, and each common type it uses, is written to
and read from YAML. Only the parsed spec is read from YAML, so the codecs for
common types live here too. Each follows the matching definition in
`schema.json`. Records are assembled from the combinators in `WebGPUGen.Codec`,
so they need no proofs of their own. The hand-written text formats (type
strings, `callback.x`, string defaults) have short proofs here, done on
character lists with the lemmas in `WebGPUGen.Text`.

`Spec.codec.roundTrip` is the headline result: decoding an encoded spec gives
back exactly that spec.
-/

namespace WebGPUGen.Parsed
open WebGPUGen.Common
open WebGPUGen.Yaml WebGPUGen.Decode WebGPUGen.Codec WebGPUGen.Text

/-! ## Names and docs -/

def Name.ofString (s : String) : Decode Name :=
  if h : isName s then pure ⟨s, h⟩ else fail s!"invalid name {s.quote}"

theorem Name.ofString_text (n : Name) (path : Array String) :
    Name.ofString n.text path = .ok n := by
  simp [Name.ofString, n.valid]; rfl

def Name.codec : Codec Name where
  encode n := string.encode n.text
  decode node := Decode.string node >>= Name.ofString
  roundTrip n path := by
    have h : Decode.string (string.encode n.text) path = .ok n.text := string.roundTrip _ _
    rw [bind_ok h, Name.ofString_text]

def Paragraph.ofString (s : String) : Decode Paragraph :=
  if h : isSingleParagraph s then pure ⟨s, h⟩ else fail "expected a single-paragraph doc"

theorem Paragraph.ofString_text (p : Paragraph) (path : Array String) :
    Paragraph.ofString p.text path = .ok p := by
  simp [Paragraph.ofString, p.valid]; rfl

def Paragraph.codec : Codec Paragraph where
  encode p := string.encode p.text
  decode node := Decode.string node >>= Paragraph.ofString
  roundTrip p path := by
    have h : Decode.string (string.encode p.text) path = .ok p.text := string.roundTrip _ _
    rw [bind_ok h, Paragraph.ofString_text]

/-- A paragraph is never empty. -/
theorem Paragraph.text_ne_empty (p : Paragraph) : p.text.isEmpty = false := by
  have hv := p.valid
  cases h : p.text.isEmpty
  · rfl
  · rw [String.isEmpty_iff.mp h] at hv; contradiction

/-- A return's doc: `""` is `none`, anything else a paragraph. -/
def returnDoc : Codec (Option Paragraph) where
  encode
    | some p => string.encode p.text
    | none => string.encode ""
  decode node := do
    let s ← Decode.string node
    if s.isEmpty then pure none else some <$> Paragraph.ofString s
  roundTrip d path := by
    cases d with
    | none =>
      have h : Decode.string (string.encode "") path = .ok "" := string.roundTrip _ _
      rw [bind_ok h]; rfl
    | some p =>
      have h : Decode.string (string.encode p.text) path = .ok p.text := string.roundTrip _ _
      rw [bind_ok h]
      simp only [Paragraph.text_ne_empty, Bool.false_eq_true, if_false]
      exact map_ok (Paragraph.ofString_text p path)

/-! ## Spelling tables -/

def Pointer.codec : Codec Pointer :=
  spelled "pointer" Pointer.spellings (spellingOf Pointer.spellings)
    (by intro a; cases a <;> rfl)

def StructKind.codec : Codec StructKind :=
  spelled "struct type" StructKind.spellings (spellingOf StructKind.spellings)
    (by intro a; cases a <;> rfl)

def CallbackStyle.codec : Codec CallbackStyle :=
  spelled "callback style" CallbackStyle.spellings (spellingOf CallbackStyle.spellings)
    (by intro a; cases a <;> rfl)

/-! ## Types -/

/-- The text inside `array<…>`, if the characters have that form. -/
def arrayInner? (cs : List Char) : Option (List Char) :=
  match stripPrefix? "array<".toList cs with
  | some rest => stripSuffix? '>' rest
  | none => none

/-- A reference `kind.name`: the kind, and the characters of the name. Exactly
one dot: `struct.a.b` is not a reference. -/
def splitRef? (cs : List Char) : Option (RefKind × List Char) :=
  match splitAt? '.' cs with
  | some (kind, rest) =>
    if '.' ∈ rest then none
    else (RefKind.spellings.lookup (String.ofList kind)).map (·, rest)
  | none => none

/-- A name has no dot. -/
theorem Name.no_dot (n : Name) : '.' ∉ n.text.toList := by
  intro h
  have hv := n.valid
  simp only [isName, Bool.and_eq_true, List.all_eq_true] at hv
  obtain ⟨⟨⟨-, hall⟩, -⟩, -⟩ := hv
  have := hall '.' h
  revert this; decide

def PrimitiveType.parse (s : String) : Decode PrimitiveType :=
  match arrayInner? s.toList with
  | some e => .array <$> spelled "array element type" ArrayElement.spellings (String.ofList e)
  | none => .scalar <$> spelled "primitive type" Primitive.spellings s

/-- Parse a `type:` string. A dot outside `array<…>` means a reference was
intended, so a string with one that is not a known reference says so. -/
def TypeRef.parse (s : String) : Decode TypeRef :=
  match arrayInner? s.toList with
  | some inner =>
    match splitRef? inner with
    | some (kind, name) => do return .refArray kind (← Name.ofString (String.ofList name))
    | none => (.primitive ∘ .array) <$>
        spelled "array element type" ArrayElement.spellings (String.ofList inner)
  | none =>
    match stripPrefix? "callback.".toList s.toList with
    | some name => do return .callback (← Name.ofString (String.ofList name))
    | none =>
      match splitRef? s.toList with
      | some (kind, name) => do return .ref kind (← Name.ofString (String.ofList name))
      | none =>
        if '.' ∈ s.toList then fail s!"invalid type reference {s.quote}"
        else (.primitive ∘ .scalar) <$> spelled "primitive type" Primitive.spellings s

/-- Facts about each reference kind's spelling, checked by `decide`: it does not
look like `array<` or `callback.`, has no dot, and the table maps it back. -/
theorem RefKind.spelling_facts (k : RefKind) :
    diverges "array<".toList (spellingOf RefKind.spellings k).toList = true ∧
    diverges "callback.".toList (spellingOf RefKind.spellings k).toList = true ∧
    '.' ∉ (spellingOf RefKind.spellings k).toList ∧
    RefKind.spellings.lookup (spellingOf RefKind.spellings k) = some k := by
  cases k <;> decide

theorem splitRef?_spelling (k : RefKind) {n : List Char} (hn : '.' ∉ n) :
    splitRef? ((spellingOf RefKind.spellings k).toList ++ '.' :: n) = some (k, n) := by
  obtain ⟨-, -, hdot, hlookup⟩ := RefKind.spelling_facts k
  simp [splitRef?, splitAt?_append hdot, String.ofList_toList, hlookup, hn]

theorem TypeRef.parse_render (t : TypeRef) (path : Array String) :
    TypeRef.parse t.render path = .ok t := by
  cases t with
  | primitive p =>
    cases p with
    | scalar p => cases p <;> rfl
    | array e => cases e <;> rfl
  | ref k n =>
    obtain ⟨harray, hcallback, -, -⟩ := RefKind.spelling_facts k
    have hcs : (TypeRef.ref k n).render.toList =
        (spellingOf RefKind.spellings k).toList ++ '.' :: n.text.toList := by
      simp [TypeRef.render, String.toList_append]
    simp only [TypeRef.parse, hcs, arrayInner?, stripPrefix?_of_diverges harray,
      stripPrefix?_of_diverges hcallback, splitRef?_spelling k (Name.no_dot n),
      String.ofList_toList]
    show (Name.ofString n.text >>= _) path = _
    rw [bind_ok (Name.ofString_text n path)]; rfl
  | refArray k n =>
    have hcs : (TypeRef.refArray k n).render.toList =
        "array<".toList ++ ((spellingOf RefKind.spellings k).toList ++ '.' :: n.text.toList) ++ ['>'] := by
      simp [TypeRef.render, String.toList_append]
    simp only [TypeRef.parse, hcs, arrayInner?, List.append_assoc, stripPrefix?_append]
    rw [← List.append_assoc, stripSuffix?_concat]
    simp only [splitRef?_spelling k (Name.no_dot n), String.ofList_toList]
    show (Name.ofString n.text >>= _) path = _
    rw [bind_ok (Name.ofString_text n path)]; rfl
  | callback n =>
    have hcs : (TypeRef.callback n).render.toList = "callback.".toList ++ n.text.toList := by
      simp [TypeRef.render, String.toList_append]
    have harray : diverges "array<".toList "callback.".toList = true := by decide
    simp only [TypeRef.parse, hcs, arrayInner?, stripPrefix?_of_diverges harray,
      stripPrefix?_append, String.ofList_toList]
    show (Name.ofString n.text >>= _) path = _
    rw [bind_ok (Name.ofString_text n path)]; rfl

def TypeRef.codec : Codec TypeRef where
  encode t := string.encode t.render
  decode node := Decode.string node >>= TypeRef.parse
  roundTrip t path := by
    have h : Decode.string (string.encode t.render) path = .ok t.render := string.roundTrip _ _
    rw [bind_ok h, TypeRef.parse_render]

def PrimitiveType.codec : Codec PrimitiveType where
  encode p := string.encode p.render
  decode node := Decode.string node >>= PrimitiveType.parse
  roundTrip p path := by
    have h : Decode.string (string.encode p.render) path = .ok p.render := string.roundTrip _ _
    rw [bind_ok h]
    cases p with
    | scalar p => cases p <;> rfl
    | array e => cases e <;> rfl

/-- `callback.name`, as a function's `callback` field writes it. -/
def callbackName : Codec Name where
  encode n := string.encode ("callback." ++ n.text)
  decode node := do
    let s ← Decode.string node
    match stripPrefix? "callback.".toList s.toList with
    | some name => Name.ofString (String.ofList name)
    | none => fail s!"expected callback.<name>, found {s.quote}"
  roundTrip n path := by
    have h : Decode.string (string.encode ("callback." ++ n.text)) path =
        .ok ("callback." ++ n.text) := string.roundTrip _ _
    rw [bind_ok h]
    simp only [String.toList_append, stripPrefix?_append, String.ofList_toList]
    exact Name.ofString_text n path

/-! ## Values -/

def uint16 : Codec UInt16 := iso (fin 65536 "16 bits") UInt16.toFin UInt16.ofFin

/-- Named values are written plain, as the spec writes them. -/
def Value64.codec : Codec Value64 where
  encode
    | .int u => Codec.nat.encode u.toNat
    | v => .scalar { text := spellingOf Value64.spellings v }
  decode node := do
    match ← value node with
    | .int n =>
      if 0 ≤ n ∧ n < 2 ^ 64 then pure (.int (UInt64.ofNat n.toNat))
      else fail s!"integer {n} does not fit in 64 bits"
    | .str s => Decode.spelled "constant value" Value64.spellings s
    | v => fail s!"expected an integer or a named value, found {v.describe}"
  roundTrip v path := by
    cases v with
    | int u =>
      have hv : value (Codec.nat.encode u.toNat) path = .ok (.int (u.toNat : Int)) := by
        simp [Codec.nat, Decode.value]; rfl
      have hlt : (u.toNat : Int) < 2 ^ 64 := by have := u.toNat_lt; omega
      rw [bind_ok hv]
      simp only [if_pos (And.intro (Int.natCast_nonneg _) hlt), Int.toNat_natCast,
        UInt64.ofNat_toNat]
      rfl
    | _ => rfl

/-- A string default, read by `defaultText`. -/
def Default.ofText (s : String) : Decode Default :=
  match h : defaultText s with
  | .zero => pure .zero
  | .constant rest => .constant <$> Name.ofString rest
  | .int n => pure (.int n)
  | .entry =>
    if hn : isName s then pure (.entry ⟨s, hn⟩ h) else fail s!"invalid name {s.quote}"

theorem Default.ofText_entry (n : Name) (h : defaultText n.text = .entry) :
    Default.ofText n.text = pure (.entry n h) := by
  unfold Default.ofText
  split <;> simp_all [n.valid]

theorem defaultText_constant (n : Name) :
    defaultText ("constant." ++ n.text) = .constant n.text := by
  have hz : ("constant." ++ n.text) ≠ "zero" := by
    intro h
    have := congrArg String.toList h
    simp [String.toList_append] at this
  simp only [defaultText, hz, if_false, String.toList_append, stripPrefix?_append,
    String.ofList_toList]

theorem Default.ofText_constant (n : Name) :
    Default.ofText ("constant." ++ n.text) = .constant <$> Name.ofString n.text := by
  unfold Default.ofText
  split
  all_goals rename_i h
  all_goals rw [defaultText_constant] at h
  all_goals (cases h; try rfl)

/-- Booleans, numbers and floats are written plain; names and `zero` quoted. -/
def Default.codec : Codec Default where
  encode
    | .bool b => Codec.bool.encode b
    | .int i => Codec.int.encode i
    | .float t _ => .scalar { text := t }
    | .constant n => Codec.string.encode ("constant." ++ n.text)
    | .entry n _ => Codec.string.encode n.text
    | .zero => Codec.string.encode "zero"
  decode node := do
    match ← value node with
    | .bool b => pure (.bool b)
    | .int n => pure (.int n)
    | .float t =>
      if h : Scalar.value { text := t } = .float t then pure (.float t h)
      else fail s!"invalid float {t}"
    | .str s => Default.ofText s
    | .null => fail "expected a default value, found null"
  roundTrip d path := by
    cases d with
    | bool b => cases b <;> rfl
    | int i => simp [Codec.int, Decode.value]; rfl
    | float t h => simp [Decode.value, h]; rfl
    | constant n =>
      simp only [Codec.string, Decode.value, Scalar.value_of_not_plain]
      show Default.ofText ("constant." ++ n.text) path = _
      rw [Default.ofText_constant]
      exact map_ok (Name.ofString_text n path)
    | entry n hn =>
      simp only [Codec.string, Decode.value, Scalar.value_of_not_plain]
      show Default.ofText n.text path = _
      rw [Default.ofText_entry n hn]; rfl
    | zero => rfl

/-! ## Entries -/

def Constant.codec : Codec Constant :=
  record
    (field  "name"      Name.codec ⊗
     field? "namespace" Name.codec ⊗
     field  "value"     Value64.codec ⊗
     field  "doc"       string)
    (fun c => (c.name, c.ns, c.value, c.doc))
    (fun (name, ns, value, doc) => { name, ns, value, doc })

def Typedef.codec : Codec Typedef :=
  record
    (field  "name"      Name.codec ⊗
     field? "namespace" Name.codec ⊗
     field  "doc"       string ⊗
     field  "type"      PrimitiveType.codec)
    (fun t => (t.name, t.ns, t.doc, t.type))
    (fun (name, ns, doc, type) => { name, ns, doc, type })

def EnumEntry.codec : Codec EnumEntry :=
  record
    (field  "name"      Name.codec ⊗
     field? "namespace" Name.codec ⊗
     field  "doc"       string ⊗
     field? "value"     uint16)
    (fun e => (e.name, e.ns, e.doc, e.value))
    (fun (name, ns, doc, value) => { name, ns, doc, value })

def Enum.codec : Codec Enum :=
  record
    (field  "name"      Name.codec ⊗
     field? "namespace" Name.codec ⊗
     field  "doc"       string ⊗
     fieldD "extended"  bool false ⊗
     fieldD "entries"   (Codec.seq (Codec.nullable EnumEntry.codec (fun _ => rfl))) #[])
    (fun e => (e.name, e.ns, e.doc, e.extended, e.entries))
    (fun (name, ns, doc, extended, entries) => { name, ns, doc, extended, entries })

def BitflagEntry.codec : Codec BitflagEntry :=
  record
    (field  "name"              Name.codec ⊗
     field? "namespace"         Name.codec ⊗
     field  "doc"               string ⊗
     field? "value"             Value64.codec ⊗
     field? "value_combination" (Codec.seq Name.codec))
    (fun e => (e.name, e.ns, e.doc, e.value, e.combination))
    (fun (name, ns, doc, value, combination) => { name, ns, doc, value, combination })

def Bitflag.codec : Codec Bitflag :=
  record
    (field  "name"      Name.codec ⊗
     field? "namespace" Name.codec ⊗
     field  "doc"       string ⊗
     fieldD "extended"  bool false ⊗
     fieldD "entries"   (Codec.seq BitflagEntry.codec) #[])
    (fun b => (b.name, b.ns, b.doc, b.extended, b.entries))
    (fun (name, ns, doc, extended, entries) => { name, ns, doc, extended, entries })

/-- A parameter, with `doc` for its doc: `string` for struct members,
`Paragraph.codec` for function and callback arguments. -/
def Parameter.codec {Doc} (doc : Codec Doc) : Codec (Parameter Doc) :=
  record
    (field  "name"                  Name.codec ⊗
     field  "doc"                   doc ⊗
     field  "type"                  TypeRef.codec ⊗
     field? "passed_with_ownership" bool ⊗
     field? "pointer"               Pointer.codec ⊗
     fieldD "optional"              bool false ⊗
     field? "default"               Default.codec)
    (fun p => (p.name, p.doc, p.type, p.passedWithOwnership, p.pointer, p.optional, p.default))
    (fun (name, doc, type, passedWithOwnership, pointer, optional, default) =>
      { name, doc, type, passedWithOwnership, pointer, optional, default })

def Struct.codec : Codec Struct :=
  record
    (field  "name"         Name.codec ⊗
     field? "namespace"    Name.codec ⊗
     field  "doc"          string ⊗
     field  "type"         StructKind.codec ⊗
     fieldD "extends"      (Codec.seq Name.codec) #[] ⊗
     fieldD "free_members" bool false ⊗
     fieldD "members"      (Codec.seq (Parameter.codec string)) #[])
    (fun s => (s.name, s.ns, s.doc, s.kind, s.extendedStructs, s.freeMembers, s.members))
    (fun (name, ns, doc, kind, extendedStructs, freeMembers, members) =>
      { name, ns, doc, kind, extendedStructs, freeMembers, members })

def Callback.codec : Codec Callback :=
  record
    (field  "name"      Name.codec ⊗
     field? "namespace" Name.codec ⊗
     field  "doc"       string ⊗
     field  "style"     CallbackStyle.codec ⊗
     fieldD "args"      (Codec.seq (Parameter.codec Paragraph.codec)) #[])
    (fun c => (c.name, c.ns, c.doc, c.style, c.args))
    (fun (name, ns, doc, style, args) => { name, ns, doc, style, args })

def Return.codec : Codec Return :=
  record
    (field  "doc"                   returnDoc ⊗
     field  "type"                  TypeRef.codec ⊗
     fieldD "optional"              bool false ⊗
     field? "passed_with_ownership" bool ⊗
     field? "pointer"               Pointer.codec)
    (fun r => (r.doc, r.type, r.optional, r.passedWithOwnership, r.pointer))
    (fun (doc, type, optional, passedWithOwnership, pointer) =>
      { doc, type, optional, passedWithOwnership, pointer })

def Function.codec : Codec Function :=
  record
    (field  "name"      Name.codec ⊗
     field? "namespace" Name.codec ⊗
     field  "doc"       string ⊗
     field? "returns"   Return.codec ⊗
     field? "callback"  callbackName ⊗
     fieldD "args"      (Codec.seq (Parameter.codec Paragraph.codec)) #[])
    (fun f => (f.name, f.ns, f.doc, f.returns, f.callback, f.args))
    (fun (name, ns, doc, returns, callback, args) => { name, ns, doc, returns, callback, args })

/-- The schema lists no required fields for objects; like upstream's generator,
this requires `name` and `doc`, as for every other entry. -/
def Object.codec : Codec Object :=
  record
    (field  "name"      Name.codec ⊗
     field? "namespace" Name.codec ⊗
     field  "doc"       string ⊗
     fieldD "extended"  bool false ⊗
     fieldD "methods"   (Codec.seq Function.codec) #[])
    (fun o => (o.name, o.ns, o.doc, o.extended, o.methods))
    (fun (name, ns, doc, extended, methods) => { name, ns, doc, extended, methods })

/-! ## The whole spec -/

def Spec.codec : Codec Spec :=
  record
    (field "copyright"   string ⊗
     field "name"        Name.codec ⊗
     field "enum_prefix" (fin 32768 "the enum prefix range") ⊗
     field "doc"         string ⊗
     field "constants"   (Codec.seq Constant.codec) ⊗
     field "typedefs"    (Codec.seq Typedef.codec) ⊗
     field "enums"       (Codec.seq Enum.codec) ⊗
     field "bitflags"    (Codec.seq Bitflag.codec) ⊗
     field "structs"     (Codec.seq Struct.codec) ⊗
     field "callbacks"   (Codec.seq Callback.codec) ⊗
     field "functions"   (Codec.seq Function.codec) ⊗
     field "objects"     (Codec.seq Object.codec))
    (fun s => (s.copyright, s.name, s.enumPrefix, s.doc, s.constants, s.typedefs, s.enums,
      s.bitflags, s.structs, s.callbacks, s.functions, s.objects))
    (fun (copyright, name, enumPrefix, doc, constants, typedefs, enums, bitflags, structs,
        callbacks, functions, objects) =>
      { copyright, name, enumPrefix, doc, constants, typedefs, enums, bitflags, structs,
        callbacks, functions, objects })

/-- Decoding an encoded spec gives back exactly that spec. -/
theorem Spec.decode_encode (s : Spec) :
    (Spec.codec.decode (Spec.codec.encode s)).run = .ok s :=
  Spec.codec.roundTrip s #[]

end WebGPUGen.Parsed
