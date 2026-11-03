module

public import WebGPU.Raw.Internal.Bytes

/-!
# Packing a struct

A helper for the generated bindings, not part of the API: the bindings import
this module privately, so it never reaches their users.

A struct of `webgpu.h`, packed as C lays it out: its bytes, each scalar written
at its offset, and its pointers as slots, each an offset and what the pointer
is to be to (a string, an object, another packed struct), for C to fill in
(`α`). A struct's `Layout` is its size and its scalars, each at its offset,
however deeply its fields nest, as the generator's layout model gives them and
the C compiler checks against `webgpu.h`.

For a well-formed layout (its scalars in order, aligned, none overlapping, all
within the struct), `pack` gives bytes of the struct's size, in which:

    theorem readLE_pack : every scalar reads back as its value, and each
      pointer as 0, for C to fill in
    theorem slot_mem_pack : each slot is a pointer of the layout, with its
      value, aligned, within the struct
    theorem slot_apart : a slot is apart from every other scalar
    theorem slots_pairwise : the slots are in order, none overlapping

Packing refuses values that are not of the layout's scalars, and a `size_t`
that does not fit the target (`Value.fits`), as a function's argument would.
-/

@[expose] public section

namespace WebGPU.Raw.Pack
open WebGPU.Raw.Bytes

/-! ## Writes that do not overlap -/

/-- A write: an offset, a width in bytes, and the number to write there. -/
abbrev Write := Nat × Nat × Nat

/-- One write ends before the other begins. -/
def Write.Apart (a b : Write) : Prop :=
  a.1 + a.2.1 ≤ b.1 ∨ b.1 + b.2.1 ≤ a.1

/-- `bytes` with each write made, in order, each whole if it fits. -/
def writeAll (bytes : ByteArray) (writes : List Write) : ByteArray :=
  writes.foldl (fun b (offset, width, n) => writeWhole b offset width n) bytes

/-- Making writes one after another. -/
theorem writeAll_cons (bytes : ByteArray) (w : Write) (writes : List Write) :
    writeAll bytes (w :: writes)
      = writeAll (writeWhole bytes w.1 w.2.1 w.2.2) writes := by
  unfold writeAll
  rfl

/-- Making writes keeps the array's size. -/
theorem size_writeAll (bytes : ByteArray) (writes : List Write) :
    (writeAll bytes writes).size = bytes.size := by
  induction writes generalizing bytes with
  | nil => rfl
  | cons w writes ih =>
    simp only [writeAll, List.foldl_cons] at ih ⊢
    rw [ih, size_writeWhole]

/-- Bytes apart from every write read as they were. -/
theorem readLE_writeAll_apart (bytes : ByteArray) (writes : List Write)
    (offset width : Nat) (h : ∀ w ∈ writes, Write.Apart w (offset, width, 0)) :
    readLE (writeAll bytes writes) offset width
      = readLE bytes offset width := by
  induction writes generalizing bytes with
  | nil => rfl
  | cons w writes ih =>
    simp only [writeAll, List.foldl_cons] at ih ⊢
    rw [ih _ fun w' hw' => h w' (List.mem_cons_of_mem _ hw')]
    obtain ⟨o, k, n⟩ := w
    have := h (o, k, n) (List.mem_cons_self ..)
    simp only [Write.Apart] at this
    exact readLE_writeWhole_disjoint _ _ _ _ _ _ this

/--
Of writes that do not overlap, each within the array, each reads back after
all are made.
-/
theorem readLE_writeAll (bytes : ByteArray) (writes : List Write)
    (hapart : writes.Pairwise Write.Apart)
    (hfit : ∀ w ∈ writes, w.1 + w.2.1 ≤ bytes.size) :
    ∀ w ∈ writes,
      readLE (writeAll bytes writes) w.1 w.2.1 = w.2.2 % 256 ^ w.2.1 := by
  induction writes generalizing bytes with
  | nil => simp
  | cons x writes ih =>
    intro w hw
    rw [writeAll_cons]
    obtain ⟨hx, hrest⟩ := List.pairwise_cons.1 hapart
    by_cases hin : w ∈ writes
    · apply ih _ hrest _ w hin
      intro w' hw'
      rw [size_writeWhole]
      exact hfit w' (List.mem_cons_of_mem _ hw')
    · have hwx : w = x := by
        rcases List.mem_cons.1 hw with h | h
        · exact h
        · exact absurd h hin
      subst hwx
      rw [readLE_writeAll_apart _ _ _ _ fun w' hw' => by
        have := hx w' hw'
        obtain ⟨o, k, n⟩ := w
        obtain ⟨o', k', n'⟩ := w'
        simp only [Write.Apart] at this ⊢
        omega]
      exact readLE_writeWhole _ _ _ _ (hfit w (List.mem_cons_self ..))

