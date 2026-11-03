// Structs as C lays them out, for the tests to compare packing with: each is
// filled in C, its pointers NULL, and returned as its bytes.

#include <string.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>

// The bytes of `size` bytes at `data`, as a new Lean byte array.
static lean_obj_res lean_wgpu_test_bytes(void const * data, size_t size) {
    lean_obj_res bytes = lean_alloc_sarray(1, size, size);
    memcpy(lean_sarray_cptr(bytes), data, size);
    return bytes;
}

// A buffer descriptor with these fields, no chain, and a label of `labelLength`
// bytes at NULL; its padding zero, as packing leaves it.
LEAN_EXPORT lean_obj_res lean_wgpu_test_buffer_descriptor(
        uint64_t usage, uint64_t size, uint32_t mappedAtCreation,
        size_t labelLength) {
    WGPUBufferDescriptor descriptor;
    memset(&descriptor, 0, sizeof descriptor);
    descriptor.nextInChain = NULL;
    descriptor.label.data = NULL;
    descriptor.label.length = labelLength;
    descriptor.usage = usage;
    descriptor.size = size;
    descriptor.mappedAtCreation = mappedAtCreation;
    return lean_wgpu_test_bytes(&descriptor, sizeof descriptor);
}
