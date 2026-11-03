module

/-!
# Bytes, little-endian

A helper for the generated bindings, not part of the API: the bindings import
this module privately, so it never reaches their users.

Writing numbers into a `ByteArray` as C lays them out in memory, and reading
them back: what packing a struct of `webgpu.h` writes. Every target the
bindings support is little-endian, which the C side checks as it compiles.

Each typed writer (`writeU32`, `writeF64`, ...) is defined in Lean, one byte at
a time, which is what the proofs reason about. It runs as a few lines of C that
Lean pastes into the code it compiles (`@[extern c inline]`), so the C compiler
inlines it: a bounds check, and one store. The C uses only `lean.h`, and is
part of this file, so any change to it rebuilds what pasted it; the tests check
it agrees with the Lean definition. A write that does not fit in the array
leaves it as it is.

    theorem size_writeLE : writing keeps the array's size
    theorem readLE_writeLE : reading what was written gives it back
    theorem readByte_writeLE_outside : a write leaves every other byte as it is
-/

@[expose] public section

namespace WebGPU.Raw.Bytes

/-! ## One byte -/

/-- The byte at `i`, or 0 past the end. -/
def readByte (bytes : ByteArray) (i : Nat) : UInt8 :=
  if h : i < bytes.size then bytes[i] else 0

/-- `bytes` with `v` at `i`, or as it is if `i` is past the end. -/
def writeByte (bytes : ByteArray) (i : Nat) (v : UInt8) : ByteArray :=
  bytes.set! i v

/-- Writing a byte keeps the array's size. -/
theorem size_writeByte (bytes : ByteArray) (i : Nat) (v : UInt8) :
    (writeByte bytes i v).size = bytes.size :=
  ByteArray.size_set! ..

/-- Reading a byte after writing one: the byte written, or the one before. -/
theorem readByte_writeByte (bytes : ByteArray) (i j : Nat) (v : UInt8) :
    readByte (writeByte bytes i v) j
      = if i = j ∧ i < bytes.size then v else readByte bytes j := by
  unfold readByte writeByte
  by_cases hj : j < bytes.size
  · rw [dif_pos (by rw [ByteArray.size_set!]; exact hj), dif_pos hj]
    by_cases hij : i = j
    · subst hij
      rw [ByteArray.getElem_set!_self _ _ _ hj, if_pos ⟨rfl, hj⟩]
    · rw [ByteArray.getElem_set!_ne _ _ _ _ hij hj,
        if_neg (fun h => hij h.1)]
  · rw [dif_neg (by rw [ByteArray.size_set!]; exact hj), dif_neg hj,
      if_neg (fun (h : i = j ∧ i < bytes.size) => hj (h.1 ▸ h.2))]

/-! ## Numbers, little-endian -/

/--
`bytes` with the `width` low bytes of `n` at `offset`, least significant
first; any that would fall past the end are not written.
-/
def writeLE (bytes : ByteArray) (offset : Nat) : Nat → Nat → ByteArray
  | 0, _ => bytes
  | width + 1, n =>
    writeLE (writeByte bytes offset (n % 256).toUInt8) (offset + 1) width
      (n / 256)

/-- The number in the `width` bytes at `offset`, least significant first. -/
def readLE (bytes : ByteArray) (offset : Nat) : Nat → Nat
  | 0 => 0
  | width + 1 =>
    (readByte bytes offset).toNat + 256 * readLE bytes (offset + 1) width

/-- Writing a number keeps the array's size. -/
theorem size_writeLE (bytes : ByteArray) (offset width n : Nat) :
    (writeLE bytes offset width n).size = bytes.size := by
  induction width generalizing bytes offset n with
  | zero => rfl
  | succ width ih =>
    simp only [writeLE]
    rw [ih, size_writeByte]

/-- A write leaves every byte outside its range as it is. -/
theorem readByte_writeLE_outside (bytes : ByteArray) (offset width n j : Nat)
    (h : j < offset ∨ offset + width ≤ j) :
    readByte (writeLE bytes offset width n) j = readByte bytes j := by
  induction width generalizing bytes offset n with
  | zero => rfl
  | succ width ih =>
    simp only [writeLE]
    rw [ih _ _ _ (by omega), readByte_writeByte]
    have : offset ≠ j := by omega
    simp [this]

