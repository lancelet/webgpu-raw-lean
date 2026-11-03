// Filling in pointers (c/reloc.c), for the tests to check: each helper fills
// bytes Lean gives it by a table Lean gives it, then checks, or returns, what
// it filled them with.

#include <string.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "reloc.h"

// The pointer at `offset` in `data`.
static void * lean_wgpu_test_pointer(uint8_t const * data, size_t offset) {
    void * pointer;
    memcpy(&pointer, data + offset, sizeof pointer);
    return pointer;
}

// A string target's string, of target `i`.
static char const * lean_wgpu_test_string(b_lean_obj_arg targets, size_t i) {
    lean_object * value = lean_ctor_get(lean_array_get_core(targets, i), 0);
    if (!lean_is_string(value)) {
        value = lean_ctor_get(value, 0);  // an optional string's some
    }
    return lean_string_cstr(value);
}

// The bytes of target `i`, a block.
static uint8_t * lean_wgpu_test_block(b_lean_obj_arg targets, size_t i) {
    return lean_sarray_cptr(
        lean_ctor_get(lean_array_get_core(targets, i), 0));
}

// Fill `bytes` by table 0 of `WebGPURawTest.Internal.Reloc.everyKind`: a
// pointer every 8 bytes, to a string, an optional string, an object, an
// optional object, and a block of two elements of 24 bytes (table 1), each a
// string, an optional object, and a block of 16 bytes with no pointers (table
// 2). If `some`, each optional is some but the second element's, and the
// second element's block empty; if not, each optional is none and the first
// block empty. The message of the first pointer that is not what it should
// be, or "".
LEAN_EXPORT lean_obj_res lean_wgpu_test_fill_every_kind(
        lean_obj_arg bytes, b_lean_obj_arg tables, b_lean_obj_arg targets,
        b_lean_obj_arg instance, uint8_t some) {
    size_t cursor = 0;
    uint8_t * data = lean_sarray_cptr(bytes);
    lean_wgpu_fill(data, lean_sarray_size(bytes), tables, 0, targets, &cursor);
    void * handle = lean_get_external_data(instance);
    char const * problem = "";
    uint8_t const * block = lean_wgpu_test_pointer(data, 32);
    if (lean_wgpu_test_pointer(data, 0) != lean_wgpu_test_string(targets, 0)) {
        problem = "the string";
    } else if (lean_wgpu_test_pointer(data, 8)
            != (some ? lean_wgpu_test_string(targets, 1) : NULL)) {
        problem = "the optional string";
    } else if (lean_wgpu_test_pointer(data, 16) != handle) {
        problem = "the object";
    } else if (lean_wgpu_test_pointer(data, 24) != (some ? handle : NULL)) {
        problem = "the optional object";
    } else if (!some) {
        if (block != NULL) {
            problem = "the empty block, not null";
        }
    } else if (block != lean_wgpu_test_block(targets, 4)) {
        problem = "the block";
    } else if (lean_wgpu_test_pointer(block, 0)
            != lean_wgpu_test_string(targets, 5)
            || lean_wgpu_test_pointer(block, 24)
                != lean_wgpu_test_string(targets, 8)) {
        problem = "the elements' strings";
    } else if (lean_wgpu_test_pointer(block, 8) != handle
            || lean_wgpu_test_pointer(block, 32) != NULL) {
        problem = "the elements' optional objects";
    } else if (lean_wgpu_test_pointer(block, 16)
            != lean_wgpu_test_block(targets, 7)
            || lean_wgpu_test_pointer(block, 40) != NULL) {
        problem = "the elements' blocks";
    }
    if (*problem == '\0' && cursor != lean_array_size(targets)) {
        problem = "the targets, not all taken";
    }
    lean_dec(bytes);
    return lean_mk_string(problem);
}

// Fill an encoded buffer descriptor by table 0, then read its label back, as
// WebGPU would, by its pointer and length; "(not a buffer descriptor)" if its
// other fields are not those of `WebGPURawTest.Internal.Encode.descriptor`.
LEAN_EXPORT lean_obj_res lean_wgpu_test_buffer_descriptor_label(
        lean_obj_arg bytes, b_lean_obj_arg tables, b_lean_obj_arg targets) {
    lean_wgpu_fill_struct(lean_sarray_cptr(bytes), lean_sarray_size(bytes),
        tables, 0, targets);
    WGPUBufferDescriptor descriptor;
    memcpy(&descriptor, lean_sarray_cptr(bytes), sizeof descriptor);
    lean_obj_res label =
        descriptor.nextInChain != NULL || descriptor.usage != 0x28
            || descriptor.size != 0x10000 || !descriptor.mappedAtCreation
        ? lean_mk_string("(not a buffer descriptor)")
        : lean_mk_string_from_bytes(descriptor.label.data,
            descriptor.label.length);
    lean_dec(bytes);
    return label;
}
