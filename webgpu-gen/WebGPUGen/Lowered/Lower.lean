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

/-! ## Values -/

/--
A short description of a type, for saying what the bindings cannot pass yet:
`struct (immutable pointer)`.
-/
def describe (t : TypeRef) (pointer : Option Pointer) : String :=
  let what := match t with
    | .primitive p          => p.render
    | .named (.typedef _)   => "typedef"
    | .named (.enum _)      => "enum"
    | .named (.bitflag _)   => "bitflag"
    | .named (.struct _)    => "struct"
    | .named (.object _)    => "object"
    | .arrayOf _            => "array"
    | .callback _           => "callback"
  match pointer with
  | none            => what
  | some .immutable => what ++ " (immutable pointer)"
  | some .mutable   => what ++ " (mutable pointer)"

/--
A primitive the bindings pass as it is. A string here is an input string; the
spec's other primitives are not passed yet.
-/
def scalarValue (t : TypeRef) : Primitive → Value
  | .bool                   => .bool
  | .uint16                 => .uint16
  | .uint32                 => .uint32
  | .uint64                 => .uint64
  | .usize                  => .usize
  | .int16                  => .int16
  | .int32                  => .int32
  | .float32                => .float32
  | .float64                => .float64
  | .stringWithDefaultEmpty => .string false
  | .nullableString         => .string true
  | _                       => .unsupported (describe t none)

/-- The names of the enum, bitflag type or object type a type names, if any. -/
def namedNames (r : Resolved.Spec) : Named → Option Names
  | .enum id    => r.enums[id.idx]?.map (typeNames ·.name)
  | .bitflag id => r.bitflags[id.idx]?.map (typeNames ·.name)
  | .object id  => r.objects[id.idx]?.map (typeNames ·.name)
  | _           => none
where
  typeNames := bothNames typeName leanTypeName

/--
The value `value` makes of the names of the type `t` names, if `t` is in range.
-/
def named (r : Resolved.Spec) (t : Named) (value : Names → Value) : Value :=
  match namedNames r t with
  | some names => value names
  | none       => .unsupported "a reference out of range"

/--
How an argument crosses into C, borrowed for the call. Only the shapes the
bindings handle are passed: a primitive, enum, bitflag or object, not behind a
pointer. An object can be optional: NULL in C. An argument with ownership stated
is an output struct whose members the caller must free, which is not handled
yet.
-/
def argValue (r : Resolved.Spec) (p : Parameter Paragraph) : Value :=
  let unsupported := Value.unsupported (describe p.type p.pointer)
  if p.pointer.isSome || p.passedWithOwnership.isSome then unsupported else
  match p.type with
  | .primitive (.scalar s) =>
    if p.optional then unsupported else scalarValue p.type s
  | .named (.enum id) =>
    if p.optional then unsupported else named r (.enum id) .enum
  | .named (.bitflag id) =>
    if p.optional then unsupported else named r (.bitflag id) .bitflag
  | .named (.object id) => named r (.object id) (.object · p.optional)
  | _ => unsupported

/--
How a result crosses back into Lean. An object is passed only if the spec says
it comes with its own reference (`passed_with_ownership`), which the Lean value
takes; a string is not passed yet. Optional means it can be NULL: `none` in
Lean.
-/
def resultValue (r : Resolved.Spec) (ret : Return) : Value :=
  let unsupported := Value.unsupported (describe ret.type ret.pointer)
  if ret.pointer.isSome then unsupported else
  match ret.type with
  | .primitive (.scalar s) =>
    match scalarValue ret.type s with
    | .string _ => unsupported
    | v         =>
      if ret.optional || ret.passedWithOwnership.isSome then unsupported else v
  | .named (.object id) =>
    if ret.passedWithOwnership != some true then
      .unsupported "an object without ownership stated"
    else named r (.object id) (.object · ret.optional)
  | .named (.enum id) =>
    if ret.optional || ret.passedWithOwnership.isSome then unsupported
    else named r (.enum id) .enum
  | .named (.bitflag id) =>
    if ret.optional || ret.passedWithOwnership.isSome then unsupported
    else named r (.bitflag id) .bitflag
  | _ => unsupported

/-! ## Structs -/

/--
An array's element of a primitive type: a number or a `Bool`. (A string array
is not passed yet.)
-/
def elementValue : ArrayElement → Value
  | .bool    => .bool
  | .uint16  => .uint16
  | .uint32  => .uint32
  | .uint64  => .uint64
  | .usize   => .usize
  | .int16   => .int16
  | .int32   => .int32
  | .float32 => .float32
  | .float64 => .float64
  | .string  => .unsupported "array<string>"

