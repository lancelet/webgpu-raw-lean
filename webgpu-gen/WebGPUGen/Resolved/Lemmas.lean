import WebGPUGen.Resolved.Resolve

/-!
# Lemmas about resolution's helpers

Facts about `indexOf?`, `eachAt`, `duplicates`, references (`refIndex?`,
`checkRef`, `checkCallbackName`), `checkSection` and `check`, for the proofs
that `build` is sound and faithful. Each `…_eq_nil` lemma turns "this
check reports nothing" into a plain logical statement.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-! ## `indexOf?` -/

/-- If `indexOf?` finds position `i`, the item there has key `k`, and no
earlier item does. -/
theorem indexOf?_some {α β} [BEq β] [LawfulBEq β] {key : α → β} {xs : Array α} {k : β}
    {i : Fin xs.size} (h : indexOf? key xs k = some i) :
    key xs[i] = k ∧ ∀ j : Fin xs.size, j < i → key xs[j] ≠ k := by
  unfold indexOf? at h
  rw [Array.findFinIdx?_eq_some_iff] at h
  obtain ⟨hi, hj⟩ := h
  exact ⟨by simpa using hi, fun j lt => by simpa using hj j lt⟩

/-- `indexOf?` finds nothing exactly when no item has key `k`. -/
theorem indexOf?_none {α β} [BEq β] [LawfulBEq β] {key : α → β} {xs : Array α} {k : β} :
    indexOf? key xs k = none ↔ ∀ x ∈ xs, key x ≠ k := by
  unfold indexOf?
  rw [Array.findFinIdx?_eq_none_iff]
  simp

/-- `indexOf?` finds something exactly when some item has key `k`. -/
theorem indexOf?_isSome {α β} [BEq β] [LawfulBEq β] {key : α → β} {xs : Array α} {k : β} :
    (indexOf? key xs k).isSome ↔ ∃ x ∈ xs, key x = k := by
  rw [← Option.ne_none_iff_isSome, ne_eq, indexOf?_none]
  simp

/-- When some item has key `k`, `indexOf` gives a position in range whose item
has key `k`. -/
theorem indexOf_spec {α β} [BEq β] [LawfulBEq β] {key : α → β} {xs : Array α} {k : β}
    (h : ∃ x ∈ xs, key x = k) :
    ∃ lt : indexOf key xs k < xs.size, key xs[indexOf key xs k] = k := by
  obtain ⟨i, hi⟩ := Option.isSome_iff_exists.mp (indexOf?_isSome.mpr h)
  have hidx : indexOf key xs k = i.val := by simp [indexOf, hi]
  exact ⟨hidx ▸ i.isLt, by simp only [hidx]; exact (indexOf?_some hi).1⟩

/-! ## `eachAt` -/

/-- `eachAt` reports nothing exactly when the check reports nothing for each
item, at that item's path (`path`, then `key`, then `[i]`). -/
theorem eachAt_eq_nil {α} {path : Array String} {key : String} {xs : Array α}
    {f : Array String → α → List Problem} :
    eachAt path key xs f = [] ↔
      ∀ i (h : i < xs.size), f ((path.push key).push s!"[{i}]") xs[i] = [] := by
  unfold eachAt
  rw [List.flatMap_eq_nil_iff]
  constructor
  · intro H i h
    exact H (xs[i], i) (by rw [List.mem_zipIdx_iff_getElem?]; simp [h])
  · rintro H ⟨x, i⟩ hm
    rw [List.mem_zipIdx_iff_getElem?] at hm
    simp only [Array.getElem?_toList, Array.getElem?_eq_some_iff] at hm
    obtain ⟨h, rfl⟩ := hm
    exact H i h

/-- A check that reports nothing for any item makes `eachAt` report nothing. -/
theorem eachAt_eq_nil_of_forall {α} {path : Array String} {key : String} {xs : Array α}
    {f : Array String → α → List Problem} (H : ∀ p x, f p x = []) :
    eachAt path key xs f = [] :=
  eachAt_eq_nil.mpr fun _ _ => H _ _

/-- If `eachAt` reports nothing, the check reports nothing for each item, at
some path. Later proofs never look at the path, and work by membership. -/
theorem eachAt_eq_nil_mem {α} {path : Array String} {key : String} {xs : Array α}
    {f : Array String → α → List Problem} (H : eachAt path key xs f = []) :
    ∀ x ∈ xs.toList, ∃ p, f p x = [] := by
  intro x hx
  obtain ⟨i, h, rfl⟩ := List.getElem_of_mem hx
  exact ⟨_, eachAt_eq_nil.mp H i h⟩

/-! ## `duplicates` -/

/-- `duplicates` reports nothing exactly when no name occurs earlier in the
list than at any position where it appears. Unnamed slots (`none`) are
ignored. -/
theorem duplicates_eq_nil {path : Array String} {key : String} {names : List (Option Name)} :
    duplicates path key names = [] ↔
      ∀ i (h : i < names.length) n, names[i] = some n → some n ∉ names.take i := by
  unfold duplicates
  rw [List.flatMap_eq_nil_iff]
  constructor
  · intro H i h n hn hmem
    have := H (names[i], i) (by rw [List.mem_zipIdx_iff_getElem?]; simp)
    simp only [hn] at this
    split at this <;> simp_all [problem]
  · rintro H ⟨x, i⟩ hm
    rw [List.mem_zipIdx_iff_getElem?, List.getElem?_eq_some_iff] at hm
    obtain ⟨h, hx⟩ := hm
    match x, hx with
    | none,   _  => rfl
    | some n, hx =>
      have := H i h n hx
      simp_all

