import WebGPUGen.Emit.C.Functions
import WebGPUGen.Emit.Lean

/-!
# Lean and C agree on what is bound

`boundFunctions` is the one definition of what is bound: the C side writes a
shim for each, and the Lean side its raw `@[extern]` declaration and the
function that calls it. Each side can still fail on its own, as each prints a
value only if it has a type for it. This shows that it never does: where C has
a shim, Lean has both declarations.

    theorem decls_of_functionShim :
      functionShim objects f = some shim →
        (rawDecl f).isSome ∧ (wrapperDecl f).isSome

So no shim is left without its Lean declarations, and no function calls an
`@[extern]` that is not declared. That the two types of each value agree by
Lean's ABI, and that each side has as many parameters (a struct crosses as
four, and the tables), is checked by compiling them together (the
repository's `scripts/check-abi.sh`), not proved. An object is found by its C
name on the C side, and named by its Lean name on the Lean side; lowering
gives both from the same spec entry.
-/

namespace WebGPUGen.Emit
open WebGPUGen.Lowered

/-! ## Values -/

/-- A value a shim takes has a type in the raw declaration. -/
theorem rawLeanType_of_abiCType {v : Value} (h : v.abiCType.isSome) :
    v.rawLeanType.isSome := by
  cases v <;> simp_all [Value.abiCType, Value.rawLeanType, Value.leanType,
    apply_ite Option.isSome]

/-- A value a shim takes has a Lean type. -/
theorem leanType_of_abiCType {v : Value} (h : v.abiCType.isSome) :
    v.leanType.isSome := by
  cases v <;> simp_all [Value.abiCType, Value.leanType, apply_ite Option.isSome]

/-- A result a shim boxes has a type in the raw declaration. -/
theorem rawLeanType_of_resultExpr {objects : List Lowered.Object} {v : Value}
    (h : (C.resultExpr objects v).isSome) : v.rawLeanType.isSome := by
  cases v <;> simp_all [C.resultExpr, Value.rawLeanType, Value.leanType,
    apply_ite Option.isSome]

/-- A result a shim boxes has a Lean type as a result. -/
theorem resultLeanType_of_resultExpr {objects : List Lowered.Object}
    {v : Value} (h : (C.resultExpr objects v).isSome) :
    v.resultLeanType.isSome := by
  cases v <;> simp_all [C.resultExpr, Value.resultLeanType, Value.leanType,
    apply_ite Option.isSome]

/-! ## Functions -/

/-- `mapM` in `Option` succeeds exactly when it does for each item. -/
theorem isSome_mapM {α β} {f : α → Option β} :
    ∀ {l : List α}, (l.mapM f).isSome ↔ ∀ x ∈ l, (f x).isSome
  | [] => by simp
  | x :: xs => by
    rw [List.mapM_cons, List.forall_mem_cons, ← isSome_mapM (l := xs)]
    cases f x <;> cases xs.mapM f <;> simp

/-- An argument a shim takes has parameters in the raw declaration. -/
theorem rawBinders_of_argCrossing {objects : List Lowered.Object}
    {x y : String} {v : Value} (h : (C.argCrossing objects x v).isSome) :
    (Lean.rawBinders y v).isSome := by
  cases v <;> simp_all [C.argCrossing, Lean.rawBinders, C.argExpr,
    Value.abiCType, Value.rawLeanType, Value.leanType, Option.isSome_bind,
    apply_ite Option.isSome]

/-- An argument a shim takes has a Lean type. -/
theorem leanType_of_argCrossing {objects : List Lowered.Object}
    {x : String} {v : Value} (h : (C.argCrossing objects x v).isSome) :
    v.leanType.isSome := by
  cases v <;> simp_all [C.argCrossing, C.argExpr, Value.abiCType,
    Value.leanType, Option.isSome_bind, apply_ite Option.isSome]

/--
What a shim for `f` needs of its values: a crossing for each argument, and a
boxing for its result.
-/
theorem values_of_functionShim {objects : List Lowered.Object}
    {structs : List Names} {f : Lowered.Function} {shim : C.Function}
    (h : C.functionShim objects structs f = some shim) :
    (∀ a ∈ f.args.toList, (C.argCrossing objects a.names.c a.value).isSome)
      ∧ ∀ v, f.result = some v → (C.resultExpr objects v).isSome := by
  simp [C.functionShim, Option.bind_eq_some_iff] at h
  -- One part for each guard and bind of `functionShim`, in order.
  obtain ⟨_, _, _, _, _, args, hargs, hresult⟩ := h
  constructor
  · intro a ha
    exact isSome_mapM.1 (by rw [hargs]; rfl) a ha
  · intro v hv
    rw [hv] at hresult
    cases he : C.resultExpr objects v
    · cases v.cType <;> simp [he] at hresult
    · rfl

/-- `any` holds of a value that exists, if it holds of every value. -/
theorem any_of_isSome {α} {o : Option α} {p : α → Bool} (ho : o.isSome)
    (hp : ∀ x, p x) : o.any p := by
  cases o <;> simp_all

/--
The raw declaration exists if each argument has parameters, and its result a
raw type.
-/
theorem rawDecl_isSome {f : Lowered.Function}
    (hargs : ∀ a ∈ f.args.toList, (Lean.rawBinders a.names.lean a.value).isSome)
    (hresult : ∀ v, f.result = some v → v.rawLeanType.isSome) :
    (Lean.rawDecl f).isSome := by
  simp [Lean.rawDecl, Option.isSome_bind]
  apply any_of_isSome
  · rw [isSome_mapM]
    exact hargs
  · intro x
    split
    · rfl
    · next v hv =>
      obtain ⟨t, ht⟩ := Option.isSome_iff_exists.1 (hresult v hv)
      simp [ht]

/-- The function exists if each value has a Lean type. -/
theorem wrapperDecl_isSome {f : Lowered.Function}
    (hargs : ∀ a ∈ f.args.toList, a.value.leanType.isSome)
    (hresult : ∀ v, f.result = some v → v.resultLeanType.isSome) :
    (Lean.wrapperDecl f).isSome := by
  simp [Lean.wrapperDecl, Option.isSome_bind]
  apply any_of_isSome
  · rw [isSome_mapM]
    intro a ha
    obtain ⟨t, ht⟩ := Option.isSome_iff_exists.1 (hargs a ha)
    simp [ht]
  · intro x
    split
    · rfl
    · next v hv =>
      obtain ⟨t, ht⟩ := Option.isSome_iff_exists.1 (hresult v hv)
      simp [ht]

/-- Where C has a shim for a function, Lean has both of its declarations. -/
theorem decls_of_functionShim {objects : List Lowered.Object}
    {structs : List Names} {f : Lowered.Function} {shim : C.Function}
    (h : C.functionShim objects structs f = some shim) :
    (Lean.rawDecl f).isSome ∧ (Lean.wrapperDecl f).isSome := by
  obtain ⟨hargs, hresult⟩ := values_of_functionShim h
  exact ⟨
    rawDecl_isSome (fun a ha => rawBinders_of_argCrossing (hargs a ha))
      (fun v hv => rawLeanType_of_resultExpr (hresult v hv)),
    wrapperDecl_isSome (fun a ha => leanType_of_argCrossing (hargs a ha))
      (fun v hv => resultLeanType_of_resultExpr (hresult v hv))⟩

end WebGPUGen.Emit
