/-!
# C layouts

Where C puts each field of a struct in memory, so that Lean can pack a struct
of `webgpu.h` as C would lay it out. The rules are C's for the structs
`webgpu.h` has: each field at the next offset its alignment allows, a struct
aligned as its most aligned field, and its size rounded up to that alignment.
Every scalar is aligned to its size, as on every target the bindings support
(64-bit, and wasm32, where pointers and `size_t` are 4 bytes but 64-bit
integers and doubles are still aligned to 8). The C compiler checks the layouts
of every bound struct against `webgpu.h`, on each target (`Emit/C/Layouts`).

For any struct, its layout has the properties packing needs:

    theorem offsets_spec : each field's offset is a multiple of its
      alignment, the field ends within the struct, and before any later one
    theorem align_dvd : each field's alignment divides the struct's
    theorem flatten_spec : the same of its scalars, however deeply nested,
      at their offsets from an aligned base: what packing writes
    theorem flatten_struct : a struct's scalars are its fields', each at
      its field's offset

So checking each field's offset, and each struct's size and alignment, against
the C compiler checks where every scalar goes, however deeply nested.
-/

namespace WebGPUGen.CLayout

/-! ## Types -/

/-- How wide the target's pointers and `size_t` are. -/
inductive Width where
  /-- wasm32: 4 bytes. -/
  | bits32
  /-- Every native target the bindings support: 8 bytes. -/
  | bits64
  deriving Repr, DecidableEq

/-- The bytes in a pointer or `size_t`. -/
def Width.bytes : Width → Nat
  | .bits32 => 4
  | .bits64 => 8

/--
A C scalar, by its representation. A `webgpu.h` enum or `WGPUBool` is a `u32`,
flags a `u64`, a signed integer the unsigned one of its width, a `float` an
`f32`, and a function pointer a `ptr` (on wasm32, a 4-byte table index).
-/
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

/-- A scalar's size, and its alignment: the same. -/
def Scalar.bytes (w : Width) : Scalar → Nat
  | .u8          => 1
  | .u16         => 2
  | .u32 | .f32  => 4
  | .u64 | .f64  => 8
  | .ptr | .size => w.bytes

/-- A C type a struct field can have: a scalar, or a struct by value. -/
inductive CType where
  | scalar (s : Scalar)
  /-- A struct, by its fields' types, in order. -/
  | struct (fields : List CType)
  deriving Repr

/-! ## Layout -/

/-- `n` rounded up to a multiple of `a`. -/
def roundUp (n a : Nat) : Nat :=
  (n + (a - 1)) / a * a

mutual
  /-- A type's alignment. -/
  def CType.align (w : Width) : CType → Nat
    | .scalar s      => s.bytes w
    | .struct fields => alignOf w fields

  /-- The largest alignment of the fields, or 1 for none. -/
  def alignOf (w : Width) : List CType → Nat
    | []          => 1
    | t :: fields => max (t.align w) (alignOf w fields)

  /-- A type's size. -/
  def CType.size (w : Width) : CType → Nat
    | .scalar s      => s.bytes w
    | .struct fields => roundUp (endOf w fields 0) (alignOf w fields)

  /-- Where the fields end, laid out from the offset `start`. -/
  def endOf (w : Width) : List CType → Nat → Nat
    | [], start => start
    | t :: fields, start =>
      endOf w fields (roundUp start (t.align w) + t.size w)
end

/-- The fields' offsets, laid out from the offset `start`. -/
def offsetsFrom (w : Width) : List CType → Nat → List Nat
  | [], _ => []
  | t :: fields, start =>
    let offset := roundUp start (t.align w)
    offset :: offsetsFrom w fields (offset + t.size w)

/-- The fields' offsets in a struct. -/
def offsets (w : Width) (fields : List CType) : List Nat :=
  offsetsFrom w fields 0

/-! ## Rounding up -/

/-- Rounding up gives at least the number rounded. -/
theorem le_roundUp (n : Nat) {a : Nat} (ha : 0 < a) : n ≤ roundUp n a := by
  have := Nat.lt_div_mul_add (a := n + (a - 1)) ha
  unfold roundUp
  omega

/-- Rounding up gives a multiple. -/
theorem dvd_roundUp (n a : Nat) : a ∣ roundUp n a :=
  Nat.dvd_mul_left a _

/-! ## Alignments -/

/-- A power of two: every alignment is one. -/
def IsPow2 (n : Nat) : Prop := ∃ k, n = 2 ^ k

/-- Of two powers of two, the smaller divides the larger. -/
theorem IsPow2.dvd_of_le {a b : Nat} (ha : IsPow2 a) (hb : IsPow2 b)
    (h : a ≤ b) : a ∣ b := by
  obtain ⟨i, rfl⟩ := ha
  obtain ⟨j, rfl⟩ := hb
  exact Nat.pow_dvd_pow 2 ((Nat.pow_le_pow_iff_right (by omega)).1 h)

