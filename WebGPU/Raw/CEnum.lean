module

/-!
# Enums with C codes

Every WebGPU enum value has a code in `webgpu.h`. `CEnum` gives both directions,
and the two laws that make them a bidirectional map: a value's code decodes to
the value, and a code decodes only to the value that has it.

Every enum in the bindings (`WebGPU.Raw.Enums`) has an instance, so
`CEnum.toC TextureFormat.rgba8Unorm` is that format's code, and
`CEnum.ofC? n : Option TextureFormat` is the format with code `n`, if any.
Where C returns a code, `CEnum.decode` keeps one no value has.
-/

public section

namespace WebGPU.Raw

/--
An enum with C codes: each value has a code, and a code decodes to the value it
came from.
-/
class CEnum (α : Type) where
  /-- The value's code in `webgpu.h`. -/
  toC     : α → UInt32
  /-- The value with this code, if any. -/
  ofC?    : UInt32 → Option α
  /-- Decoding a value's code gives the value back. -/
  ofC_toC : ∀ a, ofC? (toC a) = some a
  /-- A code decodes only to the value whose code it is. -/
  toC_ofC : ∀ n a, ofC? n = some a → toC a = n

/--
The value with the code `n`, or the code itself if no value has it. A code C
returns can be one the bindings do not know, from an implementation's own
extensions or a newer `webgpu.h`, so it is kept rather than lost.
-/
def CEnum.decode {α : Type} [CEnum α] (n : UInt32) : Except UInt32 α :=
  match CEnum.ofC? n with
  | some a => .ok a
  | none   => .error n

/-- Decoding a value's code gives the value. -/
theorem CEnum.decode_toC {α : Type} [CEnum α] (a : α) :
    CEnum.decode (CEnum.toC a) = .ok a := by
  simp [CEnum.decode, CEnum.ofC_toC]

/-- A code decodes only to the value whose code it is. -/
theorem CEnum.toC_of_decode {α : Type} [CEnum α] (n : UInt32) (a : α)
    (h : CEnum.decode n = .ok a) : CEnum.toC a = n := by
  unfold CEnum.decode at h
  split at h
  · cases h
    exact CEnum.toC_ofC _ _ ‹_›
  · cases h

end WebGPU.Raw

end
