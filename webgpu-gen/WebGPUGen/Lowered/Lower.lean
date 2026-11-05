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
  | .nullableFloat32        => .nullableFloat32
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
The value `value` makes of the names of the struct `id`, if it is in range.
-/
def structNamed (r : Resolved.Spec) (id : Id .struct) (value : Names → Value) :
    Value :=
  match r.structs[id.idx]? with
  | some s => value (bothNames typeName leanTypeName s.name)
  | none   => .unsupported "a reference out of range"

/--
How an argument crosses into C, borrowed for the call. Only the shapes the
bindings handle are passed: a primitive, enum, bitflag or object, not behind a
pointer; a struct behind an immutable one, which C only reads; or an array,
behind an immutable one, of objects (none optional) or of `uint32`s; a
nullable float is not passed yet. An object or a struct can be optional:
NULL in C. An argument with ownership stated is an output struct whose
members the caller must free, which is not handled yet.
-/
def argValue (r : Resolved.Spec) (p : Parameter Paragraph) : Value :=
  let unsupported := Value.unsupported (describe p.type p.pointer)
  if p.passedWithOwnership.isSome then unsupported else
  match p.pointer, p.type with
  | some .immutable, .named (.struct id) =>
    structNamed r id (.structPointer · p.optional)
  -- An array of objects, or of `uint32`s, as C's count and pointer.
  | some .immutable, .arrayOf (.object id) =>
    if p.optional then unsupported
    else named r (.object id) fun names => .array (.object names false) count
  | some .immutable, .primitive (.array .uint32) =>
    if p.optional then unsupported else .array .uint32 count
  | some _, _ => unsupported
  | none, _ =>
  match p.type with
  | .primitive (.scalar s) =>
    match scalarValue p.type s with
    | .nullableFloat32 => unsupported
    | v => if p.optional then unsupported else v
  | .named (.enum id) =>
    if p.optional then unsupported else named r (.enum id) .enum
  | .named (.bitflag id) =>
    if p.optional then unsupported else named r (.bitflag id) .bitflag
  | .named (.object id) => named r (.object id) (.object · p.optional)
  | _ => unsupported
where
  count := arrayCountName p.name

