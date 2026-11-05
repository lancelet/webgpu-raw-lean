import WebGPUGen.Emit.Encoders
import WebGPUGenTest.Literal

/-!
# Tests for the encoders

What an encoder writes for each kind of member, on both widths; how that pairs
with the layout model; and a whole struct's declarations, as printed. The
bindings build every generated encoder, with its proofs, and compare one with C.
-/

namespace WebGPUGenTest.Emit.Encoders
open WebGPUGen WebGPUGen.Lowered WebGPUGen.CLayout WebGPUGen.Emit.Encoders

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- A struct of the kind and members given, undocumented. -/
def struct (c lean : String) (kind : Common.StructKind)
    (members : List Member) (sType : Option Names := none) :
    Lowered.Struct where
  names           := ⟨c, lean⟩
  doc             := ""
  kind            := kind
  extendedStructs := #[]
  sType           := sType
  freeMembers     := false
  members         := members.toArray

/-- An undocumented member with no default, named the same on both sides. -/
def member (name : String) (value : Value) : Member :=
  ⟨⟨name, name⟩, "", value, none⟩

/-! ## Items -/

-- Each kind of member: a number by its expression, a float as itself, a
-- pointer left for C; a string its data then its length, an array its count
-- then its elements, a nested struct its own fields.
#guard
  let inner := struct "WGPUInner" "Inner" .standalone [member "n" .uint32]
  let input := struct "WGPUThing" "Thing" .extensible [
    member "label" (.string false),
    member "name" (.string true),
    member "mode" (.enum ⟨"WGPUMode", "Mode"⟩),
    member "usage" (.bitflag ⟨"WGPUUsage", "Usage"⟩),
    member "on" .bool,
    member "depth" .nullableFloat32,
    member "scale" .float64,
    member "bias" .int32,
    member "count" .usize,
    member "buffer" (.object ⟨"WGPUBuffer", "Buffer"⟩ false),
    member "items" (.array .uint32 "itemCount"),
    member "inner" (.struct inner.names)
  ]
  let expected (w : String) (size : String) : List Item := [
    .pointer .next,
    .pointer (.string "d.label"), .int s!"d.label.utf8ByteSize.toUInt{w}",
    .pointer (.optString "d.name"), .int s!"viewLength{w} d.name",
    .int "CEnum.toC d.mode",
    .int "d.usage.bits",
    .int "wgpuBool d.on",
    .int "nanOr d.depth",
    .float "d.scale",
    .int "d.bias.toUInt32",
    .int size,
    .pointer (.object ⟨"WGPUBuffer", "Buffer"⟩ "d.buffer"),
    .int s!"d.items.size.toUInt{w}", .pointer (.array (.words "id") "d.items"),
    .int "d.inner.n"
  ]
  items [inner, input] .bits64 input "d" 3 == some (expected "64" "d.count")
    && items [inner, input] .bits32 input "d" 3
      == some (expected "32" "size32 d.count")

-- An extension starts with its chain: the next pointer, and its SType code.
#guard
  let input := struct "WGPUExtra" "Extra" .extension [member "n" .uint32]
    (sType := some ⟨"WGPUSType_Extra", "extra"⟩)
  items [input] .bits64 input "d" 2
    == some [.pointer .next, .int "CEnum.toC SType.extra", .int "d.n"]

-- A member that cannot be written gives no items.
#guard
  let input := struct "WGPUBad" "Bad" .standalone
    [member "f" (.unsupported "callback")]
  (items [input] .bits64 input "d" 2).isNone

-- The `size_t` members, however deep, for `sizesFit`.
#guard
  let inner := struct "WGPUInner" "Inner" .standalone [member "n" .usize]
  let input := struct "WGPUOuter" "Outer" .standalone [
    member "count" .usize,
    member "inner" (.struct inner.names),
    member "x" .uint32
  ]
  sizeChecks [inner, input] input "d" 3
    == some ["sizeFits d.count", "sizeFits d.inner.n"]

-- And behind a pointer, or in an array's elements: each checked where it is.
-- (A regression test: `sizesFit` missed a `size_t` behind a pointer.)
#guard
  let inner := struct "WGPUInner" "Inner" .standalone [member "n" .usize]
  let input := struct "WGPUOuter" "Outer" .standalone [
    member "maybe" (.structPointer inner.names true),
    member "always" (.structPointer inner.names false),
    member "many" (.array (.struct inner.names) "manyCount"),
    member "sizes" (.array .usize "sizeCount")
  ]
  sizeChecks [inner, input] input "d" 3 == some [
    "(d.maybe.all fun x0 => sizeFits x0.n)",
    "sizeFits d.always.n",
    "(d.many.all fun x0 => sizeFits x0.n)",
    "(d.sizes.all fun x0 => sizeFits x0)"
  ]

