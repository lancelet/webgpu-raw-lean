import WebGPUGen.Resolved.Lemmas

/-!
# What each check guarantees

For each check in `Resolve.lean`, a lemma saying exactly when it reports
nothing, as a plain statement about the parsed spec. The statements never
mention the path: it only labels problems, so it never changes whether there
are any.

The statements use the forms `WellFormed` uses: `Nodup` for distinct names,
the rules from `WebGPUGen.Resolved.Rules`, and membership. A name that must
exist is stated as `∃ x ∈ xs, x.name = n` (for references, through `RefOk`),
which is what `indexOf_spec` needs. A part with its own check is stated as
passing that check at every path; its own lemma then says what that means.

Soundness uses these lemmas left to right; the reverse direction, right to
left.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-! ## Types and defaults

Two small predicates say what `checkTypeRef` and `checkDefault` require,
case by case. -/

/-- Every name in a parsed type names an entry of the right kind. -/
def TypeRefOk (s : Parsed.Spec) : Parsed.TypeRef → Prop
  | .primitive _     => True
  | .ref kind n      => RefOk s kind n
  | .refArray kind n => RefOk s kind n
  | .callback n      => ∃ c ∈ s.callbacks, c.name = n

/-- A type passes exactly when every name in it names an entry. -/
theorem checkTypeRef_eq_nil {s : Parsed.Spec} {path : Array String} {t : Parsed.TypeRef} :
    checkTypeRef s path t = [] ↔ TypeRefOk s t := by
  cases t <;> simp [checkTypeRef, TypeRefOk, checkRef_eq_nil, checkCallbackName_eq_nil]

/--
What a default on a member of type `type` requires of the spec. A constant must
exist. An entry needs an enum or bitflag member and, if that enum or bitflag
exists, must be one of its entries; if it does not exist, the member's type is
at fault instead.

The entry is looked for in the *first* enum or bitflag with the member type's
name. Going back from a resolved spec, where the member type is an ID, needs the
names to be distinct to know it is the first.
-/
def DefaultOk (s : Parsed.Spec) (type : Parsed.TypeRef) : Parsed.Default → Prop
  | .constant n => ∃ c ∈ s.constants, c.name = n
  | .entry n _  =>
    match type with
    | .ref .enum e    => ∀ i, indexOf? (·.name) s.enums e = some i →
        ∃ slot ∈ s.enums[i].entries, slotName slot = some n
    | .ref .bitflag b => ∀ i, indexOf? (·.name) s.bitflags b = some i →
        ∃ f ∈ s.bitflags[i].entries, f.name = n
    | _               => False
  | _           => True

/-- A default passes exactly when what it names exists. -/
theorem checkDefault_eq_nil {s : Parsed.Spec} {path : Array String} {type : Parsed.TypeRef}
    {d : Parsed.Default} :
    checkDefault s path type d = [] ↔ DefaultOk s type d := by
  cases d with
  | constant n =>
    simp only [checkDefault, DefaultOk]
    rw [← indexOf?_isSome]
    split <;> simp_all [problem]
  | entry n v =>
    simp only [checkDefault, DefaultOk]
    -- A member that is neither an enum nor a bitflag is a problem outright; an
    -- enum or bitflag member is the same argument for both.
    split <;> first
      | (simp only [problem, List.cons_ne_nil]; done)
      | (dsimp only
         split
         · rename_i i hi
           constructor
           · intro h j hj
             rw [hi, Option.some.injEq] at hj
             subst hj
             rw [← indexOf?_isSome]
             split at h
             · assumption
             · simp [problem] at h
           · intro h
             rw [if_pos (indexOf?_isSome.mpr (h i hi))]
         · simp_all)
  | _ => simp [checkDefault, DefaultOk]

/-! ## Parameters -/

/-- `passed_with_ownership` passes exactly when the ownership rule allows it. -/
theorem checkOwnership_eq_nil {role : Role} {path : Array String} {owned : Option Bool} :
    checkOwnership role path owned = [] ↔ ownershipOk role owned = true := by
  unfold checkOwnership
  cases role <;> rcases owned with _ | _ | _ <;> simp [ownershipOk, problem]

/--
A default's use passes exactly when it is on a struct member that is not a
pointer, and, unless it is an entry (which `checkDefault` checks), suits the
member's type.
-/
theorem checkDefaultUse_eq_nil {Doc} {role : Role} {path : Array String}
    {p : Parsed.Parameter Doc} {d : Parsed.Default} :
    checkDefaultUse role path p d = [] ↔
      role = .member ∧ p.pointer = none ∧
        (defaultKind d ≠ .entry → defaultSuits (memberShape p.type) (defaultKind d) = true) := by
  unfold checkDefaultUse
  cases role <;> cases hp : p.pointer <;> cases d <;> simp_all [problem, defaultKind]

