import WebGPUGen.Lowered.Settle

/-!
# Zero values line up with their structs

A default of every byte zero, `fields n values`, is printed as `n`'s `T.zero`,
whose declaration pairs `n`'s members with `values` by position, printing
each value by its member's type. So `values` must name `n`'s members, in
order, each nested zero value must be of the struct its member holds, and each
other value must fit its member: `aligned` says so. It reads only each struct's
member names and values, its `shapeOf`.

    theorem aligned_zeroFields :
      zeroFields spec n k = some values → aligned spec.shapeOf n values
    theorem lower_fields :
      (a struct member of lower r) → m.default = some (.fields n values) →
        m.value = .struct n ∧ aligned (lower r).shapeOf n values

The first holds by how `zeroFields` builds them. Lowering makes no `fields` of
its own, and settling the defaults keeps every struct's shape, so the second
follows, for the spec the printer prints. Every zero value within an aligned one
is aligned too (`aligned_of_within`), so each `T.zero` the printer declares is;
and aligned field values name their struct's members, in order
(`aligned_names`), so the declaration pairing them by position misses none.

That the struct the printer finds for a zero value, by its C name among the
bound structs, is bound, and is the one `shapeOf` finds among all of them, is
proved in `Emit/ZeroDecls`, given C names that are distinct.
-/

namespace WebGPUGen.Lowered
open WebGPUGen.Common

/-! ## Alignment -/

/-- A struct's members' names and values, by its C name: all `aligned` reads. -/
def Spec.shapeOf (spec : Lowered.Spec) (n : Names) :
    Option (List (Names × Value)) :=
  (spec.structs.find? (·.names.c == n.c)).map fun s =>
    s.members.toList.map fun m => (m.names, m.value)

/--
The value `d` fits a member of value `v`, as the printer prints it: a number
for a number, `none` for an optional value, an empty string or array, or an
entry of the member's own enum or bitflag type. A nested zero value is
`aligned` instead.
-/
def Default.fits : Default → Value → Bool
  | .bool _, .bool => true
  | .int _, .uint16 | .int _, .uint32 | .int _, .uint64 | .int _, .int16
  | .int _, .int32 | .int _, .usize => true
  | .float _, .float32 | .float _, .float64 | .float _, .nullableFloat32 => true
  | .null, .string true | .null, .object _ true
  | .null, .structPointer _ true => true
  | .empty, .string false | .empty, .array .. => true
  | .entry type _, .enum names | .entry type _, .bitflag names => type == names
  | _, _ => false

mutual
  /--
  The field values `values` line up with the members of the struct `n`, by the
  struct shapes `shape`: one for each member, named as it is, in order, and
  each fitting its member: a nested zero value of the struct its member holds,
  in turn, and any other value of its member's kind (`Default.fits`).
  -/
  def aligned (shape : Names → Option (List (Names × Value))) (n : Names)
      (values : List (Names × Default)) : Bool :=
    match shape n with
    | none         => false
    | some members => alignedFields shape members values

  /-- Each field value lines up with its member, one for one. -/
  def alignedFields (shape : Names → Option (List (Names × Value))) :
      List (Names × Value) → List (Names × Default) → Bool
    | [], [] => true
    | (name, v) :: members, (field, d) :: values =>
      field == name && alignedField shape v d
        && alignedFields shape members values
    | _, _ => false

  /-- A field value lines up with a member of value `v`. -/
  def alignedField (shape : Names → Option (List (Names × Value)))
      (v : Value) : Default → Bool
    | .fields n values => v == .struct n && aligned shape n values
    | d => d.fits v
end

/-! ## What alignment gives the printer -/

/-- Aligned field values have their members' names, in order. -/
theorem alignedFields_names {shape : Names → Option (List (Names × Value))} :
    ∀ {members : List (Names × Value)} {values : List (Names × Default)},
      alignedFields shape members values = true →
        values.map (·.1) = members.map (·.1)
  | [], [], _ => rfl
  | [], _ :: _, h | _ :: _, [], h => by simp [alignedFields] at h
  | (name, v) :: members, (field, d) :: values, h => by
    simp only [alignedFields, Bool.and_eq_true, beq_iff_eq] at h
    obtain ⟨⟨rfl, -⟩, h⟩ := h
    simp [alignedFields_names h]

