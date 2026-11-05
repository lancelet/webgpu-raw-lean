import WebGPUGen.Emit.Lean
import WebGPUGenTest.Lowered.Lower

/-!
# Tests for the Lean printer

Each test lowers a small spec and prints part of it, comparing with the exact
Lean source expected. The generated module for the real spec is compiled in the
bindings package.
-/

namespace WebGPUGenTest.Emit.Lean
open WebGPUGen.Emit WebGPUGen.Emit.Lean WebGPUGen
open WebGPUGenTest.Resolved.Resolve (spec)
open WebGPUGenTest.Lowered.Lower (lowerText)

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- A document as printed, for comparing with a `dedent` literal. -/
def render (d : Doc) : String := Doc.pretty width d ++ "\n"

/-- The first enum of the spec `input`, lowered and printed. -/
def printEnum (input : String) : Option String :=
  ((lowerText input).bind (·.enums[0]?)).map (render ∘ enumDecl)

/-- The first bitflag type of the spec `input`, lowered and printed. -/
def printBitflag (input : String) : Option String :=
  ((lowerText input).bind (·.bitflags[0]?)).map (render ∘ bitflagDecl)

/-! ## Numbers -/

#guard hex 8 0x32 == "0x00000032"
#guard hex 16 0xF == "0x000000000000000F"

/-! ## Enums -/

