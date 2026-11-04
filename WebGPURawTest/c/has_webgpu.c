// For the web self-test only: whether the page has WebGPU.

#include <lean/lean.h>

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
