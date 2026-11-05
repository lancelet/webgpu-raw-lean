import WebGPUGen.Emit.Lean
import WebGPUGen.Lowered.CFields
import WebGPUGen.Lowered.BoundStructs

/-!
# Encoders

`WebGPU/Raw/Encoders.lean`: for each bound struct, its encoders, which write a
value of it as C lays it out, its pointers left 0 for C to fill in. For each
target width, a struct has:

- its scalar fields, each an offset, a kind of scalar, and the number its bytes
  hold (`fields64`), the specification, and its pointers' offsets
  (`pointers64`);
- an encoder (`encode64`): a fresh block, then a poke for each field, each
  bound proved by `decide`, the encoder `@[noinline]` as the pokes require,
  and `@[never_extract]`;
- proofs that its fields are well-formed, that the encoder is `encode` of its
  fields, and that its pointers read as 0;
- if each of its pointers can be filled in yet (not an array of any element
  but an enum, a `UInt32`, an object or a struct, nor a pointer to a struct
  that has no table), its relocations (`relocs64`), each
  a pointer's offset and kind, and its table, their bytes for C (`table64`),
  proved to be every pointer and only them, and `serialize` of them; and what
  C fills each pointer in from (`targets64`), and itself as a block, both
  `@[never_extract]`, so that no block is a constant; and if it is the
  element of an array, an array of them encoded in turn (`encodeAll64`), their
  targets (`targetsAll64`), and both (`array64`). An array of enums is a
  block of `UInt32`s, of objects a block of handles, each by one of two
  shared tables;
- and, with every table known, at the end: that walking its table over its
  bytes (`WebGPU.Raw.Reloc.walk`, as C does) takes exactly its targets
  (`walk_encode64`), each of its kind, a pointer to a struct by that
  struct's own, an array by its elements' (`walk_encodeAll64`); and, for the
  target the program runs on, the same (`walk_toBytes`), and its instance of
  `CStruct`.

Every struct's table is in `tables64`, at its `tableIndex`; each object type
converts to the `Object` a pointer to one is filled in from.

The fields follow the layout model (`CLayout`), which the C compiler checks
against `webgpu.h` (`layouts.c`): a struct's members in order, a nested struct
by value its own fields, a string its data and its length, an array its count
and its elements.
-/

namespace WebGPUGen.Emit.Encoders
open WebGPUGen.Lowered WebGPUGen.CLayout WebGPUGen.Emit Doc

/-! ## What each scalar holds -/

/-- What an array's elements are, as C fills in a pointer to them. -/
inductive ArrayOf where
  /-- Numbers of 4 bytes, each by this conversion from its element. -/
  | words   (convert : String)
  /-- Objects of the type with these names. -/
  | objects (names : Names)
  /-- Structs with these names, each encoded in turn. -/
  | structs (names : Names)
  /-- Anything else: not yet filled in. -/
  | other
  deriving Repr, BEq

/--
What a pointer of a struct points to, and the Lean expression of what C fills
it in from: a member of a value at `d`.
-/
inductive Pointer where
  /--
  A struct chain's next, left null: an extension's, which C links, or one no
  extension can join.
  -/
  | next
  /-- The chain of the struct with these names: its `chain` field, at `expr`. -/
  | chain     (names : Names) (expr : String)
  | string    (expr : String)
  | optString (expr : String)
  /-- An object of the type with these names. -/
  | object    (names : Names) (expr : String)
  | optObject (names : Names) (expr : String)
  /-- A struct with these names, encoded as a block of its own. -/
  | struct    (names : Names) (expr : String) (nullable : Bool)
  /-- An array's elements. -/
  | array     (of : ArrayOf) (expr : String)
  /--
  A callback's closure, of the type with these names, held by the family
  being filled at `ordinal`: its info, an `Option`, at `expr`.
  -/
  | closure   (names : Names) (ordinal : Nat) (expr : String)
  deriving Repr, BEq

/-- What an encoder writes for one scalar of a struct. -/
inductive Item where
  /-- A number, by a Lean expression of the unsigned type of its width. -/
  | int (expr : String)
  /-- A `float` or `double`, by a Lean expression of `Float32` or `Float`. -/
  | float (expr : String)
  /-- A pointer, left 0 for C to fill in, and what it points to. -/
  | pointer (to : Pointer)
  deriving Repr, BEq

/-- Whether an item is a pointer. -/
def Item.isPointer : Item → Bool
  | .pointer _ => true
  | _          => false

/-- The Lean type a `size_t` is written as, on a width. -/
def sizeType : Width → String
  | .bits32 => "UInt32"
  | .bits64 => "UInt64"

/-- The width's suffix on a struct's declarations: `64` or `32`. -/
def suffix : Width → String
  | .bits32 => "32"
  | .bits64 => "64"

/-- `SIZE_MAX` on a width: the length of a null string view. -/
def sizeMax : Width → String
  | .bits32 => "0xFFFFFFFF"
  | .bits64 => "0xFFFFFFFFFFFFFFFF"

/--
The items of a struct's scalars, its value at `path`, in the order of its C
fields' scalars; none if a member cannot be written. `fuel` bounds the
nesting of structs by value.
-/
def items (structs : List Struct) (w : Width) (s : Struct) (path : String) :
    Nat → Option (List Item)
  | 0 => none
  | fuel + 1 => do
    let chain ← match s.kind with
      | .extensible | .extensibleCallbackArg => some [Item.pointer
        (if s.extensions.isEmpty then .next
          else .chain s.names s!"{path}.chain")]
      | .extension => s.sType.map fun e =>
        [Item.pointer .next, .int s!"CEnum.toC SType.{e.lean}"]
      | .standalone => some []
    let members ← s.members.toList.mapM fun m =>
      member fuel m.value s!"{path}.{m.names.lean}"
    pure (chain ++ members.flatten)
