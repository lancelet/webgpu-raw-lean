import WebGPUGen.Resolved.CheckLemmas
import WebGPUGen.Resolved.WellFormed

/-!
# Soundness

If `check` finds no problems in a parsed spec, `build` makes a well-formed
resolved spec:

    theorem build_wellFormed : check s = [] → WellFormed (build s)

The proof goes from the inside out, one lemma per part of `WellFormed`: IDs,
then types and defaults, parameters, entries, and the whole spec. Each lemma
takes what `CheckLemmas` says a passing check guarantees, and shows the built
part has the matching property.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-! ## Mapping arrays

`build` maps each array, so statements about the built arrays come back to
statements about the parsed ones. -/

/--
Every item of a mapped array has a property exactly when every item of the array
does once mapped.
-/
theorem forall_mem_map {α β} {xs : Array α} {g : α → β} {P : β → Prop} :
    (∀ y ∈ (xs.map g).toList, P y) ↔ ∀ x ∈ xs.toList, P (g x) := by
  simp

/--
Building keeps names, so built names are distinct when the parsed ones are.
-/
theorem nodup_map_map {α β} {xs : Array α} {g : α → β} {name : β → Name}
    {name' : α → Name} (h : ∀ x, name (g x) = name' x) :
    ((xs.map g).toList.map name).Nodup ↔ (xs.toList.map name').Nodup := by
  simp [Function.comp_def, h]

/-! ## IDs -/

/-- A name that names an entry builds an ID in range. -/
theorem buildNamed_inRange {s : Parsed.Spec} {kind : RefKind} {n : Name}
    (h : RefOk s kind n) : (buildNamed s kind n).InRange (build s) := by
  cases kind with
  | functionType => exact h.elim
  | _            =>
    simpa [buildNamed, Named.InRange, Id.InRange, Spec.count, build,
      typedefId, enumId, bitflagId, structId, objectId] using indexOf_lt h

/-- The name of an existing constant builds an ID in range. -/
theorem constantId_inRange {s : Parsed.Spec} {n : Name}
    (h : ∃ c ∈ s.constants, c.name = n) : (constantId s n).InRange (build s) :=
  indexOf_lt h

/-- The name of an existing struct builds an ID in range. -/
theorem structId_inRange {s : Parsed.Spec} {n : Name}
    (h : ∃ st ∈ s.structs, st.name = n) : (structId s n).InRange (build s) := by
  simpa [Id.InRange, Spec.count, build, structId] using indexOf_lt h

/-- The name of an existing callback builds an ID in range. -/
theorem callbackId_inRange {s : Parsed.Spec} {n : Name}
    (h : ∃ c ∈ s.callbacks, c.name = n) : (callbackId s n).InRange (build s) := by
  simpa [Id.InRange, Spec.count, build, callbackId] using indexOf_lt h

/-! ## Types and defaults -/

/--
A type whose names all name entries builds a type whose IDs are in range.
-/
theorem buildTypeRef_inRange {s : Parsed.Spec} {t : Parsed.TypeRef}
    (h : TypeRefOk s t) : (buildTypeRef s t).InRange (build s) := by
  cases t with
  | primitive _ => trivial
  | ref _ _      => exact buildNamed_inRange h
  | refArray _ _ => exact buildNamed_inRange h
  | callback _   => exact callbackId_inRange h

/-- Building keeps a type's shape, as the default rules see it. -/
theorem memberShape'_buildTypeRef {s : Parsed.Spec} {t : Parsed.TypeRef} :
    memberShape' (buildTypeRef s t) = memberShape t := by
  rcases t with ⟨_ | _⟩ | ⟨kind, _⟩ | ⟨_, _⟩ | _ <;> try rfl
  cases kind <;> rfl

/-- Building keeps a default's kind. -/
theorem defaultKind'_buildDefault {s : Parsed.Spec} {t : Parsed.TypeRef} {d : Parsed.Default} :
    defaultKind' (buildDefault s t d) = defaultKind d := by
  cases d <;> rfl

/--
An entry default's member type is the enum or bitflag its built reference points
into.
-/
theorem buildTypeRef_eq_owner {s : Parsed.Spec} {t : Parsed.TypeRef} {n : Name}
    {v : Parsed.defaultText n.text = .entry}
    (ht : TypeRefOk s t) (hd : DefaultOk s t (.entry n v)) :
    buildTypeRef s t = .named (buildEntryRef s t n).owner := by
  -- Any other member type has no entry defaults: `DefaultOk` is `False`.
  rcases t with _ | ⟨kind, name⟩ | _ | _ <;> try exact hd.elim
  cases kind with
  | enum =>
    obtain ⟨i, hi⟩ := Option.isSome_iff_exists.mp (indexOf?_isSome.mpr ht)
    simp [buildEntryRef, buildTypeRef, buildNamed, EntryRef.owner, hi, enumId, indexOf]
  | bitflag =>
    obtain ⟨i, hi⟩ := Option.isSome_iff_exists.mp (indexOf?_isSome.mpr ht)
    simp [buildEntryRef, buildTypeRef, buildNamed, EntryRef.owner, hi, bitflagId, indexOf]
  | _ => exact hd.elim

/--
An entry default that names an existing entry builds a reference to an entry
with that name.
-/
theorem buildEntryRef_name? {s : Parsed.Spec} {t : Parsed.TypeRef} {n : Name}
    {v : Parsed.defaultText n.text = .entry}
    (ht : TypeRefOk s t) (hd : DefaultOk s t (.entry n v)) :
    (buildEntryRef s t n).name? (build s) = some n := by
  rcases t with _ | ⟨kind, name⟩ | _ | _ <;> try exact hd.elim
  cases kind with
  | enum =>
    obtain ⟨i, hi⟩ := Option.isSome_iff_exists.mp (indexOf?_isSome.mpr ht)
    obtain ⟨lt, hj⟩ := indexOf_spec (hd i hi)
    simp only [slotName, Option.map_eq_some_iff] at hj
    obtain ⟨entry, hentry, rfl⟩ := hj
    simp only [buildEntryRef, hi, EntryRef.name?, build]
    -- `DefaultOk` indexes the enums by `i`, the goal by `i.val`.
    simp only [Fin.getElem_fin] at lt hentry
    simp [Array.getElem?_eq_getElem lt, hentry]
  | bitflag =>
    obtain ⟨i, hi⟩ := Option.isSome_iff_exists.mp (indexOf?_isSome.mpr ht)
    obtain ⟨lt, hj⟩ := indexOf_spec (hd i hi)
    simp only [buildEntryRef, hi, EntryRef.name?, build]
    simp [buildBitflag, buildFlag]
    exact ⟨_, Array.getElem?_eq_getElem lt, hj⟩
  | _ => exact hd.elim

/--
A default that names what exists, and suits its member's type, builds a
well-formed default.
-/
theorem buildDefault_wellFormed {s : Parsed.Spec} {t : Parsed.TypeRef} {d : Parsed.Default}
    (ht : TypeRefOk s t) (hd : DefaultOk s t d)
    (hs : defaultKind d ≠ .entry → defaultSuits (memberShape t) (defaultKind d) = true) :
    (buildDefault s t d).WellFormed (build s) (buildTypeRef s t) := by
  have suits := memberShape'_buildTypeRef (s := s) (t := t) ▸ hs
  cases d with
  | bool _       => exact suits (by simp [defaultKind])
  | int _        => exact suits (by simp [defaultKind])
  | float _ _    => exact suits (by simp [defaultKind])
  | zero         => exact suits (by simp [defaultKind])
  | constant _   => exact ⟨constantId_inRange hd, suits (by simp [defaultKind])⟩
  | entry n v    => exact ⟨buildTypeRef_eq_owner ht hd, n, buildEntryRef_name? ht hd, v⟩

/-! ## Parameters and return values -/

/-- A parameter that passes its check builds a well-formed parameter. -/
theorem buildParameter_wellFormed {Doc} {s : Parsed.Spec} {role : Role} {path : Array String}
    {p : Parsed.Parameter Doc} (h : checkParameter s role path p = []) :
    (buildParameter s p).WellFormed (build s) role := by
  obtain ⟨ht, hown, hdefault⟩ := checkParameter_eq_nil.mp h
  have some_default : (buildParameter s p).default.isSome → ∃ d, p.default = some d := by
    simp [buildParameter, Option.isSome_iff_exists]
  refine ⟨buildTypeRef_inRange ht, hown, ?_, ?_, ?_⟩
  · intro hsome
    obtain ⟨d, hd⟩ := some_default hsome
    exact (hdefault d hd).1
  · intro hsome
    obtain ⟨d, hd⟩ := some_default hsome
    exact (hdefault d hd).2.1
  · intro d' hd'
    simp only [buildParameter, Option.map_eq_some_iff] at hd'
    obtain ⟨d, hd, rfl⟩ := hd'
    obtain ⟨-, -, hs, hok⟩ := hdefault d hd
    exact buildDefault_wellFormed ht hok hs

/-- A return value that passes its check builds a well-formed one. -/
theorem buildReturn_wellFormed {s : Parsed.Spec} {path : Array String} {r : Parsed.Return}
    (h : checkReturn s path r = []) : (buildReturn s r).WellFormed (build s) := by
  obtain ⟨ht, hown⟩ := checkReturn_eq_nil.mp h
  exact ⟨buildTypeRef_inRange ht, hown⟩

/-! ## Entries -/

/--
Building leaves enums as they are, and `checkEnum` checks exactly what
`Enum.WellFormed` requires.
-/
theorem enum_wellFormed {s : Parsed.Spec} {path : Array String} {e : Enum}
    (h : checkEnum s path e = []) : Enum.WellFormed (build s) e := by
  obtain ⟨distinct, namespaced⟩ := checkEnum_eq_nil.mp h
  exact ⟨distinct, namespaced⟩

/-- A bitflag type that passes its check builds a well-formed one. -/
theorem buildBitflag_wellFormed {path : Array String} {b : Parsed.Bitflag}
    (h : checkBitflag path b = []) : (buildBitflag b).WellFormed := by
  obtain ⟨distinct, flags⟩ := checkBitflag_eq_nil.mp h
  refine ⟨(nodup_map_map fun _ => rfl).mpr distinct, ?_⟩
  simp only [buildBitflag, forall_mem_map]
  intro e he
  obtain ⟨-, -, combination⟩ := checkFlag_eq_nil.mp (flags e he #[])
  simp only [buildFlag, buildFlagValue]
  -- Only a combination has anything to check: that its flags exist.
  split <;> try trivial
  rename_i names _ hc
  simp only [FlagValue.WellFormed, forall_mem_map]
  intro n hn
  simpa using indexOf_lt (combination names hc n hn)

/-- A struct that passes its check builds a well-formed struct. -/
theorem buildStruct_wellFormed {s : Parsed.Spec} {path : Array String} {st : Parsed.Struct}
    (h : checkStruct s path st = []) : (buildStruct s st).WellFormed (build s) := by
  obtain ⟨extends_, distinct, members⟩ := checkStruct_eq_nil.mp h
  refine ⟨?_, (nodup_map_map fun _ => rfl).mpr distinct, ?_⟩
  · simp only [buildStruct, forall_mem_map]
    exact fun n hn => structId_inRange (extends_ n hn)
  · simp only [buildStruct, forall_mem_map]
    exact fun p hp => buildParameter_wellFormed (members p hp #[])

/-- A callback that passes its check builds a well-formed callback. -/
theorem buildCallback_wellFormed {s : Parsed.Spec} {path : Array String} {c : Parsed.Callback}
    (h : checkCallback s path c = []) : (buildCallback s c).WellFormed (build s) := by
  obtain ⟨distinct, args⟩ := checkCallback_eq_nil.mp h
  refine ⟨(nodup_map_map fun _ => rfl).mpr distinct, ?_⟩
  simp only [buildCallback, forall_mem_map]
  exact fun p hp => buildParameter_wellFormed (args p hp #[])

/-- A function that passes its check builds a well-formed function. -/
theorem buildFunction_wellFormed {s : Parsed.Spec} {path : Array String} {f : Parsed.Function}
    (h : checkFunction s path f = []) : (buildFunction s f).WellFormed (build s) := by
  obtain ⟨returns, callback, distinct, args⟩ := checkFunction_eq_nil.mp h
  refine ⟨?_, ?_, (nodup_map_map fun _ => rfl).mpr distinct, ?_⟩
  · simp only [buildFunction, Option.map_eq_some_iff]
    rintro _ ⟨r, hr, rfl⟩
    exact buildReturn_wellFormed (returns r hr #[])
  · simp only [buildFunction, Option.map_eq_some_iff]
    rintro _ ⟨n, hn, rfl⟩
    exact callbackId_inRange (callback n hn)
  · simp only [buildFunction, forall_mem_map]
    exact fun p hp => buildParameter_wellFormed (args p hp #[])

/-- An object that passes its check builds a well-formed object. -/
theorem buildObject_wellFormed {s : Parsed.Spec} {path : Array String} {o : Parsed.Object}
    (h : checkObject s path o = []) : (buildObject s o).WellFormed (build s) := by
  obtain ⟨distinct, methods⟩ := checkObject_eq_nil.mp h
  refine ⟨(nodup_map_map fun _ => rfl).mpr distinct, ?_⟩
  simp only [buildObject, forall_mem_map]
  exact fun f hf => buildFunction_wellFormed (methods f hf #[])

/-! ## The whole spec -/

/-- If `check` finds no problems, `build` makes a well-formed spec. -/
theorem build_wellFormed {s : Parsed.Spec} (h : check s = []) : WellFormed (build s) := by
  rw [check_eq_nil, checkConstants_eq_nil, checkTypedefs_eq_nil, checkEnums_eq_nil,
    checkBitflags_eq_nil, checkStructs_eq_nil, checkCallbacks_eq_nil, checkFunctions_eq_nil,
    checkObjects_eq_nil] at h
  obtain ⟨hc, ht, he, hb, hs, hcb, hf, ho⟩ := h
  simp only [build]
  exact {
    constantNames := hc
    typedefNames  := ht
    enumNames     := he.1
    enums         := fun e he' => enum_wellFormed (he.2 e he' #[])
    bitflagNames  := (nodup_map_map fun _ => rfl).mpr hb.1
    bitflags      := forall_mem_map.mpr fun b hb' => buildBitflag_wellFormed (hb.2 b hb' #[])
    structNames   := (nodup_map_map fun _ => rfl).mpr hs.1
    structs       := forall_mem_map.mpr fun st hs' => buildStruct_wellFormed (hs.2 st hs' #[])
    callbackNames := (nodup_map_map fun _ => rfl).mpr hcb.1
    callbacks     := forall_mem_map.mpr fun c hc' => buildCallback_wellFormed (hcb.2 c hc' #[])
    functionNames := (nodup_map_map fun _ => rfl).mpr hf.1
    functions     := forall_mem_map.mpr fun f hf' => buildFunction_wellFormed (hf.2 f hf' #[])
    objectNames   := (nodup_map_map fun _ => rfl).mpr ho.1
    objects       := forall_mem_map.mpr fun o ho' => buildObject_wellFormed (ho.2 o ho' #[])
  }

/-- Whatever `resolve` returns is well formed. -/
theorem resolve_wellFormed {s : Parsed.Spec} {r : Spec} (h : resolve s = .ok r) :
    WellFormed r := by
  unfold resolve at h
  split at h
  · rename_i hc
    cases h
    exact build_wellFormed hc
  · contradiction

end WebGPUGen.Resolved
