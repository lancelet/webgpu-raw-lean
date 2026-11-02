module

/-!
# Enums with C codes

Every WebGPU enum value has a code in `webgpu.h`. `CEnum` gives both directions,
and the two laws that make them a bidirectional map: a value's code decodes to
the value, and a code decodes only to the value that has it.
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

end WebGPU.Raw

end