where
  /-- The items of a member of value `v`, at `q`. -/
  member (fuel : Nat) (v : Value) (q : String) : Option (List Item) :=
    match v with
    | .bool                         => some [.int s!"wgpuBool {q}"]
    | .uint16 | .uint32 | .uint64   => some [.int q]
    | .int16                        => some [.int s!"{q}.toUInt16"]
    | .int32                        => some [.int s!"{q}.toUInt32"]
    | .float32 | .float64           => some [.float q]
    -- C's NaN, 0x7FC00000, for none, as `WGPU_DEPTH_CLEAR_VALUE_UNDEFINED`.
    | .nullableFloat32              => some [.int s!"nanOr {q}"]
    | .enum _                       => some [.int s!"CEnum.toC {q}"]
    | .bitflag _                    => some [.int s!"{q}.bits"]
    | .object names false           => some [.pointer (.object names q)]
    | .object names true            => some [.pointer (.optObject names q)]
    | .structPointer names b        => some [.pointer (.struct names q b)]
    -- A string view: its data, then its length; a null view's is `SIZE_MAX`.
    | .string false                 =>
      some [.pointer (.string q), .int s!"{q}.utf8ByteSize.to{sizeType w}"]
    | .string true                  =>
      some [.pointer (.optString q), .int s!"viewLength{suffix w} {q}"]
    -- An array: its count, then a pointer to its elements.
    | .array element _ =>
      let of := match element with
        | .enum _               => ArrayOf.words "CEnum.toC"
        | .uint32               => .words "id"
        | .object names false   => .objects names
        | .struct names         => .structs names
        | _                     => .other
      some [.int s!"{q}.size.to{sizeType w}", .pointer (.array of q)]
    | .struct names => do
      let nested ← structs.find? (·.names.c == names.c)
      items structs w nested q fuel
    -- A `size_t`: on wasm32, its low 32 bits, or `SIZE_MAX` for the largest
    -- `UInt64`; `sizesFit` says whether it fits, for the caller to check.
    | .usize => some [.int (match w with
      | .bits64 => q
      | .bits32 => s!"size32 {q}")]
    -- A callback's info: its chain, null; its mode, 0 for none; its
    -- trampoline's address (`addressOf` gives 0, or the bindings' own
    -- handler's, for none); its closure, which the family being filled holds
    -- at its ordinal; and the ordinal, for the trampoline, 0 for none.
    | .callbackInfo names hasMode k =>
      let info := s!"Internal.{names.lean}Info"
      some ([.pointer .next]
        ++ (if hasMode then [.int s!"({q}.map (CEnum.toC ·.mode)).getD 0"]
          else [])
        ++ [.int (match w with
            | .bits64 => s!"{info}.addressOf {q}"
            | .bits32 => s!"({info}.addressOf {q}).toUInt32"),
          .pointer (.closure names k q),
          -- Typed, as a bare numeral would be a `Nat`.
          .int s!"if {q}.isSome then ({k} : {sizeType w}) else 0"])
    | .future | .lentObject _ | .unsupported _ => none

/--
The checks that each `size_t` of a value of kind `v`, at `q`, fits the target:
in 32 bits on wasm32, or as the largest `UInt64` (`SIZE_MAX`). However deep: in
a struct, behind a pointer, or in an array's elements, each checked where it
is, the element or pointee named `x` and the depth of `all`s it is in, `n`.
None if the fuel runs out: each struct, pointer and array spends one.
-/
def valueChecks (structs : List Struct) (n : Nat) :
    Nat → Value → String → Option (List String)
  | 0, _, _ => none
  | fuel + 1, v, q => do
    let x := s!"x{n}"
    -- The checks of each element, or the pointee if there is one, as one.
    let all (checks : List String) : List String :=
      if checks.isEmpty then []
      else [s!"({q}.all fun {x} => {" && ".intercalate checks})"]
    -- The checks of a struct's members, at `p`, in `m` `all`s.
    let members (names : Names) (m : Nat) (p : String) :
        Option (List String) :=
      match structs.find? (·.names.c == names.c) with
      | some s => s.members.toList.flatMapM fun mem =>
        valueChecks structs m fuel mem.value s!"{p}.{mem.names.lean}"
      | none => some []
    match v with
    | .usize                     => pure [s!"sizeFits {q}"]
    | .struct names
    | .structPointer names false => members names n q
    | .structPointer names true  => all <$> members names (n + 1) x
    | .array element _           =>
      all <$> valueChecks structs (n + 1) fuel element x
    | _                          => pure []

/--
The checks of each `size_t` of a struct, its value at `path`; none if the fuel
runs out.
-/
def sizeChecks (structs : List Struct) (s : Struct) (path : String)
    (fuel : Nat) : Option (List String) :=
  s.members.toList.flatMapM fun m =>
    valueChecks structs 0 fuel m.value s!"{path}.{m.names.lean}"

/-- An item of a struct, with its scalar's offset and kind. -/
abbrev Entry := Nat × Scalar × Item

/--
A struct's entries on a width: its items, each with its scalar from the layout
model; none if they do not pair up kind by kind.
-/
def structEntries (structs : List Struct) (w : Width) (s : Struct) :
    Option (Nat × List Entry) := do
  let fields ← s.cFields structs
  let t := CType.struct (fields.map (·.2))
  let scalars := t.flatten w 0
  let its ← items structs w s "d" (structs.length + 1)
  guard (scalars.length == its.length)
  let entries := (scalars.zip its).map fun ((o, k), i) => (o, k, i)
  guard (entries.all fun (_, k, i) => match k, i with
    | .ptr, .pointer _ => true
    | .f32, .float _ | .f64, .float _ => true
    | .ptr, _ | _, .pointer _ | _, .float _ => false
    | _, .int _ => true)
  pure (t.size w, entries)

/-! ## Printing -/

/-- The scalar's name in the bindings (`WebGPU.Raw.Encode.Scalar`). -/
def scalarName : Scalar → String
  | .u8 => "u8"
  | .u16 => "u16"
  | .u32 => "u32"
  | .u64 => "u64"
  | .f32 => "f32"
  | .f64 => "f64"
  | .ptr => "ptr"
  | .size => "size"

/-- The poke that writes a scalar of this kind, on a width. -/
def pokeName (w : Width) : Scalar → Item → String
  | .u8, _ => "pokeU8"
  | .u16, _ => "pokeU16"
  | .u32, .float _ | .f32, .float _ => "pokeF32"
  | .u64, .float _ | .f64, .float _ => "pokeF64"
  -- A number at a float, as a nullable float's bits.
  | .u32, _ | .f32, _ => "pokeU32"
  | .u64, _ | .f64, _ => "pokeU64"
  | .size, _ | .ptr, _ => match w with
    | .bits32 => "pokeU32"
    | .bits64 => "pokeU64"

/-- The number an item's bytes hold, as a Lean expression, for its field. -/
def bits : Item → String
  | .int e   => s!"({e}).toNat"
  | .float e => s!"({e}).toBits.toNat"
  | .pointer _ => "0"

/-- The expression an item's poke writes, parenthesised if it has spaces. -/
def value : Item → String
  | .int e | .float e => if e.contains ' ' then s!"({e})" else e
  | .pointer _ => "0"

/-- The width as the bindings name it (`WebGPU.Raw.Encode.Width`). -/
def widthName : Width → String
  | .bits32 => ".bits32"
  | .bits64 => ".bits64"

