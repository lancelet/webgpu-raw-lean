/-
================================================================================
  GENERATED FILE: DO NOT EDIT BY HAND

  Generator:        webgpu-gen
  Generator commit: 3e49594 (clean)
  Generated:        2026-11-05 12:23:21 UTC
  Source:           vendor/webgpu-headers/webgpu.yml
  Source repo:      https://github.com/webgpu-native/webgpu-headers
  Source commit:    673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
  Source date:      2026-05-07
  Source pinned by: wgpu-native v29.0.1.1
================================================================================
-/
module

public import WebGPU.Raw.Constants
public import WebGPU.Raw.Enums
public import WebGPU.Raw.Objects
public import WebGPU.Raw.Callbacks

/-!
# Structs

The structs of `webgpu.h` the bindings can pass so far, as Lean structures,
with the defaults C's initialisers give: so `{ size := 64 }` is a buffer
descriptor with every other field at its default. A field with no default
must be given. An extensible struct's `chain` holds its extensions, linked
in order as C's `nextInChain`.
-/

@[expose] public section

namespace WebGPU.Raw

structure BlendComponent where
  /--
  If set to `BlendOperation.undefined`, [defaults]([SentinelValues]) to
  `BlendOperation.add`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  operation : BlendOperation := .undefined
  /--
  If set to `BlendFactor.undefined`, [defaults]([SentinelValues]) to
  `BlendFactor.one`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  srcFactor : BlendFactor    := .undefined
  /--
  If set to `BlendFactor.undefined`, [defaults]([SentinelValues]) to
  `BlendFactor.zero`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  dstFactor : BlendFactor    := .undefined

structure BufferBindingLayout where
  /--
  If set to `BufferBindingType.undefined`, [defaults]([SentinelValues]) to
  `BufferBindingType.uniform`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  type             : BufferBindingType := .undefined
  hasDynamicOffset : Bool              := false
  minBindingSize   : UInt64            := 0

/-- `BufferBindingLayout` with every byte zero, as C's zero initialiser. -/
def BufferBindingLayout.zero : BufferBindingLayout where
  type             := .bindingNotUsed
  hasDynamicOffset := false
  minBindingSize   := 0

structure BufferDescriptor where
  label            : String      := ""
  usage            : BufferUsage := .none
  size             : UInt64      := 0
  /--
  When true, the buffer is mapped in write mode at creation. It should thus be
  unmapped once its initial data has been written.

  **Note:** Mapping at creation does **not** require the usage
  `BufferUsage.mapWrite`.
  -/
  mappedAtCreation : Bool        := false

/--
An RGBA color. Represents a `f32`, `i32`, or `u32` color using
[DoubleAsSupertype].

If any channel is non-finite, produces a [NonFiniteFloatValueError].

[DoubleAsSupertype]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#DoubleAsSupertype
[NonFiniteFloatValueError]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#NonFiniteFloatValueError
-/
structure Color where
  r : Float := 0.0
  g : Float := 0.0
  b : Float := 0.0
  a : Float := 0.0

structure CommandBufferDescriptor where
  label : String := ""

structure CommandEncoderDescriptor where
  label : String := ""

/--
Note: While Compatibility Mode is optional to implement, this extension struct
is required to be supported (for both queries and requests) and behave as
defined in the WebGPU spec.
-/
structure CompatibilityModeLimits where
  maxStorageBuffersInVertexStage    : UInt32 := limitU32Undefined
  maxStorageTexturesInVertexStage   : UInt32 := limitU32Undefined
  maxStorageBuffersInFragmentStage  : UInt32 := limitU32Undefined
  maxStorageTexturesInFragmentStage : UInt32 := limitU32Undefined

structure ConstantEntry where
  key   : String := ""
  /--
  Represents a WGSL numeric or boolean value using [DoubleAsSupertype].

  If non-finite, produces a [NonFiniteFloatValueError].

  [DoubleAsSupertype]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#DoubleAsSupertype
  [NonFiniteFloatValueError]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#NonFiniteFloatValueError
  -/
  value : Float  := 0.0

structure Extent3D where
  width              : UInt32 := 0
  height             : UInt32 := 1
  depthOrArrayLayers : UInt32 := 1