/--
How a result crosses back into Lean. An object is passed only if the spec says
it comes with its own reference (`passed_with_ownership`), which the Lean value
takes; a string or nullable float is not passed yet. Optional means it can be
NULL: `none` in Lean.
-/
def resultValue (r : Resolved.Spec) (ret : Return) : Value :=
  let unsupported := Value.unsupported (describe ret.type ret.pointer)
  if ret.pointer.isSome then unsupported else
  match ret.type with
  | .primitive (.scalar s) =>
    match scalarValue ret.type s with
    | .string _ | .nullableFloat32 => unsupported
    | v =>
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
  -- A future by value (`getLostFuture`'s): its ID, as a callback's future.
  | .named (.struct id) =>
    if ret.optional || ret.passedWithOwnership.isSome then unsupported
    else match r.structs[id.idx]? with
      | some s => if s.name.text == "future" then .future else unsupported
      | none   => .unsupported "a reference out of range"
  | _ => unsupported

/-! ## Constants -/

/-- A constant, named on both sides, with its value by kind. -/
def lowerConstant (ctx : DocContext) (c : Common.Constant) :
    Lowered.Constant where
  names := bothNames constantName leanName c.name
  doc   := translateDoc ctx c.doc
  value := match c.value with
    | .int n     => .uint64 n
    | .usizeMax  => .sizeMax
    | .uint32Max => .uint32 0xFFFFFFFF
    | .uint64Max => .uint64 0xFFFFFFFFFFFFFFFF
    | .nan       => .nan

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

/-! ## Callbacks -/

/--
How a callback's argument crosses into Lean, as a result does: an enum by its
code, a string copied (`out_string`, which C passes for the call only), and an
object C gives its reference to (`passed_with_ownership`), which the Lean
value takes, as an `Option` whatever the spec says, as C may pass NULL. An
object C lends, behind a pointer, without its reference, is not passed to
Lean (`Value.lentObject`): it may be gone, as a device a buffer outlives. A
struct is not passed yet.
-/
def callbackArgValue (r : Resolved.Spec) (p : Parameter Paragraph) : Value :=
  let unsupported := Value.unsupported (describe p.type p.pointer)
  match p.pointer, p.type, p.passedWithOwnership with
  | some .immutable, .named (.object id), some false =>
    if p.optional then unsupported else named r (.object id) .lentObject
  | _, _, _ =>
  if p.pointer.isSome || p.optional then unsupported else
  match p.type with
  | .named (.enum id)   => named r (.enum id) .enum
  | .primitive (.scalar .outString) =>
    if p.passedWithOwnership == some true then unsupported else .string false
  | .named (.object id) =>
    if p.passedWithOwnership == some true then
      named r (.object id) (.object · true)
    else unsupported
  | _ => unsupported

/--
Every object a callback passes Lean is an `Option`: so a callback C passes
NULL is never given a Lean value of nothing.
-/
theorem nullable_of_callbackArgValue {r : Resolved.Spec}
    {p : Parameter Paragraph} {names : Names} {nullable : Bool}
    (h : callbackArgValue r p = .object names nullable) : nullable = true := by
  unfold callbackArgValue named at h
  -- An object C lends, never an object; then each case of the type, then of
  -- ownership and the lookup in range.
  split at h
  · repeat (first | split at h | simp_all)
  · split at h
    · simp at h
    · split at h <;> (try split at h) <;> (try split at h) <;> simp_all

/--
A callback type, named on both sides, with how each of its arguments
crosses.
-/
def lowerCallback (ctx : DocContext) (r : Resolved.Spec)
    (c : Resolved.Callback) : Lowered.Callback where
  names := bothNames callbackTypeName leanCallbackTypeName c.name
  doc   := translateDoc ctx c.doc
  style := c.style
  args  := c.args.map fun a => {
    names := bothNames memberName leanName a.name
    doc   := translateDoc ctx a.doc.text
    value := callbackArgValue r a
  }

/-- The callback `id` names, lowered, if it is in range. -/
def callbackNamed (ctx : DocContext) (r : Resolved.Spec) (id : Id .callback) :
    Option Lowered.Callback :=
  r.callbacks[id.idx]?.map (lowerCallback ctx r)

/--
The callbacks the structs keep, as members of callback type, each once, in the
order the structs first keep them: a callback's ordinal, where its family
holds its closure, is its place among them.
-/
def keptCallbacks (r : Resolved.Spec) : List (Id .callback) :=
  (r.structs.toList.flatMap fun s => s.members.toList.filterMap fun m =>
    match m.type with
    | .callback id => some id
    | _            => none).eraseDups

/--
How many closures a family holds, each at an ordinal below it: the bindings'
`Reloc.closures` and C's `LEAN_WGPU_FAMILY_CLOSURES`, which a test of theirs
checks agree; the test driver checks the spec's callbacks fit.
-/
def familyClosures : Nat := 4

/--
A struct member of the callback type `id`: its info, with a mode if it is
registered with one, if the bindings can pass each of its arguments and a
family has a place for its closure (`familyClosures`).
-/
def keptValue (r : Resolved.Spec) (id : Id .callback) : Value :=
  match r.callbacks[id.idx]? with
  | none   => .unsupported "a reference out of range"
  | some c =>
    let ordinal := (keptCallbacks r).idxOf id
    if c.args.any (fun a => (callbackArgValue r a).unsupported?.isSome) then
      .unsupported "callback (an argument it cannot pass)"
    else if ordinal ≥ familyClosures then
      .unsupported "callback (no place in its family)"
    else .callbackInfo (bothNames callbackTypeName leanCallbackTypeName c.name)
      (c.style == .callbackMode) ordinal

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
    if p.optional then unsupported else structNamed r id .struct
  | none, .callback id =>
    if p.optional then unsupported else keptValue r id
  | some .immutable, .named (.struct id) =>
    structNamed r id (.structPointer · p.optional)
  | some .immutable, .arrayOf (.enum id) =>
    if p.optional then unsupported
    else named r (.enum id) fun names => .array (.enum names) count
  | some .immutable, .arrayOf (.struct id) =>
    if p.optional then unsupported
    else structNamed r id fun names => .array (.struct names) count
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
an enum with no `undefined` entry (C would set a code no entry has), an
object or pointer that is not optional (C would set NULL), or a nullable float:
the spec gives each one a default, so none is guessed.
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
  | .nullableFloat32 | .bytes | .future | .lentObject _ => none
  -- A callback's info: none, C's empty info.
  | .callbackInfo ..            => some .null
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
  extensions      := r.structs.filterMap fun e =>
    if e.extendedStructs.any (r.structs[·.idx]?.map (·.name) == some s.name)
    then some (bothNames typeName leanTypeName e.name) else none
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
      default := match value, m.default with
        -- C holds NaN for none, so a NaN constant is `none` in Lean.
        | .nullableFloat32, some (.constant id) =>
          match r.constants[id.idx]? with
          | some { value := .nan, .. } => some .null
          | _ => lowerDefault r (.constant id)
        | _, _ => (m.default.bind (lowerDefault r)).orElse fun _ =>
          implicitDefault r m value
    }

