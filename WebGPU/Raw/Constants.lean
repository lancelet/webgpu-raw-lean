/-
================================================================================
  GENERATED FILE: DO NOT EDIT BY HAND

  Generator:        webgpu-gen
  Generator commit: 0c89416 (dirty)
  Generated:        2026-11-02 23:17:23 UTC
  Source:           vendor/webgpu-headers/webgpu.yml
  Source repo:      https://github.com/webgpu-native/webgpu-headers
  Source commit:    673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
  Source date:      2026-05-07
  Source pinned by: wgpu-native v29.0.1.1
================================================================================
-/
module

/-!
# Constants

Every constant in the spec, such as `wholeSize`, the size that means
"to the end of the buffer".
-/

@[expose] public section

namespace WebGPU.Raw

/--
Indicates no array layer count is specified. For more info, see [SentinelValues]
and the places that use this sentinel value.

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
def arrayLayerCountUndefined : UInt32  := 0xFFFFFFFF

/--
Indicates no copy stride is specified. For more info, see [SentinelValues] and
the places that use this sentinel value.

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
def copyStrideUndefined      : UInt32  := 0xFFFFFFFF

/--
Indicates no depth clear value is specified. For more info, see [SentinelValues]
and the places that use this sentinel value.

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
def depthClearValueUndefined : Float32 := 0.0 / 0.0

/--
Indicates no depth slice is specified. For more info, see [SentinelValues] and
the places that use this sentinel value.

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
def depthSliceUndefined      : UInt32  := 0xFFFFFFFF

/--
For `uint32_t` limits, indicates no limit value is specified. For more info, see
[SentinelValues] and the places that use this sentinel value.

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
def limitU32Undefined        : UInt32  := 0xFFFFFFFF

/--
For `uint64_t` limits, indicates no limit value is specified. For more info, see
[SentinelValues] and the places that use this sentinel value.

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
def limitU64Undefined        : UInt64  := 0xFFFFFFFFFFFFFFFF

/--
Indicates no mip level count is specified. For more info, see [SentinelValues]
and the places that use this sentinel value.

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
def mipLevelCountUndefined   : UInt32  := 0xFFFFFFFF

/--
Indicates no query set index is specified. For more info, see [SentinelValues]
and the places that use this sentinel value.

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
def querySetIndexUndefined   : UInt32  := 0xFFFFFFFF

/--
Sentinel value used in `WGPUStringView` to indicate that the pointer is to a
null-terminated string, rather than an explicitly-sized string.

`SIZE_MAX`: the largest `UInt64`, which the bindings pass as the largest
`size_t` on every platform (32 bits on the web).
-/
def strlen                   : UInt64  := 0xFFFFFFFFFFFFFFFF

/--
Indicates a size extending to the end of the buffer. For more info, see
[SentinelValues] and the places that use this sentinel value.

`SIZE_MAX`: the largest `UInt64`, which the bindings pass as the largest
`size_t` on every platform (32 bits on the web).

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
def wholeMapSize             : UInt64  := 0xFFFFFFFFFFFFFFFF

/--
Indicates a size extending to the end of the buffer. For more info, see
[SentinelValues] and the places that use this sentinel value.

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
def wholeSize                : UInt64  := 0xFFFFFFFFFFFFFFFF

end WebGPU.Raw

end