/-- The larger of two powers of two is one. -/
theorem IsPow2.max {a b : Nat} (ha : IsPow2 a) (hb : IsPow2 b) :
    IsPow2 (max a b) := by
  rcases Nat.le_total a b with h | h
  · rw [Nat.max_eq_right h]; exact hb
  · rw [Nat.max_eq_left h]; exact ha

/-- A power of two is positive. -/
theorem IsPow2.pos {a : Nat} (ha : IsPow2 a) : 0 < a := by
  obtain ⟨k, rfl⟩ := ha
  exact Nat.two_pow_pos k

/-- A scalar's size is a power of two. -/
theorem Scalar.bytes_pow2 (w : Width) (s : Scalar) : IsPow2 (s.bytes w) := by
  cases s <;> cases w <;> first
    | exact ⟨0, rfl⟩ | exact ⟨1, rfl⟩ | exact ⟨2, rfl⟩ | exact ⟨3, rfl⟩

mutual
  /-- A type's alignment is a power of two. -/
  theorem CType.align_pow2 (w : Width) : (t : CType) → IsPow2 (t.align w)
    | .scalar s      => Scalar.bytes_pow2 w s
    | .struct fields => alignOf_pow2 w fields

  /-- The fields' largest alignment is a power of two. -/
  theorem alignOf_pow2 (w : Width) : (fields : List CType) →
      IsPow2 (alignOf w fields)
    | []          => ⟨0, rfl⟩
    | t :: fields => (t.align_pow2 w).max (alignOf_pow2 w fields)
end

/-- A type's alignment is positive. -/
theorem CType.align_pos (w : Width) (t : CType) : 0 < t.align w :=
  (t.align_pow2 w).pos

/-- A field's alignment divides its struct's. -/
theorem align_dvd {w : Width} {fields : List CType} {t : CType}
    (h : t ∈ fields) : t.align w ∣ alignOf w fields := by
  apply (t.align_pow2 w).dvd_of_le (alignOf_pow2 w fields)
  induction fields with
  | nil => simp at h
  | cons u fields ih =>
    simp only [alignOf]
    rcases List.mem_cons.1 h with rfl | h
    · exact Nat.le_max_left _ _
    · exact Nat.le_trans (ih h) (Nat.le_max_right _ _)

/-! ## Field offsets -/

/-- One offset for each field. -/
theorem length_offsetsFrom (w : Width) :
    ∀ (fields : List CType) (start : Nat),
      (offsetsFrom w fields start).length = fields.length
  | [], _ => rfl
  | _ :: fields, _ => by
    simp [offsetsFrom, length_offsetsFrom w fields]

/-- The fields end no earlier than they start. -/
theorem le_endOf (w : Width) :
    ∀ (fields : List CType) (start : Nat), start ≤ endOf w fields start
  | [], _ => Nat.le_refl _
  | t :: fields, start => by
    have := le_roundUp start (t.align_pos w)
    have := le_endOf w fields (roundUp start (t.align w) + t.size w)
    simp only [endOf]
    omega

/-- Each field starts at or after `start`. -/
theorem start_le_offsetsFrom (w : Width) :
    ∀ (fields : List CType) (start i : Nat) (hi : i < fields.length),
      start ≤ (offsetsFrom w fields start)[i]'(by
        simpa [length_offsetsFrom] using hi)
  | [], _, _, hi => by simp at hi
  | t :: fields, start, i, hi => by
    have := le_roundUp start (t.align_pos w)
    cases i with
    | zero => simpa [offsetsFrom] using this
    | succ i =>
      simp only [offsetsFrom, List.getElem_cons_succ]
      have := start_le_offsetsFrom w fields
        (roundUp start (t.align w) + t.size w) i (by simpa using hi)
      omega

/-- Each field's offset is a multiple of its alignment. -/
theorem offsetsFrom_aligned (w : Width) :
    ∀ (fields : List CType) (start i : Nat) (hi : i < fields.length),
      fields[i].align w ∣ (offsetsFrom w fields start)[i]'(by
        simpa [length_offsetsFrom] using hi)
  | [], _, _, hi => by simp at hi
  | t :: fields, start, i, hi => by
    cases i with
    | zero => simpa [offsetsFrom] using dvd_roundUp start (t.align w)
    | succ i =>
      simp only [offsetsFrom, List.getElem_cons_succ]
      exact offsetsFrom_aligned w fields _ i (by simpa using hi)

