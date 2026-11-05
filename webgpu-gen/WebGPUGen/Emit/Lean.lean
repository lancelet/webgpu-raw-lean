import WebGPUGen.Lowered
import WebGPUGen.Lowered.CNames
import WebGPUGen.Emit.Pretty
import WebGPUGen.Emit.C.Functions

/-!
# The Lean printer

Writes the lowered model as Lean source for the bindings package. It decides
nothing: every name and value comes from the model, and the printer only lays
them out, as `Doc`s, with `Layout`'s columns, doc comments and banner.

Enums are declared with `c_enum` (`WebGPU.Raw.Internal.CEnum`), which the
generated module imports privately so the command never reaches users of the
bindings. Bitflag types are structures around a `UInt64`, with a constant per
flag. Object types are declared with `c_object`. Each bound function is a raw
`@[extern]` declaration its C shim implements, and the function itself, which
converts its values and calls it.

An enum or bitflag type that extends another spec's (`extended`) is not printed
yet: the output says so in its place. The core spec has none.
-/

namespace WebGPUGen.Emit.Lean
open WebGPUGen.Lowered WebGPUGen.Emit Doc

/-! ## Numbers -/

/--
`n` in hex with `digits` digits, upper case, as `webgpu.h` writes codes: `hex 8
1` is `0x00000001`.
-/
def hex (digits : Nat) (n : Nat) : String :=
  let ds := (Nat.toDigits 16 n).map Char.toUpper
  "0x" ++ String.ofList (List.replicate (digits - ds.length) '0' ++ ds)

/-! ## Declarations -/

/--
`doc` as a doc comment for a line indented `indent` spaces, then a new line:
nothing for a placeholder. It ends in a hard line, so a group around it never
fits: put it before a group (`docBefore i doc ++ group d`), not inside one.
-/
def docBefore (indent : Nat) (doc : String) : Doc :=
  match docLines indent doc with
  | []    => nil
  | lines => Doc.lines lines ++ hardline

/--
Rows laid out in aligned columns, each preceded by its doc comment, for lines
indented `indent` spaces.
-/
def documentedRows (indent : Nat) (rows : List (String × List String)) : Doc :=
  let laidOut := columns (rows.map (·.2))
  join hardline ((rows.zip laidOut).map fun ((doc, _), row) =>
    docBefore indent doc ++ text row)

/--
`d` on the lines after, indented `n` spaces. Make `d` with `n` too, where it
wraps text to fit the indented lines.
-/
def indented (n : Nat) (d : Doc) : Doc :=
  nest n (hardline ++ d)

/-- What stands in for a type that extends another spec's: not printed yet. -/
def notPrinted (name what : String) : Doc :=
  text s!"-- Not printed yet: {name} adds to {what} another spec defines."

/-- An enum, as a `c_enum` declaration with each value's code. -/
def enumDecl (e : Lowered.Enum) : Doc :=
  if e.extended then notPrinted e.names.lean "an enum" else
  let rows := e.entries.toList.map fun entry =>
    (entry.doc, ["|", entry.names.lean, "=", hex 8 entry.value.toNat])
  let indent := 2
  docBefore 0 e.doc ++ text s!"c_enum {e.names.lean} where"
    ++ if rows.isEmpty then nil
       else indented indent (documentedRows indent rows)

/--
A bitflag type, as a structure around its bits with a constant per flag,
and `|||` and `&&&` to combine and mask them.
-/
def bitflagDecl (b : Lowered.Bitflag) : Doc :=
  let type := b.names.lean
  if b.extended then notPrinted type "a bitflag type" else
  let header := Doc.lines [
    s!"structure {type} where",
    "  bits : UInt64",
    "  deriving Repr, DecidableEq, Inhabited"
  ]
  let flags := b.flags.toList.map fun flag =>
    let value := s!"⟨{hex 16 flag.value.toNat}⟩"
    (flag.doc, ["def", flag.names.lean, ":", type, ":=", value])
  let instances := table [
    ["instance :", s!"OrOp {type}", ":= ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩"],
    ["instance :", s!"AndOp {type}", ":= ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩"]
  ]
  let blocks :=
    [header, text s!"namespace {type}"]
      ++ (if flags.isEmpty then [] else [documentedRows 0 flags])
      ++ [instances, text s!"end {type}"]
  docBefore 0 b.doc ++ join (hardline ++ hardline) blocks

/-! ## Signatures -/

/-- An explicit parameter: its name and its type. -/
structure Binder where
  name : String
  type : String