/--
The field values of an aligned zero value have the names of its struct's
members, in order: one for each, so pairing them by position misses none.
-/
theorem aligned_names {shape : Names → Option (List (Names × Value))}
    {n : Names} {values : List (Names × Default)}
    (h : aligned shape n values = true) :
    ∃ members, shape n = some members
      ∧ values.map (·.1) = members.map (·.1) := by
  unfold aligned at h
  split at h
  · simp at h
  · next members hshape => exact ⟨members, hshape, alignedFields_names h⟩

/-- Each of the aligned field values lines up with one of the members. -/
theorem alignedField_of_mem {shape : Names → Option (List (Names × Value))} :
    ∀ {members : List (Names × Value)} {values : List (Names × Default)},
      alignedFields shape members values = true →
        ∀ {field d}, (field, d) ∈ values →
          ∃ p ∈ members, alignedField shape p.2 d = true
  | [], [], _, _, _, h => by simp at h
  | [], _ :: _, h, _, _, _ | _ :: _, [], h, _, _, _ => by
    simp [alignedFields] at h
  | (name, v) :: members, (field', d') :: values, h, field, d, hmem => by
    simp only [alignedFields, Bool.and_eq_true] at h
    obtain ⟨⟨-, hfield⟩, h⟩ := h
    rcases List.mem_cons.1 hmem with heq | hmem
    · cases heq
      exact ⟨(name, v), List.mem_cons_self .., hfield⟩
    · obtain ⟨p, hp, h⟩ := alignedField_of_mem h hmem
      exact ⟨p, List.mem_cons_of_mem _ hp, h⟩

/-- A zero value within one that lines up with some member lines up too. -/
theorem aligned_within {shape : Names → Option (List (Names × Value))}
    {z : Names × List (Names × Default)} {d : Default} (h : d.Within z) :
    (∃ v, alignedField shape v d = true) → aligned shape z.1 z.2 = true := by
  induction h with
  | here =>
    rintro ⟨v, hv⟩
    simp only [alignedField, Bool.and_eq_true] at hv
    exact hv.2
  | field hmem _ ih =>
    rintro ⟨v, hv⟩
    simp only [alignedField, Bool.and_eq_true] at hv
    have ha := hv.2
    unfold aligned at ha
    split at ha
    · simp at ha
    · obtain ⟨p, -, hp⟩ := alignedField_of_mem ha hmem
      exact ih ⟨p.2, hp⟩

/--
Every zero value an aligned one is or holds is aligned: so is each `T.zero`
the printer declares from it.
-/
theorem aligned_of_within {shape : Names → Option (List (Names × Value))}
    {n : Names} {values : List (Names × Default)}
    {z : Names × List (Names × Default)} (ha : aligned shape n values = true)
    (h : (Default.fields n values).Within z) : aligned shape z.1 z.2 = true :=
  aligned_within h ⟨.struct n, by simp [alignedField, ha]⟩

/-! ## Zero values as lowering builds them -/

/--
Field values made one for each member, each named as its member and lining up
with it, line up with the members.
-/
theorem alignedFields_of_mapM
    {shape : Names → Option (List (Names × Value))}
    {g : Member → Option (Names × Default)}
    (hg : ∀ m b, g m = some b →
      b.1 = m.names ∧ alignedField shape m.value b.2 = true) :
    ∀ {members : List Member} {values : List (Names × Default)},
      members.mapM g = some values →
        alignedFields shape (members.map fun m => (m.names, m.value)) values
          = true
  | [], values, h => by
    simp at h
    subst h
    simp [alignedFields]
  | m :: members, values, h => by
    rw [List.mapM_cons] at h
    cases hm : g m with
    | none => simp [hm] at h
    | some b =>
      cases hrest : members.mapM g with
      | none => simp [hm, hrest] at h
      | some rest =>
        simp [hm, hrest] at h
        subst h
        obtain ⟨hname, hfield⟩ := hg m b hm
        obtain ⟨field, d⟩ := b
        simp only at hname hfield
        simp [alignedFields, hname, hfield, alignedFields_of_mapM hg hrest]

