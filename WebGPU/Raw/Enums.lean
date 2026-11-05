/-
================================================================================
  GENERATED FILE: DO NOT EDIT BY HAND

  Generator:        webgpu-gen
  Generator commit: f8e434c (clean)
  Generated:        2026-11-05 07:48:20 UTC
  Source:           vendor/webgpu-headers/webgpu.yml
  Source repo:      https://github.com/webgpu-native/webgpu-headers
  Source commit:    673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
  Source date:      2026-05-07
  Source pinned by: wgpu-native v29.0.1.1
================================================================================
-/
module

public import WebGPU.Raw.CEnum
import WebGPU.Raw.Internal.CEnum

/-!
# Enums and bitflags

Every enum and bitflag type in `webgpu.h`, with the codes and values it gives
them.

Each `c_enum` declares an enum and its `CEnum` instance: `CEnum.toC` gives a
value's code in `webgpu.h`, and `CEnum.ofC?` the value a code stands for. Each
bitflag type wraps its bits, with a constant per flag: combine flags with `|||`
and mask them with `&&&`.
-/

@[expose] public section

namespace WebGPU.Raw

c_enum AdapterType where
  | discreteGPU   = 0x00000001
  | integratedGPU = 0x00000002
  | cpu           = 0x00000003
  | unknown       = 0x00000004

c_enum AddressMode where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined    = 0x00000000
  | clampToEdge  = 0x00000001
  | «repeat»     = 0x00000002
  | mirrorRepeat = 0x00000003

c_enum BackendType where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  | null      = 0x00000001
  | webGPU    = 0x00000002
  | d3d11     = 0x00000003
  | d3d12     = 0x00000004
  | metal     = 0x00000005
  | vulkan    = 0x00000006
  | openGL    = 0x00000007
  | openGLES  = 0x00000008

c_enum BlendFactor where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined         = 0x00000000
  | zero              = 0x00000001
  | one               = 0x00000002
  | src               = 0x00000003
  | oneMinusSrc       = 0x00000004
  | srcAlpha          = 0x00000005
  | oneMinusSrcAlpha  = 0x00000006
  | dst               = 0x00000007
  | oneMinusDst       = 0x00000008
  | dstAlpha          = 0x00000009
  | oneMinusDstAlpha  = 0x0000000A
  | srcAlphaSaturated = 0x0000000B
  | constant          = 0x0000000C
  | oneMinusConstant  = 0x0000000D
  | src1              = 0x0000000E
  | oneMinusSrc1      = 0x0000000F
  | src1Alpha         = 0x00000010
  | oneMinusSrc1Alpha = 0x00000011

c_enum BlendOperation where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined       = 0x00000000
  | add             = 0x00000001
  | subtract        = 0x00000002
  | reverseSubtract = 0x00000003
  | min             = 0x00000004
  | max             = 0x00000005

c_enum BufferBindingType where
  /--
  Indicates that this `BufferBindingLayout` member of its parent
  `BindGroupLayoutEntry` is not used. (See also [SentinelValues].)

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | bindingNotUsed  = 0x00000000
  /--
  `1`. Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined       = 0x00000001
  | uniform         = 0x00000002
  | storage         = 0x00000003
  | readOnlyStorage = 0x00000004

c_enum BufferMapState where
  | unmapped = 0x00000001
  | pending  = 0x00000002
  | mapped   = 0x00000003

/--
The callback mode controls how a callback for an asynchronous operation may be
fired. See [Asynchronous-Operations] for how these are used.