/-- A declaration's head: its keyword, its name, its parameters and its type. -/
structure Signature where
  keyword : String
  name    : String
  binders : List Binder
  result  : String

/--
A signature on one line if it fits, counting the text before and after it on
that line, and otherwise broken: each parameter on a line of its own, their `:`
aligned, and the result type on the line after the last, all indented four
spaces.

    opaque Device.createBuffer
        (device     : @& Device)
        (descriptor : @& BufferDescriptor) :
        IO Buffer

The result type on a line of its own, after a `:` ending the line before, is
how Lean's style guides move it; the parameters, one per line and aligned, are
this project's layout (Lean's guides fill them several to a line). A parameter
or result type is never broken itself, so a very long one makes its line longer
than the width.
-/
def signature (s : Signature) : Doc :=
  let head := s.keyword ++ " " ++ s.name
  let params := s.binders.map fun b => s!" ({b.name} : {b.type})"
  let flat := text (head ++ String.join params ++ " : " ++ s.result)
  let cells := s.binders.map fun b => ["(" ++ b.name, ": " ++ b.type ++ ")"]
  let rows := columns cells
  let broken := match rows.getLast? with
    | none      => text (head ++ " :") ++ indented 4 (text s.result)
    | some last =>
      text head
        ++ indented 4 (Doc.lines (rows.dropLast ++ [last ++ " :"]) ++ hardline
          ++ text s.result)
  alt flat broken

/-! ## Constants -/

/--
`doc` with the paragraph `note` added, before any link definitions at its end
(`[name]: url`), which stay last.
-/
def addParagraph (doc note : String) : String :=
  if note.isEmpty then doc else if doc.isEmpty then note else
  let lines := doc.splitOn "\n"
  let isLink (line : String) :=
    line.startsWith "[" && (line.splitOn "]: ").length == 2
  let prose := lines.takeWhile (!isLink ·)
  let links := lines.dropWhile (!isLink ·)
  let prose := (("\n".intercalate prose).dropEndWhile (· == '\n')).toString
  if links.isEmpty then prose ++ "\n\n" ++ note
  else prose ++ "\n\n" ++ note ++ "\n\n" ++ "\n".intercalate links

/--
The constants, as definitions aligned in columns, each with its doc, a blank
line between each two. A `SIZE_MAX` is the largest `UInt64`, and its doc says
what it stands for.
-/
def constantsDecl (constants : List Lowered.Constant) : Doc :=
  let rows := constants.map fun c =>
    let (type, value, note) := match c.value with
      | .uint32 n => ("UInt32", hex 8 n.toNat, "")
      | .uint64 n => ("UInt64", hex 16 n.toNat, "")
      | .sizeMax  => ("UInt64", hex 16 0xFFFFFFFFFFFFFFFF, sizeMaxNote)
      | .nan      => ("Float32", "0.0 / 0.0", "")
    (addParagraph c.doc note, ["def", c.names.lean, ":", type, ":=", value])
  let laidOut := columns (rows.map (·.2))
  join (hardline ++ hardline) ((rows.zip laidOut).map fun ((doc, _), row) =>
    docBefore 0 doc ++ text row)
where
  sizeMaxNote :=
    "`SIZE_MAX`: the largest `UInt64`, which the bindings pass as the " ++
    "largest `size_t` on every platform (32 bits on the web)."

/-! ## Objects -/

/-- An object type, as a `c_object` declaration. -/
def objectDecl (o : Lowered.Object) : Doc :=
  docBefore 0 o.doc ++ text s!"c_object {o.names.lean}"

/--
The bindings' start-up: registers the object types' classes on the C side,
before a program's `main` runs. `builtin_initialize`, unlike `initialize`, does
not run when the compiler imports the module, where there is no C code to call.
-/
def objectsStartup : Doc := Doc.lines [
  "namespace Internal",
  "",
  "/-- Register the object types' classes, so the C side can box handles. -/",
  s!"@[extern \"{objectsInitName}\"]",
  "private opaque startObjects : IO Unit",
  "",
  "builtin_initialize startObjects",
  "",
  "end Internal"
]

/-! ## Functions

Each bound function is two declarations: the raw `@[extern]` its shim
implements, under `Internal`, and the function itself, which converts what
needs converting and calls it. Every function is in `IO`, since every call
reaches the GPU or its driver.

    @[extern "lean_wgpuAdapterHasFeature"]
    opaque Internal.Adapter.hasFeature (self : @& Adapter) (feature : UInt32) :
        IO Bool

    @[inline]
    def Adapter.hasFeature (self : Adapter) (feature : FeatureName) : IO Bool :=
      Internal.Adapter.hasFeature self (CEnum.toC feature)
