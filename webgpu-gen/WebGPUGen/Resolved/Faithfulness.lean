import WebGPUGen.Resolved.Soundness
import WebGPUGen.Resolved.Unresolve

/-!
# Faithfulness

Resolving loses nothing: if `check` finds no problems in a parsed spec, then
unresolving the spec `build` makes gives back exactly the spec we started with.

    theorem unresolve_build : check s = [] → unresolve (build s) = s

`unresolve` mirrors `build` piece by piece, so the proof does too, one lemma
per piece. The heart of it is that a name that exists comes back from its ID:
`build` finds the first entry with that name, and `unresolve` reads its name.
Everything else is mapping arrays.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-! ## Names come back from IDs -/

/-- The position `indexOf` finds holds the name it was looking for. -/
theorem nameAt_indexOf {α} {name : α → Name} {xs : Array α} {n : Name}
    (h : ∃ x ∈ xs, name x = n) : nameAt name xs (indexOf name xs n) = n := by
  obtain ⟨lt, hn⟩ := indexOf_spec h
  simp [nameAt, Array.getElem?_eq_getElem lt, hn]

/-- The same, in an array mapped by something that keeps names. -/
theorem nameAt_map_indexOf {α β} {name : β → Name} {g : α → β} {name' : α → Name}
    (hg : ∀ x, name (g x) = name' x) {xs : Array α} {n : Name}
    (h : ∃ x ∈ xs, name' x = n) : nameAt name (xs.map g) (indexOf name' xs n) = n := by
  obtain ⟨lt, hn⟩ := indexOf_spec h
  simp [nameAt, Array.getElem?_map, Array.getElem?_eq_getElem lt, hg, hn]

/-- A name that names an entry comes back from its ID, with its kind. -/
theorem namedName_buildNamed {s : Parsed.Spec} {kind : RefKind} {n : Name}
    (h : RefOk s kind n) :
    (buildNamed s kind n).kind = kind ∧ namedName (build s) (buildNamed s kind n) = n := by
  cases kind with
  | functionType => exact h.elim
  | typedef      => exact ⟨rfl, nameAt_indexOf h⟩
  | enum         => exact ⟨rfl, nameAt_indexOf h⟩
  | bitflag      => exact ⟨rfl, nameAt_map_indexOf (fun _ => rfl) h⟩
  | struct       => exact ⟨rfl, nameAt_map_indexOf (fun _ => rfl) h⟩
  | object       => exact ⟨rfl, nameAt_map_indexOf (fun _ => rfl) h⟩

/-- A constant name that exists comes back from its ID. -/
theorem constantName_constantId {s : Parsed.Spec} {n : Name}
    (h : ∃ c ∈ s.constants, c.name = n) : constantName (build s) (constantId s n) = n :=
  nameAt_indexOf h

/-- A callback name that exists comes back from its ID. -/
theorem callbackName_callbackId {s : Parsed.Spec} {n : Name}
    (h : ∃ c ∈ s.callbacks, c.name = n) : callbackName (build s) (callbackId s n) = n :=
  nameAt_map_indexOf (fun _ => rfl) h

/-- Building with a function and unresolving with one that undoes it, on
every item, gives the array back. -/
theorem map_map_eq_self {α β} {f : α → β} {g : β → α} {xs : Array α}
    (h : ∀ x ∈ xs.toList, g (f x) = x) : (xs.map f).map g = xs := by
  rw [Array.map_map]
  conv => rhs; rw [← Array.map_id xs]
  exact Array.map_congr_left fun x hx => h x (by simpa using hx)

/-- The same for an optional value. -/
theorem option_map_map_eq_self {α β} {f : α → β} {g : β → α} {x : Option α}
    (h : ∀ a, x = some a → g (f a) = a) : (x.map f).map g = x := by
  cases x with
  | none   => rfl
  | some a => simp [h a rfl]

/-! ## Types and defaults -/

/-- A type whose names all name entries comes back. -/
theorem unresolveTypeRef_buildTypeRef {s : Parsed.Spec} {t : Parsed.TypeRef}
    (h : TypeRefOk s t) : unresolveTypeRef (build s) (buildTypeRef s t) = t := by
  cases t with
  | primitive _ => rfl
  | ref _ _ =>
    obtain ⟨hkind, hname⟩ := namedName_buildNamed h
    simp [buildTypeRef, unresolveTypeRef, hkind, hname]
  | refArray _ _ =>
    obtain ⟨hkind, hname⟩ := namedName_buildNamed h
    simp [buildTypeRef, unresolveTypeRef, hkind, hname]
  | callback _   => simp [buildTypeRef, unresolveTypeRef, callbackName_callbackId h]

/-- A default that names what exists comes back. -/
theorem unresolveDefault_buildDefault {s : Parsed.Spec} {t : Parsed.TypeRef}
    {d : Parsed.Default} (ht : TypeRefOk s t) (hd : DefaultOk s t d) :
    unresolveDefault (build s) (buildDefault s t d) = d := by
  cases d with
  | constant _ => simp [buildDefault, unresolveDefault, constantName_constantId hd]
  | entry _ v  => simp [buildDefault, unresolveDefault, buildEntryRef_name? ht hd, v]
  | _          => rfl

/-- A parameter that passes its check comes back. -/
theorem unresolveParameter_buildParameter {Doc} {s : Parsed.Spec} {role : Role}
    {path : Array String} {p : Parsed.Parameter Doc} (h : checkParameter s role path p = []) :
    unresolveParameter (build s) (buildParameter s p) = p := by
  obtain ⟨ht, -, hdefault⟩ := checkParameter_eq_nil.mp h
  have default := option_map_map_eq_self (f := buildDefault s p.type)
    (g := unresolveDefault (build s)) fun d hd =>
      unresolveDefault_buildDefault ht (hdefault d hd).2.2.2
  simp only [unresolveParameter, buildParameter, unresolveTypeRef_buildTypeRef ht, default]

/-- A return value that passes its check comes back. -/
theorem unresolveReturn_buildReturn {s : Parsed.Spec} {path : Array String} {r : Parsed.Return}
    (h : checkReturn s path r = []) : unresolveReturn (build s) (buildReturn s r) = r := by
  simp [unresolveReturn, buildReturn, unresolveTypeRef_buildTypeRef (checkReturn_eq_nil.mp h).1]

/-! ## Entries -/

/-- A flag that passes its check comes back: an explicit value as itself, and a
combination as the names of the flags it combines. -/
theorem unresolveFlag_buildFlag {path : Array String} {b : Parsed.Bitflag}
    {e : Parsed.BitflagEntry} (h : checkFlag b path e = []) :
    unresolveFlag (buildBitflag b) (buildFlag b e) = e := by
  obtain ⟨one, isInt, combination⟩ := checkFlag_eq_nil.mp h
  obtain ⟨name, ns, doc, value, names⟩ := e
  simp only at one isInt combination
  simp only [unresolveFlag, buildFlag, buildFlagValue]
  rcases value with _ | v <;> rcases names with _ | names
  · rfl
  · simp only [unresolveFlagValue, unresolveCombination, buildBitflag]
    congr
    exact map_map_eq_self fun n hn =>
      nameAt_map_indexOf (g := buildFlag b) (fun _ => rfl) (combination names rfl n hn)
  · obtain ⟨n, rfl⟩ := isInt v rfl
    rfl
  · simp at one

/-- A bitflag type that passes its check comes back. -/
theorem unresolveBitflag_buildBitflag {path : Array String} {b : Parsed.Bitflag}
    (h : checkBitflag path b = []) : unresolveBitflag (buildBitflag b) = b := by
  obtain ⟨-, flags⟩ := checkBitflag_eq_nil.mp h
  have entries := map_map_eq_self fun e he => unresolveFlag_buildFlag (flags e he #[])
  simp only [unresolveBitflag]
  simp only [buildBitflag] at entries ⊢
  rw [entries]

/-- A struct that passes its check comes back. -/
theorem unresolveStruct_buildStruct {s : Parsed.Spec} {path : Array String}
    {st : Parsed.Struct} (h : checkStruct s path st = []) :
    unresolveStruct (build s) (buildStruct s st) = st := by
  obtain ⟨extends_, -, members⟩ := checkStruct_eq_nil.mp h
  have extended := map_map_eq_self (f := structId s) (g := structName (build s)) fun n hn =>
    nameAt_map_indexOf (g := buildStruct s) (fun _ => rfl) (extends_ n hn)
  have members := map_map_eq_self fun p hp =>
    unresolveParameter_buildParameter (members p hp #[])
  simp only [unresolveStruct, buildStruct, extended, members]

/-- A callback that passes its check comes back. -/
theorem unresolveCallback_buildCallback {s : Parsed.Spec} {path : Array String}
    {c : Parsed.Callback} (h : checkCallback s path c = []) :
    unresolveCallback (build s) (buildCallback s c) = c := by
  obtain ⟨-, args⟩ := checkCallback_eq_nil.mp h
  have args := map_map_eq_self fun p hp => unresolveParameter_buildParameter (args p hp #[])
  simp only [unresolveCallback, buildCallback, args]

/-- A function that passes its check comes back. -/
theorem unresolveFunction_buildFunction {s : Parsed.Spec} {path : Array String}
    {f : Parsed.Function} (h : checkFunction s path f = []) :
    unresolveFunction (build s) (buildFunction s f) = f := by
  obtain ⟨returns, callback, -, args⟩ := checkFunction_eq_nil.mp h
  have returns  := option_map_map_eq_self (f := buildReturn s) (g := unresolveReturn (build s))
    fun r hr => unresolveReturn_buildReturn (returns r hr #[])
  have callback := option_map_map_eq_self (f := callbackId s) (g := callbackName (build s))
    fun n hn => callbackName_callbackId (callback n hn)
  have args     := map_map_eq_self fun p hp =>
    unresolveParameter_buildParameter (args p hp #[])
  simp only [unresolveFunction, buildFunction, returns, callback, args]

/-- An object that passes its check comes back. -/
theorem unresolveObject_buildObject {s : Parsed.Spec} {path : Array String}
    {o : Parsed.Object} (h : checkObject s path o = []) :
    unresolveObject (build s) (buildObject s o) = o := by
  obtain ⟨-, methods⟩ := checkObject_eq_nil.mp h
  have methods := map_map_eq_self fun f hf =>
    unresolveFunction_buildFunction (methods f hf #[])
  simp only [unresolveObject, buildObject, methods]

/-! ## The whole spec -/

/-- If `check` finds no problems, unresolving what `build` makes gives back the
spec. -/
theorem unresolve_build {s : Parsed.Spec} (h : check s = []) : unresolve (build s) = s := by
  rw [check_eq_nil, checkConstants_eq_nil, checkTypedefs_eq_nil, checkEnums_eq_nil,
    checkBitflags_eq_nil, checkStructs_eq_nil, checkCallbacks_eq_nil, checkFunctions_eq_nil,
    checkObjects_eq_nil] at h
  obtain ⟨-, -, -, hb, hs, hc, hf, ho⟩ := h
  have bitflags  : (build s).bitflags.map unresolveBitflag = s.bitflags :=
    map_map_eq_self fun b hb' =>
      unresolveBitflag_buildBitflag (hb.2 b hb' #[])
  have structs   : (build s).structs.map (unresolveStruct (build s)) = s.structs :=
    map_map_eq_self fun st hs' =>
      unresolveStruct_buildStruct (hs.2 st hs' #[])
  have callbacks : (build s).callbacks.map (unresolveCallback (build s)) = s.callbacks :=
    map_map_eq_self fun c hc' =>
      unresolveCallback_buildCallback (hc.2 c hc' #[])
  have functions : (build s).functions.map (unresolveFunction (build s)) = s.functions :=
    map_map_eq_self fun f hf' =>
      unresolveFunction_buildFunction (hf.2 f hf' #[])
  have objects   : (build s).objects.map (unresolveObject (build s)) = s.objects :=
    map_map_eq_self fun o ho' =>
      unresolveObject_buildObject (ho.2 o ho' #[])
  unfold unresolve
  rw [bitflags, structs, callbacks, functions, objects]
  -- The rest `build` passes through unchanged.
  rfl

/-- Unresolving whatever `resolve` returns gives back the spec it was given. -/
theorem unresolve_of_resolve {s : Parsed.Spec} {r : Spec} (h : resolve s = .ok r) :
    unresolve r = s := by
  unfold resolve at h
  split at h
  · rename_i hc
    cases h
    exact unresolve_build hc
  · contradiction

end WebGPUGen.Resolved
