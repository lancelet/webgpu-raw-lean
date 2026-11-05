module

public import WebGPU.Raw.Internal.Encode

/-!
# Relocations

A helper for the generated bindings, not part of the API. It reaches their
users, through the generated encoders and functions (`WebGPU.Raw.Encoders`,
`WebGPU.Raw.Functions`), whose types and theorems mention it.

An encoded struct (`WebGPU.Raw.Encode`) leaves its pointers 0, for C to fill
in. Where each goes, and what it points to, is a struct's relocations: each an
offset in the struct and a kind of pointer. They are the same for every value
of the struct, so they are a table, made once: `serialize` lays one out in
bytes for C to read. What each pointer is filled from is a value's targets,
one for each relocation but a null one, in order: a string, an object, a
block of bytes, another encoded struct, or an array's elements, whose own
relocations follow from its own table, its targets next in order; or a chain
of extensions, each element's bytes with the index of its own table, all of
their targets next, element by element; or a callback's closure.

One C function, `lean_wgpu_fill` (`c/reloc.c`), walks a table over the bytes,
and each element of a block, taking each target in turn. A table's header is
the size of the struct it is for, and the number of its relocations; each
relocation, 12 bytes, is its offset, its kind's code, and, for a block, the
index of the block's table, or, for a closure, its ordinal:

    u32 size, u32 count, then count × (u32 offset, u8 kind, u8[3] 0, u32 table)

all little-endian. A block's elements are the size of its table's struct, and
an empty block is a null pointer: an optional struct that is none, or an empty
array. A chain's elements are filled in first, then each linked to the next by
its first pointer, its `next`; an empty chain is a null pointer. A closure is
held by the family the shim filling the struct set (`c/family.c`), at its
ordinal, and the pointer is the family's ID; none is a null pointer.
-/

@[expose] public section

namespace WebGPU.Raw.Reloc
open WebGPU.Raw.Encode

/-- The type of handles behind `Object`. -/
opaque ObjectHandle : NonemptyType

/--
Any WebGPU object, of any of the `c_object` types: each is a Lean external
object whose data is its handle, so C reads any one's handle the same way. An
object becomes one by a conversion that is the same Lean value, `#1` in C.
-/
def Object : Type := NonemptyType.type ObjectHandle

instance : Nonempty Object := Subtype.property ObjectHandle

-- (As `c_object Object` would declare it, without importing the command.)

/-- The type of the closures behind `Closure`. -/
opaque ClosureHandle : NonemptyType

/--
Any Lean closure a callback runs, of any callback type: C holds it, and the
callback's trampoline knows its type. A closure is to become one by a
conversion that is the same Lean value, `#1` in C, as an object becomes an
`Object`, one for each callback type.
-/
def Closure : Type := NonemptyType.type ClosureHandle

instance : Nonempty Closure := Subtype.property ClosureHandle

/--
How many closures a family holds, each at an ordinal below it
(`LEAN_WGPU_FAMILY_CLOSURES` in `c/family.h`; a test checks they agree).
-/
def closures : Nat := 4

/-- What a pointer of a struct points to, as C fills it in. -/
inductive Kind where
  /-- A string's bytes. -/
  | string
  /-- An optional string's bytes; null for none. -/
  | optString
  /-- An object's handle. -/
  | object
  /-- An optional object's handle; null for none. -/
  | optObject
  /-- A block of bytes, filled in by table number `table`; null if empty. -/
  | block (table : Nat)
  /--
  A struct's chain of extensions: each element filled in by its own table,
  each linked to the next by its first pointer; null if empty.
  -/
  | chain
  /--
  A callback's userdata: an optional closure, which C holds in the family
  being filled (`c/family.c`) at `ordinal`, and the family's ID; null for
  none.
  -/
  | optClosure (ordinal : Nat)
  /--
  A pointer left null, taking no target: an extension's `next`, which its
  chain links, or the chain of a struct no extension can join.
  -/
  | null
  deriving Repr, DecidableEq

/--
A kind's code, in C: the same as its target's constructor's index, and
`null`'s, which takes no target, after them.
-/
def Kind.code : Kind → UInt8
  | .string       => 0
  | .optString    => 1
  | .object       => 2
  | .optObject    => 3
  | .block _      => 4
  | .chain        => 5
  | .optClosure _ => 6
  | .null         => 7

/-- A pointer of a struct: its offset, and what it points to. -/
structure Reloc where
  offset : Nat
  kind   : Kind
  deriving Repr, DecidableEq