-/

/-! ### Callbacks

A function that takes a callback takes its mode, if it is registered with one,
and a Lean closure, which C runs as the callback (`c/callback.c`), given each
argument as C passes it:

    abbrev QueueWorkDoneCallback :=
      Except UInt32 QueueWorkDoneStatus → String → IO Unit

The raw declaration's closure, of the type `Internal.QueueWorkDoneCallback`,
takes an enum as its code, which the function decodes; the closure is
borrowed, and the shim takes its own reference.
-/

/-- "A", or "An" before a vowel. -/
def article (word : String) : String :=
  if "AEIOUaeiou".contains (word.front) then "An" else "A"

/-- `xs` as English lists them: `a`, `a and b`, `a, b and c`. -/
def listing : List String → String
  | []      => ""
  | [x]     => x
  | [x, y]  => s!"{x} and {y}"
  | x :: xs => s!"{x}, {listing xs}"

/--
A callback type, as an `abbrev` of the closure's type; under `Internal`, the
type of the closure its raw declaration takes, which takes an enum as its
code; and the conversion of one to the other, `Internal.X.raw`, decoding each
enum. Each is of the arguments the callback passes Lean (`Callback.passed`).
Its doc says what the closure is given, if the spec's says nothing, as each
says `TODO`, and whether C may call it again (`held`).
-/
def callbackDecl (c : Lowered.Callback) (held : Bool := false) : Option Doc :=
  do
  let types ← c.passed.mapM (·.value.resultLeanType)
  let rawTypes ← c.passed.mapM (·.value.callbackRawType)
  let given := listing (c.passed.map (s!"`{·.names.lean}`"))
  let runs := if held then "C runs as a callback, perhaps more than once,"
    else "C runs once, as a callback,"
  let doc := if !(docLines 0 c.doc).isEmpty then c.doc else
    s!"A closure {runs} given {given}."
  let alias (name : String) (types : List String) : Doc :=
    text s!"abbrev {name} :=" ++ indented 2 (group (nest 2
      (join (text " →" ++ space) ((types ++ ["IO Unit"]).map text))))
  let xs := c.passed.map (·.names.lean)
  let given := c.passed.map fun a => match a.value with
    | .enum _ => s!"(CEnum.decode {a.names.lean})"
    | _       => a.names.lean
  let raw := if c.passed.any (·.value matches .enum _)
    then group (text s!"fun {" ".intercalate xs} =>"
      ++ nest 2 (space ++ text s!"f {" ".intercalate given}"))
    else text "f"
  let name := c.names.lean
  pure <| docBefore 0 doc ++ alias name types ++ hardline ++ hardline
    ++ text s!"/-- {article name} `{name}`, as its raw declaration takes it. -/"
    ++ hardline ++ alias s!"Internal.{name}" rawTypes ++ hardline ++ hardline
    ++ text s!"/-- `f`, as its raw declaration takes it: each enum decoded. -/"
    ++ hardline ++ text "@[inline]" ++ hardline
    -- The public type in full: in `Internal.X.raw`, `X` names `Internal.X`.
    ++ group (nest 4 (text s!"def Internal.{name}.raw" ++ space
      ++ text s!"(f : WebGPU.Raw.{name}) :" ++ space
      ++ text s!"Internal.{name} :="))
    ++ indented 2 raw