/--
Chained in an `BindGroupEntry` to set it to an `ExternalTexture`. This must have
a corresponding `ExternalTextureBindingLayout` in the `BindGroupLayout`.
-/
structure ExternalTextureBindingEntry where
  externalTexture : ExternalTexture

/--
Chained in `BindGroupLayoutEntry` to specify that the corresponding entries in
an `BindGroup` will contain an `ExternalTexture`.
-/
structure ExternalTextureBindingLayout where

/--
Opaque handle to an asynchronous operation. See [Asynchronous-Operations] for
more information.

[Asynchronous-Operations]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html
-/
structure Future where
  /-- Opaque id of the `Future` -/
  id : UInt64 := 0

structure InstanceLimits where
  /--
  The maximum number `FutureWaitInfo` supported in a call to `Instance.waitAny`
  with `timeoutNS > 0`.
  -/
  timedWaitAnyMaxCount : UInt64 := 0

structure MultisampleState where
  count                  : UInt32 := 1
  mask                   : UInt32 := 0xFFFFFFFF
  alphaToCoverageEnabled : Bool   := false

structure Origin3D where
  x : UInt32 := 0
  y : UInt32 := 0
  z : UInt32 := 0

structure PassTimestampWrites where
  /-- Query set to write timestamps to. -/
  querySet                  : QuerySet
  beginningOfPassWriteIndex : UInt32   := querySetIndexUndefined
  endOfPassWriteIndex       : UInt32   := querySetIndexUndefined

structure PipelineLayoutDescriptor where
  label            : String                := ""
  bindGroupLayouts : Array BindGroupLayout := #[]
  immediateSize    : UInt32                := 0

structure PrimitiveState where
  /--
  If set to `PrimitiveTopology.undefined`, [defaults]([SentinelValues]) to
  `PrimitiveTopology.triangleList`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  topology         : PrimitiveTopology := .undefined
  stripIndexFormat : IndexFormat       := .undefined
  /--
  If set to `FrontFace.undefined`, [defaults]([SentinelValues]) to
  `FrontFace.ccw`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  frontFace        : FrontFace         := .undefined
  /--
  If set to `CullMode.undefined`, [defaults]([SentinelValues]) to
  `CullMode.none`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  cullMode         : CullMode          := .undefined
  unclippedDepth   : Bool              := false

structure QuerySetDescriptor where
  label : String    := ""
  type  : QueryType
  count : UInt32    := 0

structure QueueDescriptor where
  label : String := ""

structure RenderBundleDescriptor where
  label : String := ""

structure RenderBundleEncoderDescriptor where
  label              : String              := ""
  colorFormats       : Array TextureFormat := #[]
  depthStencilFormat : TextureFormat       := .undefined
  sampleCount        : UInt32              := 1
  depthReadOnly      : Bool                := false
  stencilReadOnly    : Bool                := false

structure RenderPassDepthStencilAttachment where
  view              : TextureView
  depthLoadOp       : LoadOp         := .undefined
  depthStoreOp      : StoreOp        := .undefined
  /--
  This is a [NullableFloatingPointType].

  If `NaN`, indicates an `undefined` value (as defined by the JS spec). Use
  `WGPU_DEPTH_CLEAR_VALUE_UNDEFINED` to indicate this semantically.

  If infinite, produces a [NonFiniteFloatValueError].

  In Lean, `none` is C's NaN, as is `some` of a NaN.

  [NullableFloatingPointType]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#NullableFloatingPointType
  [NonFiniteFloatValueError]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#NonFiniteFloatValueError
  -/
  depthClearValue   : Option Float32 := none
  depthReadOnly     : Bool           := false
  stencilLoadOp     : LoadOp         := .undefined
  stencilStoreOp    : StoreOp        := .undefined
  stencilClearValue : UInt32         := 0
  stencilReadOnly   : Bool           := false

structure RenderPassMaxDrawCount where
  maxDrawCount : UInt64 := 50000000

/--
Extension providing requestAdapter options for implementations with WebXR
interop (i.e. Wasm).
-/
structure RequestAdapterWebXROptions where
  /-- Sets the `xrCompatible` option in the JS API. -/
  xrCompatible : Bool := false