-- A `c_enum` with the codes aligned; an undocumented entry has no doc comment,
-- and a keyword is quoted.
#guard
  let input := spec (enums := dedent "
    - name: address_mode
      doc: How to address.
      entries:
        - name: undefined
          doc: Nothing passed.
        - name: clamp_to_edge
          doc: TODO
        - name: repeat
          doc: TODO
    ")
  let expected := dedent "
    /-- How to address. -/
    c_enum AddressMode where
      /-- Nothing passed. -/
      | undefined   = 0x00000000
      | clampToEdge = 0x00000001
      | «repeat»    = 0x00000002
    "
  printEnum input == some expected

-- An enum with no entries is just its header: no stray line after `where`.
#guard
  let input := spec (enums := dedent "
    - name: nothing
      doc: An empty enum.
      entries: []
    ")
  let expected := dedent "
    /-- An empty enum. -/
    c_enum Nothing where
    "
  printEnum input == some expected

-- An entry's doc of several paragraphs is indented with the entry, its blank
-- line left empty, with no spaces at its end.
#guard
  let input := spec (enums := dedent "
    - name: two
      doc: TODO
      entries:
        - name: a
          doc: |
            First paragraph.

            Second paragraph.
    ")
  let expected := dedent "
    c_enum Two where
      /--
      First paragraph.

      Second paragraph.
      -/
      | a = 0x00000000
    "
  printEnum input == some expected

/-! ## Bitflags -/

-- A structure around the bits, an aligned constant per flag, and the operators.
#guard
  let input := spec (bitflags := dedent "
    - name: map_mode
      doc: TODO
      entries:
        - name: none
          doc: TODO
        - name: read
          doc: Map for reading.
        - name: write
          doc: TODO
    ")
  let expected := dedent "
    structure MapMode where
      bits : UInt64
      deriving Repr, DecidableEq, Inhabited

    namespace MapMode

    def none  : MapMode := ⟨0x0000000000000000⟩
    /-- Map for reading. -/
    def read  : MapMode := ⟨0x0000000000000001⟩
    def write : MapMode := ⟨0x0000000000000002⟩

    instance : OrOp MapMode  := ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩
    instance : AndOp MapMode := ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩

    end MapMode
    "
  printBitflag input == some expected

-- A bitflag type with no flags has no constants, and one blank line where
-- they would be.
#guard
  let input := spec (bitflags := dedent "
    - name: no_flags
      doc: TODO
      entries: []
    ")
  let expected := dedent "
    structure NoFlags where
      bits : UInt64
      deriving Repr, DecidableEq, Inhabited

    namespace NoFlags

    instance : OrOp NoFlags  := ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩
    instance : AndOp NoFlags := ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩

    end NoFlags
    "
  printBitflag input == some expected


/-! ## Signatures -/

-- A signature that fits stays on one line.
#guard
  let input : Signature := {
    keyword := "opaque"
    name    := "Device.release"
    binders := [⟨"device", "Device"⟩]
    result  := "IO Unit"
  }
  let expected := "opaque Device.release (device : Device) : IO Unit\n"
  render (signature input) == expected

-- One that does not has a parameter per line, their `:` aligned, and the result
-- type after them, all indented four spaces.
#guard
  let input : Signature := {
    keyword := "opaque"
    name    := "Device.createBuffer"
    binders := [⟨"device", "@& Device"⟩, ⟨"descriptor", "@& BufferDescriptor"⟩]
    result  := "IO Buffer"
  }
  let expected := dedent "
    opaque Device.createBuffer
        (device     : @& Device)
        (descriptor : @& BufferDescriptor) :
        IO Buffer
    "
  render (signature input) == expected

-- It breaks only past 80 columns: at 80 it fits.
#guard
  let fill (n : Nat) := String.ofList (List.replicate n 'a')
  let at80 : Signature := {
    keyword := "def"
    name    := fill 64
    binders := [⟨"x", "T"⟩]
    result  := "R"
  }
  let at81 := { at80 with name := fill 65 }
  (render (signature at80)).length == 81
    && ((render (signature at81)).splitOn "\n").length == 4

-- With no parameters, a signature too long for one line puts its type on the
-- next.
#guard
  let input : Signature := {
    keyword := "opaque"
    name    := String.ofList (List.replicate 70 'a')
    binders := []
    result  := "IO Unit"
  }
  let expected := "opaque " ++ input.name ++ " :\n    IO Unit\n"
  render (signature input) == expected

-- After its doc comment, a signature still fits on one line: the comment's line
-- break does not break the signature.
#guard
  let input : Signature := {
    keyword := "opaque"
    name    := "Device.release"
    binders := [⟨"device", "Device"⟩]
    result  := "IO Unit"
  }
  let expected := dedent "
    /-- Release the device. -/
    opaque Device.release (device : Device) : IO Unit
    "
  render (docBefore 0 "Release the device." ++ signature input) == expected

-- Text after it on the same line counts: 78 columns and ` :=` make 81, so it
-- breaks, and the ` :=` follows the result type.
#guard
  let input : Signature := {
    keyword := "def"
    name    := String.ofList (List.replicate 62 'a')
    binders := [⟨"x", "T"⟩]
    result  := "R"
  }
  let expected := "def " ++ input.name ++ "\n    (x : T) :\n    R :=\n"
  render (signature input ++ .text " :=") == expected

-- So does text before it: `private ` pushes a 76-column signature past 80.
#guard
  let input : Signature := {
    keyword := "def"
    name    := String.ofList (List.replicate 60 'a')
    binders := [⟨"x", "T"⟩]
    result  := "R"
  }
  let expected := "private def " ++ input.name ++ "\n    (x : T) :\n    R\n"
  render (.text "private " ++ signature input) == expected

-- A parameter is never broken itself: a very long type makes its line longer
-- than 80 columns.
#guard
  let long := String.ofList (List.replicate 80 'T')
  let input : Signature := {
    keyword := "opaque"
    name    := "f"
    binders := [⟨"x", long⟩]
    result  := "IO Unit"
  }
  let expected := "opaque f\n    (x : " ++ long ++ ") :\n    IO Unit\n"
  render (signature input) == expected

-- (`_root_`: inside this namespace, `Lean` alone names the printer's module.)
open _root_.Lean in
/-- Does `src` parse as one Lean command? -/
def parsesAsCommand (src : String) : CoreM Bool := do
  return (Parser.runParserCategory (← getEnv) `command src).isOk

-- Each layout is Lean that parses: on one line, broken with parameters (and
-- `@&`), and broken without them.
#eval show Lean.CoreM Unit from do
  let fits : Signature := {
    keyword := "opaque"
    name    := "Device.release"
    binders := [⟨"device", "Device"⟩]
    result  := "IO Unit"
  }
  let broken : Signature := {
    keyword := "opaque"
    name    := "Device.createBuffer"
    binders := [⟨"device", "@& Device"⟩, ⟨"descriptor", "@& BufferDescriptor"⟩]
    result  := "IO Buffer"
  }
  let bare : Signature := {
    keyword := "opaque"
    name    := String.ofList (List.replicate 70 'a')
    binders := []
    result  := "IO Unit"
  }
  for s in [fits, broken, bare] do
    let src := "@[extern \"f\"]\n" ++ render (signature s)
    unless (← parsesAsCommand src) do
      throwError "does not parse as Lean:\n{src}"

/-! ## Objects -/

-- One `c_object` declaration per object type, with its doc if it has one.
#guard
  let input := spec (objects := dedent "
    - name: adapter
      doc: TODO
      methods: []
    - name: query_set
      doc: A set of queries.
      methods: []
    ")
  let expected := dedent "
    c_object Adapter
    /-- A set of queries. -/
    c_object QuerySet
    "
  let objects (l : Lowered.Spec) := l.objects.toList.map objectDecl
  (lowerText input).map (fun l => render (Doc.join .hardline (objects l)))
    == some expected

-- The start-up that registers the object classes: a `builtin_initialize`, so
-- that the compiler does not run it when it imports the module (a regression
-- test: a plain `initialize` crashed every build importing the bindings).
#guard
  let expected := dedent "
    namespace Internal

    /-- Register the object types' classes, so the C side can box handles. -/
    @[extern \"lean_wgpu_objects_init\"]
    private opaque startObjects : IO Unit

    builtin_initialize startObjects

    end Internal
    "
  render objectsStartup == expected

/-! ## Functions -/

open WebGPUGen.Lowered

/-- A buffer's names. -/
def bufferNames : Names := ⟨"WGPUBuffer", "Buffer"⟩

/-- An undocumented argument named the same on both sides. -/
def arg (name : String) (value : Value) : Arg := ⟨⟨name, name⟩, "", value⟩

/-- An undocumented function that takes no callback. -/
def function (c lean : String) (receiver : Option Names) (args : Array Arg)
    (result : Option Value) : Lowered.Function := {
  names    := ⟨c, lean⟩
  doc      := ""
  receiver := receiver
  args     := args
  result   := result
  callback := none
}

/-- A function's two declarations, printed. -/
def printFunction (f : Lowered.Function) : String :=
  render (joinDecls (functionDecls f))

-- A function of no object type: its raw declaration takes an enum as its code,
-- and the function converts it with `CEnum.toC`.
#guard
  let feature : Names := ⟨"WGPUFeatureName", "FeatureName"⟩
  let input := function "wgpuHasFeature" "hasFeature" none
    #[arg "feature" (.enum feature)] (some .bool)
  let expected := dedent "
    /-- The shim behind `hasFeature`. -/
    @[extern \"lean_wgpuHasFeature\"]
    opaque Internal.hasFeature (feature : UInt32) : IO Bool

    @[inline]
    def hasFeature (feature : FeatureName) : IO Bool :=
      Internal.hasFeature (CEnum.toC feature)
    "
  printFunction input == expected

-- A method: its object first, as `self`; objects borrowed (`@&`) in the raw
-- declaration only; signatures too long for a line broken into tables.
#guard
  let encoder : Names := ⟨"WGPURenderPassEncoder", "RenderPassEncoder"⟩
  let input := function "wgpuRenderPassEncoderSetVertexBuffer"
    "RenderPassEncoder.setVertexBuffer" (some encoder)
    #[arg "slot" .uint32, arg "buffer" (.object bufferNames true),
      arg "offset" .uint64, arg "size" .uint64] none
  let expected := dedent "
    /-- The shim behind `RenderPassEncoder.setVertexBuffer`. -/
    @[extern \"lean_wgpuRenderPassEncoderSetVertexBuffer\"]
    opaque Internal.RenderPassEncoder.setVertexBuffer
        (self   : @& RenderPassEncoder)
        (slot   : UInt32)
        (buffer : @& Option Buffer)
        (offset : UInt64)
        (size   : UInt64) :
        IO Unit

    @[inline]
    def RenderPassEncoder.setVertexBuffer
        (self   : RenderPassEncoder)
        (slot   : UInt32)
        (buffer : Option Buffer)
        (offset : UInt64)
        (size   : UInt64) :
        IO Unit :=
      Internal.RenderPassEncoder.setVertexBuffer self slot buffer offset size
    "
  printFunction input == expected

-- A result enum is decoded, keeping a code no value has; a result bitflag type
-- is rebuilt from its bits.
#guard
  let state : Names := ⟨"WGPUBufferMapState", "BufferMapState"⟩
  let usage : Names := ⟨"WGPUBufferUsage", "BufferUsage"⟩
  let enumResult := function "wgpuBufferGetMapState" "Buffer.getMapState"
    (some bufferNames) #[] (some (.enum state))
  let flagsResult := function "wgpuBufferGetUsage" "Buffer.getUsage"
    (some bufferNames) #[] (some (.bitflag usage))
  let wrapper (f : Lowered.Function) := render ((wrapperDecl f).getD .nil)
  wrapper enumResult == dedent "
    @[inline]
    def Buffer.getMapState (self : Buffer) : IO (Except UInt32 BufferMapState) :=
      CEnum.decode <$> Internal.Buffer.getMapState self
    "
    && wrapper flagsResult == dedent "
    @[inline]
    def Buffer.getUsage (self : Buffer) : IO BufferUsage :=
      BufferUsage.mk <$> Internal.Buffer.getUsage self
    "

-- A method named with a keyword keeps its quotes in both declarations.
#guard
  let encoder : Names := ⟨"WGPUComputePassEncoder", "ComputePassEncoder"⟩
  let input := function "wgpuComputePassEncoderEnd" "ComputePassEncoder.«end»"
    (some encoder) #[] none
  (printFunction input).contains "opaque Internal.ComputePassEncoder.«end»"
    && (printFunction input).contains "def ComputePassEncoder.«end» (self"

/-! ## Constants -/

-- A paragraph added to a doc goes before its link definitions, which stay last.
#guard
  let links := "[A]: https://a.example\n[B]: https://b.example\n"
  let doc := "See [A] and [B].\n\n" ++ links
  addParagraph doc "A note." == "See [A] and [B].\n\nA note.\n\n" ++ links
    && addParagraph "" "A note." == "A note."
    && addParagraph "Plain." "" == "Plain."
    && addParagraph "No final newline." "A note."
      == "No final newline.\n\nA note."

-- Constants as definitions aligned in columns, a blank line between each two;
-- a `SIZE_MAX` says what it stands for.
#guard
  let input : List Lowered.Constant := [
    ⟨⟨"WGPU_WHOLE_SIZE", "wholeSize"⟩, "", .uint64 0xFFFFFFFFFFFFFFFF⟩,
    ⟨⟨"WGPU_LIMIT_U32_UNDEFINED", "limitU32Undefined"⟩, "", .uint32 0xFFFFFFFF⟩,
    ⟨⟨"WGPU_DEPTH_CLEAR_VALUE_UNDEFINED", "depthClearValueUndefined"⟩, "",
      .nan⟩,
    ⟨⟨"WGPU_WHOLE_MAP_SIZE", "wholeMapSize"⟩, "", .sizeMax⟩
  ]
  let expected := dedent "
    def wholeSize                : UInt64  := 0xFFFFFFFFFFFFFFFF

    def limitU32Undefined        : UInt32  := 0xFFFFFFFF

    def depthClearValueUndefined : Float32 := 0.0 / 0.0

    /--
    `SIZE_MAX`: the largest `UInt64`, which the bindings pass as the largest
    `size_t` on every platform (32 bits on the web).
    -/
    def wholeMapSize             : UInt64  := 0xFFFFFFFFFFFFFFFF
    "
  render (constantsDecl input) == expected

/-! ## Structs -/

/-- A struct of the members given, undocumented and standalone. -/
def struct (c lean : String) (members : List Member) : Lowered.Struct where
  names           := ⟨c, lean⟩
  doc             := ""
  kind            := .standalone
  extendedStructs := #[]
  sType           := none
  freeMembers     := false
  members         := members.toArray

/-- An undocumented member named the same on both sides. -/
def member (name : String) (value : Value) (default : Option Lowered.Default) :
    Member :=
  ⟨⟨name, name⟩, "", value, default⟩

-- A struct as a Lean structure, its fields aligned: each default as a Lean
-- term (an entry or zero value without its type, which the field gives), and
-- a field with none, which must be given.
#guard
  let usage : Names := ⟨"WGPUUsage", "Usage"⟩
  let inner : Names := ⟨"WGPUInner", "Inner"⟩
  let input := struct "WGPUThing" "Thing" [
    member "label" (.string false) (some .empty),
    member "usage" (.bitflag usage)
      (some (.entry usage ⟨"WGPUUsage_None", "none"⟩)),
    member "size" .uint64 (some (.constant ⟨"WGPU_WHOLE_SIZE", "wholeSize"⟩)),
    member "mask" .uint32 (some (.int 0xFFFFFFFF)),
    member "buffer" (.object bufferNames false) none,
    member "maybe" (.object bufferNames true) (some .null),
    member "inner" (.struct inner) (some (.fields inner [])),
    member "nested" (.struct inner) (some .nested),
    member "items" (.array (.struct inner) "itemCount") (some .empty)
  ]
  let expected := dedent "
    structure Thing where
      label  : String        := \"\"
      usage  : Usage         := .none
      size   : UInt64        := wholeSize
      mask   : UInt32        := 0xFFFFFFFF
      buffer : Buffer
      maybe  : Option Buffer := none
      inner  : Inner         := .zero
      nested : Inner         := {}
      items  : Array Inner   := #[]
    "
  render (structDecl input) == expected

-- A struct with no members is a structure with no fields.
#guard
  let input := struct "WGPUEmpty" "Empty" []
  render (structDecl input) == "structure Empty where\n"

-- The value of a struct with every byte zero: its fields, aligned.
#guard
  let mode : Names := ⟨"WGPUMode", "Mode"⟩
  let input := struct "WGPUSlot" "Slot" [
    member "type" (.enum mode) none,
    member "dynamic" .bool none
  ]
  let fields : List (Names × Lowered.Default) := [
    (⟨"type", "type"⟩, .entry mode ⟨"WGPUMode_NotUsed", "notUsed"⟩),
    (⟨"dynamic", "dynamic"⟩, .bool false)
  ]
  let expected := dedent "
    /-- `Slot` with every byte zero, as C's zero initialiser. -/
    def Slot.zero : Slot where
      type    := .notUsed
      dynamic := false
    "
  render (zeroDecl input fields) == expected

-- The zero values a struct's defaults refer to, at any depth: a zero value
-- with a struct in it refers to that struct's zero value too.
#guard
  let inner : Names := ⟨"WGPUInner", "Inner"⟩
  let middle : Names := ⟨"WGPUMiddle", "Middle"⟩
  let innerZero : List (Names × Lowered.Default) := [
    (⟨"count", "count"⟩, .int 0)
  ]
  let middleZero : List (Names × Lowered.Default) := [
    (⟨"inner", "inner"⟩, .fields inner innerZero)
  ]
  let structs := [
    struct "WGPUInner" "Inner" [member "count" .uint32 none],
    struct "WGPUMiddle" "Middle" [member "inner" (.struct inner) none],
    struct "WGPUOuter" "Outer" [
      member "middle" (.struct middle) (some (.fields middle middleZero))
    ]
  ]
  (zeroValues structs).map (·.1.lean) == ["Middle", "Inner"]

-- A default's zero values: itself, then each field's, outermost first; found
-- from the default alone, without the structs it names.
#guard
  let a : Names := ⟨"WGPUA", "A"⟩
  let b : Names := ⟨"WGPUB", "B"⟩
  let c : Names := ⟨"WGPUC", "C"⟩
  let input := Lowered.Default.fields a [
    (⟨"b", "b"⟩, .fields b [(⟨"n", "n"⟩, .int 0)]),
    (⟨"flag", "flag"⟩, .bool false),
    (⟨"c", "c"⟩, .fields c [])
  ]
  input.zeroValues.map (·.1.lean) == ["A", "B", "C"]
    && (Lowered.Default.int 0).zeroValues.isEmpty
    && (zeroValues [struct "WGPUOuter" "Outer" [
      member "a" (.struct a) (some input)
    ]]).map (·.1.lean) == ["A", "B", "C"]

-- Each struct has one zero value, the first a default gives.
#guard
  let inner : Names := ⟨"WGPUInner", "Inner"⟩
  let first := [(⟨"n", "n"⟩, Lowered.Default.int 0)]
  let structs := [
    struct "WGPUOne" "One" [
      member "x" (.struct inner) (some (.fields inner first))
    ],
    struct "WGPUTwo" "Two" [
      member "y" (.struct inner) (some (.fields inner []))
    ]
  ]
  zeroValues structs == [(inner, first)]

-- A default of every byte zero not yet settled into its fields' values is
-- printed as `.zero`, so that it fails to elaborate if there is no `T.zero`,
-- rather than as `{}`, a different value.
#guard
  let inner : Names := ⟨"WGPUInner", "Inner"⟩
  leanDefault (.struct inner) .zero == ".zero"

-- A nullable float is an `Option Float32`: a number as its default is `some`.
#guard
  leanDefault .nullableFloat32 (.float "0.5") == "some 0.5"
    && leanDefault .nullableFloat32 .null == "none"
    && leanDefault .nullableFloat32 (.constant ⟨"WGPU_HALF", "half"⟩)
      == "some half"

-- A nullable float's doc, which speaks of C's NaN, says what `none` is.
#guard
  let clear : Member :=
    ⟨⟨"clear", "clear"⟩, "If `NaN`, undefined.", .nullableFloat32, some .null⟩
  let input := struct "WGPUAttachment" "Attachment" [clear]
  let expected := dedent "
    structure Attachment where
      /--
      If `NaN`, undefined.

      In Lean, `none` is C's NaN, as is `some` of a NaN.
      -/
      clear : Option Float32 := none
    "
  render (structDecl input) == expected

-- Integer defaults: decimal, except a large mask of ones, which is in hex.
#guard
  intLiteral 0 == "0" && intLiteral 50000000 == "50000000"
    && intLiteral 0xFFFF == "65535" && intLiteral 0xFFFFFFFF == "0xFFFFFFFF"
    && intLiteral (-1) == "-1"

-- The structs the bindings can bind, each after those it refers to; one whose
-- members cannot all be passed is not bound, nor is one that refers to it.
#guard
  let a : Names := ⟨"WGPUA", "A"⟩
  let c : Names := ⟨"WGPUC", "C"⟩
  let structs := [
    struct "WGPUB" "B" [member "a" (.struct a) (some .nested)],
    struct "WGPUA" "A" [member "n" .uint32 (some (.int 0))],
    struct "WGPUC" "C" [member "x" (.unsupported "callback") none],
    struct "WGPUD" "D" [member "c" (.structPointer c false) none]
  ]
  (boundStructs structs).map (·.names.lean) == ["A", "B"]

-- A struct refers to another however its type names it, as in an array of
-- pointers: one that refers to a struct not given is not bound.
#guard
  let missing : Names := ⟨"WGPUMissing", "Missing"⟩
  let structs := [
    struct "WGPUE" "E" [
      member "items" (.array (.structPointer missing true) "itemCount") none
    ],
    struct "WGPUF" "F" [
      member "rows" (.array (.array (.struct missing) "n") "rowCount") none
    ]
  ]
  boundStructs structs == []

-- A struct is referred to by both of its names: one that refers to a struct's C
-- name under another Lean name is not bound.
#guard
  let a : Names := ⟨"WGPUA", "A"⟩
  let structs := [
    struct "WGPUA" "A" [member "n" .uint32 (some (.int 0))],
    struct "WGPUB" "B" [member "a" (.struct ⟨"WGPUA", "Other"⟩) (some .nested)],
    struct "WGPUC" "C" [member "a" (.struct a) (some .nested)]
  ]
  (boundStructs structs).map (·.names.lean) == ["A", "C"]

/-! ## Joining declarations -/

-- One-line declarations stay together; a longer one has blank lines around it.
#guard
  let input := [
    ["c_object Adapter"],
    ["c_object BindGroup"],
    ["/-- A device. -/", "c_object Device"],
    ["c_object Queue"]
  ]
  let expected := dedent "
    c_object Adapter
    c_object BindGroup

    /-- A device. -/
    c_object Device

    c_object Queue
    "
  render (joinDecls (input.map Doc.lines)) == expected

-- A declaration on one line counts as one line however wide it is: it never
-- breaks, so it stays with its neighbour.
#guard
  let wide := "c_object " ++ String.ofList (List.replicate 90 'A')
  let input := [[wide], ["c_object Queue"]]
  render (joinDecls (input.map Doc.lines)) == wide ++ "\nc_object Queue\n"

/-! ## The whole file -/

-- The banner, the module header and imports, then each declaration: an enum
-- whose entry's doc links a documentation section, and a documented bitflag
-- type.
#guard
  let input := spec
    (enums := dedent "
      - name: feature_level
        doc: TODO
        entries:
          - name: undefined
            doc: |
              Indicates no value is passed for this argument. See @ref SentinelValues.
          - name: core
            doc: TODO
      ")
    (bitflags := dedent "
      - name: map_mode
        doc: How a buffer is mapped.
        entries:
          - name: none
            doc: TODO
          - name: read
            doc: TODO
      ")
  let provenance : Provenance := {
    generator    := "webgpu-gen"
    time         := "2026-11-02 17:05:12 UTC"
    commit       := "3500dab"
    dirty        := false
    source       := "vendor/webgpu-headers/webgpu.yml"
    sourceRepo   := "https://github.com/webgpu-native/webgpu-headers"
    sourceCommit := "673658bc2bd70ec39fc55ebe6bb0173cf6d0a603"
    sourceDate   := "2026-05-07"
    pinnedBy     := "wgpu-native v29.0.1.1"
  }
  let expected := dedent "
    /-
    ================================================================================
      GENERATED FILE: DO NOT EDIT BY HAND

      Generator:        webgpu-gen
      Generator commit: 3500dab (clean)
      Generated:        2026-11-02 17:05:12 UTC
      Source:           vendor/webgpu-headers/webgpu.yml
      Source repo:      https://github.com/webgpu-native/webgpu-headers
      Source commit:    673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
      Source date:      2026-05-07
      Source pinned by: wgpu-native v29.0.1.1
    ================================================================================
    -/
    module

    public import WebGPU.Raw.CEnum
    import WebGPU.Raw.Internal.CEnum

    /-!
    # Enums and bitflags

    Every enum and bitflag type in `webgpu.h`, with the codes and values it gives
    them.

    Each `c_enum` declares an enum and its `CEnum` instance: `CEnum.toC` gives a
    value's code in `webgpu.h`, and `CEnum.ofC?` the value a code stands for. Each
    bitflag type wraps its bits, with a constant per flag: combine flags with `|||`
    and mask them with `&&&`.
    -/

    @[expose] public section

    namespace WebGPU.Raw

    c_enum FeatureLevel where
      /--
      Indicates no value is passed for this argument. See [SentinelValues].

      [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
      -/
      | undefined = 0x00000000
      | core      = 0x00000001

    /-- How a buffer is mapped. -/
    structure MapMode where
      bits : UInt64
      deriving Repr, DecidableEq, Inhabited

    namespace MapMode

    def none : MapMode := ⟨0x0000000000000000⟩
    def read : MapMode := ⟨0x0000000000000001⟩

    instance : OrOp MapMode  := ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩
    instance : AndOp MapMode := ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩

    end MapMode

    end WebGPU.Raw

    end
    "
  let sections := [("SentinelValues", "SentinelValues")]
  (lowerText input sections).map (enumsFile provenance) == some expected

-- A module with no declarations: one blank line inside its namespace.
#guard
  let provenance : Provenance := {
    generator    := ""
    time         := ""
    commit       := ""
    dirty        := false
    source       := ""
    sourceRepo   := ""
    sourceCommit := ""
    sourceDate   := ""
    pinnedBy     := ""
  }
  let empty := moduleFile provenance ["import X"] ["# Nothing"] []
  (empty.splitOn "namespace WebGPU.Raw\n\nend WebGPU.Raw\n").length == 2

-- A struct behind a pointer: the raw declaration takes it, and its bytes,
-- targets and table's index, each typed as its own (`OptBytesOf` and the
-- rest), and the tables; the function passes each, proved by `rfl`, if its
-- `size_t`s fit.
#guard
  let descriptor : Names := ⟨"WGPUDescriptor", "Descriptor"⟩
  let f := function "wgpuDoIt" "doIt" none
    #[arg "desc" (.structPointer descriptor true)] none
  render ((rawDecl f).getD .nil) == dedent "
    /-- The shim behind `doIt`. -/
    @[extern \"lean_wgpuDoIt\"]
    opaque Internal.doIt
        (desc        : @& Option Descriptor)
        (descBytes   : @& OptBytesOf desc)
        (descTargets : @& OptTargetsOf desc)
        (descTable   : @& IndexOf Descriptor)
        (tables      : @& CurrentTablesOf) :
        IO Unit
    "
  && render ((wrapperDecl f).getD .nil) == dedent "
    @[inline]
    def doIt (desc : Option Descriptor) : IO Unit :=
      if CStruct.optSizesFit desc then
        Internal.doIt desc ⟨_, rfl⟩ ⟨_, rfl⟩ ⟨_, rfl⟩ ⟨_, rfl⟩
      else
        throw (IO.userError \"doIt: a size_t too large\")
    "

-- An array: the raw declaration takes it and its block, typed as its own
-- (`ObjectsBlockOf`, `U32sOf`); the function passes the block, proved by
-- `rfl`.
#guard
  let buffers :=
    Value.array (.object ⟨"WGPUBuffer", "Buffer"⟩ false) "bufferCount"
  let f := function "wgpuDoIt" "doIt" none
    #[arg "buffers" buffers, arg "offsets" (.array .uint32 "offsetCount")]
    none
  render ((rawDecl f).getD .nil) == dedent "
    /-- The shim behind `doIt`. -/
    @[extern \"lean_wgpuDoIt\"]
    opaque Internal.doIt
        (buffers      : @& Array Buffer)
        (buffersBlock : @& ObjectsBlockOf buffers)
        (offsets      : @& Array UInt32)
        (offsetsBlock : @& U32sOf offsets) :
        IO Unit
    "
  && render ((wrapperDecl f).getD .nil) == dedent "
    @[inline]
    def doIt (buffers : Array Buffer) (offsets : Array UInt32) : IO Unit :=
      Internal.doIt buffers ⟨_, rfl⟩ offsets ⟨_, rfl⟩
    "

-- Bytes: a `ByteArray`, borrowed by the raw declaration.
#guard
  let f := function "wgpuDoIt" "doIt" none #[arg "data" .bytes] none
  render ((rawDecl f).getD .nil) == dedent "
    /-- The shim behind `doIt`. -/
    @[extern \"lean_wgpuDoIt\"]
    opaque Internal.doIt (data : @& ByteArray) : IO Unit
    "
  && render ((wrapperDecl f).getD .nil) == dedent "
    @[inline]
    def doIt (data : ByteArray) : IO Unit :=
      Internal.doIt data
    "

-- A struct that is of no use without its chain: the function refuses it with
-- an empty chain, as an implementation may abort (wgpu-native does), before
-- checking its `size_t`s.
#guard
  let descriptor : Names := ⟨"WGPUDescriptor", "Descriptor"⟩
  let f := { function "wgpuDoIt" "doIt" none
    #[arg "desc" (.structPointer descriptor false)] none with
    requiredChains := ["desc"] }
  render ((wrapperDecl f).getD .nil) == dedent "
    @[inline]
    def doIt (desc : Descriptor) : IO Unit :=
      if desc.chain.isEmpty then
        throw (IO.userError \"doIt: nothing chained to desc\")
      else
        if CStruct.sizesFit desc then
          Internal.doIt desc ⟨_, rfl⟩ ⟨_, rfl⟩ ⟨_, rfl⟩ ⟨_, rfl⟩
        else
          throw (IO.userError \"doIt: a size_t too large\")
    "

/-! ## Callbacks -/

/-- A callback of every kind of argument a callback can pass. -/
def found : Lowered.Callback := {
  names := ⟨"WGPUFoundCallback", "FoundCallback"⟩
  doc   := ""
  style := .callbackMode
  args  := #[
    arg "status" (.enum ⟨"WGPUMode", "Mode"⟩),
    arg "buffer" (.object bufferNames true),
    arg "message" (.string false)
  ]
}

-- A callback type: the closure's, each argument as C passes it, an enum
-- keeping a code no value has, its doc saying what it is given; the
-- closure's its raw declaration takes, an enum as its code; and the one made
-- of the other, decoding each enum.
#guard
  (callbackDecl found).map render == some (dedent "
    /--
    A closure C runs once, as a callback, given `status`, `buffer` and `message`.
    -/
    abbrev FoundCallback :=
      Except UInt32 Mode → Option Buffer → String → IO Unit

    /-- A `FoundCallback`, as its raw declaration takes it. -/
    abbrev Internal.FoundCallback :=
      UInt32 → Option Buffer → String → IO Unit

    /-- `f`, as its raw declaration takes it: each enum decoded. -/
    @[inline]
    def Internal.FoundCallback.raw
        (f : WebGPU.Raw.FoundCallback) :
        Internal.FoundCallback :=
      fun status buffer message => f (CEnum.decode status) buffer message
    ")

-- A function that takes a callback: its raw declaration takes the mode's
-- code and the closure, borrowed (`Internal.FoundCallback`); the function
-- takes the mode and the closure, which it makes the raw one, and makes a
-- `Future` of the ID the shim returns.
#guard
  let f := { function "wgpuDoIt" "doIt" none #[arg "label" (.string false)]
    (some .future) with callback := some found }
  printFunction f == dedent "
    /-- The shim behind `doIt`. -/
    @[extern \"lean_wgpuDoIt\"]
    opaque Internal.doIt
        (label        : @& String)
        (callbackMode : UInt32)
        (callback     : @& Internal.FoundCallback) :
        IO UInt64

    @[inline]
    def doIt
        (label        : String)
        (callbackMode : CallbackMode)
        (callback     : FoundCallback) :
        IO Future :=
      Future.mk <$> Internal.doIt
          label
          (CEnum.toC callbackMode)
          (Internal.FoundCallback.raw callback)
    "

-- A callback the spec leaves undocumented, as it does each (its doc is
-- `TODO`), is documented by what it is given. (A regression test: none was.)
#guard
  ((callbackDecl { found with doc := "TODO" }).map render).any
    (·.startsWith "/--\nA closure C runs once, as a callback, given")

-- A callback with no enum argument is its own raw closure.
#guard
  let done := { found with args := #[arg "message" (.string false)] }
  ((callbackDecl done).map render).any (·.endsWith "  f\n")

/-- A device's lost callback: an object C lends it, a reason and a message. -/
def lost : Lowered.Callback := {
  names := ⟨"WGPUDeviceLostCallback", "DeviceLostCallback"⟩
  doc   := ""
  style := .callbackMode
  args  := #[
    arg "device" (.lentObject ⟨"WGPUDevice", "Device"⟩),
    arg "reason" (.enum ⟨"WGPUReason", "Reason"⟩),
    arg "message" (.string false)
  ]
}

-- A callback a struct keeps may be called again; the object C lends it is
-- not given to the closure.
#guard
  ((callbackDecl lost (held := true)).map render).any fun text =>
    text.startsWith (dedent "
      /--
      A closure C runs as a callback, perhaps more than once, given `reason` and
      `message`.
      -/
      abbrev DeviceLostCallback :=
        Except UInt32 Reason → String → IO Unit
      ")

-- What a struct keeps of a callback: its info, the closure and its mode,
-- `allowSpontaneous` unless given; and what the encoder writes of it: its
-- mode's code, its closure as a `Closure`, and the address C calls, its
-- trampoline's, or 0 for none.
#guard
  render (callbackInfoDecl lost true) == dedent "
    /-- A `DeviceLostCallback` C keeps, in a struct. -/
    structure DeviceLostCallbackInfo where
      /-- The mode it is registered with. -/
      mode     : CallbackMode       := .allowSpontaneous
      /-- The closure. -/
      callback : DeviceLostCallback

    /-- An `Internal.DeviceLostCallback`, as the `Closure` its family holds. -/
    @[extern c inline \"#1\"]
    opaque Internal.DeviceLostCallback.toClosure :
        Internal.DeviceLostCallback → Closure

    /-- The address of the trampoline of `DeviceLostCallback`, for C to call. -/
    @[extern \"lean_WGPUDeviceLostCallback_address\"]
    opaque Internal.DeviceLostCallback.address : Unit → UInt64

    /-- What the encoder writes of a `DeviceLostCallbackInfo`. -/
    instance : KeptCallback DeviceLostCallbackInfo where
      mode i      := CEnum.toC i.mode
      closure i   := Internal.DeviceLostCallback.toClosure
        (Internal.DeviceLostCallback.raw i.callback)
      address     := Internal.DeviceLostCallback.address ()
      noneAddress := 0
    "

-- An uncaptured error's, with no mode; and for none, the address of the
-- bindings' own handler, as wgpu-native's default ends the program.
#guard
  let error := { lost with
    names := ⟨"WGPUUncapturedErrorCallback", "UncapturedErrorCallback"⟩
    style := .immediate }
  let text := render (callbackInfoDecl error false)
  (text.splitOn "mode :").length == 1
    && (text.splitOn "mode _      := 0").length == 2
    && (text.splitOn "noneAddress := Internal.UncapturedErrorCallback.\
      defaultAddress ()").length == 2
    && (text.splitOn
      "@[extern \"lean_WGPUUncapturedErrorCallback_default_address\"]").length
      == 2

-- A function whose struct keeps callbacks is given one of defaults for none,
-- the same to WebGPU: so the bindings' own uncaptured-error handler is
-- installed, where C's NULL would leave wgpu-native's, which ends the program.
#guard
  let descriptor : Names := ⟨"WGPUDescriptor", "Descriptor"⟩
  let f := { function "wgpuDoIt" "doIt" none
    #[arg "desc" (.structPointer descriptor true)] none with
    heldInfos := [⟨"desc", "lost", true, 0⟩] }
  ((wrapperDecl f).map render).any fun text =>
    (text.splitOn "  let desc := some (desc.getD {})\n").length == 2

end WebGPUGenTest.Emit.Lean
