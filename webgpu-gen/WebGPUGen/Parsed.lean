import WebGPUGen.Common
import WebGPUGen.CoreSchema
import WebGPUGen.Text

/-!
# The parsed spec

What `webgpu.yml` says, as Lean data: the entries that refer to other entries,
with those references still written as names. Each kind of entry in
`schema.json` has a type here (or in `WebGPUGen.Common`, if it refers to
nothing), and strings that encode structure (such as `array<struct.foo>`) are
parsed into it.

The model records the spec only. Whether references resolve, such as
`struct.foo` naming a real struct, is checked by a later step,
resolution.
-/

namespace WebGPUGen.Parsed
open WebGPUGen.Common

/-! ## Types -/

/-- A `type:` field, parsed. -/
inductive TypeRef where
  | primitive (p : PrimitiveType)            -- uint32, array<uint32>
  | ref       (kind : RefKind) (name : Name) -- struct.foo
  | refArray  (kind : RefKind) (name : Name) -- array<struct.foo>
  | callback  (name : Name)                  -- callback.foo
  deriving Repr, DecidableEq

/-- A type as the spec writes it, e.g. `array<struct.limits>`. The encoder writes
this, and the decoder parses it back. -/
def TypeRef.render : TypeRef → String
  | .primitive p => p.render
  | .ref kind name => spellingOf RefKind.spellings kind ++ "." ++ name.text
  | .refArray kind name => "array<" ++ spellingOf RefKind.spellings kind ++ "." ++ name.text ++ ">"
  | .callback name => "callback." ++ name.text

/-! ## Defaults -/

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

/-! ## Bitflags -/

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

end WebGPUGen.Parsed