/-- Reading the bytes a write fits in gives back the number written. -/
theorem readLE_writeLE (bytes : ByteArray) (offset width n : Nat)
    (h : offset + width ≤ bytes.size) :
    readLE (writeLE bytes offset width n) offset width = n % 256 ^ width := by
  induction width generalizing bytes offset n with
  | zero => simp [readLE, Nat.mod_one]
  | succ width ih =>
    simp only [readLE, writeLE]
    rw [readByte_writeLE_outside _ _ _ _ _ (by omega), readByte_writeByte,
      if_pos ⟨rfl, by omega⟩,
      ih _ _ _ (by rw [size_writeByte]; omega)]
    rw [Nat.pow_succ, Nat.mul_comm (256 ^ width) 256, Nat.mod_mul]
    have : (n % 256).toUInt8.toNat = n % 256 := by
      simp [Nat.toUInt8]
    rw [this]

/-- Reading bytes no write touched gives what was there. -/
theorem readLE_writeLE_disjoint (bytes : ByteArray) (offset width n : Nat)
    (offset' width' : Nat)
    (h : offset + width ≤ offset' ∨ offset' + width' ≤ offset) :
    readLE (writeLE bytes offset width n) offset' width'
      = readLE bytes offset' width' := by
  induction width' generalizing offset' with
  | zero => rfl
  | succ width' ih =>
    simp only [readLE]
    rw [readByte_writeLE_outside _ _ _ _ _ (by omega), ih _ (by omega)]

/-!
## Typed writers

Each writes its value whole, or leaves the array as it is if the value does not
fit: as its C fast path does, with one bounds check and one store.

Lean pastes each one's C into the code it compiles, putting the arguments in
place of `#1`, `#2` and `#3`, and of any other `#`: so the C has no `#` of its
own, and every parameter is a run-time value, in order.
-/

/-- `bytes` with `n`'s `width` bytes at `offset`, if they fit. -/
def writeWhole (bytes : ByteArray) (offset width n : Nat) : ByteArray :=
  if offset + width ≤ bytes.size then writeLE bytes offset width n else bytes

/-- `bytes` with `v` at `offset`: 1 byte. -/
@[extern c inline "({ \
  _Static_assert(__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__, \
    \"the bindings assume a little-endian target\"); \
  lean_object * lean_wgpu_b = #1; size_t lean_wgpu_o = #2; \
  uint8_t lean_wgpu_v = #3; \
  size_t lean_wgpu_n = lean_sarray_size(lean_wgpu_b); \
  if (lean_wgpu_o <= lean_wgpu_n && 1 <= lean_wgpu_n - lean_wgpu_o) { \
    if (!lean_is_exclusive(lean_wgpu_b)) \
      lean_wgpu_b = lean_copy_byte_array(lean_wgpu_b); \
    __builtin_memcpy(lean_sarray_cptr(lean_wgpu_b) + lean_wgpu_o, \
      &lean_wgpu_v, 1); \
  } \
  lean_wgpu_b; })"]

def writeU8 (bytes : ByteArray) (offset : USize) (v : UInt8) : ByteArray :=
  writeWhole bytes offset.toNat 1 v.toNat

/-- `bytes` with `v` at `offset`: 2 bytes. -/
@[extern c inline "({ \
  _Static_assert(__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__, \
    \"the bindings assume a little-endian target\"); \
  lean_object * lean_wgpu_b = #1; size_t lean_wgpu_o = #2; \
  uint16_t lean_wgpu_v = #3; \
  size_t lean_wgpu_n = lean_sarray_size(lean_wgpu_b); \
  if (lean_wgpu_o <= lean_wgpu_n && 2 <= lean_wgpu_n - lean_wgpu_o) { \
    if (!lean_is_exclusive(lean_wgpu_b)) \
      lean_wgpu_b = lean_copy_byte_array(lean_wgpu_b); \
    __builtin_memcpy(lean_sarray_cptr(lean_wgpu_b) + lean_wgpu_o, \
      &lean_wgpu_v, 2); \
  } \
  lean_wgpu_b; })"]
def writeU16 (bytes : ByteArray) (offset : USize) (v : UInt16) : ByteArray :=
  writeWhole bytes offset.toNat 2 v.toNat

/-- `bytes` with `v` at `offset`: 4 bytes. -/
@[extern c inline "({ \
  _Static_assert(__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__, \
    \"the bindings assume a little-endian target\"); \
  lean_object * lean_wgpu_b = #1; size_t lean_wgpu_o = #2; \
  uint32_t lean_wgpu_v = #3; \
  size_t lean_wgpu_n = lean_sarray_size(lean_wgpu_b); \
  if (lean_wgpu_o <= lean_wgpu_n && 4 <= lean_wgpu_n - lean_wgpu_o) { \
    if (!lean_is_exclusive(lean_wgpu_b)) \
      lean_wgpu_b = lean_copy_byte_array(lean_wgpu_b); \
    __builtin_memcpy(lean_sarray_cptr(lean_wgpu_b) + lean_wgpu_o, \
      &lean_wgpu_v, 4); \
  } \
  lean_wgpu_b; })"]
def writeU32 (bytes : ByteArray) (offset : USize) (v : UInt32) : ByteArray :=
  writeWhole bytes offset.toNat 4 v.toNat

/-- `bytes` with `v` at `offset`: 8 bytes. -/
@[extern c inline "({ \
  _Static_assert(__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__, \
    \"the bindings assume a little-endian target\"); \
  lean_object * lean_wgpu_b = #1; size_t lean_wgpu_o = #2; \
  uint64_t lean_wgpu_v = #3; \
  size_t lean_wgpu_n = lean_sarray_size(lean_wgpu_b); \
  if (lean_wgpu_o <= lean_wgpu_n && 8 <= lean_wgpu_n - lean_wgpu_o) { \
    if (!lean_is_exclusive(lean_wgpu_b)) \
      lean_wgpu_b = lean_copy_byte_array(lean_wgpu_b); \
    __builtin_memcpy(lean_sarray_cptr(lean_wgpu_b) + lean_wgpu_o, \
      &lean_wgpu_v, 8); \
  } \
  lean_wgpu_b; })"]
def writeU64 (bytes : ByteArray) (offset : USize) (v : UInt64) : ByteArray :=
  writeWhole bytes offset.toNat 8 v.toNat

/--
`bytes` with `v` at `offset`, as a C `float`: 4 bytes, its bits as `toBits`
gives them, so any NaN is written as Lean's one NaN. It writes those bits as a
`u32`, rather than storing the float in C, which would keep a NaN's sign and
payload.
-/
@[inline]
def writeF32 (bytes : ByteArray) (offset : USize) (v : Float32) : ByteArray :=
  writeU32 bytes offset v.toBits

/--
`bytes` with `v` at `offset`, as a C `double`: 8 bytes, its bits as `toBits`
gives them, as `writeF32` does.
-/
@[inline]
def writeF64 (bytes : ByteArray) (offset : USize) (v : Float) : ByteArray :=
  writeU64 bytes offset v.toBits

/-- The 2 bytes at `offset`. -/
def readU16 (bytes : ByteArray) (offset : USize) : UInt16 :=
  (readLE bytes offset.toNat 2).toUInt16

/-- The 4 bytes at `offset`. -/
def readU32 (bytes : ByteArray) (offset : USize) : UInt32 :=
  (readLE bytes offset.toNat 4).toUInt32

/-- The 8 bytes at `offset`. -/
def readU64 (bytes : ByteArray) (offset : USize) : UInt64 :=
  (readLE bytes offset.toNat 8).toUInt64

/-- Writing a whole value keeps the array's size. -/
theorem size_writeWhole (bytes : ByteArray) (offset width n : Nat) :
    (writeWhole bytes offset width n).size = bytes.size := by
  unfold writeWhole
  split
  · exact size_writeLE ..
  · rfl

/-- A whole value written where it fits reads back. -/
theorem readLE_writeWhole (bytes : ByteArray) (offset width n : Nat)
    (h : offset + width ≤ bytes.size) :
    readLE (writeWhole bytes offset width n) offset width
      = n % 256 ^ width := by
  unfold writeWhole
  rw [if_pos h]
  exact readLE_writeLE _ _ _ _ h

/-- A whole value that does not fit is not written. -/
theorem writeWhole_of_not_fit (bytes : ByteArray) (offset width n : Nat)
    (h : ¬offset + width ≤ bytes.size) :
    writeWhole bytes offset width n = bytes := by
  unfold writeWhole
  rw [if_neg h]

/-- A whole value written leaves every byte outside its range as it is. -/
theorem readByte_writeWhole_outside (bytes : ByteArray) (offset width n j : Nat)
    (h : j < offset ∨ offset + width ≤ j) :
    readByte (writeWhole bytes offset width n) j = readByte bytes j := by
  unfold writeWhole
  split
  · exact readByte_writeLE_outside _ _ _ _ _ h
  · rfl

/-- Reading bytes a whole value's write did not touch gives what was there. -/
theorem readLE_writeWhole_disjoint (bytes : ByteArray) (offset width n : Nat)
    (offset' width' : Nat)
    (h : offset + width ≤ offset' ∨ offset' + width' ≤ offset) :
    readLE (writeWhole bytes offset width n) offset' width'
      = readLE bytes offset' width' := by
  unfold writeWhole
  split
  · exact readLE_writeLE_disjoint _ _ _ _ _ _ h
  · rfl

/-- Writing a `u8` keeps the array's size. -/
theorem size_writeU8 (bytes : ByteArray) (offset : USize) (v : UInt8) :
    (writeU8 bytes offset v).size = bytes.size :=
  size_writeWhole ..

/-- Writing a `u16` keeps the array's size. -/
theorem size_writeU16 (bytes : ByteArray) (offset : USize) (v : UInt16) :
    (writeU16 bytes offset v).size = bytes.size :=
  size_writeWhole ..

/-- Writing a `u32` keeps the array's size. -/
theorem size_writeU32 (bytes : ByteArray) (offset : USize) (v : UInt32) :
    (writeU32 bytes offset v).size = bytes.size :=
  size_writeWhole ..

/-- Writing a `u64` keeps the array's size. -/
theorem size_writeU64 (bytes : ByteArray) (offset : USize) (v : UInt64) :
    (writeU64 bytes offset v).size = bytes.size :=
  size_writeWhole ..

/-- Writing a `float` keeps the array's size. -/
theorem size_writeF32 (bytes : ByteArray) (offset : USize) (v : Float32) :
    (writeF32 bytes offset v).size = bytes.size :=
  size_writeWhole ..

/-- Writing a `double` keeps the array's size. -/
theorem size_writeF64 (bytes : ByteArray) (offset : USize) (v : Float) :
    (writeF64 bytes offset v).size = bytes.size :=
  size_writeWhole ..

/-- A `u16` written where it fits reads back. -/
theorem readU16_writeU16 (bytes : ByteArray) (offset : USize) (v : UInt16)
    (h : offset.toNat + 2 ≤ bytes.size) :
    readU16 (writeU16 bytes offset v) offset = v := by
  unfold readU16 writeU16
  rw [readLE_writeWhole _ _ _ _ h,
    Nat.mod_eq_of_lt (by have := v.toNat_lt; omega)]
  exact UInt16.ofNat_toNat

/-- A `u32` written where it fits reads back. -/
theorem readU32_writeU32 (bytes : ByteArray) (offset : USize) (v : UInt32)
    (h : offset.toNat + 4 ≤ bytes.size) :
    readU32 (writeU32 bytes offset v) offset = v := by
  unfold readU32 writeU32
  rw [readLE_writeWhole _ _ _ _ h,
    Nat.mod_eq_of_lt (by have := v.toNat_lt; omega)]
  exact UInt32.ofNat_toNat

/-- A `u64` written where it fits reads back. -/
theorem readU64_writeU64 (bytes : ByteArray) (offset : USize) (v : UInt64)
    (h : offset.toNat + 8 ≤ bytes.size) :
    readU64 (writeU64 bytes offset v) offset = v := by
  unfold readU64 writeU64
  rw [readLE_writeWhole _ _ _ _ h,
    Nat.mod_eq_of_lt (by have := v.toNat_lt; omega)]
  exact UInt64.ofNat_toNat

/-- A `float` written where it fits reads back as its bits. -/
theorem readU32_writeF32 (bytes : ByteArray) (offset : USize) (v : Float32)
    (h : offset.toNat + 4 ≤ bytes.size) :
    readU32 (writeF32 bytes offset v) offset = v.toBits := by
  unfold writeF32
  exact readU32_writeU32 _ _ _ h

/-- A `double` written where it fits reads back as its bits. -/
theorem readU64_writeF64 (bytes : ByteArray) (offset : USize) (v : Float)
    (h : offset.toNat + 8 ≤ bytes.size) :
    readU64 (writeF64 bytes offset v) offset = v.toBits := by
  unfold writeF64
  exact readU64_writeU64 _ _ _ h

end WebGPU.Raw.Bytes

end