/--
Whether a relocation's numbers fit the 4 bytes `serialize` gives each, so that
the table says what it is.
-/
def Reloc.fits (r : Reloc) : Bool :=
  r.offset < 2 ^ 32 && match r.kind with
    | .block t      => t < 2 ^ 32
    | .optClosure k => k < 2 ^ 32
    | _             => true

/-- What a pointer is filled from: one for each kind but `null`. -/
inductive Target where
  | string    (s : String)
  | optString (s : Option String)
  | object    (o : Object)
  | optObject (o : Option Object)
  | block     (bytes : ByteArray)
  /-- A chain: each element's bytes, and its table's index. -/
  | chain     (links : Array (ByteArray × Nat))
  /-- A callback's closure, or none. -/
  | optClosure (c : Option Closure)

/-- The number `n` in 4 bytes, little-endian. -/
def le32 (n : Nat) : List UInt8 :=
  [n, n >>> 8, n >>> 16, n >>> 24].map (·.toUInt8)

/-- A relocation's 12 bytes. -/
def Reloc.bytes (r : Reloc) : List UInt8 :=
  let table := match r.kind with
    | .block t      => t
    | .optClosure k => k
    | _             => 0
  le32 r.offset ++ [r.kind.code, 0, 0, 0] ++ le32 table

/-- The table of a struct of `size` bytes, with these relocations. -/
def serialize (size : Nat) (relocs : List Reloc) : ByteArray :=
  ⟨(le32 size ++ le32 relocs.length ++ relocs.flatMap Reloc.bytes).toArray⟩

/-- A relocation is 12 bytes. -/
theorem length_bytes (r : Reloc) : r.bytes.length = 12 := by
  simp [Reloc.bytes, le32]

/-- A table is its header, 8 bytes, and 12 for each relocation. -/
theorem size_serialize (size : Nat) (relocs : List Reloc) :
    (serialize size relocs).size = 8 + 12 * relocs.length := by
  induction relocs with
  | nil => simp [serialize, le32, ByteArray.size]
  | cons r rs ih =>
    simp only [serialize, ByteArray.size, List.size_toArray, List.length_append,
      List.flatMap_cons, length_bytes] at ih ⊢
    simp [le32] at ih ⊢
    omega


/-! ## Callbacks kept

A struct can keep a callback, as a device descriptor keeps its device-lost
callback: in C an info, its mode, its function and its two userdata pointers.
In Lean it is an `Option` of the callback type's info structure, which says
what the encoder writes of it (`KeptCallback`): its mode's code; the address
of its trampoline, for its function; its closure, which the family being
filled holds, for its first userdata; and its ordinal there, for its second.
For none: mode 0, the address of the bindings' own handler, if any, or 0,
no closure, and 0.
-/

/-- What the encoder writes of a callback info of type `α`. -/
class KeptCallback (α : Type) where
  /-- Its mode's code; 0 for a callback with no mode. -/
  mode        : α → UInt32
  /-- Its closure, as its family holds it. -/
  closure     : α → Closure
  /-- The address of its trampoline. -/
  address     : UInt64
  /-- The address for none: the bindings' own handler's, or 0. -/
  noneAddress : UInt64

/-- An info's mode's code, or 0 for none. -/
def keptMode {α : Type} [KeptCallback α] : Option α → UInt32
  | some i => KeptCallback.mode i
  | none   => 0

/-- The address C calls for an info, or for none. -/
def keptAddress {α : Type} [KeptCallback α] : Option α → UInt64
  | some _ => KeptCallback.address α
  | none   => KeptCallback.noneAddress α

/-- An info's closure, for its family to hold. -/
def keptClosure {α : Type} [KeptCallback α] (i : Option α) : Option Closure :=
  i.map KeptCallback.closure

/-- An info's ordinal `k`, for its trampoline, or 0 for none. -/
def keptOrdinal {α : Type} (k : Nat) (i : Option α) : UInt64 :=
  if i.isSome then k.toUInt64 else 0

/-! ## The walk

Which targets `lean_wgpu_fill` takes, in which order, and of which kinds, as
Lean: the specification it implements (by review and test). A table, as the
walk reads it, is its struct's size and its relocations; each element of the
bytes takes, for each relocation but a null one, the next target, which must
be of its kind, and a block's own targets come next, by its own table, as a
chain's links' do, each by its own. The walk is none if a target is missing
or of the wrong kind, if the bytes are not whole elements, if a link is not
one element of its table whose first pointer is a null `next` at 0, where C
writes the link (`Spec.isLink`), if a closure's ordinal is not below
`closures`, where a family holds it, or if a block's or link's table does not
come before its own, as every generated one does: so it ends.

