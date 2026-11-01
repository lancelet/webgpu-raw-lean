import WebGPUGen.CoreSchema
import WebGPUGen.Text

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

/-- Does `s` match `^[a-zA-Z0-9]([a-zA-Z0-9_]*[a-zA-Z0-9])?$`: ASCII letters, digits
and underscores, not starting or ending with an underscore? -/
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

/-- Does `doc` match `^\n?.+(\n.+)*\n?$`: one or more non-empty lines, with at
most one line break before and after? The schema requires this of argument and
return docs, which Doxygen cannot show as several paragraphs. -/
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
  deriving Repr, DecidableEq

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
  deriving Repr, DecidableEq

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
  deriving Repr, DecidableEq

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

/-- A `type:` field, parsed. -/
inductive TypeRef where
  | primitive (p : PrimitiveType)            -- uint32, array<uint32>
  | ref       (kind : RefKind) (name : Name) -- struct.foo
  | refArray  (kind : RefKind) (name : Name) -- array<struct.foo>
  | callback  (name : Name)                  -- callback.foo
  deriving Repr, DecidableEq

/-- A primitive type as the spec writes it, e.g. `uint32` or `array<uint32>`. -/
def PrimitiveType.render : PrimitiveType → String
  | .scalar p => spellingOf Primitive.spellings p
  | .array e => "array<" ++ spellingOf ArrayElement.spellings e ++ ">"

/-- A type as the spec writes it, e.g. `array<struct.limits>`. The encoder writes
this, and the decoder parses it back. -/
def TypeRef.render : TypeRef → String
  | .primitive p => p.render
  | .ref kind name => spellingOf RefKind.spellings kind ++ "." ++ name.text
  | .refArray kind name => "array<" ++ spellingOf RefKind.spellings kind ++ "." ++ name.text ++ ">"
  | .callback name => "callback." ++ name.text

/-! ## Values -/

/-- A constant's value (`Value64`): a 64-bit unsigned integer, or one of the
named values the C header defines. -/
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

/-- What a string default says, before its name is checked. Shared by the
decoder and by `Default.entry`'s invariant. -/
inductive DefaultText where
  | zero
  | constant (rest : String)  -- the text after `constant.`
  | int      (n : Int)        -- a quoted number, such as "0xFFFFFFFF"
  | entry
  deriving Repr, DecidableEq

/-- Classify a string default: `zero`, `constant.x`, a number, or an entry name. -/
def defaultText (s : String) : DefaultText :=
  if s = "zero" then .zero
  else match Text.stripPrefix? "constant.".toList s.toList with
    | some rest => .constant (String.ofList rest)
    | none => match Yaml.parseInt? s with
      | some n => .int n
      | none => .entry

/-- A member's default, used by the C `INIT` macros. In the spec it is a string,
number or boolean; the strings name a constant (`constant.x`), an enum or
bitflag entry (`none`, `all`), or `zero` for zero-initialising a struct. A
quoted number such as `"0xFFFFFFFF"` is an integer: it is quoted only so YAML
reads it as written.

The proofs keep the model honest: a `float` is text YAML reads as a float, and
an `entry` is a name not read as anything else (not `zero`, say, or `123`).

The decoder does not check a default against its member's type (an `.entry` on
a `uint32`, say); that belongs to the later resolution step. -/
inductive Default where
  | bool     (b : Bool)
  | int      (n : Int)
  | float    (text : String) (valid : Yaml.Scalar.value { text } = .float text)
  | constant (name : Name)
  | entry    (name : Name) (valid : defaultText name.text = .entry)
  | zero
  deriving Repr, DecidableEq

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

/-! ## Enums and bitflags -/

/-- One named value of an enum.