/--
A parameter passes exactly when its type passes, its ownership is allowed, and a
default, if it has one, is allowed where it is and names what exists.
-/
theorem checkParameter_eq_nil {Doc} {s : Parsed.Spec} {role : Role} {path : Array String}
    {p : Parsed.Parameter Doc} :
    checkParameter s role path p = [] ↔
      TypeRefOk s p.type ∧ ownershipOk role p.passedWithOwnership = true ∧
      ∀ d, p.default = some d →
        role = .member ∧ p.pointer = none ∧
        (defaultKind d ≠ .entry → defaultSuits (memberShape p.type) (defaultKind d) = true) ∧
        DefaultOk s p.type d := by
  unfold checkParameter
  simp only [List.append_eq_nil_iff, checkTypeRef_eq_nil, checkOwnership_eq_nil]
  cases p.default <;>
    simp [List.append_eq_nil_iff, checkDefaultUse_eq_nil, checkDefault_eq_nil, and_assoc]

/--
A return value passes exactly when its type passes and its ownership is allowed.
-/
theorem checkReturn_eq_nil {s : Parsed.Spec} {path : Array String} {r : Parsed.Return} :
    checkReturn s path r = [] ↔
      TypeRefOk s r.type ∧ returnOwnershipOk r.passedWithOwnership = true := by
  unfold checkReturn
  rw [List.append_eq_nil_iff, checkTypeRef_eq_nil]
  split <;> simp_all [problem]

/-! ## Bitflags and enums -/

/--
A flag passes exactly when it does not give both a value and a combination, a
value is an integer, and a combination names flags of the same type.
-/
theorem checkFlag_eq_nil {b : Parsed.Bitflag} {path : Array String} {e : Parsed.BitflagEntry} :
    checkFlag b path e = [] ↔
      (e.value = none ∨ e.combination = none) ∧
      (∀ v, e.value = some v → ∃ n, v = .int n) ∧
      (∀ names, e.combination = some names →
        ∀ n ∈ names.toList, ∃ f ∈ b.entries, f.name = n) := by
  unfold checkFlag
  split
  · simp_all [problem]
  · simp_all
  · rename_i v _ _
    simp_all [problem]
  · rename_i names hv hc
    rw [eachAt_eq_nil_iff_mem]
    · simp only [hv, hc]
      constructor
      · intro H
        refine ⟨by simp, by simp, fun ns hns n hn => ?_⟩
        cases hns
        have h := H n hn #[]
        rw [← indexOf?_isSome]
        split at h
        · assumption
        · simp [problem] at h
      · rintro ⟨-, -, H⟩ n hn q
        rw [if_pos (indexOf?_isSome.mpr (H names rfl n hn))]
    · intro p q n
      split <;> simp [problem]
  · simp_all

/--
A bitflag passes exactly when its flags' names are distinct and each flag
passes.
-/
theorem checkBitflag_eq_nil {path : Array String} {b : Parsed.Bitflag} :
    checkBitflag path b = [] ↔
      (b.entries.toList.map (·.name)).Nodup ∧
      ∀ e ∈ b.entries.toList, ∀ path, checkFlag b path e = [] := by
  unfold checkBitflag
  rw [List.append_eq_nil_iff, duplicates_map_some_eq_nil,
    eachAt_eq_nil_iff_mem (f := checkFlag b) fun _ _ _ h =>
      checkFlag_eq_nil.mpr (checkFlag_eq_nil.mp h)]