[Asynchronous-Operations]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html
-/
c_enum CallbackMode where
  /--
  Callbacks created with `CallbackMode.waitAnyOnly`:
  - fire when the asynchronous operation's future is passed to a call to
    `Instance.waitAny` AND the operation has already completed or it completes
    inside the call to `Instance.waitAny`.
  -/
  | waitAnyOnly        = 0x00000001
  /--
  Callbacks created with `CallbackMode.allowProcessEvents`:
  - fire for the same reasons as callbacks created with
    `CallbackMode.waitAnyOnly`
  - fire inside a call to `Instance.processEvents` if the asynchronous operation
    is complete.
  -/
  | allowProcessEvents = 0x00000002
  /--
  Callbacks created with `CallbackMode.allowSpontaneous`:
  - fire for the same reasons as callbacks created with
    `CallbackMode.allowProcessEvents`
  - **may** fire spontaneously on an arbitrary or application thread, when the
    WebGPU implementations discovers that the asynchronous operation is
    complete.

  Implementations _should_ fire spontaneous callbacks as soon as possible.

  **Note:** Because spontaneous callbacks may fire at an arbitrary time on an
  arbitrary thread, applications should take extra care when acquiring locks or
  mutating state inside the callback. It undefined behavior to re-entrantly call
  into the webgpu.h API if the callback fires while inside the callstack of
  another webgpu.h function that is not `Instance.waitAny` or
  `Instance.processEvents`.
  -/
  | allowSpontaneous   = 0x00000003

c_enum CompareFunction where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined    = 0x00000000
  | never        = 0x00000001
  | less         = 0x00000002
  | equal        = 0x00000003
  | lessEqual    = 0x00000004
  | greater      = 0x00000005
  | notEqual     = 0x00000006
  | greaterEqual = 0x00000007
  | always       = 0x00000008

c_enum CompilationInfoRequestStatus where
  | success           = 0x00000001
  /--
  See [CallbackStatuses].

  [CallbackStatuses]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#CallbackStatuses
  -/
  | callbackCancelled = 0x00000002

c_enum CompilationMessageType where
  | error   = 0x00000001
  | warning = 0x00000002
  | info    = 0x00000003

c_enum ComponentSwizzle where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  /-- Force its value to 0. -/
  | zero      = 0x00000001
  /-- Force its value to 1. -/
  | one       = 0x00000002
  /-- Take its value from the red channel of the texture. -/
  | r         = 0x00000003
  /-- Take its value from the green channel of the texture. -/
  | g         = 0x00000004
  /-- Take its value from the blue channel of the texture. -/
  | b         = 0x00000005
  /-- Take its value from the alpha channel of the texture. -/
  | a         = 0x00000006

/--
Describes how frames are composited with other contents on the screen when
`Surface.present` is called.
-/
c_enum CompositeAlphaMode where
  /--
  Lets the WebGPU implementation choose the best mode (supported, and with the
  best performance) between `CompositeAlphaMode.«opaque»` or
  `CompositeAlphaMode.inherit`.
  -/
  | auto            = 0x00000000
  /--
  The alpha component of the image is ignored and teated as if it is always 1.0.
  -/
  | «opaque»        = 0x00000001
  /--
  The alpha component is respected and non-alpha components are assumed to be
  already multiplied with the alpha component. For example, (0.5, 0, 0, 0.5) is
  semi-transparent bright red.
  -/
  | premultiplied   = 0x00000002
  /--
  The alpha component is respected and non-alpha components are assumed to NOT
  be already multiplied with the alpha component. For example, (1.0, 0, 0, 0.5)
  is semi-transparent bright red.
  -/
  | unpremultiplied = 0x00000003
  /--
  The handling of the alpha component is unknown to WebGPU and should be handled
  by the application using system-specific APIs. This mode may be unavailable
  (for example on Wasm).
  -/
  | inherit         = 0x00000004

c_enum CreatePipelineAsyncStatus where
  | success           = 0x00000001
  /--
  See [CallbackStatuses].

  [CallbackStatuses]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#CallbackStatuses
  -/
  | callbackCancelled = 0x00000002
  | validationError   = 0x00000003
  | internalError     = 0x00000004

c_enum CullMode where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  | none      = 0x00000001
  | front     = 0x00000002
  | back      = 0x00000003

c_enum DeviceLostReason where
  | unknown           = 0x00000001
  | destroyed         = 0x00000002
  /--
  See [CallbackStatuses].

  [CallbackStatuses]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#CallbackStatuses
  -/
  | callbackCancelled = 0x00000003
  | failedCreation    = 0x00000004

c_enum ErrorFilter where
  | validation  = 0x00000001
  | outOfMemory = 0x00000002
  | internal    = 0x00000003