-- Nested: each element's pointee checked in its own `all`, named by depth.
#guard
  let inner := struct "WGPUInner" "Inner" .standalone [member "n" .usize]
  let middle := struct "WGPUMiddle" "Middle" .standalone [
    member "p" (.structPointer inner.names true)
  ]
  let input := struct "WGPUOuter" "Outer" .standalone [
    member "many" (.array (.struct middle.names) "manyCount")
  ]
  sizeChecks [inner, middle, input] input "d" 4
    == some ["(d.many.all fun x0 => (x0.p.all fun x1 => sizeFits x1.n))"]

-- Too deep for its fuel: none, not no checks.
#guard
  let inner := struct "WGPUInner" "Inner" .standalone [member "n" .usize]
  let input := struct "WGPUOuter" "Outer" .standalone [
    member "many" (.array (.struct inner.names) "manyCount")
  ]
  sizeChecks [inner, input] input "d" 1 == none

-- An encoder checks a `size_t` however deep its arrays nest. (A regression
-- test: three arrays deep, the encoder ran out of fuel and checked nothing.)
#guard
  let s3 := struct "WGPUS3" "S3" .standalone [member "n" .usize]
  let s2 := struct "WGPUS2" "S2" .standalone
    [member "xs" (.array (.struct s3.names) "xsCount")]
  let s1 := struct "WGPUS1" "S1" .standalone
    [member "xs" (.array (.struct s2.names) "xsCount")]
  let s0 := struct "WGPUS0" "S0" .standalone
    [member "xs" (.array (.struct s1.names) "xsCount")]
  let printed := (structEncoders [s3, s2, s1, s0] [] s0).map
    (Emit.Doc.pretty Emit.width)
  printed.any fun text => (text.splitOn "sizeFits x2.n").length > 1

/-! ## Entries -/

-- Items paired with the layout model's scalars: a buffer descriptor, on both
-- widths, as `layouts.c` checks it against `webgpu.h`.
#guard
  let input := struct "WGPUBufferDescriptor" "BufferDescriptor" .extensible [
    member "label" (.string false),
    member "usage" (.bitflag ⟨"WGPUBufferUsage", "BufferUsage"⟩),
    member "size" .uint64,
    member "mappedAtCreation" .bool
  ]
  let offsets (w : Width) :=
    (structEntries [input] w input).map fun (size, entries) =>
      (size, entries.map (·.1))
  offsets .bits64 == some (48, [0, 8, 16, 24, 32, 40])
    && offsets .bits32 == some (40, [0, 4, 8, 16, 24, 32])

/-! ## Relocations -/

-- A table's bytes, as `WebGPU.Raw.Reloc.serialize` lays them out (the bindings
-- check the same bytes): the size, the count, then each offset, code, table.
#guard tableBytes 0x10203 [(8, 4, 5)] == [
  0x03, 0x02, 0x01, 0, 1, 0, 0, 0,
  8, 0, 0, 0, 4, 0, 0, 0, 5, 0, 0, 0
]

-- Each kind of pointer: its name, its code and its table; a block's table its
-- struct's index; an array of numbers or objects a block of a shared table;
-- an array of anything else, not yet filled in, none.
#guard
  let inner : Names := ⟨"WGPUInner", "Inner"⟩
  let index (names : Names) := if names == inner then some 7 else none
  let pointers : List Pointer := [
    .next, .string "d.a", .optString "d.b",
    .object ⟨"WGPUBuffer", "Buffer"⟩ "d.c",
    .optObject ⟨"WGPUBuffer", "Buffer"⟩ "d.e",
    .struct inner "d.f" false,
    .array (.words "id") "d.g",
    .array (.objects ⟨"WGPUBuffer", "Buffer"⟩) "d.h",
    .array (.structs inner) "d.i",
    .array .other "d.j",
    .chain inner "d.chain"
  ]
  pointers.map (kind index) == [
    some (".null", 7, 0),
    some (".string", 0, 0),
    some (".optString", 1, 0),
    some (".object", 2, 0),
    some (".optObject", 3, 0),
    some (".block 7", 4, 7),
    some (".block 0", 4, 0),
    some (".block 1", 4, 1),
    some (".block 7", 4, 7),
    none,
    some (".chain", 5, 0)
  ]