/-- The zero value of a member is a nested zero value only for a struct. -/
theorem zeroOf_fields {spec : Lowered.Spec} {fuel : Nat} {v : Value}
    {n : Names} {values : List (Names × Default)}
    (h : zeroFields.zeroOf spec fuel v = some (.fields n values)) :
    v = .struct n ∧ zeroFields spec n fuel = some values := by
  cases v with
  | struct nested =>
    simp only [zeroFields.zeroOf, Option.map_eq_some_iff,
      Default.fields.injEq] at h
    obtain ⟨values', hz, rfl, rfl⟩ := h
    exact ⟨rfl, hz⟩
  | string b | object _ b | structPointer _ b =>
    cases b <;> simp [zeroFields.zeroOf] at h
  | _ => simp [zeroFields.zeroOf, Option.bind_eq_some_iff] at h

/-- A member's zero value, if not a nested one, fits the member. -/
theorem zeroOf_fits {spec : Lowered.Spec} {fuel : Nat} {v : Value}
    {d : Default} (h : zeroFields.zeroOf spec fuel v = some d)
    (hd : ∀ n values, d ≠ .fields n values) : d.fits v = true := by
  cases v with
  | struct nested =>
    simp only [zeroFields.zeroOf, Option.map_eq_some_iff] at h
    obtain ⟨values, -, rfl⟩ := h
    exact absurd rfl (hd _ _)
  | enum type | bitflag type =>
    simp [zeroFields.zeroOf, Option.bind_eq_some_iff] at h
    obtain ⟨_, -, _, -, rfl⟩ := h
    simp [Default.fits]
  | string b | object _ b | structPointer _ b =>
    cases b <;> simp [zeroFields.zeroOf] at h <;> subst h <;> rfl
  | _ => simp [zeroFields.zeroOf] at h <;> subst h <;> rfl

/-- Lowering's zero values line up with their structs. -/
theorem aligned_zeroFields {spec : Lowered.Spec} {k : Nat} :
    ∀ {n : Names} {values : List (Names × Default)},
      zeroFields spec n k = some values →
        aligned spec.shapeOf n values = true := by
  induction k with
  | zero => simp [zeroFields]
  | succ k ih =>
    intro n values h
    simp only [zeroFields, bind, Option.bind_eq_some_iff] at h
    obtain ⟨s, hs, hm⟩ := h
    simp only [aligned, Spec.shapeOf, hs, Option.map_some]
    refine alignedFields_of_mapM ?_ hm
    intro m b hb
    simp only [Option.bind_eq_some_iff, pure] at hb
    obtain ⟨d, hd, hb⟩ := hb
    injection hb with hb
    subst hb
    refine ⟨rfl, ?_⟩
    cases d with
    | fields n' values' =>
      obtain ⟨hv, hz⟩ := zeroOf_fields hd
      simp [alignedField, hv, ih hz]
    | _ => simpa [alignedField] using zeroOf_fits hd (by simp)

/-! ## Settling keeps the shapes -/

/-- Mapping members that keeps their names and values keeps every shape. -/
theorem shapeOf_mapMembers {f : Member → Member} (spec : Lowered.Spec)
    (hf : ∀ m, (f m).names = m.names ∧ (f m).value = m.value) :
    (mapMembers f spec).shapeOf = spec.shapeOf := by
  funext n
  simp [Spec.shapeOf, find?_mapMembers, Function.comp_def, hf]

/-- Settling a `zero` default keeps the member's names. -/
theorem settleZero_names (spec : Lowered.Spec) (m : Member) :
    (settleZero spec m).names = m.names := by
  unfold settleZero
  split <;> rfl

/-- Settling a `nested` default keeps the member's names. -/
theorem settleNested_names (spec : Lowered.Spec) (m : Member) :
    (settleNested spec m).names = m.names := by
  unfold settleNested
  split
  · split <;> rfl
  · rfl

/-- Settling the defaults keeps every struct's shape. -/
theorem shapeOf_settleStructDefaults (spec : Lowered.Spec) :
    (settleStructDefaults spec).shapeOf = spec.shapeOf := by
  simp only [settleStructDefaults]
  rw [shapeOf_mapMembers _ fun m =>
      ⟨settleNested_names _ m, settleNested_value _ m⟩,
    shapeOf_mapMembers _ fun m => ⟨settleZero_names _ m, settleZero_value _ m⟩]