/--
How a struct member crosses. As for an argument, only the shapes the bindings
handle are passed, and a member with ownership stated is not; beyond those, a
struct by value, a struct behind an immutable pointer (NULL if optional), an
array behind an immutable pointer, and a `float64_supertype`, which C holds as
a `double`. An array may not be optional.
-/
def memberValue (r : Resolved.Spec) (p : Parameter String) : Value :=
  let unsupported := Value.unsupported (describe p.type p.pointer)
  if p.passedWithOwnership.isSome then unsupported else
  match p.pointer, p.type with
  | none, .primitive (.scalar .float64Supertype) =>
    if p.optional then unsupported else .float64
  | none, .primitive (.scalar s) =>
    if p.optional then unsupported else scalarValue p.type s
  | none, .named (.enum id) =>
    if p.optional then unsupported else named r (.enum id) .enum
  | none, .named (.bitflag id) =>
    if p.optional then unsupported else named r (.bitflag id) .bitflag
  | none, .named (.object id) => named r (.object id) (.object · p.optional)
  | none, .named (.struct id) =>
    if p.optional then unsupported else structNamed id .struct
  | some .immutable, .named (.struct id) =>
    structNamed id (.structPointer · p.optional)
  | some .immutable, .arrayOf (.enum id) =>
    if p.optional then unsupported
    else named r (.enum id) fun names => .array (.enum names) count
  | some .immutable, .arrayOf (.struct id) =>
    if p.optional then unsupported
    else structNamed id fun names => .array (.struct names) count
  | some .immutable, .arrayOf (.object id) =>
    if p.optional then unsupported
    else named r (.object id) fun names => .array (.object names false) count
  | some .immutable, .primitive (.array e) =>
    match elementValue e with
    | .unsupported what => .unsupported what
    | element => if p.optional then unsupported else .array element count
  | _, _ => unsupported
where
  count := arrayCountName p.name
  structNamed (id : Id .struct) (value : Names → Value) : Value :=
    match r.structs[id.idx]? with
    | some s => value (bothNames typeName leanTypeName s.name)
    | none   => .unsupported "a reference out of range"

/--
A member's default, naming what it refers to on both sides; none if it refers
to nothing in range, which a well-formed spec never does.
-/
def lowerDefault (r : Resolved.Spec) : Resolved.Default → Option Lowered.Default
  | .bool b         => some (.bool b)
  | .int n          => some (.int n)
  | .float text _   => some (.float text)
  | .zero           => some .zero
  | .constant id    => r.constants[id.idx]?.map fun c =>
    .constant (bothNames constantName leanName c.name)
  | .entry (.enumEntry e i) => do
    let enum ← r.enums[e.idx]?
    let entry ← (← enum.entries[i.idx]?)
    pure (.entry (bothNames typeName leanTypeName enum.name)
      (bothNames (entryName enum.name) leanName entry.name))
  | .entry (.flag b i) => do
    let bitflag ← r.bitflags[b.idx]?
    let flag ← bitflag.entries[i.idx]?
    pure (.entry (bothNames typeName leanTypeName bitflag.name)
      (bothNames (entryName bitflag.name) leanName flag.name))

/--
The default C's initialiser gives a member the spec gives none, by upstream's
rules (`DefaultValue` in its gen.go): zero for a number, `false`, an empty
array or string, a nested struct at its own defaults, `none` for an optional
object or pointer; for an enum its `undefined` entry, and for a bitflag type its
`none` flag. None where those give no valid value, so the member is required:
an enum with no `undefined` entry (C would set a code no entry has), or an
object or pointer that is not optional (C would set NULL).
-/
def implicitDefault (r : Resolved.Spec) (p : Parameter String) :
    Value → Option Lowered.Default
  | .bool                       => some (.bool false)
  | .uint16 | .uint32 | .uint64 | .int16 | .int32 | .usize => some (.int 0)
  | .float32 | .float64         => some (.float "0.0")
  | .string false | .array ..   => some .empty
  | .string true                => some .null
  | .object _ nullable          => if nullable then some .null else none
  | .structPointer _ nullable   => if nullable then some .null else none
  | .struct _                   => some .nested
  | .enum _ => match p.type with
    | .named (.enum id) => do
      let e ← r.enums[id.idx]?
      let entries := e.entries.toList.filterMap fun slot => slot
      let entry ← entries.find? (·.name.text == "undefined")
      pure (.entry (bothNames typeName leanTypeName e.name)
        (bothNames (entryName e.name) leanName entry.name))
    | _ => none
  | .bitflag _ => match p.type with
    | .named (.bitflag id) => do
      let b ← r.bitflags[id.idx]?
      let flag ← b.entries.toList.find? (·.name.text == "none")
      pure (.entry (bothNames typeName leanTypeName b.name)
        (bothNames (entryName b.name) leanName flag.name))
    | _ => none
  | .unsupported _ => none

