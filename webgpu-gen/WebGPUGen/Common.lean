/-!
# Common types

Types used by both the parsed spec (`WebGPUGen.Parsed`, what the YAML says) and
the resolved spec (what it means). None of them refers to another entry by name:
names and docs, the type vocabulary, values, constants, typedefs, enums, and the
small enumerations used by structs and callbacks. Some still have rules that
resolution checks (an enum's entry values, for example).

Names are kept as the spec writes them (snake_case); turning them into C or
Lean names is the code generator's job.
-/

namespace WebGPUGen.Common

/--
Does `s` match `^[a-zA-Z0-9]([a-zA-Z0-9_]*[a-zA-Z0-9])?$`: ASCII letters, digits
and underscores, not starting or ending with an underscore?
-/
def isName (s : String) : Bool :=
  let cs := s.toList
  !cs.isEmpty
    && cs.all (fun c => c.isAlphanum || c == '_')
    && cs.head? != some '_'
    && cs.getLast? != some '_'

/-- A spec name (`Name` in `schema.json`), with proof that it is one. -/
structure Name where
  text  : String
  valid : isName text = true
  deriving Repr, DecidableEq, Hashable

instance : Inhabited Name := ⟨⟨"a", by decide⟩⟩

instance : ToString Name := ⟨Name.text⟩

/--
Does `doc` match `^\n?.+(\n.+)*\n?$`: one or more non-empty lines, with at most
one line break before and after? The schema requires this of argument and return
docs, which Doxygen cannot show as several paragraphs.
-/
def isSingleParagraph (doc : String) : Bool :=
  let cs := doc.toList
  let cs := match cs with
    | '\n' :: rest => rest
    | _ => cs
  let cs := if cs.getLast? = some '\n' then cs.dropLast else cs
  !cs.isEmpty && (cs.splitOn '\n').all (!·.isEmpty)

/-- A single-paragraph doc, with proof that it is one. -/
structure Paragraph where
  text  : String
  valid : isSingleParagraph text = true
  deriving Repr, DecidableEq

/-- The spelling of `x` in a spelling table. -/
def spellingOf {α} [BEq α] (table : List (String × α)) (x : α) : String :=
  ((table.find? (·.2 == x)).map (·.1)).getD "?"

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
  deriving Repr, DecidableEq, Hashable

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

/--
An element type allowed in a primitive array, `array<…>`. This is its own
list: it includes `string`, which is not a primitive on its own.
-/
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
  deriving Repr, DecidableEq, Hashable

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
  deriving Repr, DecidableEq, Hashable

/-- The kinds of named type a reference can point at. -/
inductive RefKind where
  | typedef
  | enum
  | bitflag
  | struct
  | functionType
  | object
  deriving Repr, DecidableEq

/-- Each reference kind and the prefix it is written with. -/
def RefKind.spellings : List (String × RefKind) := [
  ("typedef",       .typedef),
  ("enum",          .enum),
  ("bitflag",       .bitflag),
  ("struct",        .struct),
  ("function_type", .functionType),
  ("object",        .object)
]

/-- A primitive type as the spec writes it, e.g. `uint32` or `array<uint32>`. -/
def PrimitiveType.render : PrimitiveType → String
  | .scalar p => spellingOf Primitive.spellings p
  | .array e => "array<" ++ spellingOf ArrayElement.spellings e ++ ">"

/-! ## Values -/

/--
A constant's value (`Value64`): a 64-bit unsigned integer, or one of the named
values the C header defines.
-/
inductive Value64 where
  | int (n : UInt64)
  | usizeMax
  | uint32Max
  | uint64Max
  | nan
  deriving Repr, DecidableEq

/-- The named constant values and their spellings. -/
def Value64.spellings : List (String × Value64) := [
  ("usize_max",  .usizeMax),
  ("uint32_max", .uint32Max),
  ("uint64_max", .uint64Max),
  ("nan",        .nan)
]

/-! ## Entries -/

/-- A named constant, e.g. `whole_size`. -/
structure Constant where
  name  : Name
  ns    : Option Name  -- the spec's `namespace`
  value : Value64
  doc   : String
  deriving Repr, DecidableEq

/-- An alias of a primitive type. -/
structure Typedef where
  name : Name
  ns   : Option Name  -- the spec's `namespace`
  doc  : String
  type : PrimitiveType
  deriving Repr, DecidableEq

/-! ## Enums -/

/--
One named value of an enum.

Left to resolution, as upstream's generator does: an entry with a `namespace`
must have an explicit `value`.
-/
structure EnumEntry where
  name  : Name
  ns    : Option Name  -- the spec's `namespace`
  doc   : String
  value : Option UInt16  -- overrides the default (the entry's index)
  deriving Repr, DecidableEq

/--
An enum. `extended` marks entries added to an enum defined elsewhere, as an
extension file does.
-/
structure Enum where
  name     : Name
  ns       : Option Name                -- the spec's `namespace`
  doc      : String
  extended : Bool                       -- absent means false
  entries  : Array (Option EnumEntry)   -- `none` reserves a slot; absent means empty
  deriving Repr, DecidableEq

/-! ## Structs and callbacks -/

/-- Whether a pointer may be written through. -/
inductive Pointer where
  | immutable
  | mutable
  deriving Repr, DecidableEq

def Pointer.spellings : List (String × Pointer) := [
  ("immutable", .immutable),
  ("mutable",   .mutable)
]

/-- How a struct takes part in chaining (the spec's struct `type`). -/
inductive StructKind where
  | extensible             -- starts with a chain pointer; extensions attach to it
  | extensibleCallbackArg  -- the same, for structs passed to callbacks
  | extension              -- attaches to the chain of the structs it `extends`
  | standalone             -- takes no part in chaining
  deriving Repr, DecidableEq

def StructKind.spellings : List (String × StructKind) := [
  ("extensible",              .extensible),
  ("extensible_callback_arg", .extensibleCallbackArg),
  ("extension",               .extension),
  ("standalone",              .standalone)
]

/-- How a callback is delivered. -/
inductive CallbackStyle where
  | callbackMode  -- registered with a mode saying when it may be called
  | immediate     -- called before the function that takes it returns
  deriving Repr, DecidableEq

def CallbackStyle.spellings : List (String × CallbackStyle) := [
  ("callback_mode", .callbackMode),
  ("immediate",     .immediate)
]

end WebGPUGen.Common