c_enum ErrorType where
  | noError     = 0x00000001
  | validation  = 0x00000002
  | outOfMemory = 0x00000003
  | internal    = 0x00000004
  | unknown     = 0x00000005

/-- See `RequestAdapterOptions.featureLevel`. -/
c_enum FeatureLevel where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined     = 0x00000000
  /--
  "Compatibility" profile which can be supported on OpenGL ES 3.1 and D3D11.
  -/
  | compatibility = 0x00000001
  /-- "Core" profile which can be supported on Vulkan/Metal/D3D12 (at least). -/
  | core          = 0x00000002

c_enum FeatureName where
  | coreFeaturesAndLimits          = 0x00000001
  | depthClipControl               = 0x00000002
  | depth32FloatStencil8           = 0x00000003
  | textureCompressionBC           = 0x00000004
  | textureCompressionBCSliced3D   = 0x00000005
  | textureCompressionETC2         = 0x00000006
  | textureCompressionASTC         = 0x00000007
  | textureCompressionASTCSliced3D = 0x00000008
  | timestampQuery                 = 0x00000009
  | indirectFirstInstance          = 0x0000000A
  | shaderF16                      = 0x0000000B
  | rg11b10UfloatRenderable        = 0x0000000C
  | bgra8UnormStorage              = 0x0000000D
  | float32Filterable              = 0x0000000E
  | float32Blendable               = 0x0000000F
  | clipDistances                  = 0x00000010
  | dualSourceBlending             = 0x00000011
  | subgroups                      = 0x00000012
  | textureFormatsTier1            = 0x00000013
  | textureFormatsTier2            = 0x00000014
  | primitiveIndex                 = 0x00000015
  | textureComponentSwizzle        = 0x00000016

c_enum FilterMode where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  | nearest   = 0x00000001
  | linear    = 0x00000002

c_enum FrontFace where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  | ccw       = 0x00000001
  | cw        = 0x00000002

c_enum IndexFormat where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  | uint16    = 0x00000001
  | uint32    = 0x00000002

c_enum InstanceFeatureName where
  /-- Enable use of `Instance.waitAny` with `timeoutNS > 0`. -/
  | timedWaitAny              = 0x00000001
  /--
  Enable passing SPIR-V shaders to `Device.createShaderModule`, via
  `ShaderSourceSPIRV`.
  -/
  | shaderSourceSPIRV         = 0x00000002
  /--
  Normally, a `Adapter` can only create a single device. If this is available
  and enabled, then adapters won't immediately expire when they create a device,
  so can be reused to make multiple devices. They may still expire for other
  reasons.
  -/
  | multipleDevicesPerAdapter = 0x00000003

c_enum LoadOp where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  | load      = 0x00000001
  | clear     = 0x00000002

c_enum MapAsyncStatus where
  | success           = 0x00000001
  /--
  See [CallbackStatuses].

  [CallbackStatuses]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#CallbackStatuses
  -/
  | callbackCancelled = 0x00000002
  | error             = 0x00000003
  | aborted           = 0x00000004

c_enum MipmapFilterMode where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  | nearest   = 0x00000001
  | linear    = 0x00000002

c_enum OptionalBool where
  | false     = 0x00000000
  | true      = 0x00000001
  | undefined = 0x00000002

c_enum PopErrorScopeStatus where
  /--
  The error scope stack was successfully popped and a result was reported.
  -/
  | success           = 0x00000001
  /--
  See [CallbackStatuses].

  [CallbackStatuses]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#CallbackStatuses
  -/
  | callbackCancelled = 0x00000002
  /-- The error scope stack could not be popped, because it was empty. -/
  | error             = 0x00000003

c_enum PowerPreference where
  /--
  No preference. (See also [SentinelValues].)

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined       = 0x00000000
  | lowPower        = 0x00000001
  | highPerformance = 0x00000002

c_enum PredefinedColorSpace where
  | srgb      = 0x00000001
  | displayP3 = 0x00000002