/--
In the settled spec, a nested zero value is of the struct its member holds,
and lines up with it, if the spec settled had none of its own.
-/
theorem settleStructDefaults_fields {spec : Lowered.Spec}
    (hnone : ∀ s ∈ spec.structs, ∀ m ∈ s.members, ∀ n values,
      m.default ≠ some (.fields n values))
    {s : Struct} {m : Member} {n : Names} {values : List (Names × Default)}
    (hs : s ∈ (settleStructDefaults spec).structs) (hm : m ∈ s.members)
    (hd : m.default = some (.fields n values)) :
    m.value = .struct n
      ∧ aligned (settleStructDefaults spec).shapeOf n values = true := by
  obtain ⟨s₁, hs₁, m₁, hm₁, rfl⟩ := mem_mapMembers hs hm
  obtain ⟨s₀, hs₀, m₀, hm₀, rfl⟩ := mem_mapMembers hs₁ hm₁
  rw [shapeOf_settleStructDefaults, settleNested_value, settleZero_value]
  have hd₁ : (settleZero spec m₀).default = some (.fields n values) := by
    rcases settleNested_default (mapMembers (settleZero spec) spec)
      (settleZero spec m₀) with h | h <;> rw [h] at hd
    · exact hd
    · simp at hd
  unfold settleZero at hd₁
  split at hd₁
  · next nested hzero hv =>
    simp only [Option.map_eq_some_iff, Default.fields.injEq] at hd₁
    obtain ⟨values', hz, rfl, rfl⟩ := hd₁
    exact ⟨hv, aligned_zeroFields hz⟩
  · exact absurd hd₁ (hnone s₀ hs₀ m₀ hm₀ n values)

/-! ## Lowering -/

/-- A default the spec gives is never a nested zero value. -/
theorem lowerDefault_ne_fields (r : Resolved.Spec) (d : Resolved.Default)
    (n : Names) (values : List (Names × Default)) :
    lowerDefault r d ≠ some (.fields n values) := by
  cases d with
  | entry target =>
    cases target <;> simp [lowerDefault, Option.bind_eq_some_iff]
  | _ => simp [lowerDefault]

/-- An implicit default is never a nested zero value. -/
theorem implicitDefault_ne_fields (r : Resolved.Spec)
    (p : Resolved.Parameter String) (v : Value) (n : Names)
    (values : List (Names × Default)) :
    implicitDefault r p v ≠ some (.fields n values) := by
  cases v with
  | enum _ | bitflag _ =>
    simp only [implicitDefault]
    split <;> simp [Option.bind_eq_some_iff]
  | string b => cases b <;> simp [implicitDefault]
  | _ => simp [implicitDefault]

/-- A lowered struct's defaults hold no nested zero value yet. -/
theorem lowerStruct_no_fields {ctx : DocContext} {r : Resolved.Spec}
    {s : Resolved.Struct} {m : Member} (hm : m ∈ (lowerStruct ctx r s).members)
    (n : Names) (values : List (Names × Default)) :
    m.default ≠ some (.fields n values) := by
  simp only [lowerStruct, Array.mem_map] at hm
  obtain ⟨p, -, rfl⟩ := hm
  simp only
  split
  · split
    · simp
    · exact lowerDefault_ne_fields r _ n values
  · cases hp : p.default with
    | none => simpa using implicitDefault_ne_fields r p _ n values
    | some d =>
      cases hl : lowerDefault r d with
      | none => simpa [hl] using implicitDefault_ne_fields r p _ n values
      | some x =>
        have := lowerDefault_ne_fields r d n values
        simp_all

/--
In the lowered spec, a nested zero value is of the struct its member holds,
and lines up with it: so the printer's `T.zero` names each member once, in
order.
-/
theorem lower_fields {r : Resolved.Spec} {sections : List (String × String)}
    {stubs : List (String × List String)} {s : Struct} {m : Member}
    {n : Names} {values : List (Names × Default)}
    (hs : s ∈ (lower r sections stubs).structs) (hm : m ∈ s.members)
    (hd : m.default = some (.fields n values)) :
    m.value = .struct n
      ∧ aligned (lower r sections stubs).shapeOf n values = true := by
  refine settleStructDefaults_fields ?_ hs hm hd
  intro s hs m hm
  simp only [structs_markRequiredChains, keepPassableExtensions,
    Array.mem_map] at hs
  obtain ⟨s₁, ⟨s₀, -, rfl⟩, rfl⟩ := hs
  exact lowerStruct_no_fields hm

end WebGPUGen.Lowered
