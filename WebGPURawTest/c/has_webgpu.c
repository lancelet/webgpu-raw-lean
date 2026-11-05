// For the web self-test only: whether the page has WebGPU, and keeping the
// program alive while it waits for callbacks no request keeps it alive for.

#include <lean/lean.h>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#include <emscripten/eventloop.h>

// Whether this page has WebGPU (`navigator.gpu`): Node does not, and there
// some of emdawnwebgpu's functions throw a JavaScript error, which ends the
// program. For the web self-test only: Lean passes its `Unit` argument.
LEAN_EXPORT uint8_t lean_wgpu_test_has_webgpu(b_lean_obj_arg unit) {
    (void)unit;
    return (uint8_t)EM_ASM_INT({
        return typeof navigator !== "undefined" && !!navigator.gpu;
    });
}

// Keep the program alive, if `hold`, else stop: emdawnwebgpu keeps it alive
// while a request is pending, but not for a device's lost or uncaptured-error
// callbacks. An exit waits until every hold has stopped.
LEAN_EXPORT lean_obj_res lean_wgpu_test_keep_alive(uint8_t hold) {
    if (hold) {
        emscripten_runtime_keepalive_push();
    } else {
        emscripten_runtime_keepalive_pop();
    }
    return lean_io_result_mk_ok(lean_box(0));
}
#endif