/--
Describes when and in which order frames are presented on the screen when
`Surface.present` is called.
-/
c_enum PresentMode where
  /-- Present mode is not specified. Use the default. -/
  | undefined   = 0x00000000
  /--
  The presentation of the image to the user waits for the next vertical blanking
  period to update in a first-in, first-out manner. Tearing cannot be observed
  and frame-loop will be limited to the display's refresh rate. This is the only
  mode that's always available.
  -/
  | fifo        = 0x00000001
  /--
  The presentation of the image to the user tries to wait for the next vertical
  blanking period but may decide to not wait if a frame is presented late.
  Tearing can sometimes be observed but late-frame don't produce a full-frame
  stutter in the presentation. This is still a first-in, first-out mechanism so
  a frame-loop will be limited to the display's refresh rate.
  -/
  | fifoRelaxed = 0x00000002
  /--
  The presentation of the image to the user is updated immediately without
  waiting for a vertical blank. Tearing can be observed but latency is
  minimized.
  -/
  | immediate   = 0x00000003
  /--
  The presentation of the image to the user waits for the next vertical blanking
  period to update to the latest provided image. Tearing cannot be observed and
  a frame-loop is not limited to the display's refresh rate.
  -/
  | mailbox     = 0x00000004

c_enum PrimitiveTopology where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined     = 0x00000000
  | pointList     = 0x00000001
  | lineList      = 0x00000002
  | lineStrip     = 0x00000003
  | triangleList  = 0x00000004
  | triangleStrip = 0x00000005

c_enum QueryType where
  | occlusion = 0x00000001
  | timestamp = 0x00000002

