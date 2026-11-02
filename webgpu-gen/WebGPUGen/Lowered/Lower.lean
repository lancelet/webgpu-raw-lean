import WebGPUGen.Lowered
import WebGPUGen.Lowered.CNames
import WebGPUGen.Lowered.LeanNames
import WebGPUGen.Resolved.Values

/-!
# Lowering

Turning a resolved spec into the lowered model: naming each part on both sides,
and working out the values of enum entries and flags. Lowering is a plain map,
like `build`: it trusts the resolved spec to be well formed.
-/

namespace WebGPUGen.Lowered
open WebGPUGen.Common WebGPUGen.Resolved

/-- A spec name's names on both sides, given how each side spells it. -/
def bothNames (c lean : Name → String) (n : Name) : Names :=
  { c := c n, lean := lean n }

/-! ## Enums and bitflags -/

/--
An enum, with the value of each entry. The entry at position `i` keeps the value
position `i` gives it, though reserved slots are left out.
-/
def lowerEnum (r : Resolved.Spec) (e : Common.Enum) : Lowered.Enum where
  names    := bothNames typeName leanTypeName e.name
  doc      := e.doc
  extended := e.extended
  entries  := e.entries.zipIdx.filterMap fun (slot, i) =>
    slot.map fun entry => {
      names := bothNames (entryName e.name) leanName entry.name
      doc   := entry.doc
      value := enumValue r i entry
    }

/-- A bitflag type, with the value of each flag. -/
def lowerBitflag (b : Resolved.Bitflag) : Lowered.Bitflag where
  names    := bothNames typeName leanTypeName b.name
  doc      := b.doc
  extended := b.extended
  flags    := b.entries.mapIdx fun i flag => {
    names := bothNames (entryName b.name) leanName flag.name
    doc   := flag.doc
    value := flagValue b i
  }

/-! ## The whole spec -/

/-- Lower a resolved spec. -/
def lower (r : Resolved.Spec) : Lowered.Spec where
  enums    := r.enums.map (lowerEnum r)
  bitflags := r.bitflags.map lowerBitflag

end WebGPUGen.Lowered