/-- The width, as a declaration's doc names it. -/
def widthOn : Width → String
  | .bits32 => "wasm32"
  | .bits64 => "64-bit targets"

/-- A line, or, if it is over the width, its parts on lines of their own. -/
def lineOrBroken (indent : Nat) (head : String) (parts : List String) :
    List String :=
  let flat := head ++ String.join (parts.map (" " ++ ·))
  if indent + flat.length ≤ width then [flat]
  else head :: parts.map ("    " ++ ·)

/-- Items, comma-separated, packed into lines `indent` in, within the width. -/
def fill (indent : Nat) (items : List String) : List String :=
  let room := width - indent
  let (done, last) := items.foldl (init := ([], "")) fun (done, cur) item =>
    let word := item ++ ","
    if cur.isEmpty then (done, word)
    else if cur.length + 1 + word.length ≤ room then (done, cur ++ " " ++ word)
    else (done ++ [cur], word)
  let all := if last.isEmpty then done else done ++ [last]
  -- No comma after the last item.
  match all.getLast? with
  | some l => all.dropLast ++ [(l.dropEnd 1).toString]
  | none => []

/-- Lines, the last closed with a bracket. -/
def closed (ls : List String) : List String :=
  match ls.getLast? with
  | some l => ls.dropLast ++ [l ++ "]"]
  | none   => ["]"]

/-- Lines, each indented `n` spaces. -/
def indent (n : Nat) (ls : List String) : List String :=
  ls.map (String.ofList (List.replicate n ' ') ++ ·)

/-- A struct's declarations on one width, each as its lines. -/
def widthDecls (s : Struct) (w : Width) (size : Nat) (entries : List Entry) :
    List (List String) :=
  let t := s.names.lean
  let n := suffix w
  let wn := widthName w
  let fields := entries.filter fun (_, _, i) => !i.isPointer
  let pointers := entries.filterMap fun (o, _, i) =>
    if i.isPointer then some o else none
  let ptr := w.bytes
  let on := widthOn w
  let fieldRows := (fields.map fun (o, k, i) =>
    let param := if (bits i).contains "d." then "d" else "_"
    lineOrBroken 2 s!"⟨{o}, .{scalarName k},"
      [s!"fun {param} => {bits i}⟩"])
  -- A comma after each field but the last.
  let fieldLines := (fieldRows.zipIdx.map fun (row, j) =>
    if j + 1 == fieldRows.length then row
    else row.dropLast ++ [row.getLast! ++ ","]).flatten
  let head := s!"def fields{n} : List (Field {t}) :="
  let fieldList := if fields.isEmpty then [head ++ " []"]
    else [head ++ " ["] ++ indent 2 fieldLines ++ ["]"]
  let usesD := fields.any fun (_, _, i) => (value i).contains "d."
  let pokes := fields.flatMap fun (o, k, i) =>
    lineOrBroken 2 s!"let b := b.{pokeName w k i} {o}" [value i, "(by decide)"]
  -- The pokes the encoder makes, as lemmas of what each leaves in its bytes.
  let pokesUsed := (fields.map fun (_, k, i) => pokeName w k i).eraseDups
  let lemmas := [s!"encode{n}", "Encode.encode", s!"fields{n}",
      "Block.val_fresh"]
    ++ pokesUsed.map (s!"Block.val_{·}")
    ++ ["List.map", "Field.write", "writeAll", "List.foldl", "Scalar.bytes",
      "Width.bytes"]
  let arg := if usesD then "d" else "_"
  [
    [s!"/-- The scalar fields on {on}: the specification. -/"] ++ fieldList,
    [s!"/-- The pointers on {on}, for C to fill in. -/",
      s!"def pointers{n} : List Nat := {pointers}"],
    ["/-- The fields are well-formed: in order, apart, within the struct. -/",
      s!"theorem fields{n}_wellFormed : " ++
        s!"Fields.WellFormed {wn} {size} fields{n} := by",
      "  unfold Fields.WellFormed; decide"],
    ["/-- The pointers are within the struct. -/",
      s!"theorem pointers{n}_within :",
      s!"    ∀ o ∈ pointers{n}, o + {ptr} ≤ {size} := by",
      "  decide"],
    ["/-- The pointers are apart from every field. -/",
      s!"theorem pointers{n}_apart :",
      s!"    ∀ o ∈ pointers{n}, ∀ f ∈ fields{n},",
      s!"      f.offset + f.scalar.bytes {wn} ≤ o ∨ o + {ptr} ≤ f.offset := by",
      "  decide"],
    [s!"/-- `d` as C lays it out on {on}, its pointers 0. -/",
      "@[noinline, never_extract]",
      s!"def encode{n} ({arg} : {t}) : ByteArray :=",
      s!"  let b := Block.fresh {size}"]
      ++ indent 2 pokes ++ ["  b.1"],
    ["/-- The encoder is `encode` of the fields: " ++
        "`readLE_encode` holds of it. -/",
      s!"theorem encode{n}_eq (d : {t}) :",
      s!"    encode{n} d = Encode.encode {wn} {size} fields{n} d := by",
      "  simp only ["] ++ indent 4 (closed (fill 4 lemmas)),
    ["/-- Its encoding is its size. -/",
      s!"theorem size_encode{n} (d : {t}) :",
      s!"    (encode{n} d).size = {size} := by",
      s!"  rw [encode{n}_eq, size_encode]"],
    ["/-- Its pointers read as 0, for C to fill in. -/",
      s!"theorem encode{n}_pointers (d : {t}) :",
      s!"    ∀ o ∈ pointers{n}, readLE (encode{n} d) o {ptr} = 0 :=",
      "  fun o ho => by",
      s!"    rw [encode{n}_eq]",
      s!"    exact readLE_encode_apart d o {ptr} (pointers{n}_apart o ho)"]
  ]

/-! ## Relocations -/

/--
A pointer's kind of relocation (`WebGPU.Raw.Reloc.Kind`): as the bindings
write it, its code, and its table, a block's its struct's `index`; none for an
array's elements of another kind, not yet filled in, or a struct with no table.
An array of numbers is a block of table 0, of objects of table 1.
-/
def kind (index : Names → Option Nat) : Pointer → Option (String × Nat × Nat)
  | .next                      => some (".null", 7, 0)
  | .chain ..                  => some (".chain", 5, 0)
  | .string _                  => some (".string", 0, 0)
  | .optString _               => some (".optString", 1, 0)
  | .object ..                 => some (".object", 2, 0)
  | .optObject ..              => some (".optObject", 3, 0)
  | .struct names _ _          => block names
  | .array (.words _) _        => some (".block 0", 4, 0)
  | .array (.objects _) _      => some (".block 1", 4, 1)
  | .array (.structs names) _  => block names
  | .closure _ k _              => some (s!".optClosure {k}", 6, k)
  | .array .other _            => none