c_enum QueueWorkDoneStatus where
  | success           = 0x00000001
  /--
  See [CallbackStatuses].

  [CallbackStatuses]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#CallbackStatuses
  -/
  | callbackCancelled = 0x00000002
  /--
  There was some deterministic error. (Note this is currently never used, but it
  will be relevant when it's possible to create a queue object.)
  -/
  | error             = 0x00000003

c_enum RequestAdapterStatus where
  | success           = 0x00000001
  /--
  See [CallbackStatuses].

  [CallbackStatuses]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#CallbackStatuses
  -/
  | callbackCancelled = 0x00000002
  | unavailable       = 0x00000003
  | error             = 0x00000004

c_enum RequestDeviceStatus where
  | success           = 0x00000001
  /--
  See [CallbackStatuses].

  [CallbackStatuses]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#CallbackStatuses
  -/
  | callbackCancelled = 0x00000002
  | error             = 0x00000003

c_enum SType where
  | shaderSourceSPIRV                 = 0x00000001
  | shaderSourceWGSL                  = 0x00000002
  | renderPassMaxDrawCount            = 0x00000003
  | surfaceSourceMetalLayer           = 0x00000004
  | surfaceSourceWindowsHWND          = 0x00000005
  | surfaceSourceXlibWindow           = 0x00000006
  | surfaceSourceWaylandSurface       = 0x00000007
  | surfaceSourceAndroidNativeWindow  = 0x00000008
  | surfaceSourceXCBWindow            = 0x00000009
  | surfaceColorManagement            = 0x0000000A
  | requestAdapterWebXROptions        = 0x0000000B
  | textureComponentSwizzleDescriptor = 0x0000000C
  | externalTextureBindingLayout      = 0x0000000D
  | externalTextureBindingEntry       = 0x0000000E
  | compatibilityModeLimits           = 0x0000000F
  | textureBindingViewDimension       = 0x00000010

c_enum SamplerBindingType where
  /--
  Indicates that this `SamplerBindingLayout` member of its parent
  `BindGroupLayoutEntry` is not used. (See also [SentinelValues].)

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | bindingNotUsed = 0x00000000
  /--
  `1`. Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined      = 0x00000001
  | filtering      = 0x00000002
  | nonFiltering   = 0x00000003
  | comparison     = 0x00000004

/--
Status code returned (synchronously) from many operations. Generally indicates
an invalid input like an unknown enum value or [OutStructChainError]. Read the
function's documentation for specific error conditions.

[OutStructChainError]: https://webgpu-native.github.io/webgpu-headers/StructChaining.html#OutStructChainError
-/
c_enum Status where
  | success = 0x00000001
  | error   = 0x00000002

c_enum StencilOperation where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined      = 0x00000000
  | keep           = 0x00000001
  | zero           = 0x00000002
  | replace        = 0x00000003
  | invert         = 0x00000004
  | incrementClamp = 0x00000005
  | decrementClamp = 0x00000006
  | incrementWrap  = 0x00000007
  | decrementWrap  = 0x00000008

c_enum StorageTextureAccess where
  /--
  Indicates that this `StorageTextureBindingLayout` member of its parent
  `BindGroupLayoutEntry` is not used. (See also [SentinelValues].)

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | bindingNotUsed = 0x00000000
  /--
  `1`. Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined      = 0x00000001
  | writeOnly      = 0x00000002
  | readOnly       = 0x00000003
  | readWrite      = 0x00000004

c_enum StoreOp where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  | store     = 0x00000001
  | discard   = 0x00000002

/-- The status enum for `Surface.getCurrentTexture`. -/
c_enum SurfaceGetCurrentTextureStatus where
  /-- Yay! Everything is good and we can render this frame. -/
  | successOptimal    = 0x00000001
  /--
  Still OK - the surface can present the frame, but in a suboptimal way. The
  surface may need reconfiguration.
  -/
  | successSuboptimal = 0x00000002
  /-- Some operation timed out while trying to acquire the frame. -/
  | timeout           = 0x00000003
  /--
  The surface is too different to be used, compared to when it was originally
  created.
  -/
  | outdated          = 0x00000004
  /--
  The connection to whatever owns the surface was lost, or generally needs to be
  fully reinitialized.
  -/
  | lost              = 0x00000005
  /--
  There was some deterministic error (for example, the surface is not
  configured, or there was an [OutStructChainError]). Should produce
  [ImplementationDefinedLogging] containing details.

  [OutStructChainError]: https://webgpu-native.github.io/webgpu-headers/StructChaining.html#OutStructChainError
  [ImplementationDefinedLogging]: https://webgpu-native.github.io/webgpu-headers/Errors.html#ImplementationDefinedLogging
  -/
  | error             = 0x00000006

c_enum TextureAspect where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined   = 0x00000000
  | all         = 0x00000001
  | stencilOnly = 0x00000002
  | depthOnly   = 0x00000003

c_enum TextureDimension where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  | «1d»      = 0x00000001
  | «2d»      = 0x00000002
  | «3d»      = 0x00000003

c_enum TextureFormat where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined            = 0x00000000
  | r8Unorm              = 0x00000001
  | r8Snorm              = 0x00000002
  | r8Uint               = 0x00000003
  | r8Sint               = 0x00000004
  | r16Unorm             = 0x00000005
  | r16Snorm             = 0x00000006
  | r16Uint              = 0x00000007
  | r16Sint              = 0x00000008
  | r16Float             = 0x00000009
  | rg8Unorm             = 0x0000000A
  | rg8Snorm             = 0x0000000B
  | rg8Uint              = 0x0000000C
  | rg8Sint              = 0x0000000D
  | r32Float             = 0x0000000E
  | r32Uint              = 0x0000000F
  | r32Sint              = 0x00000010
  | rg16Unorm            = 0x00000011
  | rg16Snorm            = 0x00000012
  | rg16Uint             = 0x00000013
  | rg16Sint             = 0x00000014
  | rg16Float            = 0x00000015
  | rgba8Unorm           = 0x00000016
  | rgba8UnormSrgb       = 0x00000017
  | rgba8Snorm           = 0x00000018
  | rgba8Uint            = 0x00000019
  | rgba8Sint            = 0x0000001A
  | bgra8Unorm           = 0x0000001B
  | bgra8UnormSrgb       = 0x0000001C
  | rgb10A2Uint          = 0x0000001D
  | rgb10A2Unorm         = 0x0000001E
  | rg11B10Ufloat        = 0x0000001F
  | rgb9E5Ufloat         = 0x00000020
  | rg32Float            = 0x00000021
  | rg32Uint             = 0x00000022
  | rg32Sint             = 0x00000023
  | rgba16Unorm          = 0x00000024
  | rgba16Snorm          = 0x00000025
  | rgba16Uint           = 0x00000026
  | rgba16Sint           = 0x00000027
  | rgba16Float          = 0x00000028
  | rgba32Float          = 0x00000029
  | rgba32Uint           = 0x0000002A
  | rgba32Sint           = 0x0000002B
  | stencil8             = 0x0000002C
  | depth16Unorm         = 0x0000002D
  | depth24Plus          = 0x0000002E
  | depth24PlusStencil8  = 0x0000002F
  | depth32Float         = 0x00000030
  | depth32FloatStencil8 = 0x00000031
  | bc1RGBAUnorm         = 0x00000032
  | bc1RGBAUnormSrgb     = 0x00000033
  | bc2RGBAUnorm         = 0x00000034
  | bc2RGBAUnormSrgb     = 0x00000035
  | bc3RGBAUnorm         = 0x00000036
  | bc3RGBAUnormSrgb     = 0x00000037
  | bc4RUnorm            = 0x00000038
  | bc4RSnorm            = 0x00000039
  | bc5RGUnorm           = 0x0000003A
  | bc5RGSnorm           = 0x0000003B
  | bc6hRGBUfloat        = 0x0000003C
  | bc6hRGBFloat         = 0x0000003D
  | bc7RGBAUnorm         = 0x0000003E
  | bc7RGBAUnormSrgb     = 0x0000003F
  | etc2RGB8Unorm        = 0x00000040
  | etc2RGB8UnormSrgb    = 0x00000041
  | etc2RGB8A1Unorm      = 0x00000042
  | etc2RGB8A1UnormSrgb  = 0x00000043
  | etc2RGBA8Unorm       = 0x00000044
  | etc2RGBA8UnormSrgb   = 0x00000045
  | eacR11Unorm          = 0x00000046
  | eacR11Snorm          = 0x00000047
  | eacRG11Unorm         = 0x00000048
  | eacRG11Snorm         = 0x00000049
  | astc4x4Unorm         = 0x0000004A
  | astc4x4UnormSrgb     = 0x0000004B
  | astc5x4Unorm         = 0x0000004C
  | astc5x4UnormSrgb     = 0x0000004D
  | astc5x5Unorm         = 0x0000004E
  | astc5x5UnormSrgb     = 0x0000004F
  | astc6x5Unorm         = 0x00000050
  | astc6x5UnormSrgb     = 0x00000051
  | astc6x6Unorm         = 0x00000052
  | astc6x6UnormSrgb     = 0x00000053
  | astc8x5Unorm         = 0x00000054
  | astc8x5UnormSrgb     = 0x00000055
  | astc8x6Unorm         = 0x00000056
  | astc8x6UnormSrgb     = 0x00000057
  | astc8x8Unorm         = 0x00000058
  | astc8x8UnormSrgb     = 0x00000059
  | astc10x5Unorm        = 0x0000005A
  | astc10x5UnormSrgb    = 0x0000005B
  | astc10x6Unorm        = 0x0000005C
  | astc10x6UnormSrgb    = 0x0000005D
  | astc10x8Unorm        = 0x0000005E
  | astc10x8UnormSrgb    = 0x0000005F
  | astc10x10Unorm       = 0x00000060
  | astc10x10UnormSrgb   = 0x00000061
  | astc12x10Unorm       = 0x00000062
  | astc12x10UnormSrgb   = 0x00000063
  | astc12x12Unorm       = 0x00000064
  | astc12x12UnormSrgb   = 0x00000065

c_enum TextureSampleType where
  /--
  Indicates that this `TextureBindingLayout` member of its parent
  `BindGroupLayoutEntry` is not used. (See also [SentinelValues].)

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | bindingNotUsed    = 0x00000000
  /--
  `1`. Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined         = 0x00000001
  | float             = 0x00000002
  | unfilterableFloat = 0x00000003
  | depth             = 0x00000004
  | sint              = 0x00000005
  | uint              = 0x00000006

c_enum TextureViewDimension where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined = 0x00000000
  | «1d»      = 0x00000001
  | «2d»      = 0x00000002
  | «2dArray» = 0x00000003
  | cube      = 0x00000004
  | cubeArray = 0x00000005
  | «3d»      = 0x00000006

c_enum ToneMappingMode where
  | standard = 0x00000001
  | extended = 0x00000002

c_enum VertexFormat where
  | uint8           = 0x00000001
  | uint8x2         = 0x00000002
  | uint8x4         = 0x00000003
  | sint8           = 0x00000004
  | sint8x2         = 0x00000005
  | sint8x4         = 0x00000006
  | unorm8          = 0x00000007
  | unorm8x2        = 0x00000008
  | unorm8x4        = 0x00000009
  | snorm8          = 0x0000000A
  | snorm8x2        = 0x0000000B
  | snorm8x4        = 0x0000000C
  | uint16          = 0x0000000D
  | uint16x2        = 0x0000000E
  | uint16x4        = 0x0000000F
  | sint16          = 0x00000010
  | sint16x2        = 0x00000011
  | sint16x4        = 0x00000012
  | unorm16         = 0x00000013
  | unorm16x2       = 0x00000014
  | unorm16x4       = 0x00000015
  | snorm16         = 0x00000016
  | snorm16x2       = 0x00000017
  | snorm16x4       = 0x00000018
  | float16         = 0x00000019
  | float16x2       = 0x0000001A
  | float16x4       = 0x0000001B
  | float32         = 0x0000001C
  | float32x2       = 0x0000001D
  | float32x3       = 0x0000001E
  | float32x4       = 0x0000001F
  | uint32          = 0x00000020
  | uint32x2        = 0x00000021
  | uint32x3        = 0x00000022
  | uint32x4        = 0x00000023
  | sint32          = 0x00000024
  | sint32x2        = 0x00000025
  | sint32x3        = 0x00000026
  | sint32x4        = 0x00000027
  | unorm10_10_10_2 = 0x00000028
  | unorm8x4BGRA    = 0x00000029

c_enum VertexStepMode where
  /--
  Indicates no value is passed for this argument. See [SentinelValues].

  [SentinelValues]: https://webgpu-native.github.io/webgpu-headers/SentinelValues.html
  -/
  | undefined  = 0x00000000
  | vertex     = 0x00000001
  | «instance» = 0x00000002

/-- Status returned from a call to `Instance.waitAny`. -/
c_enum WaitStatus where
  /-- At least one WGPUFuture completed successfully. -/
  | success  = 0x00000001
  /--
  The wait operation succeeded, but no WGPUFutures completed within the timeout.
  -/
  | timedOut = 0x00000002
  /--
  The call was invalid for some reason (see [Wait-Any]). Should produce
  [ImplementationDefinedLogging] containing details.

  [Wait-Any]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#Wait-Any
  [ImplementationDefinedLogging]: https://webgpu-native.github.io/webgpu-headers/Errors.html#ImplementationDefinedLogging
  -/
  | error    = 0x00000003

c_enum WGSLLanguageFeatureName where
  | readonlyAndReadwriteStorageTextures = 0x00000001
  | packed4x8IntegerDotProduct          = 0x00000002
  | unrestrictedPointerParameters       = 0x00000003
  | pointerCompositeAccess              = 0x00000004
  | uniformBufferStandardLayout         = 0x00000005
  | subgroupId                          = 0x00000006
  | textureAndSamplerLet                = 0x00000007
  | subgroupUniformity                  = 0x00000008
  | textureFormatsTier1                 = 0x00000009
  | linearIndexing                      = 0x0000000A

structure BufferUsage where
  bits : UInt64
  deriving Repr, DecidableEq, Inhabited

namespace BufferUsage

def none         : BufferUsage := ⟨0x0000000000000000⟩
/--
The buffer can be *mapped* on the CPU side in *read* mode (using
`MapMode.read`).
-/
def mapRead      : BufferUsage := ⟨0x0000000000000001⟩
/--
The buffer can be *mapped* on the CPU side in *write* mode (using
`MapMode.write`).

**Note:** This usage is **not** required to set `mappedAtCreation` to `true` in
`BufferDescriptor`.
-/
def mapWrite     : BufferUsage := ⟨0x0000000000000002⟩
/-- The buffer can be used as the *source* of a GPU-side copy operation. -/
def copySrc      : BufferUsage := ⟨0x0000000000000004⟩
/-- The buffer can be used as the *destination* of a GPU-side copy operation. -/
def copyDst      : BufferUsage := ⟨0x0000000000000008⟩
/--
The buffer can be used as an Index buffer when doing indexed drawing in a render
pipeline.
-/
def index        : BufferUsage := ⟨0x0000000000000010⟩
/-- The buffer can be used as a Vertex buffer when using a render pipeline. -/
def vertex       : BufferUsage := ⟨0x0000000000000020⟩
/-- The buffer can be bound to a shader as a uniform buffer. -/
def uniform      : BufferUsage := ⟨0x0000000000000040⟩
/-- The buffer can be bound to a shader as a storage buffer. -/
def storage      : BufferUsage := ⟨0x0000000000000080⟩
/-- The buffer can store arguments for an indirect draw call. -/
def indirect     : BufferUsage := ⟨0x0000000000000100⟩
/-- The buffer can store the result of a timestamp or occlusion query. -/
def queryResolve : BufferUsage := ⟨0x0000000000000200⟩

instance : OrOp BufferUsage  := ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩
instance : AndOp BufferUsage := ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩

end BufferUsage

structure ColorWriteMask where
  bits : UInt64
  deriving Repr, DecidableEq, Inhabited

namespace ColorWriteMask

def none  : ColorWriteMask := ⟨0x0000000000000000⟩
def red   : ColorWriteMask := ⟨0x0000000000000001⟩
def green : ColorWriteMask := ⟨0x0000000000000002⟩
def blue  : ColorWriteMask := ⟨0x0000000000000004⟩
def alpha : ColorWriteMask := ⟨0x0000000000000008⟩
def all   : ColorWriteMask := ⟨0x000000000000000F⟩

instance : OrOp ColorWriteMask  := ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩
instance : AndOp ColorWriteMask := ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩

end ColorWriteMask

structure MapMode where
  bits : UInt64
  deriving Repr, DecidableEq, Inhabited

namespace MapMode

def none  : MapMode := ⟨0x0000000000000000⟩
def read  : MapMode := ⟨0x0000000000000001⟩
def write : MapMode := ⟨0x0000000000000002⟩

instance : OrOp MapMode  := ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩
instance : AndOp MapMode := ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩

end MapMode

structure ShaderStage where
  bits : UInt64
  deriving Repr, DecidableEq, Inhabited

namespace ShaderStage

def none     : ShaderStage := ⟨0x0000000000000000⟩
def vertex   : ShaderStage := ⟨0x0000000000000001⟩
def fragment : ShaderStage := ⟨0x0000000000000002⟩
def compute  : ShaderStage := ⟨0x0000000000000004⟩

instance : OrOp ShaderStage  := ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩
instance : AndOp ShaderStage := ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩

end ShaderStage

structure TextureUsage where
  bits : UInt64
  deriving Repr, DecidableEq, Inhabited

namespace TextureUsage

def none                : TextureUsage := ⟨0x0000000000000000⟩
def copySrc             : TextureUsage := ⟨0x0000000000000001⟩
def copyDst             : TextureUsage := ⟨0x0000000000000002⟩
def textureBinding      : TextureUsage := ⟨0x0000000000000004⟩
def storageBinding      : TextureUsage := ⟨0x0000000000000008⟩
def renderAttachment    : TextureUsage := ⟨0x0000000000000010⟩
def transientAttachment : TextureUsage := ⟨0x0000000000000020⟩

instance : OrOp TextureUsage  := ⟨fun a b => ⟨a.bits ||| b.bits⟩⟩
instance : AndOp TextureUsage := ⟨fun a b => ⟨a.bits &&& b.bits⟩⟩

end TextureUsage

end WebGPU.Raw

end
