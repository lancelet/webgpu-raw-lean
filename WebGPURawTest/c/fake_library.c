// For the callback tests (WebGPURawTest/Internal/Callback.lean): a fake
// library that runs callbacks as WebGPU does, through the callback runtime
// (c/callback.c), with a trampoline as the generated ones are. A callback's
// closure is a Lean `UInt32 → String → IO Unit`, given a code and a message.

#include <stdlib.h>
#include <string.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "callback.h"

// The trampoline: the closure, in `userdata`, given the code and the message
// copied, released as it is applied.
static void lean_wgpu_test_on_done(
        uint32_t code, WGPUStringView message, void * userdata) {
    lean_object * closure = userdata;
    lean_wgpu_callback_done(lean_apply_3(closure, lean_box_uint32(code),
        lean_wgpu_string_of_view(message), lean_io_mk_world()));
}

// A call that runs its callback before it returns, as wgpu-native's
// `requestAdapter` does, passing `message` as C may, by `form`: 0, with its
// length; 1, NUL-terminated (`WGPU_STRLEN`), a copy with a NUL after it, so
// read no further; 2, the null view.
LEAN_EXPORT lean_obj_res lean_wgpu_test_call_now(
        b_lean_obj_arg closure, uint32_t code, b_lean_obj_arg message,
        uint8_t form) {
    size_t length = lean_sarray_size(message);
    char * copy = malloc(length + 1);
    memcpy(copy, lean_sarray_cptr(message), length);
    copy[length] = 0;
    WGPUStringView view = {
        form == 2 ? NULL : copy,
        form == 0 ? length : WGPU_STRLEN
    };
    lean_object * saved = lean_wgpu_callbacks_enter();
    void * userdata = lean_wgpu_closure_hold(closure);
    lean_wgpu_test_on_done(code, view, userdata);
    free(copy);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
}

// Callbacks waiting to run: each its code, its message (copied) and its
// userdata.
typedef struct {
    uint32_t code;
    char * message;
    size_t length;
    void * userdata;
} lean_wgpu_test_waiting;

static lean_wgpu_test_waiting * lean_wgpu_test_queue;
static size_t lean_wgpu_test_queued;

// A call whose callback runs later, in a pump, as `mapAsync`'s does.
LEAN_EXPORT lean_obj_res lean_wgpu_test_defer(
        b_lean_obj_arg closure, uint32_t code, b_lean_obj_arg message) {
    lean_wgpu_test_queue = realloc(lean_wgpu_test_queue,
        (lean_wgpu_test_queued + 1) * sizeof *lean_wgpu_test_queue);
    size_t length = lean_sarray_size(message);
    char * copy = malloc(length);
    memcpy(copy, lean_sarray_cptr(message), length);
    lean_wgpu_test_queue[lean_wgpu_test_queued++] = (lean_wgpu_test_waiting){
        code, copy, length, lean_wgpu_closure_hold(closure)
    };
    return lean_io_result_mk_ok(lean_box(0));
}

// Run every callback waiting; the number run. Those a callback defers wait
// for the next run.
static size_t lean_wgpu_test_run(void) {
    lean_wgpu_test_waiting * queue = lean_wgpu_test_queue;
    size_t queued = lean_wgpu_test_queued;
    lean_wgpu_test_queue = NULL;
    lean_wgpu_test_queued = 0;
    for (size_t k = 0; k < queued; k++) {
        WGPUStringView view = {queue[k].message, queue[k].length};
        lean_wgpu_test_on_done(queue[k].code, view, queue[k].userdata);
        free(queue[k].message);
    }
    free(queue);
    return queued;
}

// A pump: a call that runs the callbacks waiting.
LEAN_EXPORT lean_obj_res lean_wgpu_test_pump(void) {
    lean_object * saved = lean_wgpu_callbacks_enter();
    size_t run = lean_wgpu_test_run();
    return lean_wgpu_callbacks_leave(saved,
        lean_io_result_mk_ok(lean_box_uint32((uint32_t)run)));
}

// The callbacks waiting, run outside every call, as the browser's event loop
// runs a spontaneous one.
LEAN_EXPORT lean_obj_res lean_wgpu_test_run_outside(void) {
    lean_wgpu_test_run();
    return lean_io_result_mk_ok(lean_box(0));
}

// Tokens, whose release is counted: so a test sees a closure that holds one
// released.
static lean_external_class * lean_wgpu_test_token_class;
static uint32_t lean_wgpu_test_tokens_released;

static void lean_wgpu_test_token_release(void * data) {
    (void)data;
    lean_wgpu_test_tokens_released++;
}

static void lean_wgpu_test_nothing(void * data, b_lean_obj_arg f) {
    (void)data;
    (void)f;
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_token(void) {
    if (lean_wgpu_test_token_class == NULL) {
        lean_wgpu_test_token_class = lean_register_external_class(
            lean_wgpu_test_token_release, lean_wgpu_test_nothing);
    }
    return lean_io_result_mk_ok(
        lean_alloc_external(lean_wgpu_test_token_class, NULL));
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_touch(b_lean_obj_arg token) {
    (void)token;
    return lean_io_result_mk_ok(lean_box(0));
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_tokens_released_count(void) {
    return lean_io_result_mk_ok(
        lean_box_uint32(lean_wgpu_test_tokens_released));
}

// Objects whose finalizer runs a callback, as releasing an instance runs its
// waiting callbacks, cancelled (code 2).
static lean_external_class * lean_wgpu_test_cancelling_class;

static void lean_wgpu_test_cancel(void * userdata) {
    WGPUStringView view = {"cancelled", 9};
    lean_wgpu_test_on_done(2, view, userdata);
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_cancelling(b_lean_obj_arg closure) {
    if (lean_wgpu_test_cancelling_class == NULL) {
        lean_wgpu_test_cancelling_class = lean_register_external_class(
            lean_wgpu_test_cancel, lean_wgpu_test_nothing);
    }
    return lean_io_result_mk_ok(lean_alloc_external(
        lean_wgpu_test_cancelling_class, lean_wgpu_closure_hold(closure)));
}
