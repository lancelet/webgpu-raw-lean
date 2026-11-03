// Little-endian stores into Lean byte arrays: the fast paths of the writers in
// WebGPU.Raw.Internal.Bytes, whose Lean definitions they implement. Each writes
// its value whole, as one store, or leaves the array as it is if the value does
// not fit; the tests check they agree with the Lean definitions.

#include <stdint.h>
#include <string.h>
#include <lean/lean.h>

// A store copies the value's bytes as the target holds them: little-endian, as
// the Lean definitions write them, on every target the bindings support.
_Static_assert(__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__,
    "the bindings assume a little-endian target");

// `bytes` with the `width` bytes at `value` stored at `offset`, if they fit,
// written in place if `bytes` is not shared.
static lean_obj_res lean_wgpu_bytes_write(lean_obj_arg bytes, size_t offset,
                                          void const * value, size_t width) {
    size_t size = lean_sarray_size(bytes);
    if (offset > size || width > size - offset) {
        return bytes;
    }
    lean_obj_res out = lean_is_exclusive(bytes) ? bytes
                                                : lean_copy_byte_array(bytes);
    memcpy(lean_sarray_cptr(out) + offset, value, width);
    return out;
}

LEAN_EXPORT lean_obj_res lean_wgpu_bytes_write_u16(lean_obj_arg bytes,
                                                   size_t offset,
                                                   uint16_t value) {
    return lean_wgpu_bytes_write(bytes, offset, &value, sizeof value);
}

LEAN_EXPORT lean_obj_res lean_wgpu_bytes_write_u32(lean_obj_arg bytes,
                                                   size_t offset,
                                                   uint32_t value) {
    return lean_wgpu_bytes_write(bytes, offset, &value, sizeof value);
}

LEAN_EXPORT lean_obj_res lean_wgpu_bytes_write_u64(lean_obj_arg bytes,
                                                   size_t offset,
                                                   uint64_t value) {
    return lean_wgpu_bytes_write(bytes, offset, &value, sizeof value);
}