/--
What a struct keeps of a callback of type `c` (`Value.callbackInfo`): its info,
a structure of the closure and, if `hasMode`, the mode it is registered with,
`allowSpontaneous` unless given, as the web needs; and what the encoder writes
of it (`KeptCallback`): its mode's code, its closure, as the `Closure` its
family holds, and the address C calls, its trampoline's, or, for none, 0 or
the bindings' own handler's (`Emit.C.defaultHandled`).
-/
def callbackInfoDecl (c : Lowered.Callback) (hasMode : Bool) : Doc :=
  let name := c.names.lean
  let info := name ++ "Info"
  let defaulted := Emit.C.defaultHandled.contains c.names.c
  let fields := (if hasMode then
      [("The mode it is registered with.",
        ["mode", ":", "CallbackMode", ":=", ".allowSpontaneous"])]
    else []) ++ [("The closure.", ["callback", ":", name])]
  -- `kw lhs : type`, broken after the colon if it does not fit.
  let typed (kw lhs type : String) : Doc :=
    group (nest 4 (text s!"{kw} {lhs} :" ++ space ++ text type))
  let decl (doc : String) (attr : Option String) (body : Doc) : Doc :=
    docBefore 0 doc
      ++ (match attr with | some a => text a ++ hardline | none => nil)
      ++ body
  join (hardline ++ hardline) ([
    docBefore 0 s!"{article name} `{name}` C keeps, in a struct."
      ++ text s!"structure {info} where"
      ++ indented 2 (documentedRows 2 fields),
    decl s!"An `Internal.{name}`, as the `Closure` its family holds."
      (some "@[extern c inline \"#1\"]")
      (typed "opaque" s!"Internal.{name}.toClosure"
        s!"Internal.{name} → Closure"),
    decl s!"The address of the trampoline of `{name}`, for C to call."
      (some s!"@[extern \"{Emit.C.addressName c}\"]")
      (typed "opaque" s!"Internal.{name}.address" "Unit → UInt64")
  ] ++ (if defaulted then [
    decl s!"The address of the bindings' own handler, for no `{name}`: 0 \
      where there is none."
      (some s!"@[extern \"lean_{c.names.c}_default_address\"]")
      (typed "opaque" s!"Internal.{name}.defaultAddress" "Unit → UInt64")
  ] else []) ++ [
    decl s!"What the encoder writes of {article info |>.toLower} `{info}`." none
      (text s!"instance : KeptCallback {info} where"
        ++ indented 2 (Doc.lines [
          if hasMode then "mode i      := CEnum.toC i.mode"
            else "mode _      := 0",
          s!"closure i   := Internal.{name}.toClosure",
          s!"  (Internal.{name}.raw i.callback)",
          s!"address     := Internal.{name}.address ()",
          "noneAddress := " ++ if defaulted
            then s!"Internal.{name}.defaultAddress ()" else "0"]))
  ])

/--
The raw declaration's parameters for `f`'s callback, as its shim takes them
(`Emit.C.callbackParams`): its mode's code, if it is registered with one, and
its closure, borrowed, taking each argument as the trampoline boxes it. None
if one cannot be.
-/
def callbackBinders (f : Lowered.Function) : Option (List Binder) :=
  match f.callback with
  | none   => some []
  | some c => do
    -- Each argument's type, which `callbackDecl` declares the closure's of.
    let _ ← c.passed.mapM (·.value.callbackRawType)
    pure ((if c.style == .callbackMode then [⟨"callbackMode", "UInt32"⟩]
      else []) ++ [⟨"callback", s!"@& Internal.{c.names.lean}"⟩])

/--
`f`'s parameters for its callback: its mode, if it is registered with one,
and the closure.
-/
def callbackWrapperBinders (f : Lowered.Function) : List Binder :=
  f.callback.toList.flatMap fun c =>
    (if c.style == .callbackMode then [⟨"callbackMode", "CallbackMode"⟩]
      else []) ++ [⟨"callback", c.names.lean⟩]

/--
`f`'s callback, converted for its raw declaration: its mode as its code, and
the closure, by `Internal.X.raw`.
-/
def callbackRawArgs (f : Lowered.Function) : List Doc :=
  f.callback.toList.flatMap fun c =>
    let mode := if c.style == .callbackMode
      then [text "(CEnum.toC callbackMode)"] else []
    mode ++ [text s!"(Internal.{c.names.lean}.raw callback)"]

/-- A type as an argument of `IO`: in parentheses if it has spaces. -/
def ioOf (type : String) : String :=
  if type.contains ' ' then s!"IO ({type})" else s!"IO {type}"

/--
A method's object, as the first parameter `self`, and its type; nothing for a
function of no object type.
-/
def receiverBinder (f : Lowered.Function) (borrowed : Bool) : List Binder :=
  f.receiver.toList.map fun names =>
    ⟨"self", (if borrowed then "@& " else "") ++ names.lean⟩

/--
An argument's parameters in the raw declaration: one, its raw type, borrowed if
an object; or, for a struct behind a pointer, four, as its shim takes them
(`Emit.C.argCrossing`): the value, which the others' types are of; its bytes,
its targets and its table's index, each typed as exactly the struct's own, so
nothing else can be passed. None if a value has no raw type.
-/
def rawBinders (x : String) : Value → Option (List Binder)
  | .structPointer names b =>
    let (bytes, targets) := if b then ("OptBytesOf", "OptTargetsOf")
      else ("BytesOf", "TargetsOf")
    let type := if b then s!"Option {names.lean}" else names.lean
    some [
      ⟨x, "@& " ++ type⟩,
      ⟨x ++ "Bytes", s!"@& {bytes} {x}"⟩,
      ⟨x ++ "Targets", s!"@& {targets} {x}"⟩,
      ⟨x ++ "Table", s!"@& IndexOf {names.lean}"⟩]
  | v => v.rawLeanType.map fun type =>
    [⟨x, (if v.isObject then "@& " else "") ++ type⟩]

