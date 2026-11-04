/*
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
*/

#include <stdint.h>
#include "objects.h"
#include "reloc.h"

// A view of the bytes of the Lean string `s`, which stays alive while the
// string is borrowed. Its length leaves out the terminating NUL.
static inline WGPUStringView lean_wgpu_string_view(b_lean_obj_arg s) {
    WGPUStringView view = {
        .data   = lean_string_cstr(s),
        .length = lean_string_size(s) - 1,
    };
    return view;
}

// An `IO` error saying `message`, for a check a shim makes, or a function an
// implementation does not implement.
static inline lean_obj_res lean_wgpu_io_error(char const * message) {
    return lean_io_result_mk_error(
        lean_mk_io_user_error(lean_mk_string(message))
    );
}

// Lean's `createInstance`: calls `wgpuCreateInstance`.
LEAN_EXPORT lean_obj_res lean_wgpuCreateInstance(
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUInstance result = wgpuCreateInstance(descriptor_struct);
    if (result == NULL) {
        return lean_wgpu_io_error("createInstance returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_instance_box(result));
}

// Lean's `hasInstanceFeature`: calls `wgpuHasInstanceFeature`.
LEAN_EXPORT lean_obj_res lean_wgpuHasInstanceFeature(uint32_t feature) {
    #ifdef WEBGPU_RAW_DAWN
    WGPUBool result = wgpuHasInstanceFeature((WGPUInstanceFeatureName)feature);
    return lean_io_result_mk_ok(lean_box(result != 0));
    #else
    (void)feature;
    return lean_wgpu_io_error(
        "hasInstanceFeature: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Adapter.hasFeature`: calls `wgpuAdapterHasFeature`.
LEAN_EXPORT lean_obj_res lean_wgpuAdapterHasFeature(
    b_lean_obj_arg self,
    uint32_t       feature
) {
    WGPUBool result = wgpuAdapterHasFeature(
        lean_wgpu_adapter_unbox(self),
        (WGPUFeatureName)feature
    );
    return lean_io_result_mk_ok(lean_box(result != 0));
}

// Lean's `BindGroup.setLabel`: calls `wgpuBindGroupSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuBindGroupSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuBindGroupSetLabel(
        lean_wgpu_bind_group_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "BindGroup.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `BindGroupLayout.setLabel`: calls `wgpuBindGroupLayoutSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuBindGroupLayoutSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuBindGroupLayoutSetLabel(
        lean_wgpu_bind_group_layout_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "BindGroupLayout.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Buffer.setLabel`: calls `wgpuBufferSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuBufferSetLabel(
        lean_wgpu_buffer_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "Buffer.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Buffer.getUsage`: calls `wgpuBufferGetUsage`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferGetUsage(b_lean_obj_arg self) {
    WGPUBufferUsage result = wgpuBufferGetUsage(lean_wgpu_buffer_unbox(self));
    return lean_io_result_mk_ok(lean_box_uint64((uint64_t)result));
}

// Lean's `Buffer.getSize`: calls `wgpuBufferGetSize`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferGetSize(b_lean_obj_arg self) {
    uint64_t result = wgpuBufferGetSize(lean_wgpu_buffer_unbox(self));
    return lean_io_result_mk_ok(lean_box_uint64(result));
}

// Lean's `Buffer.getMapState`: calls `wgpuBufferGetMapState`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferGetMapState(b_lean_obj_arg self) {
    #ifdef WEBGPU_RAW_DAWN
    WGPUBufferMapState result = wgpuBufferGetMapState(
        lean_wgpu_buffer_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box_uint32((uint32_t)result));
    #else
    (void)self;
    return lean_wgpu_io_error(
        "Buffer.getMapState: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Buffer.unmap`: calls `wgpuBufferUnmap`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferUnmap(b_lean_obj_arg self) {
    wgpuBufferUnmap(lean_wgpu_buffer_unbox(self));
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `Buffer.destroy`: calls `wgpuBufferDestroy`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferDestroy(b_lean_obj_arg self) {
    wgpuBufferDestroy(lean_wgpu_buffer_unbox(self));
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandBuffer.setLabel`: calls `wgpuCommandBufferSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandBufferSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuCommandBufferSetLabel(
        lean_wgpu_command_buffer_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "CommandBuffer.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `CommandEncoder.finish`: calls `wgpuCommandEncoderFinish`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderFinish(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUCommandBuffer result = wgpuCommandEncoderFinish(
        lean_wgpu_command_encoder_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("CommandEncoder.finish returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_command_buffer_box(result));
}

// Lean's `CommandEncoder.beginComputePass`: calls
// `wgpuCommandEncoderBeginComputePass`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderBeginComputePass(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUComputePassEncoder result = wgpuCommandEncoderBeginComputePass(
        lean_wgpu_command_encoder_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error(
            "CommandEncoder.beginComputePass returned NULL"
        );
    }
    return lean_io_result_mk_ok(lean_wgpu_compute_pass_encoder_box(result));
}

// Lean's `CommandEncoder.beginRenderPass`: calls
// `wgpuCommandEncoderBeginRenderPass`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderBeginRenderPass(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPURenderPassEncoder result = wgpuCommandEncoderBeginRenderPass(
        lean_wgpu_command_encoder_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error(
            "CommandEncoder.beginRenderPass returned NULL"
        );
    }
    return lean_io_result_mk_ok(lean_wgpu_render_pass_encoder_box(result));
}

// Lean's `CommandEncoder.copyBufferToBuffer`: calls
// `wgpuCommandEncoderCopyBufferToBuffer`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderCopyBufferToBuffer(
    b_lean_obj_arg self,
    b_lean_obj_arg source,
    uint64_t       sourceOffset,
    b_lean_obj_arg destination,
    uint64_t       destinationOffset,
    uint64_t       size
) {
    wgpuCommandEncoderCopyBufferToBuffer(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_buffer_unbox(source),
        sourceOffset,
        lean_wgpu_buffer_unbox(destination),
        destinationOffset,
        size
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandEncoder.copyBufferToTexture`: calls
// `wgpuCommandEncoderCopyBufferToTexture`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderCopyBufferToTexture(
    b_lean_obj_arg self,
    b_lean_obj_arg source,
    b_lean_obj_arg source_bytes,
    b_lean_obj_arg source_targets,
    b_lean_obj_arg source_table,
    b_lean_obj_arg destination,
    b_lean_obj_arg destination_bytes,
    b_lean_obj_arg destination_targets,
    b_lean_obj_arg destination_table,
    b_lean_obj_arg copySize,
    b_lean_obj_arg copySize_bytes,
    b_lean_obj_arg copySize_targets,
    b_lean_obj_arg copySize_table,
    b_lean_obj_arg tables
) {
    (void)source;
    void const * source_struct = lean_wgpu_fill_arg(
        source_bytes,
        tables,
        lean_usize_of_nat(source_table),
        source_targets
    );
    (void)destination;
    void const * destination_struct = lean_wgpu_fill_arg(
        destination_bytes,
        tables,
        lean_usize_of_nat(destination_table),
        destination_targets
    );
    (void)copySize;
    void const * copySize_struct = lean_wgpu_fill_arg(
        copySize_bytes,
        tables,
        lean_usize_of_nat(copySize_table),
        copySize_targets
    );
    wgpuCommandEncoderCopyBufferToTexture(
        lean_wgpu_command_encoder_unbox(self),
        source_struct,
        destination_struct,
        copySize_struct
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandEncoder.copyTextureToBuffer`: calls
// `wgpuCommandEncoderCopyTextureToBuffer`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderCopyTextureToBuffer(
    b_lean_obj_arg self,
    b_lean_obj_arg source,
    b_lean_obj_arg source_bytes,
    b_lean_obj_arg source_targets,
    b_lean_obj_arg source_table,
    b_lean_obj_arg destination,
    b_lean_obj_arg destination_bytes,
    b_lean_obj_arg destination_targets,
    b_lean_obj_arg destination_table,
    b_lean_obj_arg copySize,
    b_lean_obj_arg copySize_bytes,
    b_lean_obj_arg copySize_targets,
    b_lean_obj_arg copySize_table,
    b_lean_obj_arg tables
) {
    (void)source;
    void const * source_struct = lean_wgpu_fill_arg(
        source_bytes,
        tables,
        lean_usize_of_nat(source_table),
        source_targets
    );
    (void)destination;
    void const * destination_struct = lean_wgpu_fill_arg(
        destination_bytes,
        tables,
        lean_usize_of_nat(destination_table),
        destination_targets
    );
    (void)copySize;
    void const * copySize_struct = lean_wgpu_fill_arg(
        copySize_bytes,
        tables,
        lean_usize_of_nat(copySize_table),
        copySize_targets
    );
    wgpuCommandEncoderCopyTextureToBuffer(
        lean_wgpu_command_encoder_unbox(self),
        source_struct,
        destination_struct,
        copySize_struct
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandEncoder.copyTextureToTexture`: calls
// `wgpuCommandEncoderCopyTextureToTexture`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderCopyTextureToTexture(
    b_lean_obj_arg self,
    b_lean_obj_arg source,
    b_lean_obj_arg source_bytes,
    b_lean_obj_arg source_targets,
    b_lean_obj_arg source_table,
    b_lean_obj_arg destination,
    b_lean_obj_arg destination_bytes,
    b_lean_obj_arg destination_targets,
    b_lean_obj_arg destination_table,
    b_lean_obj_arg copySize,
    b_lean_obj_arg copySize_bytes,
    b_lean_obj_arg copySize_targets,
    b_lean_obj_arg copySize_table,
    b_lean_obj_arg tables
) {
    (void)source;
    void const * source_struct = lean_wgpu_fill_arg(
        source_bytes,
        tables,
        lean_usize_of_nat(source_table),
        source_targets
    );
    (void)destination;
    void const * destination_struct = lean_wgpu_fill_arg(
        destination_bytes,
        tables,
        lean_usize_of_nat(destination_table),
        destination_targets
    );
    (void)copySize;
    void const * copySize_struct = lean_wgpu_fill_arg(
        copySize_bytes,
        tables,
        lean_usize_of_nat(copySize_table),
        copySize_targets
    );
    wgpuCommandEncoderCopyTextureToTexture(
        lean_wgpu_command_encoder_unbox(self),
        source_struct,
        destination_struct,
        copySize_struct
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandEncoder.clearBuffer`: calls `wgpuCommandEncoderClearBuffer`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderClearBuffer(
    b_lean_obj_arg self,
    b_lean_obj_arg buffer,
    uint64_t       offset,
    uint64_t       size
) {
    wgpuCommandEncoderClearBuffer(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_buffer_unbox(buffer),
        offset,
        size
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandEncoder.insertDebugMarker`: calls
// `wgpuCommandEncoderInsertDebugMarker`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderInsertDebugMarker(
    b_lean_obj_arg self,
    b_lean_obj_arg markerLabel
) {
    wgpuCommandEncoderInsertDebugMarker(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_string_view(markerLabel)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandEncoder.popDebugGroup`: calls
// `wgpuCommandEncoderPopDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderPopDebugGroup(
    b_lean_obj_arg self
) {
    wgpuCommandEncoderPopDebugGroup(lean_wgpu_command_encoder_unbox(self));
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandEncoder.pushDebugGroup`: calls
// `wgpuCommandEncoderPushDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderPushDebugGroup(
    b_lean_obj_arg self,
    b_lean_obj_arg groupLabel
) {
    wgpuCommandEncoderPushDebugGroup(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_string_view(groupLabel)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandEncoder.resolveQuerySet`: calls
// `wgpuCommandEncoderResolveQuerySet`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderResolveQuerySet(
    b_lean_obj_arg self,
    b_lean_obj_arg querySet,
    uint32_t       firstQuery,
    uint32_t       queryCount,
    b_lean_obj_arg destination,
    uint64_t       destinationOffset
) {
    wgpuCommandEncoderResolveQuerySet(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_query_set_unbox(querySet),
        firstQuery,
        queryCount,
        lean_wgpu_buffer_unbox(destination),
        destinationOffset
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandEncoder.writeTimestamp`: calls
// `wgpuCommandEncoderWriteTimestamp`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderWriteTimestamp(
    b_lean_obj_arg self,
    b_lean_obj_arg querySet,
    uint32_t       queryIndex
) {
    wgpuCommandEncoderWriteTimestamp(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_query_set_unbox(querySet),
        queryIndex
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `CommandEncoder.setLabel`: calls `wgpuCommandEncoderSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuCommandEncoderSetLabel(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "CommandEncoder.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `ComputePassEncoder.insertDebugMarker`: calls
// `wgpuComputePassEncoderInsertDebugMarker`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderInsertDebugMarker(
    b_lean_obj_arg self,
    b_lean_obj_arg markerLabel
) {
    wgpuComputePassEncoderInsertDebugMarker(
        lean_wgpu_compute_pass_encoder_unbox(self),
        lean_wgpu_string_view(markerLabel)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `ComputePassEncoder.popDebugGroup`: calls
// `wgpuComputePassEncoderPopDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderPopDebugGroup(
    b_lean_obj_arg self
) {
    wgpuComputePassEncoderPopDebugGroup(
        lean_wgpu_compute_pass_encoder_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `ComputePassEncoder.pushDebugGroup`: calls
// `wgpuComputePassEncoderPushDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderPushDebugGroup(
    b_lean_obj_arg self,
    b_lean_obj_arg groupLabel
) {
    wgpuComputePassEncoderPushDebugGroup(
        lean_wgpu_compute_pass_encoder_unbox(self),
        lean_wgpu_string_view(groupLabel)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `ComputePassEncoder.setPipeline`: calls
// `wgpuComputePassEncoderSetPipeline`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderSetPipeline(
    b_lean_obj_arg self,
    b_lean_obj_arg pipeline
) {
    wgpuComputePassEncoderSetPipeline(
        lean_wgpu_compute_pass_encoder_unbox(self),
        lean_wgpu_compute_pipeline_unbox(pipeline)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `ComputePassEncoder.dispatchWorkgroups`: calls
// `wgpuComputePassEncoderDispatchWorkgroups`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderDispatchWorkgroups(
    b_lean_obj_arg self,
    uint32_t       workgroupCountX,
    uint32_t       workgroupCountY,
    uint32_t       workgroupCountZ
) {
    wgpuComputePassEncoderDispatchWorkgroups(
        lean_wgpu_compute_pass_encoder_unbox(self),
        workgroupCountX,
        workgroupCountY,
        workgroupCountZ
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `ComputePassEncoder.dispatchWorkgroupsIndirect`: calls
// `wgpuComputePassEncoderDispatchWorkgroupsIndirect`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderDispatchWorkgroupsIndirect(
    b_lean_obj_arg self,
    b_lean_obj_arg indirectBuffer,
    uint64_t       indirectOffset
) {
    wgpuComputePassEncoderDispatchWorkgroupsIndirect(
        lean_wgpu_compute_pass_encoder_unbox(self),
        lean_wgpu_buffer_unbox(indirectBuffer),
        indirectOffset
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `ComputePassEncoder.«end»`: calls `wgpuComputePassEncoderEnd`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderEnd(b_lean_obj_arg self) {
    wgpuComputePassEncoderEnd(lean_wgpu_compute_pass_encoder_unbox(self));
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `ComputePassEncoder.setLabel`: calls `wgpuComputePassEncoderSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuComputePassEncoderSetLabel(
        lean_wgpu_compute_pass_encoder_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "ComputePassEncoder.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `ComputePipeline.getBindGroupLayout`: calls
// `wgpuComputePipelineGetBindGroupLayout`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePipelineGetBindGroupLayout(
    b_lean_obj_arg self,
    uint32_t       groupIndex
) {
    WGPUBindGroupLayout result = wgpuComputePipelineGetBindGroupLayout(
        lean_wgpu_compute_pipeline_unbox(self),
        groupIndex
    );
    if (result == NULL) {
        return lean_wgpu_io_error(
            "ComputePipeline.getBindGroupLayout returned NULL"
        );
    }
    return lean_io_result_mk_ok(lean_wgpu_bind_group_layout_box(result));
}

// Lean's `ComputePipeline.setLabel`: calls `wgpuComputePipelineSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePipelineSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuComputePipelineSetLabel(
        lean_wgpu_compute_pipeline_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "ComputePipeline.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Device.createBindGroup`: calls `wgpuDeviceCreateBindGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateBindGroup(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUBindGroup result = wgpuDeviceCreateBindGroup(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Device.createBindGroup returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_bind_group_box(result));
}

// Lean's `Device.createBindGroupLayout`: calls
// `wgpuDeviceCreateBindGroupLayout`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateBindGroupLayout(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUBindGroupLayout result = wgpuDeviceCreateBindGroupLayout(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Device.createBindGroupLayout returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_bind_group_layout_box(result));
}

// Lean's `Device.createBuffer`: calls `wgpuDeviceCreateBuffer`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateBuffer(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUBuffer result = wgpuDeviceCreateBuffer(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    return lean_io_result_mk_ok(lean_wgpu_buffer_box_option(result));
}

// Lean's `Device.createCommandEncoder`: calls `wgpuDeviceCreateCommandEncoder`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateCommandEncoder(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUCommandEncoder result = wgpuDeviceCreateCommandEncoder(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Device.createCommandEncoder returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_command_encoder_box(result));
}

// Lean's `Device.createComputePipeline`: calls
// `wgpuDeviceCreateComputePipeline`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateComputePipeline(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUComputePipeline result = wgpuDeviceCreateComputePipeline(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Device.createComputePipeline returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_compute_pipeline_box(result));
}

// Lean's `Device.createPipelineLayout`: calls `wgpuDeviceCreatePipelineLayout`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreatePipelineLayout(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUPipelineLayout result = wgpuDeviceCreatePipelineLayout(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Device.createPipelineLayout returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_pipeline_layout_box(result));
}

// Lean's `Device.createQuerySet`: calls `wgpuDeviceCreateQuerySet`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateQuerySet(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUQuerySet result = wgpuDeviceCreateQuerySet(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Device.createQuerySet returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_query_set_box(result));
}

// Lean's `Device.createRenderBundleEncoder`: calls
// `wgpuDeviceCreateRenderBundleEncoder`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateRenderBundleEncoder(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPURenderBundleEncoder result = wgpuDeviceCreateRenderBundleEncoder(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error(
            "Device.createRenderBundleEncoder returned NULL"
        );
    }
    return lean_io_result_mk_ok(lean_wgpu_render_bundle_encoder_box(result));
}

// Lean's `Device.createRenderPipeline`: calls `wgpuDeviceCreateRenderPipeline`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateRenderPipeline(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPURenderPipeline result = wgpuDeviceCreateRenderPipeline(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Device.createRenderPipeline returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_render_pipeline_box(result));
}

// Lean's `Device.createSampler`: calls `wgpuDeviceCreateSampler`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateSampler(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUSampler result = wgpuDeviceCreateSampler(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Device.createSampler returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_sampler_box(result));
}

// Lean's `Device.createShaderModule`: calls `wgpuDeviceCreateShaderModule`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateShaderModule(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUShaderModule result = wgpuDeviceCreateShaderModule(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Device.createShaderModule returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_shader_module_box(result));
}

// Lean's `Device.createTexture`: calls `wgpuDeviceCreateTexture`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateTexture(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUTexture result = wgpuDeviceCreateTexture(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Device.createTexture returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_texture_box(result));
}

// Lean's `Device.destroy`: calls `wgpuDeviceDestroy`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceDestroy(b_lean_obj_arg self) {
    wgpuDeviceDestroy(lean_wgpu_device_unbox(self));
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `Device.hasFeature`: calls `wgpuDeviceHasFeature`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceHasFeature(
    b_lean_obj_arg self,
    uint32_t       feature
) {
    WGPUBool result = wgpuDeviceHasFeature(
        lean_wgpu_device_unbox(self),
        (WGPUFeatureName)feature
    );
    return lean_io_result_mk_ok(lean_box(result != 0));
}

// Lean's `Device.getQueue`: calls `wgpuDeviceGetQueue`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceGetQueue(b_lean_obj_arg self) {
    WGPUQueue result = wgpuDeviceGetQueue(lean_wgpu_device_unbox(self));
    if (result == NULL) {
        return lean_wgpu_io_error("Device.getQueue returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_queue_box(result));
}

// Lean's `Device.pushErrorScope`: calls `wgpuDevicePushErrorScope`.
LEAN_EXPORT lean_obj_res lean_wgpuDevicePushErrorScope(
    b_lean_obj_arg self,
    uint32_t       filter
) {
    wgpuDevicePushErrorScope(
        lean_wgpu_device_unbox(self),
        (WGPUErrorFilter)filter
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `Device.setLabel`: calls `wgpuDeviceSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuDeviceSetLabel(
        lean_wgpu_device_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "Device.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `ExternalTexture.setLabel`: calls `wgpuExternalTextureSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuExternalTextureSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuExternalTextureSetLabel(
        lean_wgpu_external_texture_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "ExternalTexture.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Instance.hasWGSLLanguageFeature`: calls
// `wgpuInstanceHasWGSLLanguageFeature`.
LEAN_EXPORT lean_obj_res lean_wgpuInstanceHasWGSLLanguageFeature(
    b_lean_obj_arg self,
    uint32_t       feature
) {
    #ifdef WEBGPU_RAW_DAWN
    WGPUBool result = wgpuInstanceHasWGSLLanguageFeature(
        lean_wgpu_instance_unbox(self),
        (WGPUWGSLLanguageFeatureName)feature
    );
    return lean_io_result_mk_ok(lean_box(result != 0));
    #else
    (void)self;
    (void)feature;
    return lean_wgpu_io_error(
        "Instance.hasWGSLLanguageFeature: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Instance.processEvents`: calls `wgpuInstanceProcessEvents`.
LEAN_EXPORT lean_obj_res lean_wgpuInstanceProcessEvents(b_lean_obj_arg self) {
    wgpuInstanceProcessEvents(lean_wgpu_instance_unbox(self));
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `PipelineLayout.setLabel`: calls `wgpuPipelineLayoutSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuPipelineLayoutSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuPipelineLayoutSetLabel(
        lean_wgpu_pipeline_layout_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "PipelineLayout.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `QuerySet.setLabel`: calls `wgpuQuerySetSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuQuerySetSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuQuerySetSetLabel(
        lean_wgpu_query_set_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "QuerySet.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `QuerySet.getType`: calls `wgpuQuerySetGetType`.
LEAN_EXPORT lean_obj_res lean_wgpuQuerySetGetType(b_lean_obj_arg self) {
    WGPUQueryType result = wgpuQuerySetGetType(lean_wgpu_query_set_unbox(self));
    return lean_io_result_mk_ok(lean_box_uint32((uint32_t)result));
}

// Lean's `QuerySet.getCount`: calls `wgpuQuerySetGetCount`.
LEAN_EXPORT lean_obj_res lean_wgpuQuerySetGetCount(b_lean_obj_arg self) {
    uint32_t result = wgpuQuerySetGetCount(lean_wgpu_query_set_unbox(self));
    return lean_io_result_mk_ok(lean_box_uint32(result));
}

// Lean's `QuerySet.destroy`: calls `wgpuQuerySetDestroy`.
LEAN_EXPORT lean_obj_res lean_wgpuQuerySetDestroy(b_lean_obj_arg self) {
    wgpuQuerySetDestroy(lean_wgpu_query_set_unbox(self));
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `Queue.setLabel`: calls `wgpuQueueSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuQueueSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuQueueSetLabel(
        lean_wgpu_queue_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error("Queue.setLabel: not implemented by wgpu-native");
    #endif
}

// Lean's `RenderBundle.setLabel`: calls `wgpuRenderBundleSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuRenderBundleSetLabel(
        lean_wgpu_render_bundle_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "RenderBundle.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `RenderBundleEncoder.setPipeline`: calls
// `wgpuRenderBundleEncoderSetPipeline`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderSetPipeline(
    b_lean_obj_arg self,
    b_lean_obj_arg pipeline
) {
    wgpuRenderBundleEncoderSetPipeline(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_render_pipeline_unbox(pipeline)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderBundleEncoder.draw`: calls `wgpuRenderBundleEncoderDraw`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderDraw(
    b_lean_obj_arg self,
    uint32_t       vertexCount,
    uint32_t       instanceCount,
    uint32_t       firstVertex,
    uint32_t       firstInstance
) {
    wgpuRenderBundleEncoderDraw(
        lean_wgpu_render_bundle_encoder_unbox(self),
        vertexCount,
        instanceCount,
        firstVertex,
        firstInstance
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderBundleEncoder.drawIndexed`: calls
// `wgpuRenderBundleEncoderDrawIndexed`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderDrawIndexed(
    b_lean_obj_arg self,
    uint32_t       indexCount,
    uint32_t       instanceCount,
    uint32_t       firstIndex,
    uint32_t       baseVertex,
    uint32_t       firstInstance
) {
    wgpuRenderBundleEncoderDrawIndexed(
        lean_wgpu_render_bundle_encoder_unbox(self),
        indexCount,
        instanceCount,
        firstIndex,
        (int32_t)baseVertex,
        firstInstance
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderBundleEncoder.drawIndirect`: calls
// `wgpuRenderBundleEncoderDrawIndirect`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderDrawIndirect(
    b_lean_obj_arg self,
    b_lean_obj_arg indirectBuffer,
    uint64_t       indirectOffset
) {
    wgpuRenderBundleEncoderDrawIndirect(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_buffer_unbox(indirectBuffer),
        indirectOffset
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderBundleEncoder.drawIndexedIndirect`: calls
// `wgpuRenderBundleEncoderDrawIndexedIndirect`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderDrawIndexedIndirect(
    b_lean_obj_arg self,
    b_lean_obj_arg indirectBuffer,
    uint64_t       indirectOffset
) {
    wgpuRenderBundleEncoderDrawIndexedIndirect(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_buffer_unbox(indirectBuffer),
        indirectOffset
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderBundleEncoder.insertDebugMarker`: calls
// `wgpuRenderBundleEncoderInsertDebugMarker`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderInsertDebugMarker(
    b_lean_obj_arg self,
    b_lean_obj_arg markerLabel
) {
    wgpuRenderBundleEncoderInsertDebugMarker(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_string_view(markerLabel)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderBundleEncoder.popDebugGroup`: calls
// `wgpuRenderBundleEncoderPopDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderPopDebugGroup(
    b_lean_obj_arg self
) {
    wgpuRenderBundleEncoderPopDebugGroup(
        lean_wgpu_render_bundle_encoder_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderBundleEncoder.pushDebugGroup`: calls
// `wgpuRenderBundleEncoderPushDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderPushDebugGroup(
    b_lean_obj_arg self,
    b_lean_obj_arg groupLabel
) {
    wgpuRenderBundleEncoderPushDebugGroup(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_string_view(groupLabel)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderBundleEncoder.setVertexBuffer`: calls
// `wgpuRenderBundleEncoderSetVertexBuffer`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderSetVertexBuffer(
    b_lean_obj_arg self,
    uint32_t       slot,
    b_lean_obj_arg buffer,
    uint64_t       offset,
    uint64_t       size
) {
    wgpuRenderBundleEncoderSetVertexBuffer(
        lean_wgpu_render_bundle_encoder_unbox(self),
        slot,
        lean_wgpu_buffer_unbox_option(buffer),
        offset,
        size
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderBundleEncoder.setIndexBuffer`: calls
// `wgpuRenderBundleEncoderSetIndexBuffer`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderSetIndexBuffer(
    b_lean_obj_arg self,
    b_lean_obj_arg buffer,
    uint32_t       format,
    uint64_t       offset,
    uint64_t       size
) {
    wgpuRenderBundleEncoderSetIndexBuffer(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_buffer_unbox(buffer),
        (WGPUIndexFormat)format,
        offset,
        size
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderBundleEncoder.finish`: calls `wgpuRenderBundleEncoderFinish`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderFinish(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPURenderBundle result = wgpuRenderBundleEncoderFinish(
        lean_wgpu_render_bundle_encoder_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("RenderBundleEncoder.finish returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_render_bundle_box(result));
}

// Lean's `RenderBundleEncoder.setLabel`: calls
// `wgpuRenderBundleEncoderSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuRenderBundleEncoderSetLabel(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "RenderBundleEncoder.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `RenderPassEncoder.setPipeline`: calls
// `wgpuRenderPassEncoderSetPipeline`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderSetPipeline(
    b_lean_obj_arg self,
    b_lean_obj_arg pipeline
) {
    wgpuRenderPassEncoderSetPipeline(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_render_pipeline_unbox(pipeline)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.draw`: calls `wgpuRenderPassEncoderDraw`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderDraw(
    b_lean_obj_arg self,
    uint32_t       vertexCount,
    uint32_t       instanceCount,
    uint32_t       firstVertex,
    uint32_t       firstInstance
) {
    wgpuRenderPassEncoderDraw(
        lean_wgpu_render_pass_encoder_unbox(self),
        vertexCount,
        instanceCount,
        firstVertex,
        firstInstance
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.drawIndexed`: calls
// `wgpuRenderPassEncoderDrawIndexed`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderDrawIndexed(
    b_lean_obj_arg self,
    uint32_t       indexCount,
    uint32_t       instanceCount,
    uint32_t       firstIndex,
    uint32_t       baseVertex,
    uint32_t       firstInstance
) {
    wgpuRenderPassEncoderDrawIndexed(
        lean_wgpu_render_pass_encoder_unbox(self),
        indexCount,
        instanceCount,
        firstIndex,
        (int32_t)baseVertex,
        firstInstance
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.drawIndirect`: calls
// `wgpuRenderPassEncoderDrawIndirect`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderDrawIndirect(
    b_lean_obj_arg self,
    b_lean_obj_arg indirectBuffer,
    uint64_t       indirectOffset
) {
    wgpuRenderPassEncoderDrawIndirect(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_buffer_unbox(indirectBuffer),
        indirectOffset
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.drawIndexedIndirect`: calls
// `wgpuRenderPassEncoderDrawIndexedIndirect`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderDrawIndexedIndirect(
    b_lean_obj_arg self,
    b_lean_obj_arg indirectBuffer,
    uint64_t       indirectOffset
) {
    wgpuRenderPassEncoderDrawIndexedIndirect(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_buffer_unbox(indirectBuffer),
        indirectOffset
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.insertDebugMarker`: calls
// `wgpuRenderPassEncoderInsertDebugMarker`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderInsertDebugMarker(
    b_lean_obj_arg self,
    b_lean_obj_arg markerLabel
) {
    wgpuRenderPassEncoderInsertDebugMarker(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_string_view(markerLabel)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.popDebugGroup`: calls
// `wgpuRenderPassEncoderPopDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderPopDebugGroup(
    b_lean_obj_arg self
) {
    wgpuRenderPassEncoderPopDebugGroup(
        lean_wgpu_render_pass_encoder_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.pushDebugGroup`: calls
// `wgpuRenderPassEncoderPushDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderPushDebugGroup(
    b_lean_obj_arg self,
    b_lean_obj_arg groupLabel
) {
    wgpuRenderPassEncoderPushDebugGroup(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_string_view(groupLabel)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.setStencilReference`: calls
// `wgpuRenderPassEncoderSetStencilReference`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderSetStencilReference(
    b_lean_obj_arg self,
    uint32_t       reference
) {
    wgpuRenderPassEncoderSetStencilReference(
        lean_wgpu_render_pass_encoder_unbox(self),
        reference
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.setBlendConstant`: calls
// `wgpuRenderPassEncoderSetBlendConstant`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderSetBlendConstant(
    b_lean_obj_arg self,
    b_lean_obj_arg color,
    b_lean_obj_arg color_bytes,
    b_lean_obj_arg color_targets,
    b_lean_obj_arg color_table,
    b_lean_obj_arg tables
) {
    (void)color;
    void const * color_struct = lean_wgpu_fill_arg(
        color_bytes,
        tables,
        lean_usize_of_nat(color_table),
        color_targets
    );
    wgpuRenderPassEncoderSetBlendConstant(
        lean_wgpu_render_pass_encoder_unbox(self),
        color_struct
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.setViewport`: calls
// `wgpuRenderPassEncoderSetViewport`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderSetViewport(
    b_lean_obj_arg self,
    float          x,
    float          y,
    float          width,
    float          height,
    float          minDepth,
    float          maxDepth
) {
    wgpuRenderPassEncoderSetViewport(
        lean_wgpu_render_pass_encoder_unbox(self),
        x,
        y,
        width,
        height,
        minDepth,
        maxDepth
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.setScissorRect`: calls
// `wgpuRenderPassEncoderSetScissorRect`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderSetScissorRect(
    b_lean_obj_arg self,
    uint32_t       x,
    uint32_t       y,
    uint32_t       width,
    uint32_t       height
) {
    wgpuRenderPassEncoderSetScissorRect(
        lean_wgpu_render_pass_encoder_unbox(self),
        x,
        y,
        width,
        height
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.setVertexBuffer`: calls
// `wgpuRenderPassEncoderSetVertexBuffer`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderSetVertexBuffer(
    b_lean_obj_arg self,
    uint32_t       slot,
    b_lean_obj_arg buffer,
    uint64_t       offset,
    uint64_t       size
) {
    wgpuRenderPassEncoderSetVertexBuffer(
        lean_wgpu_render_pass_encoder_unbox(self),
        slot,
        lean_wgpu_buffer_unbox_option(buffer),
        offset,
        size
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.setIndexBuffer`: calls
// `wgpuRenderPassEncoderSetIndexBuffer`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderSetIndexBuffer(
    b_lean_obj_arg self,
    b_lean_obj_arg buffer,
    uint32_t       format,
    uint64_t       offset,
    uint64_t       size
) {
    wgpuRenderPassEncoderSetIndexBuffer(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_buffer_unbox(buffer),
        (WGPUIndexFormat)format,
        offset,
        size
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.beginOcclusionQuery`: calls
// `wgpuRenderPassEncoderBeginOcclusionQuery`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderBeginOcclusionQuery(
    b_lean_obj_arg self,
    uint32_t       queryIndex
) {
    wgpuRenderPassEncoderBeginOcclusionQuery(
        lean_wgpu_render_pass_encoder_unbox(self),
        queryIndex
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.endOcclusionQuery`: calls
// `wgpuRenderPassEncoderEndOcclusionQuery`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderEndOcclusionQuery(
    b_lean_obj_arg self
) {
    wgpuRenderPassEncoderEndOcclusionQuery(
        lean_wgpu_render_pass_encoder_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.«end»`: calls `wgpuRenderPassEncoderEnd`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderEnd(b_lean_obj_arg self) {
    wgpuRenderPassEncoderEnd(lean_wgpu_render_pass_encoder_unbox(self));
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `RenderPassEncoder.setLabel`: calls `wgpuRenderPassEncoderSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuRenderPassEncoderSetLabel(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "RenderPassEncoder.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `RenderPipeline.getBindGroupLayout`: calls
// `wgpuRenderPipelineGetBindGroupLayout`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPipelineGetBindGroupLayout(
    b_lean_obj_arg self,
    uint32_t       groupIndex
) {
    WGPUBindGroupLayout result = wgpuRenderPipelineGetBindGroupLayout(
        lean_wgpu_render_pipeline_unbox(self),
        groupIndex
    );
    if (result == NULL) {
        return lean_wgpu_io_error(
            "RenderPipeline.getBindGroupLayout returned NULL"
        );
    }
    return lean_io_result_mk_ok(lean_wgpu_bind_group_layout_box(result));
}

// Lean's `RenderPipeline.setLabel`: calls `wgpuRenderPipelineSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPipelineSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuRenderPipelineSetLabel(
        lean_wgpu_render_pipeline_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "RenderPipeline.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Sampler.setLabel`: calls `wgpuSamplerSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuSamplerSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuSamplerSetLabel(
        lean_wgpu_sampler_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "Sampler.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `ShaderModule.setLabel`: calls `wgpuShaderModuleSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuShaderModuleSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuShaderModuleSetLabel(
        lean_wgpu_shader_module_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "ShaderModule.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Surface.configure`: calls `wgpuSurfaceConfigure`.
LEAN_EXPORT lean_obj_res lean_wgpuSurfaceConfigure(
    b_lean_obj_arg self,
    b_lean_obj_arg config,
    b_lean_obj_arg config_bytes,
    b_lean_obj_arg config_targets,
    b_lean_obj_arg config_table,
    b_lean_obj_arg tables
) {
    (void)config;
    void const * config_struct = lean_wgpu_fill_arg(
        config_bytes,
        tables,
        lean_usize_of_nat(config_table),
        config_targets
    );
    wgpuSurfaceConfigure(lean_wgpu_surface_unbox(self), config_struct);
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `Surface.present`: calls `wgpuSurfacePresent`.
LEAN_EXPORT lean_obj_res lean_wgpuSurfacePresent(b_lean_obj_arg self) {
    WGPUStatus result = wgpuSurfacePresent(lean_wgpu_surface_unbox(self));
    return lean_io_result_mk_ok(lean_box_uint32((uint32_t)result));
}

// Lean's `Surface.unconfigure`: calls `wgpuSurfaceUnconfigure`.
LEAN_EXPORT lean_obj_res lean_wgpuSurfaceUnconfigure(b_lean_obj_arg self) {
    wgpuSurfaceUnconfigure(lean_wgpu_surface_unbox(self));
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `Surface.setLabel`: calls `wgpuSurfaceSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuSurfaceSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuSurfaceSetLabel(
        lean_wgpu_surface_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "Surface.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Texture.createView`: calls `wgpuTextureCreateView`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureCreateView(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    b_lean_obj_arg tables
) {
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUTextureView result = wgpuTextureCreateView(
        lean_wgpu_texture_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_io_error("Texture.createView returned NULL");
    }
    return lean_io_result_mk_ok(lean_wgpu_texture_view_box(result));
}

// Lean's `Texture.setLabel`: calls `wgpuTextureSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuTextureSetLabel(
        lean_wgpu_texture_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "Texture.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Texture.getWidth`: calls `wgpuTextureGetWidth`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetWidth(b_lean_obj_arg self) {
    uint32_t result = wgpuTextureGetWidth(lean_wgpu_texture_unbox(self));
    return lean_io_result_mk_ok(lean_box_uint32(result));
}

// Lean's `Texture.getHeight`: calls `wgpuTextureGetHeight`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetHeight(b_lean_obj_arg self) {
    uint32_t result = wgpuTextureGetHeight(lean_wgpu_texture_unbox(self));
    return lean_io_result_mk_ok(lean_box_uint32(result));
}

// Lean's `Texture.getDepthOrArrayLayers`: calls
// `wgpuTextureGetDepthOrArrayLayers`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetDepthOrArrayLayers(
    b_lean_obj_arg self
) {
    uint32_t result = wgpuTextureGetDepthOrArrayLayers(
        lean_wgpu_texture_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box_uint32(result));
}

// Lean's `Texture.getMipLevelCount`: calls `wgpuTextureGetMipLevelCount`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetMipLevelCount(b_lean_obj_arg self) {
    uint32_t result = wgpuTextureGetMipLevelCount(
        lean_wgpu_texture_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box_uint32(result));
}

// Lean's `Texture.getSampleCount`: calls `wgpuTextureGetSampleCount`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetSampleCount(b_lean_obj_arg self) {
    uint32_t result = wgpuTextureGetSampleCount(lean_wgpu_texture_unbox(self));
    return lean_io_result_mk_ok(lean_box_uint32(result));
}

// Lean's `Texture.getDimension`: calls `wgpuTextureGetDimension`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetDimension(b_lean_obj_arg self) {
    WGPUTextureDimension result = wgpuTextureGetDimension(
        lean_wgpu_texture_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box_uint32((uint32_t)result));
}

// Lean's `Texture.getTextureBindingViewDimension`: calls
// `wgpuTextureGetTextureBindingViewDimension`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetTextureBindingViewDimension(
    b_lean_obj_arg self
) {
    #ifdef WEBGPU_RAW_DAWN
    WGPUTextureViewDimension result = wgpuTextureGetTextureBindingViewDimension(
        lean_wgpu_texture_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box_uint32((uint32_t)result));
    #else
    (void)self;
    return lean_wgpu_io_error(
        "Texture.getTextureBindingViewDimension: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Texture.getFormat`: calls `wgpuTextureGetFormat`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetFormat(b_lean_obj_arg self) {
    WGPUTextureFormat result = wgpuTextureGetFormat(
        lean_wgpu_texture_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box_uint32((uint32_t)result));
}

// Lean's `Texture.getUsage`: calls `wgpuTextureGetUsage`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetUsage(b_lean_obj_arg self) {
    WGPUTextureUsage result = wgpuTextureGetUsage(
        lean_wgpu_texture_unbox(self)
    );
    return lean_io_result_mk_ok(lean_box_uint64((uint64_t)result));
}

// Lean's `Texture.destroy`: calls `wgpuTextureDestroy`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureDestroy(b_lean_obj_arg self) {
    wgpuTextureDestroy(lean_wgpu_texture_unbox(self));
    return lean_io_result_mk_ok(lean_box(0));
}

// Lean's `TextureView.setLabel`: calls `wgpuTextureViewSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureViewSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    wgpuTextureViewSetLabel(
        lean_wgpu_texture_view_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_io_result_mk_ok(lean_box(0));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "TextureView.setLabel: not implemented by wgpu-native"
    );
    #endif
}
