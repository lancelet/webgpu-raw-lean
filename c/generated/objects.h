/*
================================================================================
  GENERATED FILE: DO NOT EDIT BY HAND

  Generator:        webgpu-gen
  Generator commit: 2c3cfe8 (clean)
  Generated:        2026-11-02 10:04:59 UTC
  Source:           vendor/webgpu-headers/webgpu.yml
  Source repo:      https://github.com/webgpu-native/webgpu-headers
  Source commit:    673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
  Source date:      2026-05-07
  Source pinned by: wgpu-native v29.0.1.1
================================================================================
*/

#pragma once

#include <lean/lean.h>
#include <webgpu/webgpu.h>

// A Lean `Adapter` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_adapter_box(WGPUAdapter handle);

// The `WGPUAdapter` a Lean `Adapter` holds; the Lean value keeps the reference.
WGPUAdapter lean_wgpu_adapter_unbox(b_lean_obj_arg object);

// A Lean `BindGroup` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_bind_group_box(WGPUBindGroup handle);

// The `WGPUBindGroup` a Lean `BindGroup` holds; the Lean value keeps the
// reference.
WGPUBindGroup lean_wgpu_bind_group_unbox(b_lean_obj_arg object);

// A Lean `BindGroupLayout` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_bind_group_layout_box(WGPUBindGroupLayout handle);

// The `WGPUBindGroupLayout` a Lean `BindGroupLayout` holds; the Lean value
// keeps the reference.
WGPUBindGroupLayout lean_wgpu_bind_group_layout_unbox(b_lean_obj_arg object);

// A Lean `Buffer` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_buffer_box(WGPUBuffer handle);

// The `WGPUBuffer` a Lean `Buffer` holds; the Lean value keeps the reference.
WGPUBuffer lean_wgpu_buffer_unbox(b_lean_obj_arg object);

// A Lean `CommandBuffer` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_command_buffer_box(WGPUCommandBuffer handle);

// The `WGPUCommandBuffer` a Lean `CommandBuffer` holds; the Lean value keeps
// the reference.
WGPUCommandBuffer lean_wgpu_command_buffer_unbox(b_lean_obj_arg object);

// A Lean `CommandEncoder` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_command_encoder_box(WGPUCommandEncoder handle);

// The `WGPUCommandEncoder` a Lean `CommandEncoder` holds; the Lean value keeps
// the reference.
WGPUCommandEncoder lean_wgpu_command_encoder_unbox(b_lean_obj_arg object);

// A Lean `ComputePassEncoder` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_compute_pass_encoder_box(WGPUComputePassEncoder handle);

// The `WGPUComputePassEncoder` a Lean `ComputePassEncoder` holds; the Lean
// value keeps the reference.
WGPUComputePassEncoder lean_wgpu_compute_pass_encoder_unbox(b_lean_obj_arg object);

// A Lean `ComputePipeline` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_compute_pipeline_box(WGPUComputePipeline handle);

// The `WGPUComputePipeline` a Lean `ComputePipeline` holds; the Lean value
// keeps the reference.
WGPUComputePipeline lean_wgpu_compute_pipeline_unbox(b_lean_obj_arg object);

// A Lean `Device` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_device_box(WGPUDevice handle);

// The `WGPUDevice` a Lean `Device` holds; the Lean value keeps the reference.
WGPUDevice lean_wgpu_device_unbox(b_lean_obj_arg object);

// A Lean `ExternalTexture` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_external_texture_box(WGPUExternalTexture handle);

// The `WGPUExternalTexture` a Lean `ExternalTexture` holds; the Lean value
// keeps the reference.
WGPUExternalTexture lean_wgpu_external_texture_unbox(b_lean_obj_arg object);

// A Lean `Instance` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_instance_box(WGPUInstance handle);

// The `WGPUInstance` a Lean `Instance` holds; the Lean value keeps the
// reference.
WGPUInstance lean_wgpu_instance_unbox(b_lean_obj_arg object);

