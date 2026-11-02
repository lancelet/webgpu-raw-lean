/-!
# The lowered model

What the printers need for each part of the spec, decided once: its names on
both sides of the boundary between C and Lean, and the values of its enum
entries and flags. The C printer and the Lean printer both read this model and
decide nothing themselves, so the two sides agree by construction.

It holds no references: everything that varies with the spec is spelt out.
Text that never varies, such as the `_Force32` entry upstream adds to every C
enum, is the printers' own. The model grows block by block; so far it has enums,
bitflags and object types, and not yet the spec's own name, copyright and doc.
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

/-! ## Objects -/

/--
A WebGPU object type: in C a handle, in Lean an opaque type. The C side boxes a
handle as a Lean value, with a finalizer that releases it.
-/
structure Object where
  names   : Names
  doc     : String
  /-- The C function that releases a reference: `wgpuDeviceRelease`. -/
  release : String
  /-- The prefix of the shim's C names for it: `lean_wgpu_device`. -/
  shim    : String
  deriving Repr, DecidableEq

/-! ## The whole spec -/

/-- The lowered spec. -/
structure Spec where
  enums    : Array Enum
  bitflags : Array Bitflag
  objects  : Array Object
  deriving Repr, DecidableEq

end WebGPUGen.Lowered
