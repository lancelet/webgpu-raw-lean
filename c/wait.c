// `Instance.waitAny`'s shim, written by hand (`WebGPU/Raw/Wait.lean`): its
// futures are an array C reads and writes, each future in, and whether it
// completed out, which the generator does not pass.

#include <stdlib.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "callback.h"
#include "generated/objects.h"

// An IO error with `message`.
static lean_obj_res lean_wgpu_wait_error(char const * message) {
    return lean_io_result_mk_error(
        lean_mk_io_user_error(lean_mk_string(message)));
}

// Waits on `futures` (borrowed, an array of each future's ID) for up to
// `timeout` nanoseconds: the status's code, and a byte for each future, 1 if
// it completed. Bracketed, as the callbacks of those that completed run in
// it. wgpu-native leaves it unimplemented (calling it aborts): built against
// it, an IO error, as the generated shims of such functions raise.
LEAN_EXPORT lean_obj_res lean_wgpuInstanceWaitAny(
        b_lean_obj_arg self, b_lean_obj_arg futures, uint64_t timeout) {
#ifdef WEBGPU_RAW_DAWN
    size_t count = lean_array_size(futures);
    WGPUFutureWaitInfo * infos = NULL;
    if (count > 0) {
        infos = calloc(count, sizeof *infos);
        if (infos == NULL) {
            return lean_wgpu_wait_error("Instance.waitAny: out of memory");
        }
    }
    for (size_t k = 0; k < count; k++) {
        infos[k].future.id = lean_unbox_uint64(lean_array_get_core(futures, k));
    }
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUWaitStatus status = wgpuInstanceWaitAny(
        lean_wgpu_instance_unbox(self), count, infos, timeout);
    lean_object * completed = lean_alloc_sarray(1, count, count);
    for (size_t k = 0; k < count; k++) {
        lean_sarray_cptr(completed)[k] = infos[k].completed ? 1 : 0;
    }
    free(infos);
    lean_object * pair = lean_alloc_ctor(0, 2, 0);
    lean_ctor_set(pair, 0, lean_box_uint32((uint32_t)status));
    lean_ctor_set(pair, 1, completed);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(pair));
#else
    (void)self;
    (void)futures;
    (void)timeout;
    return lean_wgpu_wait_error(
        "Instance.waitAny: not implemented by wgpu-native");
#endif
}