structure SamplerBindingLayout where
  /--
  If set to `SamplerBindingType.undefined`, [defaults]([SentinelValues]) to
  `SamplerBindingType.filtering`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  type : SamplerBindingType := .undefined

/-- `SamplerBindingLayout` with every byte zero, as C's zero initialiser. -/
def SamplerBindingLayout.zero : SamplerBindingLayout where
  type := .bindingNotUsed

structure SamplerDescriptor where
  label         : String           := ""
  /--
  If set to `AddressMode.undefined`, [defaults]([SentinelValues]) to
  `AddressMode.clampToEdge`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  addressModeU  : AddressMode      := .undefined
  /--
  If set to `AddressMode.undefined`, [defaults]([SentinelValues]) to
  `AddressMode.clampToEdge`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  addressModeV  : AddressMode      := .undefined
  /--
  If set to `AddressMode.undefined`, [defaults]([SentinelValues]) to
  `AddressMode.clampToEdge`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  addressModeW  : AddressMode      := .undefined
  /--
  If set to `FilterMode.undefined`, [defaults]([SentinelValues]) to
  `FilterMode.nearest`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  magFilter     : FilterMode       := .undefined
  /--
  If set to `FilterMode.undefined`, [defaults]([SentinelValues]) to
  `FilterMode.nearest`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  minFilter     : FilterMode       := .undefined
  /--
  If set to `FilterMode.undefined`, [defaults]([SentinelValues]) to
  `MipmapFilterMode.nearest`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  mipmapFilter  : MipmapFilterMode := .undefined
  /--
  If non-finite, produces a [NonFiniteFloatValueError].

  [NonFiniteFloatValueError]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#NonFiniteFloatValueError
  -/
  lodMinClamp   : Float32          := 0.0
  /--
  If non-finite, produces a [NonFiniteFloatValueError].

  [NonFiniteFloatValueError]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#NonFiniteFloatValueError
  -/
  lodMaxClamp   : Float32          := 32.0
  compare       : CompareFunction  := .undefined
  maxAnisotropy : UInt16           := 1

structure ShaderSourceWGSL where
  code : String := ""

structure StencilFaceState where
  /--
  If set to `CompareFunction.undefined`, [defaults]([SentinelValues]) to
  `CompareFunction.always`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  compare     : CompareFunction  := .undefined
  /--
  If set to `StencilOperation.undefined`, [defaults]([SentinelValues]) to
  `StencilOperation.keep`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  failOp      : StencilOperation := .undefined
  /--
  If set to `StencilOperation.undefined`, [defaults]([SentinelValues]) to
  `StencilOperation.keep`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  depthFailOp : StencilOperation := .undefined
  /--
  If set to `StencilOperation.undefined`, [defaults]([SentinelValues]) to
  `StencilOperation.keep`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  passOp      : StencilOperation := .undefined

structure StorageTextureBindingLayout where
  /--
  If set to `StorageTextureAccess.undefined`, [defaults]([SentinelValues]) to
  `StorageTextureAccess.writeOnly`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  access        : StorageTextureAccess := .undefined
  format        : TextureFormat        := .undefined
  /--
  If set to `TextureViewDimension.undefined`, [defaults]([SentinelValues]) to
  `TextureViewDimension.«2d»`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  viewDimension : TextureViewDimension := .undefined

/--
`StorageTextureBindingLayout` with every byte zero, as C's zero initialiser.
-/
def StorageTextureBindingLayout.zero : StorageTextureBindingLayout where
  access        := .bindingNotUsed
  format        := .undefined
  viewDimension := .undefined

structure SupportedFeatures where
  features : Array FeatureName := #[]

structure SupportedInstanceFeatures where
  features : Array InstanceFeatureName := #[]

structure SupportedWGSLLanguageFeatures where
  features : Array WGSLLanguageFeatureName := #[]