/--
An enum passes exactly when its entries' names are distinct, and every
namespaced entry is in the core spec, in a known namespace, with an explicit
value.
-/
theorem checkEnum_eq_nil {s : Parsed.Spec} {path : Array String} {e : Enum} :
    checkEnum s path e = [] ↔
      (e.entries.toList.filterMap (·.map (·.name))).Nodup ∧
      ∀ entry, some entry ∈ e.entries.toList → ∀ ns, entry.ns = some ns →
        s.enumPrefix.val = 0 ∧ (namespaceBlock? ns).isSome ∧ entry.value.isSome := by
  unfold checkEnum
  rw [List.append_eq_nil_iff, duplicates_slotName_eq_nil, eachAt_eq_nil_iff_mem]
  · refine and_congr_right' ⟨fun H entry hmem ns hns => ?_, fun H slot hmem q => ?_⟩
    · obtain ⟨name, ns', doc, value⟩ := entry
      simp only at hns
      subst hns
      have h := H _ hmem #[]
      by_cases h0 : s.enumPrefix.val = 0 <;> cases hb : namespaceBlock? ns <;>
        cases value <;> simp_all [problem]
    · rcases slot with _ | ⟨name, _ | ns, doc, value⟩
      · rfl
      · rfl
      · obtain ⟨h0, hb, hv⟩ := H _ hmem ns rfl
        cases hb' : namespaceBlock? ns <;> cases value <;> simp_all
  · intro p q slot h
    rcases slot with _ | ⟨name, _ | ns, doc, value⟩
    · rfl
    · rfl
    · by_cases h0 : s.enumPrefix.val = 0 <;> cases hb : namespaceBlock? ns <;>
        cases value <;> simp_all [problem]

/-! ## Structs, callbacks, functions and objects -/

/--
A struct passes exactly when every struct it extends exists, its members' names
are distinct, and each member passes.
-/
theorem checkStruct_eq_nil {s : Parsed.Spec} {path : Array String} {st : Parsed.Struct} :
    checkStruct s path st = [] ↔
      (∀ n ∈ st.extendedStructs.toList, ∃ x ∈ s.structs, x.name = n) ∧
      (st.members.toList.map (·.name)).Nodup ∧
      ∀ p ∈ st.members.toList, ∀ path, checkParameter s .member path p = [] := by
  unfold checkStruct
  simp only [List.append_eq_nil_iff, and_assoc]
  rw [duplicates_map_some_eq_nil,
    eachAt_eq_nil_iff_mem (f := fun path n => checkRef s path .struct n)
      fun _ _ _ h => checkRef_eq_nil.mpr (checkRef_eq_nil.mp h),
    eachAt_eq_nil_iff_mem (f := checkParameter s .member) fun _ _ _ h =>
      checkParameter_eq_nil.mpr (checkParameter_eq_nil.mp h)]
  simp [checkRef_eq_nil, RefOk]

/--
A callback passes exactly when its arguments' names are distinct and each
argument passes.
-/
theorem checkCallback_eq_nil {s : Parsed.Spec} {path : Array String} {c : Parsed.Callback} :
    checkCallback s path c = [] ↔
      (c.args.toList.map (·.name)).Nodup ∧
      ∀ p ∈ c.args.toList, ∀ path, checkParameter s .callbackArgument path p = [] := by
  unfold checkCallback
  rw [List.append_eq_nil_iff, duplicates_map_some_eq_nil,
    eachAt_eq_nil_iff_mem (f := checkParameter s .callbackArgument) fun _ _ _ h =>
      checkParameter_eq_nil.mpr (checkParameter_eq_nil.mp h)]

/--
A function passes exactly when its return value (if any) passes, its callback
type (if any) exists, its arguments' names are distinct, and each argument
passes.
-/
theorem checkFunction_eq_nil {s : Parsed.Spec} {path : Array String} {f : Parsed.Function} :
    checkFunction s path f = [] ↔
      (∀ r, f.returns = some r → ∀ path, checkReturn s path r = []) ∧
      (∀ n, f.callback = some n → ∃ c ∈ s.callbacks, c.name = n) ∧
      (f.args.toList.map (·.name)).Nodup ∧
      ∀ p ∈ f.args.toList, ∀ path, checkParameter s .argument path p = [] := by
  unfold checkFunction
  simp only [List.append_eq_nil_iff, and_assoc]
  rw [duplicates_map_some_eq_nil,
    eachAt_eq_nil_iff_mem (f := checkParameter s .argument) fun _ _ _ h =>
      checkParameter_eq_nil.mpr (checkParameter_eq_nil.mp h)]
  refine and_congr ?_ (and_congr ?_ Iff.rfl)
  · cases f.returns <;> simp [checkReturn_eq_nil]
  · cases f.callback <;> simp [checkCallbackName_eq_nil]

/--
An object passes exactly when its methods' names are distinct and each method
passes.
-/
theorem checkObject_eq_nil {s : Parsed.Spec} {path : Array String} {o : Parsed.Object} :
    checkObject s path o = [] ↔
      (o.methods.toList.map (·.name)).Nodup ∧
      ∀ f ∈ o.methods.toList, ∀ path, checkFunction s path f = [] := by
  unfold checkObject
  rw [List.append_eq_nil_iff, duplicates_map_some_eq_nil,
    eachAt_eq_nil_iff_mem (f := checkFunction s) fun _ _ _ h =>
      checkFunction_eq_nil.mpr (checkFunction_eq_nil.mp h)]

