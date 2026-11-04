/-
================================================================================
  GENERATED FILE: DO NOT EDIT BY HAND

  Generator:        webgpu-gen
  Generator commit: bf5c6e3 (clean)
  Generated:        2026-11-04 23:49:00 UTC
  Source:           vendor/webgpu-headers/webgpu.yml
  Source repo:      https://github.com/webgpu-native/webgpu-headers
  Source commit:    673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
  Source date:      2026-05-07
  Source pinned by: wgpu-native v29.0.1.1
================================================================================
-/
module

public import WebGPU.Raw.CEnum
public import WebGPU.Raw.Enums
public import WebGPU.Raw.Objects
public import WebGPU.Raw.Encoders

/-!
# Functions

The functions and methods of `webgpu.h` the bindings can bind so far, each in
`IO`. A method takes its object first, as `self`, so `device.getQueue` calls
`wgpuDeviceGetQueue`. Each calls a raw declaration under `Internal`, which
its C shim implements, and which is not API: only these functions call
them. `docs/Safety.md` gives the rules they follow.
-/

@[expose] public section

namespace WebGPU.Raw

open Reloc

/-- The shim behind `createInstance`. -/
@[extern "lean_wgpuCreateInstance"]
opaque Internal.createInstance
    (descriptor        : @& Option InstanceDescriptor)
    (descriptorBytes   : @& OptBytesOf descriptor)
    (descriptorTargets : @& OptTargetsOf descriptor)
    (descriptorTable   : @& IndexOf InstanceDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO Instance

/-- Create a WGPUInstance -/
@[inline]
def createInstance (descriptor : Option InstanceDescriptor) : IO Instance :=
  if CStruct.optSizesFit descriptor then
    Internal.createInstance descriptor ⟨_, rfl⟩ ⟨_, rfl⟩ ⟨_, rfl⟩ ⟨_, rfl⟩
  else
    throw (IO.userError "createInstance: a size_t too large")

/-- The shim behind `hasInstanceFeature`. -/
@[extern "lean_wgpuHasInstanceFeature"]
opaque Internal.hasInstanceFeature (feature : UInt32) : IO Bool

/--
Check whether a particular `InstanceFeatureName` is supported by the instance.
-/
@[inline]
def hasInstanceFeature (feature : InstanceFeatureName) : IO Bool :=
  Internal.hasInstanceFeature (CEnum.toC feature)

/-- The shim behind `Adapter.hasFeature`. -/
@[extern "lean_wgpuAdapterHasFeature"]
opaque Internal.Adapter.hasFeature
    (self    : @& Adapter)
    (feature : UInt32) :
    IO Bool

@[inline]
def Adapter.hasFeature (self : Adapter) (feature : FeatureName) : IO Bool :=
  Internal.Adapter.hasFeature self (CEnum.toC feature)

/-- The shim behind `BindGroup.setLabel`. -/
@[extern "lean_wgpuBindGroupSetLabel"]
opaque Internal.BindGroup.setLabel
    (self  : @& BindGroup)
    (label : @& String) :
    IO Unit

@[inline]
def BindGroup.setLabel (self : BindGroup) (label : String) : IO Unit :=
  Internal.BindGroup.setLabel self label

/-- The shim behind `BindGroupLayout.setLabel`. -/
@[extern "lean_wgpuBindGroupLayoutSetLabel"]
opaque Internal.BindGroupLayout.setLabel
    (self  : @& BindGroupLayout)
    (label : @& String) :
    IO Unit

@[inline]
def BindGroupLayout.setLabel
    (self  : BindGroupLayout)
    (label : String) :
    IO Unit :=
  Internal.BindGroupLayout.setLabel self label

/-- The shim behind `Buffer.setLabel`. -/
@[extern "lean_wgpuBufferSetLabel"]
opaque Internal.Buffer.setLabel (self : @& Buffer) (label : @& String) : IO Unit

@[inline]
def Buffer.setLabel (self : Buffer) (label : String) : IO Unit :=
  Internal.Buffer.setLabel self label

/-- The shim behind `Buffer.getUsage`. -/
@[extern "lean_wgpuBufferGetUsage"]
opaque Internal.Buffer.getUsage (self : @& Buffer) : IO UInt64

@[inline]
def Buffer.getUsage (self : Buffer) : IO BufferUsage :=
  BufferUsage.mk <$> Internal.Buffer.getUsage self

/-- The shim behind `Buffer.getSize`. -/
@[extern "lean_wgpuBufferGetSize"]
opaque Internal.Buffer.getSize (self : @& Buffer) : IO UInt64

@[inline]
def Buffer.getSize (self : Buffer) : IO UInt64 :=
  Internal.Buffer.getSize self

/-- The shim behind `Buffer.getMapState`. -/
@[extern "lean_wgpuBufferGetMapState"]
opaque Internal.Buffer.getMapState (self : @& Buffer) : IO UInt32

@[inline]
def Buffer.getMapState (self : Buffer) : IO (Except UInt32 BufferMapState) :=
  CEnum.decode <$> Internal.Buffer.getMapState self

/-- The shim behind `Buffer.unmap`. -/
@[extern "lean_wgpuBufferUnmap"]
opaque Internal.Buffer.unmap (self : @& Buffer) : IO Unit

@[inline]
def Buffer.unmap (self : Buffer) : IO Unit :=
  Internal.Buffer.unmap self

/-- The shim behind `Buffer.destroy`. -/
@[extern "lean_wgpuBufferDestroy"]
opaque Internal.Buffer.destroy (self : @& Buffer) : IO Unit

@[inline]
def Buffer.destroy (self : Buffer) : IO Unit :=
  Internal.Buffer.destroy self

/-- The shim behind `CommandBuffer.setLabel`. -/
@[extern "lean_wgpuCommandBufferSetLabel"]
opaque Internal.CommandBuffer.setLabel
    (self  : @& CommandBuffer)
    (label : @& String) :
    IO Unit

@[inline]
def CommandBuffer.setLabel (self : CommandBuffer) (label : String) : IO Unit :=
  Internal.CommandBuffer.setLabel self label

/-- The shim behind `CommandEncoder.finish`. -/
@[extern "lean_wgpuCommandEncoderFinish"]
opaque Internal.CommandEncoder.finish
    (self              : @& CommandEncoder)
    (descriptor        : @& Option CommandBufferDescriptor)
    (descriptorBytes   : @& OptBytesOf descriptor)
    (descriptorTargets : @& OptTargetsOf descriptor)
    (descriptorTable   : @& IndexOf CommandBufferDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO CommandBuffer

@[inline]
def CommandEncoder.finish
    (self       : CommandEncoder)
    (descriptor : Option CommandBufferDescriptor) :
    IO CommandBuffer :=
  if CStruct.optSizesFit descriptor then
    Internal.CommandEncoder.finish
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "CommandEncoder.finish: a size_t too large")

/-- The shim behind `CommandEncoder.beginComputePass`. -/
@[extern "lean_wgpuCommandEncoderBeginComputePass"]
opaque Internal.CommandEncoder.beginComputePass
    (self              : @& CommandEncoder)
    (descriptor        : @& Option ComputePassDescriptor)
    (descriptorBytes   : @& OptBytesOf descriptor)
    (descriptorTargets : @& OptTargetsOf descriptor)
    (descriptorTable   : @& IndexOf ComputePassDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO ComputePassEncoder

@[inline]
def CommandEncoder.beginComputePass
    (self       : CommandEncoder)
    (descriptor : Option ComputePassDescriptor) :
    IO ComputePassEncoder :=
  if CStruct.optSizesFit descriptor then
    Internal.CommandEncoder.beginComputePass
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "CommandEncoder.beginComputePass: a size_t too large")

/-- The shim behind `CommandEncoder.beginRenderPass`. -/
@[extern "lean_wgpuCommandEncoderBeginRenderPass"]
opaque Internal.CommandEncoder.beginRenderPass
    (self              : @& CommandEncoder)
    (descriptor        : @& RenderPassDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf RenderPassDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO RenderPassEncoder

@[inline]
def CommandEncoder.beginRenderPass
    (self       : CommandEncoder)
    (descriptor : RenderPassDescriptor) :
    IO RenderPassEncoder :=
  if CStruct.sizesFit descriptor then
    Internal.CommandEncoder.beginRenderPass
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "CommandEncoder.beginRenderPass: a size_t too large")

/-- The shim behind `CommandEncoder.copyBufferToBuffer`. -/
@[extern "lean_wgpuCommandEncoderCopyBufferToBuffer"]
opaque Internal.CommandEncoder.copyBufferToBuffer
    (self              : @& CommandEncoder)
    (source            : @& Buffer)
    (sourceOffset      : UInt64)
    (destination       : @& Buffer)
    (destinationOffset : UInt64)
    (size              : UInt64) :
    IO Unit

@[inline]
def CommandEncoder.copyBufferToBuffer
    (self              : CommandEncoder)
    (source            : Buffer)
    (sourceOffset      : UInt64)
    (destination       : Buffer)
    (destinationOffset : UInt64)
    (size              : UInt64) :
    IO Unit :=
  Internal.CommandEncoder.copyBufferToBuffer
      self
      source
      sourceOffset
      destination
      destinationOffset
      size

/-- The shim behind `CommandEncoder.copyBufferToTexture`. -/
@[extern "lean_wgpuCommandEncoderCopyBufferToTexture"]
opaque Internal.CommandEncoder.copyBufferToTexture
    (self               : @& CommandEncoder)
    (source             : @& TexelCopyBufferInfo)
    (sourceBytes        : @& BytesOf source)
    (sourceTargets      : @& TargetsOf source)
    (sourceTable        : @& IndexOf TexelCopyBufferInfo)
    (destination        : @& TexelCopyTextureInfo)
    (destinationBytes   : @& BytesOf destination)
    (destinationTargets : @& TargetsOf destination)
    (destinationTable   : @& IndexOf TexelCopyTextureInfo)
    (copySize           : @& Extent3D)
    (copySizeBytes      : @& BytesOf copySize)
    (copySizeTargets    : @& TargetsOf copySize)
    (copySizeTable      : @& IndexOf Extent3D)
    (tables             : @& CurrentTablesOf) :
    IO Unit

@[inline]
def CommandEncoder.copyBufferToTexture
    (self        : CommandEncoder)
    (source      : TexelCopyBufferInfo)
    (destination : TexelCopyTextureInfo)
    (copySize    : Extent3D) :
    IO Unit :=
  if CStruct.sizesFit source &&
      CStruct.sizesFit destination &&
      CStruct.sizesFit copySize then
    Internal.CommandEncoder.copyBufferToTexture
        self
        source
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        destination
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        copySize
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError
      "CommandEncoder.copyBufferToTexture: a size_t too large")