/--
A struct, named on both sides, with how each member crosses and its default,
the spec's or else upstream's (`implicitDefault`).
-/
def lowerStruct (ctx : DocContext) (r : Resolved.Spec) (s : Resolved.Struct) :
    Lowered.Struct where
  names           := bothNames typeName leanTypeName s.name
  doc             := translateDoc ctx s.doc
  kind            := s.kind
  extendedStructs := s.extendedStructs.filterMap fun id =>
    r.structs[id.idx]?.map (bothNames typeName leanTypeName ·.name)
  sType           := if s.kind != .extension then none else do
    -- The entry of the `s_type` enum named after the struct.
    let sTypes ← r.enums.find? (·.name.text == "s_type")
    let entries := sTypes.entries.toList.filterMap fun slot => slot
    let entry ← entries.find? (·.name.text == s.name.text)
    pure (bothNames (entryName sTypes.name) leanName entry.name)
  freeMembers     := s.freeMembers
  members         := s.members.map fun m =>
    let value := memberValue r m
    {
      names   := bothNames memberName leanName m.name
      doc     := translateDoc ctx m.doc
      value   := value
      default := (m.default.bind (lowerDefault r)).orElse fun _ =>
        implicitDefault r m value
    }

/-! ## Functions and objects -/

/--
A function, or a method of the object type `receiver`: named on both sides, with
how each of its values crosses. A method is named after its object type on both
sides: `wgpuDeviceCreateBuffer`, `Device.createBuffer`.
-/
def lowerFunction (ctx : DocContext) (r : Resolved.Spec)
    (receiver : Option Resolved.Object) (f : Resolved.Function) :
    Lowered.Function where
  names    := match receiver with
    | some o => {
      c    := methodName o.name f.name
      lean := leanTypeName o.name ++ "." ++ leanName f.name
    }
    | none   => bothNames functionName leanName f.name
  doc      := translateDoc ctx f.doc
  receiver := receiver.map fun o => bothNames typeName leanTypeName o.name
  args     := f.args.map fun a => {
    names := bothNames memberName leanName a.name
    doc   := translateDoc ctx a.doc.text
    value := argValue r a
  }
  result   := f.returns.map (resultValue r)
  callback := f.callback.isSome

/-- An object type, named on both sides, with its methods. -/
def lowerObject (ctx : DocContext) (r : Resolved.Spec) (o : Resolved.Object) :
    Lowered.Object where
  names    := bothNames typeName leanTypeName o.name
  doc      := translateDoc ctx o.doc
  release  := methodName o.name ⟨"release", by decide⟩
  shim     := "lean_wgpu_" ++ o.name.text
  extended := o.extended
  methods  := o.methods.map (lowerFunction ctx r (some o))

/-! ## The whole spec -/

/--
`f`, marked with the implementations whose stubs it is among: `stubs` gives
each implementation with the C names of the functions it leaves unimplemented
(for wgpu-native, `vendor/wgpu-native/stubs`).
-/
def markStubs (stubs : List (String × List String)) (f : Lowered.Function) :
    Lowered.Function :=
  { f with notImplementedBy := stubs.filterMap fun (impl, names) =>
      if names.contains f.names.c then some impl else none }

/--
Lower a resolved spec. `sections` are the documentation sections its docs may
refer to, each with its page (`articleSections` reads them from upstream's
articles); `stubs` are the functions each implementation leaves unimplemented
(`markStubs`).
-/
def lower (r : Resolved.Spec) (sections : List (String × String) := [])
    (stubs : List (String × List String) := []) : Lowered.Spec :=
  let ctx : DocContext := {
    leanNames := leanNamesOfC r
    sections  := Std.HashMap.ofList sections
  }
  let mark := markStubs stubs
  {
    enums     := r.enums.map (lowerEnum ctx r)
    bitflags  := r.bitflags.map (lowerBitflag ctx)
    structs   := r.structs.map (lowerStruct ctx r)
    objects   := r.objects.map fun o =>
      let lowered := lowerObject ctx r o
      { lowered with methods := lowered.methods.map mark }
    functions := r.functions.map (mark ∘ lowerFunction ctx r none)
  }

end WebGPUGen.Lowered