// A Lean `PipelineLayout` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_pipeline_layout_box(WGPUPipelineLayout handle);

// The `WGPUPipelineLayout` a Lean `PipelineLayout` holds; the Lean value keeps
// the reference.
WGPUPipelineLayout lean_wgpu_pipeline_layout_unbox(b_lean_obj_arg object);

// A Lean `QuerySet` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_query_set_box(WGPUQuerySet handle);

// The `WGPUQuerySet` a Lean `QuerySet` holds; the Lean value keeps the
// reference.
WGPUQuerySet lean_wgpu_query_set_unbox(b_lean_obj_arg object);

// A Lean `Queue` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_queue_box(WGPUQueue handle);

// The `WGPUQueue` a Lean `Queue` holds; the Lean value keeps the reference.
WGPUQueue lean_wgpu_queue_unbox(b_lean_obj_arg object);

// A Lean `RenderBundle` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_render_bundle_box(WGPURenderBundle handle);

// The `WGPURenderBundle` a Lean `RenderBundle` holds; the Lean value keeps the
// reference.
WGPURenderBundle lean_wgpu_render_bundle_unbox(b_lean_obj_arg object);

// A Lean `RenderBundleEncoder` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_render_bundle_encoder_box(WGPURenderBundleEncoder handle);

// The `WGPURenderBundleEncoder` a Lean `RenderBundleEncoder` holds; the Lean
// value keeps the reference.
WGPURenderBundleEncoder lean_wgpu_render_bundle_encoder_unbox(b_lean_obj_arg object);

// A Lean `RenderPassEncoder` owning the reference `handle`, which it releases
// when Lean frees it.
lean_obj_res lean_wgpu_render_pass_encoder_box(WGPURenderPassEncoder handle);

// The `WGPURenderPassEncoder` a Lean `RenderPassEncoder` holds; the Lean value
// keeps the reference.
WGPURenderPassEncoder lean_wgpu_render_pass_encoder_unbox(b_lean_obj_arg object);

// A Lean `RenderPipeline` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_render_pipeline_box(WGPURenderPipeline handle);

// The `WGPURenderPipeline` a Lean `RenderPipeline` holds; the Lean value keeps
// the reference.
WGPURenderPipeline lean_wgpu_render_pipeline_unbox(b_lean_obj_arg object);

// A Lean `Sampler` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_sampler_box(WGPUSampler handle);

// The `WGPUSampler` a Lean `Sampler` holds; the Lean value keeps the reference.
WGPUSampler lean_wgpu_sampler_unbox(b_lean_obj_arg object);

// A Lean `ShaderModule` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_shader_module_box(WGPUShaderModule handle);

// The `WGPUShaderModule` a Lean `ShaderModule` holds; the Lean value keeps the
// reference.
WGPUShaderModule lean_wgpu_shader_module_unbox(b_lean_obj_arg object);

// A Lean `Surface` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_surface_box(WGPUSurface handle);

// The `WGPUSurface` a Lean `Surface` holds; the Lean value keeps the reference.
WGPUSurface lean_wgpu_surface_unbox(b_lean_obj_arg object);

// A Lean `Texture` owning the reference `handle`, which it releases when Lean
// frees it.
lean_obj_res lean_wgpu_texture_box(WGPUTexture handle);

// The `WGPUTexture` a Lean `Texture` holds; the Lean value keeps the reference.
WGPUTexture lean_wgpu_texture_unbox(b_lean_obj_arg object);

// A Lean `TextureView` owning the reference `handle`, which it releases when
// Lean frees it.
lean_obj_res lean_wgpu_texture_view_box(WGPUTextureView handle);

// The `WGPUTextureView` a Lean `TextureView` holds; the Lean value keeps the
// reference.
WGPUTextureView lean_wgpu_texture_view_unbox(b_lean_obj_arg object);
