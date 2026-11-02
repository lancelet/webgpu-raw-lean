import WebGPU.Raw

/-!
# Tests for the constants

The generated constants have the values `webgpu.h` gives them; the generator's
tests check the same against the header's text.
-/

namespace WebGPURawTest.Constants
open WebGPU.Raw

#guard limitU32Undefined == 0xFFFFFFFF
#guard wholeSize == 0xFFFFFFFFFFFFFFFF

-- `SIZE_MAX` is the largest `UInt64`, whatever the platform's `size_t`.
#guard wholeMapSize == 0xFFFFFFFFFFFFFFFF

-- The depth clear value no value is: a NaN.
#guard depthClearValueUndefined.isNaN

end WebGPURawTest.Constants