/-- The raw declaration's parameter for the tables, if `f` takes a struct. -/
def tablesBinders (f : Lowered.Function) : List Binder :=
  if Emit.C.takesStruct f then
    [⟨"tables", "@& CurrentTablesOf"⟩]
  else []

/--
The raw `@[extern]` declaration of `f`, as its shim implements it: objects and
strings borrowed, an enum as its code and a bitflag type as its bits. None if a
value has no raw type, which a bound function never has.
-/
def rawDecl (f : Lowered.Function) : Option Doc := do
  let args ← f.args.toList.mapM fun a => rawBinders a.names.lean a.value
  let callback ← callbackBinders f
  let result ← match f.result with
    | none   => pure "Unit"
    | some v => v.rawLeanType
  let shim := Emit.C.functionShimName f
  pure <| text s!"/-- The shim behind `{f.names.lean}`. -/" ++ hardline
    ++ text s!"@[extern \"{shim}\"]" ++ hardline
    ++ signature {
      keyword := "opaque"
      name    := "Internal." ++ f.names.lean
      binders := receiverBinder f true ++ args.flatten ++ callback
        ++ tablesBinders f
      result  := ioOf result
    }

/--
An argument `x` of `f`, converted to what the raw declaration takes: a struct
behind a pointer as itself and its bytes, targets and table's index, each
proved its own by `rfl`.
-/
def rawArg (x : String) : Value → List String
  | .enum _          => [s!"(CEnum.toC {x})"]
  | .bitflag _       => [s!"{x}.bits"]
  | .structPointer .. => [x, "⟨_, rfl⟩", "⟨_, rfl⟩", "⟨_, rfl⟩"]
  | _                => [x]

/--
`f` itself: its arguments and result in their Lean types, converted for its
raw declaration, which it calls. A result enum keeps a code no value has
(`CEnum.decode`). None if a value has no Lean type, which a bound function
never has.
-/
def wrapperDecl (f : Lowered.Function) : Option Doc := do
  let args ← f.args.toList.mapM fun a => do
    let type ← a.value.leanType
    pure (⟨a.names.lean, type⟩ : Binder)
  let result ← match f.result with
    | none   => pure "Unit"
    | some v => v.resultLeanType
  let callArgs :=
    ((f.receiver.toList.map fun _ => "self")
      ++ (f.args.toList.flatMap fun a => rawArg a.names.lean a.value)).map text
      ++ callbackRawArgs f
      ++ (if Emit.C.takesStruct f then [text "⟨_, rfl⟩"] else [])
  let call := group (nest 4 (join space
    ((text ("Internal." ++ f.names.lean)) :: callArgs)))
  let decoded := match f.result with
    | some (.enum _)          => text "CEnum.decode <$> " ++ call
    | some (.bitflag names)   => text s!"{names.lean}.mk <$> " ++ call
    | some .future            => text "Future.mk <$> " ++ call
    | _                       => call
  -- Each struct's `size_t`s must fit this target, as a `size_t` argument's
  -- must: an `IO` error if not.
  let fits := f.args.toList.filterMap fun a => match a.value with
    | .structPointer _ b =>
      let check := if b then "CStruct.optSizesFit" else "CStruct.sizesFit"
      some s!"{check} {a.names.lean}"
    | _ => none
  let condition := group (nest 4 (text "if "
    ++ join (text " &&" ++ space) (fits.map text) ++ text " then"))
  let refusal := group (nest 2 (text "throw (IO.userError" ++ space
    ++ text s!"\"{f.names.lean}: a size_t too large\")"))
  let body := if fits.isEmpty then decoded else
    condition ++ indented 2 decoded ++ hardline ++ text "else"
      ++ indented 2 refusal
  -- A struct that keeps callbacks is given for none as one of defaults, `{}`
  -- (each of its members has a default, or this does not elaborate), the
  -- same to WebGPU: so the bindings' own handlers are installed for those it
  -- is not given (`Emit.C.defaultHandled`), where C's NULL would install the
  -- implementation's, which may end the program (wgpu-native's does).
  let defaulted := f.args.toList.filterMap fun a => match a.value with
    | .structPointer _ true =>
      if f.heldInfos.any (·.arg == a.names.c) then some a.names.lean else none
    | _ => none
  let body := defaulted.foldr (init := body) fun x body =>
    text s!"let {x} := some ({x}.getD \{})" ++ hardline ++ body
  -- A struct of no use without its chain must be given one: an `IO` error if
  -- not, as an implementation may abort.
  let body := f.requiredChains.foldr (init := body) fun x body =>
    let refusal := group (nest 2 (text "throw (IO.userError" ++ space
      ++ text s!"\"{f.names.lean}: nothing chained to {x}\")"))
    text s!"if {x}.chain.isEmpty then" ++ indented 2 refusal ++ hardline
      ++ text "else" ++ indented 2 body
  pure <| docBefore 0 f.doc ++ text "@[inline]" ++ hardline
    ++ signature {
      keyword := "def"
      name    := f.names.lean
      binders := receiverBinder f false ++ args ++ callbackWrapperBinders f
      result  := ioOf result
    }
    ++ text " :=" ++ indented 2 body

