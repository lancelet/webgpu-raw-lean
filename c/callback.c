// Running Lean closures as WebGPU callbacks: see callback.h.
//
// Callbacks run on the thread of the call into WebGPU that runs them (the
// call that takes them, `processEvents`, `waitAny`, a release), or, on the
// web, from the browser's event loop on the only thread. So what the calls
// on a thread are doing is the thread's own: how many are running, and the
// first error a callback raised in the innermost.

#include <stdlib.h>
#include <string.h>
#include "callback.h"

// How many calls that can run callbacks are running on this thread.
static _Thread_local size_t lean_wgpu_depth;

// The first error a callback raised in the innermost of them: an IO result,
// or NULL.
static _Thread_local lean_object * lean_wgpu_pending;

lean_object * lean_wgpu_callbacks_enter(void) {
    lean_object * saved = lean_wgpu_pending;
    lean_wgpu_pending = NULL;
    lean_wgpu_depth++;
    return saved;
}

lean_obj_res lean_wgpu_callbacks_leave(lean_object * saved, lean_obj_arg ok) {
    lean_object * result = ok;
    if (lean_wgpu_pending != NULL) {
        // Taken before `ok` is released, which can run finalizers, and so
        // callbacks, at this depth: their errors come after the first.
        result = lean_wgpu_pending;
        lean_dec(ok);
    }
    lean_wgpu_pending = saved;
    lean_wgpu_depth--;
    return result;
}

void * lean_wgpu_closure_hold(b_lean_obj_arg closure) {
    lean_mark_mt(closure);
    lean_inc(closure);
    return closure;
}

void lean_wgpu_callback_done(lean_obj_arg result) {
    if (lean_io_result_is_ok(result)) {
        lean_dec(result);
    } else if (lean_wgpu_depth == 0) {
        lean_io_result_show_error(result);
        lean_dec(result);
        exit(1);
    } else if (lean_wgpu_pending == NULL) {
        lean_wgpu_pending = result;
    } else {
        lean_dec(result);
    }
}

lean_obj_res lean_wgpu_string_of_view(WGPUStringView view) {
    if (view.data == NULL) {
        return lean_mk_string("");
    }
    size_t length = view.length == WGPU_STRLEN
        ? strlen(view.data) : view.length;
    return lean_mk_string_from_bytes(view.data, length);
}

#ifndef WEBGPU_RAW_DAWN
// The bindings' own handler of an uncaptured error, for a device whose
// descriptor gives none, as wgpu-native's default ends the program at once:
// an IO error, saying the error's type and message, of the call that made it,
// as every shim brackets its call (`lean_wgpu_callbacks_enter`); outside
// every call (in a finalizer run outside every call), as for any callback, it
// is printed and the program ends.
static void lean_wgpu_uncaptured_error_default(
        WGPUDevice const * device, WGPUErrorType type, WGPUStringView message,
        void * userdata1, void * userdata2) {
    (void)device;
    (void)userdata1;
    (void)userdata2;
    char const * kind = "WebGPU error: ";
    switch (type) {
    case WGPUErrorType_Validation:
        kind = "WebGPU validation error: ";
        break;
    case WGPUErrorType_OutOfMemory:
        kind = "WebGPU out-of-memory error: ";
        break;
    case WGPUErrorType_Internal:
        kind = "WebGPU internal error: ";
        break;
    default:
        break;
    }
    lean_object * text = lean_mk_string(kind);
    lean_object * view = lean_wgpu_string_of_view(message);
    text = lean_string_append(text, view);
    lean_dec(view);
    lean_wgpu_callback_done(
        lean_io_result_mk_error(lean_mk_io_user_error(text)));
}
#endif

LEAN_EXPORT uint64_t lean_WGPUUncapturedErrorCallback_default_address(
        b_lean_obj_arg unit) {
    (void)unit;
#ifdef WEBGPU_RAW_DAWN
    // Dawn's own default logs the error: there is nothing to end.
    return 0;
#else
    return (uint64_t)(uintptr_t)lean_wgpu_uncaptured_error_default;
#endif
}
