/-!
# The lowered model

What the printers need for each part of the spec, decided once: its names on
both sides of the boundary between C and Lean, and the values of its enum
entries and flags. The C printer and the Lean printer both read this model and
decide nothing themselves, so the two sides agree by construction.

It holds no references: everything that varies with the spec is spelt out.
Text that never varies, such as the `_Force32` entry upstream adds to every C
enum, is the printers' own. The model grows block by block; so far it has enums,
bitflags, object types, and functions and methods with how each of their values
crosses between Lean and C, and not yet structs, callbacks, or the spec's own
name, copyright and doc.
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
  | .unsupported _     => none

/-- What the bindings cannot pass yet, if anything. -/
def Value.unsupported? : Value → Option String
  | .unsupported what => some what
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
  deriving Repr, DecidableEq

/--
Why the bindings cannot bind the function yet: one reason for each value they
cannot pass, and one if it takes a callback. None if they can.
-/
def Function.unsupported (f : Function) : List String :=
  (if f.callback then ["takes a callback"] else [])
    ++ f.args.toList.filterMap (·.value.unsupported?)
    ++ (f.result.bind (·.unsupported?)).toList

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
  objects   : Array Object
  /-- The functions that belong to no object type, such as `createInstance`. -/
  functions : Array Function
  deriving Repr, DecidableEq

end WebGPUGen.Lowered
