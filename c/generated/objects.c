/*
================================================================================
  GENERATED FILE: DO NOT EDIT BY HAND

  Generator:        webgpu-gen
  Generator commit: 0348310 (clean)
  Generated:        2026-11-05 04:04:48 UTC
  Source:           vendor/webgpu-headers/webgpu.yml
  Source repo:      https://github.com/webgpu-native/webgpu-headers
  Source commit:    673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
  Source date:      2026-05-07
  Source pinned by: wgpu-native v29.0.1.1
================================================================================
*/

#include "objects.h"

// An object holds no Lean values, so there are none to visit.
static void lean_wgpu_visit_nothing(
    void *         data,
    b_lean_obj_arg visitor
) {
    (void)data;
    (void)visitor;
}

static lean_external_class * lean_wgpu_adapter_class               = NULL;
static lean_external_class * lean_wgpu_bind_group_class            = NULL;
static lean_external_class * lean_wgpu_bind_group_layout_class     = NULL;
static lean_external_class * lean_wgpu_buffer_class                = NULL;
static lean_external_class * lean_wgpu_command_buffer_class        = NULL;
static lean_external_class * lean_wgpu_command_encoder_class       = NULL;
static lean_external_class * lean_wgpu_compute_pass_encoder_class  = NULL;
static lean_external_class * lean_wgpu_compute_pipeline_class      = NULL;
static lean_external_class * lean_wgpu_device_class                = NULL;
static lean_external_class * lean_wgpu_external_texture_class      = NULL;
static lean_external_class * lean_wgpu_instance_class              = NULL;
static lean_external_class * lean_wgpu_pipeline_layout_class       = NULL;
static lean_external_class * lean_wgpu_query_set_class             = NULL;
static lean_external_class * lean_wgpu_queue_class                 = NULL;
static lean_external_class * lean_wgpu_render_bundle_class         = NULL;
static lean_external_class * lean_wgpu_render_bundle_encoder_class = NULL;
static lean_external_class * lean_wgpu_render_pass_encoder_class   = NULL;
static lean_external_class * lean_wgpu_render_pipeline_class       = NULL;
static lean_external_class * lean_wgpu_sampler_class               = NULL;
static lean_external_class * lean_wgpu_shader_module_class         = NULL;
static lean_external_class * lean_wgpu_surface_class               = NULL;
static lean_external_class * lean_wgpu_texture_class               = NULL;
static lean_external_class * lean_wgpu_texture_view_class          = NULL;

// Release the reference a Lean `Adapter` owned, when Lean frees it.
static void lean_wgpu_adapter_finalize(void * data) {
    wgpuAdapterRelease((WGPUAdapter)data);
}

// Release the reference a Lean `BindGroup` owned, when Lean frees it.
static void lean_wgpu_bind_group_finalize(void * data) {
    wgpuBindGroupRelease((WGPUBindGroup)data);
}

// Release the reference a Lean `BindGroupLayout` owned, when Lean frees it.
static void lean_wgpu_bind_group_layout_finalize(void * data) {
    wgpuBindGroupLayoutRelease((WGPUBindGroupLayout)data);
}

// Release the reference a Lean `Buffer` owned, when Lean frees it.
static void lean_wgpu_buffer_finalize(void * data) {
    wgpuBufferRelease((WGPUBuffer)data);
}

// Release the reference a Lean `CommandBuffer` owned, when Lean frees it.
static void lean_wgpu_command_buffer_finalize(void * data) {
    wgpuCommandBufferRelease((WGPUCommandBuffer)data);
}

// Release the reference a Lean `CommandEncoder` owned, when Lean frees it.
static void lean_wgpu_command_encoder_finalize(void * data) {
    wgpuCommandEncoderRelease((WGPUCommandEncoder)data);
}

// Release the reference a Lean `ComputePassEncoder` owned, when Lean frees it.
static void lean_wgpu_compute_pass_encoder_finalize(void * data) {
    wgpuComputePassEncoderRelease((WGPUComputePassEncoder)data);
}

// Release the reference a Lean `ComputePipeline` owned, when Lean frees it.
static void lean_wgpu_compute_pipeline_finalize(void * data) {
    wgpuComputePipelineRelease((WGPUComputePipeline)data);
}

// Release the reference a Lean `Device` owned, when Lean frees it.
static void lean_wgpu_device_finalize(void * data) {
    wgpuDeviceRelease((WGPUDevice)data);
}