/-- Each field ends where the fields end, or before. -/
theorem offsetsFrom_fit (w : Width) :
    ∀ (fields : List CType) (start i : Nat) (hi : i < fields.length),
      (offsetsFrom w fields start)[i]'(by simpa [length_offsetsFrom] using hi)
        + fields[i].size w ≤ endOf w fields start
  | [], _, _, hi => by simp at hi
  | t :: fields, start, i, hi => by
    cases i with
    | zero =>
      simpa [offsetsFrom, endOf] using le_endOf w fields _
    | succ i =>
      simp only [offsetsFrom, List.getElem_cons_succ, endOf]
      exact offsetsFrom_fit w fields _ i (by simpa using hi)

/-- Each field ends before any later field begins. -/
theorem offsetsFrom_disjoint (w : Width) :
    ∀ (fields : List CType) (start i j : Nat) (hij : i < j)
      (hj : j < fields.length),
      (offsetsFrom w fields start)[i]'(by
          simp [length_offsetsFrom]; omega)
        + (fields[i]'(by omega)).size w
        ≤ (offsetsFrom w fields start)[j]'(by
          simpa [length_offsetsFrom] using hj)
  | [], _, _, _, _, hj => by simp at hj
  | t :: fields, start, i, j, hij, hj => by
    cases j with
    | zero => omega
    | succ j =>
      cases i with
      | zero =>
        simp only [offsetsFrom, List.getElem_cons_zero,
          List.getElem_cons_succ]
        exact start_le_offsetsFrom w fields _ j (by simpa using hj)
      | succ i =>
        simp only [offsetsFrom, List.getElem_cons_succ]
        exact offsetsFrom_disjoint w fields _ i j (by omega)
          (by simpa using hj)

/-! ## Structs -/

/-- A struct's fields end within it. -/
theorem endOf_le_size (w : Width) (fields : List CType) :
    endOf w fields 0 ≤ (CType.struct fields).size w := by
  simp only [CType.size]
  exact le_roundUp _ (alignOf_pow2 w fields).pos

/-- A struct's size is a multiple of its alignment. -/
theorem align_dvd_size (w : Width) (t : CType) : t.align w ∣ t.size w := by
  cases t with
  | scalar s => exact Nat.dvd_refl _
  | struct fields => exact dvd_roundUp _ _

/-- Each field of a struct is aligned, within it, and before any later one. -/
theorem offsets_spec (w : Width) (fields : List CType) (i : Nat)
    (hi : i < fields.length) :
    fields[i].align w ∣ (offsets w fields)[i]'(by
        simpa [offsets, length_offsetsFrom] using hi)
      ∧ (offsets w fields)[i]'(by simpa [offsets, length_offsetsFrom] using hi)
          + fields[i].size w ≤ (CType.struct fields).size w
      ∧ ∀ j, i < j → ∀ (hj : j < fields.length),
        (offsets w fields)[i]'(by simpa [offsets, length_offsetsFrom] using hi)
          + fields[i].size w
          ≤ (offsets w fields)[j]'(by
            simpa [offsets, length_offsetsFrom] using hj) :=
  ⟨offsetsFrom_aligned w fields 0 i hi,
    Nat.le_trans (offsetsFrom_fit w fields 0 i hi) (endOf_le_size w fields),
    fun j hij hj => offsetsFrom_disjoint w fields 0 i j hij hj⟩

/-! ## Scalars, however nested -/

mutual
  /--
  A type's scalars, each at its offset from `base`, in order: what packing
  writes, however deeply structs nest.
  -/
  def CType.flatten (w : Width) : CType → Nat → List (Nat × Scalar)
    | .scalar s, base      => [(base, s)]
    | .struct fields, base => flattenFields w fields base 0

  /-- The scalars of fields laid out from `start`, at offsets from `base`. -/
  def flattenFields (w : Width) :
      List CType → Nat → Nat → List (Nat × Scalar)
    | [], _, _ => []
    | t :: fields, base, start =>
      let offset := roundUp start (t.align w)
      t.flatten w (base + offset)
        ++ flattenFields w fields base (offset + t.size w)
end

/-- One scalar ends before the other begins. -/
def Before (w : Width) (a b : Nat × Scalar) : Prop :=
  a.1 + a.2.bytes w ≤ b.1

mutual
  /-- A type's scalars lie within it. -/
  theorem CType.flatten_within (w : Width) :
      ∀ (t : CType) (base : Nat), ∀ p ∈ t.flatten w base,
        base ≤ p.1 ∧ p.1 + p.2.bytes w ≤ base + t.size w
    | .scalar s, base, p, hp => by
      simp only [CType.flatten, List.mem_singleton] at hp
      subst hp
      simp [CType.size]
    | .struct fields, base, p, hp => by
      have := flattenFields_within w fields base 0 p hp
      have := endOf_le_size w fields
      omega

  /-- Fields' scalars lie where the fields do. -/
  theorem flattenFields_within (w : Width) :
      ∀ (fields : List CType) (base start : Nat),
        ∀ p ∈ flattenFields w fields base start,
          base + start ≤ p.1 ∧ p.1 + p.2.bytes w ≤ base + endOf w fields start
    | [], _, _, p, hp => by simp [flattenFields] at hp
    | t :: fields, base, start, p, hp => by
      have hround := le_roundUp start (t.align_pos w)
      have hend := le_endOf w fields (roundUp start (t.align w) + t.size w)
      simp only [flattenFields, List.mem_append] at hp
      simp only [endOf]
      rcases hp with hp | hp
      · have := t.flatten_within w _ p hp
        omega
      · have := flattenFields_within w fields base _ p hp
        omega
