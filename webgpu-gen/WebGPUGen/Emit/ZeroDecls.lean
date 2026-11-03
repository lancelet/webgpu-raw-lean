import WebGPUGen.Emit.ZeroValues
import WebGPUGen.Lowered.BoundStructs
import WebGPUGen.Lowered.ZeroFields

/-!
# Every printed zero value is declared, and right

The Lean printer prints the bound structs (`boundStructs`), each followed by
its `T.zero` if `zeroValues` lists one for it, found by its C name. It prints
`.zero`, naming a `T.zero`, as a member's default and among a `T.zero`'s field
values. If the structs' C names are distinct, as the generator checks, then for
the lowered spec:

    theorem lower_zero_declared :
      s ∈ bound → m ∈ s.members → m.default = some d → d.Within z →
        Declared (lower r) z.1
    theorem lower_zero_closed :
      z ∈ zeroValues bound → (Default.fields z.1 z.2).Within z' →
        Declared (lower r) z'.1
    theorem lower_zero_aligned :
      s ∈ bound → (zeroValues bound).find? (·.1.c == s.names.c) = some z →
        z.1 = s.names ∧ aligned (shape of s) s.names z.2

`Declared` says a struct is bound and the printer finds a zero value for it, by
its C name, so declares its `T.zero`. So each `.zero` printed names a declared
`T.zero`; each `T.zero` declared has its struct's field values, aligned with
its members (`aligned_names`): one for each, in order, each fitting it; and
each `.zero` names a struct printed before the struct or `T.zero` using it
(`zero_before_member`, `zero_before_zero`), as Lean needs. A `nested` default,
printed `{}`, is of a bound struct, the one `complete` finds (`nested_found`).
-/

namespace WebGPUGen.Emit.Lean
open WebGPUGen.Lowered

/-! ## Finding structs by their C names -/

/-- In a list with distinct keys, finding an item by its key finds it. -/
theorem find?_of_nodup {α} {f : α → String} :
    ∀ {l : List α} {x : α}, (l.map f).Nodup → x ∈ l →
      l.find? (fun y => f y == f x) = some x
  | [], _, _, h => by simp at h
  | y :: ys, x, hnodup, hx => by
    simp only [List.map_cons, List.nodup_cons, List.mem_map] at hnodup
    obtain ⟨hy, hnodup⟩ := hnodup
    rcases List.mem_cons.1 hx with rfl | hx
    · simp
    · have hne : f y ≠ f x := fun h => hy ⟨x, hx, h.symm⟩
      simp [hne, find?_of_nodup hnodup hx]

/-- With distinct C names, a struct is found by its C name. -/
theorem find?_of_distinct {spec : Lowered.Spec}
    (hdistinct : spec.structNamesDistinct) {t : Struct}
    (ht : t ∈ spec.structs.toList) :
    spec.structs.find? (·.names.c == t.names.c) = some t := by
  rw [← Array.find?_toList]
  exact find?_of_nodup hdistinct ht