Left to resolution, as upstream's generator does: an entry with a `namespace`
must have an explicit `value`. -/
structure EnumEntry where
  name  : Name
  ns    : Option Name  -- the spec's `namespace`
  doc   : String
  value : Option UInt16  -- overrides the default (the entry's index)
  deriving Repr, DecidableEq

/-- An enum. `extended` marks entries added to an enum defined elsewhere, as an
extension file does. -/
structure Enum where
  name     : Name
  ns       : Option Name                -- the spec's `namespace`
  doc      : String
  extended : Bool                       -- absent means false
  entries  : Array (Option EnumEntry)   -- `none` reserves a slot; absent means empty
  deriving Repr, DecidableEq

/-- One flag of a bitflag type, or a named combination of other flags.

Left to resolution, as upstream's generator does: `value` and `combination`
may not both be given, and a `value` must be an integer, not a named value. -/
structure BitflagEntry where
  name        : Name
  ns          : Option Name          -- the spec's `namespace`
  doc         : String
  value       : Option Value64       -- an explicit value
  combination : Option (Array Name)  -- `value_combination`: entries OR-ed together
  deriving Repr, DecidableEq

/-- A bitflag type: a set of flags that can be combined. -/
structure Bitflag where
  name     : Name
  ns       : Option Name          -- the spec's `namespace`
  doc      : String
  extended : Bool                 -- absent means false
  entries  : Array BitflagEntry   -- absent means empty
  deriving Repr, DecidableEq

/-! ## Structs -/

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

/-- A struct member, function argument or return value (`ParameterType` in the
schema).

Left to resolution, as upstream's generator does: struct members may not set
`passed_with_ownership`, and a pointer may not have a default.

`Doc` is the type of its doc: `String` for struct members, `Paragraph` for
function and callback arguments (`FunctionParameterType`), whose docs must be
a single paragraph. -/
structure Parameter (Doc : Type) where
  name                : Name
  doc                 : Doc
  type                : TypeRef
  passedWithOwnership : Option Bool     -- absent is not the same as false
  pointer             : Option Pointer
  optional            : Bool            -- absent means false
  default             : Option Default
  deriving Repr, DecidableEq

/-- A struct. `extendedStructs` is the spec's `extends`: the structs an
extension attaches to. The schema allows any string there; every use is a
struct name, so the decoder requires one. -/
structure Struct where
  name            : Name
  ns              : Option Name       -- the spec's `namespace`
  doc             : String
  kind            : StructKind        -- the spec's `type`
  extendedStructs : Array Name        -- the spec's `extends`; absent means empty
  freeMembers     : Bool              -- `free_members`; absent means false
  members         : Array (Parameter String)  -- absent means empty
  deriving Repr, DecidableEq

/-! ## Callbacks, functions and objects -/

/-- How a callback is delivered. -/
inductive CallbackStyle where
  | callbackMode  -- registered with a mode saying when it may be called
  | immediate     -- called before the function that takes it returns
  deriving Repr, DecidableEq

def CallbackStyle.spellings : List (String × CallbackStyle) := [
  ("callback_mode", .callbackMode),
  ("immediate",     .immediate)
]

/-- A callback type: the arguments it is called with. -/
structure Callback where
  name  : Name
  ns    : Option Name       -- the spec's `namespace`
  doc   : String
  style : CallbackStyle
  args  : Array (Parameter Paragraph)  -- absent means empty
  deriving Repr, DecidableEq

/-- What a function returns. Its doc may be empty (written `""`), which is `none`
here; otherwise it is a single paragraph. -/
structure Return where
  doc                 : Option Paragraph
  type                : TypeRef
  optional            : Bool            -- absent means false
  passedWithOwnership : Option Bool     -- absent is not the same as false
  pointer             : Option Pointer
  deriving Repr, DecidableEq

/-- A function or method. `callback` names the callback type of an asynchronous
function (the spec writes `callback.name`).

An asynchronous function implicitly returns a future and takes the callback's
info struct as a final argument; the spec states neither, so neither is here.
Upstream's generator adds both when writing C. -/
structure Function where
  name     : Name
  ns       : Option Name       -- the spec's `namespace`
  doc      : String
  returns  : Option Return     -- absent means it returns nothing
  callback : Option Name
  args     : Array (Parameter Paragraph)  -- absent means empty
  deriving Repr, DecidableEq

/-- An object type and its methods. -/
structure Object where
  name     : Name
  ns       : Option Name      -- the spec's `namespace`
  doc      : String
  extended : Bool             -- absent means false
  methods  : Array Function   -- absent means empty
  deriving Repr, DecidableEq

/-! ## The whole spec -/

/-- A whole spec file, such as `webgpu.yml` or an extension file. -/
structure Spec where
  copyright  : String
  name       : Name
  enumPrefix : Fin 32768        -- `enum_prefix`: a block of enum values, < 0x8000
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

end WebGPUGen.Spec
