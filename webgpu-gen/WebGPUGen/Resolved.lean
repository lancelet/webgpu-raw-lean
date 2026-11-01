import WebGPUGen.Common
import WebGPUGen.CoreSchema

/-!
# The resolved spec

What the spec means, once every reference has been followed. It has the same
entries as the parsed spec (`WebGPUGen.Parsed`), in the same order, but where
the parsed spec names another entry, the resolved spec holds its ID: an index
into the matching array of `Spec`. Types that refer to nothing by name are
shared, from `WebGPUGen.Common`.

IDs have a type per kind of entry, so a struct's ID cannot be used where an
enum's is expected. Whether every ID is in range, and the spec's other rules,
are stated by `WellFormed` and established by resolution.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-! ## IDs -/

/-- A constant: an index into `Spec.constants`. -/
structure ConstantId where
  idx : Nat
  deriving Repr, DecidableEq, Hashable

/-- A typedef: an index into `Spec.typedefs`. -/
structure TypedefId where
  idx : Nat
  deriving Repr, DecidableEq, Hashable

/-- An enum: an index into `Spec.enums`. -/
structure EnumId where
  idx : Nat
  deriving Repr, DecidableEq, Hashable

/-- A bitflag type: an index into `Spec.bitflags`. -/
structure BitflagId where
  idx : Nat
  deriving Repr, DecidableEq, Hashable

/-- A struct: an index into `Spec.structs`. -/
structure StructId where
  idx : Nat
  deriving Repr, DecidableEq, Hashable

/-- A callback type: an index into `Spec.callbacks`. -/
structure CallbackId where
  idx : Nat
  deriving Repr, DecidableEq, Hashable

/-- An object type: an index into `Spec.objects`. -/
structure ObjectId where
  idx : Nat
  deriving Repr, DecidableEq, Hashable

/-- An entry of a given enum or bitflag: an index into its `entries`. For an
enum, reserved slots count, so an entry's index is its position in the spec. -/
structure EntryIndex where
  idx : Nat
  deriving Repr, DecidableEq, Hashable

/-! ## Types -/

/-- A named type a value can have. The spec's `function_type.x` has no
counterpart: nothing in the spec defines function types, so resolution rejects
it. -/
inductive Named where
  | typedef (id : TypedefId)
  | enum    (id : EnumId)
  | bitflag (id : BitflagId)
  | struct  (id : StructId)
  | object  (id : ObjectId)
  deriving Repr, DecidableEq, Hashable

/-- A `type:`, resolved. -/
inductive TypeRef where
  | primitive (p : PrimitiveType)  -- uint32, array<uint32>
  | named     (t : Named)          -- struct.foo
  | arrayOf   (t : Named)          -- array<struct.foo>
  | callback  (id : CallbackId)    -- callback.foo
  deriving Repr, DecidableEq, Hashable

/-! ## Defaults -/

/-- The entry a default names, and the enum or bitflag it belongs to. -/
inductive EntryRef where
  | enumEntry (enum : EnumId) (entry : EntryIndex)
  | flag      (bitflag : BitflagId) (entry : EntryIndex)
  deriving Repr, DecidableEq, Hashable

/-- A member's default, resolved. A `float` keeps the parsed spec's proof that
its text reads as a float, so the parsed default can be rebuilt from it. For
an `entry`, `WellFormed` says the slot holds an entry (not a reserved gap)
whose name reads as an entry name, which rebuilding the parsed default needs. -/
inductive Default where
  | bool     (b : Bool)
  | int      (n : Int)
  | float    (text : String) (valid : Yaml.Scalar.value { text } = .float text)
  | constant (id : ConstantId)
  | entry    (target : EntryRef)
  | zero
  deriving Repr, DecidableEq

/-! ## Bitflags -/

/-- How a flag's value is given. The parsed spec allows a `value` and a
`value_combination` together, and named values; upstream rejects both, so the
resolved spec cannot express them. -/
inductive FlagValue where
  | implicit                                -- by position: 0, then 1, 2, 4, …
  | explicit    (n : UInt64)                -- `value`
  | combination (flags : Array EntryIndex)  -- `value_combination`: flags of this type
  deriving Repr, DecidableEq

/-- One flag of a bitflag type, or a named combination of other flags of the
same type. -/
structure BitflagEntry where
  name  : Name
  ns    : Option Name  -- the spec's `namespace`
  doc   : String
  value : FlagValue
  deriving Repr, DecidableEq

/-- A bitflag type: a set of flags that can be combined. -/
structure Bitflag where
  name     : Name
  ns       : Option Name          -- the spec's `namespace`
  doc      : String
  extended : Bool
  entries  : Array BitflagEntry
  deriving Repr, DecidableEq

/-! ## Structs -/

/-- A struct member, function argument or return value. `Doc` is `String` for
struct members and `Paragraph` for arguments, as in the parsed spec. -/
structure Parameter (Doc : Type) where
  name                : Name
  doc                 : Doc
  type                : TypeRef
  passedWithOwnership : Option Bool     -- absent is not the same as false
  pointer             : Option Pointer
  optional            : Bool
  default             : Option Default
  deriving Repr, DecidableEq

/-- A struct. `extendedStructs` is the spec's `extends`: the structs an
extension attaches to. -/
structure Struct where
  name            : Name
  ns              : Option Name                -- the spec's `namespace`
  doc             : String
  kind            : StructKind                 -- the spec's `type`
  extendedStructs : Array StructId             -- the spec's `extends`
  freeMembers     : Bool                       -- `free_members`
  members         : Array (Parameter String)
  deriving Repr, DecidableEq

/-! ## Callbacks, functions and objects -/

/-- A callback type: the arguments it is called with. -/
structure Callback where
  name  : Name
  ns    : Option Name                    -- the spec's `namespace`
  doc   : String
  style : CallbackStyle
  args  : Array (Parameter Paragraph)
  deriving Repr, DecidableEq

/-- What a function returns. An empty doc is `none`. -/
structure Return where
  doc                 : Option Paragraph
  type                : TypeRef
  optional            : Bool
  passedWithOwnership : Option Bool     -- absent is not the same as false
  pointer             : Option Pointer
  deriving Repr, DecidableEq

/-- A function or method. `callback` is the callback type of an asynchronous
function. -/
structure Function where
  name     : Name
  ns       : Option Name                    -- the spec's `namespace`
  doc      : String
  returns  : Option Return                  -- absent means it returns nothing
  callback : Option CallbackId
  args     : Array (Parameter Paragraph)
  deriving Repr, DecidableEq

/-- An object type and its methods. -/
structure Object where
  name     : Name
  ns       : Option Name      -- the spec's `namespace`
  doc      : String
  extended : Bool
  methods  : Array Function
  deriving Repr, DecidableEq

/-! ## The whole spec -/

/-- A whole spec, resolved. Each array is in the parsed spec's order, and IDs
index into them. -/
structure Spec where
  copyright  : String
  name       : Name
  enumPrefix : Fin 32768
  doc        : String
  constants  : Array Constant
  typedefs   : Array Typedef
  enums      : Array Enum
  bitflags   : Array Bitflag
  structs    : Array Struct
  callbacks  : Array Callback
  functions  : Array Function
  objects    : Array Object
  deriving Repr, DecidableEq

end WebGPUGen.Resolved