// Release the reference a Lean `ExternalTexture` owned, when Lean frees it.
static void lean_wgpu_external_texture_finalize(void * data) {
    wgpuExternalTextureRelease((WGPUExternalTexture)data);
}

// Release the reference a Lean `Instance` owned, when Lean frees it.
static void lean_wgpu_instance_finalize(void * data) {
    wgpuInstanceRelease((WGPUInstance)data);
}

// Release the reference a Lean `PipelineLayout` owned, when Lean frees it.
static void lean_wgpu_pipeline_layout_finalize(void * data) {
    wgpuPipelineLayoutRelease((WGPUPipelineLayout)data);
}

// Release the reference a Lean `QuerySet` owned, when Lean frees it.
static void lean_wgpu_query_set_finalize(void * data) {
    wgpuQuerySetRelease((WGPUQuerySet)data);
}

// Release the reference a Lean `Queue` owned, when Lean frees it.
static void lean_wgpu_queue_finalize(void * data) {
    wgpuQueueRelease((WGPUQueue)data);
}

// Release the reference a Lean `RenderBundle` owned, when Lean frees it.
static void lean_wgpu_render_bundle_finalize(void * data) {
    wgpuRenderBundleRelease((WGPURenderBundle)data);
}

// Release the reference a Lean `RenderBundleEncoder` owned, when Lean frees it.
static void lean_wgpu_render_bundle_encoder_finalize(void * data) {
    wgpuRenderBundleEncoderRelease((WGPURenderBundleEncoder)data);
}

// Release the reference a Lean `RenderPassEncoder` owned, when Lean frees it.
static void lean_wgpu_render_pass_encoder_finalize(void * data) {
    wgpuRenderPassEncoderRelease((WGPURenderPassEncoder)data);
}

// Release the reference a Lean `RenderPipeline` owned, when Lean frees it.
static void lean_wgpu_render_pipeline_finalize(void * data) {
    wgpuRenderPipelineRelease((WGPURenderPipeline)data);
}

// Release the reference a Lean `Sampler` owned, when Lean frees it.
static void lean_wgpu_sampler_finalize(void * data) {
    wgpuSamplerRelease((WGPUSampler)data);
}

// Release the reference a Lean `ShaderModule` owned, when Lean frees it.
static void lean_wgpu_shader_module_finalize(void * data) {
    wgpuShaderModuleRelease((WGPUShaderModule)data);
}

// Release the reference a Lean `Surface` owned, when Lean frees it.
static void lean_wgpu_surface_finalize(void * data) {
    wgpuSurfaceRelease((WGPUSurface)data);
}

// Release the reference a Lean `Texture` owned, when Lean frees it.
static void lean_wgpu_texture_finalize(void * data) {
    wgpuTextureRelease((WGPUTexture)data);
}

// Release the reference a Lean `TextureView` owned, when Lean frees it.
static void lean_wgpu_texture_view_finalize(void * data) {
    wgpuTextureViewRelease((WGPUTextureView)data);
}