/-! ## Functions and objects -/

/--
Whether `p` and `q` are bytes an argument passes: a `c_void` behind an
immutable pointer, then their size, a `usize` named as one (`size`,
`data_size`).
-/
def isBytes (p q : Parameter Paragraph) : Bool :=
  p.type == .primitive (.scalar .cVoid) && p.pointer == some .immutable
    && !p.optional && p.passedWithOwnership.isNone
    && q.type == .primitive (.scalar .usize) && q.pointer.isNone
    && !q.optional && q.passedWithOwnership.isNone
    && q.name.text.endsWith "size"

/--
A function's arguments, each as `argValue` says, but for bytes and their
size, which are one, `Value.bytes`, named as the bytes.
-/
def lowerArgs (ctx : DocContext) (r : Resolved.Spec) :
    List (Parameter Paragraph) → List Arg
  | p :: q :: rest =>
    if isBytes p q then arg p .bytes :: lowerArgs ctx r rest
    else arg p (argValue r p) :: lowerArgs ctx r (q :: rest)
  | [p] => [arg p (argValue r p)]
  | []  => []
where
  arg (p : Parameter Paragraph) (value : Value) : Arg := {
    names := bothNames memberName leanName p.name
    doc   := translateDoc ctx p.doc.text
    value := value
  }

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
  args     := (lowerArgs ctx r f.args.toList).toArray
  -- A function that takes a callback returns a future, which the spec leaves
  -- implicit (the test driver checks `webgpu.h` declares it so).
  result   := match f.callback with
    | some id =>
      if (callbackNamed ctx r id).isSome then some .future
      else some (.unsupported "a reference out of range")
    | none    => f.returns.map (resultValue r)
  callback := f.callback.bind (callbackNamed ctx r)

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

/-! ## Struct defaults that refer to other structs -/

/--
The value each member of the struct named `names` has when all its bytes are
zero (a `zero` default): for an enum or bitflag type its entry whose code is
0, for a number 0, `false`, an empty string or array, `none` for what is
optional, and a nested struct's own zero values. None if a member has no such
value, as an enum with no entry for 0, or an object that is not optional.
`fuel` bounds the nesting: structs do not contain themselves.
-/
def zeroFields (spec : Lowered.Spec) (names : Names) :
    Nat → Option (List (Names × Lowered.Default))
  | 0 => none
  | fuel + 1 => do
    let s ← spec.structs.find? (·.names.c == names.c)
    s.members.toList.mapM fun m => do
      let value ← zeroOf fuel m.value
      pure (m.names, value)
where
  zeroOf (fuel : Nat) : Value → Option Lowered.Default
    | .bool => some (.bool false)
    | .uint16 | .uint32 | .uint64 | .int16 | .int32 | .usize => some (.int 0)
    | .float32 | .float64 | .nullableFloat32 => some (.float "0.0")
    -- A nullable string is the null string view, not the empty string.
    | .string true => some .null
    | .string false | .array .. => some .empty
    | .object _ true | .structPointer _ true => some .null
    | .enum type => do
      let e ← spec.enums.find? (·.names.c == type.c)
      let entry ← e.entries.find? (·.value == 0)
      pure (.entry type entry.names)
    | .bitflag type => do
      let b ← spec.bitflags.find? (·.names.c == type.c)
      let flag ← b.flags.find? (·.value == 0)
      pure (.entry type flag.names)
    | .struct nested => (zeroFields spec nested fuel).map (.fields nested)
    | _ => none

/--
Whether a struct needs nothing given: each member has a default, and each
nested at its own defaults needs nothing given either. `fuel` bounds the
nesting.
-/
def complete (spec : Lowered.Spec) (names : Names) : Nat → Bool
  | 0 => false
  | fuel + 1 =>
    match spec.structs.find? (·.names.c == names.c) with
    | none => false
    | some s => s.members.all fun m =>
      match m.default, m.value with
      | some .nested, .struct nested => complete spec nested fuel
      | some _, _ => true
      | none, _ => false

/-- `spec` with `f` applied to each struct's members. -/
def mapMembers (f : Member → Member) (spec : Lowered.Spec) : Lowered.Spec :=
  { spec with structs := spec.structs.map fun s =>
      { s with members := s.members.map f } }