/--
Filled by `Surface.getCapabilities` with what's supported for
`Surface.configure` for a pair of `Surface` and `Adapter`.
-/
structure SurfaceCapabilities where
  /--
  The bit set of supported `TextureUsage` bits. Guaranteed to contain
  `TextureUsage.renderAttachment`.
  -/
  usages       : TextureUsage             := .none
  /-- A list of supported `TextureFormat` values, in order of preference. -/
  formats      : Array TextureFormat      := #[]
  /--
  A list of supported `PresentMode` values. Guaranteed to contain
  `PresentMode.fifo`.
  -/
  presentModes : Array PresentMode        := #[]
  /--
  A list of supported `CompositeAlphaMode` values. `CompositeAlphaMode.auto`
  will be an alias for the first element and will never be present in this
  array.
  -/
  alphaModes   : Array CompositeAlphaMode := #[]

/-- Extension of `SurfaceConfiguration` for color spaces and HDR. -/
structure SurfaceColorManagement where
  colorSpace      : PredefinedColorSpace
  toneMappingMode : ToneMappingMode

/--
Options to `Surface.configure` for defining how a `Surface` will be rendered to
and presented to the user. See [Surface-Configuration] for more details.

[Surface-Configuration]: https://webgpu-native.github.io/webgpu-headers/Surfaces.html#Surface-Configuration
-/
structure SurfaceConfiguration where
  /-- The `Device` to use to render to surface's textures. -/
  device      : Device
  /-- The `TextureFormat` of the surface's textures. -/
  format      : TextureFormat       := .undefined
  /-- The `TextureUsage` of the surface's textures. -/
  usage       : TextureUsage        := .renderAttachment
  /-- The width of the surface's textures. -/
  width       : UInt32              := 0
  /-- The height of the surface's textures. -/
  height      : UInt32              := 0
  /--
  The additional `TextureFormat` for `TextureView` format reinterpretation of
  the surface's textures.
  -/
  viewFormats : Array TextureFormat := #[]
  /--
  How the surface's frames will be composited on the screen.

  If set to `CompositeAlphaMode.auto`, [defaults] to
  `CompositeAlphaMode.inherit` in native (allowing the mode to be configured
  externally), and to `CompositeAlphaMode.«opaque»` in Wasm.
  -/
  alphaMode   : CompositeAlphaMode  := .auto
  /--
  When and in which order the surface's frames will be shown on the screen.

  If set to `PresentMode.undefined`, [defaults]([SentinelValues]) to
  `PresentMode.fifo`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  presentMode : PresentMode         := .undefined

/--
The root descriptor for the creation of an `Surface` with
`Instance.createSurface`. It isn't sufficient by itself and must have one of the
`WGPUSurfaceSource*` in its chain. See [Surface-Creation] for more details.

[Surface-Creation]: https://webgpu-native.github.io/webgpu-headers/Surfaces.html#Surface-Creation
-/
structure SurfaceDescriptor where
  /-- Label used to refer to the object. -/
  label : String := ""

/--
Queried each frame from a `Surface` to get a `Texture` to render to along with
some metadata. See [Surface-Presenting] for more details.

[Surface-Presenting]: https://webgpu-native.github.io/webgpu-headers/Surfaces.html#Surface-Presenting
-/
structure SurfaceTexture where
  /--
  The `Texture` representing the frame that will be shown on the surface. It is
  [ReturnedWithOwnership] from `Surface.getCurrentTexture`.

  [ReturnedWithOwnership]: https://webgpu-native.github.io/webgpu-headers/Ownership.html#ReturnedWithOwnership
  -/
  texture : Texture
  /--
  Whether the call to `Surface.getCurrentTexture` succeeded and a hint as to why
  it might not have.
  -/
  status  : SurfaceGetCurrentTextureStatus

structure TexelCopyBufferLayout where
  offset       : UInt64 := 0
  bytesPerRow  : UInt32 := copyStrideUndefined
  rowsPerImage : UInt32 := copyStrideUndefined

structure TextureBindingLayout where
  /--
  If set to `TextureSampleType.undefined`, [defaults]([SentinelValues]) to
  `TextureSampleType.float`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  sampleType    : TextureSampleType    := .undefined
  /--
  If set to `TextureViewDimension.undefined`, [defaults]([SentinelValues]) to
  `TextureViewDimension.«2d»`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  viewDimension : TextureViewDimension := .undefined
  multisampled  : Bool                 := false