// The bindings' start-up, run by Lean when a program using them starts:
// register every object type's external class.
LEAN_EXPORT lean_obj_res lean_wgpu_objects_init(void) {
    lean_wgpu_adapter_class = lean_register_external_class(
        lean_wgpu_adapter_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_bind_group_class = lean_register_external_class(
        lean_wgpu_bind_group_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_bind_group_layout_class = lean_register_external_class(
        lean_wgpu_bind_group_layout_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_buffer_class = lean_register_external_class(
        lean_wgpu_buffer_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_command_buffer_class = lean_register_external_class(
        lean_wgpu_command_buffer_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_command_encoder_class = lean_register_external_class(
        lean_wgpu_command_encoder_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_compute_pass_encoder_class = lean_register_external_class(
        lean_wgpu_compute_pass_encoder_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_compute_pipeline_class = lean_register_external_class(
        lean_wgpu_compute_pipeline_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_device_class = lean_register_external_class(
        lean_wgpu_device_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_external_texture_class = lean_register_external_class(
        lean_wgpu_external_texture_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_instance_class = lean_register_external_class(
        lean_wgpu_instance_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_pipeline_layout_class = lean_register_external_class(
        lean_wgpu_pipeline_layout_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_query_set_class = lean_register_external_class(
        lean_wgpu_query_set_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_queue_class = lean_register_external_class(
        lean_wgpu_queue_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_render_bundle_class = lean_register_external_class(
        lean_wgpu_render_bundle_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_render_bundle_encoder_class = lean_register_external_class(
        lean_wgpu_render_bundle_encoder_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_render_pass_encoder_class = lean_register_external_class(
        lean_wgpu_render_pass_encoder_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_render_pipeline_class = lean_register_external_class(
        lean_wgpu_render_pipeline_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_sampler_class = lean_register_external_class(
        lean_wgpu_sampler_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_shader_module_class = lean_register_external_class(
        lean_wgpu_shader_module_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_surface_class = lean_register_external_class(
        lean_wgpu_surface_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_texture_class = lean_register_external_class(
        lean_wgpu_texture_finalize,
        lean_wgpu_visit_nothing
    );
    lean_wgpu_texture_view_class = lean_register_external_class(
        lean_wgpu_texture_view_finalize,
        lean_wgpu_visit_nothing
    );
    return lean_io_result_mk_ok(lean_box(0));
}

// A Lean `Adapter` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_adapter_box(WGPUAdapter handle) {
    if (handle == NULL) {
        lean_internal_panic("lean_wgpu_adapter_box: a NULL WGPUAdapter");
    }
    if (lean_wgpu_adapter_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_adapter_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_adapter_class, handle);
}

// The `WGPUAdapter` a Lean `Adapter` holds; the Lean value keeps the reference.
WGPUAdapter lean_wgpu_adapter_unbox(b_lean_obj_arg object) {
    return (WGPUAdapter)lean_get_external_data(object);
}

// A Lean `Option Adapter`: `none` for NULL, and otherwise owning the reference
// `handle`.
lean_obj_res lean_wgpu_adapter_box_option(WGPUAdapter handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_adapter_box(handle));
    return some;
}

// The `WGPUAdapter` a Lean `Option Adapter` holds, or NULL for `none`; the Lean
// value keeps the reference.
WGPUAdapter lean_wgpu_adapter_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_adapter_unbox(lean_ctor_get(option, 0));
}

// A Lean `BindGroup` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_bind_group_box(WGPUBindGroup handle) {
    if (handle == NULL) {
        lean_internal_panic("lean_wgpu_bind_group_box: a NULL WGPUBindGroup");
    }
    if (lean_wgpu_bind_group_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_bind_group_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_bind_group_class, handle);
}

// The `WGPUBindGroup` a Lean `BindGroup` holds; the Lean value keeps the
// reference.
WGPUBindGroup lean_wgpu_bind_group_unbox(b_lean_obj_arg object) {
    return (WGPUBindGroup)lean_get_external_data(object);
}

// A Lean `Option BindGroup`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_bind_group_box_option(WGPUBindGroup handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_bind_group_box(handle));
    return some;
}

// The `WGPUBindGroup` a Lean `Option BindGroup` holds, or NULL for `none`; the
// Lean value keeps the reference.
WGPUBindGroup lean_wgpu_bind_group_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_bind_group_unbox(lean_ctor_get(option, 0));
}

// A Lean `BindGroupLayout` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_bind_group_layout_box(WGPUBindGroupLayout handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_bind_group_layout_box: a NULL WGPUBindGroupLayout"
        );
    }
    if (lean_wgpu_bind_group_layout_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_bind_group_layout_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_bind_group_layout_class, handle);
}

// The `WGPUBindGroupLayout` a Lean `BindGroupLayout` holds; the Lean value
// keeps the reference.
WGPUBindGroupLayout lean_wgpu_bind_group_layout_unbox(b_lean_obj_arg object) {
    return (WGPUBindGroupLayout)lean_get_external_data(object);
}

// A Lean `Option BindGroupLayout`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_bind_group_layout_box_option(
    WGPUBindGroupLayout handle
) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_bind_group_layout_box(handle));
    return some;
}

// The `WGPUBindGroupLayout` a Lean `Option BindGroupLayout` holds, or NULL for
// `none`; the Lean value keeps the reference.
WGPUBindGroupLayout lean_wgpu_bind_group_layout_unbox_option(
    b_lean_obj_arg option
) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_bind_group_layout_unbox(lean_ctor_get(option, 0));
}

// A Lean `Buffer` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_buffer_box(WGPUBuffer handle) {
    if (handle == NULL) {
        lean_internal_panic("lean_wgpu_buffer_box: a NULL WGPUBuffer");
    }
    if (lean_wgpu_buffer_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_buffer_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_buffer_class, handle);
}

// The `WGPUBuffer` a Lean `Buffer` holds; the Lean value keeps the reference.
WGPUBuffer lean_wgpu_buffer_unbox(b_lean_obj_arg object) {
    return (WGPUBuffer)lean_get_external_data(object);
}

// A Lean `Option Buffer`: `none` for NULL, and otherwise owning the reference
// `handle`.
lean_obj_res lean_wgpu_buffer_box_option(WGPUBuffer handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_buffer_box(handle));
    return some;
}

// The `WGPUBuffer` a Lean `Option Buffer` holds, or NULL for `none`; the Lean
// value keeps the reference.
WGPUBuffer lean_wgpu_buffer_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_buffer_unbox(lean_ctor_get(option, 0));
}

// A Lean `CommandBuffer` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_command_buffer_box(WGPUCommandBuffer handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_command_buffer_box: a NULL WGPUCommandBuffer"
        );
    }
    if (lean_wgpu_command_buffer_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_command_buffer_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_command_buffer_class, handle);
}

// The `WGPUCommandBuffer` a Lean `CommandBuffer` holds; the Lean value keeps
// the reference.
WGPUCommandBuffer lean_wgpu_command_buffer_unbox(b_lean_obj_arg object) {
    return (WGPUCommandBuffer)lean_get_external_data(object);
}

// A Lean `Option CommandBuffer`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_command_buffer_box_option(WGPUCommandBuffer handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_command_buffer_box(handle));
    return some;
}

// The `WGPUCommandBuffer` a Lean `Option CommandBuffer` holds, or NULL for
// `none`; the Lean value keeps the reference.
WGPUCommandBuffer lean_wgpu_command_buffer_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_command_buffer_unbox(lean_ctor_get(option, 0));
}

