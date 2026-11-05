/-
================================================================================
  GENERATED FILE: DO NOT EDIT BY HAND

  Generator:        webgpu-gen
  Generator commit: aa0c435 (clean)
  Generated:        2026-11-05 12:01:46 UTC
  Source:           vendor/webgpu-headers/webgpu.yml
  Source repo:      https://github.com/webgpu-native/webgpu-headers
  Source commit:    673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
  Source date:      2026-05-07
  Source pinned by: wgpu-native v29.0.1.1
================================================================================
-/
module

import WebGPU.Raw.Internal.CObject

/-!
# Objects

Every object type in `webgpu.h`. Each `c_object` declares an opaque type: Lean
code can hold a handle to the object and pass it on, but only the C side can
make one or look inside it.
-/

@[expose] public section

namespace WebGPU.Raw

c_object Adapter
c_object BindGroup
c_object BindGroupLayout
c_object Buffer
c_object CommandBuffer
c_object CommandEncoder
c_object ComputePassEncoder
c_object ComputePipeline

/--
Releasing the last ref to a `Device` also calls `Device.destroy`. For more info,
see [DeviceRelease].

[DeviceRelease]: https://webgpu-native.github.io/webgpu-headers/Ownership.html#DeviceRelease
-/
c_object Device

/--
A sampleable 2D texture that may perform 0-copy YUV sampling internally.
Creation of `ExternalTexture` is extremely implementation-dependent and not
defined in this header.
-/
c_object ExternalTexture

c_object Instance
c_object PipelineLayout
c_object QuerySet
c_object Queue
c_object RenderBundle
c_object RenderBundleEncoder
c_object RenderPassEncoder
c_object RenderPipeline
c_object Sampler
c_object ShaderModule

/--
An object used to continuously present image data to the user, see [Surfaces]
for more details.

[Surfaces]: https://webgpu-native.github.io/webgpu-headers/Surfaces.html
-/
c_object Surface

c_object Texture
c_object TextureView

namespace Internal

/-- Register the object types' classes, so the C side can box handles. -/
@[extern "lean_wgpu_objects_init"]
private opaque startObjects : IO Unit

builtin_initialize startObjects

end Internal

end WebGPU.Raw

end
