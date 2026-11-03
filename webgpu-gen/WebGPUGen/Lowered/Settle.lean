import WebGPUGen.Lowered.Lower

/-!
# Settled struct defaults

`settleStructDefaults` settles the defaults that refer to other structs. A
`zero` default becomes its field values (`fields`), which the printer prints as
`.zero`, declaring `T.zero` from them; an unsettled `zero` would print `.zero`
with no declaration. A `nested` default, printed `{}`, stands only if the nested
struct needs nothing given. After it:

    theorem settleStructDefaults_no_zero :
      (a struct member of the settled spec) → m.value = .struct n →
        m.default ≠ some .zero
    theorem settleStructDefaults_nested :
      (a struct member of the settled spec) → m.default = some .nested →
        m.value = .struct n → complete (settleStructDefaults spec) n fuel

So each `{}` names a struct that needs nothing given in the settled spec,
found by its C name. `complete` decides that with `fuel` as a bound on the
nesting (any fuel from `size + 1` up, by `complete_le`): true means every
member has a default, at every depth.

With C names distinct, as the generator checks, the struct found is the one the
Lean file names, and each `.zero` names a declared `T.zero` (`Emit/ZeroDecls`).
Not proved: that each entry and constant a default names exists, and that
every member of a bound struct is printed.
-/

namespace WebGPUGen.Lowered
open WebGPUGen.Common

/-! ## Mapping members -/

/-- Mapping members keeps each struct, found by its C name. -/
theorem find?_mapMembers (f : Member → Member) (spec : Lowered.Spec)
    (n : Names) :
    (mapMembers f spec).structs.find? (·.names.c == n.c)
      = (spec.structs.find? (·.names.c == n.c)).map fun s =>
        { s with members := s.members.map f } := by
  simp [mapMembers, Array.find?_map, Function.comp_def]

/-- A member of a struct of the mapped spec is `f` of a member of the spec's. -/
theorem mem_mapMembers {f : Member → Member} {spec : Lowered.Spec}
    {s : Struct} {m : Member} (hs : s ∈ (mapMembers f spec).structs)
    (hm : m ∈ s.members) :
    ∃ s₀ ∈ spec.structs, ∃ m₀ ∈ s₀.members, m = f m₀ := by
  simp only [mapMembers, Array.mem_map] at hs
  obtain ⟨s₀, hs₀, rfl⟩ := hs
  simp only [Array.mem_map] at hm
  obtain ⟨m₀, hm₀, rfl⟩ := hm
  exact ⟨s₀, hs₀, m₀, hm₀, rfl⟩

/-! ## Completeness -/

/-- A struct complete at some fuel is complete with more. -/
theorem complete_succ {spec : Lowered.Spec} {n : Names} {k : Nat}
    (h : complete spec n k = true) : complete spec n (k + 1) = true := by
  induction k generalizing n with
  | zero => simp [complete] at h
  | succ k ih =>
    rw [complete] at h ⊢
    cases hf : spec.structs.find? (·.names.c == n.c) with
    | none => simp [hf] at h
    | some s =>
      simp only [hf, Array.all_eq_true] at h ⊢
      intro i hi
      have hm := h i hi
      split at hm
      · exact ih hm
      · rfl
      · simp at hm