/-- The shim behind `CommandEncoder.copyTextureToBuffer`. -/
@[extern "lean_wgpuCommandEncoderCopyTextureToBuffer"]
opaque Internal.CommandEncoder.copyTextureToBuffer
    (self               : @& CommandEncoder)
    (source             : @& TexelCopyTextureInfo)
    (sourceBytes        : @& BytesOf source)
    (sourceTargets      : @& TargetsOf source)
    (sourceTable        : @& IndexOf TexelCopyTextureInfo)
    (destination        : @& TexelCopyBufferInfo)
    (destinationBytes   : @& BytesOf destination)
    (destinationTargets : @& TargetsOf destination)
    (destinationTable   : @& IndexOf TexelCopyBufferInfo)
    (copySize           : @& Extent3D)
    (copySizeBytes      : @& BytesOf copySize)
    (copySizeTargets    : @& TargetsOf copySize)
    (copySizeTable      : @& IndexOf Extent3D)
    (tables             : @& CurrentTablesOf) :
    IO Unit

@[inline]
def CommandEncoder.copyTextureToBuffer
    (self        : CommandEncoder)
    (source      : TexelCopyTextureInfo)
    (destination : TexelCopyBufferInfo)
    (copySize    : Extent3D) :
    IO Unit :=
  if CStruct.sizesFit source &&
      CStruct.sizesFit destination &&
      CStruct.sizesFit copySize then
    Internal.CommandEncoder.copyTextureToBuffer
        self
        source
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        destination
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        copySize
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError
      "CommandEncoder.copyTextureToBuffer: a size_t too large")

/-- The shim behind `CommandEncoder.copyTextureToTexture`. -/
@[extern "lean_wgpuCommandEncoderCopyTextureToTexture"]
opaque Internal.CommandEncoder.copyTextureToTexture
    (self               : @& CommandEncoder)
    (source             : @& TexelCopyTextureInfo)
    (sourceBytes        : @& BytesOf source)
    (sourceTargets      : @& TargetsOf source)
    (sourceTable        : @& IndexOf TexelCopyTextureInfo)
    (destination        : @& TexelCopyTextureInfo)
    (destinationBytes   : @& BytesOf destination)
    (destinationTargets : @& TargetsOf destination)
    (destinationTable   : @& IndexOf TexelCopyTextureInfo)
    (copySize           : @& Extent3D)
    (copySizeBytes      : @& BytesOf copySize)
    (copySizeTargets    : @& TargetsOf copySize)
    (copySizeTable      : @& IndexOf Extent3D)
    (tables             : @& CurrentTablesOf) :
    IO Unit

@[inline]
def CommandEncoder.copyTextureToTexture
    (self        : CommandEncoder)
    (source      : TexelCopyTextureInfo)
    (destination : TexelCopyTextureInfo)
    (copySize    : Extent3D) :
    IO Unit :=
  if CStruct.sizesFit source &&
      CStruct.sizesFit destination &&
      CStruct.sizesFit copySize then
    Internal.CommandEncoder.copyTextureToTexture
        self
        source
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        destination
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        copySize
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError
      "CommandEncoder.copyTextureToTexture: a size_t too large")

/-- The shim behind `CommandEncoder.clearBuffer`. -/
@[extern "lean_wgpuCommandEncoderClearBuffer"]
opaque Internal.CommandEncoder.clearBuffer
    (self   : @& CommandEncoder)
    (buffer : @& Buffer)
    (offset : UInt64)
    (size   : UInt64) :
    IO Unit

@[inline]
def CommandEncoder.clearBuffer
    (self   : CommandEncoder)
    (buffer : Buffer)
    (offset : UInt64)
    (size   : UInt64) :
    IO Unit :=
  Internal.CommandEncoder.clearBuffer self buffer offset size

/-- The shim behind `CommandEncoder.insertDebugMarker`. -/
@[extern "lean_wgpuCommandEncoderInsertDebugMarker"]
opaque Internal.CommandEncoder.insertDebugMarker
    (self        : @& CommandEncoder)
    (markerLabel : @& String) :
    IO Unit

@[inline]
def CommandEncoder.insertDebugMarker
    (self        : CommandEncoder)
    (markerLabel : String) :
    IO Unit :=
  Internal.CommandEncoder.insertDebugMarker self markerLabel

/-- The shim behind `CommandEncoder.popDebugGroup`. -/
@[extern "lean_wgpuCommandEncoderPopDebugGroup"]
opaque Internal.CommandEncoder.popDebugGroup
    (self : @& CommandEncoder) :
    IO Unit

@[inline]
def CommandEncoder.popDebugGroup (self : CommandEncoder) : IO Unit :=
  Internal.CommandEncoder.popDebugGroup self

/-- The shim behind `CommandEncoder.pushDebugGroup`. -/
@[extern "lean_wgpuCommandEncoderPushDebugGroup"]
opaque Internal.CommandEncoder.pushDebugGroup
    (self       : @& CommandEncoder)
    (groupLabel : @& String) :
    IO Unit

@[inline]
def CommandEncoder.pushDebugGroup
    (self       : CommandEncoder)
    (groupLabel : String) :
    IO Unit :=
  Internal.CommandEncoder.pushDebugGroup self groupLabel

/-- The shim behind `CommandEncoder.resolveQuerySet`. -/
@[extern "lean_wgpuCommandEncoderResolveQuerySet"]
opaque Internal.CommandEncoder.resolveQuerySet
    (self              : @& CommandEncoder)
    (querySet          : @& QuerySet)
    (firstQuery        : UInt32)
    (queryCount        : UInt32)
    (destination       : @& Buffer)
    (destinationOffset : UInt64) :
    IO Unit

@[inline]
def CommandEncoder.resolveQuerySet
    (self              : CommandEncoder)
    (querySet          : QuerySet)
    (firstQuery        : UInt32)
    (queryCount        : UInt32)
    (destination       : Buffer)
    (destinationOffset : UInt64) :
    IO Unit :=
  Internal.CommandEncoder.resolveQuerySet
      self
      querySet
      firstQuery
      queryCount
      destination
      destinationOffset

