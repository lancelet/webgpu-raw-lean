import WebGPUGen.Emit.Lean

/-!
# Every zero value is found

The Lean printer prints a default of every byte zero, `fields`, as `.zero`,
which names a `T.zero` it must declare; `zeroValues` lists the ones to declare.
It prints `.zero` in two places: as a struct member's default, and among the
field values of a `T.zero` it declares. Both are listed:

    theorem zeroValues_complete :
      s ∈ structs → m ∈ s.members → m.default = some d → d.Within z →
        ∃ z' ∈ zeroValues structs, z'.1.c = z.1.c
    theorem zeroValues_closed :
      z ∈ zeroValues structs → (Default.fields z.1 z.2).Within z' →
        ∃ z'' ∈ zeroValues structs, z''.1.c = z'.1.c

`Default.Within` says what a zero value in a default is, apart from
`zeroValues`, which is checked against it both ways: a default's
`zeroValues` are exactly the zero values within it. Each struct has one
`T.zero`, so the one listed may come from another default naming the same
struct; that lowering gives both the same field values is not proved, but
`zeroFields` computes them from the struct alone.

That the struct of each zero value is bound, so that its `T.zero` is printed,
and that its field values line up with its members, is proved in `ZeroDecls`.
-/

namespace WebGPUGen.Emit.Lean
open WebGPUGen.Lowered

/-! ## A default's zero values -/

/-- The zero values of a field value are among those of its fields. -/
theorem zeroValues_subset_inner {values : List (Names × Lowered.Default)}
    {field : Names} {d : Lowered.Default} (h : (field, d) ∈ values) :
    ∀ z ∈ d.zeroValues, z ∈ Lowered.Default.zeroValues.inner values := by
  induction values with
  | nil => simp at h
  | cons x rest ih =>
    intro z hz
    simp only [Lowered.Default.zeroValues.inner, List.mem_append]
    rcases List.mem_cons.1 h with rfl | h
    · exact Or.inl hz
    · exact Or.inr (ih h z hz)

/-- A zero value of the fields is one of some field value. -/
theorem mem_inner {values : List (Names × Lowered.Default)}
    {z : Names × List (Names × Lowered.Default)}
    (h : z ∈ Lowered.Default.zeroValues.inner values) :
    ∃ field d, (field, d) ∈ values ∧ z ∈ d.zeroValues := by
  induction values with
  | nil => simp [Lowered.Default.zeroValues.inner] at h
  | cons x rest ih =>
    obtain ⟨field, d⟩ := x
    simp only [Lowered.Default.zeroValues.inner, List.mem_append] at h
    rcases h with h | h
    · exact ⟨field, d, List.mem_cons_self .., h⟩
    · obtain ⟨field', d', hmem, hz⟩ := ih h
      exact ⟨field', d', List.mem_cons_of_mem _ hmem, hz⟩

/-- A zero value within a default is among its zero values. -/
theorem mem_zeroValues_of_within {z : Names × List (Names × Lowered.Default)}
    {d : Lowered.Default} (h : d.Within z) : z ∈ d.zeroValues := by
  induction h with
  | here => simp [Lowered.Default.zeroValues]
  | field hmem _ ih =>
    simp only [Lowered.Default.zeroValues, List.mem_cons]
    exact Or.inr (zeroValues_subset_inner hmem _ ih)

/-- A default's zero values are within it. -/
theorem within_of_mem_zeroValues {z : Names × List (Names × Lowered.Default)} :
    ∀ {d : Lowered.Default}, z ∈ d.zeroValues → d.Within z
  | .fields struct values, h => by
    simp only [Lowered.Default.zeroValues, List.mem_cons] at h
    rcases h with rfl | h
    · exact .here
    · obtain ⟨field, d, hmem, hz⟩ := mem_inner h
      have := List.sizeOf_lt_of_mem hmem
      exact .field hmem (within_of_mem_zeroValues hz)
  | .bool _, h | .int _, h | .float _, h | .constant _, h | .entry .., h
  | .zero, h | .nested, h | .null, h | .empty, h => by
    simp [Lowered.Default.zeroValues] at h
termination_by d => sizeOf d
decreasing_by
  simp only [Lowered.Default.fields.sizeOf_spec, Prod.mk.sizeOf_spec] at *
  omega