// A Lean `CommandEncoder` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_command_encoder_box(WGPUCommandEncoder handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_command_encoder_box: a NULL WGPUCommandEncoder"
        );
    }
    if (lean_wgpu_command_encoder_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_command_encoder_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_command_encoder_class, handle);
}

// The `WGPUCommandEncoder` a Lean `CommandEncoder` holds; the Lean value keeps
// the reference.
WGPUCommandEncoder lean_wgpu_command_encoder_unbox(b_lean_obj_arg object) {
    return (WGPUCommandEncoder)lean_get_external_data(object);
}

// A Lean `Option CommandEncoder`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_command_encoder_box_option(WGPUCommandEncoder handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_command_encoder_box(handle));
    return some;
}

// The `WGPUCommandEncoder` a Lean `Option CommandEncoder` holds, or NULL for
// `none`; the Lean value keeps the reference.
WGPUCommandEncoder lean_wgpu_command_encoder_unbox_option(
    b_lean_obj_arg option
) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_command_encoder_unbox(lean_ctor_get(option, 0));
}

// A Lean `ComputePassEncoder` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_compute_pass_encoder_box(WGPUComputePassEncoder handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_compute_pass_encoder_box: a NULL WGPUComputePassEncoder"
        );
    }
    if (lean_wgpu_compute_pass_encoder_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_compute_pass_encoder_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_compute_pass_encoder_class, handle);
}

// The `WGPUComputePassEncoder` a Lean `ComputePassEncoder` holds; the Lean
// value keeps the reference.
WGPUComputePassEncoder lean_wgpu_compute_pass_encoder_unbox(
    b_lean_obj_arg object
) {
    return (WGPUComputePassEncoder)lean_get_external_data(object);
}

// A Lean `Option ComputePassEncoder`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_compute_pass_encoder_box_option(
    WGPUComputePassEncoder handle
) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_compute_pass_encoder_box(handle));
    return some;
}

// The `WGPUComputePassEncoder` a Lean `Option ComputePassEncoder` holds, or
// NULL for `none`; the Lean value keeps the reference.
WGPUComputePassEncoder lean_wgpu_compute_pass_encoder_unbox_option(
    b_lean_obj_arg option
) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_compute_pass_encoder_unbox(lean_ctor_get(option, 0));
}

