/*
================================================================================
  GENERATED FILE: DO NOT EDIT BY HAND

  Generator:        webgpu-gen
  Generator commit: cf062a5 (clean)
  Generated:        2026-11-05 09:10:39 UTC
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
#include "callback.h"
#include "family.h"

// A function the shims use, which some builds may not.

#define LEAN_WGPU_HELPER static inline __attribute__((unused))

// A view of the bytes of the Lean string `s`, which stays alive while the
// string is borrowed. Its length leaves out the terminating NUL.
LEAN_WGPU_HELPER WGPUStringView lean_wgpu_string_view(b_lean_obj_arg s) {
    WGPUStringView view = {
        .data   = lean_string_cstr(s),
        .length = lean_string_size(s) - 1,
    };
    return view;
}

// A size from Lean as a `size_t`, checked to fit: the largest `UInt64` stands
// for `SIZE_MAX`, which is 32 bits on the web.
LEAN_WGPU_HELPER size_t lean_wgpu_size(uint64_t size) {
    if (size == UINT64_MAX) {
        return SIZE_MAX;
    }
    return (size_t)size;
}

// An `IO` error saying `message`, for a check a shim makes, or a function an
// implementation does not implement.
LEAN_WGPU_HELPER lean_obj_res lean_wgpu_io_error(char const * message) {
    return lean_io_result_mk_error(
        lean_mk_io_user_error(lean_mk_string(message))
    );
}

// Calls the Lean closure `userdata1` as a `RequestDeviceCallback`, releasing
// it; each object it gives Lean joins the family `userdata2` names, whose
// reference it gives back.
LEAN_WGPU_HELPER void lean_WGPURequestDeviceCallback(
    WGPURequestDeviceStatus status,
    WGPUDevice              device,
    WGPUStringView          message,
    void *                  userdata1,
    void *                  userdata2
) {
    lean_wgpu_family family = (lean_wgpu_family)((uintptr_t)userdata2);
    lean_wgpu_family_join(device, family);
    lean_wgpu_family_release(family);
    lean_wgpu_callback_done(
        lean_apply_4(
            (lean_object *)userdata1,
            lean_box_uint32((uint32_t)status),
            lean_wgpu_device_box_option(device),
            lean_wgpu_string_of_view(message),
            lean_io_mk_world()
        )
    );
}

// Calls the Lean closure `userdata1` as a `BufferMapCallback`, releasing it;
// each object it gives Lean joins the family `userdata2` names, whose reference
// it gives back.
LEAN_WGPU_HELPER void lean_WGPUBufferMapCallback(
    WGPUMapAsyncStatus status,
    WGPUStringView     message,
    void *             userdata1,
    void *             userdata2
) {
    lean_wgpu_family family = (lean_wgpu_family)((uintptr_t)userdata2);
    lean_wgpu_family_release(family);
    lean_wgpu_callback_done(
        lean_apply_3(
            (lean_object *)userdata1,
            lean_box_uint32((uint32_t)status),
            lean_wgpu_string_of_view(message),
            lean_io_mk_world()
        )
    );
}

// Calls the Lean closure `userdata1` as a `CreateComputePipelineAsyncCallback`,
// releasing it; each object it gives Lean joins the family `userdata2` names,
// whose reference it gives back.
LEAN_WGPU_HELPER void lean_WGPUCreateComputePipelineAsyncCallback(
    WGPUCreatePipelineAsyncStatus status,
    WGPUComputePipeline           pipeline,
    WGPUStringView                message,
    void *                        userdata1,
    void *                        userdata2
) {
    lean_wgpu_family family = (lean_wgpu_family)((uintptr_t)userdata2);
    lean_wgpu_family_join(pipeline, family);
    lean_wgpu_family_release(family);
    lean_wgpu_callback_done(
        lean_apply_4(
            (lean_object *)userdata1,
            lean_box_uint32((uint32_t)status),
            lean_wgpu_compute_pipeline_box_option(pipeline),
            lean_wgpu_string_of_view(message),
            lean_io_mk_world()
        )
    );
}

// Calls the Lean closure `userdata1` as a `CreateRenderPipelineAsyncCallback`,
// releasing it; each object it gives Lean joins the family `userdata2` names,
// whose reference it gives back.
LEAN_WGPU_HELPER void lean_WGPUCreateRenderPipelineAsyncCallback(
    WGPUCreatePipelineAsyncStatus status,
    WGPURenderPipeline            pipeline,
    WGPUStringView                message,
    void *                        userdata1,
    void *                        userdata2
) {
    lean_wgpu_family family = (lean_wgpu_family)((uintptr_t)userdata2);
    lean_wgpu_family_join(pipeline, family);
    lean_wgpu_family_release(family);
    lean_wgpu_callback_done(
        lean_apply_4(
            (lean_object *)userdata1,
            lean_box_uint32((uint32_t)status),
            lean_wgpu_render_pipeline_box_option(pipeline),
            lean_wgpu_string_of_view(message),
            lean_io_mk_world()
        )
    );
}

// Calls the Lean closure `userdata1` as a `PopErrorScopeCallback`, releasing
// it; each object it gives Lean joins the family `userdata2` names, whose
// reference it gives back.
LEAN_WGPU_HELPER void lean_WGPUPopErrorScopeCallback(
    WGPUPopErrorScopeStatus status,
    WGPUErrorType           type,
    WGPUStringView          message,
    void *                  userdata1,
    void *                  userdata2
) {
    lean_wgpu_family family = (lean_wgpu_family)((uintptr_t)userdata2);
    lean_wgpu_family_release(family);
    lean_wgpu_callback_done(
        lean_apply_4(
            (lean_object *)userdata1,
            lean_box_uint32((uint32_t)status),
            lean_box_uint32((uint32_t)type),
            lean_wgpu_string_of_view(message),
            lean_io_mk_world()
        )
    );
}

// Calls the Lean closure `userdata1` as a `RequestAdapterCallback`, releasing
// it; each object it gives Lean joins the family `userdata2` names, whose
// reference it gives back.
LEAN_WGPU_HELPER void lean_WGPURequestAdapterCallback(
    WGPURequestAdapterStatus status,
    WGPUAdapter              adapter,
    WGPUStringView           message,
    void *                   userdata1,
    void *                   userdata2
) {
    lean_wgpu_family family = (lean_wgpu_family)((uintptr_t)userdata2);
    lean_wgpu_family_join(adapter, family);
    lean_wgpu_family_release(family);
    lean_wgpu_callback_done(
        lean_apply_4(
            (lean_object *)userdata1,
            lean_box_uint32((uint32_t)status),
            lean_wgpu_adapter_box_option(adapter),
            lean_wgpu_string_of_view(message),
            lean_io_mk_world()
        )
    );
}

// Calls the Lean closure `userdata1` as a `QueueWorkDoneCallback`, releasing
// it; each object it gives Lean joins the family `userdata2` names, whose
// reference it gives back.
LEAN_WGPU_HELPER void lean_WGPUQueueWorkDoneCallback(
    WGPUQueueWorkDoneStatus status,
    WGPUStringView          message,
    void *                  userdata1,
    void *                  userdata2
) {
    lean_wgpu_family family = (lean_wgpu_family)((uintptr_t)userdata2);
    lean_wgpu_family_release(family);
    lean_wgpu_callback_done(
        lean_apply_3(
            (lean_object *)userdata1,
            lean_box_uint32((uint32_t)status),
            lean_wgpu_string_of_view(message),
            lean_io_mk_world()
        )
    );
}

// Calls the closure the family `userdata1` holds at `userdata2`, as a
// `DeviceLostCallback`, keeping it, as C may call it again; nothing if the
// family is gone.
LEAN_WGPU_HELPER void lean_WGPUDeviceLostCallback(
    WGPUDevice const *   device,
    WGPUDeviceLostReason reason,
    WGPUStringView       message,
    void *               userdata1,
    void *               userdata2
) {
    (void)device;
    lean_wgpu_family family = (lean_wgpu_family)((uintptr_t)userdata1);
    lean_object * closure = lean_wgpu_family_closure(
        family,
        (size_t)((uintptr_t)userdata2)
    );
    #ifdef WEBGPU_RAW_DAWN
    lean_wgpu_family_release(family);
    #endif
    if (closure == NULL) {
        return;
    }
    lean_wgpu_callback_done(
        lean_apply_3(
            closure,
            lean_box_uint32((uint32_t)reason),
            lean_wgpu_string_of_view(message),
            lean_io_mk_world()
        )
    );
}

// The address of `DeviceLostCallback`'s trampoline, for Lean to write into a
// struct.
LEAN_EXPORT uint64_t lean_WGPUDeviceLostCallback_address(b_lean_obj_arg unit) {
    (void)unit;
    return (uint64_t)((uintptr_t)lean_WGPUDeviceLostCallback);
}

// Calls the closure the family `userdata1` holds at `userdata2`, as a
// `UncapturedErrorCallback`, keeping it, as C may call it again; nothing if the
// family is gone.
LEAN_WGPU_HELPER void lean_WGPUUncapturedErrorCallback(
    WGPUDevice const * device,
    WGPUErrorType      type,
    WGPUStringView     message,
    void *             userdata1,
    void *             userdata2
) {
    (void)device;
    lean_wgpu_family family = (lean_wgpu_family)((uintptr_t)userdata1);
    lean_object * closure = lean_wgpu_family_closure(
        family,
        (size_t)((uintptr_t)userdata2)
    );
    if (closure == NULL) {
        return;
    }
    lean_wgpu_callback_done(
        lean_apply_3(
            closure,
            lean_box_uint32((uint32_t)type),
            lean_wgpu_string_of_view(message),
            lean_io_mk_world()
        )
    );
}

// The address of `UncapturedErrorCallback`'s trampoline, for Lean to write into
// a struct.
LEAN_EXPORT uint64_t lean_WGPUUncapturedErrorCallback_address(
    b_lean_obj_arg unit
) {
    (void)unit;
    return (uint64_t)((uintptr_t)lean_WGPUUncapturedErrorCallback);
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUInstance result = wgpuCreateInstance(descriptor_struct);
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("createInstance returned NULL")
        );
    }
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_instance_box(result))
    );
}

// Lean's `hasInstanceFeature`: calls `wgpuHasInstanceFeature`.
LEAN_EXPORT lean_obj_res lean_wgpuHasInstanceFeature(uint32_t feature) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBool result = wgpuHasInstanceFeature((WGPUInstanceFeatureName)feature);
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box(result != 0))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBool result = wgpuAdapterHasFeature(
        lean_wgpu_adapter_unbox(self),
        (WGPUFeatureName)feature
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box(result != 0))
    );
}

// Lean's `Adapter.requestDevice`: calls `wgpuAdapterRequestDevice`.
LEAN_EXPORT lean_obj_res lean_wgpuAdapterRequestDevice(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    uint32_t       callbackMode,
    b_lean_obj_arg callback,
    b_lean_obj_arg tables
) {
    lean_wgpu_family family = lean_wgpu_family_new();
    lean_wgpu_family filling = lean_wgpu_family_set_filling(family);
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    lean_wgpu_family_set_filling(filling);
    #ifdef WEBGPU_RAW_DAWN
    if (descriptor_struct != NULL) {
        WGPUDeviceDescriptor const * held = descriptor_struct;
        if (held->deviceLostCallbackInfo.userdata1 != NULL) {
            lean_wgpu_family_retain(family);
        }
    }
    #endif
    WGPURequestDeviceCallbackInfo callbackInfo = {
        .nextInChain = NULL,
        .mode        = (WGPUCallbackMode)callbackMode,
        .callback    = lean_WGPURequestDeviceCallback,
        .userdata1   = lean_wgpu_closure_hold(callback),
        .userdata2   = (void *)family,
    };
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUFuture result = wgpuAdapterRequestDevice(
        lean_wgpu_adapter_unbox(self),
        descriptor_struct,
        callbackInfo
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64(result.id))
    );
}

// Lean's `BindGroup.setLabel`: calls `wgpuBindGroupSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuBindGroupSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuBindGroupSetLabel(
        lean_wgpu_bind_group_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuBindGroupLayoutSetLabel(
        lean_wgpu_bind_group_layout_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "BindGroupLayout.setLabel: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Buffer.mapAsync`: calls `wgpuBufferMapAsync`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferMapAsync(
    b_lean_obj_arg self,
    uint64_t       mode,
    uint64_t       offset,
    uint64_t       size,
    uint32_t       callbackMode,
    b_lean_obj_arg callback
) {
    if ((offset != UINT64_MAX) && (((uint64_t)((size_t)offset)) != offset)) {
        return lean_wgpu_io_error(
            "Buffer.mapAsync: offset is too large for a size_t"
        );
    }
    if ((size != UINT64_MAX) && (((uint64_t)((size_t)size)) != size)) {
        return lean_wgpu_io_error(
            "Buffer.mapAsync: size is too large for a size_t"
        );
    }
    lean_wgpu_family family = lean_wgpu_family_of(lean_wgpu_buffer_unbox(self));
    lean_wgpu_family_retain(family);
    WGPUBufferMapCallbackInfo callbackInfo = {
        .nextInChain = NULL,
        .mode        = (WGPUCallbackMode)callbackMode,
        .callback    = lean_WGPUBufferMapCallback,
        .userdata1   = lean_wgpu_closure_hold(callback),
        .userdata2   = (void *)family,
    };
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUFuture result = wgpuBufferMapAsync(
        lean_wgpu_buffer_unbox(self),
        (WGPUMapMode)mode,
        lean_wgpu_size(offset),
        lean_wgpu_size(size),
        callbackInfo
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64(result.id))
    );
}

// Lean's `Buffer.setLabel`: calls `wgpuBufferSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuBufferSetLabel(
        lean_wgpu_buffer_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBufferUsage result = wgpuBufferGetUsage(lean_wgpu_buffer_unbox(self));
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64((uint64_t)result))
    );
}

// Lean's `Buffer.getSize`: calls `wgpuBufferGetSize`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferGetSize(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    uint64_t result = wgpuBufferGetSize(lean_wgpu_buffer_unbox(self));
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64(result))
    );
}

// Lean's `Buffer.getMapState`: calls `wgpuBufferGetMapState`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferGetMapState(b_lean_obj_arg self) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBufferMapState result = wgpuBufferGetMapState(
        lean_wgpu_buffer_unbox(self)
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32((uint32_t)result))
    );
    #else
    (void)self;
    return lean_wgpu_io_error(
        "Buffer.getMapState: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Buffer.unmap`: calls `wgpuBufferUnmap`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferUnmap(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuBufferUnmap(lean_wgpu_buffer_unbox(self));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `Buffer.destroy`: calls `wgpuBufferDestroy`.
LEAN_EXPORT lean_obj_res lean_wgpuBufferDestroy(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuBufferDestroy(lean_wgpu_buffer_unbox(self));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `CommandBuffer.setLabel`: calls `wgpuCommandBufferSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandBufferSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandBufferSetLabel(
        lean_wgpu_command_buffer_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUCommandBuffer result = wgpuCommandEncoderFinish(
        lean_wgpu_command_encoder_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("CommandEncoder.finish returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_command_encoder_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_command_buffer_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUComputePassEncoder result = wgpuCommandEncoderBeginComputePass(
        lean_wgpu_command_encoder_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("CommandEncoder.beginComputePass returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_command_encoder_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_compute_pass_encoder_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPURenderPassEncoder result = wgpuCommandEncoderBeginRenderPass(
        lean_wgpu_command_encoder_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("CommandEncoder.beginRenderPass returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_command_encoder_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_render_pass_encoder_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderCopyBufferToBuffer(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_buffer_unbox(source),
        sourceOffset,
        lean_wgpu_buffer_unbox(destination),
        destinationOffset,
        size
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderCopyBufferToTexture(
        lean_wgpu_command_encoder_unbox(self),
        source_struct,
        destination_struct,
        copySize_struct
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderCopyTextureToBuffer(
        lean_wgpu_command_encoder_unbox(self),
        source_struct,
        destination_struct,
        copySize_struct
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderCopyTextureToTexture(
        lean_wgpu_command_encoder_unbox(self),
        source_struct,
        destination_struct,
        copySize_struct
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `CommandEncoder.clearBuffer`: calls `wgpuCommandEncoderClearBuffer`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderClearBuffer(
    b_lean_obj_arg self,
    b_lean_obj_arg buffer,
    uint64_t       offset,
    uint64_t       size
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderClearBuffer(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_buffer_unbox(buffer),
        offset,
        size
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `CommandEncoder.insertDebugMarker`: calls
// `wgpuCommandEncoderInsertDebugMarker`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderInsertDebugMarker(
    b_lean_obj_arg self,
    b_lean_obj_arg markerLabel
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderInsertDebugMarker(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_string_view(markerLabel)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `CommandEncoder.popDebugGroup`: calls
// `wgpuCommandEncoderPopDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderPopDebugGroup(
    b_lean_obj_arg self
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderPopDebugGroup(lean_wgpu_command_encoder_unbox(self));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `CommandEncoder.pushDebugGroup`: calls
// `wgpuCommandEncoderPushDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderPushDebugGroup(
    b_lean_obj_arg self,
    b_lean_obj_arg groupLabel
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderPushDebugGroup(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_string_view(groupLabel)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderResolveQuerySet(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_query_set_unbox(querySet),
        firstQuery,
        queryCount,
        lean_wgpu_buffer_unbox(destination),
        destinationOffset
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `CommandEncoder.writeTimestamp`: calls
// `wgpuCommandEncoderWriteTimestamp`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderWriteTimestamp(
    b_lean_obj_arg self,
    b_lean_obj_arg querySet,
    uint32_t       queryIndex
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderWriteTimestamp(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_query_set_unbox(querySet),
        queryIndex
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `CommandEncoder.setLabel`: calls `wgpuCommandEncoderSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuCommandEncoderSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuCommandEncoderSetLabel(
        lean_wgpu_command_encoder_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuComputePassEncoderInsertDebugMarker(
        lean_wgpu_compute_pass_encoder_unbox(self),
        lean_wgpu_string_view(markerLabel)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `ComputePassEncoder.popDebugGroup`: calls
// `wgpuComputePassEncoderPopDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderPopDebugGroup(
    b_lean_obj_arg self
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuComputePassEncoderPopDebugGroup(
        lean_wgpu_compute_pass_encoder_unbox(self)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `ComputePassEncoder.pushDebugGroup`: calls
// `wgpuComputePassEncoderPushDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderPushDebugGroup(
    b_lean_obj_arg self,
    b_lean_obj_arg groupLabel
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuComputePassEncoderPushDebugGroup(
        lean_wgpu_compute_pass_encoder_unbox(self),
        lean_wgpu_string_view(groupLabel)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `ComputePassEncoder.setPipeline`: calls
// `wgpuComputePassEncoderSetPipeline`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderSetPipeline(
    b_lean_obj_arg self,
    b_lean_obj_arg pipeline
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuComputePassEncoderSetPipeline(
        lean_wgpu_compute_pass_encoder_unbox(self),
        lean_wgpu_compute_pipeline_unbox(pipeline)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `ComputePassEncoder.dispatchWorkgroups`: calls
// `wgpuComputePassEncoderDispatchWorkgroups`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderDispatchWorkgroups(
    b_lean_obj_arg self,
    uint32_t       workgroupCountX,
    uint32_t       workgroupCountY,
    uint32_t       workgroupCountZ
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuComputePassEncoderDispatchWorkgroups(
        lean_wgpu_compute_pass_encoder_unbox(self),
        workgroupCountX,
        workgroupCountY,
        workgroupCountZ
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `ComputePassEncoder.dispatchWorkgroupsIndirect`: calls
// `wgpuComputePassEncoderDispatchWorkgroupsIndirect`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderDispatchWorkgroupsIndirect(
    b_lean_obj_arg self,
    b_lean_obj_arg indirectBuffer,
    uint64_t       indirectOffset
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuComputePassEncoderDispatchWorkgroupsIndirect(
        lean_wgpu_compute_pass_encoder_unbox(self),
        lean_wgpu_buffer_unbox(indirectBuffer),
        indirectOffset
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `ComputePassEncoder.«end»`: calls `wgpuComputePassEncoderEnd`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderEnd(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuComputePassEncoderEnd(lean_wgpu_compute_pass_encoder_unbox(self));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `ComputePassEncoder.setLabel`: calls `wgpuComputePassEncoderSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePassEncoderSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuComputePassEncoderSetLabel(
        lean_wgpu_compute_pass_encoder_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBindGroupLayout result = wgpuComputePipelineGetBindGroupLayout(
        lean_wgpu_compute_pipeline_unbox(self),
        groupIndex
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error(
                "ComputePipeline.getBindGroupLayout returned NULL"
            )
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_compute_pipeline_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_bind_group_layout_box(result))
    );
}

// Lean's `ComputePipeline.setLabel`: calls `wgpuComputePipelineSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuComputePipelineSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuComputePipelineSetLabel(
        lean_wgpu_compute_pipeline_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBindGroup result = wgpuDeviceCreateBindGroup(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createBindGroup returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_bind_group_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBindGroupLayout result = wgpuDeviceCreateBindGroupLayout(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createBindGroupLayout returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_bind_group_layout_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBuffer result = wgpuDeviceCreateBuffer(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_buffer_box_option(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUCommandEncoder result = wgpuDeviceCreateCommandEncoder(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createCommandEncoder returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_command_encoder_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUComputePipeline result = wgpuDeviceCreateComputePipeline(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createComputePipeline returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_compute_pipeline_box(result))
    );
}

// Lean's `Device.createComputePipelineAsync`: calls
// `wgpuDeviceCreateComputePipelineAsync`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateComputePipelineAsync(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    uint32_t       callbackMode,
    b_lean_obj_arg callback,
    b_lean_obj_arg tables
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_wgpu_family family = lean_wgpu_family_of(lean_wgpu_device_unbox(self));
    lean_wgpu_family_retain(family);
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUCreateComputePipelineAsyncCallbackInfo callbackInfo = {
        .nextInChain = NULL,
        .mode        = (WGPUCallbackMode)callbackMode,
        .callback    = lean_WGPUCreateComputePipelineAsyncCallback,
        .userdata1   = lean_wgpu_closure_hold(callback),
        .userdata2   = (void *)family,
    };
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUFuture result = wgpuDeviceCreateComputePipelineAsync(
        lean_wgpu_device_unbox(self),
        descriptor_struct,
        callbackInfo
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64(result.id))
    );
    #else
    (void)self;
    (void)descriptor;
    (void)descriptor_bytes;
    (void)descriptor_targets;
    (void)descriptor_table;
    (void)callbackMode;
    (void)callback;
    (void)tables;
    return lean_wgpu_io_error(
        "Device.createComputePipelineAsync: not implemented by wgpu-native"
    );
    #endif
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUPipelineLayout result = wgpuDeviceCreatePipelineLayout(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createPipelineLayout returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_pipeline_layout_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUQuerySet result = wgpuDeviceCreateQuerySet(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createQuerySet returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_query_set_box(result))
    );
}

// Lean's `Device.createRenderPipelineAsync`: calls
// `wgpuDeviceCreateRenderPipelineAsync`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceCreateRenderPipelineAsync(
    b_lean_obj_arg self,
    b_lean_obj_arg descriptor,
    b_lean_obj_arg descriptor_bytes,
    b_lean_obj_arg descriptor_targets,
    b_lean_obj_arg descriptor_table,
    uint32_t       callbackMode,
    b_lean_obj_arg callback,
    b_lean_obj_arg tables
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_wgpu_family family = lean_wgpu_family_of(lean_wgpu_device_unbox(self));
    lean_wgpu_family_retain(family);
    (void)descriptor;
    void const * descriptor_struct = lean_wgpu_fill_arg(
        descriptor_bytes,
        tables,
        lean_usize_of_nat(descriptor_table),
        descriptor_targets
    );
    WGPUCreateRenderPipelineAsyncCallbackInfo callbackInfo = {
        .nextInChain = NULL,
        .mode        = (WGPUCallbackMode)callbackMode,
        .callback    = lean_WGPUCreateRenderPipelineAsyncCallback,
        .userdata1   = lean_wgpu_closure_hold(callback),
        .userdata2   = (void *)family,
    };
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUFuture result = wgpuDeviceCreateRenderPipelineAsync(
        lean_wgpu_device_unbox(self),
        descriptor_struct,
        callbackInfo
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64(result.id))
    );
    #else
    (void)self;
    (void)descriptor;
    (void)descriptor_bytes;
    (void)descriptor_targets;
    (void)descriptor_table;
    (void)callbackMode;
    (void)callback;
    (void)tables;
    return lean_wgpu_io_error(
        "Device.createRenderPipelineAsync: not implemented by wgpu-native"
    );
    #endif
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPURenderBundleEncoder result = wgpuDeviceCreateRenderBundleEncoder(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createRenderBundleEncoder returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_render_bundle_encoder_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPURenderPipeline result = wgpuDeviceCreateRenderPipeline(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createRenderPipeline returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_render_pipeline_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUSampler result = wgpuDeviceCreateSampler(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createSampler returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_sampler_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUShaderModule result = wgpuDeviceCreateShaderModule(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createShaderModule returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_shader_module_box(result))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUTexture result = wgpuDeviceCreateTexture(
        lean_wgpu_device_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.createTexture returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_texture_box(result))
    );
}

// Lean's `Device.destroy`: calls `wgpuDeviceDestroy`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceDestroy(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuDeviceDestroy(lean_wgpu_device_unbox(self));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `Device.getLostFuture`: calls `wgpuDeviceGetLostFuture`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceGetLostFuture(b_lean_obj_arg self) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUFuture result = wgpuDeviceGetLostFuture(lean_wgpu_device_unbox(self));
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64(result.id))
    );
    #else
    (void)self;
    return lean_wgpu_io_error(
        "Device.getLostFuture: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Device.hasFeature`: calls `wgpuDeviceHasFeature`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceHasFeature(
    b_lean_obj_arg self,
    uint32_t       feature
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBool result = wgpuDeviceHasFeature(
        lean_wgpu_device_unbox(self),
        (WGPUFeatureName)feature
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box(result != 0))
    );
}

// Lean's `Device.getQueue`: calls `wgpuDeviceGetQueue`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceGetQueue(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUQueue result = wgpuDeviceGetQueue(lean_wgpu_device_unbox(self));
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Device.getQueue returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_device_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_queue_box(result))
    );
}

// Lean's `Device.pushErrorScope`: calls `wgpuDevicePushErrorScope`.
LEAN_EXPORT lean_obj_res lean_wgpuDevicePushErrorScope(
    b_lean_obj_arg self,
    uint32_t       filter
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuDevicePushErrorScope(
        lean_wgpu_device_unbox(self),
        (WGPUErrorFilter)filter
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `Device.popErrorScope`: calls `wgpuDevicePopErrorScope`.
LEAN_EXPORT lean_obj_res lean_wgpuDevicePopErrorScope(
    b_lean_obj_arg self,
    uint32_t       callbackMode,
    b_lean_obj_arg callback
) {
    lean_wgpu_family family = lean_wgpu_family_of(lean_wgpu_device_unbox(self));
    lean_wgpu_family_retain(family);
    WGPUPopErrorScopeCallbackInfo callbackInfo = {
        .nextInChain = NULL,
        .mode        = (WGPUCallbackMode)callbackMode,
        .callback    = lean_WGPUPopErrorScopeCallback,
        .userdata1   = lean_wgpu_closure_hold(callback),
        .userdata2   = (void *)family,
    };
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUFuture result = wgpuDevicePopErrorScope(
        lean_wgpu_device_unbox(self),
        callbackInfo
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64(result.id))
    );
}

// Lean's `Device.setLabel`: calls `wgpuDeviceSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuDeviceSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuDeviceSetLabel(
        lean_wgpu_device_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuExternalTextureSetLabel(
        lean_wgpu_external_texture_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBool result = wgpuInstanceHasWGSLLanguageFeature(
        lean_wgpu_instance_unbox(self),
        (WGPUWGSLLanguageFeatureName)feature
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box(result != 0))
    );
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuInstanceProcessEvents(lean_wgpu_instance_unbox(self));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `Instance.requestAdapter`: calls `wgpuInstanceRequestAdapter`.
LEAN_EXPORT lean_obj_res lean_wgpuInstanceRequestAdapter(
    b_lean_obj_arg self,
    b_lean_obj_arg options,
    b_lean_obj_arg options_bytes,
    b_lean_obj_arg options_targets,
    b_lean_obj_arg options_table,
    uint32_t       callbackMode,
    b_lean_obj_arg callback,
    b_lean_obj_arg tables
) {
    lean_wgpu_family family = lean_wgpu_family_of(
        lean_wgpu_instance_unbox(self)
    );
    lean_wgpu_family_retain(family);
    (void)options;
    void const * options_struct = lean_wgpu_fill_arg(
        options_bytes,
        tables,
        lean_usize_of_nat(options_table),
        options_targets
    );
    WGPURequestAdapterCallbackInfo callbackInfo = {
        .nextInChain = NULL,
        .mode        = (WGPUCallbackMode)callbackMode,
        .callback    = lean_WGPURequestAdapterCallback,
        .userdata1   = lean_wgpu_closure_hold(callback),
        .userdata2   = (void *)family,
    };
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUFuture result = wgpuInstanceRequestAdapter(
        lean_wgpu_instance_unbox(self),
        options_struct,
        callbackInfo
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64(result.id))
    );
}

// Lean's `PipelineLayout.setLabel`: calls `wgpuPipelineLayoutSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuPipelineLayoutSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuPipelineLayoutSetLabel(
        lean_wgpu_pipeline_layout_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuQuerySetSetLabel(
        lean_wgpu_query_set_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUQueryType result = wgpuQuerySetGetType(lean_wgpu_query_set_unbox(self));
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32((uint32_t)result))
    );
}

// Lean's `QuerySet.getCount`: calls `wgpuQuerySetGetCount`.
LEAN_EXPORT lean_obj_res lean_wgpuQuerySetGetCount(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    uint32_t result = wgpuQuerySetGetCount(lean_wgpu_query_set_unbox(self));
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32(result))
    );
}

// Lean's `QuerySet.destroy`: calls `wgpuQuerySetDestroy`.
LEAN_EXPORT lean_obj_res lean_wgpuQuerySetDestroy(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuQuerySetDestroy(lean_wgpu_query_set_unbox(self));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `Queue.onSubmittedWorkDone`: calls `wgpuQueueOnSubmittedWorkDone`.
LEAN_EXPORT lean_obj_res lean_wgpuQueueOnSubmittedWorkDone(
    b_lean_obj_arg self,
    uint32_t       callbackMode,
    b_lean_obj_arg callback
) {
    lean_wgpu_family family = lean_wgpu_family_of(lean_wgpu_queue_unbox(self));
    lean_wgpu_family_retain(family);
    WGPUQueueWorkDoneCallbackInfo callbackInfo = {
        .nextInChain = NULL,
        .mode        = (WGPUCallbackMode)callbackMode,
        .callback    = lean_WGPUQueueWorkDoneCallback,
        .userdata1   = lean_wgpu_closure_hold(callback),
        .userdata2   = (void *)family,
    };
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUFuture result = wgpuQueueOnSubmittedWorkDone(
        lean_wgpu_queue_unbox(self),
        callbackInfo
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64(result.id))
    );
}

// Lean's `Queue.setLabel`: calls `wgpuQueueSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuQueueSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuQueueSetLabel(
        lean_wgpu_queue_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleSetLabel(
        lean_wgpu_render_bundle_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderSetPipeline(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_render_pipeline_unbox(pipeline)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderBundleEncoder.draw`: calls `wgpuRenderBundleEncoderDraw`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderDraw(
    b_lean_obj_arg self,
    uint32_t       vertexCount,
    uint32_t       instanceCount,
    uint32_t       firstVertex,
    uint32_t       firstInstance
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderDraw(
        lean_wgpu_render_bundle_encoder_unbox(self),
        vertexCount,
        instanceCount,
        firstVertex,
        firstInstance
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderDrawIndexed(
        lean_wgpu_render_bundle_encoder_unbox(self),
        indexCount,
        instanceCount,
        firstIndex,
        (int32_t)baseVertex,
        firstInstance
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderBundleEncoder.drawIndirect`: calls
// `wgpuRenderBundleEncoderDrawIndirect`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderDrawIndirect(
    b_lean_obj_arg self,
    b_lean_obj_arg indirectBuffer,
    uint64_t       indirectOffset
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderDrawIndirect(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_buffer_unbox(indirectBuffer),
        indirectOffset
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderBundleEncoder.drawIndexedIndirect`: calls
// `wgpuRenderBundleEncoderDrawIndexedIndirect`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderDrawIndexedIndirect(
    b_lean_obj_arg self,
    b_lean_obj_arg indirectBuffer,
    uint64_t       indirectOffset
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderDrawIndexedIndirect(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_buffer_unbox(indirectBuffer),
        indirectOffset
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderBundleEncoder.insertDebugMarker`: calls
// `wgpuRenderBundleEncoderInsertDebugMarker`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderInsertDebugMarker(
    b_lean_obj_arg self,
    b_lean_obj_arg markerLabel
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderInsertDebugMarker(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_string_view(markerLabel)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderBundleEncoder.popDebugGroup`: calls
// `wgpuRenderBundleEncoderPopDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderPopDebugGroup(
    b_lean_obj_arg self
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderPopDebugGroup(
        lean_wgpu_render_bundle_encoder_unbox(self)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderBundleEncoder.pushDebugGroup`: calls
// `wgpuRenderBundleEncoderPushDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderPushDebugGroup(
    b_lean_obj_arg self,
    b_lean_obj_arg groupLabel
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderPushDebugGroup(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_string_view(groupLabel)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderSetVertexBuffer(
        lean_wgpu_render_bundle_encoder_unbox(self),
        slot,
        lean_wgpu_buffer_unbox_option(buffer),
        offset,
        size
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderSetIndexBuffer(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_buffer_unbox(buffer),
        (WGPUIndexFormat)format,
        offset,
        size
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPURenderBundle result = wgpuRenderBundleEncoderFinish(
        lean_wgpu_render_bundle_encoder_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("RenderBundleEncoder.finish returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_render_bundle_encoder_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_render_bundle_box(result))
    );
}

// Lean's `RenderBundleEncoder.setLabel`: calls
// `wgpuRenderBundleEncoderSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderBundleEncoderSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderBundleEncoderSetLabel(
        lean_wgpu_render_bundle_encoder_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderSetPipeline(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_render_pipeline_unbox(pipeline)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.draw`: calls `wgpuRenderPassEncoderDraw`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderDraw(
    b_lean_obj_arg self,
    uint32_t       vertexCount,
    uint32_t       instanceCount,
    uint32_t       firstVertex,
    uint32_t       firstInstance
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderDraw(
        lean_wgpu_render_pass_encoder_unbox(self),
        vertexCount,
        instanceCount,
        firstVertex,
        firstInstance
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderDrawIndexed(
        lean_wgpu_render_pass_encoder_unbox(self),
        indexCount,
        instanceCount,
        firstIndex,
        (int32_t)baseVertex,
        firstInstance
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.drawIndirect`: calls
// `wgpuRenderPassEncoderDrawIndirect`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderDrawIndirect(
    b_lean_obj_arg self,
    b_lean_obj_arg indirectBuffer,
    uint64_t       indirectOffset
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderDrawIndirect(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_buffer_unbox(indirectBuffer),
        indirectOffset
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.drawIndexedIndirect`: calls
// `wgpuRenderPassEncoderDrawIndexedIndirect`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderDrawIndexedIndirect(
    b_lean_obj_arg self,
    b_lean_obj_arg indirectBuffer,
    uint64_t       indirectOffset
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderDrawIndexedIndirect(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_buffer_unbox(indirectBuffer),
        indirectOffset
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.insertDebugMarker`: calls
// `wgpuRenderPassEncoderInsertDebugMarker`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderInsertDebugMarker(
    b_lean_obj_arg self,
    b_lean_obj_arg markerLabel
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderInsertDebugMarker(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_string_view(markerLabel)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.popDebugGroup`: calls
// `wgpuRenderPassEncoderPopDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderPopDebugGroup(
    b_lean_obj_arg self
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderPopDebugGroup(
        lean_wgpu_render_pass_encoder_unbox(self)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.pushDebugGroup`: calls
// `wgpuRenderPassEncoderPushDebugGroup`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderPushDebugGroup(
    b_lean_obj_arg self,
    b_lean_obj_arg groupLabel
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderPushDebugGroup(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_string_view(groupLabel)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.setStencilReference`: calls
// `wgpuRenderPassEncoderSetStencilReference`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderSetStencilReference(
    b_lean_obj_arg self,
    uint32_t       reference
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderSetStencilReference(
        lean_wgpu_render_pass_encoder_unbox(self),
        reference
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderSetBlendConstant(
        lean_wgpu_render_pass_encoder_unbox(self),
        color_struct
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderSetViewport(
        lean_wgpu_render_pass_encoder_unbox(self),
        x,
        y,
        width,
        height,
        minDepth,
        maxDepth
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderSetScissorRect(
        lean_wgpu_render_pass_encoder_unbox(self),
        x,
        y,
        width,
        height
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderSetVertexBuffer(
        lean_wgpu_render_pass_encoder_unbox(self),
        slot,
        lean_wgpu_buffer_unbox_option(buffer),
        offset,
        size
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderSetIndexBuffer(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_buffer_unbox(buffer),
        (WGPUIndexFormat)format,
        offset,
        size
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.beginOcclusionQuery`: calls
// `wgpuRenderPassEncoderBeginOcclusionQuery`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderBeginOcclusionQuery(
    b_lean_obj_arg self,
    uint32_t       queryIndex
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderBeginOcclusionQuery(
        lean_wgpu_render_pass_encoder_unbox(self),
        queryIndex
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.endOcclusionQuery`: calls
// `wgpuRenderPassEncoderEndOcclusionQuery`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderEndOcclusionQuery(
    b_lean_obj_arg self
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderEndOcclusionQuery(
        lean_wgpu_render_pass_encoder_unbox(self)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.«end»`: calls `wgpuRenderPassEncoderEnd`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderEnd(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderEnd(lean_wgpu_render_pass_encoder_unbox(self));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `RenderPassEncoder.setLabel`: calls `wgpuRenderPassEncoderSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPassEncoderSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPassEncoderSetLabel(
        lean_wgpu_render_pass_encoder_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUBindGroupLayout result = wgpuRenderPipelineGetBindGroupLayout(
        lean_wgpu_render_pipeline_unbox(self),
        groupIndex
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error(
                "RenderPipeline.getBindGroupLayout returned NULL"
            )
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_render_pipeline_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_bind_group_layout_box(result))
    );
}

// Lean's `RenderPipeline.setLabel`: calls `wgpuRenderPipelineSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuRenderPipelineSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuRenderPipelineSetLabel(
        lean_wgpu_render_pipeline_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuSamplerSetLabel(
        lean_wgpu_sampler_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuShaderModuleSetLabel(
        lean_wgpu_shader_module_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuSurfaceConfigure(lean_wgpu_surface_unbox(self), config_struct);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `Surface.present`: calls `wgpuSurfacePresent`.
LEAN_EXPORT lean_obj_res lean_wgpuSurfacePresent(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUStatus result = wgpuSurfacePresent(lean_wgpu_surface_unbox(self));
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32((uint32_t)result))
    );
}

// Lean's `Surface.unconfigure`: calls `wgpuSurfaceUnconfigure`.
LEAN_EXPORT lean_obj_res lean_wgpuSurfaceUnconfigure(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuSurfaceUnconfigure(lean_wgpu_surface_unbox(self));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `Surface.setLabel`: calls `wgpuSurfaceSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuSurfaceSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuSurfaceSetLabel(
        lean_wgpu_surface_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUTextureView result = wgpuTextureCreateView(
        lean_wgpu_texture_unbox(self),
        descriptor_struct
    );
    if (result == NULL) {
        return lean_wgpu_callbacks_leave(
            saved,
            lean_wgpu_io_error("Texture.createView returned NULL")
        );
    }
    lean_wgpu_family_join(
        result,
        lean_wgpu_family_of(lean_wgpu_texture_unbox(self))
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_wgpu_texture_view_box(result))
    );
}

// Lean's `Texture.setLabel`: calls `wgpuTextureSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuTextureSetLabel(
        lean_wgpu_texture_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
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
    lean_object * saved = lean_wgpu_callbacks_enter();
    uint32_t result = wgpuTextureGetWidth(lean_wgpu_texture_unbox(self));
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32(result))
    );
}

// Lean's `Texture.getHeight`: calls `wgpuTextureGetHeight`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetHeight(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    uint32_t result = wgpuTextureGetHeight(lean_wgpu_texture_unbox(self));
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32(result))
    );
}

// Lean's `Texture.getDepthOrArrayLayers`: calls
// `wgpuTextureGetDepthOrArrayLayers`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetDepthOrArrayLayers(
    b_lean_obj_arg self
) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    uint32_t result = wgpuTextureGetDepthOrArrayLayers(
        lean_wgpu_texture_unbox(self)
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32(result))
    );
}

// Lean's `Texture.getMipLevelCount`: calls `wgpuTextureGetMipLevelCount`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetMipLevelCount(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    uint32_t result = wgpuTextureGetMipLevelCount(
        lean_wgpu_texture_unbox(self)
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32(result))
    );
}

// Lean's `Texture.getSampleCount`: calls `wgpuTextureGetSampleCount`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetSampleCount(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    uint32_t result = wgpuTextureGetSampleCount(lean_wgpu_texture_unbox(self));
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32(result))
    );
}

// Lean's `Texture.getDimension`: calls `wgpuTextureGetDimension`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetDimension(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUTextureDimension result = wgpuTextureGetDimension(
        lean_wgpu_texture_unbox(self)
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32((uint32_t)result))
    );
}

// Lean's `Texture.getTextureBindingViewDimension`: calls
// `wgpuTextureGetTextureBindingViewDimension`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetTextureBindingViewDimension(
    b_lean_obj_arg self
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUTextureViewDimension result = wgpuTextureGetTextureBindingViewDimension(
        lean_wgpu_texture_unbox(self)
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32((uint32_t)result))
    );
    #else
    (void)self;
    return lean_wgpu_io_error(
        "Texture.getTextureBindingViewDimension: not implemented by wgpu-native"
    );
    #endif
}

// Lean's `Texture.getFormat`: calls `wgpuTextureGetFormat`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetFormat(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUTextureFormat result = wgpuTextureGetFormat(
        lean_wgpu_texture_unbox(self)
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint32((uint32_t)result))
    );
}

// Lean's `Texture.getUsage`: calls `wgpuTextureGetUsage`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureGetUsage(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUTextureUsage result = wgpuTextureGetUsage(
        lean_wgpu_texture_unbox(self)
    );
    return lean_wgpu_callbacks_leave(
        saved,
        lean_io_result_mk_ok(lean_box_uint64((uint64_t)result))
    );
}

// Lean's `Texture.destroy`: calls `wgpuTextureDestroy`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureDestroy(b_lean_obj_arg self) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuTextureDestroy(lean_wgpu_texture_unbox(self));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Lean's `TextureView.setLabel`: calls `wgpuTextureViewSetLabel`.
LEAN_EXPORT lean_obj_res lean_wgpuTextureViewSetLabel(
    b_lean_obj_arg self,
    b_lean_obj_arg label
) {
    #ifdef WEBGPU_RAW_DAWN
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuTextureViewSetLabel(
        lean_wgpu_texture_view_unbox(self),
        lean_wgpu_string_view(label)
    );
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
    #else
    (void)self;
    (void)label;
    return lean_wgpu_io_error(
        "TextureView.setLabel: not implemented by wgpu-native"
    );
    #endif
}