/-! ## Sections -/

/--
A section passes exactly when its names are distinct and each entry passes its
check at every path.
-/
theorem checkSection_eq_nil_iff_mem {α} {key : String} {xs : Array α} {name : α → Name}
    {f : Array String → α → List Problem} (hf : ∀ p q x, f p x = [] → f q x = []) :
    checkSection key xs name f = [] ↔
      (xs.toList.map name).Nodup ∧ ∀ x ∈ xs.toList, ∀ path, f path x = [] := by
  rw [checkSection_eq_nil, duplicates_map_some_eq_nil, eachAt_eq_nil_iff_mem hf]

/-! ### Each section

The same, section by section. Rewriting with `checkSection_eq_nil_iff_mem`
directly makes Lean search for the check, which can time out; these name it. -/

/-- Constants need only distinct names. -/
theorem checkConstants_eq_nil {s : Parsed.Spec} :
    checkConstants s = [] ↔ (s.constants.toList.map (·.name)).Nodup := by
  unfold checkConstants
  rw [checkSection_eq_nil_iff_mem (f := noChecks) fun _ _ _ _ => rfl]
  simp [noChecks]

/-- Typedefs need only distinct names. -/
theorem checkTypedefs_eq_nil {s : Parsed.Spec} :
    checkTypedefs s = [] ↔ (s.typedefs.toList.map (·.name)).Nodup := by
  unfold checkTypedefs
  rw [checkSection_eq_nil_iff_mem (f := noChecks) fun _ _ _ _ => rfl]
  simp [noChecks]

theorem checkEnums_eq_nil {s : Parsed.Spec} :
    checkEnums s = [] ↔
      (s.enums.toList.map (·.name)).Nodup ∧
      ∀ e ∈ s.enums.toList, ∀ path, checkEnum s path e = [] :=
  checkSection_eq_nil_iff_mem (f := checkEnum s) fun _ _ _ h =>
    checkEnum_eq_nil.mpr (checkEnum_eq_nil.mp h)

theorem checkBitflags_eq_nil {s : Parsed.Spec} :
    checkBitflags s = [] ↔
      (s.bitflags.toList.map (·.name)).Nodup ∧
      ∀ b ∈ s.bitflags.toList, ∀ path, checkBitflag path b = [] :=
  checkSection_eq_nil_iff_mem (f := checkBitflag) fun _ _ _ h =>
    checkBitflag_eq_nil.mpr (checkBitflag_eq_nil.mp h)

theorem checkStructs_eq_nil {s : Parsed.Spec} :
    checkStructs s = [] ↔
      (s.structs.toList.map (·.name)).Nodup ∧
      ∀ st ∈ s.structs.toList, ∀ path, checkStruct s path st = [] :=
  checkSection_eq_nil_iff_mem (f := checkStruct s) fun _ _ _ h =>
    checkStruct_eq_nil.mpr (checkStruct_eq_nil.mp h)

theorem checkCallbacks_eq_nil {s : Parsed.Spec} :
    checkCallbacks s = [] ↔
      (s.callbacks.toList.map (·.name)).Nodup ∧
      ∀ c ∈ s.callbacks.toList, ∀ path, checkCallback s path c = [] :=
  checkSection_eq_nil_iff_mem (f := checkCallback s) fun _ _ _ h =>
    checkCallback_eq_nil.mpr (checkCallback_eq_nil.mp h)

theorem checkFunctions_eq_nil {s : Parsed.Spec} :
    checkFunctions s = [] ↔
      (s.functions.toList.map (·.name)).Nodup ∧
      ∀ f ∈ s.functions.toList, ∀ path, checkFunction s path f = [] :=
  checkSection_eq_nil_iff_mem (f := checkFunction s) fun _ _ _ h =>
    checkFunction_eq_nil.mpr (checkFunction_eq_nil.mp h)

theorem checkObjects_eq_nil {s : Parsed.Spec} :
    checkObjects s = [] ↔
      (s.objects.toList.map (·.name)).Nodup ∧
      ∀ o ∈ s.objects.toList, ∀ path, checkObject s path o = [] :=
  checkSection_eq_nil_iff_mem (f := checkObject s) fun _ _ _ h =>
    checkObject_eq_nil.mpr (checkObject_eq_nil.mp h)

end WebGPUGen.Resolved
