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

/-- Lines as one text, for comparing with a `dedent` literal. -/
def text (lines : List String) : String := "\n".intercalate lines ++ "\n"

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
  ((lowerText input).bind (·.enums[0]?)).map (text ∘ enumDecl) == some expected

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
  ((lowerText input).bind (·.bitflags[0]?)).map (text ∘ bitflagDecl) == some expected


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
  (lowerText input).map (fun l => text (l.objects.toList.flatMap objectDecl)) == some expected

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
  text (joinDecls input) == expected

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

end WebGPUGenTest.Emit.Lean