-- The structs with tables: each after those it points to, by its index; not
-- one with an array of strings, nor one that points to one with no table.
#guard
  let leaf := struct "WGPULeaf" "Leaf" .standalone [member "s" (.string false)]
  let listed := struct "WGPUListed" "Listed" .standalone
    [member "xs" (.array (.string false) "xsCount")]
  let top := struct "WGPUTop" "Top" .standalone [
    member "leaf" (.structPointer leaf.names true)
  ]
  let above := struct "WGPUAbove" "Above" .standalone [
    member "listed" (.structPointer listed.names false)
  ]
  (tabled [leaf, listed, top, above]).map (·.names.lean)
    == ["Leaf", "Top"]

-- An array's targets: of numbers, its block; of objects, its block of handles
-- then its objects; of structs, its block and its elements' targets.
#guard
  let buffer : Names := ⟨"WGPUBuffer", "Buffer"⟩
  let inner : Names := ⟨"WGPUInner", "Inner"⟩
  let ps := [
    pieces .bits64 (.array (.words "CEnum.toC") "d.a"),
    pieces .bits32 (.array (.objects buffer) "d.b"),
    pieces .bits64 (.array (.structs inner) "d.c")
  ]
  ps.map (piecesLines 2) == [
    ["#[.block (encodeU32s CEnum.toC d.a)]"],
    ["#[.block (objectsBlock 4 d.b)] ++ " ++
      "objectsOf Internal.Buffer.toObject d.b"],
    ["Inner.array64 d.c"]
  ]

-- The elements of arrays: each struct once, of the structs with tables.
#guard
  let leaf := struct "WGPULeaf" "Leaf" .standalone [member "n" .uint32]
  let a := struct "WGPUA" "A" .standalone
    [member "xs" (.array (.struct leaf.names) "xsCount")]
  let b := struct "WGPUB" "B" .standalone
    [member "ys" (.array (.struct leaf.names) "ysCount")]
  arrayed [leaf, a, b] [leaf, a, b] == [leaf.names]

-- A struct that is the element of an array: its array's encoder, its size,
-- its targets and both, after its own.
#guard
  let input := struct "WGPUOne" "One" .standalone [member "s" (.string false)]
  let decls (isArrayed : Bool) :=
    match structEntries [input] .bits64 input with
    | some (size, entries) =>
      relocDecls [input] input .bits64 size entries (fun _ => none) isArrayed
    | none => none
  let tail := (decls true).map fun ds =>
    ds.drop ((decls false).getD []).length
  tail == some [
    ["/-- `d` poked into `b` at `off`, as `encode64` lays it out. -/",
      "@[inline]",
      "def encodeInto64 {total : Nat} (b : Block total) (off : Nat)",
      "    (h : off + 16 ≤ total) (d : One) :",
      "    Block total :=",
      "  let b := b.pokeU64 (off + 8) d.s.utf8ByteSize.toUInt64 (by omega)",
      "  b"],
    ["/-- An array of them, encoded in turn into one block, on 64-bit " ++
        "targets. -/",
      "@[noinline, never_extract]",
      "def encodeAll64 (xs : Array One) : ByteArray :=",
      "  (go 0 (Block.fresh (xs.size * 16))).1",
      "where",
      "  /-- Each element from the `i`th on, encoded into `b`. -/",
      "  go (i : Nat) (b : Block (xs.size * 16)) :",
      "      Block (xs.size * 16) :=",
      "    if h : i < xs.size then",
      "      go (i + 1) (encodeInto64 b (i * 16) (by omega) xs[i])",
      "    else b",
      "  termination_by xs.size - i"],
    ["/-- An array of them is their size. -/",
      "theorem size_encodeAll64 (xs : Array One) :",
      "    (encodeAll64 xs).size = xs.size * 16 :=",
      "  (encodeAll64.go xs 0 (Block.fresh (xs.size * 16))).2"],
    ["/-- What C fills in an array of them's pointers from on 64-bit " ++
        "targets. -/",
      "@[never_extract]",
      "def targetsAll64 (xs : Array One) : Array Target :=",
      "  targetsOfAll targets64 xs"],
    ["/-- An array of them as a block on 64-bit targets, and its targets. -/",
      "@[never_extract]",
      "def array64 (xs : Array One) : Array Target :=",
      "  #[.block (encodeAll64 xs)] ++ targetsAll64 xs"]
  ]

