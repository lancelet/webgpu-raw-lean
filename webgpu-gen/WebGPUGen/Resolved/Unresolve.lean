import WebGPUGen.Resolved.WellFormed

/-!
# Unresolving

Turning a resolved spec back into a parsed one: each ID becomes the name of the
entry it points at, and each flag value becomes the parsed `value` and
`value_combination` fields. It mirrors `build`, piece by piece, in reverse.

`unresolve` is total. Where a well-formed spec could not reach (an ID out of
range, or an entry default whose name the parsed spec could not write), it uses
a placeholder; theorems about `unresolve` assume `WellFormed`, which rules the
placeholders out:

* faithfulness: `unresolve (build s) = s` when `check s = []`;
* the reverse direction: `resolve (unresolve r) = .ok r` when `WellFormed r`.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-! ## Names by ID -/

/--
The name of the entry at `idx`, or a placeholder if there is none (which
`WellFormed` rules out).
-/
def nameAt {α} (name : α → Name) (xs : Array α) (idx : Nat) : Name :=
  (xs[idx]?.map name).getD default

def constantName (r : Spec) (id : Id .constant) : Name := nameAt (·.name) r.constants id.idx
def typedefName  (r : Spec) (id : Id .typedef)  : Name := nameAt (·.name) r.typedefs  id.idx
def enumName     (r : Spec) (id : Id .enum)     : Name := nameAt (·.name) r.enums     id.idx
def bitflagName  (r : Spec) (id : Id .bitflag)  : Name := nameAt (·.name) r.bitflags  id.idx
def structName   (r : Spec) (id : Id .struct)   : Name := nameAt (·.name) r.structs   id.idx
def callbackName (r : Spec) (id : Id .callback) : Name := nameAt (·.name) r.callbacks id.idx
def objectName   (r : Spec) (id : Id .object)   : Name := nameAt (·.name) r.objects   id.idx

/-! ## Types and defaults -/

/-- The name of the entry a named type refers to. -/
def namedName (r : Spec) : Named → Name
  | .typedef id => typedefName r id
  | .enum    id => enumName    r id
  | .bitflag id => bitflagName r id
  | .struct  id => structName  r id
  | .object  id => objectName  r id

def unresolveTypeRef (r : Spec) : TypeRef → Parsed.TypeRef
  | .primitive p => .primitive p
  | .named t     => .ref      t.kind (namedName r t)
  | .arrayOf t   => .refArray t.kind (namedName r t)
  | .callback id => .callback (callbackName r id)

/--
A default, written with names. An entry default is rebuilt from its entry's
name, which must read as an entry name; `WellFormed` says it does, so the `zero`
placeholder is never used.
-/
def unresolveDefault (r : Spec) : Default → Parsed.Default
  | .bool b           => .bool b
  | .int n            => .int n
  | .float text valid => .float text valid
  | .constant id      => .constant (constantName r id)
  | .entry ref        =>
    let n := (ref.name? r).getD default
    if valid : Parsed.defaultText n.text = .entry then .entry n valid
    else .zero  -- placeholder: `WellFormed` rules this out
  | .zero             => .zero

def unresolveParameter {Doc} (r : Spec) (p : Parameter Doc) : Parsed.Parameter Doc where
  name                := p.name
  doc                 := p.doc
  type                := unresolveTypeRef r p.type
  passedWithOwnership := p.passedWithOwnership
  pointer             := p.pointer
  optional            := p.optional
  default             := p.default.map (unresolveDefault r)

/-! ## Entries -/

/-- A flag's parsed `value`. -/
def unresolveFlagValue : FlagValue → Option Value64
  | .explicit n => some (.int n)
  | _           => none

/-- A flag's parsed `value_combination`: the names of the flags it combines. -/
def unresolveCombination (b : Bitflag) : FlagValue → Option (Array Name)
  | .combination flags => some (flags.map fun i => nameAt (·.name) b.entries i.idx)
  | _                  => none

def unresolveFlag (b : Bitflag) (e : BitflagEntry) : Parsed.BitflagEntry where
  name        := e.name
  ns          := e.ns
  doc         := e.doc
  value       := unresolveFlagValue e.value
  combination := unresolveCombination b e.value

def unresolveBitflag (b : Bitflag) : Parsed.Bitflag where
  name     := b.name
  ns       := b.ns
  doc      := b.doc
  extended := b.extended
  entries  := b.entries.map (unresolveFlag b)

def unresolveStruct (r : Spec) (st : Struct) : Parsed.Struct where
  name            := st.name
  ns              := st.ns
  doc             := st.doc
  kind            := st.kind
  extendedStructs := st.extendedStructs.map (structName r)
  freeMembers     := st.freeMembers
  members         := st.members.map (unresolveParameter r)

def unresolveCallback (r : Spec) (c : Callback) : Parsed.Callback where
  name  := c.name
  ns    := c.ns
  doc   := c.doc
  style := c.style
  args  := c.args.map (unresolveParameter r)

def unresolveReturn (r : Spec) (ret : Return) : Parsed.Return where
  doc                 := ret.doc
  type                := unresolveTypeRef r ret.type
  optional            := ret.optional
  passedWithOwnership := ret.passedWithOwnership
  pointer             := ret.pointer

def unresolveFunction (r : Spec) (f : Function) : Parsed.Function where
  name     := f.name
  ns       := f.ns
  doc      := f.doc
  returns  := f.returns.map (unresolveReturn r)
  callback := f.callback.map (callbackName r)
  args     := f.args.map (unresolveParameter r)

def unresolveObject (r : Spec) (o : Object) : Parsed.Object where
  name     := o.name
  ns       := o.ns
  doc      := o.doc
  extended := o.extended
  methods  := o.methods.map (unresolveFunction r)

/-! ## The whole spec -/

/-- Replace every ID in `r` with the name of the entry it points at. -/
def unresolve (r : Spec) : Parsed.Spec where
  copyright  := r.copyright
  name       := r.name
  enumPrefix := r.enumPrefix
  doc        := r.doc
  constants  := r.constants
  typedefs   := r.typedefs
  enums      := r.enums
  bitflags   := r.bitflags.map unresolveBitflag
  structs    := r.structs.map (unresolveStruct r)
  callbacks  := r.callbacks.map (unresolveCallback r)
  functions  := r.functions.map (unresolveFunction r)
  objects    := r.objects.map (unresolveObject r)

end WebGPUGen.Resolved