/-- The shim behind `CommandEncoder.writeTimestamp`. -/
@[extern "lean_wgpuCommandEncoderWriteTimestamp"]
opaque Internal.CommandEncoder.writeTimestamp
    (self       : @& CommandEncoder)
    (querySet   : @& QuerySet)
    (queryIndex : UInt32) :
    IO Unit

@[inline]
def CommandEncoder.writeTimestamp
    (self       : CommandEncoder)
    (querySet   : QuerySet)
    (queryIndex : UInt32) :
    IO Unit :=
  Internal.CommandEncoder.writeTimestamp self querySet queryIndex

/-- The shim behind `CommandEncoder.setLabel`. -/
@[extern "lean_wgpuCommandEncoderSetLabel"]
opaque Internal.CommandEncoder.setLabel
    (self  : @& CommandEncoder)
    (label : @& String) :
    IO Unit

@[inline]
def CommandEncoder.setLabel
    (self  : CommandEncoder)
    (label : String) :
    IO Unit :=
  Internal.CommandEncoder.setLabel self label

/-- The shim behind `ComputePassEncoder.insertDebugMarker`. -/
@[extern "lean_wgpuComputePassEncoderInsertDebugMarker"]
opaque Internal.ComputePassEncoder.insertDebugMarker
    (self        : @& ComputePassEncoder)
    (markerLabel : @& String) :
    IO Unit

@[inline]
def ComputePassEncoder.insertDebugMarker
    (self        : ComputePassEncoder)
    (markerLabel : String) :
    IO Unit :=
  Internal.ComputePassEncoder.insertDebugMarker self markerLabel

/-- The shim behind `ComputePassEncoder.popDebugGroup`. -/
@[extern "lean_wgpuComputePassEncoderPopDebugGroup"]
opaque Internal.ComputePassEncoder.popDebugGroup
    (self : @& ComputePassEncoder) :
    IO Unit

@[inline]
def ComputePassEncoder.popDebugGroup (self : ComputePassEncoder) : IO Unit :=
  Internal.ComputePassEncoder.popDebugGroup self

/-- The shim behind `ComputePassEncoder.pushDebugGroup`. -/
@[extern "lean_wgpuComputePassEncoderPushDebugGroup"]
opaque Internal.ComputePassEncoder.pushDebugGroup
    (self       : @& ComputePassEncoder)
    (groupLabel : @& String) :
    IO Unit

@[inline]
def ComputePassEncoder.pushDebugGroup
    (self       : ComputePassEncoder)
    (groupLabel : String) :
    IO Unit :=
  Internal.ComputePassEncoder.pushDebugGroup self groupLabel

/-- The shim behind `ComputePassEncoder.setPipeline`. -/
@[extern "lean_wgpuComputePassEncoderSetPipeline"]
opaque Internal.ComputePassEncoder.setPipeline
    (self     : @& ComputePassEncoder)
    (pipeline : @& ComputePipeline) :
    IO Unit

@[inline]
def ComputePassEncoder.setPipeline
    (self     : ComputePassEncoder)
    (pipeline : ComputePipeline) :
    IO Unit :=
  Internal.ComputePassEncoder.setPipeline self pipeline

/-- The shim behind `ComputePassEncoder.dispatchWorkgroups`. -/
@[extern "lean_wgpuComputePassEncoderDispatchWorkgroups"]
opaque Internal.ComputePassEncoder.dispatchWorkgroups
    (self            : @& ComputePassEncoder)
    (workgroupCountX : UInt32)
    (workgroupCountY : UInt32)
    (workgroupCountZ : UInt32) :
    IO Unit

@[inline]
def ComputePassEncoder.dispatchWorkgroups
    (self            : ComputePassEncoder)
    (workgroupCountX : UInt32)
    (workgroupCountY : UInt32)
    (workgroupCountZ : UInt32) :
    IO Unit :=
  Internal.ComputePassEncoder.dispatchWorkgroups
      self
      workgroupCountX
      workgroupCountY
      workgroupCountZ

/-- The shim behind `ComputePassEncoder.dispatchWorkgroupsIndirect`. -/
@[extern "lean_wgpuComputePassEncoderDispatchWorkgroupsIndirect"]
opaque Internal.ComputePassEncoder.dispatchWorkgroupsIndirect
    (self           : @& ComputePassEncoder)
    (indirectBuffer : @& Buffer)
    (indirectOffset : UInt64) :
    IO Unit

@[inline]
def ComputePassEncoder.dispatchWorkgroupsIndirect
    (self           : ComputePassEncoder)
    (indirectBuffer : Buffer)
    (indirectOffset : UInt64) :
    IO Unit :=
  Internal.ComputePassEncoder.dispatchWorkgroupsIndirect
      self
      indirectBuffer
      indirectOffset

/-- The shim behind `ComputePassEncoder.«end»`. -/
@[extern "lean_wgpuComputePassEncoderEnd"]
opaque Internal.ComputePassEncoder.«end»
    (self : @& ComputePassEncoder) :
    IO Unit

@[inline]
def ComputePassEncoder.«end» (self : ComputePassEncoder) : IO Unit :=
  Internal.ComputePassEncoder.«end» self

/-- The shim behind `ComputePassEncoder.setLabel`. -/
@[extern "lean_wgpuComputePassEncoderSetLabel"]
opaque Internal.ComputePassEncoder.setLabel
    (self  : @& ComputePassEncoder)
    (label : @& String) :
    IO Unit

@[inline]
def ComputePassEncoder.setLabel
    (self  : ComputePassEncoder)
    (label : String) :
    IO Unit :=
  Internal.ComputePassEncoder.setLabel self label

/-- The shim behind `ComputePipeline.getBindGroupLayout`. -/
@[extern "lean_wgpuComputePipelineGetBindGroupLayout"]
opaque Internal.ComputePipeline.getBindGroupLayout
    (self       : @& ComputePipeline)
    (groupIndex : UInt32) :
    IO BindGroupLayout

@[inline]
def ComputePipeline.getBindGroupLayout
    (self       : ComputePipeline)
    (groupIndex : UInt32) :
    IO BindGroupLayout :=
  Internal.ComputePipeline.getBindGroupLayout self groupIndex

/-- The shim behind `ComputePipeline.setLabel`. -/
@[extern "lean_wgpuComputePipelineSetLabel"]
opaque Internal.ComputePipeline.setLabel
    (self  : @& ComputePipeline)
    (label : @& String) :
    IO Unit

@[inline]
def ComputePipeline.setLabel
    (self  : ComputePipeline)
    (label : String) :
    IO Unit :=
  Internal.ComputePipeline.setLabel self label

