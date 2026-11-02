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
  A `size_t`. Lean passes it as a `UInt64`, as WebGPU's JavaScript API does, and
  the shim checks it fits: `size_t` is 32 bits on the web.
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
  | .usize             => "size_t"
  | .enum names        => names.c
  | .bitflag names     => names.c
  | .object names _    => names.c
  | .string _          => "WGPUStringView"
  | .struct names      => names.c
  | .structPointer names _ => s!"{names.c} const *"
  | .array element _   => element.cType.map (· ++ " const *")
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
  | .object .. | .string _ | .struct _ | .structPointer .. | .array .. => true
  | _                      => false

/-- The value's type in the raw `@[extern]` declaration, without `@&`. -/
def Value.rawLeanType : Value → Option String
  -- Not passed to functions yet: their shims come with descriptors.
  | .struct _ | .structPointer .. | .array .. => none
  | .enum _    => "UInt32"
  | .bitflag _ => "UInt64"
  | v          => v.leanType

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
  | .struct _ | .structPointer .. | .array .. => none
  | .unsupported _   => none

/-- What the bindings cannot pass yet, if anything. -/
def Value.unsupported? : Value → Option String
  | .unsupported what => some what
  -- An array is no more passable than its elements.
  | .array element _   => element.unsupported?
  | _                 => none

/-! ## Functions -/

/-- A function's argument: borrowed from Lean for the call. -/
structure Arg where
  names : Names
  doc   : String
  value : Value
  deriving Repr, DecidableEq

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
  Whether it takes a callback. Every such function in the spec is asynchronous,
  calling back when its operation completes; none is bound yet.
  -/
  callback : Bool
  /--
  The implementations that leave it unimplemented, aborting if it is called,
  such as `wgpu-native`: built against one, its shim raises an `IO` error
  instead.
  -/
  notImplementedBy : List String := []
  deriving Repr, DecidableEq

/--
Why the bindings cannot bind the function yet: one reason for each value they
cannot pass, and one if it takes a callback. None if they can.
-/
def Function.unsupported (f : Function) : List String :=
  (if f.callback then ["takes a callback"] else [])
    ++ f.args.toList.filterMap (·.value.unsupported?)
    ++ (f.result.bind (·.unsupported?)).toList

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
  /-- A nested struct at its own defaults (its `WGPU_X_INIT`). -/
  | nested
  /-- NULL: an optional object or struct pointer that is absent, `none`. -/
  | null
  /-- An empty array (a count of 0, NULL), or an empty string. -/
  | empty
  deriving Repr, DecidableEq

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
  deriving Repr, DecidableEq

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
  For an extension, the entry of the `SType` enum that marks it in a chain:
  `WGPUSType_ShaderSourceWGSL`, `shaderSourceWGSL`.
  -/
  sType           : Option Names
  /-- Whether C allocates its members, which `wgpuXFreeMembers` frees. -/
  freeMembers     : Bool
  members         : Array Member
  deriving Repr, DecidableEq

/--
What the bindings cannot pass yet among the struct's members: one reason for
each, and one if it is an extension with no `SType` entry to mark it. None if
they can.
-/
def Struct.unsupported (s : Struct) : List String :=
  (if s.kind == .extension && s.sType.isNone then ["no SType entry"] else [])
    ++ s.members.toList.filterMap (·.value.unsupported?)

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
  enums     : Array Enum
  bitflags  : Array Bitflag
  structs   : Array Struct
  objects   : Array Object
  /-- The functions that belong to no object type, such as `createInstance`. -/
  functions : Array Function
  deriving Repr, DecidableEq

end WebGPUGen.Lowered
