module

public import WebGPU.Raw.CEnum

/-!
# The `c_enum` command

A helper for the generated bindings, not part of the API: the bindings import
this module privately, so it never reaches their users.

    c_enum AddressMode where
      | clampToEdge  = 0x00000001
      | «repeat»     = 0x00000002

declares the enum, giving each value's code once, and its `CEnum` instance.
Both directions are `match`es, which compile to jump tables as hand-written
code would.

The instance proves both laws for the enum it declares, and the command also
proves every code fits in 32 bits. So Lean's kernel checks every enum this
command makes: each value has the code written beside it, and the two
directions are inverse. A mistake in the command can only stop the bindings
compiling. An enum needs at least one value, as every C enum has.

The proofs take time roughly quadratic in the number of values: about 8
seconds for 100, the size of the largest WebGPU enum.
-/

public section

namespace WebGPU.Raw.Internal
open Lean

/-- `c_enum T where | a = 1 | b = 2 …`: the enum `T` and its `CEnum` instance. -/
syntax (docComment)? "c_enum " ident " where"
  (ppLine atomic((docComment)? " | ") ident " = " num)* : command

macro_rules
  | `($[$doc?]? c_enum $T:ident where $[$[$docs?]? | $cs:ident = $vs:num]*) => do
    let cs : Array Ident := cs.map (⟨·⟩)
    let vs : Array NumLit := vs.map (⟨·⟩)
    for v in vs do
      if v.getNat ≥ 2 ^ 32 then
        Macro.throwErrorAt v "a C enum code must fit in 32 bits"
    let qualified := cs.map fun c => mkIdentFrom c (T.getId ++ c.getId)
    `($[$doc?]? inductive $T:ident where
        $[$[$docs?]? | $cs:ident]*
        deriving Repr, DecidableEq, Inhabited
      instance : CEnum $T where
        toC     := fun a => match a with
          $[| $qualified => $vs]*
        ofC?    := fun n => match n with
          $[| $vs => some $qualified]*
          | _ => none
        ofC_toC := by
          intro a
          cases a <;> rfl
        toC_ofC := by
          intro n a h
          split at h <;> cases h <;> rfl
      -- Each code fits in 32 bits, so it is the number written, not wrapped.
      example : ([$vs,*] : List Nat).all (· < 2 ^ 32) := by decide)

end WebGPU.Raw.Internal

end