/--
A member with a `zero` default, given its field values (`fields`), or with no
default if they cannot all be zero.
-/
def settleZero (spec : Lowered.Spec) (m : Member) : Member :=
  match m.default, m.value with
  | some .zero, .struct nested =>
    let fields := zeroFields spec nested (spec.structs.size + 1)
    { m with default := fields.map (.fields nested) }
  | _, _ => m

/--
A member with a `nested` default, which stands only if the nested struct needs
nothing given; with no default otherwise.
-/
def settleNested (spec : Lowered.Spec) (m : Member) : Member :=
  match m.default, m.value with
  | some .nested, .struct nested =>
    if complete spec nested (spec.structs.size + 1) then m
    else { m with default := none }
  | _, _ => m

/--
Settle the defaults that refer to other structs, once all are lowered: first a
`zero` default becomes its field values (`fields`); then a `nested` one stands
only if the nested struct, so settled, needs nothing given. Where either cannot
be, the member has no default, and must be given.
-/
def settleStructDefaults (spec : Lowered.Spec) : Lowered.Spec :=
  let zeros := mapMembers (settleZero spec) spec
  mapMembers (settleNested zeros) zeros

/--
Each struct's extensions, only those the bindings can bind, as structs of
their own (`boundStructs`, ignoring every chain): a struct chains only those,
so one that cannot be passed yet, or refers to a struct that cannot, does not
keep its base from being bound.
-/
def keepPassableExtensions (spec : Lowered.Spec) : Lowered.Spec :=
  let bound := boundStructs
    (spec.structs.toList.map fun s => { s with extensions := #[] })
  { spec with structs := spec.structs.map fun s =>
      { s with extensions := s.extensions.filter fun n =>
          bound.any (·.names == n) } }

/--
Each function's arguments whose struct must be given a chain
(`Struct.chainRequired`), and each method's: a struct passed by pointer, not
optional.
-/
def markRequiredChains (spec : Lowered.Spec) : Lowered.Spec :=
  let structs := spec.structs.toList
  let mark (f : Lowered.Function) : Lowered.Function :=
    { f with requiredChains := f.args.toList.filterMap fun a =>
        match a.value with
        | .structPointer names false =>
          if structs.any fun s =>
              s.names == names && s.chainRequired structs
          then some a.names.lean else none
        | _ => none }
  { spec with
    functions := spec.functions.map mark
    objects   := spec.objects.map fun o =>
      { o with methods := o.methods.map mark } }

/-- It leaves the structs as they are. -/
theorem structs_markRequiredChains (spec : Lowered.Spec) :
    (markRequiredChains spec).structs = spec.structs :=
  rfl

/--
Each function's callbacks the structs it takes keep (`HeldInfo`), each a
member of one: so its shim makes the family that holds them. Only members of
the structs themselves; the test driver checks the spec keeps none deeper.
-/
def markHeldInfos (spec : Lowered.Spec) : Lowered.Spec :=
  let structs := spec.structs.toList
  let mark (f : Lowered.Function) : Lowered.Function :=
    { f with heldInfos := f.args.toList.flatMap fun a => match a.value with
        | .structPointer names _ =>
          ((structs.find? (·.names == names)).map fun s =>
            s.members.toList.filterMap fun m => match m.value with
              -- With a mode as its callback is registered with one, which its
              -- trampoline, too, decides by.
              | .callbackInfo names _ k =>
                let hasMode := spec.callbacks.any fun c =>
                  c.names == names && c.style == .callbackMode
                some ⟨a.names.c, m.names.c, hasMode, k⟩
              | _ => none).getD []
        | _ => [] }
  { spec with
    functions := spec.functions.map mark
    objects   := spec.objects.map fun o =>
      { o with methods := o.methods.map mark } }

/-- It leaves the structs as they are. -/
theorem structs_markHeldInfos (spec : Lowered.Spec) :
    (markHeldInfos spec).structs = spec.structs :=
  rfl

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
  settleStructDefaults <| markHeldInfos <| markRequiredChains
    <| keepPassableExtensions {
    callbacks := r.callbacks.map (lowerCallback ctx r)
    constants := r.constants.map (lowerConstant ctx)
    enums     := r.enums.map (lowerEnum ctx r)
    bitflags  := r.bitflags.map (lowerBitflag ctx)
    structs   := r.structs.map (lowerStruct ctx r)
    objects   := r.objects.map fun o =>
      let lowered := lowerObject ctx r o
      { lowered with methods := lowered.methods.map mark }
    functions := r.functions.map (mark ∘ lowerFunction ctx r none)
  }

end WebGPUGen.Lowered
