import WebGPUGen.Resolved.Faithfulness

/-!
# The reverse direction

Every well-formed resolved spec comes from a parsed one: unresolve it, and
resolving gives it back. With soundness and faithfulness, this makes
resolvable parsed specs and well-formed resolved specs two views of the same
thing, and shows `WellFormed` asks exactly what `check` checks.

    theorem resolve_unresolve : WellFormed r → resolve (unresolve r) = .ok r
    theorem wellFormed_iff_resolves : WellFormed r ↔ ∃ s, resolve s = .ok r

It comes in two halves. First, a well-formed spec written back with names
passes every check (`check_unresolve`): an ID in range names an entry, so its
name exists. Second, building it again gives back the same IDs
(`build_unresolve`): names are distinct, so looking one up finds the ID it
came from.
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

/--
When names are distinct, looking up the name at a position finds that position.
-/
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

/--
An entry default whose entry has a name that reads as an entry name unresolves
to that name.
-/
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

/--
A well-formed default unresolves to one that names what exists. An entry default
needs the enum or bitflag names to be distinct: the parsed spec finds an entry's
owner by name, and must find the one the ID points at.
-/
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


/-! ## Resolving again finds the same IDs

The second half: building the unresolved spec gives back the spec we started
with. `build` looks each name up, and with distinct names the lookup finds the
ID the name came from. -/

/-- When names are distinct, `indexOf` finds the position a name came from. -/
theorem indexOf_nameAt {α} {name : α → Name} {xs : Array α}
    (h : (xs.toList.map name).Nodup) {i : Nat} (lt : i < xs.size) :
    indexOf name xs (nameAt name xs i) = i := by
  simp [indexOf, indexOf?_nameAt h lt]