// A Lean `ComputePipeline` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_compute_pipeline_box(WGPUComputePipeline handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_compute_pipeline_box: a NULL WGPUComputePipeline"
        );
    }
    if (lean_wgpu_compute_pipeline_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_compute_pipeline_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_compute_pipeline_class, handle);
}

// The `WGPUComputePipeline` a Lean `ComputePipeline` holds; the Lean value
// keeps the reference.
WGPUComputePipeline lean_wgpu_compute_pipeline_unbox(b_lean_obj_arg object) {
    return (WGPUComputePipeline)lean_get_external_data(object);
}

// A Lean `Option ComputePipeline`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_compute_pipeline_box_option(WGPUComputePipeline handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_compute_pipeline_box(handle));
    return some;
}

// The `WGPUComputePipeline` a Lean `Option ComputePipeline` holds, or NULL for
// `none`; the Lean value keeps the reference.
WGPUComputePipeline lean_wgpu_compute_pipeline_unbox_option(
    b_lean_obj_arg option
) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_compute_pipeline_unbox(lean_ctor_get(option, 0));
}

// A Lean `Device` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_device_box(WGPUDevice handle) {
    if (handle == NULL) {
        lean_internal_panic("lean_wgpu_device_box: a NULL WGPUDevice");
    }
    if (lean_wgpu_device_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_device_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_device_class, handle);
}

// The `WGPUDevice` a Lean `Device` holds; the Lean value keeps the reference.
WGPUDevice lean_wgpu_device_unbox(b_lean_obj_arg object) {
    return (WGPUDevice)lean_get_external_data(object);
}

// A Lean `Option Device`: `none` for NULL, and otherwise owning the reference
// `handle`.
lean_obj_res lean_wgpu_device_box_option(WGPUDevice handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_device_box(handle));
    return some;
}

// The `WGPUDevice` a Lean `Option Device` holds, or NULL for `none`; the Lean
// value keeps the reference.
WGPUDevice lean_wgpu_device_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_device_unbox(lean_ctor_get(option, 0));
}

// A Lean `ExternalTexture` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_external_texture_box(WGPUExternalTexture handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_external_texture_box: a NULL WGPUExternalTexture"
        );
    }
    if (lean_wgpu_external_texture_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_external_texture_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_external_texture_class, handle);
}

// The `WGPUExternalTexture` a Lean `ExternalTexture` holds; the Lean value
// keeps the reference.
WGPUExternalTexture lean_wgpu_external_texture_unbox(b_lean_obj_arg object) {
    return (WGPUExternalTexture)lean_get_external_data(object);
}

// A Lean `Option ExternalTexture`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_external_texture_box_option(WGPUExternalTexture handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_external_texture_box(handle));
    return some;
}

// The `WGPUExternalTexture` a Lean `Option ExternalTexture` holds, or NULL for
// `none`; the Lean value keeps the reference.
WGPUExternalTexture lean_wgpu_external_texture_unbox_option(
    b_lean_obj_arg option
) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_external_texture_unbox(lean_ctor_get(option, 0));
}

// A Lean `Instance` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_instance_box(WGPUInstance handle) {
    if (handle == NULL) {
        lean_internal_panic("lean_wgpu_instance_box: a NULL WGPUInstance");
    }
    if (lean_wgpu_instance_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_instance_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_instance_class, handle);
}

// The `WGPUInstance` a Lean `Instance` holds; the Lean value keeps the
// reference.
WGPUInstance lean_wgpu_instance_unbox(b_lean_obj_arg object) {
    return (WGPUInstance)lean_get_external_data(object);
}

// A Lean `Option Instance`: `none` for NULL, and otherwise owning the reference
// `handle`.
lean_obj_res lean_wgpu_instance_box_option(WGPUInstance handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_instance_box(handle));
    return some;
}

// The `WGPUInstance` a Lean `Option Instance` holds, or NULL for `none`; the
// Lean value keeps the reference.
WGPUInstance lean_wgpu_instance_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_instance_unbox(lean_ctor_get(option, 0));
}

// A Lean `PipelineLayout` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_pipeline_layout_box(WGPUPipelineLayout handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_pipeline_layout_box: a NULL WGPUPipelineLayout"
        );
    }
    if (lean_wgpu_pipeline_layout_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_pipeline_layout_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_pipeline_layout_class, handle);
}