/-- With distinct C names, two structs with one C name are one. -/
theorem eq_of_distinct {spec : Lowered.Spec}
    (hdistinct : spec.structNamesDistinct) {s t : Struct}
    (hs : s ∈ spec.structs.toList) (ht : t ∈ spec.structs.toList)
    (h : s.names.c = t.names.c) : s = t := by
  have hs' := find?_of_distinct hdistinct hs
  rw [h] at hs'
  rw [find?_of_distinct hdistinct ht] at hs'
  exact (Option.some.inj hs').symm

/-- With distinct C names, a struct's shape is its members' names and values. -/
theorem shapeOf_of_distinct {spec : Lowered.Spec}
    (hdistinct : spec.structNamesDistinct) {t : Struct}
    (ht : t ∈ spec.structs.toList) :
    spec.shapeOf t.names
      = some (t.members.toList.map fun m => (m.names, m.value)) := by
  simp [Spec.shapeOf, find?_of_distinct hdistinct ht]

/-! ## The structs of zero values are bound -/

/-- A default with a zero value within it is a zero value itself. -/
theorem fields_of_within {z : Names × List (Names × Default)} {d : Default}
    (h : d.Within z) : ∃ n values, d = .fields n values := by
  cases h <;> exact ⟨_, _, rfl⟩

/-- A struct with a member holding another struct refers to it. -/
theorem mem_references {t : Struct} {m : Member} {n : Names}
    (hm : m ∈ t.members) (hv : m.value = .struct n) : n ∈ t.references := by
  simp only [Struct.references, List.mem_filterMap]
  exact ⟨m, by simpa using hm, by simp [hv, Value.structRef?]⟩

/--
With distinct C names, a zero value within an aligned one of a bound struct is
of a bound struct too: each is held by a member of the one around it, which
refers to it.
-/
theorem bound_of_within {L : Lowered.Spec} (hdistinct : L.structNamesDistinct)
    {z : Names × List (Names × Default)} {d : Default} (h : d.Within z) :
    ∀ {n : Names} {values : List (Names × Default)}, d = .fields n values →
      aligned L.shapeOf n values = true →
      (∃ t ∈ boundStructs L.structs.toList, t.names = n) →
      ∃ t ∈ boundStructs L.structs.toList, t.names = z.1 := by
  induction h with
  | here =>
    intro n values heq _ hbound
    injection heq with hn
    exact hn ▸ hbound
  | field hmem hw ih =>
    intro n values heq ha hbound
    injection heq with hn hvalues
    subst hn hvalues
    obtain ⟨t, ht, rfl⟩ := hbound
    obtain ⟨n₂, values₂, rfl⟩ := fields_of_within hw
    unfold aligned at ha
    rw [shapeOf_of_distinct hdistinct (boundStructs_supported ht).1] at ha
    dsimp only at ha
    obtain ⟨p, hp, hfield⟩ := alignedField_of_mem ha hmem
    simp only [alignedField, Bool.and_eq_true, beq_iff_eq] at hfield
    obtain ⟨hv, ha₂⟩ := hfield
    simp only [List.mem_map] at hp
    obtain ⟨m, hm, rfl⟩ := hp
    obtain ⟨t₂, ht₂, he⟩ :=
      boundStructs_closed ht n₂ (mem_references (by simpa using hm) hv)
    exact ih rfl ha₂ ⟨t₂, ht₂, he⟩

/-! ## Declared, and right -/

/--
What lowering gives every zero-value default: it is of the struct its member
holds, and lines up with it (`lower_fields`).
-/
def FieldsAligned (L : Lowered.Spec) : Prop :=
  ∀ s ∈ L.structs, ∀ m ∈ s.members, ∀ n values,
    m.default = some (.fields n values) →
      m.value = .struct n ∧ aligned L.shapeOf n values = true

/--
The struct `n` is bound, and the printer finds a zero value for it, by its C
name, so declares its `T.zero` after it.
-/
def Declared (L : Lowered.Spec) (n : Names) : Prop :=
  ∃ t ∈ boundStructs L.structs.toList, t.names = n
    ∧ ((zeroValues (boundStructs L.structs.toList)).find?
      (·.1.c == t.names.c)).isSome

/-- A bound struct with a zero value listed is declared. -/
theorem declared_of_listed {L : Lowered.Spec} {n : Names}
    (hbound : ∃ t ∈ boundStructs L.structs.toList, t.names = n)
    (hlisted : ∃ z ∈ zeroValues (boundStructs L.structs.toList), z.1.c = n.c) :
    Declared L n := by
  obtain ⟨t, ht, rfl⟩ := hbound
  obtain ⟨z, hz, hc⟩ := hlisted
  exact ⟨t, ht, rfl, List.find?_isSome.2 ⟨z, hz, by simp [hc]⟩⟩

/-- Each zero value a bound struct's default is or holds is declared. -/
theorem zero_declared {L : Lowered.Spec} (hdistinct : L.structNamesDistinct)
    (hfields : FieldsAligned L) {s : Struct} {m : Member} {d : Default}
    {z : Names × List (Names × Default)}
    (hs : s ∈ boundStructs L.structs.toList) (hm : m ∈ s.members)
    (hd : m.default = some d) (hz : d.Within z) : Declared L z.1 := by
  refine declared_of_listed ?_ (zeroValues_complete hs hm hd hz)
  obtain ⟨n, values, rfl⟩ := fields_of_within hz
  have hsL : s ∈ L.structs := by simpa using (boundStructs_supported hs).1
  obtain ⟨hv, ha⟩ := hfields s hsL m hm n values hd
  obtain ⟨t, ht, he⟩ := boundStructs_closed hs n (mem_references hm hv)
  exact bound_of_within hdistinct hz rfl ha ⟨t, ht, he⟩

/-- Each zero value listed is of a bound struct, and lines up with it. -/
theorem listed_aligned {L : Lowered.Spec} (hdistinct : L.structNamesDistinct)
    (hfields : FieldsAligned L) {z : Names × List (Names × Default)}
    (h : z ∈ zeroValues (boundStructs L.structs.toList)) :
    (∃ t ∈ boundStructs L.structs.toList, t.names = z.1)
      ∧ aligned L.shapeOf z.1 z.2 = true := by
  obtain ⟨s, hs, m, hm, d, hd, hz⟩ := zeroValues_sound h
  obtain ⟨t, ht, he, -⟩ := zero_declared hdistinct hfields hs hm hd hz
  refine ⟨⟨t, ht, he⟩, ?_⟩
  obtain ⟨n, values, rfl⟩ := fields_of_within hz
  have hsL : s ∈ L.structs := by simpa using (boundStructs_supported hs).1
  exact aligned_of_within (hfields s hsL m hm n values hd).2 hz

/-- Each zero value among a listed one's field values is declared. -/
theorem zero_closed {L : Lowered.Spec} (hdistinct : L.structNamesDistinct)
    (hfields : FieldsAligned L) {z z' : Names × List (Names × Default)}
    (h : z ∈ zeroValues (boundStructs L.structs.toList))
    (h' : (Default.fields z.1 z.2).Within z') : Declared L z'.1 := by
  obtain ⟨hbound, ha⟩ := listed_aligned hdistinct hfields h
  exact declared_of_listed (bound_of_within hdistinct h' rfl ha hbound)
    (zeroValues_closed h h')

/--
The zero value the printer finds for a bound struct, by its C name, is that
struct's, and lines up with its members.
-/
theorem zero_aligned {L : Lowered.Spec} (hdistinct : L.structNamesDistinct)
    (hfields : FieldsAligned L) {s : Struct}
    {z : Names × List (Names × Default)}
    (hs : s ∈ boundStructs L.structs.toList)
    (h : (zeroValues (boundStructs L.structs.toList)).find?
      (·.1.c == s.names.c) = some z) :
    z.1 = s.names
      ∧ aligned L.shapeOf s.names z.2 = true
      ∧ L.shapeOf s.names
        = some (s.members.toList.map fun m => (m.names, m.value)) := by
  have hc : z.1.c = s.names.c := by simpa using List.find?_some h
  obtain ⟨⟨t, ht, he⟩, ha⟩ :=
    listed_aligned hdistinct hfields (List.mem_of_find?_eq_some h)
  have hts : t = s := eq_of_distinct hdistinct (boundStructs_supported ht).1
    (boundStructs_supported hs).1 (by rw [he, hc])
  subst hts
  exact ⟨he.symm, he ▸ ha, shapeOf_of_distinct hdistinct
    (boundStructs_supported ht).1⟩

/-! ## Declared before use -/

/--
The printer prints the bound structs in order, each followed by its `T.zero`:
so a `T.zero` is declared before a use in a struct that comes after its own.
A zero-value default of the `i`th bound struct names one that comes before it.
-/
theorem zero_before_member {L : Lowered.Spec} (hfields : FieldsAligned L)
    {i : Nat} (hi : i < (boundStructs L.structs.toList).length) {m : Member}
    (hm : m ∈ (boundStructs L.structs.toList)[i].members) {n : Names}
    {values : List (Names × Default)}
    (hd : m.default = some (.fields n values)) :
    ∃ t ∈ (boundStructs L.structs.toList).take i, t.names = n := by
  have hsL : (boundStructs L.structs.toList)[i] ∈ L.structs := by
    simpa using (boundStructs_supported (List.getElem_mem hi)).1
  obtain ⟨hv, -⟩ := hfields _ hsL m hm n values hd
  exact boundStructs_ordered _ i hi n (mem_references hm hv)

/--
A zero value among the field values of the `i`th bound struct's `T.zero`
names a struct that comes before it.
-/
theorem zero_before_zero {L : Lowered.Spec} (hdistinct : L.structNamesDistinct)
    (hfields : FieldsAligned L) {i : Nat}
    (hi : i < (boundStructs L.structs.toList).length)
    {z : Names × List (Names × Default)}
    (h : (zeroValues (boundStructs L.structs.toList)).find?
      (·.1.c == (boundStructs L.structs.toList)[i].names.c) = some z)
    {field n : Names} {values : List (Names × Default)}
    (hmem : (field, .fields n values) ∈ z.2) :
    ∃ t ∈ (boundStructs L.structs.toList).take i, t.names = n := by
  obtain ⟨-, ha, hshape⟩ :=
    zero_aligned hdistinct hfields (List.getElem_mem hi) h
  unfold aligned at ha
  rw [hshape] at ha
  dsimp only at ha
  obtain ⟨p, hp, hfield⟩ := alignedField_of_mem ha hmem
  simp only [alignedField, Bool.and_eq_true, beq_iff_eq] at hfield
  simp only [List.mem_map] at hp
  obtain ⟨m, hm, rfl⟩ := hp
  exact boundStructs_ordered _ i hi n
    (mem_references (by simpa using hm) hfield.1)

/-! ## Nested defaults -/

/--
A `nested` default, printed `{}`, is of a bound struct, the one the Lean file
names, which is the struct `complete` finds by its C name.
-/
theorem nested_found {L : Lowered.Spec} (hdistinct : L.structNamesDistinct)
    {s : Struct} {m : Member} {n : Names}
    (hs : s ∈ boundStructs L.structs.toList) (hm : m ∈ s.members)
    (hv : m.value = .struct n) :
    ∃ t ∈ boundStructs L.structs.toList, t.names = n
      ∧ L.structs.find? (·.names.c == n.c) = some t := by
  obtain ⟨t, ht, rfl⟩ := boundStructs_closed hs n (mem_references hm hv)
  exact ⟨t, ht, rfl, find?_of_distinct hdistinct (boundStructs_supported ht).1⟩

/-! ## The lowered spec -/

/-- Lowering lines up every zero-value default. -/
theorem lower_fieldsAligned (r : Resolved.Spec)
    (sections : List (String × String)) (stubs : List (String × List String)) :
    FieldsAligned (lower r sections stubs) :=
  fun _ hs _ hm _ _ hd => lower_fields hs hm hd

/--
In the lowered spec, with distinct C names, each `.zero` a bound struct's
member default prints names a bound struct whose `T.zero` is declared.
-/
theorem lower_zero_declared {r : Resolved.Spec}
    {sections : List (String × String)} {stubs : List (String × List String)}
    (hdistinct : (lower r sections stubs).structNamesDistinct)
    {s : Struct} {m : Member} {d : Default}
    {z : Names × List (Names × Default)}
    (hs : s ∈ boundStructs (lower r sections stubs).structs.toList)
    (hm : m ∈ s.members) (hd : m.default = some d) (hz : d.Within z) :
    Declared (lower r sections stubs) z.1 :=
  zero_declared hdistinct (lower_fieldsAligned r sections stubs) hs hm hd hz

/--
In the lowered spec, with distinct C names, each `.zero` a `T.zero` prints
names a bound struct whose `T.zero` is declared.
-/
theorem lower_zero_closed {r : Resolved.Spec}
    {sections : List (String × String)} {stubs : List (String × List String)}
    (hdistinct : (lower r sections stubs).structNamesDistinct)
    {z z' : Names × List (Names × Default)}
    (h : z ∈ zeroValues (boundStructs (lower r sections stubs).structs.toList))
    (h' : (Default.fields z.1 z.2).Within z') :
    Declared (lower r sections stubs) z'.1 :=
  zero_closed hdistinct (lower_fieldsAligned r sections stubs) h h'

/--
In the lowered spec, with distinct C names, each `T.zero` the printer declares
is its struct's, and lines up with its members.
-/
theorem lower_zero_aligned {r : Resolved.Spec}
    {sections : List (String × String)} {stubs : List (String × List String)}
    (hdistinct : (lower r sections stubs).structNamesDistinct)
    {s : Struct} {z : Names × List (Names × Default)}
    (hs : s ∈ boundStructs (lower r sections stubs).structs.toList)
    (h :
      (zeroValues (boundStructs (lower r sections stubs).structs.toList)).find?
        (·.1.c == s.names.c) = some z) :
    z.1 = s.names
      ∧ aligned (lower r sections stubs).shapeOf s.names z.2 = true
      ∧ (lower r sections stubs).shapeOf s.names
        = some (s.members.toList.map fun m => (m.names, m.value)) :=
  zero_aligned hdistinct (lower_fieldsAligned r sections stubs) hs h

end WebGPUGen.Emit.Lean
