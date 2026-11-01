/-!
# The spec model

What `webgpu.yml` says, as Lean data. Each kind of entry in `schema.json` has a
type here, and strings that encode structure (such as `array<struct.foo>`) are
parsed into it. Names are kept as the spec writes them (snake_case); turning
them into C or Lean names is the code generator's job.

The model records the spec only. Whether references resolve, such as
`struct.foo` naming a real struct, is checked by a later step.
-/

namespace WebGPUGen.Spec

/-- A spec name: ASCII letters, digits and underscores, not starting or ending
with an underscore (`Name` in `schema.json`). The decoder checks this. -/
structure Name where
  text : String
  deriving Repr, BEq, Hashable, Inhabited

instance : ToString Name := ⟨Name.text⟩

/-! ## Types -/

/-- A primitive (non-array) type. -/
inductive Primitive where
  | cVoid
  | bool
  | nullableString
  | stringWithDefaultEmpty
  | outString
  | uint16
  | uint32
  | uint64
  | usize
  | int16
  | int32
  | float32
  | nullableFloat32
  | float64
  | float64Supertype
  deriving Repr, BEq, Inhabited

/-- Each primitive and its spelling in the spec. -/
def Primitive.spellings : List (String × Primitive) := [
  ("c_void",                    .cVoid),
  ("bool",                      .bool),
  ("nullable_string",           .nullableString),
  ("string_with_default_empty", .stringWithDefaultEmpty),
  ("out_string",                .outString),
  ("uint16",                    .uint16),
  ("uint32",                    .uint32),
  ("uint64",                    .uint64),
  ("usize",                     .usize),
  ("int16",                     .int16),
  ("int32",                     .int32),
  ("float32",                   .float32),
  ("nullable_float32",          .nullableFloat32),
  ("float64",                   .float64),
  ("float64_supertype",         .float64Supertype)
]

/-- An element type allowed in a primitive array, `array<…>`. This is its own
list: it includes `string`, which is not a primitive on its own. -/
inductive ArrayElement where
  | bool
  | string
  | uint16
  | uint32
  | uint64
  | usize
  | int16
  | int32
  | float32
  | float64
  deriving Repr, BEq, Inhabited

/-- Each array element type and its spelling in the spec. -/
def ArrayElement.spellings : List (String × ArrayElement) := [
  ("bool",    .bool),
  ("string",  .string),
  ("uint16",  .uint16),
  ("uint32",  .uint32),
  ("uint64",  .uint64),
  ("usize",   .usize),
  ("int16",   .int16),
  ("int32",   .int32),
  ("float32", .float32),
  ("float64", .float64)
]

/-- `PrimitiveType` in `schema.json`: a primitive or an array of primitives. -/
inductive PrimitiveType where
  | scalar (p : Primitive)     -- uint32
  | array  (e : ArrayElement)  -- array<uint32>
  deriving Repr, BEq, Inhabited

/-- The kinds of named type a reference can point at. -/
inductive RefKind where
  | typedef
  | enum
  | bitflag
  | struct
  | functionType
  | object
  deriving Repr, BEq, Inhabited

/-- Each reference kind and the prefix it is written with. -/
def RefKind.spellings : List (String × RefKind) := [
  ("typedef",       .typedef),
  ("enum",          .enum),
  ("bitflag",       .bitflag),
  ("struct",        .struct),
  ("function_type", .functionType),
  ("object",        .object)
]

/-- A `type:` field, parsed. -/
inductive TypeRef where
  | primitive (p : PrimitiveType)            -- uint32, array<uint32>
  | ref       (kind : RefKind) (name : Name) -- struct.foo
  | refArray  (kind : RefKind) (name : Name) -- array<struct.foo>
  | callback  (name : Name)                  -- callback.foo
  deriving Repr, BEq, Inhabited

/-! ## Values -/

/-- A constant's value (`Value64`): a 64-bit unsigned integer, or one of the
named values the C header defines. -/
inductive Value64 where
  | int (n : Nat)
  | usizeMax
  | uint32Max
  | uint64Max
  | nan
  deriving Repr, BEq, Inhabited

/-- The named constant values and their spellings. -/
def Value64.spellings : List (String × Value64) := [
  ("usize_max",  .usizeMax),
  ("uint32_max", .uint32Max),
  ("uint64_max", .uint64Max),
  ("nan",        .nan)
]

/-- A member's default, used by the C `INIT` macros. In the spec it is a string,
number or boolean; the strings name a constant (`constant.x`), an enum or
bitflag entry (`none`, `all`), or `zero` for zero-initialising a struct. A
quoted number such as `"0xFFFFFFFF"` is an integer: it is quoted only so YAML
reads it as written.

The decoder does not check a default against its member's type (an `.entry` on
a `uint32`, say); that belongs to the later resolution step. -/
inductive Default where
  | bool     (b : Bool)
  | int      (n : Int)
  | float    (text : String)  -- kept as written, e.g. 32.0
  | constant (name : Name)    -- constant.whole_size
  | entry    (name : Name)    -- none, auto, all
  | zero
  deriving Repr, BEq, Inhabited

/-! ## Entries -/

/-- A named constant, e.g. `whole_size`. -/
structure Constant where
  name  : Name
  ns    : Option Name  -- the spec's `namespace`
  value : Value64
  doc   : String
  deriving Repr, BEq, Inhabited

/-- An alias of a primitive type. -/
structure Typedef where
  name : Name
  ns   : Option Name  -- the spec's `namespace`
  doc  : String
  type : PrimitiveType
  deriving Repr, BEq, Inhabited

/-! ## Enums and bitflags -/

/-- One named value of an enum.

Left to resolution, as upstream's generator does: an entry with a `namespace`
must have an explicit `value`. -/
structure EnumEntry where
  name  : Name
  ns    : Option Name  -- the spec's `namespace`
  doc   : String
  value : Option Nat   -- overrides the default (the entry's index); < 2^16
  deriving Repr, BEq, Inhabited

/-- An enum. `extended` marks entries added to an enum defined elsewhere, as an
extension file does. -/
structure Enum where
  name     : Name
  ns       : Option Name                -- the spec's `namespace`
  doc      : String
  extended : Bool                       -- absent means false
  entries  : Array (Option EnumEntry)   -- `none` reserves a slot; absent means empty
  deriving Repr, BEq, Inhabited

/-- One flag of a bitflag type, or a named combination of other flags.

Left to resolution, as upstream's generator does: `value` and `combination`
may not both be given, and a `value` must be an integer, not a named value. -/
structure BitflagEntry where
  name        : Name
  ns          : Option Name          -- the spec's `namespace`
  doc         : String
  value       : Option Value64       -- an explicit value
  combination : Option (Array Name)  -- `value_combination`: entries OR-ed together
  deriving Repr, BEq, Inhabited

/-- A bitflag type: a set of flags that can be combined. -/
structure Bitflag where
  name     : Name
  ns       : Option Name          -- the spec's `namespace`
  doc      : String
  extended : Bool                 -- absent means false
  entries  : Array BitflagEntry   -- absent means empty
  deriving Repr, BEq, Inhabited

end WebGPUGen.Spec