It says nothing of where C writes each pointer (each struct's pointers are
proved within it, `pointers64_within`), of alignment, or of a block being
held by nothing else (both checked in the checked build); nor that C reads
the table `serialize` lays out (by review and test), or that a kind's code
is its target's constructor's index (by test, of both); nor that an array's
count, a field of its struct, is its block's length in elements (by
construction: the generator writes both from the same array).
-/

/-- A table as the walk reads it: its struct's size, and its relocations. -/
abbrev Spec := Nat × List Reloc

/--
Whether `size` bytes can be a chain's link by the table `spec`: exactly one
of its structs, whose first pointer, at 0, is its `next`, left null by its
table for C to link.
-/
def Spec.isLink (spec : Spec) (size : Nat) : Bool :=
  size == spec.1 && spec.2.head? == some ⟨0, .null⟩

/--
A chain's links in turn, each by its own table of `specs` (`walk`), its
targets after it: the targets left after them all; none if one is not a link
by its table (`Spec.isLink`), as C writes each one's `next`.
-/
def walkLinks (specs : Array Spec)
    (walk : Nat → Nat → List Target → Option (List Target))
    (links : Array (ByteArray × Nat)) (ts : List Target) :
    Option (List Target) :=
  links.toList.foldlM (init := ts) fun ts link =>
    if specs[link.2]?.any (·.isLink link.1.size) then
      walk link.2 link.1.size ts
    else none

/--
One relocation's step: the targets after it, if the next is of its kind; a
chain's links by their tables of `specs`.
-/
def step (specs : Array Spec)
    (walk : Nat → Nat → List Target → Option (List Target)) (r : Reloc)
    (ts : List Target) : Option (List Target) :=
  match r.kind, ts with
  | .null,         ts                  => some ts
  | .string,       .string _ :: ts     => some ts
  | .optString,    .optString _ :: ts  => some ts
  | .object,       .object _ :: ts     => some ts
  | .optObject,    .optObject _ :: ts  => some ts
  | .block j,      .block bytes :: ts  => walk j bytes.size ts
  | .chain,        .chain links :: ts  => walkLinks specs walk links ts
  | .optClosure k, .optClosure _ :: ts =>
    if k < closures then some ts else none
  | _,             _                   => none

/--
The targets left after filling in `size` bytes by table `table` of `specs`,
from `targets`; none if they do not agree.
-/
def walk (specs : Array Spec) (table size : Nat) (targets : List Target) :
    Option (List Target) := do
  let (stride, relocs) ← specs[table]?
  if stride = 0 ∨ size % stride ≠ 0 then none
  else
    (List.replicate (size / stride) ()).foldlM (init := targets) fun ts _ =>
      relocs.foldlM (init := ts) fun ts r =>
        step specs
          (fun j size ts => if j < table then walk specs j size ts else none)
          r ts
termination_by table


/--
One element's walk: its relocations, in turn, from `ts`, a block by `walk`,
its table before `table`.
-/
def element (specs : Array Spec) (table : Nat) (relocs : List Reloc)
    (ts : List Target) : Option (List Target) :=
  relocs.foldlM (init := ts) fun ts r =>
    step specs (fun j size ts =>
      if j < table then walk specs j size ts else none) r ts

/-- The walk, element by element. -/
theorem walk_def (specs : Array Spec) (table size : Nat) (ts : List Target) :
    walk specs table size ts = match specs[table]? with
      | none                  => none
      | some (stride, relocs) =>
        if stride = 0 ∨ size % stride ≠ 0 then none
        else (List.replicate (size / stride) ()).foldlM (init := ts)
          fun ts _ => element specs table relocs ts := by
  rw [walk]
  cases specs[table]? <;> rfl

/-- Elements in turn, each taking exactly its own targets, take all theirs. -/
theorem foldlM_replicate {g : List Target → Option (List Target)}
    (parts : List (List Target)) (hg : ∀ p ∈ parts, ∀ ts, g (p ++ ts) = some ts)
    (ts : List Target) :
    (List.replicate parts.length ()).foldlM (init := parts.flatten ++ ts)
      (fun ts _ => g ts) = some ts := by
  induction parts with
  | nil => rfl
  | cons p ps ih =>
    simp only [List.length_cons, List.replicate_succ, List.foldlM_cons,
      List.flatten_cons, List.append_assoc]
    rw [hg p (List.mem_cons_self ..)]
    exact ih fun q hq => hg q (List.mem_cons_of_mem _ hq)

