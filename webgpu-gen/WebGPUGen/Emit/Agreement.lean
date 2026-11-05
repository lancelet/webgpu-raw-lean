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
      functionShim objects structs f = some shim →
        (rawDecl f).isSome ∧ (wrapperDecl f).isSome
          ∧ ∀ c, f.callback = some c → (callbackDecl c).isSome

So no shim is left without its Lean declarations, no function calls an
`@[extern]` that is not declared, and no callback's type is missing. That
the two types of each value agree by Lean's ABI, and that each side has as
many parameters (a struct crosses as four, and the tables), is checked by
compiling them together (the repository's `scripts/check-abi.sh`), not
proved. An object is found by its C name on the C side, and named by its Lean
name on the Lean side; lowering gives both from the same spec entry.
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
What a shim for `f` needs of its values: a crossing for each argument, a
boxing for its result, and a trampoline for its callback.
-/
theorem values_of_functionShim {objects : List Lowered.Object}
    {structs : List Names} {f : Lowered.Function} {shim : C.Function}
    (h : C.functionShim objects structs f = some shim) :
    (∀ a ∈ f.args.toList, (C.argCrossing objects a.names.c a.value).isSome)
      ∧ (∀ v, f.result = some v → (C.resultExpr objects v).isSome)
      ∧ ∀ c, f.callback = some c → (C.trampoline objects c).isSome := by
  simp [C.functionShim, Option.bind_eq_some_iff] at h
  -- One part for each guard and bind of `functionShim`, in order.
  obtain ⟨_, _, _, ⟨_, htrampoline⟩, _, _, _, _, args, hargs, hresult⟩ := h
  refine ⟨?_, ?_, ?_⟩
  · intro a ha
    exact isSome_mapM.1 (by rw [hargs]; rfl) a ha
  · intro v hv
    rw [hv] at hresult
    cases he : C.resultExpr objects v
    · cases v.cType <;> simp [he] at hresult
    · rfl
  · intro c hc
    rw [hc] at htrampoline
    cases ht : C.trampoline objects c <;> simp [ht] at htrampoline ⊢

/-- `any` holds of a value that exists, if it holds of every value. -/
theorem any_of_isSome {α} {o : Option α} {p : α → Bool} (ho : o.isSome)
    (hp : ∀ x, p x) : o.any p := by
  cases o <;> simp_all

/-! ## Callbacks -/

/-- A callback's argument a trampoline boxes has a type in the raw closure. -/
theorem callbackRawType_of_callbackArgExpr {objects : List Lowered.Object}
    {x : String} {v : Value} (h : (C.callbackArgExpr objects x v).isSome) :
    v.callbackRawType.isSome := by
  unfold C.callbackArgExpr at h
  split at h <;> simp_all [Value.callbackRawType]

/-- And a Lean type, in its callback's type. -/
theorem resultLeanType_of_callbackArgExpr {objects : List Lowered.Object}
    {x : String} {v : Value} (h : (C.callbackArgExpr objects x v).isSome) :
    v.resultLeanType.isSome := by
  unfold C.callbackArgExpr at h
  split at h <;> simp_all [Value.resultLeanType, Value.leanType]

/-- What a trampoline needs of its callback's arguments: each boxed. -/
theorem args_of_trampoline {objects : List Lowered.Object}
    {c : Lowered.Callback} (h : (C.trampoline objects c).isSome) :
    ∀ a ∈ c.args.toList,
      (C.callbackArgExpr objects a.names.c a.value).isSome := by
  obtain ⟨t, ht⟩ := Option.isSome_iff_exists.1 h
  simp [C.trampoline, Option.bind_eq_some_iff] at ht
  -- One part for each guard and bind of `trampoline`, in order.
  obtain ⟨_, _, _, boxed, hboxed, _⟩ := ht
  exact isSome_mapM.1 (by rw [hboxed]; rfl)

/-- The raw declaration's callback parameters exist if each argument's do. -/
theorem callbackBinders_isSome {f : Lowered.Function}
    (h : ∀ c, f.callback = some c →
      ∀ a ∈ c.args.toList, a.value.callbackRawType.isSome) :
    (Lean.callbackBinders f).isSome := by
  unfold Lean.callbackBinders
  split
  · rfl
  · next c hc =>
    obtain ⟨types, htypes⟩ :=
      Option.isSome_iff_exists.1 (isSome_mapM.2 (h c hc))
    simp [htypes]

/--
A callback's types are declared if each argument has a Lean type, and a type
in the raw closure.
-/
theorem callbackDecl_isSome {c : Lowered.Callback}
    (h : ∀ a ∈ c.args.toList, a.value.resultLeanType.isSome)
    (hraw : ∀ a ∈ c.args.toList, a.value.callbackRawType.isSome) :
    (Lean.callbackDecl c).isSome := by
  obtain ⟨types, htypes⟩ := Option.isSome_iff_exists.1 (isSome_mapM.2 h)
  obtain ⟨raw, hraw⟩ := Option.isSome_iff_exists.1 (isSome_mapM.2 hraw)
  simp [Lean.callbackDecl, htypes, hraw]

/-! ## Declarations -/

/--
The raw declaration exists if each argument has parameters, its callback
parameters, and its result a raw type.
-/
theorem rawDecl_isSome {f : Lowered.Function}
    (hargs : ∀ a ∈ f.args.toList, (Lean.rawBinders a.names.lean a.value).isSome)
    (hcallback : (Lean.callbackBinders f).isSome)
    (hresult : ∀ v, f.result = some v → v.rawLeanType.isSome) :
    (Lean.rawDecl f).isSome := by
  simp [Lean.rawDecl, Option.isSome_bind]
  apply any_of_isSome
  · rw [isSome_mapM]
    exact hargs
  · intro x
    apply any_of_isSome hcallback
    intro y
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

/--
Where C has a shim for a function, Lean has both of its declarations, and the
type of the callback it takes, if any.
-/
theorem decls_of_functionShim {objects : List Lowered.Object}
    {structs : List Names} {f : Lowered.Function} {shim : C.Function}
    (h : C.functionShim objects structs f = some shim) :
    (Lean.rawDecl f).isSome ∧ (Lean.wrapperDecl f).isSome
      ∧ ∀ c, f.callback = some c → (Lean.callbackDecl c).isSome := by
  obtain ⟨hargs, hresult, htrampoline⟩ := values_of_functionShim h
  refine ⟨?_, ?_, ?_⟩
  · exact rawDecl_isSome (fun a ha => rawBinders_of_argCrossing (hargs a ha))
      (callbackBinders_isSome fun c hc a ha =>
        callbackRawType_of_callbackArgExpr
          (args_of_trampoline (htrampoline c hc) a ha))
      (fun v hv => rawLeanType_of_resultExpr (hresult v hv))
  · exact wrapperDecl_isSome (fun a ha => leanType_of_argCrossing (hargs a ha))
      (fun v hv => resultLeanType_of_resultExpr (hresult v hv))
  · intro c hc
    exact callbackDecl_isSome
      (fun a ha => resultLeanType_of_callbackArgExpr
        (args_of_trampoline (htrampoline c hc) a ha))
      (fun a ha => callbackRawType_of_callbackArgExpr
        (args_of_trampoline (htrampoline c hc) a ha))

end WebGPUGen.Emit
