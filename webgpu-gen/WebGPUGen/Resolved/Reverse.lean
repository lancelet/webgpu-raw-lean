import WebGPUGen.Resolved.Faithfulness

/-!
# The reverse direction

Every well-formed resolved spec comes from a parsed one: unresolve it, and
resolving gives it back. With soundness and faithfulness, this makes
resolvable parsed specs and well-formed resolved specs two views of the same
thing, and shows `WellFormed` asks exactly what `check` checks.

The first half, here: a well-formed spec, written back with names, passes
every check.

    theorem check_unresolve : WellFormed r → check (unresolve r) = []

Each lemma takes a part of `WellFormed` and shows the unresolved piece meets
what `CheckLemmas` says its check needs. The heart of it is that an ID in range
names an entry, so its name exists.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-! ## IDs name entries -/

/-- The name at a position in range is the name of an item. -/
theorem nameAt_mem {α} {name : α → Name} {xs : Array α} {i : Nat} (lt : i < xs.size) :
    ∃ x ∈ xs, name x = nameAt name xs i :=
  ⟨xs[i], Array.getElem_mem lt, by simp [nameAt, Array.getElem?_eq_getElem lt]⟩

/-- The same, in an array mapped by something that keeps names. -/
theorem nameAt_mem_map {α β} {name : β → Name} {g : α → β} {name' : α → Name}
    (hg : ∀ x, name (g x) = name' x) {xs : Array α} {i : Nat} (lt : i < xs.size) :
    ∃ y ∈ xs.map g, name y = nameAt name' xs i :=
  ⟨g xs[i], Array.mem_map_of_mem (Array.getElem_mem lt),
    by simp [nameAt, Array.getElem?_eq_getElem lt, hg]⟩

/-- When names are distinct, looking up the name at a position finds that
position. -/
theorem indexOf?_nameAt {α} {name : α → Name} {xs : Array α}
    (h : (xs.toList.map name).Nodup) {i : Nat} (lt : i < xs.size) :
    indexOf? name xs (nameAt name xs i) = some ⟨i, lt⟩ := by
  rw [show nameAt name xs i = name xs[i] by simp [nameAt, Array.getElem?_eq_getElem lt]]
  exact indexOf?_of_nodup h lt

/-- The same, in an array mapped by something that keeps names. -/
theorem indexOf?_nameAt_map {α β} {name : β → Name} {g : α → β} {name' : α → Name}
    (hg : ∀ x, name (g x) = name' x) {xs : Array α} (h : (xs.toList.map name').Nodup)
    {i : Nat} (lt : i < xs.size) :
    indexOf? name (xs.map g) (nameAt name' xs i) = some ⟨i, by simpa using lt⟩ := by
  have lt' : i < (xs.map g).size := by simpa using lt
  rw [show nameAt name' xs i = name (xs.map g)[i] by
    simp [nameAt, Array.getElem?_eq_getElem lt, hg]]
  exact indexOf?_of_nodup ((nodup_map_map hg).mpr h) lt'

/-- A named type in range names an entry of its kind. -/
theorem refOk_namedName {r : Spec} {t : Named} (h : t.InRange r) :
    RefOk (unresolve r) t.kind (namedName r t) := by
  cases t with
  | typedef _ => exact nameAt_mem h
  | enum    _ => exact nameAt_mem h
  | bitflag _ => exact nameAt_mem_map (g := unresolveBitflag) (fun _ => rfl) h
  | struct  _ => exact nameAt_mem_map (g := unresolveStruct r) (fun _ => rfl) h
  | object  _ => exact nameAt_mem_map (g := unresolveObject r) (fun _ => rfl) h

/-- A struct ID in range names a struct. -/
theorem structName_mem {r : Spec} {id : Id .struct} (h : id.InRange r) :
    ∃ x ∈ (unresolve r).structs, x.name = structName r id :=
  nameAt_mem_map (g := unresolveStruct r) (fun _ => rfl) h

/-- A callback ID in range names a callback. -/
theorem callbackName_mem {r : Spec} {id : Id .callback} (h : id.InRange r) :
    ∃ x ∈ (unresolve r).callbacks, x.name = callbackName r id :=
  nameAt_mem_map (g := unresolveCallback r) (fun _ => rfl) h

/-! ## Types and defaults -/

/-- A type whose IDs are in range unresolves to one whose names exist. -/
theorem typeRefOk_unresolve {r : Spec} {t : TypeRef} (h : t.InRange r) :
    TypeRefOk (unresolve r) (unresolveTypeRef r t) := by
  cases t with
  | primitive _ => trivial
  | named _     => exact refOk_namedName h
  | arrayOf _   => exact refOk_namedName h
  | callback _  => exact callbackName_mem h

/-- Unresolving keeps a type's shape, as the default rules see it. -/
theorem memberShape_unresolveTypeRef {r : Spec} {t : TypeRef} :
    memberShape (unresolveTypeRef r t) = memberShape' t := by
  cases t with
  | primitive p => cases p <;> rfl
  | named t     => cases t <;> rfl
  | arrayOf _   => rfl
  | callback _  => rfl

/-- An entry default whose entry has a name that reads as an entry name
unresolves to that name. -/
theorem unresolveDefault_entry {r : Spec} {ref : EntryRef} {n : Name}
    (h : ref.name? r = some n) (v : Parsed.defaultText n.text = .entry) :
    unresolveDefault r (.entry ref) = .entry n v := by
  simp [unresolveDefault, h, v]

/-- A well-formed default unresolves to one that suits its member's type. -/
theorem suits_unresolve {r : Spec} {t : TypeRef} {d : Default} (hd : d.WellFormed r t) :
    defaultKind (unresolveDefault r d) ≠ .entry →
      defaultSuits (memberShape (unresolveTypeRef r t)) (defaultKind (unresolveDefault r d)) =
        true := by
  rw [memberShape_unresolveTypeRef]
  cases d with
  | entry _ =>
    obtain ⟨-, n, hn, v⟩ := hd
    rw [unresolveDefault_entry hn v]
    exact fun h => absurd rfl h
  | constant _ => exact fun _ => hd.2
  | _          => exact fun _ => hd

/-- A well-formed default unresolves to one that names what exists. An entry
default needs the enum or bitflag names to be distinct: the parsed spec finds
an entry's owner by name, and must find the one the ID points at. -/
theorem defaultOk_unresolve {r : Spec} (hr : WellFormed r) {t : TypeRef} {d : Default}
    (hd : d.WellFormed r t) :
    DefaultOk (unresolve r) (unresolveTypeRef r t) (unresolveDefault r d) := by
  cases d with
  | constant _ => exact nameAt_mem hd.1
  | entry ref  =>
    obtain ⟨ht, n, hn, v⟩ := hd
    rw [unresolveDefault_entry hn v]
    subst ht
    cases ref with
    | enumEntry e i =>
      simp only [EntryRef.name?, Option.bind_eq_some_iff, Array.getElem?_eq_some_iff] at hn
      obtain ⟨slot, ⟨_, ⟨lt, rfl⟩, ⟨lt', rfl⟩⟩, hname⟩ := hn
      intro j hj
      -- Names are distinct, so the lookup finds the enum the ID points at.
      cases Option.some.inj (hj.symm.trans (indexOf?_nameAt hr.enumNames lt))
      exact ⟨_, Array.getElem_mem lt', hname⟩
    | flag b i =>
      simp only [EntryRef.name?, Option.map_eq_some_iff, Option.bind_eq_some_iff,
        Array.getElem?_eq_some_iff] at hn
      obtain ⟨flag, ⟨_, ⟨lt, rfl⟩, ⟨lt', rfl⟩⟩, rfl⟩ := hn
      intro j hj
      cases Option.some.inj (hj.symm.trans
        (indexOf?_nameAt_map (g := unresolveBitflag) (fun _ => rfl) hr.bitflagNames lt))
      refine ⟨unresolveFlag r.bitflags[b.idx] r.bitflags[b.idx].entries[i.idx], ?_, rfl⟩
      simpa [unresolve, unresolveBitflag] using
        Array.mem_map_of_mem (f := unresolveFlag r.bitflags[b.idx]) (Array.getElem_mem lt')
  | _ => trivial

/-! ## Parameters and return values -/

/-- A well-formed parameter unresolves to one that passes its check. -/
theorem checkParameter_unresolve {Doc} {r : Spec} (hr : WellFormed r) {role : Role}
    {path : Array String} {p : Parameter Doc} (hp : p.WellFormed r role) :
    checkParameter (unresolve r) role path (unresolveParameter r p) = [] := by
  rw [checkParameter_eq_nil]
  refine ⟨typeRefOk_unresolve hp.typeInRange, hp.ownership, ?_⟩
  intro d' hd'
  simp only [unresolveParameter, Option.map_eq_some_iff] at hd'
  obtain ⟨d, hd, rfl⟩ := hd'
  have some : p.default.isSome := by simp [hd]
  exact ⟨hp.defaultMember some, hp.defaultNotPtr some, suits_unresolve (hp.defaultOk d hd),
    defaultOk_unresolve hr (hp.defaultOk d hd)⟩

/-- A well-formed return value unresolves to one that passes its check. -/
theorem checkReturn_unresolve {r : Spec} {path : Array String} {ret : Return}
    (h : ret.WellFormed r) : checkReturn (unresolve r) path (unresolveReturn r ret) = [] :=
  checkReturn_eq_nil.mpr ⟨typeRefOk_unresolve h.typeInRange, h.ownership⟩

/-! ## Entries -/

/-- A well-formed flag unresolves to one that passes its check. -/
theorem checkFlag_unresolve {b : Bitflag} {path : Array String} {e : BitflagEntry}
    (h : e.value.WellFormed b) :
    checkFlag (unresolveBitflag b) path (unresolveFlag b e) = [] := by
  rw [checkFlag_eq_nil]
  rcases hv : e.value with _ | n | flags
  · simp [unresolveFlag, unresolveFlagValue, unresolveCombination, hv]
  · simp [unresolveFlag, unresolveFlagValue, unresolveCombination, hv]
  · rw [hv] at h
    simp only [unresolveFlag, unresolveFlagValue, unresolveCombination, hv]
    refine ⟨by simp, by simp, ?_⟩
    rintro _ ⟨⟩ n hn
    simp only [Array.toList_map, List.mem_map] at hn
    obtain ⟨i, hi, rfl⟩ := hn
    exact nameAt_mem_map (g := unresolveFlag b) (fun _ => rfl) (h i hi)

/-- A well-formed bitflag type unresolves to one that passes its check. -/
theorem checkBitflag_unresolve {b : Bitflag} {path : Array String} (h : b.WellFormed) :
    checkBitflag path (unresolveBitflag b) = [] :=
  checkBitflag_eq_nil.mpr ⟨(nodup_map_map fun _ => rfl).mpr h.distinct,
    forall_mem_map.mpr fun e he _ => checkFlag_unresolve (h.values e he)⟩

/-- A well-formed enum passes its check: unresolving leaves enums as they are. -/
theorem checkEnum_unresolve {r : Spec} {path : Array String} {e : Enum}
    (h : Enum.WellFormed r e) : checkEnum (unresolve r) path e = [] :=
  checkEnum_eq_nil.mpr ⟨h.distinct, h.namespaced⟩

/-- A well-formed struct unresolves to one that passes its check. -/
theorem checkStruct_unresolve {r : Spec} (hr : WellFormed r) {path : Array String}
    {st : Struct} (h : st.WellFormed r) :
    checkStruct (unresolve r) path (unresolveStruct r st) = [] :=
  checkStruct_eq_nil.mpr ⟨forall_mem_map.mpr fun _ hid => structName_mem (h.extends_ _ hid),
    (nodup_map_map fun _ => rfl).mpr h.distinct,
    forall_mem_map.mpr fun _ hp _ => checkParameter_unresolve hr (h.members _ hp)⟩

/-- A well-formed callback unresolves to one that passes its check. -/
theorem checkCallback_unresolve {r : Spec} (hr : WellFormed r) {path : Array String}
    {c : Callback} (h : c.WellFormed r) :
    checkCallback (unresolve r) path (unresolveCallback r c) = [] :=
  checkCallback_eq_nil.mpr ⟨(nodup_map_map fun _ => rfl).mpr h.distinct,
    forall_mem_map.mpr fun _ hp _ => checkParameter_unresolve hr (h.args _ hp)⟩

/-- A well-formed function unresolves to one that passes its check. -/
theorem checkFunction_unresolve {r : Spec} (hr : WellFormed r) {path : Array String}
    {f : Function} (h : f.WellFormed r) :
    checkFunction (unresolve r) path (unresolveFunction r f) = [] := by
  refine checkFunction_eq_nil.mpr ⟨?_, ?_, (nodup_map_map fun _ => rfl).mpr h.distinct,
    forall_mem_map.mpr fun _ hp _ => checkParameter_unresolve hr (h.args _ hp)⟩
  · intro _ hret _
    simp only [unresolveFunction, Option.map_eq_some_iff] at hret
    obtain ⟨ret, hret, rfl⟩ := hret
    exact checkReturn_unresolve (h.returns ret hret)
  · intro _ hc
    simp only [unresolveFunction, Option.map_eq_some_iff] at hc
    obtain ⟨id, hid, rfl⟩ := hc
    exact callbackName_mem (h.callback id hid)

/-- A well-formed object unresolves to one that passes its check. -/
theorem checkObject_unresolve {r : Spec} (hr : WellFormed r) {path : Array String}
    {o : Object} (h : o.WellFormed r) :
    checkObject (unresolve r) path (unresolveObject r o) = [] :=
  checkObject_eq_nil.mpr ⟨(nodup_map_map fun _ => rfl).mpr h.distinct,
    forall_mem_map.mpr fun _ hf _ => checkFunction_unresolve hr (h.methods _ hf)⟩

/-! ## The whole spec -/

/-- A well-formed spec, written back with names, passes every check. -/
theorem check_unresolve {r : Spec} (hr : WellFormed r) : check (unresolve r) = [] := by
  rw [check_eq_nil, checkConstants_eq_nil, checkTypedefs_eq_nil, checkEnums_eq_nil,
    checkBitflags_eq_nil, checkStructs_eq_nil, checkCallbacks_eq_nil, checkFunctions_eq_nil,
    checkObjects_eq_nil]
  exact ⟨
    hr.constantNames,
    hr.typedefNames,
    ⟨hr.enumNames, fun e he _ => checkEnum_unresolve (hr.enums e he)⟩,
    ⟨(nodup_map_map fun _ => rfl).mpr hr.bitflagNames,
      forall_mem_map.mpr fun b hb _ => checkBitflag_unresolve (hr.bitflags b hb)⟩,
    ⟨(nodup_map_map fun _ => rfl).mpr hr.structNames,
      forall_mem_map.mpr fun st hs _ => checkStruct_unresolve hr (hr.structs st hs)⟩,
    ⟨(nodup_map_map fun _ => rfl).mpr hr.callbackNames,
      forall_mem_map.mpr fun c hc _ => checkCallback_unresolve hr (hr.callbacks c hc)⟩,
    ⟨(nodup_map_map fun _ => rfl).mpr hr.functionNames,
      forall_mem_map.mpr fun f hf _ => checkFunction_unresolve hr (hr.functions f hf)⟩,
    ⟨(nodup_map_map fun _ => rfl).mpr hr.objectNames,
      forall_mem_map.mpr fun o ho _ => checkObject_unresolve hr (hr.objects o ho)⟩⟩

end WebGPUGen.Resolved