/-- The names (unnamed slots aside) are distinct exactly when none occurs
earlier than at a position where it appears. -/
theorem nodup_filterMap_id_iff {l : List (Option Name)} :
    (l.filterMap id).Nodup ↔
      ∀ j (h : j < l.length) n, l[j] = some n → some n ∉ l.take j := by
  rw [List.nodup_iff_pairwise_ne, List.pairwise_filterMap, List.pairwise_iff_getElem]
  constructor
  · intro H j hj n hn hmem
    rw [List.mem_take_iff_getElem] at hmem
    obtain ⟨i, hi, heq⟩ := hmem
    exact H i j (by omega) hj (by omega) n (by simp [heq]) n (by simp [hn]) rfl
  · intro H i j hi hj hij x hx y hy hxy
    subst hxy
    apply H j hj x hy
    rw [List.mem_take_iff_getElem]
    exact ⟨i, by omega, hx⟩

/-- `duplicates` reports nothing exactly when the names, unnamed slots aside,
are distinct. -/
theorem duplicates_eq_nil_iff_nodup {path : Array String} {key : String}
    {names : List (Option Name)} :
    duplicates path key names = [] ↔ (names.filterMap id).Nodup := by
  rw [duplicates_eq_nil, nodup_filterMap_id_iff]

/-- For a section, where every entry is named: `duplicates` reports nothing
exactly when the names are distinct. -/
theorem duplicates_map_some_eq_nil {α} {path : Array String} {key : String} {xs : List α}
    {name : α → Name} :
    duplicates path key (xs.map fun x => some (name x)) = [] ↔ (xs.map name).Nodup := by
  rw [duplicates_eq_nil_iff_nodup, List.filterMap_map]
  simp

/-- For an enum's entries, where reserved slots are unnamed: `duplicates`
reports nothing exactly when the entries' names are distinct. -/
theorem duplicates_slotName_eq_nil {path : Array String} {key : String}
    {slots : List (Option EnumEntry)} :
    duplicates path key (slots.map slotName) = [] ↔
      (slots.filterMap (·.map (·.name))).Nodup := by
  rw [duplicates_eq_nil_iff_nodup, List.filterMap_map]
  rfl

/-! ## References -/

/-- A reference of kind `kind` to `n` is found exactly when that kind has a
list of names and `n` is in it. -/
theorem refIndex?_isSome {s : Parsed.Spec} {kind : RefKind} {n : Name} :
    (refIndex? s kind n).isSome ↔ ∃ names, namesOf s kind = some names ∧ n ∈ names := by
  unfold refIndex?
  cases namesOf s kind with
  | none       => simp
  | some names =>
    simp only [Option.bind_some, Option.some.injEq, exists_eq_left']
    rw [← Option.ne_none_iff_isSome, ne_eq, Array.findIdx?_eq_none_iff]
    simp

/-- `checkRef` reports nothing exactly when the reference is not to a function
type and names an existing entry. -/
theorem checkRef_eq_nil {s : Parsed.Spec} {path : Array String} {kind : RefKind} {n : Name} :
    checkRef s path kind n = [] ↔ kind ≠ .functionType ∧ (refIndex? s kind n).isSome := by
  unfold checkRef
  cases kind <;> simp [problem, Option.ne_none_iff_isSome]

/-- `checkCallbackName` reports nothing exactly when a callback named `n`
exists. -/
theorem checkCallbackName_eq_nil {s : Parsed.Spec} {path : Array String} {n : Name} :
    checkCallbackName s path n = [] ↔ ∃ c ∈ s.callbacks, c.name = n := by
  unfold checkCallbackName
  rw [← indexOf?_isSome]
  split <;> simp_all [problem]

/-! ## Sections and `check` -/

/-- A section passes exactly when its names are distinct and each entry passes
its own check. -/
theorem checkSection_eq_nil {α} {key : String} {xs : Array α} {name : α → Name}
    {f : Array String → α → List Problem} :
    checkSection key xs name f = [] ↔
      duplicates #[] key (xs.toList.map fun x => some (name x)) = []
        ∧ eachAt #[] key xs f = [] := by
  unfold checkSection
  exact List.append_eq_nil_iff

/-- A spec passes `check` exactly when every section passes. -/
theorem check_eq_nil {s : Parsed.Spec} :
    check s = [] ↔
      checkConstants s = [] ∧ checkTypedefs s  = [] ∧ checkEnums     s = [] ∧
      checkBitflags  s = [] ∧ checkStructs  s  = [] ∧ checkCallbacks s = [] ∧
      checkFunctions s = [] ∧ checkObjects  s  = [] := by
  unfold check
  simp only [List.append_eq_nil_iff, and_assoc]

end WebGPUGen.Resolved