where
  /-- A block of the struct with these names, by its table. -/
  block (names : Names) : Option (String × Nat × Nat) :=
    (index names).map fun i => (s!".block {i}", 4, i)

/-- The number `n` in 4 bytes, little-endian. -/
def le32 (n : Nat) : List Nat :=
  [n % 256, n / 256 % 256, n / 65536 % 256, n / 16777216 % 256]

/--
A table's bytes, as `WebGPU.Raw.Reloc.serialize` lays them out: the struct's
size, the number of relocations, then each one's offset, code and table.
-/
def tableBytes (size : Nat) (relocs : List (Nat × Nat × Nat)) : List Nat :=
  le32 size ++ le32 relocs.length ++ relocs.flatMap fun (o, code, table) =>
    le32 o ++ [code, 0, 0, 0] ++ le32 table

/--
A struct's table's index among `tables`: after the two shared tables, of an
array of numbers (0) and of objects (1).
-/
def tableOf (tables : List Struct) (names : Names) : Option Nat :=
  (tables.findIdx? (·.names.c == names.c)).map (· + 2)

/--
The structs that are the elements of an array of one of `tables` (as laid out
on 64-bit targets: what a pointer is to is the same on both).
-/
def arrayed (structs tables : List Struct) : List Names :=
  (tables.flatMap fun s => match structEntries structs .bits64 s with
    | some (_, entries) => entries.filterMap fun (_, _, i) => match i with
      | .pointer (.array (.structs names) _) => some names
      | _                                    => none
    | none => []).eraseDups

/-- Part of a struct's targets: one target, or an expression of an array. -/
inductive Piece where
  | target (expr : String)
  | targets (expr : String)

/-- What C fills a pointer in from, on a width. -/
def pieces (w : Width) : Pointer → List Piece
  | .next                       => []
  | .chain names e              =>
    [.target s!".chain ({e}.map {names.lean}.chainLink{n})",
      .targets s!"targetsOfAll {names.lean}.chainTargets{n} {e}"]
  | .string e                   => [.target s!".string {e}"]
  | .optString e                => [.target s!".optString {e}"]
  | .object names e             => [.target s!".object ({object names} {e})"]
  | .optObject names e          =>
    [.target s!".optObject ({e}.map {object names})"]
  | .struct names e false       => [.targets s!"{names.lean}.block{n} {e}"]
  | .struct names e true        =>
    [.targets s!"optBlock {names.lean}.block{n} {e}"]
  | .array (.words f) e         => [.target s!".block (encodeU32s {f} {e})"]
  | .array (.objects names) e   =>
    [.target s!".block (objectsBlock {w.bytes} {e})",
      .targets s!"objectsOf {object names} {e}"]
  | .array (.structs names) e   => [.targets s!"{names.lean}.array{n} {e}"]
  | .closure names _ e          =>
    [.target s!".optClosure ({e}.map Internal.{names.lean}Info.closure)"]
  | .array .other _             => []
where
  /-- The width's suffix. -/
  n : String := suffix w
  /-- An object type's conversion to `Object`. -/
  object (names : Names) : String := s!"Internal.{names.lean}.toObject"

/-- Pieces in a row: a run of targets, an array literal, or an array. -/
inductive Run where
  | literal (targets : List String)
  | array (expr : String)

/-- Pieces in runs: each run of targets, one literal. -/
def runs (ps : List Piece) : List Run :=
  ps.foldr (init := []) fun p rs => match p, rs with
    | .target e,  .literal es :: rs => .literal (e :: es) :: rs
    | .target e,  rs                => .literal [e] :: rs
    | .targets e, rs                => .array e :: rs

/-- A run on one line. -/
def Run.line : Run → String
  | .literal es => "#[" ++ ", ".intercalate es ++ "]"
  | .array e    => e

/--
Pieces as the lines of an `Array Target`, `indent` in: their runs joined by
`++`, on one line if they fit, else each on its own, a literal too long
broken one target a line.
-/
def piecesLines (indent : Nat) (ps : List Piece) : List String :=
  let rs := runs ps
  let flat := " ++ ".intercalate (rs.map Run.line)
  if rs.isEmpty then ["#[]"]
  else if indent + flat.length ≤ width then [flat]
  else rs.zipIdx.flatMap fun (r, i) =>
    let head := if i == 0 then "" else "++ "
    if indent + head.length + r.line.length ≤ width then [head ++ r.line]
    else match r with
      | .literal es =>
        [head ++ "#["] ++ (es.zipIdx.map fun (e, j) =>
          "  " ++ e ++ if j + 1 == es.length then "" else ",") ++ ["]"]
      | .array e => [head ++ e]