// The `WGPUPipelineLayout` a Lean `PipelineLayout` holds; the Lean value keeps
// the reference.
WGPUPipelineLayout lean_wgpu_pipeline_layout_unbox(b_lean_obj_arg object) {
    return (WGPUPipelineLayout)lean_get_external_data(object);
}

// A Lean `Option PipelineLayout`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_pipeline_layout_box_option(WGPUPipelineLayout handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_pipeline_layout_box(handle));
    return some;
}

// The `WGPUPipelineLayout` a Lean `Option PipelineLayout` holds, or NULL for
// `none`; the Lean value keeps the reference.
WGPUPipelineLayout lean_wgpu_pipeline_layout_unbox_option(
    b_lean_obj_arg option
) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_pipeline_layout_unbox(lean_ctor_get(option, 0));
}

// A Lean `QuerySet` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_query_set_box(WGPUQuerySet handle) {
    if (handle == NULL) {
        lean_internal_panic("lean_wgpu_query_set_box: a NULL WGPUQuerySet");
    }
    if (lean_wgpu_query_set_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_query_set_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_query_set_class, handle);
}

// The `WGPUQuerySet` a Lean `QuerySet` holds; the Lean value keeps the
// reference.
WGPUQuerySet lean_wgpu_query_set_unbox(b_lean_obj_arg object) {
    return (WGPUQuerySet)lean_get_external_data(object);
}

// A Lean `Option QuerySet`: `none` for NULL, and otherwise owning the reference
// `handle`.
lean_obj_res lean_wgpu_query_set_box_option(WGPUQuerySet handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_query_set_box(handle));
    return some;
}

// The `WGPUQuerySet` a Lean `Option QuerySet` holds, or NULL for `none`; the
// Lean value keeps the reference.
WGPUQuerySet lean_wgpu_query_set_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_query_set_unbox(lean_ctor_get(option, 0));
}

// A Lean `Queue` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_queue_box(WGPUQueue handle) {
    if (handle == NULL) {
        lean_internal_panic("lean_wgpu_queue_box: a NULL WGPUQueue");
    }
    if (lean_wgpu_queue_class == NULL) {
        lean_internal_panic("lean_wgpu_queue_box: before the bindings started");
    }
    return lean_alloc_external(lean_wgpu_queue_class, handle);
}

// The `WGPUQueue` a Lean `Queue` holds; the Lean value keeps the reference.
WGPUQueue lean_wgpu_queue_unbox(b_lean_obj_arg object) {
    return (WGPUQueue)lean_get_external_data(object);
}

// A Lean `Option Queue`: `none` for NULL, and otherwise owning the reference
// `handle`.
lean_obj_res lean_wgpu_queue_box_option(WGPUQueue handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_queue_box(handle));
    return some;
}

// The `WGPUQueue` a Lean `Option Queue` holds, or NULL for `none`; the Lean
// value keeps the reference.
WGPUQueue lean_wgpu_queue_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_queue_unbox(lean_ctor_get(option, 0));
}

// A Lean `RenderBundle` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_render_bundle_box(WGPURenderBundle handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_render_bundle_box: a NULL WGPURenderBundle"
        );
    }
    if (lean_wgpu_render_bundle_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_render_bundle_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_render_bundle_class, handle);
}

// The `WGPURenderBundle` a Lean `RenderBundle` holds; the Lean value keeps the
// reference.
WGPURenderBundle lean_wgpu_render_bundle_unbox(b_lean_obj_arg object) {
    return (WGPURenderBundle)lean_get_external_data(object);
}

// A Lean `Option RenderBundle`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_render_bundle_box_option(WGPURenderBundle handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_render_bundle_box(handle));
    return some;
}

// The `WGPURenderBundle` a Lean `Option RenderBundle` holds, or NULL for
// `none`; the Lean value keeps the reference.
WGPURenderBundle lean_wgpu_render_bundle_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_render_bundle_unbox(lean_ctor_get(option, 0));
}

// A Lean `RenderBundleEncoder` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_render_bundle_encoder_box(
    WGPURenderBundleEncoder handle
) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_render_bundle_encoder_box: a NULL WGPURenderBundleEncoder"
        );
    }
    if (lean_wgpu_render_bundle_encoder_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_render_bundle_encoder_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_render_bundle_encoder_class, handle);
}

