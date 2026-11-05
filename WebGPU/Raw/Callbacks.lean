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
public import WebGPU.Raw.Enums
public import WebGPU.Raw.Objects
public import WebGPU.Raw.Internal.Reloc

/-!
# Callbacks

The callback types of `webgpu.h` the bindings can pass so far: each the
type of a Lean closure C runs as a callback, given each argument as C
passes it, and the type of the closure the raw declarations take. Those a
struct keeps, as a device descriptor keeps its device-lost callback, have
an info structure too: the closure, and the mode it is registered with.
-/

@[expose] public section

namespace WebGPU.Raw

open Reloc

/-- A closure C runs once, as a callback, given `status` and `message`. -/
abbrev BufferMapCallback :=
  Except UInt32 MapAsyncStatus → String → IO Unit

/-- A `BufferMapCallback`, as its raw declaration takes it. -/
abbrev Internal.BufferMapCallback :=
  UInt32 → String → IO Unit

/-- `f`, as its raw declaration takes it: each enum decoded. -/
@[inline]
def Internal.BufferMapCallback.raw
    (f : WebGPU.Raw.BufferMapCallback) :
    Internal.BufferMapCallback :=
  fun status message => f (CEnum.decode status) message

/--
A closure C runs once, as a callback, given `status`, `pipeline` and `message`.
-/
abbrev CreateComputePipelineAsyncCallback :=
  Except UInt32 CreatePipelineAsyncStatus →
    Option ComputePipeline →
    String →
    IO Unit

/-- A `CreateComputePipelineAsyncCallback`, as its raw declaration takes it. -/
abbrev Internal.CreateComputePipelineAsyncCallback :=
  UInt32 → Option ComputePipeline → String → IO Unit

/-- `f`, as its raw declaration takes it: each enum decoded. -/
@[inline]
def Internal.CreateComputePipelineAsyncCallback.raw
    (f : WebGPU.Raw.CreateComputePipelineAsyncCallback) :
    Internal.CreateComputePipelineAsyncCallback :=
  fun status pipeline message => f (CEnum.decode status) pipeline message

/--
A closure C runs once, as a callback, given `status`, `pipeline` and `message`.
-/
abbrev CreateRenderPipelineAsyncCallback :=
  Except UInt32 CreatePipelineAsyncStatus →
    Option RenderPipeline →
    String →
    IO Unit

/-- A `CreateRenderPipelineAsyncCallback`, as its raw declaration takes it. -/
abbrev Internal.CreateRenderPipelineAsyncCallback :=
  UInt32 → Option RenderPipeline → String → IO Unit

/-- `f`, as its raw declaration takes it: each enum decoded. -/
@[inline]
def Internal.CreateRenderPipelineAsyncCallback.raw
    (f : WebGPU.Raw.CreateRenderPipelineAsyncCallback) :
    Internal.CreateRenderPipelineAsyncCallback :=
  fun status pipeline message => f (CEnum.decode status) pipeline message

/--
A closure C runs once, as a callback, given `status`, `type` and `message`.
-/
abbrev PopErrorScopeCallback :=
  Except UInt32 PopErrorScopeStatus → Except UInt32 ErrorType → String → IO Unit

/-- A `PopErrorScopeCallback`, as its raw declaration takes it. -/
abbrev Internal.PopErrorScopeCallback :=
  UInt32 → UInt32 → String → IO Unit

/-- `f`, as its raw declaration takes it: each enum decoded. -/
@[inline]
def Internal.PopErrorScopeCallback.raw
    (f : WebGPU.Raw.PopErrorScopeCallback) :
    Internal.PopErrorScopeCallback :=
  fun status type message => f (CEnum.decode status) (CEnum.decode type) message

/--
A closure C runs once, as a callback, given `status`, `adapter` and `message`.
-/
abbrev RequestAdapterCallback :=
  Except UInt32 RequestAdapterStatus → Option Adapter → String → IO Unit

/-- A `RequestAdapterCallback`, as its raw declaration takes it. -/
abbrev Internal.RequestAdapterCallback :=
  UInt32 → Option Adapter → String → IO Unit

/-- `f`, as its raw declaration takes it: each enum decoded. -/
@[inline]
def Internal.RequestAdapterCallback.raw
    (f : WebGPU.Raw.RequestAdapterCallback) :
    Internal.RequestAdapterCallback :=
  fun status adapter message => f (CEnum.decode status) adapter message

/-- A closure C runs once, as a callback, given `status` and `message`. -/
abbrev QueueWorkDoneCallback :=
  Except UInt32 QueueWorkDoneStatus → String → IO Unit

/-- A `QueueWorkDoneCallback`, as its raw declaration takes it. -/
abbrev Internal.QueueWorkDoneCallback :=
  UInt32 → String → IO Unit

/-- `f`, as its raw declaration takes it: each enum decoded. -/
@[inline]
def Internal.QueueWorkDoneCallback.raw
    (f : WebGPU.Raw.QueueWorkDoneCallback) :
    Internal.QueueWorkDoneCallback :=
  fun status message => f (CEnum.decode status) message

end WebGPU.Raw

end