/-- The shim behind `Device.createBindGroup`. -/
@[extern "lean_wgpuDeviceCreateBindGroup"]
opaque Internal.Device.createBindGroup
    (self              : @& Device)
    (descriptor        : @& BindGroupDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf BindGroupDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO BindGroup

@[inline]
def Device.createBindGroup
    (self       : Device)
    (descriptor : BindGroupDescriptor) :
    IO BindGroup :=
  if CStruct.sizesFit descriptor then
    Internal.Device.createBindGroup
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createBindGroup: a size_t too large")

/-- The shim behind `Device.createBindGroupLayout`. -/
@[extern "lean_wgpuDeviceCreateBindGroupLayout"]
opaque Internal.Device.createBindGroupLayout
    (self              : @& Device)
    (descriptor        : @& BindGroupLayoutDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf BindGroupLayoutDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO BindGroupLayout

@[inline]
def Device.createBindGroupLayout
    (self       : Device)
    (descriptor : BindGroupLayoutDescriptor) :
    IO BindGroupLayout :=
  if CStruct.sizesFit descriptor then
    Internal.Device.createBindGroupLayout
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createBindGroupLayout: a size_t too large")

/-- The shim behind `Device.createBuffer`. -/
@[extern "lean_wgpuDeviceCreateBuffer"]
opaque Internal.Device.createBuffer
    (self              : @& Device)
    (descriptor        : @& BufferDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf BufferDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO (Option Buffer)

/--
If `BufferDescriptor.mappedAtCreation` is `true` and the mapping allocation
fails, returns `NULL`.
-/
@[inline]
def Device.createBuffer
    (self       : Device)
    (descriptor : BufferDescriptor) :
    IO (Option Buffer) :=
  if CStruct.sizesFit descriptor then
    Internal.Device.createBuffer
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createBuffer: a size_t too large")

/-- The shim behind `Device.createCommandEncoder`. -/
@[extern "lean_wgpuDeviceCreateCommandEncoder"]
opaque Internal.Device.createCommandEncoder
    (self              : @& Device)
    (descriptor        : @& Option CommandEncoderDescriptor)
    (descriptorBytes   : @& OptBytesOf descriptor)
    (descriptorTargets : @& OptTargetsOf descriptor)
    (descriptorTable   : @& IndexOf CommandEncoderDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO CommandEncoder

@[inline]
def Device.createCommandEncoder
    (self       : Device)
    (descriptor : Option CommandEncoderDescriptor) :
    IO CommandEncoder :=
  if CStruct.optSizesFit descriptor then
    Internal.Device.createCommandEncoder
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createCommandEncoder: a size_t too large")

/-- The shim behind `Device.createComputePipeline`. -/
@[extern "lean_wgpuDeviceCreateComputePipeline"]
opaque Internal.Device.createComputePipeline
    (self              : @& Device)
    (descriptor        : @& ComputePipelineDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf ComputePipelineDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO ComputePipeline

@[inline]
def Device.createComputePipeline
    (self       : Device)
    (descriptor : ComputePipelineDescriptor) :
    IO ComputePipeline :=
  if CStruct.sizesFit descriptor then
    Internal.Device.createComputePipeline
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createComputePipeline: a size_t too large")

/-- The shim behind `Device.createPipelineLayout`. -/
@[extern "lean_wgpuDeviceCreatePipelineLayout"]
opaque Internal.Device.createPipelineLayout
    (self              : @& Device)
    (descriptor        : @& PipelineLayoutDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf PipelineLayoutDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO PipelineLayout

@[inline]
def Device.createPipelineLayout
    (self       : Device)
    (descriptor : PipelineLayoutDescriptor) :
    IO PipelineLayout :=
  if CStruct.sizesFit descriptor then
    Internal.Device.createPipelineLayout
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createPipelineLayout: a size_t too large")

/-- The shim behind `Device.createQuerySet`. -/
@[extern "lean_wgpuDeviceCreateQuerySet"]
opaque Internal.Device.createQuerySet
    (self              : @& Device)
    (descriptor        : @& QuerySetDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf QuerySetDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO QuerySet

@[inline]
def Device.createQuerySet
    (self       : Device)
    (descriptor : QuerySetDescriptor) :
    IO QuerySet :=
  if CStruct.sizesFit descriptor then
    Internal.Device.createQuerySet
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createQuerySet: a size_t too large")

/-- The shim behind `Device.createRenderBundleEncoder`. -/
@[extern "lean_wgpuDeviceCreateRenderBundleEncoder"]
opaque Internal.Device.createRenderBundleEncoder
    (self              : @& Device)
    (descriptor        : @& RenderBundleEncoderDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf RenderBundleEncoderDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO RenderBundleEncoder

@[inline]
def Device.createRenderBundleEncoder
    (self       : Device)
    (descriptor : RenderBundleEncoderDescriptor) :
    IO RenderBundleEncoder :=
  if CStruct.sizesFit descriptor then
    Internal.Device.createRenderBundleEncoder
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createRenderBundleEncoder: a size_t too large")

/-- The shim behind `Device.createRenderPipeline`. -/
@[extern "lean_wgpuDeviceCreateRenderPipeline"]
opaque Internal.Device.createRenderPipeline
    (self              : @& Device)
    (descriptor        : @& RenderPipelineDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf RenderPipelineDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO RenderPipeline

@[inline]
def Device.createRenderPipeline
    (self       : Device)
    (descriptor : RenderPipelineDescriptor) :
    IO RenderPipeline :=
  if CStruct.sizesFit descriptor then
    Internal.Device.createRenderPipeline
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createRenderPipeline: a size_t too large")

/-- The shim behind `Device.createSampler`. -/
@[extern "lean_wgpuDeviceCreateSampler"]
opaque Internal.Device.createSampler
    (self              : @& Device)
    (descriptor        : @& Option SamplerDescriptor)
    (descriptorBytes   : @& OptBytesOf descriptor)
    (descriptorTargets : @& OptTargetsOf descriptor)
    (descriptorTable   : @& IndexOf SamplerDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO Sampler

@[inline]
def Device.createSampler
    (self       : Device)
    (descriptor : Option SamplerDescriptor) :
    IO Sampler :=
  if CStruct.optSizesFit descriptor then
    Internal.Device.createSampler
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createSampler: a size_t too large")

/-- The shim behind `Device.createShaderModule`. -/
@[extern "lean_wgpuDeviceCreateShaderModule"]
opaque Internal.Device.createShaderModule
    (self              : @& Device)
    (descriptor        : @& ShaderModuleDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf ShaderModuleDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO ShaderModule

@[inline]
def Device.createShaderModule
    (self       : Device)
    (descriptor : ShaderModuleDescriptor) :
    IO ShaderModule :=
  if descriptor.chain.isEmpty then
    throw (IO.userError
      "Device.createShaderModule: nothing chained to descriptor")
  else
    if CStruct.sizesFit descriptor then
      Internal.Device.createShaderModule
          self
          descriptor
          ⟨_, rfl⟩
          ⟨_, rfl⟩
          ⟨_, rfl⟩
          ⟨_, rfl⟩
    else
      throw (IO.userError "Device.createShaderModule: a size_t too large")

/-- The shim behind `Device.createTexture`. -/
@[extern "lean_wgpuDeviceCreateTexture"]
opaque Internal.Device.createTexture
    (self              : @& Device)
    (descriptor        : @& TextureDescriptor)
    (descriptorBytes   : @& BytesOf descriptor)
    (descriptorTargets : @& TargetsOf descriptor)
    (descriptorTable   : @& IndexOf TextureDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO Texture

@[inline]
def Device.createTexture
    (self       : Device)
    (descriptor : TextureDescriptor) :
    IO Texture :=
  if CStruct.sizesFit descriptor then
    Internal.Device.createTexture
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Device.createTexture: a size_t too large")

/-- The shim behind `Device.destroy`. -/
@[extern "lean_wgpuDeviceDestroy"]
opaque Internal.Device.destroy (self : @& Device) : IO Unit

@[inline]
def Device.destroy (self : Device) : IO Unit :=
  Internal.Device.destroy self

/-- The shim behind `Device.hasFeature`. -/
@[extern "lean_wgpuDeviceHasFeature"]
opaque Internal.Device.hasFeature
    (self    : @& Device)
    (feature : UInt32) :
    IO Bool

@[inline]
def Device.hasFeature (self : Device) (feature : FeatureName) : IO Bool :=
  Internal.Device.hasFeature self (CEnum.toC feature)

/-- The shim behind `Device.getQueue`. -/
@[extern "lean_wgpuDeviceGetQueue"]
opaque Internal.Device.getQueue (self : @& Device) : IO Queue

@[inline]
def Device.getQueue (self : Device) : IO Queue :=
  Internal.Device.getQueue self

/-- The shim behind `Device.pushErrorScope`. -/
@[extern "lean_wgpuDevicePushErrorScope"]
opaque Internal.Device.pushErrorScope
    (self   : @& Device)
    (filter : UInt32) :
    IO Unit

/--
Pushes an error scope to the current thread's error scope stack. See
[ErrorScopes].

[ErrorScopes]: https://webgpu-native.github.io/webgpu-headers/Errors.html#ErrorScopes
-/
@[inline]
def Device.pushErrorScope (self : Device) (filter : ErrorFilter) : IO Unit :=
  Internal.Device.pushErrorScope self (CEnum.toC filter)

/-- The shim behind `Device.setLabel`. -/
@[extern "lean_wgpuDeviceSetLabel"]
opaque Internal.Device.setLabel (self : @& Device) (label : @& String) : IO Unit

@[inline]
def Device.setLabel (self : Device) (label : String) : IO Unit :=
  Internal.Device.setLabel self label

/-- The shim behind `ExternalTexture.setLabel`. -/
@[extern "lean_wgpuExternalTextureSetLabel"]
opaque Internal.ExternalTexture.setLabel
    (self  : @& ExternalTexture)
    (label : @& String) :
    IO Unit

@[inline]
def ExternalTexture.setLabel
    (self  : ExternalTexture)
    (label : String) :
    IO Unit :=
  Internal.ExternalTexture.setLabel self label

/-- The shim behind `Instance.hasWGSLLanguageFeature`. -/
@[extern "lean_wgpuInstanceHasWGSLLanguageFeature"]
opaque Internal.Instance.hasWGSLLanguageFeature
    (self    : @& Instance)
    (feature : UInt32) :
    IO Bool

@[inline]
def Instance.hasWGSLLanguageFeature
    (self    : Instance)
    (feature : WGSLLanguageFeatureName) :
    IO Bool :=
  Internal.Instance.hasWGSLLanguageFeature self (CEnum.toC feature)

/-- The shim behind `Instance.processEvents`. -/
@[extern "lean_wgpuInstanceProcessEvents"]
opaque Internal.Instance.processEvents (self : @& Instance) : IO Unit

/--
Processes asynchronous events on this `Instance`, calling any callbacks for
asynchronous operations created with `CallbackMode.allowProcessEvents`.

See [Process-Events] for more information.

[Process-Events]: https://webgpu-native.github.io/webgpu-headers/Asynchronous-Operations.html#Process-Events
-/
@[inline]
def Instance.processEvents (self : Instance) : IO Unit :=
  Internal.Instance.processEvents self

/-- The shim behind `PipelineLayout.setLabel`. -/
@[extern "lean_wgpuPipelineLayoutSetLabel"]
opaque Internal.PipelineLayout.setLabel
    (self  : @& PipelineLayout)
    (label : @& String) :
    IO Unit

@[inline]
def PipelineLayout.setLabel
    (self  : PipelineLayout)
    (label : String) :
    IO Unit :=
  Internal.PipelineLayout.setLabel self label

/-- The shim behind `QuerySet.setLabel`. -/
@[extern "lean_wgpuQuerySetSetLabel"]
opaque Internal.QuerySet.setLabel
    (self  : @& QuerySet)
    (label : @& String) :
    IO Unit

@[inline]
def QuerySet.setLabel (self : QuerySet) (label : String) : IO Unit :=
  Internal.QuerySet.setLabel self label

/-- The shim behind `QuerySet.getType`. -/
@[extern "lean_wgpuQuerySetGetType"]
opaque Internal.QuerySet.getType (self : @& QuerySet) : IO UInt32

@[inline]
def QuerySet.getType (self : QuerySet) : IO (Except UInt32 QueryType) :=
  CEnum.decode <$> Internal.QuerySet.getType self

/-- The shim behind `QuerySet.getCount`. -/
@[extern "lean_wgpuQuerySetGetCount"]
opaque Internal.QuerySet.getCount (self : @& QuerySet) : IO UInt32

@[inline]
def QuerySet.getCount (self : QuerySet) : IO UInt32 :=
  Internal.QuerySet.getCount self

/-- The shim behind `QuerySet.destroy`. -/
@[extern "lean_wgpuQuerySetDestroy"]
opaque Internal.QuerySet.destroy (self : @& QuerySet) : IO Unit

@[inline]
def QuerySet.destroy (self : QuerySet) : IO Unit :=
  Internal.QuerySet.destroy self

/-- The shim behind `Queue.setLabel`. -/
@[extern "lean_wgpuQueueSetLabel"]
opaque Internal.Queue.setLabel (self : @& Queue) (label : @& String) : IO Unit

@[inline]
def Queue.setLabel (self : Queue) (label : String) : IO Unit :=
  Internal.Queue.setLabel self label

/-- The shim behind `RenderBundle.setLabel`. -/
@[extern "lean_wgpuRenderBundleSetLabel"]
opaque Internal.RenderBundle.setLabel
    (self  : @& RenderBundle)
    (label : @& String) :
    IO Unit

@[inline]
def RenderBundle.setLabel (self : RenderBundle) (label : String) : IO Unit :=
  Internal.RenderBundle.setLabel self label

/-- The shim behind `RenderBundleEncoder.setPipeline`. -/
@[extern "lean_wgpuRenderBundleEncoderSetPipeline"]
opaque Internal.RenderBundleEncoder.setPipeline
    (self     : @& RenderBundleEncoder)
    (pipeline : @& RenderPipeline) :
    IO Unit

@[inline]
def RenderBundleEncoder.setPipeline
    (self     : RenderBundleEncoder)
    (pipeline : RenderPipeline) :
    IO Unit :=
  Internal.RenderBundleEncoder.setPipeline self pipeline

/-- The shim behind `RenderBundleEncoder.draw`. -/
@[extern "lean_wgpuRenderBundleEncoderDraw"]
opaque Internal.RenderBundleEncoder.draw
    (self          : @& RenderBundleEncoder)
    (vertexCount   : UInt32)
    (instanceCount : UInt32)
    (firstVertex   : UInt32)
    (firstInstance : UInt32) :
    IO Unit

@[inline]
def RenderBundleEncoder.draw
    (self          : RenderBundleEncoder)
    (vertexCount   : UInt32)
    (instanceCount : UInt32)
    (firstVertex   : UInt32)
    (firstInstance : UInt32) :
    IO Unit :=
  Internal.RenderBundleEncoder.draw
      self
      vertexCount
      instanceCount
      firstVertex
      firstInstance

/-- The shim behind `RenderBundleEncoder.drawIndexed`. -/
@[extern "lean_wgpuRenderBundleEncoderDrawIndexed"]
opaque Internal.RenderBundleEncoder.drawIndexed
    (self          : @& RenderBundleEncoder)
    (indexCount    : UInt32)
    (instanceCount : UInt32)
    (firstIndex    : UInt32)
    (baseVertex    : Int32)
    (firstInstance : UInt32) :
    IO Unit

@[inline]
def RenderBundleEncoder.drawIndexed
    (self          : RenderBundleEncoder)
    (indexCount    : UInt32)
    (instanceCount : UInt32)
    (firstIndex    : UInt32)
    (baseVertex    : Int32)
    (firstInstance : UInt32) :
    IO Unit :=
  Internal.RenderBundleEncoder.drawIndexed
      self
      indexCount
      instanceCount
      firstIndex
      baseVertex
      firstInstance

/-- The shim behind `RenderBundleEncoder.drawIndirect`. -/
@[extern "lean_wgpuRenderBundleEncoderDrawIndirect"]
opaque Internal.RenderBundleEncoder.drawIndirect
    (self           : @& RenderBundleEncoder)
    (indirectBuffer : @& Buffer)
    (indirectOffset : UInt64) :
    IO Unit

@[inline]
def RenderBundleEncoder.drawIndirect
    (self           : RenderBundleEncoder)
    (indirectBuffer : Buffer)
    (indirectOffset : UInt64) :
    IO Unit :=
  Internal.RenderBundleEncoder.drawIndirect self indirectBuffer indirectOffset

/-- The shim behind `RenderBundleEncoder.drawIndexedIndirect`. -/
@[extern "lean_wgpuRenderBundleEncoderDrawIndexedIndirect"]
opaque Internal.RenderBundleEncoder.drawIndexedIndirect
    (self           : @& RenderBundleEncoder)
    (indirectBuffer : @& Buffer)
    (indirectOffset : UInt64) :
    IO Unit

@[inline]
def RenderBundleEncoder.drawIndexedIndirect
    (self           : RenderBundleEncoder)
    (indirectBuffer : Buffer)
    (indirectOffset : UInt64) :
    IO Unit :=
  Internal.RenderBundleEncoder.drawIndexedIndirect
      self
      indirectBuffer
      indirectOffset

/-- The shim behind `RenderBundleEncoder.insertDebugMarker`. -/
@[extern "lean_wgpuRenderBundleEncoderInsertDebugMarker"]
opaque Internal.RenderBundleEncoder.insertDebugMarker
    (self        : @& RenderBundleEncoder)
    (markerLabel : @& String) :
    IO Unit

@[inline]
def RenderBundleEncoder.insertDebugMarker
    (self        : RenderBundleEncoder)
    (markerLabel : String) :
    IO Unit :=
  Internal.RenderBundleEncoder.insertDebugMarker self markerLabel

/-- The shim behind `RenderBundleEncoder.popDebugGroup`. -/
@[extern "lean_wgpuRenderBundleEncoderPopDebugGroup"]
opaque Internal.RenderBundleEncoder.popDebugGroup
    (self : @& RenderBundleEncoder) :
    IO Unit

@[inline]
def RenderBundleEncoder.popDebugGroup (self : RenderBundleEncoder) : IO Unit :=
  Internal.RenderBundleEncoder.popDebugGroup self

/-- The shim behind `RenderBundleEncoder.pushDebugGroup`. -/
@[extern "lean_wgpuRenderBundleEncoderPushDebugGroup"]
opaque Internal.RenderBundleEncoder.pushDebugGroup
    (self       : @& RenderBundleEncoder)
    (groupLabel : @& String) :
    IO Unit

@[inline]
def RenderBundleEncoder.pushDebugGroup
    (self       : RenderBundleEncoder)
    (groupLabel : String) :
    IO Unit :=
  Internal.RenderBundleEncoder.pushDebugGroup self groupLabel

/-- The shim behind `RenderBundleEncoder.setVertexBuffer`. -/
@[extern "lean_wgpuRenderBundleEncoderSetVertexBuffer"]
opaque Internal.RenderBundleEncoder.setVertexBuffer
    (self   : @& RenderBundleEncoder)
    (slot   : UInt32)
    (buffer : @& Option Buffer)
    (offset : UInt64)
    (size   : UInt64) :
    IO Unit

@[inline]
def RenderBundleEncoder.setVertexBuffer
    (self   : RenderBundleEncoder)
    (slot   : UInt32)
    (buffer : Option Buffer)
    (offset : UInt64)
    (size   : UInt64) :
    IO Unit :=
  Internal.RenderBundleEncoder.setVertexBuffer self slot buffer offset size

/-- The shim behind `RenderBundleEncoder.setIndexBuffer`. -/
@[extern "lean_wgpuRenderBundleEncoderSetIndexBuffer"]
opaque Internal.RenderBundleEncoder.setIndexBuffer
    (self   : @& RenderBundleEncoder)
    (buffer : @& Buffer)
    (format : UInt32)
    (offset : UInt64)
    (size   : UInt64) :
    IO Unit

@[inline]
def RenderBundleEncoder.setIndexBuffer
    (self   : RenderBundleEncoder)
    (buffer : Buffer)
    (format : IndexFormat)
    (offset : UInt64)
    (size   : UInt64) :
    IO Unit :=
  Internal.RenderBundleEncoder.setIndexBuffer
      self
      buffer
      (CEnum.toC format)
      offset
      size

/-- The shim behind `RenderBundleEncoder.finish`. -/
@[extern "lean_wgpuRenderBundleEncoderFinish"]
opaque Internal.RenderBundleEncoder.finish
    (self              : @& RenderBundleEncoder)
    (descriptor        : @& Option RenderBundleDescriptor)
    (descriptorBytes   : @& OptBytesOf descriptor)
    (descriptorTargets : @& OptTargetsOf descriptor)
    (descriptorTable   : @& IndexOf RenderBundleDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO RenderBundle

@[inline]
def RenderBundleEncoder.finish
    (self       : RenderBundleEncoder)
    (descriptor : Option RenderBundleDescriptor) :
    IO RenderBundle :=
  if CStruct.optSizesFit descriptor then
    Internal.RenderBundleEncoder.finish
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "RenderBundleEncoder.finish: a size_t too large")

/-- The shim behind `RenderBundleEncoder.setLabel`. -/
@[extern "lean_wgpuRenderBundleEncoderSetLabel"]
opaque Internal.RenderBundleEncoder.setLabel
    (self  : @& RenderBundleEncoder)
    (label : @& String) :
    IO Unit

@[inline]
def RenderBundleEncoder.setLabel
    (self  : RenderBundleEncoder)
    (label : String) :
    IO Unit :=
  Internal.RenderBundleEncoder.setLabel self label

/-- The shim behind `RenderPassEncoder.setPipeline`. -/
@[extern "lean_wgpuRenderPassEncoderSetPipeline"]
opaque Internal.RenderPassEncoder.setPipeline
    (self     : @& RenderPassEncoder)
    (pipeline : @& RenderPipeline) :
    IO Unit

@[inline]
def RenderPassEncoder.setPipeline
    (self     : RenderPassEncoder)
    (pipeline : RenderPipeline) :
    IO Unit :=
  Internal.RenderPassEncoder.setPipeline self pipeline

/-- The shim behind `RenderPassEncoder.draw`. -/
@[extern "lean_wgpuRenderPassEncoderDraw"]
opaque Internal.RenderPassEncoder.draw
    (self          : @& RenderPassEncoder)
    (vertexCount   : UInt32)
    (instanceCount : UInt32)
    (firstVertex   : UInt32)
    (firstInstance : UInt32) :
    IO Unit

@[inline]
def RenderPassEncoder.draw
    (self          : RenderPassEncoder)
    (vertexCount   : UInt32)
    (instanceCount : UInt32)
    (firstVertex   : UInt32)
    (firstInstance : UInt32) :
    IO Unit :=
  Internal.RenderPassEncoder.draw
      self
      vertexCount
      instanceCount
      firstVertex
      firstInstance

/-- The shim behind `RenderPassEncoder.drawIndexed`. -/
@[extern "lean_wgpuRenderPassEncoderDrawIndexed"]
opaque Internal.RenderPassEncoder.drawIndexed
    (self          : @& RenderPassEncoder)
    (indexCount    : UInt32)
    (instanceCount : UInt32)
    (firstIndex    : UInt32)
    (baseVertex    : Int32)
    (firstInstance : UInt32) :
    IO Unit

@[inline]
def RenderPassEncoder.drawIndexed
    (self          : RenderPassEncoder)
    (indexCount    : UInt32)
    (instanceCount : UInt32)
    (firstIndex    : UInt32)
    (baseVertex    : Int32)
    (firstInstance : UInt32) :
    IO Unit :=
  Internal.RenderPassEncoder.drawIndexed
      self
      indexCount
      instanceCount
      firstIndex
      baseVertex
      firstInstance

/-- The shim behind `RenderPassEncoder.drawIndirect`. -/
@[extern "lean_wgpuRenderPassEncoderDrawIndirect"]
opaque Internal.RenderPassEncoder.drawIndirect
    (self           : @& RenderPassEncoder)
    (indirectBuffer : @& Buffer)
    (indirectOffset : UInt64) :
    IO Unit

@[inline]
def RenderPassEncoder.drawIndirect
    (self           : RenderPassEncoder)
    (indirectBuffer : Buffer)
    (indirectOffset : UInt64) :
    IO Unit :=
  Internal.RenderPassEncoder.drawIndirect self indirectBuffer indirectOffset

/-- The shim behind `RenderPassEncoder.drawIndexedIndirect`. -/
@[extern "lean_wgpuRenderPassEncoderDrawIndexedIndirect"]
opaque Internal.RenderPassEncoder.drawIndexedIndirect
    (self           : @& RenderPassEncoder)
    (indirectBuffer : @& Buffer)
    (indirectOffset : UInt64) :
    IO Unit

@[inline]
def RenderPassEncoder.drawIndexedIndirect
    (self           : RenderPassEncoder)
    (indirectBuffer : Buffer)
    (indirectOffset : UInt64) :
    IO Unit :=
  Internal.RenderPassEncoder.drawIndexedIndirect
      self
      indirectBuffer
      indirectOffset

/-- The shim behind `RenderPassEncoder.insertDebugMarker`. -/
@[extern "lean_wgpuRenderPassEncoderInsertDebugMarker"]
opaque Internal.RenderPassEncoder.insertDebugMarker
    (self        : @& RenderPassEncoder)
    (markerLabel : @& String) :
    IO Unit

@[inline]
def RenderPassEncoder.insertDebugMarker
    (self        : RenderPassEncoder)
    (markerLabel : String) :
    IO Unit :=
  Internal.RenderPassEncoder.insertDebugMarker self markerLabel

/-- The shim behind `RenderPassEncoder.popDebugGroup`. -/
@[extern "lean_wgpuRenderPassEncoderPopDebugGroup"]
opaque Internal.RenderPassEncoder.popDebugGroup
    (self : @& RenderPassEncoder) :
    IO Unit

@[inline]
def RenderPassEncoder.popDebugGroup (self : RenderPassEncoder) : IO Unit :=
  Internal.RenderPassEncoder.popDebugGroup self

/-- The shim behind `RenderPassEncoder.pushDebugGroup`. -/
@[extern "lean_wgpuRenderPassEncoderPushDebugGroup"]
opaque Internal.RenderPassEncoder.pushDebugGroup
    (self       : @& RenderPassEncoder)
    (groupLabel : @& String) :
    IO Unit

@[inline]
def RenderPassEncoder.pushDebugGroup
    (self       : RenderPassEncoder)
    (groupLabel : String) :
    IO Unit :=
  Internal.RenderPassEncoder.pushDebugGroup self groupLabel

/-- The shim behind `RenderPassEncoder.setStencilReference`. -/
@[extern "lean_wgpuRenderPassEncoderSetStencilReference"]
opaque Internal.RenderPassEncoder.setStencilReference
    (self      : @& RenderPassEncoder)
    (reference : UInt32) :
    IO Unit

@[inline]
def RenderPassEncoder.setStencilReference
    (self      : RenderPassEncoder)
    (reference : UInt32) :
    IO Unit :=
  Internal.RenderPassEncoder.setStencilReference self reference

/-- The shim behind `RenderPassEncoder.setBlendConstant`. -/
@[extern "lean_wgpuRenderPassEncoderSetBlendConstant"]
opaque Internal.RenderPassEncoder.setBlendConstant
    (self         : @& RenderPassEncoder)
    (color        : @& Color)
    (colorBytes   : @& BytesOf color)
    (colorTargets : @& TargetsOf color)
    (colorTable   : @& IndexOf Color)
    (tables       : @& CurrentTablesOf) :
    IO Unit

@[inline]
def RenderPassEncoder.setBlendConstant
    (self  : RenderPassEncoder)
    (color : Color) :
    IO Unit :=
  if CStruct.sizesFit color then
    Internal.RenderPassEncoder.setBlendConstant
        self
        color
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError
      "RenderPassEncoder.setBlendConstant: a size_t too large")

/-- The shim behind `RenderPassEncoder.setViewport`. -/
@[extern "lean_wgpuRenderPassEncoderSetViewport"]
opaque Internal.RenderPassEncoder.setViewport
    (self     : @& RenderPassEncoder)
    (x        : Float32)
    (y        : Float32)
    (width    : Float32)
    (height   : Float32)
    (minDepth : Float32)
    (maxDepth : Float32) :
    IO Unit

/--
If any argument is non-finite, produces a [NonFiniteFloatValueError].

[NonFiniteFloatValueError]: https://webgpu-native.github.io/webgpu-headers/FloatingPointNumbers.html#NonFiniteFloatValueError
-/
@[inline]
def RenderPassEncoder.setViewport
    (self     : RenderPassEncoder)
    (x        : Float32)
    (y        : Float32)
    (width    : Float32)
    (height   : Float32)
    (minDepth : Float32)
    (maxDepth : Float32) :
    IO Unit :=
  Internal.RenderPassEncoder.setViewport self x y width height minDepth maxDepth

/-- The shim behind `RenderPassEncoder.setScissorRect`. -/
@[extern "lean_wgpuRenderPassEncoderSetScissorRect"]
opaque Internal.RenderPassEncoder.setScissorRect
    (self   : @& RenderPassEncoder)
    (x      : UInt32)
    (y      : UInt32)
    (width  : UInt32)
    (height : UInt32) :
    IO Unit

@[inline]
def RenderPassEncoder.setScissorRect
    (self   : RenderPassEncoder)
    (x      : UInt32)
    (y      : UInt32)
    (width  : UInt32)
    (height : UInt32) :
    IO Unit :=
  Internal.RenderPassEncoder.setScissorRect self x y width height

/-- The shim behind `RenderPassEncoder.setVertexBuffer`. -/
@[extern "lean_wgpuRenderPassEncoderSetVertexBuffer"]
opaque Internal.RenderPassEncoder.setVertexBuffer
    (self   : @& RenderPassEncoder)
    (slot   : UInt32)
    (buffer : @& Option Buffer)
    (offset : UInt64)
    (size   : UInt64) :
    IO Unit

@[inline]
def RenderPassEncoder.setVertexBuffer
    (self   : RenderPassEncoder)
    (slot   : UInt32)
    (buffer : Option Buffer)
    (offset : UInt64)
    (size   : UInt64) :
    IO Unit :=
  Internal.RenderPassEncoder.setVertexBuffer self slot buffer offset size

/-- The shim behind `RenderPassEncoder.setIndexBuffer`. -/
@[extern "lean_wgpuRenderPassEncoderSetIndexBuffer"]
opaque Internal.RenderPassEncoder.setIndexBuffer
    (self   : @& RenderPassEncoder)
    (buffer : @& Buffer)
    (format : UInt32)
    (offset : UInt64)
    (size   : UInt64) :
    IO Unit

@[inline]
def RenderPassEncoder.setIndexBuffer
    (self   : RenderPassEncoder)
    (buffer : Buffer)
    (format : IndexFormat)
    (offset : UInt64)
    (size   : UInt64) :
    IO Unit :=
  Internal.RenderPassEncoder.setIndexBuffer
      self
      buffer
      (CEnum.toC format)
      offset
      size

/-- The shim behind `RenderPassEncoder.beginOcclusionQuery`. -/
@[extern "lean_wgpuRenderPassEncoderBeginOcclusionQuery"]
opaque Internal.RenderPassEncoder.beginOcclusionQuery
    (self       : @& RenderPassEncoder)
    (queryIndex : UInt32) :
    IO Unit

@[inline]
def RenderPassEncoder.beginOcclusionQuery
    (self       : RenderPassEncoder)
    (queryIndex : UInt32) :
    IO Unit :=
  Internal.RenderPassEncoder.beginOcclusionQuery self queryIndex

/-- The shim behind `RenderPassEncoder.endOcclusionQuery`. -/
@[extern "lean_wgpuRenderPassEncoderEndOcclusionQuery"]
opaque Internal.RenderPassEncoder.endOcclusionQuery
    (self : @& RenderPassEncoder) :
    IO Unit

@[inline]
def RenderPassEncoder.endOcclusionQuery (self : RenderPassEncoder) : IO Unit :=
  Internal.RenderPassEncoder.endOcclusionQuery self

/-- The shim behind `RenderPassEncoder.«end»`. -/
@[extern "lean_wgpuRenderPassEncoderEnd"]
opaque Internal.RenderPassEncoder.«end» (self : @& RenderPassEncoder) : IO Unit

@[inline]
def RenderPassEncoder.«end» (self : RenderPassEncoder) : IO Unit :=
  Internal.RenderPassEncoder.«end» self

/-- The shim behind `RenderPassEncoder.setLabel`. -/
@[extern "lean_wgpuRenderPassEncoderSetLabel"]
opaque Internal.RenderPassEncoder.setLabel
    (self  : @& RenderPassEncoder)
    (label : @& String) :
    IO Unit

@[inline]
def RenderPassEncoder.setLabel
    (self  : RenderPassEncoder)
    (label : String) :
    IO Unit :=
  Internal.RenderPassEncoder.setLabel self label

/-- The shim behind `RenderPipeline.getBindGroupLayout`. -/
@[extern "lean_wgpuRenderPipelineGetBindGroupLayout"]
opaque Internal.RenderPipeline.getBindGroupLayout
    (self       : @& RenderPipeline)
    (groupIndex : UInt32) :
    IO BindGroupLayout

@[inline]
def RenderPipeline.getBindGroupLayout
    (self       : RenderPipeline)
    (groupIndex : UInt32) :
    IO BindGroupLayout :=
  Internal.RenderPipeline.getBindGroupLayout self groupIndex

/-- The shim behind `RenderPipeline.setLabel`. -/
@[extern "lean_wgpuRenderPipelineSetLabel"]
opaque Internal.RenderPipeline.setLabel
    (self  : @& RenderPipeline)
    (label : @& String) :
    IO Unit

@[inline]
def RenderPipeline.setLabel
    (self  : RenderPipeline)
    (label : String) :
    IO Unit :=
  Internal.RenderPipeline.setLabel self label

/-- The shim behind `Sampler.setLabel`. -/
@[extern "lean_wgpuSamplerSetLabel"]
opaque Internal.Sampler.setLabel
    (self  : @& Sampler)
    (label : @& String) :
    IO Unit

@[inline]
def Sampler.setLabel (self : Sampler) (label : String) : IO Unit :=
  Internal.Sampler.setLabel self label

/-- The shim behind `ShaderModule.setLabel`. -/
@[extern "lean_wgpuShaderModuleSetLabel"]
opaque Internal.ShaderModule.setLabel
    (self  : @& ShaderModule)
    (label : @& String) :
    IO Unit

@[inline]
def ShaderModule.setLabel (self : ShaderModule) (label : String) : IO Unit :=
  Internal.ShaderModule.setLabel self label

/-- The shim behind `Surface.configure`. -/
@[extern "lean_wgpuSurfaceConfigure"]
opaque Internal.Surface.configure
    (self          : @& Surface)
    (config        : @& SurfaceConfiguration)
    (configBytes   : @& BytesOf config)
    (configTargets : @& TargetsOf config)
    (configTable   : @& IndexOf SurfaceConfiguration)
    (tables        : @& CurrentTablesOf) :
    IO Unit

/--
Configures parameters for rendering to `surface`. Produces a [DeviceError] for
all content-timeline errors defined by the WebGPU specification.

See [Surface-Configuration] for more details.

[DeviceError]: https://webgpu-native.github.io/webgpu-headers/Errors.html#DeviceError
[Surface-Configuration]: https://webgpu-native.github.io/webgpu-headers/Surfaces.html#Surface-Configuration
-/
@[inline]
def Surface.configure
    (self   : Surface)
    (config : SurfaceConfiguration) :
    IO Unit :=
  if CStruct.sizesFit config then
    Internal.Surface.configure self config ⟨_, rfl⟩ ⟨_, rfl⟩ ⟨_, rfl⟩ ⟨_, rfl⟩
  else
    throw (IO.userError "Surface.configure: a size_t too large")

/-- The shim behind `Surface.present`. -/
@[extern "lean_wgpuSurfacePresent"]
opaque Internal.Surface.present (self : @& Surface) : IO UInt32

/--
Shows `surface`'s current texture to the user. See [Surface-Presenting] for more
details.

[Surface-Presenting]: https://webgpu-native.github.io/webgpu-headers/Surfaces.html#Surface-Presenting
-/
@[inline]
def Surface.present (self : Surface) : IO (Except UInt32 Status) :=
  CEnum.decode <$> Internal.Surface.present self

/-- The shim behind `Surface.unconfigure`. -/
@[extern "lean_wgpuSurfaceUnconfigure"]
opaque Internal.Surface.unconfigure (self : @& Surface) : IO Unit

/--
Removes the configuration for `surface`. See [Surface-Configuration] for more
details.

[Surface-Configuration]: https://webgpu-native.github.io/webgpu-headers/Surfaces.html#Surface-Configuration
-/
@[inline]
def Surface.unconfigure (self : Surface) : IO Unit :=
  Internal.Surface.unconfigure self

/-- The shim behind `Surface.setLabel`. -/
@[extern "lean_wgpuSurfaceSetLabel"]
opaque Internal.Surface.setLabel
    (self  : @& Surface)
    (label : @& String) :
    IO Unit

/-- Modifies the label used to refer to `surface`. -/
@[inline]
def Surface.setLabel (self : Surface) (label : String) : IO Unit :=
  Internal.Surface.setLabel self label

/-- The shim behind `Texture.createView`. -/
@[extern "lean_wgpuTextureCreateView"]
opaque Internal.Texture.createView
    (self              : @& Texture)
    (descriptor        : @& Option TextureViewDescriptor)
    (descriptorBytes   : @& OptBytesOf descriptor)
    (descriptorTargets : @& OptTargetsOf descriptor)
    (descriptorTable   : @& IndexOf TextureViewDescriptor)
    (tables            : @& CurrentTablesOf) :
    IO TextureView

@[inline]
def Texture.createView
    (self       : Texture)
    (descriptor : Option TextureViewDescriptor) :
    IO TextureView :=
  if CStruct.optSizesFit descriptor then
    Internal.Texture.createView
        self
        descriptor
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
        ⟨_, rfl⟩
  else
    throw (IO.userError "Texture.createView: a size_t too large")

/-- The shim behind `Texture.setLabel`. -/
@[extern "lean_wgpuTextureSetLabel"]
opaque Internal.Texture.setLabel
    (self  : @& Texture)
    (label : @& String) :
    IO Unit

@[inline]
def Texture.setLabel (self : Texture) (label : String) : IO Unit :=
  Internal.Texture.setLabel self label

/-- The shim behind `Texture.getWidth`. -/
@[extern "lean_wgpuTextureGetWidth"]
opaque Internal.Texture.getWidth (self : @& Texture) : IO UInt32

@[inline]
def Texture.getWidth (self : Texture) : IO UInt32 :=
  Internal.Texture.getWidth self

/-- The shim behind `Texture.getHeight`. -/
@[extern "lean_wgpuTextureGetHeight"]
opaque Internal.Texture.getHeight (self : @& Texture) : IO UInt32

@[inline]
def Texture.getHeight (self : Texture) : IO UInt32 :=
  Internal.Texture.getHeight self

/-- The shim behind `Texture.getDepthOrArrayLayers`. -/
@[extern "lean_wgpuTextureGetDepthOrArrayLayers"]
opaque Internal.Texture.getDepthOrArrayLayers (self : @& Texture) : IO UInt32

@[inline]
def Texture.getDepthOrArrayLayers (self : Texture) : IO UInt32 :=
  Internal.Texture.getDepthOrArrayLayers self

/-- The shim behind `Texture.getMipLevelCount`. -/
@[extern "lean_wgpuTextureGetMipLevelCount"]
opaque Internal.Texture.getMipLevelCount (self : @& Texture) : IO UInt32

@[inline]
def Texture.getMipLevelCount (self : Texture) : IO UInt32 :=
  Internal.Texture.getMipLevelCount self

/-- The shim behind `Texture.getSampleCount`. -/
@[extern "lean_wgpuTextureGetSampleCount"]
opaque Internal.Texture.getSampleCount (self : @& Texture) : IO UInt32

@[inline]
def Texture.getSampleCount (self : Texture) : IO UInt32 :=
  Internal.Texture.getSampleCount self

/-- The shim behind `Texture.getDimension`. -/
@[extern "lean_wgpuTextureGetDimension"]
opaque Internal.Texture.getDimension (self : @& Texture) : IO UInt32

@[inline]
def Texture.getDimension
    (self : Texture) :
    IO (Except UInt32 TextureDimension) :=
  CEnum.decode <$> Internal.Texture.getDimension self

/-- The shim behind `Texture.getTextureBindingViewDimension`. -/
@[extern "lean_wgpuTextureGetTextureBindingViewDimension"]
opaque Internal.Texture.getTextureBindingViewDimension
    (self : @& Texture) :
    IO UInt32

@[inline]
def Texture.getTextureBindingViewDimension
    (self : Texture) :
    IO (Except UInt32 TextureViewDimension) :=
  CEnum.decode <$> Internal.Texture.getTextureBindingViewDimension self

/-- The shim behind `Texture.getFormat`. -/
@[extern "lean_wgpuTextureGetFormat"]
opaque Internal.Texture.getFormat (self : @& Texture) : IO UInt32

@[inline]
def Texture.getFormat (self : Texture) : IO (Except UInt32 TextureFormat) :=
  CEnum.decode <$> Internal.Texture.getFormat self

/-- The shim behind `Texture.getUsage`. -/
@[extern "lean_wgpuTextureGetUsage"]
opaque Internal.Texture.getUsage (self : @& Texture) : IO UInt64

@[inline]
def Texture.getUsage (self : Texture) : IO TextureUsage :=
  TextureUsage.mk <$> Internal.Texture.getUsage self

/-- The shim behind `Texture.destroy`. -/
@[extern "lean_wgpuTextureDestroy"]
opaque Internal.Texture.destroy (self : @& Texture) : IO Unit

@[inline]
def Texture.destroy (self : Texture) : IO Unit :=
  Internal.Texture.destroy self

/-- The shim behind `TextureView.setLabel`. -/
@[extern "lean_wgpuTextureViewSetLabel"]
opaque Internal.TextureView.setLabel
    (self  : @& TextureView)
    (label : @& String) :
    IO Unit

@[inline]
def TextureView.setLabel (self : TextureView) (label : String) : IO Unit :=
  Internal.TextureView.setLabel self label

end WebGPU.Raw

end