/--
A block of elements, each taking exactly its own targets by its table, takes
exactly all theirs, in turn: a struct is a block of one, an array a block of
its elements.
-/
theorem walk_elements {α : Type} {specs : Array Spec} {table stride : Nat}
    {relocs : List Reloc} (h : specs[table]? = some (stride, relocs))
    (hstride : stride ≠ 0) (xs : List α) (f : α → List Target) (size : Nat)
    (hsize : size = xs.length * stride)
    (he : ∀ x ∈ xs, ∀ ts, element specs table relocs (f x ++ ts) = some ts)
    (ts : List Target) :
    walk specs table size (xs.flatMap f ++ ts) = some ts := by
  rw [walk_def, h]
  have hdiv : size / stride = (xs.map f).length := by
    rw [hsize, Nat.mul_div_cancel _ (Nat.pos_of_ne_zero hstride),
      List.length_map]
  have hmod : size % stride = 0 := by
    rw [hsize, Nat.mul_mod_left]
  simp only [hstride, hmod, ne_eq, not_true_eq_false, or_self, ite_false,
    hdiv, List.flatMap_def]
  exact foldlM_replicate _ (fun p hp ts => by
    obtain ⟨x, hx, rfl⟩ := List.mem_map.1 hp
    exact he x hx ts) ts

/-- A struct is a block of one element. -/
theorem walk_one {α : Type} {specs : Array Spec} {table stride : Nat}
    {relocs : List Reloc} (h : specs[table]? = some (stride, relocs))
    (hstride : stride ≠ 0) (x : α) (f : α → List Target) (size : Nat)
    (hsize : size = stride)
    (he : ∀ ts, element specs table relocs (f x ++ ts) = some ts)
    (ts : List Target) :
    walk specs table size (f x ++ ts) = some ts := by
  have := walk_elements h hstride [x] f size (by simp [hsize])
    (fun y hy ts => by rw [List.mem_singleton.1 hy]; exact he ts) ts
  simpa using this

/-- An empty block takes no targets: an optional struct that is none. -/
theorem walk_empty {specs : Array Spec} {table stride : Nat}
    {relocs : List Reloc} (h : specs[table]? = some (stride, relocs))
    (hstride : stride ≠ 0) (ts : List Target) :
    walk specs table 0 ts = some ts := by
  rw [walk, h]
  simp [hstride]


/--
An optional struct as what C fills a pointer to it in from: its block, by
`block`, or for none, an empty block, a null pointer.
-/
def optBlock {α : Type} (block : α → Array Target) : Option α → Array Target
  | none   => #[.block .empty]
  | some x => block x

/-! ## Arrays

An array's elements are a block of their own, walked by a table: a struct's,
for an array of structs; and for the rest, one of two shared tables, first of
all the tables. An array of enums is a block of `UInt32`s with no pointers
(`wordsSpec`). An array of objects is a block of handles, each a pointer
filled in from an object (`objectsSpec`), the objects the targets after it. -/

/-- The table of an array of `UInt32`s: elements of 4 bytes, no pointers. -/
def wordsSpec : Spec := (4, [])

/-- The table of an array of objects, pointers of `ptr` bytes: each a handle. -/
def objectsSpec (ptr : Nat) : Spec := (ptr, [⟨0, .object⟩])

/--
The block of an array of objects, pointers of `ptr` bytes: zeros, for C to
fill in. `@[noinline]`, so that no function holds two of its fresh blocks.
-/
@[noinline, never_extract]
def objectsBlock {α : Type} (ptr : Nat) (xs : Array α) : ByteArray :=
  Bytes.freshZeros (xs.size * ptr)

/-- An array of objects' targets: each element as an object, by `g`. -/
def objectsOf {α : Type} (g : α → Object) (xs : Array α) : Array Target :=
  xs.map fun x => .object (g x)

/--
An array's elements' targets, each element's in turn, appended to `init`: no
list built.
-/
@[inline]
def targetsOfAll {α : Type} (f : α → Array Target) (xs : Array α) :
    Array Target :=
  xs.foldl (fun acc x => acc ++ f x) (Array.emptyWithCapacity xs.size)