-- Targets: each run of targets one literal, joined with arrays by `++`; on one
-- line if they fit, else each run on its own, and a long literal one a line.
#guard
  let ps := [Piece.target ".string d.a", .target ".string d.b",
    .targets "Inner.block64 d.c", .target ".string d.e"]
  piecesLines 2 ps
    == ["#[.string d.a, .string d.b] ++ Inner.block64 d.c ++ #[.string d.e]"]
  && piecesLines 2 [] == ["#[]"]
  && piecesLines 60 ps == [
    "#[", "  .string d.a,", "  .string d.b", "]",
    "++ Inner.block64 d.c", "++ #[.string d.e]"
  ]
  -- An array too long for its line is left on its own.
  && piecesLines 70 [.targets "Inner.block64 d.c", .targets "Inner.block64 d.e"]
    == ["Inner.block64 d.c", "++ Inner.block64 d.e"]

-- A struct nested by value keeps its own chain: a null relocation at its
-- offset in the outer struct, after the outer one's.
#guard
  let inner := struct "WGPUInner" "Inner" .extensible [member "n" .uint32]
  let input := struct "WGPUOuter" "Outer" .extensible [
    member "label" (.string false),
    member "inner" (.struct inner.names)
  ]
  let printed := (structEncoders [inner, input] [inner, input] input).map
    (Emit.Doc.pretty Emit.width)
  let has (s : String) := printed.any fun text => (text.splitOn s).length > 1
  has "⟨0, .null⟩, ⟨8, .string⟩, ⟨24, .null⟩"
    && has "⟨0, .null⟩, ⟨4, .string⟩, ⟨12, .null⟩"
    && has "def targets64 (d : Outer) : Array Target :=\n  #[.string d.label]"

-- A struct's relocations, table, proofs and targets, as printed: a chain, a
-- string, and an optional struct with a table, a block of its own.
#guard
  let inner := struct "WGPUInner" "Inner" .standalone [member "n" .uint32]
  let input := struct "WGPUOuter" "Outer" .extensible [
    member "label" (.string false),
    member "inner" (.structPointer inner.names true)
  ]
  let printed := (structEncoders [inner, input] [inner, input] input).map
    (Emit.Doc.pretty Emit.width)
  let has (s : String) := printed.any fun text => (text.splitOn s).length > 1
  has ("noncomputable def relocs64 : List Reloc := [\n" ++
      "  ⟨0, .null⟩, ⟨8, .string⟩, ⟨24, .block 2⟩\n]")
    && has "theorem table64_eq : table64 = serialize 32 relocs64 := rfl"
    && has ("theorem relocs64_offsets : " ++
      "relocs64.map (·.offset) = pointers64 :=\n  rfl")
    && has ("def targets64 (d : Outer) : Array Target :=\n" ++
      "  #[.string d.label] ++ optBlock Inner.block64 d.inner")
    && has "def tableIndex : Nat := 3"

/-! ## Chains -/

