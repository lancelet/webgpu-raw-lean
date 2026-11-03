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
  bound proved by `decide`, the encoder `@[noinline]` as the pokes require;
- proofs that its fields are well-formed, that the encoder is `encode` of its
  fields, and that its pointers read as 0.

The fields follow the layout model (`CLayout`), which the C compiler checks
against `webgpu.h` (`layouts.c`): a struct's members in order, a nested struct
by value its own fields, a string its data and its length, an array its count
and its elements.
-/

namespace WebGPUGen.Emit.Encoders
open WebGPUGen.Lowered WebGPUGen.CLayout WebGPUGen.Emit Doc

/-! ## What each scalar holds -/

/-- What an encoder writes for one scalar of a struct. -/
inductive Item where
  /-- A number, by a Lean expression of the unsigned type of its width. -/
  | int (expr : String)
  /-- A `float` or `double`, by a Lean expression of `Float32` or `Float`. -/
  | float (expr : String)
  /-- A pointer, left 0 for C to fill in. -/
  | pointer
  deriving Repr, BEq

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
      | .extensible | .extensibleCallbackArg => some [Item.pointer]
      | .extension => s.sType.map fun e =>
        [Item.pointer, .int s!"CEnum.toC SType.{e.lean}"]
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
    | .object .. | .structPointer .. => some [.pointer]
    -- A string view: its data, then its length; a null view's is `SIZE_MAX`.
    | .string false                 =>
      some [.pointer, .int s!"{q}.utf8ByteSize.to{sizeType w}"]
    | .string true                  =>
      some [.pointer, .int s!"viewLength{suffix w} {q}"]
    -- An array: its count, then a pointer to its elements.
    | .array .. => some [.int s!"{q}.size.to{sizeType w}", .pointer]
    | .struct names => do
      let nested ← structs.find? (·.names.c == names.c)
      items structs w nested q fuel
    -- A `size_t`: on wasm32, its low 32 bits, or `SIZE_MAX` for the largest
    -- `UInt64`; `sizesFit` says whether it fits, for the caller to check.
    | .usize => some [.int (match w with
      | .bits64 => q
      | .bits32 => s!"size32 {q}")]
    | .unsupported _ => none

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
    | .ptr, .pointer => true
    | .f32, .float _ | .f64, .float _ => true
    | .ptr, _ | _, .pointer | _, .float _ => false
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
  | .pointer => "0"

/-- The expression an item's poke writes, parenthesised if it has spaces. -/
def value : Item → String
  | .int e | .float e => if e.contains ' ' then s!"({e})" else e
  | .pointer => "0"

/-- The width as the bindings name it (`WebGPU.Raw.Encode.Width`). -/
def widthName : Width → String
  | .bits32 => ".bits32"
  | .bits64 => ".bits64"

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
  let fields := entries.filter fun (_, _, i) => i != .pointer
  let pointers := entries.filterMap fun (o, _, i) =>
    if i == .pointer then some o else none
  let ptr := w.bytes
  let on := match w with
    | .bits32 => "wasm32"
    | .bits64 => "64-bit targets"
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
    ["/-- The pointers are apart from every field. -/",
      s!"theorem pointers{n}_apart :",
      s!"    ∀ o ∈ pointers{n}, ∀ f ∈ fields{n},",
      s!"      f.offset + f.scalar.bytes {wn} ≤ o ∨ o + {ptr} ≤ f.offset := by",
      "  decide"],
    [s!"/-- `d` as C lays it out on {on}, its pointers 0. -/",
      "@[noinline]",
      s!"def encode{n} ({arg} : {t}) : ByteArray :=",
      s!"  let b := Block.fresh {size}"]
      ++ indent 2 pokes ++ ["  b.1"],
    ["/-- The encoder is `encode` of the fields: " ++
        "`readLE_encode` holds of it. -/",
      s!"theorem encode{n}_eq (d : {t}) :",
      s!"    encode{n} d = Encode.encode {wn} {size} fields{n} d := by",
      "  simp only ["] ++ indent 4 (closed (fill 4 lemmas)),
    ["/-- Its pointers read as 0, for C to fill in. -/",
      s!"theorem encode{n}_pointers (d : {t}) :",
      s!"    ∀ o ∈ pointers{n}, readLE (encode{n} d) o {ptr} = 0 :=",
      "  fun o ho => by",
      s!"    rw [encode{n}_eq]",
      s!"    exact readLE_encode_apart d o {ptr} (pointers{n}_apart o ho)"]
  ]

/-- A struct's encoders, both widths, and the one for the target. -/
def structEncoders (structs : List Struct) (s : Struct) : Option Doc := do
  let (size64, entries64) ← structEntries structs .bits64 s
  let (size32, entries32) ← structEntries structs .bits32 s
  -- Enough fuel: each struct is in a chain at most once, and each spends one,
  -- as does a pointer or array to it.
  let sizes ← sizeChecks structs s "d" (2 * structs.length + 1)
  -- The checks, each on a line of its own if they do not fit on one.
  let fit := match sizes with
    | []  => lineOrBroken 2 "true" []
    | [c] => lineOrBroken 2 "System.Platform.numBits = 64 ||" [c]
    | c :: cs =>
      lineOrBroken 2 "System.Platform.numBits = 64 ||"
        ((("(" ++ c) :: cs).zipIdx.map fun (c, i) =>
          if i == cs.length then c ++ ")" else c ++ " &&")
  let t := s.names.lean
  let arg := if sizes.isEmpty then "_" else "d"
  let decls := widthDecls s .bits64 size64 entries64
    ++ widthDecls s .bits32 size32 entries32 ++ [
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
        "  if System.Platform.numBits = 64 then encode64 d else encode32 d"]
    ]
  pure (text s!"namespace {t}" ++ hardline ++ hardline
    ++ join (hardline ++ hardline) (decls.map Doc.lines) ++ hardline
    ++ hardline ++ text s!"end {t}")

/-- The encoders of every bound struct; none if one cannot be made. -/
def encoderDecls (spec : Lowered.Spec) : Option (List Doc) :=
  let structs := spec.structs.toList
  (boundStructs structs).mapM (structEncoders structs)

/-- The bound structs that cannot be encoded, by their C names. -/
def unencodable (spec : Lowered.Spec) : List String :=
  let structs := spec.structs.toList
  (boundStructs structs).filterMap fun s =>
    if (structEncoders structs s).isSome then none else some s.names.c

/-- The encoders' module, `WebGPU/Raw/Encoders.lean`; none if one is missing. -/
def encodersFile (p : Provenance) (spec : Lowered.Spec) : Option String := do
  let decls ← encoderDecls spec
  pure <| Lean.moduleFile p
    [
      "public import WebGPU.Raw.Structs",
      "public import WebGPU.Raw.Internal.Encode"
    ]
    [
      "# Encoders",
      "",
      "Each struct of `WebGPU.Raw.Structs` as C lays it out, its pointers 0",
      "for C to fill in (`toBytes`). For each target width, a struct's",
      "fields are the specification (`WebGPU.Raw.Encode.encode`); its",
      "encoder, a poke for each field into a fresh block, is proved the same,",
      "its fields well-formed, and its pointers 0. The C compiler checks the",
      "layouts against `webgpu.h` (`c/generated/layouts.c`)."
    ]
    (text "open Encode Bytes" :: decls)

end WebGPUGen.Emit.Encoders
