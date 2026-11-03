import WebGPU.Raw.Internal.Bytes

/-!
# Tests for the byte writers

The Lean definitions, at compile time; and the C fast paths against them, at
run time, natively (`WebGPURawTest/Main.lean`) and on the web (the web
self-test), as only compiled code calls C.
-/

namespace WebGPURawTest.Internal.Bytes
open WebGPU.Raw.Bytes

/-! ## The Lean definitions -/

-- A value is written least significant byte first, at its offset.
#guard
  let input := ByteArray.mk #[0, 0, 0, 0, 0, 0, 0, 0]
  (writeWhole input 2 4 0x01020304).data == #[0, 0, 4, 3, 2, 1, 0, 0]

-- A value that does not fit is not written, not even in part.
#guard
  let input := ByteArray.mk #[9, 9, 9, 9]
  (writeWhole input 2 4 0xFFFFFFFF).data == #[9, 9, 9, 9]

-- What was written reads back, and only its own bytes change.
#guard
  let input := ByteArray.mk #[1, 2, 3, 4, 5, 6]
  let written := writeWhole input 1 2 0xABCD
  readLE written 1 2 == 0xABCD
    && written.data == #[1, 0xCD, 0xAB, 4, 5, 6]

/-! ## The C fast paths against them -/

/-- The next number of a simple generator, for values to write. -/
def next (n : UInt64) : UInt64 :=
  n * 6364136223846793005 + 1442695040888963407

/--
Each way a writer's C fast path differs from its Lean definition, over arrays
of several sizes, every offset in and past them, and many values: edge cases
(0, all ones, NaNs) and pseudo-random ones from `seed`. A write must also
leave an array it shares as it was, copying it rather than writing in place.
-/
@[noinline]
def disagreements (seed : UInt64) : List String := Id.run do
  let mut found : List String := []
  let mut n := seed
  let edges : List UInt64 := [
    0,
    0xFFFFFFFFFFFFFFFF,
    -- NaNs' bits, as doubles and floats: the integer writers write them as
    -- they are, and `ofBits` makes each Lean's one NaN for the float writers.
    0x7FC0000000000001,
    0x7FF0000000000001,
    0x000000007FC00001,
    0x000000007F800001
  ]
  for size in [0, 3, 8, 17] do
    -- Every offset in the array and just past it, and offsets so large that
    -- adding a width to them overflows a `USize`.
    let huge := [USize.size - 1, USize.size - 4, USize.size / 2]
    for offset in List.range (size + 2) ++ huge do
      let mut values := edges
      for _ in [0:8] do
        n := next n
        values := n :: values
      for v in values do
        let bytes := ByteArray.mk ((List.range size).map (·.toUInt8)).toArray
        let at_ := offset.toUSize
        let cases : List (String × ByteArray × ByteArray) := [
          ("writeU16", writeU16 bytes at_ v.toUInt16,
            writeWhole bytes offset 2 v.toUInt16.toNat),
          ("writeU32", writeU32 bytes at_ v.toUInt32,
            writeWhole bytes offset 4 v.toUInt32.toNat),
          ("writeU64", writeU64 bytes at_ v,
            writeWhole bytes offset 8 v.toNat),
          ("writeF32", writeF32 bytes at_ (Float32.ofBits v.toUInt32),
            writeWhole bytes offset 4 (Float32.ofBits v.toUInt32).toBits.toNat),
          ("writeF64", writeF64 bytes at_ (Float.ofBits v),
            writeWhole bytes offset 8 (Float.ofBits v).toBits.toNat)
        ]
        -- NaNs that are not Lean's canonical one: Lean's `toBits` gives its
        -- canonical NaN for any NaN, so a writer must give the same bits.
        let nan64 := -(Float.ofBits 0x7FF8000000000000)
        let nan32 := -(Float32.ofBits 0x7FC00000)
        let nans : List (String × ByteArray × ByteArray) := [
          ("writeF32 of a negative NaN", writeF32 bytes at_ nan32,
            writeWhole bytes offset 4 nan32.toBits.toNat),
          ("writeF64 of a negative NaN", writeF64 bytes at_ nan64,
            writeWhole bytes offset 8 nan64.toBits.toNat)
        ]
        for (name, fast, lean) in cases ++ nans do
          unless fast.data == lean.data do
            found := s!"{name} at {offset} of {size} bytes, {v}: \
              {fast.data}, not {lean.data}" :: found
        -- Writes in place: each array here is new, and held by nothing else.
        let fresh := ByteArray.mk ((List.range size).map (·.toUInt8)).toArray
        let inPlace := writeU16 (writeU64 fresh at_ v) at_ v.toUInt16
        let expected := writeWhole (writeWhole bytes offset 8 v.toNat) offset 2
          v.toUInt16.toNat
        unless inPlace.data == expected.data do
          found := s!"writing in place at {offset} of {size} bytes, {v}: \
            {inPlace.data}, not {expected.data}" :: found
        -- `bytes` is still used here, so each write above found it shared.
        unless bytes.data == ((List.range size).map (·.toUInt8)).toArray do
          found := s!"a write changed a shared array of {size} bytes" :: found
  return found.reverse

end WebGPURawTest.Internal.Bytes