end

mutual
  /-- An aligned type's scalars are aligned. -/
  theorem CType.flatten_aligned (w : Width) :
      ∀ (t : CType) (base : Nat), t.align w ∣ base →
        ∀ p ∈ t.flatten w base, p.2.bytes w ∣ p.1
    | .scalar s, base, h, p, hp => by
      simp only [CType.flatten, List.mem_singleton] at hp
      subst hp
      exact h
    | .struct fields, base, h, p, hp =>
      flattenFields_aligned w fields base 0
        (fun _ hu => Nat.dvd_trans (align_dvd hu) h) p hp

  /-- Fields' scalars are aligned, if each field's alignment divides `base`. -/
  theorem flattenFields_aligned (w : Width) :
      ∀ (fields : List CType) (base start : Nat),
        (∀ u ∈ fields, u.align w ∣ base) →
          ∀ p ∈ flattenFields w fields base start, p.2.bytes w ∣ p.1
    | [], _, _, _, p, hp => by simp [flattenFields] at hp
    | t :: fields, base, start, h, p, hp => by
      simp only [flattenFields, List.mem_append] at hp
      rcases hp with hp | hp
      · exact t.flatten_aligned w _
          (Nat.dvd_add (h t (List.mem_cons_self ..)) (dvd_roundUp _ _)) p hp
      · exact flattenFields_aligned w fields base _
          (fun u hu => h u (List.mem_cons_of_mem _ hu)) p hp
end

mutual
  /-- A type's scalars are in order, each ending before the next begins. -/
  theorem CType.flatten_disjoint (w : Width) :
      ∀ (t : CType) (base : Nat), (t.flatten w base).Pairwise (Before w)
    | .scalar _, _ => List.pairwise_singleton _ _
    | .struct fields, base => flattenFields_disjoint w fields base 0

  /-- Fields' scalars are in order, each ending before the next begins. -/
  theorem flattenFields_disjoint (w : Width) :
      ∀ (fields : List CType) (base start : Nat),
        (flattenFields w fields base start).Pairwise (Before w)
    | [], _, _ => List.Pairwise.nil
    | t :: fields, base, start => by
      simp only [flattenFields]
      refine List.pairwise_append.2 ⟨t.flatten_disjoint w _,
        flattenFields_disjoint w fields base _, ?_⟩
      intro a ha b hb
      have := t.flatten_within w _ a ha
      have := flattenFields_within w fields base _ b hb
      simp only [Before]
      omega
end

/--
An aligned struct's scalars are aligned, within it, and each ends before the
next begins: packing may write each at its offset.
-/
theorem flatten_spec (w : Width) (t : CType) (base : Nat)
    (h : t.align w ∣ base) :
    (∀ p ∈ t.flatten w base,
      p.2.bytes w ∣ p.1 ∧ base ≤ p.1 ∧ p.1 + p.2.bytes w ≤ base + t.size w)
      ∧ (t.flatten w base).Pairwise (Before w) :=
  ⟨fun p hp => ⟨t.flatten_aligned w base h p hp, t.flatten_within w base p hp⟩,
    t.flatten_disjoint w base⟩

/-- Fields' scalars are each field's own, at the field's offset. -/
theorem flattenFields_eq (w : Width) :
    ∀ (fields : List CType) (base start : Nat),
      flattenFields w fields base start
        = (fields.zip (offsetsFrom w fields start)).flatMap
          fun (t, offset) => t.flatten w (base + offset)
  | [], _, _ => rfl
  | t :: fields, base, start => by
    simp only [flattenFields, offsetsFrom, List.zip_cons_cons,
      List.flatMap_cons]
    rw [flattenFields_eq w fields base]

/--
A struct's scalars are each field's own, at the field's offset (`offsets`): so
checking each field's offset and size against C checks every scalar's.
-/
theorem flatten_struct (w : Width) (fields : List CType) (base : Nat) :
    (CType.struct fields).flatten w base
      = (fields.zip (offsets w fields)).flatMap
        fun (t, offset) => t.flatten w (base + offset) := by
  simp only [CType.flatten, offsets]
  exact flattenFields_eq w fields base 0

end WebGPUGen.CLayout