// The `WGPURenderBundleEncoder` a Lean `RenderBundleEncoder` holds; the Lean
// value keeps the reference.
WGPURenderBundleEncoder lean_wgpu_render_bundle_encoder_unbox(
    b_lean_obj_arg object
) {
    return (WGPURenderBundleEncoder)lean_get_external_data(object);
}

// A Lean `Option RenderBundleEncoder`: `none` for NULL, and otherwise owning
// the reference `handle`.
lean_obj_res lean_wgpu_render_bundle_encoder_box_option(
    WGPURenderBundleEncoder handle
) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_render_bundle_encoder_box(handle));
    return some;
}

// The `WGPURenderBundleEncoder` a Lean `Option RenderBundleEncoder` holds, or
// NULL for `none`; the Lean value keeps the reference.
WGPURenderBundleEncoder lean_wgpu_render_bundle_encoder_unbox_option(
    b_lean_obj_arg option
) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_render_bundle_encoder_unbox(lean_ctor_get(option, 0));
}

// A Lean `RenderPassEncoder` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_render_pass_encoder_box(WGPURenderPassEncoder handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_render_pass_encoder_box: a NULL WGPURenderPassEncoder"
        );
    }
    if (lean_wgpu_render_pass_encoder_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_render_pass_encoder_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_render_pass_encoder_class, handle);
}

// The `WGPURenderPassEncoder` a Lean `RenderPassEncoder` holds; the Lean value
// keeps the reference.
WGPURenderPassEncoder lean_wgpu_render_pass_encoder_unbox(
    b_lean_obj_arg object
) {
    return (WGPURenderPassEncoder)lean_get_external_data(object);
}

// A Lean `Option RenderPassEncoder`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_render_pass_encoder_box_option(
    WGPURenderPassEncoder handle
) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_render_pass_encoder_box(handle));
    return some;
}

// The `WGPURenderPassEncoder` a Lean `Option RenderPassEncoder` holds, or NULL
// for `none`; the Lean value keeps the reference.
WGPURenderPassEncoder lean_wgpu_render_pass_encoder_unbox_option(
    b_lean_obj_arg option
) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_render_pass_encoder_unbox(lean_ctor_get(option, 0));
}

// A Lean `RenderPipeline` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_render_pipeline_box(WGPURenderPipeline handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_render_pipeline_box: a NULL WGPURenderPipeline"
        );
    }
    if (lean_wgpu_render_pipeline_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_render_pipeline_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_render_pipeline_class, handle);
}

// The `WGPURenderPipeline` a Lean `RenderPipeline` holds; the Lean value keeps
// the reference.
WGPURenderPipeline lean_wgpu_render_pipeline_unbox(b_lean_obj_arg object) {
    return (WGPURenderPipeline)lean_get_external_data(object);
}

// A Lean `Option RenderPipeline`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_render_pipeline_box_option(WGPURenderPipeline handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_render_pipeline_box(handle));
    return some;
}

// The `WGPURenderPipeline` a Lean `Option RenderPipeline` holds, or NULL for
// `none`; the Lean value keeps the reference.
WGPURenderPipeline lean_wgpu_render_pipeline_unbox_option(
    b_lean_obj_arg option
) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_render_pipeline_unbox(lean_ctor_get(option, 0));
}

// A Lean `Sampler` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_sampler_box(WGPUSampler handle) {
    if (handle == NULL) {
        lean_internal_panic("lean_wgpu_sampler_box: a NULL WGPUSampler");
    }
    if (lean_wgpu_sampler_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_sampler_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_sampler_class, handle);
}

// The `WGPUSampler` a Lean `Sampler` holds; the Lean value keeps the reference.
WGPUSampler lean_wgpu_sampler_unbox(b_lean_obj_arg object) {
    return (WGPUSampler)lean_get_external_data(object);
}

// A Lean `Option Sampler`: `none` for NULL, and otherwise owning the reference
// `handle`.
lean_obj_res lean_wgpu_sampler_box_option(WGPUSampler handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_sampler_box(handle));
    return some;
}

// The `WGPUSampler` a Lean `Option Sampler` holds, or NULL for `none`; the Lean
// value keeps the reference.
WGPUSampler lean_wgpu_sampler_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_sampler_unbox(lean_ctor_get(option, 0));
}