/-- A struct complete at some fuel is complete with any more. -/
theorem complete_le {spec : Lowered.Spec} {n : Names} {k k' : Nat}
    (hk : k ≤ k') (h : complete spec n k = true) :
    complete spec n k' = true := by
  induction hk with
  | refl => exact h
  | step _ ih => exact complete_succ ih

/--
Settling `nested` defaults keeps a struct complete: a nested struct it needs is
complete, so its member keeps its default.
-/
theorem complete_settleNested {spec : Lowered.Spec} {n : Names} {k : Nat}
    (hk : k ≤ spec.structs.size + 1) (h : complete spec n k = true) :
    complete (mapMembers (settleNested spec) spec) n k = true := by
  induction k generalizing n with
  | zero => simp [complete] at h
  | succ k ih =>
    rw [complete] at h ⊢
    rw [find?_mapMembers]
    cases hf : spec.structs.find? (·.names.c == n.c) with
    | none => simp [hf] at h
    | some s =>
      simp only [hf, Option.map_some, Array.all_map, Array.all_eq_true,
        Function.comp_def] at h ⊢
      intro i hi
      have hm := h i hi
      generalize s.members[i] = m at hm ⊢
      -- Settling keeps the member: a nested struct it needs is complete.
      have hkeep : settleNested spec m = m := by
        unfold settleNested
        split
        · next nested hd hv =>
          simp only [hd, hv] at hm
          rw [if_pos (complete_le (by omega) hm)]
        · rfl
      rw [hkeep]
      split at hm
      · exact ih (by omega) hm
      · rfl
      · simp at hm

/-! ## Settling a member -/

/-- Settling a `zero` default keeps the member's value. -/
theorem settleZero_value (spec : Lowered.Spec) (m : Member) :
    (settleZero spec m).value = m.value := by
  unfold settleZero
  split <;> rfl

/-- Settling a `nested` default keeps the member's value. -/
theorem settleNested_value (spec : Lowered.Spec) (m : Member) :
    (settleNested spec m).value = m.value := by
  unfold settleNested
  split
  · split <;> rfl
  · rfl

/-- Settling a `nested` default keeps it, or leaves none. -/
theorem settleNested_default (spec : Lowered.Spec) (m : Member) :
    (settleNested spec m).default = m.default
      ∨ (settleNested spec m).default = none := by
  unfold settleNested
  split
  · split <;> simp
  · simp

/-! ## The settled spec -/

/-- No struct member of the settled spec has a `zero` default. -/
theorem settleStructDefaults_no_zero {spec : Lowered.Spec} {s : Struct}
    {m : Member} {n : Names} (hs : s ∈ (settleStructDefaults spec).structs)
    (hm : m ∈ s.members) (hv : m.value = .struct n) :
    m.default ≠ some .zero := by
  obtain ⟨s₁, hs₁, m₁, hm₁, rfl⟩ := mem_mapMembers hs hm
  obtain ⟨-, -, m₀, -, rfl⟩ := mem_mapMembers hs₁ hm₁
  rw [settleNested_value, settleZero_value] at hv
  intro h
  rcases settleNested_default (mapMembers (settleZero spec) spec)
    (settleZero spec m₀) with h' | h' <;> rw [h'] at h
  · unfold settleZero at h
    split at h
    · simp [Option.map_eq_some_iff] at h
    · next hne => exact hne _ h hv
  · simp at h

/--
A `nested` default of the settled spec names a struct that needs nothing
given, in the settled spec.
-/
theorem settleStructDefaults_nested {spec : Lowered.Spec} {s : Struct}
    {m : Member} {n : Names} (hs : s ∈ (settleStructDefaults spec).structs)
    (hm : m ∈ s.members) (hd : m.default = some .nested)
    (hv : m.value = .struct n) :
    complete (settleStructDefaults spec) n
      ((settleStructDefaults spec).structs.size + 1) = true := by
  obtain ⟨-, -, m₀, -, rfl⟩ := mem_mapMembers hs hm
  generalize hz : mapMembers (settleZero spec) spec = zeros at *
  have hsize : (mapMembers (settleNested zeros) zeros).structs.size
      = zeros.structs.size := by
    simp [mapMembers]
  simp only [settleStructDefaults, hz, hsize]
  apply complete_settleNested (Nat.le_refl _)
  rw [settleNested_value] at hv
  have hd₀ : m₀.default = some .nested := by
    rcases settleNested_default zeros m₀ with h | h <;> rw [h] at hd
    · exact hd
    · simp at hd
  unfold settleNested at hd
  simp only [hd₀, hv] at hd
  split at hd
  · assumption
  · simp at hd

end WebGPUGen.Lowered