/--
A struct's relocations, table and targets on one width, each declaration as
its lines; none if a pointer cannot be filled in yet. `index` gives each
struct's table.
-/
def relocDecls (structs : List Struct) (s : Struct) (w : Width) (size : Nat)
    (entries : List Entry) (index : Names → Option Nat) (isArrayed : Bool) :
    Option (List (List String)) := do
  let t := s.names.lean
  let n := suffix w
  let on := widthOn w
  let pointers := entries.filterMap fun (o, _, i) => match i with
    | .pointer p => some (o, p)
    | _          => none
  let kinds ← pointers.mapM fun (o, p) => do
    let (name, code, table) ← kind index p
    pure (s!"⟨{o}, {name}⟩", o, code, table)
  let relocs := kinds.map (·.1)
  let codes := kinds.map (·.2)
  let bytes := (tableBytes size codes).map toString
  let ps := pointers.flatMap fun (_, p) => pieces w p
  -- An element's fields poked into an array's block, at its offset there.
  let fields := entries.filter fun (_, _, i) => !i.isPointer
  let intoPokes := fields.flatMap fun (o, k, i) =>
    lineOrBroken 2 s!"let b := b.{pokeName w k i} (off + {o})"
      [value i, "(by omega)"]
  let usesD := fields.any fun (_, _, i) => (value i).contains "d."
  let intoArg := if usesD then "d" else "_"
  let proof := if fields.isEmpty then "_h" else "h"
  let body := piecesLines 2 ps
  let arg := if ps.isEmpty then "_" else "d"
  -- Only for the proofs: C reads the table, its bytes.
  let head := s!"noncomputable def relocs{n} : List Reloc :="
  let relocList := if relocs.isEmpty then [head ++ " []"]
    else [head ++ " ["] ++ indent 2 (fill 2 relocs) ++ ["]"]
  -- Its chain's elements: each extension's bytes, table and targets.
  let links := s.extensions.toList.filterMap fun e => do
    let x ← structs.find? (·.names == e)
    let entry ← x.sType
    pure (entry.lean, e.lean)
  -- An arm on one line, or two, or its parts on lines of their own.
  let arm (c : String) (parts : List String) : List String :=
    let rhs := " ".intercalate parts
    let flat := s!"  | .{c} x => {rhs}"
    if flat.length ≤ width then [flat]
    else if 4 + rhs.length ≤ width then [s!"  | .{c} x =>", s!"    {rhs}"]
    else [s!"  | .{c} x =>"] ++ parts.zipIdx.map fun (p, i) =>
      (if i == 0 then "    " else "      ") ++ p
  let chainDecls := if links.isEmpty then [] else [
    [s!"/-- An element of its chain on {on}: its bytes, and its table. -/",
      "@[never_extract]",
      s!"def chainLink{n} : Chained → ByteArray × Nat"]
      ++ links.flatMap fun (c, x) =>
        arm c [s!"({x}.encode{n} x,", s!"{x}.tableIndex)"],
    [s!"/-- What C fills in an element of its chain from on {on}. -/",
      "@[never_extract]",
      s!"def chainTargets{n} : Chained → Array Target"]
      ++ links.flatMap fun (c, x) => arm c [s!"{x}.targets{n} x"]]
  pure (chainDecls ++ [
    [s!"/-- Its pointers' relocations on {on}: what C fills each in from. -/"]
      ++ relocList,
    [s!"/-- Its table on {on}, for C: `serialize` of its relocations. -/",
      s!"def table{n} : ByteArray := ⟨#["] ++ indent 2 (fill 2 bytes)
      ++ ["]⟩"],
    ["set_option maxRecDepth 4096 in",
      "/-- The table is its relocations. -/",
      s!"theorem table{n}_eq : table{n} = serialize {size} relocs{n} := rfl"],
    ["/-- Every pointer has a relocation, and only a pointer. -/",
      s!"theorem relocs{n}_offsets : relocs{n}.map (·.offset) = pointers{n} :=",
      "  rfl"],
    ["/-- Its relocations' numbers fit its table. -/",
      s!"theorem relocs{n}_fit : relocs{n}.all Reloc.fits := by decide"],
    [s!"/-- What C fills in `d`'s pointers from on {on}, in order. -/",
      "@[never_extract]",
      s!"def targets{n} ({arg} : {t}) : Array Target :="] ++ indent 2 body,
    [s!"/-- `d` as the block a pointer to it points to on {on}. -/",
      "@[never_extract]",
      s!"def block{n} (d : {t}) : Array Target :=",
      s!"  #[.block (encode{n} d)] ++ targets{n} d"]
  ] ++ if !isArrayed then [] else [
    [s!"/-- `d` poked into `b` at `off`, as `encode{n}` lays it out. -/",
      "@[inline]",
      s!"def encodeInto{n} \{total : Nat} (b : Block total) (off : Nat)",
      s!"    ({proof} : off + {size} ≤ total) ({intoArg} : {t}) :",
      "    Block total :="]
      ++ Encoders.indent 2 intoPokes ++ ["  b"],
    [s!"/-- An array of them, encoded in turn into one block, on {on}. -/",
      "@[noinline, never_extract]",
      s!"def encodeAll{n} (xs : Array {t}) : ByteArray :=",
      s!"  (go 0 (Block.fresh (xs.size * {size}))).1",
      "where",
      "  /-- Each element from the `i`th on, encoded into `b`. -/",
      s!"  go (i : Nat) (b : Block (xs.size * {size})) :",
      s!"      Block (xs.size * {size}) :=",
      "    if h : i < xs.size then",
      s!"      go (i + 1) (encodeInto{n} b (i * {size}) (by omega) xs[i])",
      "    else b",
      "  termination_by xs.size - i"],
    ["/-- An array of them is their size. -/",
      s!"theorem size_encodeAll{n} (xs : Array {t}) :",
      s!"    (encodeAll{n} xs).size = xs.size * {size} :=",
      s!"  (encodeAll{n}.go xs 0 (Block.fresh (xs.size * {size}))).2"],
    [s!"/-- What C fills in an array of them's pointers from on {on}. -/",
      "@[never_extract]",
      s!"def targetsAll{n} (xs : Array {t}) : Array Target :=",
      s!"  targetsOfAll targets{n} xs"],
    [s!"/-- An array of them as a block on {on}, and its targets. -/",
      "@[never_extract]",
      s!"def array{n} (xs : Array {t}) : Array Target :=",
      s!"  #[.block (encodeAll{n} xs)] ++ targetsAll{n} xs"]
  ])

/--
The bound structs whose pointers can all be filled in, each after those it
points to: their tables, in this order, are the tables. One pass suffices, as
each bound struct comes after those it refers to (`boundStructs_ordered`).
-/
def tabled (structs : List Struct) : List Struct :=
  (boundStructs structs).foldl (init := []) fun done s =>
    let index := tableOf done
    let fills (w : Width) := match structEntries structs w s with
      | some (_, entries) => entries.all fun (_, _, i) => match i with
        | .pointer p => (kind index p).isSome
        | _          => true
      | none => false
    if fills .bits64 && fills .bits32 then done ++ [s] else done