/--
An entry: an offset, a width, and the number to write there, or none for bytes
left for C to fill in.
-/
abbrev Entry := Nat × Nat × Option Nat

/-- One entry ends before the other begins. -/
def Entry.Apart (a b : Entry) : Prop :=
  a.1 + a.2.1 ≤ b.1 ∨ b.1 + b.2.1 ≤ a.1

/-- An entry's write, if it has a number to write. -/
def Entry.write? (e : Entry) : Option Write :=
  e.2.2.map fun n => (e.1, e.2.1, n)

/--
Of entries that do not overlap, each within the array, each reads back after
all are written: as its number, or, if it has none, as it read before.
-/
theorem readLE_writeAll_entries (bytes : ByteArray) (entries : List Entry)
    (hapart : entries.Pairwise Entry.Apart)
    (hfit : ∀ e ∈ entries, e.1 + e.2.1 ≤ bytes.size) :
    ∀ e ∈ entries,
      readLE (writeAll bytes (entries.filterMap Entry.write?)) e.1 e.2.1
        = match e.2.2 with
          | some n => n % 256 ^ e.2.1
          | none   => readLE bytes e.1 e.2.1 := by
  induction entries generalizing bytes with
  | nil => simp
  | cons x entries ih =>
    intro e he
    obtain ⟨hx, hrest⟩ := List.pairwise_cons.1 hapart
    have hfit' : ∀ e ∈ entries, e.1 + e.2.1 ≤ bytes.size :=
      fun e he => hfit e (List.mem_cons_of_mem _ he)
    -- Writing `x` first: where it writes, if it does.
    let after := match x.write? with
      | some w => writeWhole bytes w.1 w.2.1 w.2.2
      | none => bytes
    have hafter : writeAll bytes ((x :: entries).filterMap Entry.write?)
        = writeAll after (entries.filterMap Entry.write?) := by
      simp only [List.filterMap_cons, after]
      cases x.write? <;> simp [writeAll_cons]
    have hsize : after.size = bytes.size := by
      simp only [after]
      cases x.write? <;> simp [size_writeWhole]
    rw [hafter]
    -- An entry apart from `x` reads in `after` as it did before.
    have happart : ∀ e, Entry.Apart x e →
        readLE after e.1 e.2.1 = readLE bytes e.1 e.2.1 := by
      intro e hxe
      simp only [after]
      cases hw : x.write? with
      | none => rfl
      | some w =>
        simp only [Entry.write?, Option.map_eq_some_iff] at hw
        obtain ⟨n, -, rfl⟩ := hw
        simp only [Entry.Apart] at hxe
        exact readLE_writeWhole_disjoint _ _ _ _ _ _ hxe
    by_cases hin : e ∈ entries
    · rw [ih after hrest (fun e he => hsize ▸ hfit' e he) e hin]
      cases e.2.2 with
      | some n => rfl
      | none => exact happart e (hx e hin)
    · have hex : e = x := by
        rcases List.mem_cons.1 he with h | h
        · exact h
        · exact absurd h hin
      subst hex
      rw [readLE_writeAll_apart _ _ _ _ fun w hw => by
        simp only [List.mem_filterMap, Entry.write?, Option.map_eq_some_iff]
          at hw
        obtain ⟨f, hf, n, -, rfl⟩ := hw
        have := hx f hf
        obtain ⟨o, k, _⟩ := e
        obtain ⟨o', k', _⟩ := f
        simp only [Entry.Apart, Write.Apart] at this ⊢
        omega]
      simp only [after]
      cases hn : e.2.2 with
      | none => simp [Entry.write?, hn]
      | some n =>
        simp only [Entry.write?, hn, Option.map_some]
        exact readLE_writeWhole _ _ _ _ (hfit e (List.mem_cons_self ..))

/-! ## Layouts and values -/

/-- How wide the target's pointers and `size_t` are. -/
inductive Width where
  /-- wasm32: 4 bytes. -/
  | bits32
  /-- Every native target the bindings support: 8 bytes. -/
  | bits64
  deriving Repr, DecidableEq

/-- The width of the target the program runs on. -/
def Width.current : Width :=
  if System.Platform.numBits = 64 then .bits64 else .bits32

/-- The bytes in a pointer or `size_t`. -/
def Width.bytes : Width → Nat
  | .bits32 => 4
  | .bits64 => 8

/-- A scalar of a struct, by its C type, as the layout model has it. -/
inductive Scalar where
  | u8
  | u16
  | u32
  | u64
  | f32
  | f64
  | ptr
  /-- A `size_t`. -/
  | size
  deriving Repr, DecidableEq

/-- A scalar's size in bytes, and its alignment. -/
def Scalar.bytes (w : Width) : Scalar → Nat
  | .u8          => 1
  | .u16         => 2
  | .u32 | .f32  => 4
  | .u64 | .f64  => 8
  | .ptr | .size => w.bytes

/-- A struct's layout: its size, and each scalar at its offset, in order. -/
structure Layout where
  size    : Nat
  scalars : List (Nat × Scalar)
  deriving Repr

/--
A layout packing can write: of a size offsets fit in, with each scalar aligned
and within the struct, and each ending before the next begins. These are what
`flatten_spec` of the generator's layout model proves of every layout it gives;
the bindings cannot import the generator, so the generator is to write each
layout out, with a proof by `decide` that it is well-formed, which Lean's kernel
checks.
-/
def Layout.WellFormed (w : Width) (layout : Layout) : Prop :=
  layout.size < 2 ^ 32
    ∧ (∀ s ∈ layout.scalars,
      s.2.bytes w ∣ s.1 ∧ s.1 + s.2.bytes w ≤ layout.size)
    ∧ layout.scalars.Pairwise fun a b => a.1 + a.2.bytes w ≤ b.1

/-- A value for one scalar; a pointer is to `α`, for C to fill in. -/
inductive Value (α : Type) where
  | u8   (v : UInt8)
  | u16  (v : UInt16)
  | u32  (v : UInt32)
  | u64  (v : UInt64)
  | f32  (v : Float32)
  | f64  (v : Float)
  /--
  A `size_t`, as the bindings pass one: on wasm32 it must fit in 32 bits, or be
  the largest `UInt64`, which stands for `SIZE_MAX` (`Value.fits`).
  -/
  | size (n : UInt64)
  | ptr  (target : α)

/-- The scalar a value is for. -/
def Value.scalar {α : Type} : Value α → Scalar
  | .u8 _   => .u8
  | .u16 _  => .u16
  | .u32 _  => .u32
  | .u64 _  => .u64
  | .f32 _  => .f32
  | .f64 _  => .f64
  | .size _ => .size
  | .ptr _  => .ptr

/-- The largest `UInt64`, which stands for `SIZE_MAX` on every target. -/
def sizeMax : UInt64 := 0xFFFF_FFFF_FFFF_FFFF

/--
Whether a value can be packed for the target: a `size_t` on wasm32 must fit in
32 bits, or be `sizeMax`, as a function's `size_t` argument must.
-/
def Value.fits {α : Type} (w : Width) : Value α → Bool
  | .size n => match w with
    | .bits32 => n.toNat < 2 ^ 32 || n == sizeMax
    | .bits64 => true
  | _ => true

/--
The number a value's bytes hold, little-endian; none for a pointer. On wasm32,
`sizeMax` is `SIZE_MAX`, 32 bits of ones.
-/
def Value.bits? {α : Type} (w : Width) : Value α → Option Nat
  | .u8 v   => some v.toNat
  | .u16 v  => some v.toNat
  | .u32 v  => some v.toNat
  | .u64 v  => some v.toNat
  | .f32 v  => some v.toBits.toNat
  | .f64 v  => some v.toBits.toNat
  | .size n => some (match w with
    | .bits32 => if n = sizeMax then 0xFFFF_FFFF else n.toNat
    | .bits64 => n.toNat)
  | .ptr _  => none

/-- What a pointer is to, if the value is one. -/
def Value.slot? {α : Type} : Value α → Option α
  | .ptr target => some target
  | _           => none

/-- `bytes` with the value written at `offset`; a pointer is not written. -/
def Value.write {α : Type} (w : Width) (bytes : ByteArray) (offset : Nat) :
    Value α → ByteArray
  | .u8 v   => writeU8 bytes offset.toUSize v
  | .u16 v  => writeU16 bytes offset.toUSize v
  | .u32 v  => writeU32 bytes offset.toUSize v
  | .u64 v  => writeU64 bytes offset.toUSize v
  | .f32 v  => writeF32 bytes offset.toUSize v
  | .f64 v  => writeF64 bytes offset.toUSize v
  | .size n => match w with
    | .bits32 => writeU32 bytes offset.toUSize
      (if n = sizeMax then 0xFFFF_FFFF else n.toUInt32)
    | .bits64 => writeU64 bytes offset.toUSize n
  | .ptr _  => bytes

/-! ## Packing -/

/--
A packed struct: its bytes, and its pointers, each an offset and what the
pointer there is to be to. The bytes at each are 0, for C to fill in; so are
any between scalars, which C leaves as padding.
-/
structure Packed (α : Type) where
  bytes : ByteArray
  slots : List (Nat × α)

/--
A struct packed by its layout, from a value for each scalar, in order; or why
it cannot be: the values are not of the layout's scalars, or one does not fit
the target (`Value.fits`).
-/
def pack {α : Type} (w : Width) (layout : Layout) (values : List (Value α)) :
    Except String (Packed α) :=
  if layout.scalars.map (·.2) = values.map (·.scalar) then
    if values.all (·.fits w) then
      let pairs := layout.scalars.zip values
      .ok {
        bytes := pairs.foldl (fun b ((offset, _), v) => v.write w b offset)
          (zeros layout.size)
        slots := pairs.filterMap fun ((offset, _), v) => v.slot?.map (offset, ·)
      }
    else
      .error s!"value {values.findIdx (!·.fits w)}: a size too large for a \
        32-bit size_t"
  else .error "the values are not of the layout's scalars"

/-! ## What packing writes -/

/-- An offset within a struct converts to a `USize` exactly. -/
theorem toNat_toUSize_of_lt {offset : Nat} (h : offset < 2 ^ 32) :
    offset.toUSize.toNat = offset :=
  USize.toNat_ofNat_of_lt' (Nat.lt_of_lt_of_le h USize.le_size)

/-- A value that fits is written whole: its number, at its width. -/
theorem Value.write_eq {α : Type} (w : Width) (bytes : ByteArray)
    (offset : Nat) (v : Value α) (h : offset < 2 ^ 32) (hfit : v.fits w) :
    v.write w bytes offset = match v.bits? w with
      | some n => writeWhole bytes offset (v.scalar.bytes w) n
      | none   => bytes := by
  cases v with
  | size n =>
    cases w with
    | bits64 =>
      simp [Value.write, Value.bits?, Value.scalar, Scalar.bytes, Width.bytes,
        writeU64, toNat_toUSize_of_lt h]
    | bits32 =>
      simp only [Value.fits, Bool.or_eq_true, decide_eq_true_eq,
        beq_iff_eq] at hfit
      simp only [Value.write, Value.bits?, Value.scalar, Scalar.bytes,
        Width.bytes, writeU32, toNat_toUSize_of_lt h]
      by_cases hmax : n = sizeMax
      · simp [hmax]
      · have hlt : n.toNat < 2 ^ 32 := hfit.resolve_right hmax
        simp [hmax, UInt64.toNat_toUInt32, Nat.mod_eq_of_lt hlt]
  | ptr _ => rfl
  | _ =>
    simp [Value.write, Value.bits?, Value.scalar, Scalar.bytes, writeU8,
      writeU16, writeU32, writeU64, writeF32, writeF64, toNat_toUSize_of_lt h]

/-- A value that fits has a number that fits its width. -/
theorem Value.bits_lt {α : Type} (w : Width) (v : Value α) (n : Nat)
    (hfit : v.fits w) (h : v.bits? w = some n) :
    n < 256 ^ v.scalar.bytes w := by
  cases v with
  | u8 x =>
    cases h; have := x.toNat_lt; simp [Value.scalar, Scalar.bytes]; omega
  | u16 x =>
    cases h; have := x.toNat_lt; simp [Value.scalar, Scalar.bytes]; omega
  | u32 x =>
    cases h; have := x.toNat_lt; simp [Value.scalar, Scalar.bytes]; omega
  | u64 x =>
    cases h; have := x.toNat_lt; simp [Value.scalar, Scalar.bytes]; omega
  | f32 x =>
    cases h; have := x.toBits.toNat_lt; simp [Value.scalar, Scalar.bytes]; omega
  | f64 x =>
    cases h; have := x.toBits.toNat_lt; simp [Value.scalar, Scalar.bytes]; omega
  | size m =>
    cases w with
    | bits64 =>
      simp only [Value.bits?, Option.some.injEq] at h
      subst h
      have := m.toNat_lt
      simp [Value.scalar, Scalar.bytes, Width.bytes]; omega
    | bits32 =>
      simp only [Value.fits, Bool.or_eq_true, decide_eq_true_eq,
        beq_iff_eq] at hfit
      simp only [Value.bits?, Option.some.injEq] at h
      subst h
      simp only [Value.scalar, Scalar.bytes, Width.bytes]
      split
      · decide
      · next hmax => have := hfit.resolve_right hmax; omega
  | ptr _ => cases h

/-- A scalar and its value, as an entry: its offset, width and number. -/
def toEntry {α : Type} (w : Width) (pair : (Nat × Scalar) × Value α) : Entry :=
  (pair.1.1, pair.1.2.bytes w, pair.2.bits? w)

/-- Packing's writes, value by value, are the entries' writes. -/
theorem foldl_write_eq {α : Type} (w : Width) :
    ∀ (pairs : List ((Nat × Scalar) × Value α)) (bytes : ByteArray),
      (∀ p ∈ pairs, p.1.2 = p.2.scalar ∧ p.1.1 < 2 ^ 32 ∧ p.2.fits w) →
        pairs.foldl (fun b ((offset, _), v) => v.write w b offset) bytes
          = writeAll bytes ((pairs.map (toEntry w)).filterMap Entry.write?)
  | [], _, _ => rfl
  | ((o, k), v) :: pairs, bytes, h => by
    obtain ⟨hk, ho, hfit⟩ := h ((o, k), v) (List.mem_cons_self ..)
    simp only at hk ho hfit
    simp only [List.foldl_cons, List.map_cons, List.filterMap_cons]
    rw [Value.write_eq w bytes o v ho hfit]
    cases hb : v.bits? w with
    | none =>
      simp only [toEntry, hb, Entry.write?, Option.map_none]
      exact foldl_write_eq w pairs bytes
        fun p hp => h p (List.mem_cons_of_mem _ hp)
    | some n =>
      simp only [toEntry, hb, Entry.write?, Option.map_some, writeAll_cons, hk]
      exact foldl_write_eq w pairs _
        fun p hp => h p (List.mem_cons_of_mem _ hp)

/-- Of two lists mapped alike, the pairs of their zip are alike. -/
theorem eq_of_mem_zip {β γ δ : Type} {f : β → δ} {g : γ → δ} :
    ∀ {l₁ : List β} {l₂ : List γ}, l₁.map f = l₂.map g →
      ∀ p ∈ l₁.zip l₂, f p.1 = g p.2
  | [], _, _, _, hp => by simp at hp
  | _ :: _, [], h, _, _ => by simp at h
  | a :: l₁, b :: l₂, h, p, hp => by
    simp only [List.map_cons, List.cons.injEq] at h
    rcases List.mem_cons.1 hp with rfl | hp
    · exact h.1
    · exact eq_of_mem_zip h.2 p hp

/-- A zip is in order as its first list is. -/
theorem pairwise_zip {β γ : Type} {R : β → β → Prop} :
    ∀ {l₁ : List β} {l₂ : List γ}, l₁.Pairwise R →
      (l₁.zip l₂).Pairwise fun a b => R a.1 b.1
  | [], _, _ => by simp
  | _ :: _, [], _ => by simp
  | a :: l₁, b :: l₂, h => by
    obtain ⟨ha, h⟩ := List.pairwise_cons.1 h
    simp only [List.zip_cons_cons, List.pairwise_cons]
    exact ⟨fun p hp => ha p.1 (List.of_mem_zip hp).1, pairwise_zip h⟩

/-- Of a list in order, two members are one, or one comes before the other. -/
theorem eq_or_of_pairwise {β : Type} {R : β → β → Prop} :
    ∀ {l : List β}, l.Pairwise R → ∀ {a b}, a ∈ l → b ∈ l →
      a = b ∨ R a b ∨ R b a
  | [], _, _, _, ha, _ => by simp at ha
  | x :: l, h, a, b, ha, hb => by
    obtain ⟨hx, h⟩ := List.pairwise_cons.1 h
    rcases List.mem_cons.1 ha with hax | hal <;>
      rcases List.mem_cons.1 hb with hbx | hbl
    · exact .inl (hax.trans hbx.symm)
    · subst hax; exact .inr (.inl (hx b hbl))
    · subst hbx; exact .inr (.inr (hx a hal))
    · exact eq_or_of_pairwise h hal hbl

/-! ## What a packed struct holds -/

/-- Writing a value keeps the array's size. -/
theorem Value.size_write {α : Type} (w : Width) (bytes : ByteArray)
    (offset : Nat) (v : Value α) :
    (v.write w bytes offset).size = bytes.size := by
  cases v with
  | size n => cases w <;> exact size_writeWhole ..
  | ptr _ => rfl
  | _ => exact size_writeWhole ..

/-- Writing values keeps the array's size. -/
theorem size_foldl_write {α : Type} (w : Width) :
    ∀ (pairs : List ((Nat × Scalar) × Value α)) (bytes : ByteArray),
      (pairs.foldl (fun b ((offset, _), v) => v.write w b offset) bytes).size
        = bytes.size
  | [], _ => rfl
  | _ :: pairs, bytes => by
    simp only [List.foldl_cons]
    rw [size_foldl_write w pairs, Value.size_write]

/--
Packing succeeds only for values of the layout's scalars that fit the target,
and gives its bytes and slots as `pack` makes them.
-/
theorem pack_eq_ok {α : Type} {w : Width} {layout : Layout}
    {values : List (Value α)} {packed : Packed α}
    (h : pack w layout values = .ok packed) :
    layout.scalars.map (·.2) = values.map (·.scalar)
      ∧ values.all (·.fits w)
      ∧ packed.bytes = (layout.scalars.zip values).foldl
        (fun b ((offset, _), v) => v.write w b offset) (zeros layout.size)
      ∧ packed.slots = (layout.scalars.zip values).filterMap
        fun ((offset, _), v) => v.slot?.map (offset, ·) := by
  unfold pack at h
  split at h
  · split at h
    · cases h
      exact ⟨by assumption, by assumption, rfl, rfl⟩
    · cases h
  · cases h

/-- A packed struct is the layout's size. -/
theorem size_pack {α : Type} {w : Width} {layout : Layout}
    {values : List (Value α)} {packed : Packed α}
    (h : pack w layout values = .ok packed) :
    packed.bytes.size = layout.size := by
  rw [(pack_eq_ok h).2.2.1, size_foldl_write, size_zeros]

/--
In a struct packed by a well-formed layout, every scalar reads back as its
value: its number, or 0 for a pointer, for C to fill in.
-/
theorem readLE_pack {α : Type} {w : Width} {layout : Layout}
    {values : List (Value α)} {packed : Packed α}
    (hwf : layout.WellFormed w) (h : pack w layout values = .ok packed) :
    ∀ p ∈ layout.scalars.zip values,
      readLE packed.bytes p.1.1 (p.1.2.bytes w) = (p.2.bits? w).getD 0 := by
  obtain ⟨_, hfit, hord⟩ := hwf
  obtain ⟨hkinds, hall, hbytes, -⟩ := pack_eq_ok h
  intro p hp
  have hpairs : ∀ q ∈ layout.scalars.zip values,
      q.1.2 = q.2.scalar ∧ q.1.1 < 2 ^ 32 ∧ q.2.fits w := fun q hq =>
    ⟨eq_of_mem_zip hkinds q hq,
      by have := (hfit q.1 (List.of_mem_zip hq).1).2; omega,
      List.all_eq_true.1 hall q.2 (List.of_mem_zip hq).2⟩
  rw [hbytes, foldl_write_eq w _ _ hpairs]
  have hentry := readLE_writeAll_entries (zeros layout.size)
    ((layout.scalars.zip values).map (toEntry w))
    (List.pairwise_map.2 ((pairwise_zip hord).imp fun hab => Or.inl hab))
    (fun e he => by
      simp only [List.mem_map] at he
      obtain ⟨q, hq, rfl⟩ := he
      rw [size_zeros]
      exact (hfit q.1 (List.of_mem_zip hq).1).2)
    (toEntry w p) (List.mem_map_of_mem hp)
  simp only [toEntry] at hentry
  rw [hentry]
  cases hb : p.2.bits? w with
  | none => exact readLE_zeros ..
  | some n =>
    have := Value.bits_lt w p.2 n (hpairs p hp).2.2 hb
    rw [← (hpairs p hp).1] at this
    exact Nat.mod_eq_of_lt this

/--
Each slot of a struct packed by a well-formed layout is a pointer of the layout,
with its value: aligned, within the struct.
-/
theorem slot_mem_pack {α : Type} {w : Width} {layout : Layout}
    {values : List (Value α)} {packed : Packed α}
    (hwf : layout.WellFormed w) (h : pack w layout values = .ok packed) :
    ∀ s ∈ packed.slots,
      ((s.1, Scalar.ptr), Value.ptr s.2) ∈ layout.scalars.zip values
        ∧ w.bytes ∣ s.1 ∧ s.1 + w.bytes ≤ layout.size := by
  obtain ⟨hkinds, -, -, hslots⟩ := pack_eq_ok h
  intro s hs
  rw [hslots, List.mem_filterMap] at hs
  obtain ⟨⟨⟨o, k⟩, v⟩, hp, hv⟩ := hs
  cases v with
  | ptr target =>
    simp only [Value.slot?, Option.map_some, Option.some.injEq] at hv
    subst hv
    have hk : k = .ptr := eq_of_mem_zip hkinds _ hp
    subst hk
    exact ⟨hp, hwf.2.1 _ (List.of_mem_zip hp).1⟩
  | _ => simp [Value.slot?] at hv

/--
A slot's pointer is apart from every other scalar of the layout: C may write it
without touching any.
-/
theorem slot_apart {α : Type} {w : Width} {layout : Layout}
    {values : List (Value α)} {packed : Packed α}
    (hwf : layout.WellFormed w) (h : pack w layout values = .ok packed)
    {s : Nat × α} (hs : s ∈ packed.slots) {q : Nat × Scalar}
    (hq : q ∈ layout.scalars) (hne : q.1 ≠ s.1) :
    s.1 + w.bytes ≤ q.1 ∨ q.1 + q.2.bytes w ≤ s.1 := by
  have hp := (List.of_mem_zip (slot_mem_pack hwf h s hs).1).1
  rcases eq_or_of_pairwise hwf.2.2 hp hq with heq | hbefore | hafter
  · exact absurd (congrArg Prod.fst heq).symm hne
  · exact .inl hbefore
  · exact .inr hafter

/-- A packed struct's slots are in order, each ending before the next begins. -/
theorem slots_pairwise {α : Type} {w : Width} {layout : Layout}
    {values : List (Value α)} {packed : Packed α}
    (hwf : layout.WellFormed w) (h : pack w layout values = .ok packed) :
    packed.slots.Pairwise fun a b => a.1 + w.bytes ≤ b.1 := by
  obtain ⟨hkinds, -, -, hslots⟩ := pack_eq_ok h
  rw [hslots, List.pairwise_filterMap]
  refine (pairwise_zip hwf.2.2).imp_of_mem fun {a b} ha _ hab => ?_
  intro x hx y hy
  obtain ⟨⟨o, k⟩, v⟩ := a
  cases v with
  | ptr target =>
    simp only [Value.slot?, Option.map_some, Option.some.injEq] at hx hy
    subst hx
    have hk : k = .ptr := eq_of_mem_zip hkinds _ ha
    subst hk
    obtain ⟨⟨o', k'⟩, v'⟩ := b
    cases v' with
    | ptr _ =>
      simp only [Option.map_some, Option.some.injEq] at hy
      subst hy
      exact hab
    | _ => simp at hy
  | _ => simp [Value.slot?] at hx

end WebGPU.Raw.Pack

end
