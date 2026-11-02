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

end WebGPUGenTest.Emit.Lean