/-- The same, in an array mapped by something that keeps names. -/
theorem indexOf_nameAt_map {α β} {name : β → Name} {g : α → β} {name' : α → Name}
    (hg : ∀ x, name (g x) = name' x) {xs : Array α} (h : (xs.toList.map name').Nodup)
    {i : Nat} (lt : i < xs.size) : indexOf name (xs.map g) (nameAt name' xs i) = i := by
  simp [indexOf, indexOf?_nameAt_map hg h lt]

/--
An enum's named slots have distinct names, so looking up a slot's name finds
that slot. Reserved slots have no name and never match.
-/
theorem indexOf?_slotName {entries : Array (Option EnumEntry)}
    (h : (entries.toList.filterMap (·.map (·.name))).Nodup) {i : Nat}
    (lt : i < entries.size) {n : Name} (hs : slotName entries[i] = some n) :
    indexOf? slotName entries (some n) = some ⟨i, lt⟩ := by
  have h' : ((entries.toList.map slotName).filterMap id).Nodup := by
    rw [List.filterMap_map]
    exact h
  unfold indexOf?
  rw [Array.findFinIdx?_eq_some_iff]
  refine ⟨by simp [hs], fun j hj heq => ?_⟩
  apply nodup_filterMap_id_iff.mp h' i (by simpa using lt) n (by simpa using hs)
  rw [List.mem_take_iff_getElem]
  exact ⟨j, by simp only [List.length_map, Array.length_toList, Nat.lt_min]; exact ⟨hj, j.isLt⟩,
    by simpa using heq⟩

/-! ### IDs -/

/-- A constant ID in range comes back from its name. -/
theorem constantId_constantName {r : Spec} (hr : WellFormed r) {id : Id .constant}
    (h : id.InRange r) : constantId (unresolve r) (constantName r id) = id :=
  congrArg Id.mk (indexOf_nameAt hr.constantNames h)

/-- A typedef ID in range comes back from its name. -/
theorem typedefId_typedefName {r : Spec} (hr : WellFormed r) {id : Id .typedef}
    (h : id.InRange r) : typedefId (unresolve r) (typedefName r id) = id :=
  congrArg Id.mk (indexOf_nameAt hr.typedefNames h)

/-- A enum ID in range comes back from its name. -/
theorem enumId_enumName {r : Spec} (hr : WellFormed r) {id : Id .enum}
    (h : id.InRange r) : enumId (unresolve r) (enumName r id) = id :=
  congrArg Id.mk (indexOf_nameAt hr.enumNames h)

/-- A bitflag ID in range comes back from its name. -/
theorem bitflagId_bitflagName {r : Spec} (hr : WellFormed r) {id : Id .bitflag}
    (h : id.InRange r) : bitflagId (unresolve r) (bitflagName r id) = id :=
  congrArg Id.mk (indexOf_nameAt_map (g := unresolveBitflag) (fun _ => rfl) hr.bitflagNames h)

/-- A struct ID in range comes back from its name. -/
theorem structId_structName {r : Spec} (hr : WellFormed r) {id : Id .struct}
    (h : id.InRange r) : structId (unresolve r) (structName r id) = id :=
  congrArg Id.mk (indexOf_nameAt_map (g := unresolveStruct r) (fun _ => rfl) hr.structNames h)

/-- A callback ID in range comes back from its name. -/
theorem callbackId_callbackName {r : Spec} (hr : WellFormed r) {id : Id .callback}
    (h : id.InRange r) : callbackId (unresolve r) (callbackName r id) = id :=
  congrArg Id.mk
    (indexOf_nameAt_map (g := unresolveCallback r) (fun _ => rfl) hr.callbackNames h)

/-- A object ID in range comes back from its name. -/
theorem objectId_objectName {r : Spec} (hr : WellFormed r) {id : Id .object}
    (h : id.InRange r) : objectId (unresolve r) (objectName r id) = id :=
  congrArg Id.mk (indexOf_nameAt_map (g := unresolveObject r) (fun _ => rfl) hr.objectNames h)

/-! ### Types and defaults -/

/-- A named type in range comes back. -/
theorem buildNamed_namedName {r : Spec} (hr : WellFormed r) {t : Named} (h : t.InRange r) :
    buildNamed (unresolve r) t.kind (namedName r t) = t := by
  cases t with
  | typedef _ => exact congrArg Named.typedef (typedefId_typedefName hr h)
  | enum    _ => exact congrArg Named.enum    (enumId_enumName       hr h)
  | bitflag _ => exact congrArg Named.bitflag (bitflagId_bitflagName hr h)
  | struct  _ => exact congrArg Named.struct  (structId_structName   hr h)
  | object  _ => exact congrArg Named.object  (objectId_objectName   hr h)

/-- A type whose IDs are in range comes back. -/
theorem buildTypeRef_unresolveTypeRef {r : Spec} (hr : WellFormed r) {t : TypeRef}
    (h : t.InRange r) : buildTypeRef (unresolve r) (unresolveTypeRef r t) = t := by
  cases t with
  | primitive _ => rfl
  | named _     => exact congrArg TypeRef.named    (buildNamed_namedName hr h)
  | arrayOf _   => exact congrArg TypeRef.arrayOf  (buildNamed_namedName hr h)
  | callback _  => exact congrArg TypeRef.callback (callbackId_callbackName hr h)

/--
A well-formed entry default's reference comes back: its enum or bitflag by name,
then its entry by name, both distinct.
-/
theorem buildEntryRef_unresolve {r : Spec} (hr : WellFormed r) {ref : EntryRef} {n : Name}
    (hn : ref.name? r = some n) :
    buildEntryRef (unresolve r) (unresolveTypeRef r (.named ref.owner)) n = ref := by
  cases ref with
  | enumEntry e i =>
    simp only [EntryRef.name?, Option.bind_eq_some_iff, Array.getElem?_eq_some_iff] at hn
    obtain ⟨slot, ⟨_, ⟨lt, rfl⟩, ⟨lt', rfl⟩⟩, hname⟩ := hn
    have he : indexOf? (·.name) (unresolve r).enums (enumName r e) = some ⟨e.idx, lt⟩ :=
      indexOf?_nameAt hr.enumNames lt
    have hi : indexOf slotName r.enums[e.idx].entries (some n) = i.idx := by
      have distinct := (hr.enums r.enums[e.idx] (by simp)).distinct
      simp [indexOf, indexOf?_slotName distinct lt' hname]
    simp only [EntryRef.owner, unresolveTypeRef, Named.kind, namedName, buildEntryRef, he]
    simp only [Fin.getElem_fin, unresolve, hi]
  | flag b i =>
    simp only [EntryRef.name?, Option.map_eq_some_iff, Option.bind_eq_some_iff,
      Array.getElem?_eq_some_iff] at hn
    obtain ⟨flag, ⟨_, ⟨lt, rfl⟩, ⟨lt', rfl⟩⟩, rfl⟩ := hn
    have hb : indexOf? (·.name) (unresolve r).bitflags (bitflagName r b) =
        some ⟨b.idx, by simpa [unresolve] using lt⟩ :=
      indexOf?_nameAt_map (g := unresolveBitflag) (fun _ => rfl) hr.bitflagNames lt
    have hi : indexOf (·.name) (unresolveBitflag r.bitflags[b.idx]).entries
        r.bitflags[b.idx].entries[i.idx].name = i.idx := by
      have distinct := (hr.bitflags r.bitflags[b.idx] (by simp)).distinct
      simpa [nameAt, Array.getElem?_eq_getElem lt', unresolveBitflag, unresolveFlag] using
        indexOf_nameAt_map (g := unresolveFlag r.bitflags[b.idx]) (fun _ => rfl) distinct lt'
    simp only [EntryRef.owner, unresolveTypeRef, Named.kind, namedName, buildEntryRef, hb]
    -- The resolved bitflag at `b`, read through `unresolve`'s map.
    simp only [Fin.getElem_fin, unresolve, Array.getElem_map]
    rw [hi]

/-- A well-formed default comes back. -/
theorem buildDefault_unresolveDefault {r : Spec} (hr : WellFormed r) {t : TypeRef}
    {d : Default} (hd : d.WellFormed r t) :
    buildDefault (unresolve r) (unresolveTypeRef r t) (unresolveDefault r d) = d := by
  cases d with
  | constant _ => exact congrArg Default.constant (constantId_constantName hr hd.1)
  | entry _    =>
    obtain ⟨ht, n, hn, v⟩ := hd
    rw [unresolveDefault_entry hn v]
    subst ht
    exact congrArg Default.entry (buildEntryRef_unresolve hr hn)
  | _          => rfl

/-! ### Parameters and entries -/

/-- A well-formed parameter comes back. -/
theorem buildParameter_unresolve {Doc} {r : Spec} (hr : WellFormed r) {role : Role}
    {p : Parameter Doc} (hp : p.WellFormed r role) :
    buildParameter (unresolve r) (unresolveParameter r p) = p := by
  have default := option_map_map_eq_self (f := unresolveDefault r)
    (g := buildDefault (unresolve r) (unresolveTypeRef r p.type)) fun d hd =>
      buildDefault_unresolveDefault hr (hp.defaultOk d hd)
  simp only [buildParameter, unresolveParameter, buildTypeRef_unresolveTypeRef hr hp.typeInRange,
    default]

/-- A well-formed return value comes back. -/
theorem buildReturn_unresolve {r : Spec} (hr : WellFormed r) {ret : Return}
    (h : ret.WellFormed r) : buildReturn (unresolve r) (unresolveReturn r ret) = ret := by
  simp only [buildReturn, unresolveReturn, buildTypeRef_unresolveTypeRef hr h.typeInRange]

/--
A well-formed flag comes back: a combination's names find the flags they came
from, since flag names are distinct.
-/
theorem buildFlag_unresolve {b : Bitflag} (hb : b.WellFormed) {e : BitflagEntry}
    (h : e.value.WellFormed b) : buildFlag (unresolveBitflag b) (unresolveFlag b e) = e := by
  obtain ⟨name, ns, doc, value⟩ := e
  simp only [buildFlag, unresolveFlag]
  congr 1
  cases value with
  | implicit   => rfl
  | explicit _ => rfl
  | combination flags =>
    simp only [buildFlagValue, unresolveFlagValue, unresolveCombination, unresolveBitflag]
    congr
    exact map_map_eq_self fun i hi => congrArg EntryIndex.mk
      (indexOf_nameAt_map (g := unresolveFlag b) (fun _ => rfl) hb.distinct (h i hi))

/-- A well-formed bitflag type comes back. -/
theorem buildBitflag_unresolve {b : Bitflag} (h : b.WellFormed) :
    buildBitflag (unresolveBitflag b) = b := by
  have entries : (unresolveBitflag b).entries.map (buildFlag (unresolveBitflag b)) = b.entries :=
    map_map_eq_self fun e he => buildFlag_unresolve h (h.values e he)
  unfold buildBitflag
  rw [entries]
  rfl

/-- A well-formed struct comes back. -/
theorem buildStruct_unresolve {r : Spec} (hr : WellFormed r) {st : Struct}
    (h : st.WellFormed r) : buildStruct (unresolve r) (unresolveStruct r st) = st := by
  have extended := map_map_eq_self (f := structName r) (g := structId (unresolve r))
    fun id hid => structId_structName hr (h.extends_ id hid)
  have members  := map_map_eq_self (f := unresolveParameter r)
    (g := buildParameter (unresolve r)) fun p hp => buildParameter_unresolve hr (h.members p hp)
  simp only [buildStruct, unresolveStruct, extended, members]

/-- A well-formed callback comes back. -/
theorem buildCallback_unresolve {r : Spec} (hr : WellFormed r) {c : Callback}
    (h : c.WellFormed r) : buildCallback (unresolve r) (unresolveCallback r c) = c := by
  have args := map_map_eq_self (f := unresolveParameter r)
    (g := buildParameter (unresolve r)) fun p hp => buildParameter_unresolve hr (h.args p hp)
  simp only [buildCallback, unresolveCallback, args]

/-- A well-formed function comes back. -/
theorem buildFunction_unresolve {r : Spec} (hr : WellFormed r) {f : Function}
    (h : f.WellFormed r) : buildFunction (unresolve r) (unresolveFunction r f) = f := by
  have returns := option_map_map_eq_self (f := unresolveReturn r)
    (g := buildReturn (unresolve r)) fun ret hret => buildReturn_unresolve hr (h.returns ret hret)
  have callback := option_map_map_eq_self (f := callbackName r)
    (g := callbackId (unresolve r)) fun id hid => callbackId_callbackName hr (h.callback id hid)
  have args := map_map_eq_self (f := unresolveParameter r)
    (g := buildParameter (unresolve r)) fun p hp => buildParameter_unresolve hr (h.args p hp)
  simp only [buildFunction, unresolveFunction, returns, callback, args]

/-- A well-formed object comes back. -/
theorem buildObject_unresolve {r : Spec} (hr : WellFormed r) {o : Object}
    (h : o.WellFormed r) : buildObject (unresolve r) (unresolveObject r o) = o := by
  have methods := map_map_eq_self (f := unresolveFunction r)
    (g := buildFunction (unresolve r)) fun f hf => buildFunction_unresolve hr (h.methods f hf)
  simp only [buildObject, unresolveObject, methods]

/-! ### The whole spec -/

/-- A well-formed spec, unresolved and built again, comes back. -/
theorem build_unresolve {r : Spec} (hr : WellFormed r) : build (unresolve r) = r := by
  have bitflags  : (unresolve r).bitflags.map buildBitflag = r.bitflags :=
    map_map_eq_self fun b hb => buildBitflag_unresolve (hr.bitflags b hb)
  have structs   : (unresolve r).structs.map (buildStruct (unresolve r)) = r.structs :=
    map_map_eq_self fun st hs => buildStruct_unresolve hr (hr.structs st hs)
  have callbacks : (unresolve r).callbacks.map (buildCallback (unresolve r)) = r.callbacks :=
    map_map_eq_self fun c hc => buildCallback_unresolve hr (hr.callbacks c hc)
  have functions : (unresolve r).functions.map (buildFunction (unresolve r)) = r.functions :=
    map_map_eq_self fun f hf => buildFunction_unresolve hr (hr.functions f hf)
  have objects   : (unresolve r).objects.map (buildObject (unresolve r)) = r.objects :=
    map_map_eq_self fun o ho => buildObject_unresolve hr (hr.objects o ho)
  unfold build
  rw [bitflags, structs, callbacks, functions, objects]
  -- The rest `unresolve` passes through unchanged.
  rfl

/-! ## The equivalence -/

/--
Every well-formed spec comes from a parsed one: unresolve it, and resolving
gives it back.
-/
theorem resolve_unresolve {r : Spec} (hr : WellFormed r) : resolve (unresolve r) = .ok r := by
  unfold resolve
  rw [check_unresolve hr, build_unresolve hr]

/-- The resolved specs are exactly the well-formed ones. -/
theorem wellFormed_iff_resolves {r : Spec} : WellFormed r ↔ ∃ s, resolve s = .ok r :=
  ⟨fun hr => ⟨unresolve r, resolve_unresolve hr⟩, fun ⟨_, h⟩ => resolve_wellFormed h⟩

end WebGPUGen.Resolved
