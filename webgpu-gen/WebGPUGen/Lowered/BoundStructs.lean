import WebGPUGen.Lowered

/-!
# The bound structs

`boundStructs` picks the structs the bindings bind, each after the structs it
refers to, so that the Lean file declaring them in that order elaborates:

    theorem boundStructs_ordered (structs) : Ordered (boundStructs structs)
    theorem boundStructs_supported :
      s ∈ boundStructs structs → s ∈ structs ∧ s.unsupported.isEmpty

So every struct a bound struct refers to is bound too, and comes before it:

    theorem boundStructs_closed : s ∈ boundStructs structs →
      ∀ r ∈ s.references, ∃ t ∈ boundStructs structs, t.names = r

A reference is a value's `structRef?`, which names a struct however the
value's Lean type does, so these are the structs the Lean file names. All
three follow from invariants of `boundStructs.go`, which holds a list in order
(`done`) and the structs still waiting (`rest`).
-/

namespace WebGPUGen.Lowered

/--
Each struct of `l` comes after the structs it refers to: for each reference,
an earlier struct has its names, the Lean one by which the Lean file refers to
it, and the C one.
-/
def Ordered (l : List Struct) : Prop :=
  ∀ i (hi : i < l.length), ∀ r ∈ l[i].references,
    ∃ t ∈ l.take i, t.names = r

/-- An empty list is in order. -/
theorem ordered_nil : Ordered [] := by
  simp [Ordered]

/-- Structs that refer only to those of an ordered list can follow it. -/
theorem ordered_append {done ready : List Struct} (h : Ordered done)
    (hready : ∀ s ∈ ready, ∀ r ∈ s.references, ∃ t ∈ done, t.names = r) :
    Ordered (done ++ ready) := by
  intro i hi r hr
  by_cases hd : i < done.length
  · rw [List.getElem_append_left hd] at hr
    obtain ⟨t, ht, he⟩ := h i hd r hr
    exact ⟨t, by rw [List.take_append_of_le_length (by omega)]; exact ht, he⟩
  · rw [List.getElem_append_right (by omega)] at hr
    obtain ⟨t, ht, he⟩ := hready _ (List.getElem_mem _) r hr
    refine ⟨t, ?_, he⟩
    rw [List.take_append,
      List.take_of_length_le (by omega : done.length ≤ i)]
    exact List.mem_append_left _ ht

/-- `go` keeps its list in order. -/
theorem boundStructs_go_ordered {fuel : Nat} {done rest : List Struct}
    (h : Ordered done) : Ordered (boundStructs.go fuel done rest) := by
  induction fuel generalizing done rest with
  | zero => simpa [boundStructs.go]
  | succ n ih =>
    simp only [boundStructs.go]
    split
    · exact h
    · apply ih
      apply ordered_append h
      intro s hs r hr
      simp only [List.mem_filter, List.all_eq_true, List.any_eq_true,
        beq_iff_eq] at hs
      exact hs.2 r hr

/-- `go` binds only structs it was given, in `done` or `rest`. -/
theorem boundStructs_go_mem {P : Struct → Prop} {fuel : Nat}
    {done rest : List Struct} (hdone : ∀ s ∈ done, P s)
    (hrest : ∀ s ∈ rest, P s) : ∀ s ∈ boundStructs.go fuel done rest, P s := by
  induction fuel generalizing done rest with
  | zero => simpa [boundStructs.go]
  | succ n ih =>
    simp only [boundStructs.go]
    split
    · exact hdone
    · apply ih
      · intro s hs
        rcases List.mem_append.1 hs with hs | hs
        · exact hdone s hs
        · exact hrest s (List.mem_filter.1 hs).1
      · intro s hs
        exact hrest s (List.mem_filter.1 hs).1

/-- The bound structs are in order: each after the structs it refers to. -/
theorem boundStructs_ordered (structs : List Struct) :
    Ordered (boundStructs structs) :=
  boundStructs_go_ordered ordered_nil

/-- A bound struct is one of those given, and holds nothing unsupported. -/
theorem boundStructs_supported {structs : List Struct} {s : Struct}
    (h : s ∈ boundStructs structs) : s ∈ structs ∧ s.unsupported.isEmpty :=
  boundStructs_go_mem (P := fun s => s ∈ structs ∧ s.unsupported.isEmpty)
    (by simp) (fun _ hs => List.mem_filter.1 hs) s h

/-- Every struct a bound struct refers to is bound too. -/
theorem boundStructs_closed {structs : List Struct} {s : Struct}
    (h : s ∈ boundStructs structs) :
    ∀ r ∈ s.references, ∃ t ∈ boundStructs structs, t.names = r := by
  intro r hr
  obtain ⟨i, hi, rfl⟩ := List.getElem_of_mem h
  obtain ⟨t, ht, he⟩ := boundStructs_ordered structs i hi r hr
  exact ⟨t, List.mem_of_mem_take ht, he⟩

end WebGPUGen.Lowered