-- A struct with extensions: its chain is filled in from its `chain` field, its
-- links each by its own encoder, table and targets, and walked by each one's
-- walk, each table before its own.
#guard
  let wgsl := struct "WGPUWGSL" "WGSL" .extension
    [member "code" (.string false)] (sType := some ⟨"WGPUSType_WGSL", "wgsl"⟩)
  let input := { struct "WGPUModule" "Module" .extensible
    [member "label" (.string false)] with extensions := #[wgsl.names] }
  let entries := (structEntries [wgsl, input] .bits64 input).map (·.2)
  let decls := match structEntries [wgsl, input] .bits64 input with
    | some (size, entries) =>
      (relocDecls [wgsl, input] input .bits64 size entries
        (fun n => if n == wgsl.names then some 2 else none) false).getD []
    | none => []
  let walks := match structEntries [wgsl, input] .bits64 input with
    | some (size, entries) => walkDecls input .bits64 size entries 3 false
    | none => []
  let printed := "\n".intercalate (decls ++ walks).flatten
  let has (s : String) := (printed.splitOn s).length > 1
  entries.map (·.head?.map (·.2.2)) == some (some (.pointer
      (.chain input.names "d.chain")))
    && has ("def targets64 (d : Module) : Array Target :=\n" ++
      "  #[.chain (d.chain.map Module.chainLink64)]\n" ++
      "  ++ targetsOfAll Module.chainTargets64 d.chain")
    && has ("def chainLink64 : Chained → ByteArray × Nat\n" ++
      "  | .wgsl x => (WGSL.encode64 x, WGSL.tableIndex)")
    && has ("def chainTargets64 : Chained → Array Target\n" ++
      "  | .wgsl x => WGSL.targets64 x")
    && has "theorem chainLink64_isLink (c : Chained) :"
    && has "theorem walk_chain64 {table : Nat}"
    && has "Module.walk_chain64 (table := 3) (by decide)"

/-! ## Callbacks kept -/

-- A callback a struct keeps: its info's chain, null; its mode, 0 for none;
-- its trampoline's address; its closure, which the family being filled holds
-- at the ordinal; and the ordinal, for the trampoline, 0 for none. The
-- address and the ordinal are pointer-sized numbers on each width.
#guard
  let lost : Names := ⟨"WGPUDeviceLostCallback", "DeviceLostCallback"⟩
  let input := struct "WGPUDescriptor" "Descriptor" .standalone
    [member "lost" (.callbackInfo lost true 1)]
  let laid (w : Width) := (structEntries [input] w input).map fun (size, es) =>
    (size, es.map fun (o, _, i) => (o, i))
  laid .bits64 == some (40, [
      (0,  .pointer .next),
      (8,  .int "(d.lost.map (CEnum.toC ·.mode)).getD 0"),
      (16, .int "Internal.DeviceLostCallbackInfo.addressOf d.lost"),
      (24, .pointer (.closure lost 1 "d.lost")),
      (32, .int "if d.lost.isSome then (1 : UInt64) else 0")
    ])
    && (laid .bits32).map (·.1) == some 20
    && kind (fun _ => none) (.closure lost 1 "d.lost")
      == some (".optClosure 1", 6, 1)
    && piecesLines 2 (pieces .bits64 (.closure lost 1 "d.lost")) == [
      "#[.optClosure (d.lost.map Internal.DeviceLostCallbackInfo.closure)]"
    ]

/-! ## Walks -/

-- `simp` on one line if it fits, else its lemmas filled below it.
#guard
  let long (s : String) := s ++ String.ofList (List.replicate 29 '_')
  simpLines 2 ["a", "b"] == ["  simp [a, b]"]
    && simpLines 2 [long "a", long "b", long "c"] == [
      "  simp [",
      s!"    {long "a"}, {long "b"},",
      s!"    {long "c"}]"
    ]

-- A struct's walk proofs: its index; its element's walk, a case for each
-- optional struct, by that struct's block, walk and empty walk, and an array
-- of enums by `walk_words`; its walk from its element's; and, as it is the
-- element of an array, an array of them's.
#guard
  let inner := struct "WGPUInner" "Inner" .standalone
    [member "s" (.string false)]
  let input := struct "WGPUOuter" "Outer" .extensible [
    member "inner" (.structPointer inner.names true),
    member "xs" (.array (.enum ⟨"WGPUMode", "Mode"⟩) "xsCount")
  ]
  let lines := match structEntries [inner, input] .bits64 input with
    | some (size, entries) => walkDecls input .bits64 size entries 3 true
    | none                 => []
  lines == [
    ["/-- Its index finds its table as the walk reads it. -/",
      "theorem getElem?_specs64 :",
      "    specs64[3]? = some (32, relocs64) :=",
      "  rfl"],
    ["/-- An element's walk takes exactly its targets. -/",
      "theorem element_targets64 (d : Outer) (ts : List Target) :",
      "    element specs64 3 relocs64",
      "      ((targets64 d).toList ++ ts) = some ts := by",
      "  cases h0 : d.inner <;>",
      "    simp [",
      "      element, relocs64, targets64, step, optBlock, h0, Inner.block64,",
      ("      Inner.walk_encode64, " ++
        "walk_empty Inner.getElem?_specs64 (by decide),"),
      "      walk_words getElem?_specs64_words]"],
    ["/-- Walking its table over its bytes takes exactly its targets. -/",
      "theorem walk_encode64 (d : Outer) (ts : List Target) :",
      "    walk specs64 3 (encode64 d).size",
      "      ((targets64 d).toList ++ ts) = some ts :=",
      ("  walk_one getElem?_specs64 (by decide) d " ++
        "(fun d => (targets64 d).toList) _"),
      "    (size_encode64 d) (element_targets64 d) ts"],
    ["/-- The same, at its index. -/",
      "theorem walk_encode64_tableIndex (d : Outer) (ts : List Target) :",
      "    walk specs64 tableIndex (encode64 d).size",
      "      ((targets64 d).toList ++ ts) = some ts :=",
      "  walk_encode64 d ts"],
    ["/-- Walking an array of them takes exactly their targets, in turn. -/",
      "theorem walk_encodeAll64 (xs : Array Outer) (ts : List Target) :",
      "    walk specs64 3 (encodeAll64 xs).size",
      "      ((targetsAll64 xs).toList ++ ts) = some ts := by",
      "  rw [targetsAll64, toList_targetsOfAll]",
      "  exact walk_elements getElem?_specs64 (by decide) xs.toList",
      "    (fun d => (targets64 d).toList) _",
      "    (by rw [size_encodeAll64, Array.length_toList])",
      "    (fun d _ => element_targets64 d) ts"]
  ]

-- Several optional structs, one in a struct held by value: a case for each,
-- by its path, the lemmas for a struct they share once.
#guard
  let inner := struct "WGPUInner" "Inner" .standalone
    [member "s" (.string false)]
  let middle := struct "WGPUMiddle" "Middle" .standalone
    [member "c" (.structPointer inner.names true)]
  let input := struct "WGPUOuter" "Outer" .standalone [
    member "a" (.structPointer inner.names true),
    member "b" (.structPointer inner.names true),
    member "mid" (.struct middle.names)
  ]
  let lines := match structEntries [inner, middle, input] .bits64 input with
    | some (size, entries) => walkDecls input .bits64 size entries 2 false
    | none                 => []
  let proof := (lines.drop 1).head?.getD []
  proof.drop 4 == [
    "  cases h0 : d.a <;>",
    "  cases h1 : d.b <;>",
    "  cases h2 : d.mid.c <;>",
    "    simp [",
    ("      element, relocs64, targets64, step, optBlock, h0, h1, h2, " ++
      "Inner.block64,"),
    "      Inner.walk_encode64, walk_empty Inner.getElem?_specs64 (by decide)]"
  ]

/-! ## Printing -/

-- A struct of one field: its fields, pointers, proofs, and encoders.
#guard
  let input := struct "WGPUOne" "One" .standalone [member "n" .uint32]
  let expected := dedent "
    /-! ### `One` -/

    namespace One

    /-- The scalar fields on 64-bit targets: the specification. -/
    def fields64 : List (Field One) := [
      ⟨0, .u32, fun d => (d.n).toNat⟩
    ]

    /-- The pointers on 64-bit targets, for C to fill in. -/
    def pointers64 : List Nat := []

    /-- The fields are well-formed: in order, apart, within the struct. -/
    theorem fields64_wellFormed : Fields.WellFormed .bits64 4 fields64 := by
      unfold Fields.WellFormed; decide

    /-- The pointers are within the struct. -/
    theorem pointers64_within :
        ∀ o ∈ pointers64, o + 8 ≤ 4 := by
      decide

    /-- The pointers are apart from every field. -/
    theorem pointers64_apart :
        ∀ o ∈ pointers64, ∀ f ∈ fields64,
          f.offset + f.scalar.bytes .bits64 ≤ o ∨ o + 8 ≤ f.offset := by
      decide

    /-- `d` as C lays it out on 64-bit targets, its pointers 0. -/
    @[noinline, never_extract]
    def encode64 (d : One) : ByteArray :=
      let b := Block.fresh 4
      let b := b.pokeU32 0 d.n (by decide)
      b.1

    /-- The encoder is `encode` of the fields: `readLE_encode` holds of it. -/
    theorem encode64_eq (d : One) :
        encode64 d = Encode.encode .bits64 4 fields64 d := by
      simp only [
        encode64, Encode.encode, fields64, Block.val_fresh, Block.val_pokeU32,
        List.map, Field.write, writeAll, List.foldl, Scalar.bytes, Width.bytes]

    /-- Its encoding is its size. -/
    theorem size_encode64 (d : One) :
        (encode64 d).size = 4 := by
      rw [encode64_eq, size_encode]

    /-- Its pointers read as 0, for C to fill in. -/
    theorem encode64_pointers (d : One) :
        ∀ o ∈ pointers64, readLE (encode64 d) o 8 = 0 :=
      fun o ho => by
        rw [encode64_eq]
        exact readLE_encode_apart d o 8 (pointers64_apart o ho)
    "
  (structEncoders [input] [] input).map (fun d => Emit.Doc.pretty Emit.width d)
    |>.map (fun text => text.startsWith expected) == some true

end WebGPUGenTest.Emit.Encoders
