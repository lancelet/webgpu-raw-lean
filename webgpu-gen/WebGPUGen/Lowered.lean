import WebGPUGen.Common

/-!
# The lowered model

What the printers need for each part of the spec, decided once: its names on
both sides of the boundary between C and Lean, and the values of its enum
entries and flags. The C printer and the Lean printer both read this model and
decide nothing themselves, so the two sides agree by construction.

It holds no references: everything that varies with the spec is spelt out.
Text that never varies, such as the `_Force32` entry upstream adds to every C
enum, is the printers' own. The model grows block by block; so far it has enums,
bitflags, structs (each member with its default), object types, and functions
and methods, with how each of their values crosses between Lean and C; not yet
callbacks, or the spec's own name, copyright and doc.
-/

namespace WebGPUGen.Lowered

/-- A name on both sides: in `webgpu.h`, and in the Lean bindings. -/
structure Names where
  c    : String
  lean : String
  deriving Repr, DecidableEq

/-! ## Enums -/

/-- An enum entry and its value. -/
structure EnumEntry where
  names : Names
  doc   : String
  value : UInt32
  deriving Repr, DecidableEq

/--
An enum. Reserved slots are left out: they only shift the values of the entries
after them, and the values are already worked out.
-/
structure Enum where
  names    : Names
  doc      : String
  extended : Bool  -- adds entries to an enum another spec defines
  entries  : Array EnumEntry
  deriving Repr, DecidableEq

/-! ## Bitflags -/

/-- A flag, or a named combination of flags, and its value. -/
structure Flag where
  names : Names
  doc   : String
  value : UInt64
  deriving Repr, DecidableEq

/-- A bitflag type. -/
structure Bitflag where
  names    : Names
  doc      : String
  extended : Bool  -- adds flags to a bitflag type another spec defines
  flags    : Array Flag
  deriving Repr, DecidableEq

/-! ## Values -/

/--
How a value crosses between Lean and C: what it is on each side, and so how the
shim converts it. Whose reference an object is depends on which way it crosses:
an argument's object is borrowed for the call, and a result's object is owned,
its reference taken by the Lean value.