/-- A bound function: its raw declaration, then itself. -/
def functionDecls (f : Lowered.Function) : List Doc :=
  (rawDecl f).toList ++ (wrapperDecl f).toList

/-! ## Structs

Each struct the bindings can bind is a Lean structure, its fields aligned as
`name : Type := default`; a field with no default must be given. A default of
every byte zero, as a bind group layout entry's unused slots have, is a
definition of its own, `T.zero`, after the structure `T`.

    structure VertexAttribute where
      format         : VertexFormat
      offset         : UInt64       := 0
      shaderLocation : UInt32       := 0
-/

/--
A number as a Lean literal: in hex if it is a large mask of ones, as
`0xFFFFFFFF`, and otherwise in decimal, as the spec writes `50000000`.
-/
def intLiteral (n : Int) : String :=
  let mask := n ≥ 0x10000 && (n.toNat + 1) &&& n.toNat == 0
  if mask then hex 0 n.toNat else toString n

/--
A default, as a Lean term, for a field of the value `v`: `.rgba8Unorm` for an
enum entry, as the field's type is known.
-/
def leanDefault (v : Value) : Lowered.Default → String
  | .bool b          => if b then "true" else "false"
  | .int n           => intLiteral n
  | .float literal   => match v with
    | .nullableFloat32 => s!"some {literal}"
    | _ => literal
  | .constant names  => match v with
    | .nullableFloat32 => s!"some {names.lean}"
    | _ => names.lean
  -- The field's type is known, so an entry or zero value needs no type name.
  | .entry _ e       => "." ++ e.lean
  -- Settled, a zero default is `fields`; unsettled, `.zero` still names the
  -- value, and fails to elaborate rather than give another if there is none.
  | .fields .. | .zero => ".zero"
  | .nested            => "{}"
  | .null            => "none"
  | .empty           => match v with
    | .array .. => "#[]"
    | _ => "\"\""

