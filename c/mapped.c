// Reading and writing a buffer's mapped memory, written by hand
// (`WebGPU/Raw/Mapped.lean`): a mapped range is a pointer into memory the
// buffer owns until it is unmapped, which the bindings never give Lean; they
// copy out of it, or into it, in the call.

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "callback.h"
#include "generated/objects.h"

// An IO error with `message`.
static lean_obj_res lean_wgpu_mapped_error(char const * message) {
    return lean_io_result_mk_error(
        lean_mk_io_user_error(lean_mk_string(message)));
}

// Why the `size` bytes at `offset` of `buffer` cannot be a mapped range, or
// NULL if they can: WebGPU's alignment (an offset a multiple of 8, a size of
// 4), and within the buffer. wgpu-native ends the program on a range that
// breaks either, where Dawn gives none, so the shims check first. Whether
// the range is mapped, C checks; wgpu-native cannot be asked first.
static char const * lean_wgpu_mapped_refusal(
        WGPUBuffer buffer, uint64_t offset, uint64_t size) {
    if (offset % 8 != 0 || size % 4 != 0) {
        return "an offset not a multiple of 8, or a size not of 4";
    }
#if SIZE_MAX < UINT64_MAX
    if (offset > SIZE_MAX || size > SIZE_MAX) {
        return "a range too large for this target";
    }
#endif
    uint64_t length = wgpuBufferGetSize(buffer);
    if (offset > length || size > length - offset) {
        return "a range outside the buffer";
    }
    return NULL;
}

// Why C gave no range: in a browser, too, each byte of a mapping can be asked
// for once, till the buffer is unmapped.
static char const lean_wgpu_mapped_none[] =
    "no mapped range there (not mapped, or in a browser, asked for already)";

// An IO error of the function `name`: `what`.
static lean_obj_res lean_wgpu_mapped_refused(
        char const * name, char const * what) {
    char message[160];
    snprintf(message, sizeof message, "%s: %s", name, what);
    return lean_wgpu_mapped_error(message);
}

// A copy of the `size` bytes at `offset` in `buffer`'s mapped memory, as a
// new `ByteArray`; an IO error if they cannot be a mapped range, or C gives
// none for them (not mapped there).
LEAN_EXPORT lean_obj_res lean_wgpu_buffer_read_mapped(
        b_lean_obj_arg buffer, uint64_t offset, uint64_t size) {
    WGPUBuffer handle = lean_wgpu_buffer_unbox(buffer);
    char const * refusal = lean_wgpu_mapped_refusal(handle, offset, size);
    if (refusal != NULL) {
        return lean_wgpu_mapped_refused("Buffer.readMapped", refusal);
    }
    if (size == 0) {
        // No bytes: C is not asked, as Dawn gives no range for none.
        return lean_io_result_mk_ok(lean_alloc_sarray(1, 0, 0));
    }
    lean_object * saved = lean_wgpu_callbacks_enter();
    void const * range = wgpuBufferGetConstMappedRange(
        handle, (size_t)offset, (size_t)size);
    if (range == NULL) {
        return lean_wgpu_callbacks_leave(saved, lean_wgpu_mapped_refused(
            "Buffer.readMapped", lean_wgpu_mapped_none));
    }
    lean_object * bytes = lean_alloc_sarray(1, (size_t)size, (size_t)size);
    memcpy(lean_sarray_cptr(bytes), range, (size_t)size);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(bytes));
}

// Copy `data` (borrowed) into `buffer`'s mapped memory at `offset`; an IO
// error if it cannot be a mapped range, or C gives none for it (not mapped
// there for writing).
LEAN_EXPORT lean_obj_res lean_wgpu_buffer_write_mapped(
        b_lean_obj_arg buffer, uint64_t offset, b_lean_obj_arg data) {
    WGPUBuffer handle = lean_wgpu_buffer_unbox(buffer);
    size_t size = lean_sarray_size(data);
    char const * refusal = lean_wgpu_mapped_refusal(handle, offset, size);
    if (refusal != NULL) {
        return lean_wgpu_mapped_refused("Buffer.writeMapped", refusal);
    }
    if (size == 0) {
        return lean_io_result_mk_ok(lean_box(0));
    }
    lean_object * saved = lean_wgpu_callbacks_enter();
    void * range = wgpuBufferGetMappedRange(handle, (size_t)offset, size);
    if (range == NULL) {
        return lean_wgpu_callbacks_leave(saved, lean_wgpu_mapped_refused(
            "Buffer.writeMapped", lean_wgpu_mapped_none));
    }
    memcpy(range, lean_sarray_cptr(data), size);
    return lean_wgpu_callbacks_leave(saved,
        lean_io_result_mk_ok(lean_box(0)));
}
