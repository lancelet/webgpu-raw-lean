// For the tests only: an instance, until the bindings can create one.
// wgpuCreateInstance takes a descriptor, which the bindings cannot pass yet;
// with no descriptor it needs no GPU, so the tests can call functions on it
// anywhere.

#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "objects.h"

// A new instance, owning its reference, or an IO error if there is none.
LEAN_EXPORT lean_obj_res lean_wgpu_test_create_instance(void) {
    WGPUInstance instance = wgpuCreateInstance(NULL);
    if (instance == NULL) {
        return lean_io_result_mk_error(
            lean_mk_io_user_error(lean_mk_string("wgpuCreateInstance failed"))
        );
    }
    return lean_io_result_mk_ok(lean_wgpu_instance_box(instance));
}

#ifdef __EMSCRIPTEN__
#include <emscripten.h>

// Whether this page has WebGPU (`navigator.gpu`): Node does not, and there
// some of emdawnwebgpu's functions throw a JavaScript error, which ends the
// program. For the web self-test only: Lean passes its `Unit` argument.
LEAN_EXPORT uint8_t lean_wgpu_test_has_webgpu(b_lean_obj_arg unit) {
    (void)unit;
    return (uint8_t)EM_ASM_INT({
        return typeof navigator !== "undefined" && !!navigator.gpu;
    });
}
#endif
