// For the benchmark (WebGPURawBench.lean): C filling structs on the stack, the
// baseline the bindings' encoding is measured against, and the bindings' fill
// alone. Lean times each call, an `IO` action, so that it runs between the
// clock's two readings; each returns `n`. Each struct is handed to a function
// through a volatile pointer, so the compiler cannot leave the filling out;
// the empty loop does the same.

#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "reloc.h"

// Where each filled struct goes: nowhere, but the compiler cannot know it.
static void lean_wgpu_bench_nothing(void const * p) { (void)p; }
static void (* volatile lean_wgpu_bench_sink)(void const *) =
    lean_wgpu_bench_nothing;

// `n` iterations of the empty loop.
LEAN_EXPORT lean_obj_res lean_wgpu_bench_c_loop(size_t n) {
    for (size_t i = 0; i < n; i++) {
        lean_wgpu_bench_sink(&i);
    }
    return lean_io_result_mk_ok(lean_box_uint64(n));
}

// Fill `n` buffer descriptors: a label and scalars.
LEAN_EXPORT lean_obj_res lean_wgpu_bench_c_buffer(size_t n) {
    for (size_t i = 0; i < n; i++) {
        WGPUBufferDescriptor d = WGPU_BUFFER_DESCRIPTOR_INIT;
        d.label = (WGPUStringView){"vertices", 8};
        d.usage = WGPUBufferUsage_Vertex | WGPUBufferUsage_CopyDst;
        d.size = i;
        d.mappedAtCreation = 1;
        lean_wgpu_bench_sink(&d);
    }
    return lean_io_result_mk_ok(lean_box_uint64(n));
}

// Fill `n` instance descriptors: an array of two enums, and limits behind a
// pointer.
LEAN_EXPORT lean_obj_res lean_wgpu_bench_c_instance(size_t n) {
    for (size_t i = 0; i < n; i++) {
        WGPUInstanceFeatureName features[2] = {
            WGPUInstanceFeatureName_TimedWaitAny,
            WGPUInstanceFeatureName_ShaderSourceSPIRV
        };
        WGPUInstanceLimits limits = WGPU_INSTANCE_LIMITS_INIT;
        limits.timedWaitAnyMaxCount = i;
        WGPUInstanceDescriptor d = WGPU_INSTANCE_DESCRIPTOR_INIT;
        d.requiredFeatureCount = 2;
        d.requiredFeatures = features;
        d.requiredLimits = &limits;
        lean_wgpu_bench_sink(&d);
    }
    return lean_io_result_mk_ok(lean_box_uint64(n));
}

// Fill `n` bind group layout descriptors: a label, and an array of four
// entries, each with structs nested by value.
LEAN_EXPORT lean_obj_res lean_wgpu_bench_c_layout(size_t n) {
    for (size_t i = 0; i < n; i++) {
        WGPUBindGroupLayoutEntry entries[4];
        for (uint32_t k = 0; k < 4; k++) {
            WGPUBindGroupLayoutEntry e = WGPU_BIND_GROUP_LAYOUT_ENTRY_INIT;
            e.binding = (uint32_t)i + k;
            e.visibility = WGPUShaderStage_Fragment;
            entries[k] = e;
        }
        WGPUBindGroupLayoutDescriptor d =
            WGPU_BIND_GROUP_LAYOUT_DESCRIPTOR_INIT;
        d.label = (WGPUStringView){"layout", 6};
        d.entryCount = 4;
        d.entries = entries;
        lean_wgpu_bench_sink(&d);
    }
    return lean_io_result_mk_ok(lean_box_uint64(n));
}

// Fill in an encoded argument as a shim does, without calling WebGPU: its
// first pointer-sized word, so that the fill is not left out.
LEAN_EXPORT uint64_t lean_wgpu_bench_fill(
        b_lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets) {
    void const * p = lean_wgpu_fill_arg(bytes, tables, table, targets);
    lean_wgpu_bench_sink(p);
    return p == NULL ? 0 : *(uintptr_t const *)p;
}