/-- `TextureBindingLayout` with every byte zero, as C's zero initialiser. -/
def TextureBindingLayout.zero : TextureBindingLayout where
  sampleType    := .bindingNotUsed
  viewDimension := .undefined
  multisampled  := false

/--
Note: While Compatibility Mode is optional to implement, this extension struct
is required to be accepted (but per the WebGPU spec, its contents are ignored on
devices that have the `FeatureName.coreFeaturesAndLimits` feature).
-/
structure TextureBindingViewDimension where
  textureBindingViewDimension : TextureViewDimension := .undefined

/--
When accessed by a shader, the red/green/blue/alpha channels are replaced by the
value corresponding to the component specified in r, g, b, and a, respectively
unlike the JS API which uses a string of length four, with each character
mapping to the texture view's red/green/blue/alpha channels.
-/
structure TextureComponentSwizzle where
  /--
  The value that replaces the red channel in the shader.

  If set to `ComponentSwizzle.undefined`, [defaults]([SentinelValues]) to
  `ComponentSwizzle.r`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  r : ComponentSwizzle := .undefined
  /--
  The value that replaces the green channel in the shader.

  If set to `ComponentSwizzle.undefined`, [defaults]([SentinelValues]) to
  `ComponentSwizzle.g`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  g : ComponentSwizzle := .undefined
  /--
  The value that replaces the blue channel in the shader.

  If set to `ComponentSwizzle.undefined`, [defaults]([SentinelValues]) to
  `ComponentSwizzle.b`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  b : ComponentSwizzle := .undefined
  /--
  The value that replaces the alpha channel in the shader.

  If set to `ComponentSwizzle.undefined`, [defaults]([SentinelValues]) to
  `ComponentSwizzle.a`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  a : ComponentSwizzle := .undefined

structure VertexAttribute where
  format         : VertexFormat
  offset         : UInt64       := 0
  shaderLocation : UInt32       := 0

/-- What can be chained to a `BindGroupEntry`: one of its extensions. -/
inductive BindGroupEntry.Chained where
  | externalTextureBindingEntry (s : ExternalTextureBindingEntry)

structure BindGroupEntry where
  /-- Binding index in the bind group. -/
  binding     : UInt32             := 0
  /-- Set this if the binding is a buffer object. Otherwise must be null. -/
  buffer      : Option Buffer      := none
  /--
  If the binding is a buffer, this is the byte offset of the binding range.
  Otherwise ignored.
  -/
  offset      : UInt64             := 0
  /--
  If the binding is a buffer, this is the byte size of the binding range
  (`WGPU_WHOLE_SIZE` means the binding ends at the end of the buffer). Otherwise
  ignored.
  -/
  size        : UInt64             := wholeSize
  /-- Set this if the binding is a sampler object. Otherwise must be null. -/
  sampler     : Option Sampler     := none
  /--
  Set this if the binding is a texture view object. Otherwise must be null.
  -/
  textureView : Option TextureView := none
  /-- Extensions chained to it (`nextInChain`), in order. -/
  chain : Array BindGroupEntry.Chained := #[]

/-- What can be chained to a `BindGroupLayoutEntry`: one of its extensions. -/
inductive BindGroupLayoutEntry.Chained where
  | externalTextureBindingLayout (s : ExternalTextureBindingLayout)

structure BindGroupLayoutEntry where
  binding          : UInt32                      := 0
  visibility       : ShaderStage                 := .none
  /-- If non-zero, this entry defines a binding array with this size. -/
  bindingArraySize : UInt32                      := 0
  buffer           : BufferBindingLayout         := .zero
  sampler          : SamplerBindingLayout        := .zero
  texture          : TextureBindingLayout        := .zero
  storageTexture   : StorageTextureBindingLayout := .zero
  /-- Extensions chained to it (`nextInChain`), in order. -/
  chain : Array BindGroupLayoutEntry.Chained := #[]

structure BlendState where
  color : BlendComponent := {}
  alpha : BlendComponent := {}

structure ComputePassDescriptor where
  label           : String                     := ""
  timestampWrites : Option PassTimestampWrites := none

structure ComputeState where
  module     : ShaderModule
  entryPoint : Option String       := none
  constants  : Array ConstantEntry := #[]

