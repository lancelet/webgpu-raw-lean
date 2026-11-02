import WebGPUGen.Decode

/-!
# Codecs

A `Codec α` describes how values of `α` are written to and read from YAML, as
one value: an encoder, a decoder, and a proof that decoding what was encoded
gives back the original value.

Codecs are built from the combinators in this module, each proved once:
scalars, record fields, records, sequences, nullable values and spelling
tables. A codec assembled from them carries its round-trip proof by
construction, so a format described with codecs needs no proof of its own,
only small side conditions (distinct keys, conversions that undo each other)
that Lean checks with `decide` or `rfl`.

The proof says the encoder and decoder agree, and that every value of `α` can
be written. It does not say that the format matches anyone else's reading of
the same YAML.
-/

namespace WebGPUGen.Codec
open WebGPUGen.Yaml WebGPUGen.Decode

/-! ## Running decoders

How decoders behave when the parts they run succeed. -/

theorem bind_ok {α β} {m : Decode α} {f : α → Decode β} {path a}
    (h : m path = .ok a) : (m >>= f) path = f a path := by
  show (do let x ← m path; f x path : Except _ _) = _
  rw [h]; rfl

theorem map_ok {α β} {m : Decode α} {f : α → β} {path a}
    (h : m path = .ok a) : (f <$> m) path = .ok (f a) := by
  show (do let x ← m path; pure (f x) : Except _ _) = _
  rw [h]; rfl

theorem within_apply {α} (key : String) (d : Decode α) (path : Array String) :
    within key d path = d (path.push key) := rfl