/--
A struct's encoders, both widths, and the one for the target; and, if it is of
the `tables`, its relocations, table and targets.
-/
def structEncoders (structs tables : List Struct) (s : Struct) :
    Option Doc := do
  let (size64, entries64) ← structEntries structs .bits64 s
  let (size32, entries32) ← structEntries structs .bits32 s
  -- Enough fuel: each struct is in a chain at most once, and each spends one,
  -- as does a pointer or array to it.
  let sizes ← sizeChecks structs s "d" (2 * structs.length + 1)
  -- The checks, each on a line of its own if they do not fit on one.
  let fit := match sizes with
    | []  => lineOrBroken 2 "true" []
    | [c] => lineOrBroken 2 "Width.is64 () ||" [c]
    | c :: cs =>
      lineOrBroken 2 "Width.is64 () ||"
        ((("(" ++ c) :: cs).zipIdx.map fun (c, i) =>
          if i == cs.length then c ++ ")" else c ++ " &&")
  let t := s.names.lean
  let arg := if sizes.isEmpty then "_" else "d"
  let index := tableOf tables
  let isArrayed := (arrayed structs tables).contains s.names
  let relocs (w : Width) (size : Nat) (entries : List Entry) :=
    if (index s.names).isSome then
      relocDecls structs s w size entries index isArrayed
    else none
  -- Its table's index, and its targets on this target, if it has a table.
  let tableDecls := match index s.names with
    | some i => [
      ["/-- Its table's index in `tables64` and `tables32`. -/",
        s!"def tableIndex : Nat := {i}"],
      ["/-- What C fills in `d`'s pointers from on this target. -/",
        "@[inline]",
        s!"def toTargets (d : {t}) : Array Target :=",
        "  if Width.is64 () then targets64 d else targets32 d"]]
    | none => []
  let decls := widthDecls s .bits64 size64 entries64
    ++ (relocs .bits64 size64 entries64).getD []
    ++ widthDecls s .bits32 size32 entries32
    ++ (relocs .bits32 size32 entries32).getD [] ++ [
      ["/--",
        "Whether each `size_t` of `d` fits the target: on wasm32, " ++
          "in 32 bits, or",
        "as the largest `UInt64`, `SIZE_MAX`. A caller refuses one " ++
          "that does not,",
        "as for a `size_t` argument.",
        "-/",
        s!"def sizesFit ({arg} : {t}) : Bool :="]
        ++ indent 2 fit,
      (if sizes.isEmpty then
        [s!"/-- `d` as C lays it out on this target, its pointers 0. -/"]
      else
        ["/--",
          "`d` as C lays it out on this target, its pointers 0. The caller " ++
            "checks",
          "`sizesFit d` first: on wasm32, a `size_t` that does not fit is " ++
            "cut to its",
          "low 32 bits.",
          "-/"]) ++
      ["@[inline]",
        s!"def toBytes (d : {t}) : ByteArray :=",
        "  if Width.is64 () then encode64 d else encode32 d"]
    ] ++ tableDecls
  pure (text s!"/-! ### `{t}` -/" ++ hardline ++ hardline
    ++ text s!"namespace {t}" ++ hardline ++ hardline
    ++ join (hardline ++ hardline) (decls.map Doc.lines) ++ hardline
    ++ hardline ++ text s!"end {t}")

/-- The encoders of every bound struct; none if one cannot be made. -/
def encoderDecls (spec : Lowered.Spec) : Option (List Doc) :=
  let structs := spec.structs.toList
  (boundStructs structs).mapM (structEncoders structs (tabled structs))

/-- The bound structs that cannot be encoded, by their C names. -/
def unencodable (spec : Lowered.Spec) : List String :=
  let structs := spec.structs.toList
  let tables := tabled structs
  (boundStructs structs).filterMap fun s =>
    if (structEncoders structs tables s).isSome then none else some s.names.c

/-- Each object type's conversion to `Object`, the same Lean value. -/
def objectDecls (spec : Lowered.Spec) : List Doc :=
  [Doc.lines ["/-! ## Objects", "",
    "Each object type as an `Object`, the same Lean value: what C fills in a",
    "pointer to one from. -/"]]
    ++ spec.objects.toList.map fun o => Doc.lines [
      s!"/-- `{o.names.lean}`, as an `Object`. -/",
      "@[extern c inline \"#1\"]",
      s!"opaque Internal.{o.names.lean}.toObject : {o.names.lean} → Object"]

/--
`simp` with these lemmas, `indent` in: on one line if it fits, else its lemmas
on lines of their own, filled.
-/
def simpLines (indent : Nat) (lemmas : List String) : List String :=
  let flat := "simp [" ++ ", ".intercalate lemmas ++ "]"
  let pad := String.ofList (List.replicate indent ' ')
  if indent + flat.length ≤ width then [pad ++ flat]
  else [pad ++ "simp ["] ++ Encoders.indent (indent + 2)
    (closed (fill (indent + 2) lemmas))

/--
The structs a struct's pointers point to: each one's names, the path to its
pointer, and whether it is optional.
-/
def pointees (entries : List Entry) : List (Names × String × Bool) :=
  entries.filterMap fun (_, _, i) => match i with
    | .pointer (.struct names e nullable) => some (names, e, nullable)
    | _                                   => none