What the bindings cannot pass yet is `unsupported`, saying what it is, so that
nothing is guessed: a function with such a value is not bound.
-/
inductive Value where
  | bool
  | uint16
  | uint32
  | uint64
  | int16
  | int32
  | float32
  | float64
  /--
  A `float` that C holds as NaN for none (upstream's `nullable_float32`): in
  Lean, an `Option Float32`.
  -/
  | nullableFloat32
  /--
  A `size_t`. Lean passes it as a `UInt64`, as WebGPU's JavaScript API does, and
  the shim checks it fits (`size_t` is 32 bits on the web), except that the
  largest `UInt64` stands for `SIZE_MAX`, both ways.
  -/
  | usize
  | enum    (names : Names)
  | bitflag (names : Names)
  /-- A handle to an object; `none` in Lean is a NULL handle in C. -/
  | object  (names : Names) (nullable : Bool)
  /-- A string, as a `WGPUStringView`; `none` in Lean is the null view. -/
  | string  (nullable : Bool)
  /-- A struct, by value: in Lean, a structure. -/
  | struct  (names : Names)
  /-- A struct behind a pointer; `none` in Lean is a NULL pointer. -/
  | structPointer (names : Names) (nullable : Bool)
  /--
  An array: in C, a count (`size_t`, named `count`, as `arrayCountName` names
  it) and a pointer to the elements; in Lean, an `Array`.
  -/
  | array   (element : Value) (count : String)
  /--
  A future, which a function that takes a callback returns: in C a
  `WGPUFuture`, the struct holding its ID; in Lean the `Future` structure.
  (`getLostFuture`'s, a result of struct type, is not one yet.)
  -/
  | future
  /--
  A callback C keeps, in a struct: its info, in Lean an `Option` of the
  callback type's info structure (with its mode, if `hasMode`); in C, the
  callback type's info, whose closure the family being filled holds at
  `ordinal` (`c/family.c`), for its trampoline to run.
  -/
  | callbackInfo (names : Names) (hasMode : Bool) (ordinal : Nat)
  /--
  An object C lends a callback behind a pointer, without its reference: not
  passed to Lean, as it may be gone by then (a device a buffer outlives).
  -/
  | lentObject (names : Names)
  | unsupported (what : String)
  deriving Repr, DecidableEq

/--
The value's type in Lean; none if the bindings cannot pass it, so that a
printer cannot print one by mistake.
-/
def Value.leanType : Value → Option String
  | .bool              => "Bool"
  | .uint16            => "UInt16"
  | .uint32            => "UInt32"
  | .uint64            => "UInt64"
  | .int16             => "Int16"
  | .int32             => "Int32"
  | .float32           => "Float32"
  | .float64           => "Float"
  | .nullableFloat32   => "Option Float32"
  | .usize             => "UInt64"
  | .enum names        => names.lean
  | .bitflag names     => names.lean
  | .object names b    => if b then s!"Option {names.lean}" else names.lean
  | .string b          => if b then "Option String" else "String"
  | .struct names      => names.lean
  | .structPointer names b =>
    if b then s!"Option {names.lean}" else names.lean
  | .array element _   => element.leanType.map fun t =>
    if t.contains ' ' then s!"Array ({t})" else s!"Array {t}"
  | .future            => "Future"
  | .callbackInfo names .. => s!"Option {names.lean}Info"
  | .lentObject _      => none
  | .unsupported _     => none

/--
The value's type in Lean as a result, where C gives it to Lean. An enum can hold
a code the bindings do not know, from an implementation's own extensions or a
newer `webgpu.h`, so its code is kept: `.error code`. An object that is not
nullable must not be NULL; the shim stops the program if it is, rather than
make a Lean value of nothing. A `WGPUBool` is true when it is not 0.
-/
def Value.resultLeanType : Value → Option String
  | .enum names => s!"Except UInt32 {names.lean}"
  | v           => v.leanType

/-- The value's type in C; none if the bindings cannot pass it. -/
def Value.cType : Value → Option String
  | .bool              => "WGPUBool"
  | .uint16            => "uint16_t"
  | .uint32            => "uint32_t"
  | .uint64            => "uint64_t"
  | .int16             => "int16_t"
  | .int32             => "int32_t"
  | .float32           => "float"
  | .float64           => "double"
  | .nullableFloat32   => "float"
  | .usize             => "size_t"
  | .enum names        => names.c
  | .bitflag names     => names.c
  | .object names _    => names.c
  | .string _          => "WGPUStringView"
  | .struct names      => names.c
  | .structPointer names _ => s!"{names.c} const *"
  | .array element _   => element.cType.map (· ++ " const *")
  | .future            => "WGPUFuture"
  | .callbackInfo names .. => names.c ++ "Info"
  | .lentObject names  => s!"{names.c} const *"
  | .unsupported _     => none

/-! ### Across the boundary

Each function is bound by a shim in C and a raw `@[extern]` declaration in
Lean, whose types must agree as Lean's ABI says (`docs/Safety.md`). The two are
defined here, side by side, so they cannot drift apart. An enum crosses as its
code and a bitflag type as its bits: Lean converts them, so the shims never
depend on how Lean represents its types.
-/

/--
Whether the value crosses as a Lean object (`lean_object *`): borrowed (`@&`)
as an argument, and owned as a result.
-/
def Value.isObject : Value → Bool
  | .object .. | .string _ | .nullableFloat32 | .struct _ | .structPointer ..
  | .array ..   => true
  | _           => false

/-- The value's type in the raw `@[extern]` declaration, without `@&`. -/
def Value.rawLeanType : Value → Option String
  -- Not passed to functions yet: their shims come with descriptors. A
  -- callback's info is only ever in a struct.
  | .nullableFloat32 | .struct _ | .structPointer .. | .array ..
  | .callbackInfo .. => none
  | .enum _    => "UInt32"
  | .bitflag _ => "UInt64"
  -- A future as its ID, which the function makes a `Future` of.
  | .future    => "UInt64"
  | v          => v.leanType

/--
A callback's argument's type in the raw declaration's closure, as its
trampoline boxes it: an enum as its code, an object as an `Option`, a string
copied. None if a callback cannot pass it.
-/
def Value.callbackRawType : Value → Option String
  | .enum _            => "UInt32"
  | .object names true => s!"Option {names.lean}"
  | .string false      => "String"
  | _                  => none

/--
The C type a shim takes the value as, matching `rawLeanType` by Lean's ABI. (A
result is boxed into the `IO` result instead.)
-/
def Value.abiCType : Value → Option String
  | .bool            => "uint8_t"
  | .uint16          => "uint16_t"
  | .uint32          => "uint32_t"
  | .uint64          => "uint64_t"
  | .int16           => "uint16_t"
  | .int32           => "uint32_t"
  | .float32         => "float"
  | .float64         => "double"
  | .usize           => "uint64_t"
  | .enum _          => "uint32_t"
  | .bitflag _       => "uint64_t"
  | .object ..       => "b_lean_obj_arg"
  | .string _        => "b_lean_obj_arg"
  | .nullableFloat32 | .struct _ | .structPointer .. | .array .. | .future
  | .callbackInfo .. | .lentObject _ => none
  | .unsupported _   => none

/-- What the bindings cannot pass yet, if anything. -/
def Value.unsupported? : Value → Option String
  | .unsupported what => some what
  -- An array is no more passable than its elements.
  | .array element _   => element.unsupported?
  | _                 => none

/-! ## Arguments -/

/--
A function's argument, borrowed from Lean for the call; or a callback's,
passed to Lean.
-/
structure Arg where
  names : Names
  doc   : String
  value : Value
  deriving Repr, DecidableEq

/-! ## Callbacks -/

/--
A callback type: the arguments C calls it with, each crossing into Lean as a
result does (`Value.resultLeanType`): an enum keeps a code the bindings do not
know, and an object C gives its reference to is an `Option`, as C may pass
NULL even where the spec does not say so. Its `style` says when it may be
called. Its arguments are `Arg`s, but cross the other way: C gives each to
Lean, as it gives a function's result.
-/
structure Callback where
  names : Names
  doc   : String
  style : Common.CallbackStyle
  args  : Array Arg
  deriving Repr, DecidableEq

/--
What the bindings cannot pass yet among the callback's arguments: one reason
for each, naming it. None if they can.
-/
def Callback.unsupported (c : Callback) : List String :=
  c.args.toList.filterMap fun a =>
    a.value.unsupported?.map (s!"callback {a.names.lean}: " ++ ·)

/--
The arguments a callback passes Lean: all but the objects C lends it
(`Value.lentObject`), which may be gone.
-/
def Callback.passed (c : Callback) : List Arg :=
  c.args.toList.filter fun a => !(a.value matches .lentObject _)

/-! ## Functions -/

/--
A function, or a method of an object type, which takes its object as a first
argument before the others, borrowed like them.
-/
structure Function where
  names    : Names
  doc      : String
  /-- The object type a method belongs to. -/
  receiver : Option Names
  args     : Array Arg
  /-- What it returns, owned by Lean; `none` if it returns nothing. -/
  result   : Option Value
  /--
  The callback it takes, if any. Every such function in the spec is
  asynchronous, calling back when its operation completes, and returns a
  future (`Value.future`).
  -/
  callback : Option Callback
  /--
  The implementations that leave it unimplemented, aborting if it is called,
  such as `wgpu-native`: built against one, its shim raises an `IO` error
  instead.
  -/
  notImplementedBy : List String := []
  /--
  The arguments, by their Lean names, whose struct must be given a chain
  (`Struct.chainRequired`): its function refuses one with none.
  -/
  requiredChains   : List String := []
  deriving Repr, DecidableEq

/--
Why the bindings cannot bind the function yet: one reason for each value they
cannot pass, its callback's arguments among them. None if they can.
-/
def Function.unsupported (f : Function) : List String :=
  (f.callback.map (·.unsupported)).getD []
    ++ f.args.toList.filterMap (·.value.unsupported?)
    ++ (f.result.bind (·.unsupported?)).toList

/-! ## Constants -/

/-- A constant's value, by its kind, which also gives its type. -/
inductive ConstantValue where
  /-- A `uint32_t`: `UINT32_MAX` is `0xFFFFFFFF`. -/
  | uint32 (n : UInt32)
  /-- A `uint64_t`. -/
  | uint64 (n : UInt64)
  /--
  `SIZE_MAX`, which is 32 bits on the web and 64 natively. In Lean, a `size_t`
  is a `UInt64`, so this is its largest value, which stands for `SIZE_MAX`
  wherever the bindings pass a `size_t`.
  -/
  | sizeMax
  /-- A float that is not a number. -/
  | nan
  deriving Repr, DecidableEq

/-- A constant: in C a macro, in Lean a definition. -/
structure Constant where
  names : Names
  doc   : String
  value : ConstantValue
  deriving Repr, DecidableEq

/-! ## Structs -/

/--
A member's default: the value C's `WGPU_X_INIT` initialiser gives it, from the
spec's `default` or else from upstream's rules for a member without one, with
what it names on both sides.
-/
inductive Default where
  | bool     (b : Bool)
  | int      (n : Int)
  /-- A floating-point number, as the spec writes it: `0.0`, `32.0`. -/
  | float    (text : String)
  /-- A constant: `WGPU_WHOLE_SIZE`, `wholeSize`. -/
  | constant (names : Names)
  /--
  An entry of the enum or bitflag type `type`: `WGPUBlendFactor_One`, `one`.
  -/
  | entry    (type entry : Names)
  /--
  A nested struct with every byte zero (upstream's `_wgpu_STRUCT_ZERO_INIT`),
  not at its own defaults: so an enum in it has the code 0, as when a
  bind group layout's unused slot has the type `BindingNotUsed` rather than
  `Undefined`.
  -/
  | zero
  /--
  The nested struct `struct` with the fields given, each at its value: what
  lowering makes of `zero`, the field values that are all-zero bytes, so that a
  printer can write them out, as `T.zero`.
  -/
  | fields (struct : Names) (values : List (Names × Default))
  /-- A nested struct at its own defaults (its `WGPU_X_INIT`). -/
  | nested
  /-- NULL: an optional object or struct pointer that is absent, `none`. -/
  | null
  /-- An empty array (a count of 0, NULL), or an empty string. -/
  | empty
  deriving Repr, BEq

/--
The zero values a default is or holds, however deep: each `fields`, with its
struct and its field values, outermost first.
-/
def Default.zeroValues : Default → List (Names × List (Names × Default))
  | .fields struct values => (struct, values) :: inner values
  | _ => []
where
  /-- The zero values of each field value. -/
  inner : List (Names × Default) → List (Names × List (Names × Default))
    | [] => []
    | (_, d) :: rest => d.zeroValues ++ inner rest

/--
The zero value `z`, a struct with its field values, is or is held by a default,
however deep: what a printer must declare a `T.zero` for.
-/
inductive Default.Within (z : Names × List (Names × Default)) : Default → Prop
  | here : Default.Within z (.fields z.1 z.2)
  | field {struct : Names} {values : List (Names × Default)} {field : Names}
      {d : Default} :
      (field, d) ∈ values → Default.Within z d →
        Default.Within z (.fields struct values)

/-- A struct member: how its value crosses, and its default. -/
structure Member where
  names   : Names
  doc     : String
  value   : Value
  /--
  None if the member has no valid default, so must be given: as when C's
  initialiser would set an enum to a code no entry has, or an object that is
  not optional to NULL.
  -/
  default : Option Default
  deriving Repr, BEq

/--
A struct. `kind` says how it takes part in chaining: an `extensible` struct
starts with a chain pointer, to which `extension` structs (those whose
`extendedStructs` name it) attach.
-/
structure Struct where
  names           : Names
  doc             : String
  kind            : Common.StructKind
  /-- The structs an extension attaches to: the spec's `extends`. -/
  extendedStructs : Array Names
  /--
  The structs that attach to it, if it is extensible: those whose `extends`
  name it, which its `chain` holds.
  -/
  extensions      : Array Names := #[]
  /--
  For an extension, the entry of the `SType` enum that marks it in a chain:
  `WGPUSType_ShaderSourceWGSL`, `shaderSourceWGSL`.
  -/
  sType           : Option Names
  /-- Whether C allocates its members, which `wgpuXFreeMembers` frees. -/
  freeMembers     : Bool
  members         : Array Member
  deriving Repr, BEq

/--
What the bindings cannot pass yet among the struct's members: one reason for
each, and one if it is an extension with no `SType` entry to mark it. None if
they can.
-/
def Struct.unsupported (s : Struct) : List String :=
  (if s.kind == .extension && s.sType.isNone then ["no SType entry"] else [])
    ++ s.members.toList.filterMap (·.value.unsupported?)

/--
Whether a struct describes nothing but by its chain: extensible, with no
member but its label, and extended by others, as a shader module descriptor
is by its sources. Passed without a chain it is of no use, and an
implementation may abort (wgpu-native does).
-/
def Struct.chainRequired (structs : List Struct) (s : Struct) : Bool :=
  s.kind == .extensible
    && s.members.all (·.names.lean == "label")
    && structs.any (·.extendedStructs.contains s.names)

/--
Whether a struct describes nothing but by a chain it cannot have: one that
requires a chain (`chainRequired`), but whose extensions the bindings cannot
pass, as a surface descriptor's are surface sources, which hold OS handles.
-/
def Struct.needsChain (structs : List Struct) (s : Struct) : Bool :=
  s.chainRequired structs && s.extensions.isEmpty

/--
The struct a value names, if any: by value, by pointer, or as the elements of
an array, however nested, as `leanType` names it.
-/
def Value.structRef? : Value → Option Names
  | .struct names | .structPointer names _ => some names
  | .array element _ => element.structRef?
  | _ => none

/-- The structs a struct's members refer to. -/
def Struct.references (s : Struct) : List Names :=
  s.members.toList.filterMap (·.value.structRef?) ++ s.extensions.toList

/--
The structs the bindings can bind, in an order in which each comes after the
structs it refers to: those whose members can all be passed, and whose
referred structs, matched by both their names, can be bound too. `fuel` bounds
the passes over the structs; structs do not refer to themselves.
-/
def boundStructs (structs : List Struct) : List Struct :=
  go structs.length [] (structs.filter (·.unsupported.isEmpty))
where
  /-- Bound so far (`done`, in order), and those still waiting (`rest`). -/
  go : Nat → List Struct → List Struct → List Struct
    | 0, done, _ => done
    | fuel + 1, done, rest =>
      let ready := rest.filter fun s =>
        s.references.all fun r => done.any (·.names == r)
      if ready.isEmpty then done
      else go fuel (done ++ ready) (rest.filter fun s => !ready.contains s)

/-! ## Objects -/

/--
A WebGPU object type: in C a handle, in Lean an opaque type. The C side boxes a
handle as a Lean value, with a finalizer that releases it.
-/
structure Object where
  names    : Names
  doc      : String
  /-- The C function that releases a reference: `wgpuDeviceRelease`. -/
  release  : String
  /-- The prefix of the shim's C names for it: `lean_wgpu_device`. -/
  shim     : String
  /-- Whether it adds methods to an object type another spec defines. -/
  extended : Bool
  methods  : Array Function
  deriving Repr, DecidableEq

/-! ## The whole spec -/

/-- The lowered spec. -/
structure Spec where
  constants : Array Constant
  enums     : Array Enum
  bitflags  : Array Bitflag
  structs   : Array Struct
  objects   : Array Object
  /-- The functions that belong to no object type, such as `createInstance`. -/
  functions : Array Function
  /--
  The callback types structs keep (`Value.callbackInfo`), for their
  trampolines and types, which no function's callback may give.
  -/
  callbacks : Array Callback := #[]
  deriving Repr, BEq

/--
The structs' C names are distinct: what finding a struct by its C name needs,
as the printers do. The generator checks it of the spec it prints.
-/
def Spec.structNamesDistinct (spec : Spec) : Prop :=
  (spec.structs.toList.map (·.names.c)).Nodup

instance (spec : Spec) : Decidable spec.structNamesDistinct :=
  List.nodupDecidable _

/-- The C names two or more structs share, for a message when they do. -/
def Spec.sharedStructNames (spec : Spec) : List String :=
  let names := spec.structs.toList.map (·.names.c)
  (names.filter (names.count · > 1)).eraseDups

end WebGPUGen.Lowered
