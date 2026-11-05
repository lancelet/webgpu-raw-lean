// A surface's texture to draw in, and what it can be configured with,
// written by hand (`WebGPU/Raw/Surface.lean`): structs C fills, given Lean as
// an object and words, those whose members C allocates freed in the call.
// Each call is bracketed, as every shim's is.

#include <stdint.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "callback.h"
#include "generated/objects.h"

// The Lean pair `(a, b)`, taking both.
static lean_obj_res lean_wgpu_surface_pair(lean_obj_arg a, lean_obj_arg b) {
    lean_object * pair = lean_alloc_ctor(0, 2, 0);
    lean_ctor_set(pair, 0, a);
    lean_ctor_set(pair, 1, b);
    return pair;
}

// `count` codes from `codes`, an array of an enum (4 bytes each, as every
// enum has a member of 0x7FFFFFFF), as a Lean `Array UInt32`.
static lean_obj_res lean_wgpu_surface_codes(
        size_t count, void const * codes) {
    uint32_t const * words = codes;
    lean_object * array = lean_alloc_array(count, count);
    for (size_t k = 0; k < count; k++) {
        lean_array_set_core(array, k, lean_box_uint32(words[k]));
    }
    return array;
}

// The status's code, and the texture to draw in this frame, if any: its
// reference, which the Lean texture takes. A surface's texture is of no
// family (`c/family.c`): it is the surface's, not a device's.
LEAN_EXPORT lean_obj_res lean_wgpu_surface_get_current_texture(
        b_lean_obj_arg surface) {
    WGPUSurfaceTexture texture = WGPU_SURFACE_TEXTURE_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuSurfaceGetCurrentTexture(lean_wgpu_surface_unbox(surface), &texture);
    lean_object * result = lean_wgpu_surface_pair(
        lean_box_uint32((uint32_t)texture.status),
        lean_wgpu_texture_box_option(texture.texture));
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(result));
}

// The status's code, then the usages' bits, and the formats', present
// modes' and alpha modes' codes, the surface can be configured with for
// `adapter`.
LEAN_EXPORT lean_obj_res lean_wgpu_surface_get_capabilities(
        b_lean_obj_arg surface, b_lean_obj_arg adapter) {
    WGPUSurfaceCapabilities capabilities = WGPU_SURFACE_CAPABILITIES_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUStatus status = wgpuSurfaceGetCapabilities(
        lean_wgpu_surface_unbox(surface), lean_wgpu_adapter_unbox(adapter),
        &capabilities);
    lean_object * modes = lean_wgpu_surface_pair(
        lean_wgpu_surface_codes(
            capabilities.presentModeCount, capabilities.presentModes),
        lean_wgpu_surface_codes(
            capabilities.alphaModeCount, capabilities.alphaModes));
    lean_object * result = lean_wgpu_surface_pair(
        lean_box_uint32((uint32_t)status),
        lean_wgpu_surface_pair(
            lean_box_uint64((uint64_t)capabilities.usages),
            lean_wgpu_surface_pair(
                lean_wgpu_surface_codes(
                    capabilities.formatCount, capabilities.formats),
                modes)));
    // A status other than success leaves them as the initialiser made them,
    // which this frees nothing of.
    wgpuSurfaceCapabilitiesFreeMembers(capabilities);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(result));
}