/-- They are each element's targets, in turn. -/
theorem toList_targetsOfAll {α : Type} (f : α → Array Target) (xs : Array α) :
    (targetsOfAll f xs).toList = xs.toList.flatMap fun x => (f x).toList := by
  rw [targetsOfAll, ← Array.foldl_toList]
  -- Each element appends its own to what is there.
  have : ∀ (l : List α) (acc : Array Target),
      (l.foldl (fun acc x => acc ++ f x) acc).toList
        = acc.toList ++ l.flatMap fun x => (f x).toList := by
    intro l
    induction l with
    | nil => simp
    | cons x l ih => intro acc; simp [ih, List.append_assoc]
  rw [this]
  simp [Array.emptyWithCapacity]

/--
An empty chain's targets: a constant, made once. A literal in `chainTargetsOf`
would be built anew at each call, as it is inlined into the makers of
targets, which are `@[never_extract]`; C walks no link of it, nor writes.
-/
def emptyChainTargets : Array Target := #[.chain #[]]

/--
A chain's targets: the chain, each link by `link`, then each link's own
targets, by `targets`. Most chains are empty, whose targets are a constant,
`emptyChainTargets`: no array built.
-/
@[inline]
def chainTargetsOf {α : Type} (link : α → ByteArray × Nat)
    (targets : α → Array Target) (chain : Array α) : Array Target :=
  if chain.isEmpty then emptyChainTargets
  else #[.chain (chain.map link)] ++ targetsOfAll targets chain

/-- They are the chain's, then its links' targets, empty or not. -/
@[simp]
theorem chainTargetsOf_eq {α : Type} (link : α → ByteArray × Nat)
    (targets : α → Array Target) (chain : Array α) :
    chainTargetsOf link targets chain
      = #[.chain (chain.map link)] ++ targetsOfAll targets chain := by
  unfold chainTargetsOf
  split
  · simp_all [Array.isEmpty_iff, targetsOfAll, emptyChainTargets]
  · rfl

/--
A chain of links, each a link by its own table and taking exactly its own
targets, takes all theirs, in turn: the targets of a struct's chain, each
element by its own table.
-/
theorem walkLinks_map {specs : Array Spec}
    {walk : Nat → Nat → List Target → Option (List Target)}
    {α : Type} (link : α → ByteArray × Nat) (targets : α → Array Target)
    (hl : ∀ x, specs[(link x).2]?.any (·.isLink (link x).1.size))
    (h : ∀ x ts,
      walk (link x).2 (link x).1.size ((targets x).toList ++ ts) = some ts)
    (xs : Array α) (ts : List Target) :
    walkLinks specs walk (xs.map link)
      ((targetsOfAll targets xs).toList ++ ts) = some ts := by
  rw [walkLinks, toList_targetsOfAll, Array.toList_map]
  induction xs.toList generalizing ts with
  | nil => rfl
  | cons x xs ih =>
    simp only [List.map_cons, List.foldlM_cons, List.flatMap_cons,
      List.append_assoc, hl, h, if_true]
    exact ih ts

/-- An array of enums takes no targets. -/
theorem walk_words {specs : Array Spec} {table : Nat}
    (h : specs[table]? = some wordsSpec) {α : Type} (f : α → UInt32)
    (xs : Array α) (ts : List Target) :
    walk specs table (encodeU32s f xs).size ts = some ts := by
  have := walk_elements h (by decide) xs.toList (fun _ => [])
    (encodeU32s f xs).size
    (by rw [size_encodeU32s, Array.length_toList])
    (fun _ _ ts => by simp [element]) ts
  have hnil : ∀ l : List α, l.flatMap (fun _ => ([] : List Target)) = [] := by
    intro l; induction l <;> simp_all
  simpa [hnil] using this

/-- An array of objects takes exactly its objects. -/
theorem walk_objects {specs : Array Spec} {table ptr : Nat}
    (h : specs[table]? = some (objectsSpec ptr)) (hptr : ptr ≠ 0)
    {α : Type} (g : α → Object) (xs : Array α) (ts : List Target) :
    walk specs table (objectsBlock ptr xs).size
      ((objectsOf g xs).toList ++ ts) = some ts := by
  have := walk_elements h hptr xs.toList (fun x => [.object (g x)])
    (objectsBlock ptr xs).size
    (by rw [objectsBlock, Bytes.size_freshZeros, Array.length_toList])
    (fun _ _ ts => by simp [element, step]) ts
  have hmap : ∀ l : List α,
      l.flatMap (fun x => [Target.object (g x)])
        = l.map fun x => .object (g x) := by
    intro l; induction l <;> simp_all
  simpa [objectsOf, hmap] using this