structure DepthStencilState where
  format              : TextureFormat    := .undefined
  depthWriteEnabled   : OptionalBool     := .undefined
  depthCompare        : CompareFunction  := .undefined
  stencilFront        : StencilFaceState := {}
  stencilBack         : StencilFaceState := {}
  stencilReadMask     : UInt32           := 0xFFFFFFFF
  stencilWriteMask    : UInt32           := 0xFFFFFFFF
  depthBias           : Int32            := 0
  /--
  If non-finite, produces a [NonFiniteFloatValueError].

  [NonFiniteFloatValueError]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#NonFiniteFloatValueError
  -/
  depthBiasSlopeScale : Float32          := 0.0
  /--
  If non-finite, produces a [NonFiniteFloatValueError].

  [NonFiniteFloatValueError]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#NonFiniteFloatValueError
  -/
  depthBiasClamp      : Float32          := 0.0

/-- Struct holding a future to wait on, and a `completed` boolean flag. -/
structure FutureWaitInfo where
  /-- The future to wait on. -/
  future    : Future := {}
  /-- Whether or not the future completed. -/
  completed : Bool   := false

structure InstanceDescriptor where
  requiredFeatures : Array InstanceFeatureName := #[]
  requiredLimits   : Option InstanceLimits     := none

/-- What can be chained to a `Limits`: one of its extensions. -/
inductive Limits.Chained where
  | compatibilityModeLimits (s : CompatibilityModeLimits)

structure Limits where
  maxTextureDimension1D                     : UInt32 := limitU32Undefined
  maxTextureDimension2D                     : UInt32 := limitU32Undefined
  maxTextureDimension3D                     : UInt32 := limitU32Undefined
  maxTextureArrayLayers                     : UInt32 := limitU32Undefined
  maxBindGroups                             : UInt32 := limitU32Undefined
  maxBindGroupsPlusVertexBuffers            : UInt32 := limitU32Undefined
  maxBindingsPerBindGroup                   : UInt32 := limitU32Undefined
  maxDynamicUniformBuffersPerPipelineLayout : UInt32 := limitU32Undefined
  maxDynamicStorageBuffersPerPipelineLayout : UInt32 := limitU32Undefined
  maxSampledTexturesPerShaderStage          : UInt32 := limitU32Undefined
  maxSamplersPerShaderStage                 : UInt32 := limitU32Undefined
  maxStorageBuffersPerShaderStage           : UInt32 := limitU32Undefined
  maxStorageTexturesPerShaderStage          : UInt32 := limitU32Undefined
  maxUniformBuffersPerShaderStage           : UInt32 := limitU32Undefined
  maxUniformBufferBindingSize               : UInt64 := limitU64Undefined
  maxStorageBufferBindingSize               : UInt64 := limitU64Undefined
  minUniformBufferOffsetAlignment           : UInt32 := limitU32Undefined
  minStorageBufferOffsetAlignment           : UInt32 := limitU32Undefined
  maxVertexBuffers                          : UInt32 := limitU32Undefined
  maxBufferSize                             : UInt64 := limitU64Undefined
  maxVertexAttributes                       : UInt32 := limitU32Undefined
  maxVertexBufferArrayStride                : UInt32 := limitU32Undefined
  maxInterStageShaderVariables              : UInt32 := limitU32Undefined
  maxColorAttachments                       : UInt32 := limitU32Undefined
  maxColorAttachmentBytesPerSample          : UInt32 := limitU32Undefined
  maxComputeWorkgroupStorageSize            : UInt32 := limitU32Undefined
  maxComputeInvocationsPerWorkgroup         : UInt32 := limitU32Undefined
  maxComputeWorkgroupSizeX                  : UInt32 := limitU32Undefined
  maxComputeWorkgroupSizeY                  : UInt32 := limitU32Undefined
  maxComputeWorkgroupSizeZ                  : UInt32 := limitU32Undefined
  maxComputeWorkgroupsPerDimension          : UInt32 := limitU32Undefined
  maxImmediateSize                          : UInt32 := limitU32Undefined
  /-- Extensions chained to it (`nextInChain`), in order. -/
  chain : Array Limits.Chained := #[]

