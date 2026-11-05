/*
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
*/

#include <stddef.h>
#include <stdint.h>
#include <webgpu/webgpu.h>

#define BY_WIDTH(bits64, bits32) (sizeof(void *) == 8 ? (bits64) : (bits32))
#define FIELD(T, f, bits64, bits32) \
    _Static_assert(offsetof(T, f) == BY_WIDTH(bits64, bits32), \
        #T "." #f " is where the layout model puts it")
#define STRUCT(T, size64, size32, align64, align32) \
    _Static_assert(sizeof(T) == BY_WIDTH(size64, size32), \
        #T " has the size the layout model gives it"); \
    _Static_assert(_Alignof(T) == BY_WIDTH(align64, align32), \
        #T " has the alignment the layout model gives it")
#define SCALAR(T, bytes) \
    _Static_assert(sizeof(T) == (bytes) && _Alignof(T) == (bytes), \
        #T " has the size and alignment the layout model gives it")

// The target: pointers and size_t of 8 bytes or 4, and every scalar aligned to
// its size.
_Static_assert(sizeof(void *) == 8 || sizeof(void *) == 4, "pointer size");
_Static_assert(_Alignof(void *) == sizeof(void *),         "pointer alignment");
_Static_assert(sizeof(size_t) == sizeof(void *),           "size_t size");
_Static_assert(_Alignof(size_t) == sizeof(size_t),         "size_t alignment");
SCALAR(uint16_t,  2);
SCALAR(uint32_t,  4);
SCALAR(uint64_t,  8);
SCALAR(float,     4);
SCALAR(double,    8);
SCALAR(WGPUBool,  4);
SCALAR(WGPUFlags, 8);

// Each enum, of 4 bytes, and each flag type, of 8.
SCALAR(WGPUAdapterType,                    4);
SCALAR(WGPUAddressMode,                    4);
SCALAR(WGPUBackendType,                    4);
SCALAR(WGPUBlendFactor,                    4);
SCALAR(WGPUBlendOperation,                 4);
SCALAR(WGPUBufferBindingType,              4);
SCALAR(WGPUBufferMapState,                 4);
SCALAR(WGPUCallbackMode,                   4);
SCALAR(WGPUCompareFunction,                4);
SCALAR(WGPUCompilationInfoRequestStatus,   4);
SCALAR(WGPUCompilationMessageType,         4);
SCALAR(WGPUComponentSwizzle,               4);
SCALAR(WGPUCompositeAlphaMode,             4);
SCALAR(WGPUCreatePipelineAsyncStatus,      4);
SCALAR(WGPUCullMode,                       4);
SCALAR(WGPUDeviceLostReason,               4);
SCALAR(WGPUErrorFilter,                    4);
SCALAR(WGPUErrorType,                      4);
SCALAR(WGPUFeatureLevel,                   4);
SCALAR(WGPUFeatureName,                    4);
SCALAR(WGPUFilterMode,                     4);
SCALAR(WGPUFrontFace,                      4);
SCALAR(WGPUIndexFormat,                    4);
SCALAR(WGPUInstanceFeatureName,            4);
SCALAR(WGPULoadOp,                         4);
SCALAR(WGPUMapAsyncStatus,                 4);
SCALAR(WGPUMipmapFilterMode,               4);
SCALAR(WGPUOptionalBool,                   4);
SCALAR(WGPUPopErrorScopeStatus,            4);
SCALAR(WGPUPowerPreference,                4);
SCALAR(WGPUPredefinedColorSpace,           4);
SCALAR(WGPUPresentMode,                    4);
SCALAR(WGPUPrimitiveTopology,              4);
SCALAR(WGPUQueryType,                      4);
SCALAR(WGPUQueueWorkDoneStatus,            4);
SCALAR(WGPURequestAdapterStatus,           4);
SCALAR(WGPURequestDeviceStatus,            4);
SCALAR(WGPUSType,                          4);
SCALAR(WGPUSamplerBindingType,             4);
SCALAR(WGPUStatus,                         4);
SCALAR(WGPUStencilOperation,               4);
SCALAR(WGPUStorageTextureAccess,           4);
SCALAR(WGPUStoreOp,                        4);
SCALAR(WGPUSurfaceGetCurrentTextureStatus, 4);
SCALAR(WGPUTextureAspect,                  4);
SCALAR(WGPUTextureDimension,               4);
SCALAR(WGPUTextureFormat,                  4);
SCALAR(WGPUTextureSampleType,              4);
SCALAR(WGPUTextureViewDimension,           4);
SCALAR(WGPUToneMappingMode,                4);
SCALAR(WGPUVertexFormat,                   4);
SCALAR(WGPUVertexStepMode,                 4);
SCALAR(WGPUWaitStatus,                     4);
SCALAR(WGPUWGSLLanguageFeatureName,        4);
SCALAR(WGPUBufferUsage,                    8);
SCALAR(WGPUColorWriteMask,                 8);
SCALAR(WGPUMapMode,                        8);
SCALAR(WGPUShaderStage,                    8);
SCALAR(WGPUTextureUsage,                   8);

// WGPUStringView
FIELD(WGPUStringView, data,   0, 0);
FIELD(WGPUStringView, length, 8, 4);
STRUCT(WGPUStringView, 16, 8, 8, 4);

// WGPUChainedStruct
FIELD(WGPUChainedStruct, next,  0, 0);
FIELD(WGPUChainedStruct, sType, 8, 4);
STRUCT(WGPUChainedStruct, 16, 8, 8, 4);

// WGPUBlendComponent
FIELD(WGPUBlendComponent, operation, 0, 0);
FIELD(WGPUBlendComponent, srcFactor, 4, 4);
FIELD(WGPUBlendComponent, dstFactor, 8, 8);
STRUCT(WGPUBlendComponent, 12, 12, 4, 4);

// WGPUBufferBindingLayout
FIELD(WGPUBufferBindingLayout, nextInChain,      0,  0);
FIELD(WGPUBufferBindingLayout, type,             8,  4);
FIELD(WGPUBufferBindingLayout, hasDynamicOffset, 12, 8);
FIELD(WGPUBufferBindingLayout, minBindingSize,   16, 16);
STRUCT(WGPUBufferBindingLayout, 24, 24, 8, 8);

// WGPUBufferDescriptor
FIELD(WGPUBufferDescriptor, nextInChain,      0,  0);
FIELD(WGPUBufferDescriptor, label,            8,  4);
FIELD(WGPUBufferDescriptor, usage,            24, 16);
FIELD(WGPUBufferDescriptor, size,             32, 24);
FIELD(WGPUBufferDescriptor, mappedAtCreation, 40, 32);
STRUCT(WGPUBufferDescriptor, 48, 40, 8, 8);

// WGPUColor
FIELD(WGPUColor, r, 0,  0);
FIELD(WGPUColor, g, 8,  8);
FIELD(WGPUColor, b, 16, 16);
FIELD(WGPUColor, a, 24, 24);
STRUCT(WGPUColor, 32, 32, 8, 8);

// WGPUCommandBufferDescriptor
FIELD(WGPUCommandBufferDescriptor, nextInChain, 0, 0);
FIELD(WGPUCommandBufferDescriptor, label,       8, 4);
STRUCT(WGPUCommandBufferDescriptor, 24, 12, 8, 4);

// WGPUCommandEncoderDescriptor
FIELD(WGPUCommandEncoderDescriptor, nextInChain, 0, 0);
FIELD(WGPUCommandEncoderDescriptor, label,       8, 4);
STRUCT(WGPUCommandEncoderDescriptor, 24, 12, 8, 4);

// WGPUCompatibilityModeLimits
FIELD(WGPUCompatibilityModeLimits, chain,                             0,  0);
FIELD(WGPUCompatibilityModeLimits, maxStorageBuffersInVertexStage,    16, 8);
FIELD(WGPUCompatibilityModeLimits, maxStorageTexturesInVertexStage,   20, 12);
FIELD(WGPUCompatibilityModeLimits, maxStorageBuffersInFragmentStage,  24, 16);
FIELD(WGPUCompatibilityModeLimits, maxStorageTexturesInFragmentStage, 28, 20);
STRUCT(WGPUCompatibilityModeLimits, 32, 24, 8, 4);

// WGPUConstantEntry
FIELD(WGPUConstantEntry, nextInChain, 0,  0);
FIELD(WGPUConstantEntry, key,         8,  4);
FIELD(WGPUConstantEntry, value,       24, 16);
STRUCT(WGPUConstantEntry, 32, 24, 8, 8);

// WGPUExtent3D
FIELD(WGPUExtent3D, width,              0, 0);
FIELD(WGPUExtent3D, height,             4, 4);
FIELD(WGPUExtent3D, depthOrArrayLayers, 8, 8);
STRUCT(WGPUExtent3D, 12, 12, 4, 4);

// WGPUExternalTextureBindingEntry
FIELD(WGPUExternalTextureBindingEntry, chain,           0,  0);
FIELD(WGPUExternalTextureBindingEntry, externalTexture, 16, 8);
STRUCT(WGPUExternalTextureBindingEntry, 24, 12, 8, 4);

// WGPUExternalTextureBindingLayout
FIELD(WGPUExternalTextureBindingLayout, chain, 0, 0);
STRUCT(WGPUExternalTextureBindingLayout, 16, 8, 8, 4);

// WGPUFuture
FIELD(WGPUFuture, id, 0, 0);
STRUCT(WGPUFuture, 8, 8, 8, 8);

// WGPUInstanceLimits
FIELD(WGPUInstanceLimits, nextInChain,          0, 0);
FIELD(WGPUInstanceLimits, timedWaitAnyMaxCount, 8, 4);
STRUCT(WGPUInstanceLimits, 16, 8, 8, 4);

// WGPUMultisampleState
FIELD(WGPUMultisampleState, nextInChain,            0,  0);
FIELD(WGPUMultisampleState, count,                  8,  4);
FIELD(WGPUMultisampleState, mask,                   12, 8);
FIELD(WGPUMultisampleState, alphaToCoverageEnabled, 16, 12);
STRUCT(WGPUMultisampleState, 24, 16, 8, 4);

// WGPUOrigin3D
FIELD(WGPUOrigin3D, x, 0, 0);
FIELD(WGPUOrigin3D, y, 4, 4);
FIELD(WGPUOrigin3D, z, 8, 8);
STRUCT(WGPUOrigin3D, 12, 12, 4, 4);

// WGPUPassTimestampWrites
FIELD(WGPUPassTimestampWrites, nextInChain,               0,  0);
FIELD(WGPUPassTimestampWrites, querySet,                  8,  4);
FIELD(WGPUPassTimestampWrites, beginningOfPassWriteIndex, 16, 8);
FIELD(WGPUPassTimestampWrites, endOfPassWriteIndex,       20, 12);
STRUCT(WGPUPassTimestampWrites, 24, 16, 8, 4);

// WGPUPipelineLayoutDescriptor
FIELD(WGPUPipelineLayoutDescriptor, nextInChain,          0,  0);
FIELD(WGPUPipelineLayoutDescriptor, label,                8,  4);
FIELD(WGPUPipelineLayoutDescriptor, bindGroupLayoutCount, 24, 12);
FIELD(WGPUPipelineLayoutDescriptor, bindGroupLayouts,     32, 16);
FIELD(WGPUPipelineLayoutDescriptor, immediateSize,        40, 20);
STRUCT(WGPUPipelineLayoutDescriptor, 48, 24, 8, 4);

// WGPUPrimitiveState
FIELD(WGPUPrimitiveState, nextInChain,      0,  0);
FIELD(WGPUPrimitiveState, topology,         8,  4);
FIELD(WGPUPrimitiveState, stripIndexFormat, 12, 8);
FIELD(WGPUPrimitiveState, frontFace,        16, 12);
FIELD(WGPUPrimitiveState, cullMode,         20, 16);
FIELD(WGPUPrimitiveState, unclippedDepth,   24, 20);
STRUCT(WGPUPrimitiveState, 32, 24, 8, 4);

// WGPUQuerySetDescriptor
FIELD(WGPUQuerySetDescriptor, nextInChain, 0,  0);
FIELD(WGPUQuerySetDescriptor, label,       8,  4);
FIELD(WGPUQuerySetDescriptor, type,        24, 12);
FIELD(WGPUQuerySetDescriptor, count,       28, 16);
STRUCT(WGPUQuerySetDescriptor, 32, 20, 8, 4);

// WGPUQueueDescriptor
FIELD(WGPUQueueDescriptor, nextInChain, 0, 0);
FIELD(WGPUQueueDescriptor, label,       8, 4);
STRUCT(WGPUQueueDescriptor, 24, 12, 8, 4);

// WGPURenderBundleDescriptor
FIELD(WGPURenderBundleDescriptor, nextInChain, 0, 0);
FIELD(WGPURenderBundleDescriptor, label,       8, 4);
STRUCT(WGPURenderBundleDescriptor, 24, 12, 8, 4);

// WGPURenderBundleEncoderDescriptor
FIELD(WGPURenderBundleEncoderDescriptor, nextInChain,        0,  0);
FIELD(WGPURenderBundleEncoderDescriptor, label,              8,  4);
FIELD(WGPURenderBundleEncoderDescriptor, colorFormatCount,   24, 12);
FIELD(WGPURenderBundleEncoderDescriptor, colorFormats,       32, 16);
FIELD(WGPURenderBundleEncoderDescriptor, depthStencilFormat, 40, 20);
FIELD(WGPURenderBundleEncoderDescriptor, sampleCount,        44, 24);
FIELD(WGPURenderBundleEncoderDescriptor, depthReadOnly,      48, 28);
FIELD(WGPURenderBundleEncoderDescriptor, stencilReadOnly,    52, 32);
STRUCT(WGPURenderBundleEncoderDescriptor, 56, 36, 8, 4);

// WGPURenderPassDepthStencilAttachment
FIELD(WGPURenderPassDepthStencilAttachment, nextInChain,       0,  0);
FIELD(WGPURenderPassDepthStencilAttachment, view,              8,  4);
FIELD(WGPURenderPassDepthStencilAttachment, depthLoadOp,       16, 8);
FIELD(WGPURenderPassDepthStencilAttachment, depthStoreOp,      20, 12);
FIELD(WGPURenderPassDepthStencilAttachment, depthClearValue,   24, 16);
FIELD(WGPURenderPassDepthStencilAttachment, depthReadOnly,     28, 20);
FIELD(WGPURenderPassDepthStencilAttachment, stencilLoadOp,     32, 24);
FIELD(WGPURenderPassDepthStencilAttachment, stencilStoreOp,    36, 28);
FIELD(WGPURenderPassDepthStencilAttachment, stencilClearValue, 40, 32);
FIELD(WGPURenderPassDepthStencilAttachment, stencilReadOnly,   44, 36);
STRUCT(WGPURenderPassDepthStencilAttachment, 48, 40, 8, 4);

// WGPURenderPassMaxDrawCount
FIELD(WGPURenderPassMaxDrawCount, chain,        0,  0);
FIELD(WGPURenderPassMaxDrawCount, maxDrawCount, 16, 8);
STRUCT(WGPURenderPassMaxDrawCount, 24, 16, 8, 8);

// WGPURequestAdapterWebXROptions
FIELD(WGPURequestAdapterWebXROptions, chain,        0,  0);
FIELD(WGPURequestAdapterWebXROptions, xrCompatible, 16, 8);
STRUCT(WGPURequestAdapterWebXROptions, 24, 12, 8, 4);

// WGPUSamplerBindingLayout
FIELD(WGPUSamplerBindingLayout, nextInChain, 0, 0);
FIELD(WGPUSamplerBindingLayout, type,        8, 4);
STRUCT(WGPUSamplerBindingLayout, 16, 8, 8, 4);

// WGPUSamplerDescriptor
FIELD(WGPUSamplerDescriptor, nextInChain,   0,  0);
FIELD(WGPUSamplerDescriptor, label,         8,  4);
FIELD(WGPUSamplerDescriptor, addressModeU,  24, 12);
FIELD(WGPUSamplerDescriptor, addressModeV,  28, 16);
FIELD(WGPUSamplerDescriptor, addressModeW,  32, 20);
FIELD(WGPUSamplerDescriptor, magFilter,     36, 24);
FIELD(WGPUSamplerDescriptor, minFilter,     40, 28);
FIELD(WGPUSamplerDescriptor, mipmapFilter,  44, 32);
FIELD(WGPUSamplerDescriptor, lodMinClamp,   48, 36);
FIELD(WGPUSamplerDescriptor, lodMaxClamp,   52, 40);
FIELD(WGPUSamplerDescriptor, compare,       56, 44);
FIELD(WGPUSamplerDescriptor, maxAnisotropy, 60, 48);
STRUCT(WGPUSamplerDescriptor, 64, 52, 8, 4);

// WGPUShaderSourceWGSL
FIELD(WGPUShaderSourceWGSL, chain, 0,  0);
FIELD(WGPUShaderSourceWGSL, code,  16, 8);
STRUCT(WGPUShaderSourceWGSL, 32, 16, 8, 4);

// WGPUStencilFaceState
FIELD(WGPUStencilFaceState, compare,     0,  0);
FIELD(WGPUStencilFaceState, failOp,      4,  4);
FIELD(WGPUStencilFaceState, depthFailOp, 8,  8);
FIELD(WGPUStencilFaceState, passOp,      12, 12);
STRUCT(WGPUStencilFaceState, 16, 16, 4, 4);

// WGPUStorageTextureBindingLayout
FIELD(WGPUStorageTextureBindingLayout, nextInChain,   0,  0);
FIELD(WGPUStorageTextureBindingLayout, access,        8,  4);
FIELD(WGPUStorageTextureBindingLayout, format,        12, 8);
FIELD(WGPUStorageTextureBindingLayout, viewDimension, 16, 12);
STRUCT(WGPUStorageTextureBindingLayout, 24, 16, 8, 4);

// WGPUSupportedFeatures
FIELD(WGPUSupportedFeatures, featureCount, 0, 0);
FIELD(WGPUSupportedFeatures, features,     8, 4);
STRUCT(WGPUSupportedFeatures, 16, 8, 8, 4);

// WGPUSupportedInstanceFeatures
FIELD(WGPUSupportedInstanceFeatures, featureCount, 0, 0);
FIELD(WGPUSupportedInstanceFeatures, features,     8, 4);
STRUCT(WGPUSupportedInstanceFeatures, 16, 8, 8, 4);

// WGPUSupportedWGSLLanguageFeatures
FIELD(WGPUSupportedWGSLLanguageFeatures, featureCount, 0, 0);
FIELD(WGPUSupportedWGSLLanguageFeatures, features,     8, 4);
STRUCT(WGPUSupportedWGSLLanguageFeatures, 16, 8, 8, 4);

// WGPUSurfaceCapabilities
FIELD(WGPUSurfaceCapabilities, nextInChain,      0,  0);
FIELD(WGPUSurfaceCapabilities, usages,           8,  8);
FIELD(WGPUSurfaceCapabilities, formatCount,      16, 16);
FIELD(WGPUSurfaceCapabilities, formats,          24, 20);
FIELD(WGPUSurfaceCapabilities, presentModeCount, 32, 24);
FIELD(WGPUSurfaceCapabilities, presentModes,     40, 28);
FIELD(WGPUSurfaceCapabilities, alphaModeCount,   48, 32);
FIELD(WGPUSurfaceCapabilities, alphaModes,       56, 36);
STRUCT(WGPUSurfaceCapabilities, 64, 40, 8, 8);

// WGPUSurfaceColorManagement
FIELD(WGPUSurfaceColorManagement, chain,           0,  0);
FIELD(WGPUSurfaceColorManagement, colorSpace,      16, 8);
FIELD(WGPUSurfaceColorManagement, toneMappingMode, 20, 12);
STRUCT(WGPUSurfaceColorManagement, 24, 16, 8, 4);

// WGPUSurfaceConfiguration
FIELD(WGPUSurfaceConfiguration, nextInChain,     0,  0);
FIELD(WGPUSurfaceConfiguration, device,          8,  4);
FIELD(WGPUSurfaceConfiguration, format,          16, 8);
FIELD(WGPUSurfaceConfiguration, usage,           24, 16);
FIELD(WGPUSurfaceConfiguration, width,           32, 24);
FIELD(WGPUSurfaceConfiguration, height,          36, 28);
FIELD(WGPUSurfaceConfiguration, viewFormatCount, 40, 32);
FIELD(WGPUSurfaceConfiguration, viewFormats,     48, 36);
FIELD(WGPUSurfaceConfiguration, alphaMode,       56, 40);
FIELD(WGPUSurfaceConfiguration, presentMode,     60, 44);
STRUCT(WGPUSurfaceConfiguration, 64, 48, 8, 8);

// WGPUSurfaceDescriptor
FIELD(WGPUSurfaceDescriptor, nextInChain, 0, 0);
FIELD(WGPUSurfaceDescriptor, label,       8, 4);
STRUCT(WGPUSurfaceDescriptor, 24, 12, 8, 4);

// WGPUSurfaceTexture
FIELD(WGPUSurfaceTexture, nextInChain, 0,  0);
FIELD(WGPUSurfaceTexture, texture,     8,  4);
FIELD(WGPUSurfaceTexture, status,      16, 8);
STRUCT(WGPUSurfaceTexture, 24, 12, 8, 4);

// WGPUTexelCopyBufferLayout
FIELD(WGPUTexelCopyBufferLayout, offset,       0,  0);
FIELD(WGPUTexelCopyBufferLayout, bytesPerRow,  8,  8);
FIELD(WGPUTexelCopyBufferLayout, rowsPerImage, 12, 12);
STRUCT(WGPUTexelCopyBufferLayout, 16, 16, 8, 8);

// WGPUTextureBindingLayout
FIELD(WGPUTextureBindingLayout, nextInChain,   0,  0);
FIELD(WGPUTextureBindingLayout, sampleType,    8,  4);
FIELD(WGPUTextureBindingLayout, viewDimension, 12, 8);
FIELD(WGPUTextureBindingLayout, multisampled,  16, 12);
STRUCT(WGPUTextureBindingLayout, 24, 16, 8, 4);

// WGPUTextureBindingViewDimension
FIELD(WGPUTextureBindingViewDimension, chain,                       0,  0);
FIELD(WGPUTextureBindingViewDimension, textureBindingViewDimension, 16, 8);
STRUCT(WGPUTextureBindingViewDimension, 24, 12, 8, 4);

// WGPUTextureComponentSwizzle
FIELD(WGPUTextureComponentSwizzle, r, 0,  0);
FIELD(WGPUTextureComponentSwizzle, g, 4,  4);
FIELD(WGPUTextureComponentSwizzle, b, 8,  8);
FIELD(WGPUTextureComponentSwizzle, a, 12, 12);
STRUCT(WGPUTextureComponentSwizzle, 16, 16, 4, 4);

// WGPUVertexAttribute
FIELD(WGPUVertexAttribute, nextInChain,    0,  0);
FIELD(WGPUVertexAttribute, format,         8,  4);
FIELD(WGPUVertexAttribute, offset,         16, 8);
FIELD(WGPUVertexAttribute, shaderLocation, 24, 16);
STRUCT(WGPUVertexAttribute, 32, 24, 8, 8);

// WGPUBindGroupEntry
FIELD(WGPUBindGroupEntry, nextInChain, 0,  0);
FIELD(WGPUBindGroupEntry, binding,     8,  4);
FIELD(WGPUBindGroupEntry, buffer,      16, 8);
FIELD(WGPUBindGroupEntry, offset,      24, 16);
FIELD(WGPUBindGroupEntry, size,        32, 24);
FIELD(WGPUBindGroupEntry, sampler,     40, 32);
FIELD(WGPUBindGroupEntry, textureView, 48, 36);
STRUCT(WGPUBindGroupEntry, 56, 40, 8, 8);

// WGPUBindGroupLayoutEntry
FIELD(WGPUBindGroupLayoutEntry, nextInChain,      0,  0);
FIELD(WGPUBindGroupLayoutEntry, binding,          8,  4);
FIELD(WGPUBindGroupLayoutEntry, visibility,       16, 8);
FIELD(WGPUBindGroupLayoutEntry, bindingArraySize, 24, 16);
FIELD(WGPUBindGroupLayoutEntry, buffer,           32, 24);
FIELD(WGPUBindGroupLayoutEntry, sampler,          56, 48);
FIELD(WGPUBindGroupLayoutEntry, texture,          72, 56);
FIELD(WGPUBindGroupLayoutEntry, storageTexture,   96, 72);
STRUCT(WGPUBindGroupLayoutEntry, 120, 88, 8, 8);

// WGPUBlendState
FIELD(WGPUBlendState, color, 0,  0);
FIELD(WGPUBlendState, alpha, 12, 12);
STRUCT(WGPUBlendState, 24, 24, 4, 4);

// WGPUComputePassDescriptor
FIELD(WGPUComputePassDescriptor, nextInChain,     0,  0);
FIELD(WGPUComputePassDescriptor, label,           8,  4);
FIELD(WGPUComputePassDescriptor, timestampWrites, 24, 12);
STRUCT(WGPUComputePassDescriptor, 32, 16, 8, 4);

// WGPUComputeState
FIELD(WGPUComputeState, nextInChain,   0,  0);
FIELD(WGPUComputeState, module,        8,  4);
FIELD(WGPUComputeState, entryPoint,    16, 8);
FIELD(WGPUComputeState, constantCount, 32, 16);
FIELD(WGPUComputeState, constants,     40, 20);
STRUCT(WGPUComputeState, 48, 24, 8, 4);

// WGPUDepthStencilState
FIELD(WGPUDepthStencilState, nextInChain,         0,  0);
FIELD(WGPUDepthStencilState, format,              8,  4);
FIELD(WGPUDepthStencilState, depthWriteEnabled,   12, 8);
FIELD(WGPUDepthStencilState, depthCompare,        16, 12);
FIELD(WGPUDepthStencilState, stencilFront,        20, 16);
FIELD(WGPUDepthStencilState, stencilBack,         36, 32);
FIELD(WGPUDepthStencilState, stencilReadMask,     52, 48);
FIELD(WGPUDepthStencilState, stencilWriteMask,    56, 52);
FIELD(WGPUDepthStencilState, depthBias,           60, 56);
FIELD(WGPUDepthStencilState, depthBiasSlopeScale, 64, 60);
FIELD(WGPUDepthStencilState, depthBiasClamp,      68, 64);
STRUCT(WGPUDepthStencilState, 72, 68, 8, 4);

// WGPUFutureWaitInfo
FIELD(WGPUFutureWaitInfo, future,    0, 0);
FIELD(WGPUFutureWaitInfo, completed, 8, 8);
STRUCT(WGPUFutureWaitInfo, 16, 16, 8, 8);

// WGPUInstanceDescriptor
FIELD(WGPUInstanceDescriptor, nextInChain,          0,  0);
FIELD(WGPUInstanceDescriptor, requiredFeatureCount, 8,  4);
FIELD(WGPUInstanceDescriptor, requiredFeatures,     16, 8);
FIELD(WGPUInstanceDescriptor, requiredLimits,       24, 12);
STRUCT(WGPUInstanceDescriptor, 32, 16, 8, 4);

// WGPULimits
FIELD(WGPULimits, nextInChain,                               0,   0);
FIELD(WGPULimits, maxTextureDimension1D,                     8,   4);
FIELD(WGPULimits, maxTextureDimension2D,                     12,  8);
FIELD(WGPULimits, maxTextureDimension3D,                     16,  12);
FIELD(WGPULimits, maxTextureArrayLayers,                     20,  16);
FIELD(WGPULimits, maxBindGroups,                             24,  20);
FIELD(WGPULimits, maxBindGroupsPlusVertexBuffers,            28,  24);
FIELD(WGPULimits, maxBindingsPerBindGroup,                   32,  28);
FIELD(WGPULimits, maxDynamicUniformBuffersPerPipelineLayout, 36,  32);
FIELD(WGPULimits, maxDynamicStorageBuffersPerPipelineLayout, 40,  36);
FIELD(WGPULimits, maxSampledTexturesPerShaderStage,          44,  40);
FIELD(WGPULimits, maxSamplersPerShaderStage,                 48,  44);
FIELD(WGPULimits, maxStorageBuffersPerShaderStage,           52,  48);
FIELD(WGPULimits, maxStorageTexturesPerShaderStage,          56,  52);
FIELD(WGPULimits, maxUniformBuffersPerShaderStage,           60,  56);
FIELD(WGPULimits, maxUniformBufferBindingSize,               64,  64);
FIELD(WGPULimits, maxStorageBufferBindingSize,               72,  72);
FIELD(WGPULimits, minUniformBufferOffsetAlignment,           80,  80);
FIELD(WGPULimits, minStorageBufferOffsetAlignment,           84,  84);
FIELD(WGPULimits, maxVertexBuffers,                          88,  88);
FIELD(WGPULimits, maxBufferSize,                             96,  96);
FIELD(WGPULimits, maxVertexAttributes,                       104, 104);
FIELD(WGPULimits, maxVertexBufferArrayStride,                108, 108);
FIELD(WGPULimits, maxInterStageShaderVariables,              112, 112);
FIELD(WGPULimits, maxColorAttachments,                       116, 116);
FIELD(WGPULimits, maxColorAttachmentBytesPerSample,          120, 120);
FIELD(WGPULimits, maxComputeWorkgroupStorageSize,            124, 124);
FIELD(WGPULimits, maxComputeInvocationsPerWorkgroup,         128, 128);
FIELD(WGPULimits, maxComputeWorkgroupSizeX,                  132, 132);
FIELD(WGPULimits, maxComputeWorkgroupSizeY,                  136, 136);
FIELD(WGPULimits, maxComputeWorkgroupSizeZ,                  140, 140);
FIELD(WGPULimits, maxComputeWorkgroupsPerDimension,          144, 144);
FIELD(WGPULimits, maxImmediateSize,                          148, 148);
STRUCT(WGPULimits, 152, 152, 8, 8);

// WGPURenderPassColorAttachment
FIELD(WGPURenderPassColorAttachment, nextInChain,   0,  0);
FIELD(WGPURenderPassColorAttachment, view,          8,  4);
FIELD(WGPURenderPassColorAttachment, depthSlice,    16, 8);
FIELD(WGPURenderPassColorAttachment, resolveTarget, 24, 12);
FIELD(WGPURenderPassColorAttachment, loadOp,        32, 16);
FIELD(WGPURenderPassColorAttachment, storeOp,       36, 20);
FIELD(WGPURenderPassColorAttachment, clearValue,    40, 24);
STRUCT(WGPURenderPassColorAttachment, 72, 56, 8, 8);

// WGPURequestAdapterOptions
FIELD(WGPURequestAdapterOptions, nextInChain,          0,  0);
FIELD(WGPURequestAdapterOptions, featureLevel,         8,  4);
FIELD(WGPURequestAdapterOptions, powerPreference,      12, 8);
FIELD(WGPURequestAdapterOptions, forceFallbackAdapter, 16, 12);
FIELD(WGPURequestAdapterOptions, backendType,          20, 16);
FIELD(WGPURequestAdapterOptions, compatibleSurface,    24, 20);
STRUCT(WGPURequestAdapterOptions, 32, 24, 8, 4);

// WGPUShaderModuleDescriptor
FIELD(WGPUShaderModuleDescriptor, nextInChain, 0, 0);
FIELD(WGPUShaderModuleDescriptor, label,       8, 4);
STRUCT(WGPUShaderModuleDescriptor, 24, 12, 8, 4);

// WGPUTexelCopyBufferInfo
FIELD(WGPUTexelCopyBufferInfo, layout, 0,  0);
FIELD(WGPUTexelCopyBufferInfo, buffer, 16, 16);
STRUCT(WGPUTexelCopyBufferInfo, 24, 24, 8, 8);

// WGPUTexelCopyTextureInfo
FIELD(WGPUTexelCopyTextureInfo, texture,  0,  0);
FIELD(WGPUTexelCopyTextureInfo, mipLevel, 8,  4);
FIELD(WGPUTexelCopyTextureInfo, origin,   12, 8);
FIELD(WGPUTexelCopyTextureInfo, aspect,   24, 20);
STRUCT(WGPUTexelCopyTextureInfo, 32, 24, 8, 4);

// WGPUTextureComponentSwizzleDescriptor
FIELD(WGPUTextureComponentSwizzleDescriptor, chain,   0,  0);
FIELD(WGPUTextureComponentSwizzleDescriptor, swizzle, 16, 8);
STRUCT(WGPUTextureComponentSwizzleDescriptor, 32, 24, 8, 4);

// WGPUTextureDescriptor
FIELD(WGPUTextureDescriptor, nextInChain,     0,  0);
FIELD(WGPUTextureDescriptor, label,           8,  4);
FIELD(WGPUTextureDescriptor, usage,           24, 16);
FIELD(WGPUTextureDescriptor, dimension,       32, 24);
FIELD(WGPUTextureDescriptor, size,            36, 28);
FIELD(WGPUTextureDescriptor, format,          48, 40);
FIELD(WGPUTextureDescriptor, mipLevelCount,   52, 44);
FIELD(WGPUTextureDescriptor, sampleCount,     56, 48);
FIELD(WGPUTextureDescriptor, viewFormatCount, 64, 52);
FIELD(WGPUTextureDescriptor, viewFormats,     72, 56);
STRUCT(WGPUTextureDescriptor, 80, 64, 8, 8);

// WGPUVertexBufferLayout
FIELD(WGPUVertexBufferLayout, nextInChain,    0,  0);
FIELD(WGPUVertexBufferLayout, stepMode,       8,  4);
FIELD(WGPUVertexBufferLayout, arrayStride,    16, 8);
FIELD(WGPUVertexBufferLayout, attributeCount, 24, 16);
FIELD(WGPUVertexBufferLayout, attributes,     32, 20);
STRUCT(WGPUVertexBufferLayout, 40, 24, 8, 8);

// WGPUBindGroupDescriptor
FIELD(WGPUBindGroupDescriptor, nextInChain, 0,  0);
FIELD(WGPUBindGroupDescriptor, label,       8,  4);
FIELD(WGPUBindGroupDescriptor, layout,      24, 12);
FIELD(WGPUBindGroupDescriptor, entryCount,  32, 16);
FIELD(WGPUBindGroupDescriptor, entries,     40, 20);
STRUCT(WGPUBindGroupDescriptor, 48, 24, 8, 4);

// WGPUBindGroupLayoutDescriptor
FIELD(WGPUBindGroupLayoutDescriptor, nextInChain, 0,  0);
FIELD(WGPUBindGroupLayoutDescriptor, label,       8,  4);
FIELD(WGPUBindGroupLayoutDescriptor, entryCount,  24, 12);
FIELD(WGPUBindGroupLayoutDescriptor, entries,     32, 16);
STRUCT(WGPUBindGroupLayoutDescriptor, 40, 20, 8, 4);

// WGPUColorTargetState
FIELD(WGPUColorTargetState, nextInChain, 0,  0);
FIELD(WGPUColorTargetState, format,      8,  4);
FIELD(WGPUColorTargetState, blend,       16, 8);
FIELD(WGPUColorTargetState, writeMask,   24, 16);
STRUCT(WGPUColorTargetState, 32, 24, 8, 8);

// WGPUComputePipelineDescriptor
FIELD(WGPUComputePipelineDescriptor, nextInChain, 0,  0);
FIELD(WGPUComputePipelineDescriptor, label,       8,  4);
FIELD(WGPUComputePipelineDescriptor, layout,      24, 12);
FIELD(WGPUComputePipelineDescriptor, compute,     32, 16);
STRUCT(WGPUComputePipelineDescriptor, 80, 40, 8, 4);

// WGPURenderPassDescriptor
FIELD(WGPURenderPassDescriptor, nextInChain,            0,  0);
FIELD(WGPURenderPassDescriptor, label,                  8,  4);
FIELD(WGPURenderPassDescriptor, colorAttachmentCount,   24, 12);
FIELD(WGPURenderPassDescriptor, colorAttachments,       32, 16);
FIELD(WGPURenderPassDescriptor, depthStencilAttachment, 40, 20);
FIELD(WGPURenderPassDescriptor, occlusionQuerySet,      48, 24);
FIELD(WGPURenderPassDescriptor, timestampWrites,        56, 28);
STRUCT(WGPURenderPassDescriptor, 64, 32, 8, 4);

// WGPUTextureViewDescriptor
FIELD(WGPUTextureViewDescriptor, nextInChain,     0,  0);
FIELD(WGPUTextureViewDescriptor, label,           8,  4);
FIELD(WGPUTextureViewDescriptor, format,          24, 12);
FIELD(WGPUTextureViewDescriptor, dimension,       28, 16);
FIELD(WGPUTextureViewDescriptor, baseMipLevel,    32, 20);
FIELD(WGPUTextureViewDescriptor, mipLevelCount,   36, 24);
FIELD(WGPUTextureViewDescriptor, baseArrayLayer,  40, 28);
FIELD(WGPUTextureViewDescriptor, arrayLayerCount, 44, 32);
FIELD(WGPUTextureViewDescriptor, aspect,          48, 36);
FIELD(WGPUTextureViewDescriptor, usage,           56, 40);
STRUCT(WGPUTextureViewDescriptor, 64, 48, 8, 8);

// WGPUVertexState
FIELD(WGPUVertexState, nextInChain,   0,  0);
FIELD(WGPUVertexState, module,        8,  4);
FIELD(WGPUVertexState, entryPoint,    16, 8);
FIELD(WGPUVertexState, constantCount, 32, 16);
FIELD(WGPUVertexState, constants,     40, 20);
FIELD(WGPUVertexState, bufferCount,   48, 24);
FIELD(WGPUVertexState, buffers,       56, 28);
STRUCT(WGPUVertexState, 64, 32, 8, 4);

// WGPUFragmentState
FIELD(WGPUFragmentState, nextInChain,   0,  0);
FIELD(WGPUFragmentState, module,        8,  4);
FIELD(WGPUFragmentState, entryPoint,    16, 8);
FIELD(WGPUFragmentState, constantCount, 32, 16);
FIELD(WGPUFragmentState, constants,     40, 20);
FIELD(WGPUFragmentState, targetCount,   48, 24);
FIELD(WGPUFragmentState, targets,       56, 28);
STRUCT(WGPUFragmentState, 64, 32, 8, 4);

// WGPURenderPipelineDescriptor
FIELD(WGPURenderPipelineDescriptor, nextInChain,  0,   0);
FIELD(WGPURenderPipelineDescriptor, label,        8,   4);
FIELD(WGPURenderPipelineDescriptor, layout,       24,  12);
FIELD(WGPURenderPipelineDescriptor, vertex,       32,  16);
FIELD(WGPURenderPipelineDescriptor, primitive,    96,  48);
FIELD(WGPURenderPipelineDescriptor, depthStencil, 128, 72);
FIELD(WGPURenderPipelineDescriptor, multisample,  136, 76);
FIELD(WGPURenderPipelineDescriptor, fragment,     160, 92);
STRUCT(WGPURenderPipelineDescriptor, 168, 96, 8, 4);