/-! ## Structs C fills in

A struct of `webgpu.h`, as the bindings pass it to C (`CStruct`): its bytes,
with its pointers 0; its targets, what C fills each pointer in from; its
table's index; and whether each of its `size_t`s fits the target. And, apart,
the proofs that make that safe (`CStruct.Fills`): that its bytes are one
struct, the size its table is for, and that walking its table over them takes
exactly its targets. The proofs are a `Prop`, so they cost nothing at run time,
and can be of tables that exist only for them. -/

/-- A struct C fills in: the generated bindings give every bound struct one. -/
class CStruct (T : Type) where
  /-- Its bytes, as C lays it out, its pointers 0. -/
  toBytes    : T → ByteArray
  /-- What C fills in its pointers from, in order. -/
  toTargets  : T → Array Target
  /-- Its table's index. -/
  tableIndex : Nat
  /-- Whether each of its `size_t`s fits the target. -/
  sizesFit   : T → Bool

/--
That C fills in a struct as its table in `specs`, the tables as the walk reads
them, says: the generated bindings prove it of every bound struct, by the
tables of the target the program runs on.
-/
class CStruct.Fills (specs : Array Spec) (T : Type) [CStruct T] : Prop where
  /-- Its bytes are one struct: the size its table is for. -/
  size_toBytes : ∀ d : T, ∃ relocs,
    specs[CStruct.tableIndex T]? = some ((CStruct.toBytes d).size, relocs)
  /-- Walking its table over its bytes takes exactly its targets. -/
  fills        : ∀ (d : T) ts,
    walk specs (CStruct.tableIndex T) (CStruct.toBytes d).size
      ((CStruct.toTargets d).toList ++ ts) = some ts

/--
An optional struct's bytes: none's are empty, a null pointer. Never computed
once, as a constant: C writes into the bytes.
-/
@[never_extract]
def CStruct.optBytes {T : Type} [CStruct T] : Option T → ByteArray
  | none   => .empty
  | some d => toBytes d

/--
An optional struct's targets: none has none. Never computed once, as a
constant: C writes into its blocks.
-/
@[never_extract]
def CStruct.optTargets {T : Type} [CStruct T] : Option T → Array Target
  | none   => #[]
  | some d => toTargets d

/-- Whether each `size_t` of an optional struct fits: none has none. -/
def CStruct.optSizesFit {T : Type} [CStruct T] : Option T → Bool
  | none   => true
  | some d => sizesFit d

/-! ### What a shim takes

A function that takes a struct passes C its bytes, its targets and its table's
index: each typed as exactly the struct's own, so that nothing else can be
passed. A subtype of one field is that field at run time: these cost nothing. -/

/-- `d`'s bytes, and no others. -/
abbrev BytesOf {T : Type} [CStruct T] (d : T) :=
  {b : ByteArray // b = CStruct.toBytes d}

/-- `d`'s targets, and no others. -/
abbrev TargetsOf {T : Type} [CStruct T] (d : T) :=
  {t : Array Target // t = CStruct.toTargets d}

/-- An optional struct's bytes, and no others. -/
abbrev OptBytesOf {T : Type} [CStruct T] (d : Option T) :=
  {b : ByteArray // b = CStruct.optBytes d}

/-- An optional struct's targets, and no others. -/
abbrev OptTargetsOf {T : Type} [CStruct T] (d : Option T) :=
  {t : Array Target // t = CStruct.optTargets d}

/-- `T`'s table's index, and no other. -/
abbrev IndexOf (T : Type) [CStruct T] :=
  {i : Nat // i = CStruct.tableIndex T}

/-!
A function that takes an array of objects passes C the array and a block of
zeros, a pointer wide an object on this target, which C fills with their
handles (`lean_wgpu_fill_objects`) and passes, with the array's size; one
that takes an array of `UInt32`s passes the block of them, as C lays them
out. Each block is typed as exactly the array's own.
-/

/-- The zeroed block for the handles of `xs`, and no other. -/
abbrev ObjectsBlockOf {α : Type} (xs : Array α) :=
  {b : ByteArray // b = objectsBlock Width.current.bytes xs}

/-- The block of `xs`, as C lays them out, and no other. -/
abbrev U32sOf (xs : Array UInt32) :=
  {b : ByteArray // b = encodeU32s id xs}

end WebGPU.Raw.Reloc

end