structure RenderPassColorAttachment where
  /--
  If `NULL`, indicates a hole in the parent
  `RenderPassDescriptor.colorAttachments` array.
  -/
  view          : Option TextureView := none
  depthSlice    : UInt32             := depthSliceUndefined
  resolveTarget : Option TextureView := none
  loadOp        : LoadOp             := .undefined
  storeOp       : StoreOp            := .undefined
  clearValue    : Color              := {}

/-- What can be chained to a `RequestAdapterOptions`: one of its extensions. -/
inductive RequestAdapterOptions.Chained where
  | requestAdapterWebXROptions (s : RequestAdapterWebXROptions)

structure RequestAdapterOptions where
  /--
  "Feature level" for the adapter request. If an adapter is returned, it must
  support the features and limits in the requested feature level.

  If set to `FeatureLevel.undefined`, [defaults]([SentinelValues]) to
  `FeatureLevel.core`. Additionally, implementations may ignore
  `FeatureLevel.compatibility` and provide `FeatureLevel.core` instead.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  featureLevel         : FeatureLevel    := .undefined
  powerPreference      : PowerPreference := .undefined
  /--
  If true, requires the adapter to be a "fallback" adapter as defined by the JS
  spec. If this is not possible, the request returns null.
  -/
  forceFallbackAdapter : Bool            := false
  /--
  If set, requires the adapter to have a particular backend type. If this is not
  possible, the request returns null.
  -/
  backendType          : BackendType     := .undefined
  /--
  If set, requires the adapter to be able to output to a particular surface. If
  this is not possible, the request returns null.
  -/
  compatibleSurface    : Option Surface  := none
  /-- Extensions chained to it (`nextInChain`), in order. -/
  chain : Array RequestAdapterOptions.Chained := #[]

/-- What can be chained to a `ShaderModuleDescriptor`: one of its extensions. -/
inductive ShaderModuleDescriptor.Chained where
  | shaderSourceWGSL (s : ShaderSourceWGSL)

structure ShaderModuleDescriptor where
  label : String := ""
  /-- Extensions chained to it (`nextInChain`), in order. -/
  chain : Array ShaderModuleDescriptor.Chained := #[]

structure TexelCopyBufferInfo where
  layout : TexelCopyBufferLayout := {}
  buffer : Buffer

structure TexelCopyTextureInfo where
  texture  : Texture
  mipLevel : UInt32        := 0
  origin   : Origin3D      := {}
  /--
  If set to `TextureAspect.undefined`, [defaults]([SentinelValues]) to
  `TextureAspect.all`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  aspect   : TextureAspect := .undefined

structure TextureComponentSwizzleDescriptor where
  swizzle : TextureComponentSwizzle := {}

/-- What can be chained to a `TextureDescriptor`: one of its extensions. -/
inductive TextureDescriptor.Chained where
  | textureBindingViewDimension (s : TextureBindingViewDimension)

structure TextureDescriptor where
  label         : String              := ""
  usage         : TextureUsage        := .none
  /--
  If set to `TextureDimension.undefined`, [defaults]([SentinelValues]) to
  `TextureDimension.«2d»`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  dimension     : TextureDimension    := .undefined
  size          : Extent3D            := {}
  format        : TextureFormat       := .undefined
  mipLevelCount : UInt32              := 1
  sampleCount   : UInt32              := 1
  viewFormats   : Array TextureFormat := #[]
  /-- Extensions chained to it (`nextInChain`), in order. -/
  chain : Array TextureDescriptor.Chained := #[]

/--
If `attributes` is empty *and* `stepMode` is `VertexStepMode.undefined`,
indicates a "hole" in the parent `VertexState` `buffers` array, with behavior
equivalent to `null` in the JS API.

If `attributes` is empty but `stepMode` is *not* `VertexStepMode.undefined`,
indicates a vertex buffer with no attributes, with behavior equivalent to `{
attributes: [] }` in the JS API. (TODO: If the JS API changes not to distinguish
these cases, then this distinction doesn't matter and we can remove this
documentation.)

If `stepMode` is `VertexStepMode.undefined` but `attributes` is *not* empty,
`stepMode` [defaults]([SentinelValues]) to `VertexStepMode.vertex`.

[SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
-/
structure VertexBufferLayout where
  stepMode    : VertexStepMode        := .undefined
  arrayStride : UInt64                := 0
  attributes  : Array VertexAttribute := #[]

structure BindGroupDescriptor where
  label   : String               := ""
  layout  : BindGroupLayout
  entries : Array BindGroupEntry := #[]

structure BindGroupLayoutDescriptor where
  label   : String                     := ""
  entries : Array BindGroupLayoutEntry := #[]

structure ColorTargetState where
  /--
  The texture format of the target. If `TextureFormat.undefined`, indicates a
  "hole" in the parent `FragmentState` `targets` array: the pipeline does not
  output a value at this `location`.
  -/
  format    : TextureFormat     := .undefined
  blend     : Option BlendState := none
  writeMask : ColorWriteMask    := .all

structure ComputePipelineDescriptor where
  label   : String                := ""
  layout  : Option PipelineLayout := none
  compute : ComputeState

structure DeviceDescriptor where
  label                       : String                             := ""
  requiredFeatures            : Array FeatureName                  := #[]
  requiredLimits              : Option Limits                      := none
  defaultQueue                : QueueDescriptor                    := {}
  deviceLostCallbackInfo      : Option DeviceLostCallbackInfo      := none
  /--
  Called when there is an uncaptured error on this device, from any thread. See
  [ErrorScopes].

  **Important:** This callback does not have a configurable `CallbackMode`; it
  may be called at any time (like `CallbackMode.allowSpontaneous`). As such,
  calls into the `webgpu.h` API from this callback are unsafe. See
  [CallbackReentrancy].

  [ErrorScopes]: https://webgpu-native.github.io/webgpu-headers/Errors.html#ErrorScopes
  [CallbackReentrancy]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#CallbackReentrancy
  -/
  uncapturedErrorCallbackInfo : Option UncapturedErrorCallbackInfo := none

/-- What can be chained to a `RenderPassDescriptor`: one of its extensions. -/
inductive RenderPassDescriptor.Chained where
  | renderPassMaxDrawCount (s : RenderPassMaxDrawCount)

structure RenderPassDescriptor where
  label                  : String                                  := ""
  colorAttachments       : Array RenderPassColorAttachment         := #[]
  depthStencilAttachment : Option RenderPassDepthStencilAttachment := none
  occlusionQuerySet      : Option QuerySet                         := none
  timestampWrites        : Option PassTimestampWrites              := none
  /-- Extensions chained to it (`nextInChain`), in order. -/
  chain : Array RenderPassDescriptor.Chained := #[]

/-- What can be chained to a `TextureViewDescriptor`: one of its extensions. -/
inductive TextureViewDescriptor.Chained where
  | textureComponentSwizzleDescriptor (s : TextureComponentSwizzleDescriptor)

structure TextureViewDescriptor where
  label           : String               := ""
  format          : TextureFormat        := .undefined
  dimension       : TextureViewDimension := .undefined
  baseMipLevel    : UInt32               := 0
  mipLevelCount   : UInt32               := mipLevelCountUndefined
  baseArrayLayer  : UInt32               := 0
  arrayLayerCount : UInt32               := arrayLayerCountUndefined
  /--
  If set to `TextureAspect.undefined`, [defaults]([SentinelValues]) to
  `TextureAspect.all`.

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  aspect          : TextureAspect        := .undefined
  usage           : TextureUsage         := .none
  /-- Extensions chained to it (`nextInChain`), in order. -/
  chain : Array TextureViewDescriptor.Chained := #[]

structure VertexState where
  module     : ShaderModule
  entryPoint : Option String            := none
  constants  : Array ConstantEntry      := #[]
  buffers    : Array VertexBufferLayout := #[]

structure FragmentState where
  module     : ShaderModule
  entryPoint : Option String          := none
  constants  : Array ConstantEntry    := #[]
  targets    : Array ColorTargetState := #[]

structure RenderPipelineDescriptor where
  label        : String                   := ""
  layout       : Option PipelineLayout    := none
  vertex       : VertexState
  primitive    : PrimitiveState           := {}
  depthStencil : Option DepthStencilState := none
  multisample  : MultisampleState         := {}
  fragment     : Option FragmentState     := none

end WebGPU.Raw

end