/--
A struct's proofs that the walk (`WebGPU.Raw.Reloc.walk`) agrees with its
table and targets on one width, its table's index `i`: each declaration as its
lines. Its element's walk is proved by `simp`, a case for each optional struct,
by the lemmas of the structs and arrays it points to; then its walk, and an
array of them's if `isArrayed`, by `walk_one` and `walk_elements`.
-/
def walkDecls (s : Struct) (w : Width) (size : Nat) (entries : List Entry)
    (i : Nat) (isArrayed : Bool) : List (List String) :=
  let t := s.names.lean
  let n := suffix w
  let ps := pointees entries
  let optional := ps.filter fun (_, _, nullable) => nullable
  let hyp (k : Nat) := s!"h{k}"
  -- The pointees' lemmas, and for each optional one, its case and its empty.
  let pointeeLemmas := (ps.map fun (names, _, _) =>
      [s!"{names.lean}.block{n}", s!"{names.lean}.walk_encode{n}"]).flatten
  let empties := optional.map fun (names, _, _) =>
      s!"walk_empty {names.lean}.getElem?_specs{n} (by decide)"
  -- The arrays' lemmas: each kind's walk.
  let arrayLemmas := (entries.filterMap fun (_, _, it) => match it with
    | .pointer (.array (.words _) _)       =>
      some [s!"walk_words getElem?_specs{n}_words"]
    | .pointer (.array (.objects _) _)     =>
      some [s!"walk_objects getElem?_specs{n}_objects (by decide)"]
    | .pointer (.array (.structs names) _) =>
      some [s!"{names.lean}.array{n}", s!"{names.lean}.walk_encodeAll{n}"]
    | _                                    => none).flatten
  -- The chains' lemmas: each walks its links by its own table, before this.
  let chainLemmas := entries.filterMap fun (_, _, it) => match it with
    | .pointer (.chain names _) =>
      some s!"{names.lean}.walk_chain{n} (table := {i}) (by decide)"
    | _ => none
  let relocs := entries.filter fun (_, _, it) => it.isPointer
  let lemmas := ["element", s!"relocs{n}", s!"targets{n}"]
    ++ (if relocs.isEmpty then [] else ["step"])
    -- A closure's ordinal is below `closures`, which `simp` decides.
    ++ (if entries.any (fun (_, _, it) => it matches .pointer (.closure ..))
      then ["closures"] else [])
    ++ (if optional.isEmpty then [] else ["optBlock"])
    ++ (optional.zipIdx.map fun (_, k) => hyp k)
    ++ (pointeeLemmas ++ empties ++ arrayLemmas ++ chainLemmas).eraseDups
  let cases := optional.zipIdx.map fun ((_, e, _), k) =>
    s!"cases {hyp k} : {e} <;>"
  let statement (name : String) (args : String) (lhs : List String) :
      List String :=
    lineOrBroken 0 s!"theorem {name} {args}" ["(ts : List Target) :"] ++ lhs
  -- Its chain's walk, if it has extensions: each link's by its own walk.
  let chainWalkLemmas := [s!"chainLink{n}", s!"chainTargets{n}"]
    ++ s.extensions.toList.map fun e => s!"{e.lean}.walk_encode{n}_tableIndex"
  let chainProof := if s.extensions.isEmpty then [] else [
    ["/-- Each link's table comes before its own. -/",
      s!"theorem chainLink{n}_lt_tableIndex (c : Chained) :",
      s!"    (chainLink{n} c).2 < tableIndex := by",
      "  cases c <;>"]
      ++ simpLines 4 ([s!"chainLink{n}", "tableIndex"]
        ++ s.extensions.toList.map fun e => s!"{e.lean}.tableIndex"),
    ["/-- Each link is one element of its own table, its `next` first. -/",
      s!"theorem chainLink{n}_isLink (c : Chained) :",
      s!"    specs{n}[(chainLink{n} c).2]?.any",
      s!"      (·.isLink (chainLink{n} c).1.size) := by",
      "  cases c <;>"]
      ++ simpLines 4 ([s!"chainLink{n}", "Spec.isLink"]
        ++ (s.extensions.toList.map fun e => [s!"{e.lean}.tableIndex",
          s!"{e.lean}.getElem?_specs{n}", s!"{e.lean}.size_encode{n}",
          s!"{e.lean}.relocs{n}"]).flatten),
    ["/--",
      "Walking its chain, from a table not before its own, takes exactly its",
      "links' targets, in turn.",
      "-/",
      s!"theorem walk_chain{n} \{table : Nat}",
      s!"    (h : tableIndex ≤ table) (cs : Array Chained)",
      "    (ts : List Target) :",
      s!"    walkLinks specs{n} (fun j size ts =>",
      s!"        if j < table then walk specs{n} j size ts else none)",
      s!"      (cs.map chainLink{n})",
      s!"      ((targetsOfAll chainTargets{n} cs).toList ++ ts) = some ts :=",
      s!"  walkLinks_map _ _ chainLink{n}_isLink (fun c ts => by",
      s!"    have := Nat.lt_of_lt_of_le (chainLink{n}_lt_tableIndex c) h",
      "    cases c <;> simp_all ["]
      ++ Encoders.indent 6 (closed (fill 6 chainWalkLemmas))
      ++ ["  ) cs ts"]]
  chainProof ++ [
    ["/-- Its index finds its table as the walk reads it. -/",
      s!"theorem getElem?_specs{n} :",
      s!"    specs{n}[{i}]? = some ({size}, relocs{n}) :=",
      "  rfl"],
    ["/-- An element's walk takes exactly its targets. -/"]
      ++ statement s!"element_targets{n}" s!"(d : {t})"
        [s!"    element specs{n} {i} relocs{n}",
          s!"      ((targets{n} d).toList ++ ts) = some ts := by"]
      ++ indent 2 cases ++ simpLines (if cases.isEmpty then 2 else 4) lemmas,
    ["/-- Walking its table over its bytes takes exactly its targets. -/"]
      ++ statement s!"walk_encode{n}" s!"(d : {t})"
        [s!"    walk specs{n} {i} (encode{n} d).size",
          s!"      ((targets{n} d).toList ++ ts) = some ts :=",
          s!"  walk_one getElem?_specs{n} (by decide) d " ++
            s!"(fun d => (targets{n} d).toList) _",
          s!"    (size_encode{n} d) (element_targets{n} d) ts"],
    ["/-- The same, at its index. -/"]
      ++ statement s!"walk_encode{n}_tableIndex" s!"(d : {t})"
        [s!"    walk specs{n} tableIndex (encode{n} d).size",
          s!"      ((targets{n} d).toList ++ ts) = some ts :=",
          s!"  walk_encode{n} d ts"]
  ] ++ if !isArrayed then [] else [
    ["/-- Walking an array of them takes exactly their targets, in turn. -/"]
      ++ statement s!"walk_encodeAll{n}" s!"(xs : Array {t})"
        [s!"    walk specs{n} {i} (encodeAll{n} xs).size",
          s!"      ((targetsAll{n} xs).toList ++ ts) = some ts := by",
          s!"  rw [targetsAll{n}, toList_targetsOfAll]",
          s!"  exact walk_elements getElem?_specs{n} (by decide) xs.toList",
          s!"    (fun d => (targets{n} d).toList) _",
          s!"    (by rw [size_encodeAll{n}, Array.length_toList])",
          s!"    (fun d _ => element_targets{n} d) ts"]
  ]

/--
A struct's proofs for the target the program runs on, by cases on its width,
and its instance of `CStruct`: each declaration as its lines.
-/
def currentDecls (s : Struct) : List (List String) :=
  let t := s.names.lean
  -- By cases on the width, each case by its width's lemma.
  -- (In the second, `h` makes the width `false`, which `Bool.false_eq_true`
  -- turns from a condition into one `simp` can decide.)
  let cases (lemmas : List String) (each : String → String) :=
    let simps (more : List String) :=
      let all := lemmas ++ ["h"] ++ more ++ ["↓reduceIte"]
      let flat := s!"  · simp only [{", ".intercalate all}]"
      if flat.length ≤ width then [flat]
      else ["  · simp only ["] ++ Encoders.indent 6 (closed (fill 6 all))
    ["  by_cases h : Width.is64 () = true"] ++ simps [] ++ [s!"    {each "64"}"]
      ++ simps ["Bool.false_eq_true"] ++ [s!"    {each "32"}"]
  [
    ["/-- Its bytes are one struct, on this target. -/",
      s!"theorem size_toBytes (d : {t}) :",
      "    ∃ relocs,",
      "      currentSpecs[tableIndex]? = some ((toBytes d).size, relocs) := by"]
      ++ cases ["currentSpecs", "toBytes"] fun n =>
        s!"exact ⟨_, by rw [size_encode{n}]; exact getElem?_specs{n}⟩",
    ["/-- Walking its table over its bytes takes its targets, on this " ++
        "target. -/"]
      ++ lineOrBroken 0 s!"theorem walk_toBytes (d : {t})"
        ["(ts : List Target) :"]
      ++ ["    walk currentSpecs tableIndex (toBytes d).size",
        "      ((toTargets d).toList ++ ts) = some ts := by"]
      ++ cases ["currentSpecs", "toBytes", "toTargets"] fun n =>
        s!"exact walk_encode{n}_tableIndex d ts",
    ["/-- It is a struct C fills in. -/",
      s!"instance : CStruct {t} :=",
      "  ⟨toBytes, toTargets, tableIndex, sizesFit⟩"],
    ["/-- C fills it in as its table says, on this target. -/",
      s!"instance : CStruct.Fills currentSpecs {t} :=",
      "  ⟨size_toBytes, walk_toBytes⟩"]
  ]