theorem fields_bind_ok {α β} {x : Fields α} {f : α → Fields β} {s path a s'}
    (h : x s path = .ok (a, s')) : (x >>= f) s path = f a s' path := by
  show (do let p ← x s path; f p.1 p.2 path : Except _ _) = _
  rw [h]; rfl

theorem fields_map_ok {α β} {x : Fields α} {f : α → β} {s path a s'}
    (h : x s path = .ok (a, s')) : (f <$> x) s path = .ok (f a, s') := by
  show (do let p ← x s path; pure (f p.1, p.2) : Except _ _) = _
  rw [h]; rfl

theorem fields_lift_ok {α} {d : Decode α} {s : List (String × Node)} {path} {a : α}
    (h : d path = .ok a) : (liftM d : Fields α) s path = .ok (a, s) := by
  show (do let x ← d path; pure (x, s) : Except _ _) = _
  rw [h]; rfl

/-- `take?` finds a key at the head of the entries when it occurs nowhere else. -/
theorem take?_head {k : String} {v : Node} {rest : List (String × Node)} {path}
    (h : ∀ e ∈ rest, e.1 ≠ k) : take? k ((k, v) :: rest) path = .ok (some v, rest) := by
  have hf : rest.filter (·.1 != k) = rest := by
    rw [List.filter_eq_self]; intro e he; simpa using h e he
  simp [take?, hf]; rfl

/-- `take?` finds nothing when the key is absent. -/
theorem take?_absent {k : String} {rest : List (String × Node)} {path}
    (h : ∀ e ∈ rest, e.1 ≠ k) : take? k rest path = .ok (none, rest) := by
  have hf : rest.filter (·.1 != k) = rest := by
    rw [List.filter_eq_self]; intro e he; simpa using h e he
  have hn : rest.find? (·.1 == k) = none := by
    rw [List.find?_eq_none]; intro e he; simpa using h e he
  simp [take?, hf, hn]; rfl

/-- A mapping decodes when its fields consume every entry. -/
theorem object_ok {α} {fields : Fields α} {entries : Array (String × Node)} {path} {a : α}
    (h : fields entries.toList path = .ok (a, [])) : object fields (.map entries) path = .ok a := by
  show (do
    let p ← fields entries.toList path
    (if let (key, _) :: _ := p.2 then fail s!"unknown field {key}" else pure p.1 : Decode α) path
    : Except _ _) = _
  rw [h]; rfl

/-! ## Codecs -/

/-- An encoder and decoder for `α` that undo each other. -/
structure Codec (α : Type) where
  encode    : α → Node
  decode    : Node → Decode α
  roundTrip : ∀ a path, decode (encode a) path = .ok a

/-! ## Scalars -/

/-- Strings are written quoted, so no text is ever read as a keyword. -/
def string : Codec String where
  encode s := .scalar { text := s, plain := false }
  decode := Decode.string
  roundTrip s path := by
    simp [Decode.string, Decode.value, Scalar.value_of_not_plain]; rfl

def bool : Codec Bool where
  encode b := .scalar { text := if b then "true" else "false" }
  decode := Decode.bool
  roundTrip b path := by
    cases b <;> simp [Decode.bool, Decode.value] <;> rfl

/-- None of the spellings of null, true or false parses as an integer. -/
theorem keywords_not_int :
    ∀ k ∈ nullSpellings ++ trueSpellings ++ falseSpellings, parseInt? k = none := by decide

/-- An integer written in decimal reads back as that integer. -/
@[simp] theorem value_repr (i : Int) : Scalar.value { text := i.repr } = .int i := by
  have hp : parseInt? i.repr = some i := parseInt?_toString i
  have nk : ∀ k ∈ nullSpellings ++ trueSpellings ++ falseSpellings, i.repr ≠ k := by
    intro k hk heq
    rw [heq, keywords_not_int k hk] at hp
    contradiction
  simp only [nullSpellings, trueSpellings, falseSpellings, List.cons_append, List.nil_append,
    List.mem_cons, List.not_mem_nil, or_false, forall_eq_or_imp, forall_eq] at nk
  simp [Scalar.value, nullSpellings, trueSpellings, falseSpellings, nk, hp]

def int : Codec Int where
  encode i := .scalar { text := i.repr }
  decode node := do
    match ← value node with
    | .int n => pure n
    | v => fail s!"expected an integer, found {v.describe}"
  roundTrip i path := by
    simp [Decode.value]; rfl

def nat : Codec Nat where
  encode n := .scalar { text := (n : Int).repr }
  decode := Decode.nat
  roundTrip n path := by
    simp [Decode.nat, Decode.value]; rfl

/-- A natural number below `bound`, as `Fin bound`. -/
def fin (bound : Nat) (what : String) : Codec (Fin bound) where
  encode i := nat.encode i.val
  decode node := do
    let n ← Decode.nat node
    if h : n < bound then pure ⟨n, h⟩
    else fail s!"integer {n} does not fit in {what}"
  roundTrip i path := by
    have h : Decode.nat (nat.encode i.val) path = .ok i.val := nat.roundTrip _ _
    rw [bind_ok h]
    simp [i.isLt]; rfl

/--
A value named by one of the spellings in `table`. `spell` gives each value its
spelling; `lookup_spell` says the table maps it back.
-/
def spelled {α} (what : String) (table : List (String × α)) (spell : α → String)
    (lookup_spell : ∀ a, table.lookup (spell a) = some a) : Codec α where
  encode a := string.encode (spell a)
  decode node := Decode.string node >>= Decode.spelled what table
  roundTrip a path := by
    have h : Decode.string (string.encode (spell a)) path = .ok (spell a) :=
      string.roundTrip _ _
    rw [bind_ok h]
    simp [Decode.spelled, lookup_spell]; rfl

/-- A codec for `α` from one for `β`, through conversions that undo each other. -/
def iso {α β} (c : Codec β) (to : α → β) (of : β → α)
    (of_to : ∀ a, of (to a) = a := by intro a; rfl) : Codec α where
  encode a := c.encode (to a)
  decode node := of <$> c.decode node
  roundTrip a path := by rw [map_ok (c.roundTrip (to a) path), of_to]

/-! ## Records -/

/--
The fields of a record: which keys they use, how they are written, and how they
are read back. Reading the written entries, followed by any entries with other
keys, gives back the value and leaves the other entries.
-/
structure Fields (α : Type) where
  keys        : List String
  encode      : α → List (String × Node)
  decode      : Decode.Fields α
  encode_keys : ∀ a, ∀ e ∈ encode a, e.1 ∈ keys
  roundTrip   : ∀ a rest path, (∀ e ∈ rest, e.1 ∉ keys) →
    decode (encode a ++ rest) path = .ok (a, rest)

/-- A required field. -/
def field {α} (key : String) (c : Codec α) : Fields α where
  keys := [key]
  encode a := [(key, c.encode a)]
  decode := Decode.field key c.decode
  encode_keys a e he := by simp_all
  roundTrip a rest path h := by
    have hk : ∀ e ∈ rest, e.1 ≠ key := fun e he heq => h e he (by simp [heq])
    simp only [List.cons_append, List.nil_append]
    show (take? key >>= _) _ path = _
    rw [fields_bind_ok (take?_head hk)]
    exact fields_lift_ok (by rw [within_apply, c.roundTrip])

/-- An optional field: absent is `none`. -/
def field? {α} (key : String) (c : Codec α) : Fields (Option α) where
  keys := [key]
  encode
    | some a => [(key, c.encode a)]
    | none => []
  decode := Decode.field? key c.decode
  encode_keys a e he := by cases a <;> simp_all
  roundTrip a rest path h := by
    have hk : ∀ e ∈ rest, e.1 ≠ key := fun e he heq => h e he (by simp [heq])
    cases a with
    | none =>
      show (take? key >>= _) rest path = _
      rw [fields_bind_ok (take?_absent hk)]; rfl
    | some a =>
      simp only [List.cons_append, List.nil_append]
      show (take? key >>= _) _ path = _
      rw [fields_bind_ok (take?_head hk)]
      show (some <$> (liftM (within key (c.decode (c.encode a))) : Decode.Fields α)) rest path = _
      exact fields_map_ok (fields_lift_ok (by rw [within_apply, c.roundTrip]))

/-- Two groups of fields with different keys, read and written in turn. -/
def Fields.prod {α β} (f : Fields α) (g : Fields β)
    -- `decide` checks closed key lists; `simp` handles fields of a codec that is
    -- itself a variable (as in `Parameter.codec`), which `decide` refuses.
    (disjoint : ∀ k ∈ f.keys, k ∉ g.keys := by first
      | decide
      | simp [WebGPUGen.Codec.Fields.prod, WebGPUGen.Codec.field, WebGPUGen.Codec.field?,
          WebGPUGen.Codec.fieldD]) : Fields (α × β) where
  keys := f.keys ++ g.keys
  encode p := f.encode p.1 ++ g.encode p.2
  decode := do
    let a ← f.decode
    let b ← g.decode
    pure (a, b)
  encode_keys p e he := by
    rcases List.mem_append.mp he with h | h
    · exact List.mem_append_left _ (f.encode_keys _ e h)
    · exact List.mem_append_right _ (g.encode_keys _ e h)
  roundTrip p rest path h := by
    obtain ⟨a, b⟩ := p
    have hf : ∀ e ∈ g.encode b ++ rest, e.1 ∉ f.keys := by
      intro e he hk
      rcases List.mem_append.mp he with h' | h'
      · exact disjoint _ hk (g.encode_keys _ e h')
      · exact h e h' (List.mem_append_left _ hk)
    have hg : ∀ e ∈ rest, e.1 ∉ g.keys := fun e he hk => h e he (List.mem_append_right _ hk)
    show (f.decode >>= _) _ path = _
    rw [List.append_assoc, fields_bind_ok (f.roundTrip a _ path hf)]
    show (g.decode >>= _) _ path = _
    rw [fields_bind_ok (g.roundTrip b rest path hg)]; rfl

@[inherit_doc] infixr:35 " ⊗ " => Fields.prod

/-- A record: its fields, and a conversion to and from their values. -/
def record {α β} (fields : Fields β) (to : α → β) (of : β → α)
    (of_to : ∀ a, of (to a) = a := by intro a; rfl) : Codec α where
  encode a := .map (fields.encode (to a)).toArray
  decode := object (of <$> fields.decode)
  roundTrip a path := by
    have h := fields.roundTrip (to a) [] path (by simp)
    rw [List.append_nil] at h
    apply object_ok
    rw [List.toList_toArray, fields_map_ok h, of_to]

/-- A field that is written always, and read as `default` when absent. -/
def fieldD {α} (key : String) (c : Codec α) (default : α) : Fields α where
  keys := [key]
  encode a := (field? key c).encode (some a)
  decode := (·.getD default) <$> (field? key c).decode
  encode_keys a := (field? key c).encode_keys (some a)
  roundTrip a rest path h := fields_map_ok ((field? key c).roundTrip (some a) rest path h)

/-! ## Sequences and nullable values -/

theorem items_ok {α} (c : Codec α) :
    ∀ (l : List α) (i : Nat) path, items c.decode i (l.map c.encode) path = .ok l
  | [], _, _ => rfl
  | a :: l, i, path => by
    show (within s!"[{i}]" (c.decode (c.encode a)) >>= _) path = _
    rw [bind_ok (by rw [within_apply, c.roundTrip])]
    show (items c.decode (i + 1) (l.map c.encode) >>= _) path = _
    rw [bind_ok (items_ok c l (i + 1) path)]; rfl

/-- A sequence of values, each with `c`. -/
def seq {α} (c : Codec α) : Codec (Array α) where
  encode xs := .seq (xs.map c.encode)
  decode := Decode.seq c.decode
  roundTrip xs path := by
    show (List.toArray <$> items c.decode 0 (xs.map c.encode).toList) path = _
    rw [Array.toList_map, map_ok (items_ok c xs.toList 0 path)]

/--
Does `node` read as null? A codec used with `nullable` must never encode a value
that way.
-/
def isNull : Node → Bool
  | .scalar s => s.value == .null
  | _ => false

/-- `none` written as `null`, otherwise a value written with `c`. -/
def nullable {α} (c : Codec α) (notNull : ∀ a, isNull (c.encode a) = false) :
    Codec (Option α) where
  encode
    | some a => c.encode a
    | none => .scalar { text := "null" }
  decode := Decode.nullable c.decode
  roundTrip a path := by
    cases a with
    | none => rfl
    | some a =>
      show Decode.nullable c.decode (c.encode a) path = .ok (some a)
      have h := notNull a
      have rt := c.roundTrip a path
      revert h rt
      generalize c.encode a = n
      intro h rt
      cases n with
      | scalar s =>
        simp only [isNull] at h
        simp only [Decode.nullable, h, Bool.false_eq_true, if_false]
        exact map_ok rt
      | seq _ => exact map_ok rt
      | map _ => exact map_ok rt

/-- A record never encodes as null. -/
theorem record_notNull {α β} (fields : Fields β) (to : α → β) (of : β → α) (of_to) :
    ∀ a, isNull ((record fields to of of_to).encode a) = false := fun _ => rfl

end WebGPUGen.Codec