/--
A struct's fields, aligned in columns, each with its doc: a nullable float's
says what `none` is, as upstream's speaks of NaN.
-/
def structFields (s : Lowered.Struct) : Doc :=
  let members := s.members.toList.filterMap fun m => do
    let type ← m.value.leanType
    let cells := [m.names.lean, ":", type]
    let doc := match m.value with
      | .nullableFloat32 =>
        addParagraph m.doc "In Lean, `none` is C's NaN, as is `some` of a NaN."
      | _ => m.doc
    pure (doc, cells ++ match m.default with
      | some d => [":=", leanDefault m.value d]
      | none   => [])
  -- Its extensions, chained to it (C's `nextInChain`): aligned on their own,
  -- so that its long type does not widen the members' columns.
  let chain := if s.extensions.isEmpty then [] else
    [("Extensions chained to it (`nextInChain`), in order.",
      ["chain", ":", s!"Array {s.names.lean}.Chained", ":=", "#[]"])]
  join hardline (([members, chain].filter (!·.isEmpty)).map (documentedRows 2))

/--
What can be chained to the struct `s`, if anything: its extensions, as an
inductive `T.Chained`, each a constructor named by its `SType` entry. None if
it has no extensions.
-/
def chainedDecl (structs : List Lowered.Struct) (s : Lowered.Struct) :
    Option Doc := do
  guard !s.extensions.isEmpty
  let ctors ← s.extensions.toList.mapM fun n => do
    let e ← structs.find? (·.names == n)
    let entry ← e.sType
    pure (entry.lean, n.lean)
  let width := (ctors.map (·.1.length)).foldl max 0
  let pad (x : String) := x.pushn ' ' (width - x.length)
  pure <| Doc.lines ([
    s!"/-- What can be chained to a `{s.names.lean}`: one of its " ++
      "extensions. -/",
    s!"inductive {s.names.lean}.Chained where"]
    ++ ctors.map fun (c, t) => s!"  | {pad c} (s : {t})")

/-- A struct, as a Lean structure. -/
def structDecl (s : Lowered.Struct) : Doc :=
  let header := text s!"structure {s.names.lean} where"
  docBefore 0 s.doc ++ header
    ++ (if s.members.isEmpty && s.extensions.isEmpty then nil
      else indented 2 (structFields s))

/--
The value of the struct `s` with every byte zero (C's `_wgpu_STRUCT_ZERO_INIT`),
`T.zero`, given its fields' values.
-/
def zeroDecl (s : Lowered.Struct) (fields : List (Names × Lowered.Default)) :
    Doc :=
  let doc := s!"`{s.names.lean}` with every byte zero, as C's zero initialiser."
  docBefore 0 doc
    ++ text s!"def {s.names.lean}.zero : {s.names.lean} where"
    ++ indented 2 (Doc.lines (columns ((s.members.toList.zip fields).map
      fun (m, (n, d)) => [n.lean, ":=", leanDefault m.value d])))

/--
The first zero value of each struct, by its C name, in order: a struct has
one `T.zero`, whichever default refers to it.
-/
def firstOfEach (zeros : List (Names × List (Names × Lowered.Default))) :
    List (Names × List (Names × Lowered.Default)) :=
  go [] zeros
where
  /-- Those kept so far (`acc`), and those still to look at. -/
  go (acc : List (Names × List (Names × Lowered.Default))) :
      List (Names × List (Names × Lowered.Default)) →
        List (Names × List (Names × Lowered.Default))
    | [] => acc
    | (n, f) :: rest =>
      go (if acc.any (·.1.c == n.c) then acc else acc ++ [(n, f)]) rest

/--
The zero values the structs' defaults are or hold, however deep, in the order
of `structs`, each once.
-/
def zeroValues (structs : List Lowered.Struct) :
    List (Names × List (Names × Lowered.Default)) :=
  firstOfEach (structs.flatMap fun s => s.members.toList.flatMap fun m =>
    (m.default.map (·.zeroValues)).getD [])

/-- The bound structs' declarations, each followed by its zero value if used. -/
def structDecls (spec : Lowered.Spec) : List Doc :=
  let bound := boundStructs spec.structs.toList
  let zeros := zeroValues bound
  bound.flatMap fun s =>
    let zero := zeros.find? (·.1.c == s.names.c)
    (chainedDecl bound s).toList ++ [structDecl s]
      ++ zero.toList.map fun (_, f) => zeroDecl s f

/-! ## Files -/

/--
Does `d` print on one line, at the margin? (Declarations always start there.)
-/
def isOneLine (d : Doc) : Bool :=
  !(pretty width d).contains '\n'

/--
Declarations one after another, with a blank line between them, except that
consecutive one-line declarations stay together.
-/
def joinDecls : List Doc → Doc
  | []      => nil
  | d :: ds => d ++ go (isOneLine d) ds
where
  /-- The rest, after a declaration that was one line if `previous`. -/
  go (previous : Bool) : List Doc → Doc
    | []      => nil
    | d :: ds =>
      let oneLine := isOneLine d
      let sep := if previous && oneLine then hardline else hardline ++ hardline
      sep ++ d ++ go oneLine ds

/--
A generated module: the banner, the module header with its imports, the module
doc, then the declarations in `WebGPU.Raw`, laid out by `joinDecls`. Its
declarations are public, and its definitions exposed, so that users can compute
with them.
-/
def moduleFile (p : Provenance) (imports doc : List String) (decls : List Doc) :
    String :=
  let blocks := [Doc.lines (banner p ++ ["module"])]
    ++ (if imports.isEmpty then [] else [Doc.lines imports]) ++ [
    Doc.lines (["/-!"] ++ doc ++ ["-/"]),
    text "@[expose] public section",
    text "namespace WebGPU.Raw"
  ] ++ (if decls.isEmpty then [] else [joinDecls decls]) ++ [
    text "end WebGPU.Raw",
    text "end"
  ]
  pretty width (join (hardline ++ hardline) blocks) ++ "\n"

/-- The module of enums and bitflag types. -/
def enumsFile (p : Provenance) (spec : Lowered.Spec) : String :=
  moduleFile p
    [
      "public import WebGPU.Raw.CEnum",
      "import WebGPU.Raw.Internal.CEnum"
    ]
    [
      "# Enums and bitflags",
      "",
      "Every enum and bitflag type in `webgpu.h`, with the codes and values it gives",
      "them.",
      "",
      "Each `c_enum` declares an enum and its `CEnum` instance: `CEnum.toC` gives a",
      "value's code in `webgpu.h`, and `CEnum.ofC?` the value a code stands for. Each",
      "bitflag type wraps its bits, with a constant per flag: combine flags with `|||`",
      "and mask them with `&&&`."
    ]
    (spec.enums.toList.map enumDecl ++ spec.bitflags.toList.map bitflagDecl)

/-- The module of object types. -/
def objectsFile (p : Provenance) (spec : Lowered.Spec) : String :=
  moduleFile p
    [
      "import WebGPU.Raw.Internal.CObject"
    ]
    [
      "# Objects",
      "",
      "Every object type in `webgpu.h`. Each `c_object` declares an opaque type: Lean",
      "code can hold a handle to the object and pass it on, but only the C side can",
      "make one or look inside it."
    ]
    (spec.objects.toList.map objectDecl ++ [objectsStartup])

/--
The module of callback types: those the bound functions take, and those the
bound structs keep, with their infos.
-/
def callbacksFile (p : Provenance) (spec : Lowered.Spec) : String :=
  let held := Emit.C.heldCallbacks spec
  moduleFile p
    [
      "public import WebGPU.Raw.CEnum",
      "public import WebGPU.Raw.Enums",
      "public import WebGPU.Raw.Objects",
      "public import WebGPU.Raw.Internal.Reloc"
    ]
    [
      "# Callbacks",
      "",
      "The callback types of `webgpu.h` the bindings can pass so far: each the",
      "type of a Lean closure C runs as a callback, given each argument as C",
      "passes it, and the type of the closure the raw declarations take. Those a",
      "struct keeps, as a device descriptor keeps its device-lost callback, have",
      "an info structure too: the closure, and the mode it is registered with."
    ]
    (text "open Reloc" ::
      (Emit.C.boundCallbacks spec).filterMap (callbackDecl ·)
      ++ held.flatMap fun (c, hasMode) =>
        -- Its info only beside its types, which it uses.
        (callbackDecl c (held := true)).toList.flatMap fun d =>
          [d, callbackInfoDecl c hasMode])

/-- The module of functions and methods. -/
def functionsFile (p : Provenance) (spec : Lowered.Spec) : String :=
  moduleFile p
    [
      "public import WebGPU.Raw.CEnum",
      "public import WebGPU.Raw.Enums",
      "public import WebGPU.Raw.Objects",
      "public import WebGPU.Raw.Callbacks",
      "public import WebGPU.Raw.Encoders"
    ]
    [
      "# Functions",
      "",
      "The functions and methods of `webgpu.h` the bindings can bind so far, each in",
      "`IO`. A method takes its object first, as `self`, so `device.getQueue` calls",
      "`wgpuDeviceGetQueue`. Each calls a raw declaration under `Internal`, which",
      "its C shim implements, and which is not API: only these functions call",
      "them. `docs/Safety.md` gives the rules they follow."
    ]
    (text "open Reloc" ::
      (Emit.C.boundFunctions spec).flatMap fun (f, _) => functionDecls f)

/-- The module of constants. -/
def constantsFile (p : Provenance) (spec : Lowered.Spec) : String :=
  moduleFile p []
    [
      "# Constants",
      "",
      "Every constant in the spec, such as `wholeSize`, the size that means",
      "\"to the end of the buffer\"."
    ]
    [constantsDecl spec.constants.toList]

/-- The module of structs. -/
def structsFile (p : Provenance) (spec : Lowered.Spec) : String :=
  moduleFile p
    [
      "public import WebGPU.Raw.Constants",
      "public import WebGPU.Raw.Enums",
      "public import WebGPU.Raw.Objects",
      "public import WebGPU.Raw.Callbacks"
    ]
    [
      "# Structs",
      "",
      "The structs of `webgpu.h` the bindings can pass so far, as Lean structures,",
      "with the defaults C's initialisers give: so `{ size := 64 }` is a buffer",
      "descriptor with every other field at its default. A field with no default",
      "must be given. An extensible struct's `chain` holds its extensions, linked",
      "in order as C's `nextInChain`."
    ]
    (structDecls spec)

end WebGPUGen.Emit.Lean
