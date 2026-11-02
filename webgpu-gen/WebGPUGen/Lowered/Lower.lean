import WebGPUGen.Lowered
import WebGPUGen.Lowered.CNames
import WebGPUGen.Lowered.LeanNames
import WebGPUGen.Lowered.Docs
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
def lowerEnum (ctx : DocContext) (r : Resolved.Spec) (e : Common.Enum) : Lowered.Enum where
  names    := bothNames typeName leanTypeName e.name
  doc      := translateDoc ctx e.doc
  extended := e.extended
  entries  := e.entries.zipIdx.filterMap fun (slot, i) =>
    slot.map fun entry => {
      names := bothNames (entryName e.name) leanName entry.name
      doc   := translateDoc ctx entry.doc
      value := enumValue r i entry
    }

/-- A bitflag type, with the value of each flag. -/
def lowerBitflag (ctx : DocContext) (b : Resolved.Bitflag) : Lowered.Bitflag where
  names    := bothNames typeName leanTypeName b.name
  doc      := translateDoc ctx b.doc
  extended := b.extended
  flags    := b.entries.mapIdx fun i flag => {
    names := bothNames (entryName b.name) leanName flag.name
    doc   := translateDoc ctx flag.doc
    value := flagValue b i
  }

/-! ## Objects -/

/-- An object type, named on both sides. -/
def lowerObject (ctx : DocContext) (o : Resolved.Object) : Lowered.Object where
  names := bothNames typeName leanTypeName o.name
  doc   := translateDoc ctx o.doc

/-! ## The whole spec -/

/--
Lower a resolved spec. `sections` are the documentation sections its docs may
refer to, each with its page (`articleSections` reads them from upstream's
articles).
-/
def lower (r : Resolved.Spec) (sections : List (String × String) := []) : Lowered.Spec :=
  let ctx : DocContext := {
    leanNames := leanNamesOfC r
    sections  := Std.HashMap.ofList sections
  }
  {
    enums    := r.enums.map (lowerEnum ctx r)
    bitflags := r.bitflags.map (lowerBitflag ctx)
    objects  := r.objects.map (lowerObject ctx)
  }

end WebGPUGen.Lowered
