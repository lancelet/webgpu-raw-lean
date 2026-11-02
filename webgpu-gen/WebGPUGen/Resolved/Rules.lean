import WebGPUGen.Common

/-!
# Rules

The rules a spec must follow beyond referring to real entries, as upstream's
generator applies them. Each is defined once, here: `check` reports a problem
when a rule fails on the parsed spec, and `WellFormed` requires it of the
resolved spec. Keeping one definition means the two can never disagree.

The rules look at only a little of each type and default, so both specs
describe theirs in the same small terms (`MemberShape`, `DefaultKind`) before
asking a rule.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-! ## Namespaces -/

/--
The block of enum values a namespace's entries use, for the namespaces upstream
knows. Entries in another namespace cannot be numbered.
-/
def namespaceBlock? (ns : Name) : Option UInt16 :=
  if ns.text == "compatibility_mode" then some 0x2000 else none

/-! ## Parameters -/

/-- Where a parameter appears; some rules depend on it. -/
inductive Role where
  | member            -- a struct member
  | argument          -- a function argument
  | callbackArgument  -- a callback argument
  deriving Repr, DecidableEq

/--
May a parameter in this role set `passed_with_ownership` to this? Struct members
may not set it; function arguments may only set it to `true`; callback arguments
may set it either way.
-/
def ownershipOk : Role → Option Bool → Bool
  | _,         none       => true
  | .member,   some _     => false
  | .argument, some false => false
  | _,         _          => true

/-- May a return value set `passed_with_ownership` to this? Only to `true`. -/
def returnOwnershipOk : Option Bool → Bool
  | some false => false
  | _          => true

/-! ## Defaults

Defaults exist for the C `INIT` macros, so only struct members have them, and
never pointers. -/

/-- What the default rules need to know about a member's type. -/
inductive MemberShape where
  | struct                  -- struct.x
  | scalar (p : Primitive)  -- a primitive, not an array
  | other                   -- enums, bitflags, objects, arrays, callbacks, typedefs
  deriving Repr, DecidableEq

/-- What the default rules need to know about a default. -/
inductive DefaultKind where
  | bool
  | int
  | float
  | constant
  | entry
  | zero
  deriving Repr, DecidableEq

/-- The primitive types upstream gives integer defaults: not `int16`. -/
def takesInteger : Primitive → Bool
  | .uint16 | .uint32 | .uint64 | .usize | .int32 => true
  | _                                             => false

/-- The primitive types upstream gives float defaults. -/
def takesFloat : Primitive → Bool
  | .float32 | .nullableFloat32 | .float64 | .float64Supertype => true
  | _                                                          => false

/--
Does a default of this kind suit a member of this shape? Entry defaults are
matched against the member's own enum or bitflag instead.
-/
def defaultSuits : MemberShape → DefaultKind → Bool
  | .struct,       .zero     => true
  | .scalar .bool, .bool     => true
  | .scalar .bool, .constant => true
  | .scalar p,     .int      => takesInteger p || takesFloat p
  | .scalar p,     .float    => takesFloat p
  | .scalar p,     .constant => takesInteger p || takesFloat p
  | _,             _         => false

end WebGPUGen.Resolved