/-- Every table on each width, by its index in a relocation. -/
def tablesDecls (spec : Lowered.Spec) : List Doc :=
  let structs := spec.structs.toList
  let tables := tabled structs
  let elements := arrayed structs tables
  let widths := [Width.bits64, .bits32].flatMap fun w =>
    let n := suffix w
    let ptr := w.bytes
    -- The two shared tables first: of arrays of numbers, and of objects.
    let names := [s!"serialize 4 []", s!"serialize {ptr} [⟨0, .object⟩]"]
      ++ tables.map fun s => s!"{s.names.lean}.table{n}"
    -- Every struct of `tables` has its entries, so none is left out here,
    -- which would put each after it at the wrong index.
    let specs := ["wordsSpec", s!"objectsSpec {ptr}"] ++ tables.filterMap
      fun s => (structEntries structs w s).map fun (size, _) =>
        s!"({size}, {s.names.lean}.relocs{n})"
    [Doc.lines ([s!"/-- Every struct's table on {widthOn w}, by its index. -/",
        s!"def tables{n} : Array ByteArray := #["] ++ indent 2 (fill 2 names)
        ++ ["]"]),
      Doc.lines ([s!"/-- Every struct's table on {widthOn w}, as the walk " ++
          "reads it. -/",
        s!"noncomputable def specs{n} : Array Spec := #["]
        ++ indent 2 (fill 2 specs) ++ ["]"]),
      Doc.lines ["set_option maxRecDepth 16384 in",
        "/-- The tables C reads are the tables the walk reads. -/",
        s!"theorem tables{n}_eq :",
        s!"    tables{n}.toList = specs{n}.toList.map fun (size, relocs) =>",
        "      serialize size relocs :=",
        "  rfl"],
      Doc.lines ["/-- The shared table of arrays of numbers is the first. -/",
        s!"theorem getElem?_specs{n}_words : specs{n}[0]? = some wordsSpec :=",
        "  rfl"],
      Doc.lines ["/-- The shared table of arrays of objects is the second. -/",
        s!"theorem getElem?_specs{n}_objects : specs{n}[1]? = " ++
          s!"some (objectsSpec {ptr}) := rfl"]]
  let current := Doc.lines ["/-- Every table on this target. -/", "@[inline]",
    "def currentTables : Array ByteArray :=",
    "  if Width.is64 () then tables64 else tables32"]
  let tablesOf := Doc.lines [
    "/-- The tables on this target, and no others: what a shim takes. -/",
    "abbrev CurrentTablesOf := {ts : Array ByteArray // ts = currentTables}"]
  let currentSpecs := Doc.lines [
    "/-- Every table on this target, as the walk reads it. -/",
    "noncomputable def currentSpecs : Array Spec :=",
    "  if Width.is64 () then specs64 else specs32"]
  let currentEq := Doc.lines [
    "/-- The tables C reads on this target are the tables the walk reads. -/",
    "theorem currentTables_eq :",
    "    currentTables.toList = currentSpecs.toList.map fun (size, relocs) =>",
    "      serialize size relocs := by",
    "  by_cases h : Width.is64 () = true",
    "  · simp only [currentTables, currentSpecs, h, ↓reduceIte]",
    "    exact tables64_eq",
    "  · simp only [currentTables, currentSpecs, h, Bool.false_eq_true,",
    "      ↓reduceIte]",
    "    exact tables32_eq"]
  -- Each struct's index finds its tables, and its walk takes its targets.
  let proofs := tables.zipIdx.map fun (s, i) =>
    let walks := [Width.bits64, .bits32].flatMap fun w =>
      match structEntries structs w s with
      | some (size, entries) =>
        walkDecls s w size entries (i + 2) (elements.contains s.names)
      | none                 => []
    Doc.lines ([s!"/-! ### `{s.names.lean}`: its walk -/", "",
      s!"namespace {s.names.lean}", "",
      "/-- Its index finds its tables. -/",
      "theorem getElem?_tables_tableIndex :",
      "    tables64[tableIndex]? = some table64 ∧",
      "      tables32[tableIndex]? = some table32 :=",
      "  ⟨rfl, rfl⟩", ""]
      ++ (walks.map (· ++ [""])).flatten
      ++ ((currentDecls s).map (· ++ [""])).flatten
      ++ [s!"end {s.names.lean}"])
  [Doc.lines ["/-! ## Tables -/"]] ++ widths
    ++ [current, tablesOf, currentSpecs, currentEq] ++ proofs

/-- The encoders' module, `WebGPU/Raw/Encoders.lean`; none if one is missing. -/
def encodersFile (p : Provenance) (spec : Lowered.Spec) : Option String := do
  let decls ← encoderDecls spec
  pure <| Lean.moduleFile p
    [
      "public import WebGPU.Raw.Structs",
      "public import WebGPU.Raw.Internal.Encode",
      "public import WebGPU.Raw.Internal.Reloc"
    ]
    [
      "# Encoders",
      "",
      "Each struct of `WebGPU.Raw.Structs` as C lays it out, its pointers 0",
      "for C to fill in (`toBytes`). For each target width, a struct's",
      "fields are the specification (`WebGPU.Raw.Encode.encode`); its",
      "encoder, a poke for each field into a fresh block, is proved the same,",
      "its fields well-formed, and its pointers 0. The C compiler checks the",
      "layouts against `webgpu.h` (`c/generated/layouts.c`).",
      "",
      "Where C fills in a struct's pointers is its table (`currentTables`, at",
      "`tableIndex`), proved to be its pointers; what it fills each in from,",
      "its targets (`toTargets`), proved to be what walking its table takes",
      "(`walk_encode64`, `walk_encode32`)."
    ]
    (text "open Encode Bytes Reloc" :: objectDecls spec ++ decls
      ++ tablesDecls spec)

end WebGPUGen.Emit.Encoders