/-- What is within a zero value within a default is within the default. -/
theorem within_trans {z z' : Names × List (Names × Lowered.Default)}
    {d : Lowered.Default} (h : d.Within z)
    (h' : (Lowered.Default.fields z.1 z.2).Within z') : d.Within z' := by
  induction h with
  | here => exact h'
  | field hmem _ ih => exact .field hmem ih

/-! ## The first of each -/

/--
`firstOfEach.go` keeps what it has, finds a zero value for each struct, and
takes nothing it was not given.
-/
theorem firstOfEach_go
    (acc zeros : List (Names × List (Names × Lowered.Default))) :
    (∀ z ∈ acc, z ∈ firstOfEach.go acc zeros)
      ∧ (∀ z ∈ zeros, ∃ z' ∈ firstOfEach.go acc zeros, z'.1.c = z.1.c)
      ∧ ∀ z ∈ firstOfEach.go acc zeros, z ∈ acc ∨ z ∈ zeros := by
  induction zeros generalizing acc with
  | nil => simp [firstOfEach.go]
  | cons x rest ih =>
    obtain ⟨n, f⟩ := x
    simp only [firstOfEach.go]
    split
    · next hany =>
      obtain ⟨hkeep, hfind, hfrom⟩ := ih acc
      refine ⟨hkeep, ?_, ?_⟩
      · intro z hz
        rcases List.mem_cons.1 hz with rfl | hz
        · obtain ⟨z', hz', he⟩ := List.any_eq_true.1 hany
          exact ⟨z', hkeep z' hz', by simpa using he⟩
        · exact hfind z hz
      · intro z hz
        rcases hfrom z hz with h | h
        · exact Or.inl h
        · exact Or.inr (List.mem_cons_of_mem _ h)
    · obtain ⟨hkeep, hfind, hfrom⟩ := ih (acc ++ [(n, f)])
      refine ⟨fun z hz => hkeep z (List.mem_append_left _ hz), ?_, ?_⟩
      · intro z hz
        rcases List.mem_cons.1 hz with rfl | hz
        · exact ⟨_, hkeep _ (by simp), rfl⟩
        · exact hfind z hz
      · intro z hz
        rcases hfrom z hz with h | h
        · rcases List.mem_append.1 h with h | h
          · exact Or.inl h
          · exact Or.inr (by simp_all)
        · exact Or.inr (List.mem_cons_of_mem _ h)

/-- `firstOfEach` has a zero value for each struct with one. -/
theorem firstOfEach_complete
    {zeros : List (Names × List (Names × Lowered.Default))}
    {z : Names × List (Names × Lowered.Default)} (h : z ∈ zeros) :
    ∃ z' ∈ firstOfEach zeros, z'.1.c = z.1.c :=
  (firstOfEach_go [] zeros).2.1 z h

/-- `firstOfEach` takes only what it was given. -/
theorem mem_of_mem_firstOfEach
    {zeros : List (Names × List (Names × Lowered.Default))}
    {z : Names × List (Names × Lowered.Default)} (h : z ∈ firstOfEach zeros) :
    z ∈ zeros := by
  rcases (firstOfEach_go [] zeros).2.2 z h with h | h
  · simp at h
  · exact h

/-! ## The structs' zero values -/

/-- Every zero value a struct's default is or holds is listed, by its struct. -/
theorem zeroValues_complete {structs : List Lowered.Struct}
    {s : Lowered.Struct} {m : Member} {d : Lowered.Default}
    {z : Names × List (Names × Lowered.Default)} (hs : s ∈ structs)
    (hm : m ∈ s.members) (hd : m.default = some d) (hz : d.Within z) :
    ∃ z' ∈ zeroValues structs, z'.1.c = z.1.c := by
  apply firstOfEach_complete
  have hmem := mem_zeroValues_of_within hz
  simp only [List.mem_flatMap]
  exact ⟨s, hs, m, by simpa using hm, by simpa [hd] using hmem⟩

/-- Every zero value listed is within a struct's default. -/
theorem zeroValues_sound {structs : List Lowered.Struct}
    {z : Names × List (Names × Lowered.Default)}
    (h : z ∈ zeroValues structs) :
    ∃ s ∈ structs, ∃ m ∈ s.members, ∃ d, m.default = some d ∧ d.Within z := by
  have h := mem_of_mem_firstOfEach h
  simp only [List.mem_flatMap] at h
  obtain ⟨s, hs, m, hm, hz⟩ := h
  cases hd : m.default with
  | none => simp [hd] at hz
  | some d =>
    simp only [hd, Option.map_some, Option.getD_some] at hz
    exact ⟨s, hs, m, by simpa using hm, d, hd, within_of_mem_zeroValues hz⟩

/--
Every zero value among the field values of a listed one is listed too, so each
`.zero` a `T.zero` declaration prints names one to declare.
-/
theorem zeroValues_closed {structs : List Lowered.Struct}
    {z z' : Names × List (Names × Lowered.Default)}
    (h : z ∈ zeroValues structs)
    (h' : (Lowered.Default.fields z.1 z.2).Within z') :
    ∃ z'' ∈ zeroValues structs, z''.1.c = z'.1.c := by
  obtain ⟨s, hs, m, hm, d, hd, hz⟩ := zeroValues_sound h
  exact zeroValues_complete hs hm hd (within_trans hz h')

end WebGPUGen.Emit.Lean
