import WebGPUGen.Resolved
import WebGPUGen.Resolved.Rules

/-!
# Enum and flag values

The number each enum entry and flag stands for, as upstream's generator
computes it (`EnumValue32`, `bitflagEntryValue` and `BitflagValue` in
`gen/gen.go`). These are facts about the resolved spec, not about C: the Lean
bindings use the same numbers.

Where no spec goes, the two can differ:

* an enum entry numbered by a position past 65535: upstream rejects it, and
  `check` does not yet;
* a flag numbered by a position past 64: upstream silently overflows;
* an explicit value written in octal or with a `+`, or quoted: values here
  follow the YAML core schema, upstream reads decimal or `0x` hex text.

Proofs about the values will need the first two as assumptions.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-! ## Enums -/

/--
The value of the enum entry at position `i`: its block in the high 16 bits (the
spec's enum prefix, or its namespace's block), and in the low 16 its explicit
value or else its position.
-/
def enumValue (r : Spec) (i : Nat) (entry : EnumEntry) : UInt32 :=
  let block : UInt16 := match entry.ns with
    | some ns => (namespaceBlock? ns).getD 0  -- `WellFormed` says it is known
    | none    => r.enumPrefix.val.toUInt16
  let low : UInt16 := entry.value.getD i.toUInt16
  (block.toUInt32 <<< 16) ||| low.toUInt32

/-! ## Flags -/

/--
A flag's own value: as written, or else by position `i`, 0 for the first and
then 1, 2, 4, …. A combination's own value is by position: this is what
upstream ORs together when another combination names it.
-/
def flagOwnValue (i : Nat) : FlagValue → UInt64
  | .explicit n => n
  | _           => if i = 0 then 0 else 1 <<< (i - 1).toUInt64

/-- The own value of the flag at position `i` of `b`. -/
def flagOwnValueAt (b : Bitflag) (i : Nat) : UInt64 :=
  flagOwnValue i ((b.entries[i]?.map (·.value)).getD .implicit)

/--
The value of the flag at position `i` of `b`: a combination ORs together the own
values of the flags it names, any other flag has its own value. Like upstream,
an empty combination counts as none, so its value is by position.
-/
def flagValue (b : Bitflag) (i : Nat) : UInt64 :=
  match (b.entries[i]?.map (·.value)).getD .implicit with
  | .combination flags =>
    if flags.isEmpty then flagOwnValueAt b i
    -- `WellFormed` says each flag is in range.
    else flags.foldl (init := 0) fun acc f => acc ||| flagOwnValueAt b f.idx
  | _ => flagOwnValueAt b i

end WebGPUGen.Resolved