// A Lean `ShaderModule` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_shader_module_box(WGPUShaderModule handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_shader_module_box: a NULL WGPUShaderModule"
        );
    }
    if (lean_wgpu_shader_module_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_shader_module_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_shader_module_class, handle);
}

// The `WGPUShaderModule` a Lean `ShaderModule` holds; the Lean value keeps the
// reference.
WGPUShaderModule lean_wgpu_shader_module_unbox(b_lean_obj_arg object) {
    return (WGPUShaderModule)lean_get_external_data(object);
}

// A Lean `Option ShaderModule`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_shader_module_box_option(WGPUShaderModule handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_shader_module_box(handle));
    return some;
}

// The `WGPUShaderModule` a Lean `Option ShaderModule` holds, or NULL for
// `none`; the Lean value keeps the reference.
WGPUShaderModule lean_wgpu_shader_module_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_shader_module_unbox(lean_ctor_get(option, 0));
}

// A Lean `Surface` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_surface_box(WGPUSurface handle) {
    if (handle == NULL) {
        lean_internal_panic("lean_wgpu_surface_box: a NULL WGPUSurface");
    }
    if (lean_wgpu_surface_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_surface_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_surface_class, handle);
}

// The `WGPUSurface` a Lean `Surface` holds; the Lean value keeps the reference.
WGPUSurface lean_wgpu_surface_unbox(b_lean_obj_arg object) {
    return (WGPUSurface)lean_get_external_data(object);
}

// A Lean `Option Surface`: `none` for NULL, and otherwise owning the reference
// `handle`.
lean_obj_res lean_wgpu_surface_box_option(WGPUSurface handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_surface_box(handle));
    return some;
}

// The `WGPUSurface` a Lean `Option Surface` holds, or NULL for `none`; the Lean
// value keeps the reference.
WGPUSurface lean_wgpu_surface_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_surface_unbox(lean_ctor_get(option, 0));
}

// A Lean `Texture` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_texture_box(WGPUTexture handle) {
    if (handle == NULL) {
        lean_internal_panic("lean_wgpu_texture_box: a NULL WGPUTexture");
    }
    if (lean_wgpu_texture_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_texture_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_texture_class, handle);
}

// The `WGPUTexture` a Lean `Texture` holds; the Lean value keeps the reference.
WGPUTexture lean_wgpu_texture_unbox(b_lean_obj_arg object) {
    return (WGPUTexture)lean_get_external_data(object);
}

// A Lean `Option Texture`: `none` for NULL, and otherwise owning the reference
// `handle`.
lean_obj_res lean_wgpu_texture_box_option(WGPUTexture handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_texture_box(handle));
    return some;
}

// The `WGPUTexture` a Lean `Option Texture` holds, or NULL for `none`; the Lean
// value keeps the reference.
WGPUTexture lean_wgpu_texture_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_texture_unbox(lean_ctor_get(option, 0));
}

// A Lean `TextureView` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_texture_view_box(WGPUTextureView handle) {
    if (handle == NULL) {
        lean_internal_panic(
            "lean_wgpu_texture_view_box: a NULL WGPUTextureView"
        );
    }
    if (lean_wgpu_texture_view_class == NULL) {
        lean_internal_panic(
            "lean_wgpu_texture_view_box: before the bindings started"
        );
    }
    return lean_alloc_external(lean_wgpu_texture_view_class, handle);
}

// The `WGPUTextureView` a Lean `TextureView` holds; the Lean value keeps the
// reference.
WGPUTextureView lean_wgpu_texture_view_unbox(b_lean_obj_arg object) {
    return (WGPUTextureView)lean_get_external_data(object);
}

// A Lean `Option TextureView`: `none` for NULL, and otherwise owning the
// reference `handle`.
lean_obj_res lean_wgpu_texture_view_box_option(WGPUTextureView handle) {
    if (handle == NULL) {
        return lean_box(0);
    }
    lean_object * some = lean_alloc_ctor(1, 1, 0);
    lean_ctor_set(some, 0, lean_wgpu_texture_view_box(handle));
    return some;
}

// The `WGPUTextureView` a Lean `Option TextureView` holds, or NULL for `none`;
// the Lean value keeps the reference.
WGPUTextureView lean_wgpu_texture_view_unbox_option(b_lean_obj_arg option) {
    if (lean_is_scalar(option)) {
        return NULL;
    }
    return lean_wgpu_texture_view_unbox(lean_ctor_get(option, 0));
}
