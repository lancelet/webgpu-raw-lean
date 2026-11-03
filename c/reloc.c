// Filling in an encoded struct's pointers: see WebGPU/Raw/Internal/Reloc.lean,
// whose `walk` this implements. That the table, the targets and the bytes
// agree is proved there of every generated table; this checks it only when the
// bindings are built with `-K checkPokes=true` (LEAN_WGPU_CHECKED), as the
// tests are in CI.

#include <string.h>
#include "reloc.h"

#ifdef LEAN_WGPU_CHECKED
#define LEAN_WGPU_CHECK(ok, what) \
    ((ok) ? (void)0 : lean_internal_panic("a relocation: " what))
#else
#define LEAN_WGPU_CHECK(ok, what) ((void)0)
#endif

// A kind's code, as `Kind.code` gives it: its target's constructor's index.
enum {
    LEAN_WGPU_STRING     = 0,
    LEAN_WGPU_OPT_STRING = 1,
    LEAN_WGPU_OBJECT     = 2,
    LEAN_WGPU_OPT_OBJECT = 3,
    LEAN_WGPU_BLOCK      = 4,
    LEAN_WGPU_NULL       = 5,
};

// The little-endian u32 at `p`. Every target is little-endian.
static uint32_t lean_wgpu_u32(uint8_t const * p) {
    uint32_t v;
    memcpy(&v, p, sizeof v);
    return v;
}

// What an `Option`'s some holds, or NULL for none.
static lean_object * lean_wgpu_some(b_lean_obj_arg option) {
    return lean_is_scalar(option) ? NULL : lean_ctor_get(option, 0);
}

void lean_wgpu_fill(
        uint8_t * data, size_t size, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets, size_t * cursor) {
    LEAN_WGPU_CHECK(table < lean_array_size(tables), "no such table");
    lean_object * bytes = lean_array_get_core(tables, table);
    uint8_t const * header = lean_sarray_cptr(bytes);
    uint32_t stride = lean_wgpu_u32(header);
    uint32_t count = lean_wgpu_u32(header + 4);
    LEAN_WGPU_CHECK(count <= (SIZE_MAX - 8) / 12
        && lean_sarray_size(bytes) == 8 + 12 * (size_t)count,
        "a table of the wrong size");
    LEAN_WGPU_CHECK(stride >= sizeof(void *) && size % stride == 0,
        "bytes not a whole number of elements");
    LEAN_WGPU_CHECK(((uintptr_t)data & 7) == 0, "bytes out of alignment");
    for (size_t at = 0; at < size; at += stride) {
        for (uint32_t i = 0; i < count; i++) {
            uint8_t const * reloc = header + 8 + 12 * (size_t)i;
            uint32_t offset = lean_wgpu_u32(reloc);
            uint8_t kind = reloc[4];
            LEAN_WGPU_CHECK(offset <= stride - sizeof(void *),
                "a pointer past its struct's end");
            void * pointer = NULL;
            if (kind == LEAN_WGPU_NULL) {
                // Left null, taking no target.
                memcpy(data + at + offset, &pointer, sizeof pointer);
                continue;
            }
            LEAN_WGPU_CHECK(*cursor < lean_array_size(targets),
                "too few targets");
            lean_object * target = lean_array_get_core(targets, (*cursor)++);
            LEAN_WGPU_CHECK(lean_ptr_tag(target) == kind,
                "a target of the wrong kind");
            lean_object * value = lean_ctor_get(target, 0);
            switch (kind) {
            case LEAN_WGPU_STRING:
                pointer = (void *)lean_string_cstr(value);
                break;
            case LEAN_WGPU_OPT_STRING:
                value = lean_wgpu_some(value);
                if (value != NULL) {
                    pointer = (void *)lean_string_cstr(value);
                }
                break;
            case LEAN_WGPU_OBJECT:
                pointer = lean_get_external_data(value);
                break;
            case LEAN_WGPU_OPT_OBJECT:
                value = lean_wgpu_some(value);
                if (value != NULL) {
                    pointer = lean_get_external_data(value);
                }
                break;
            case LEAN_WGPU_BLOCK: {
                // Filled in by its own table, then pointed to; empty, null,
                // and written into not at all, so it may be shared: an
                // optional struct that is none is the one `ByteArray.empty`.
                size_t length = lean_sarray_size(value);
                LEAN_WGPU_CHECK(length == 0 || lean_is_exclusive(value),
                    "a block held by anything else");
                uint8_t * block = lean_sarray_cptr(value);
                lean_wgpu_fill(block, length, tables,
                    lean_wgpu_u32(reloc + 8), targets, cursor);
                pointer = length == 0 ? NULL : block;
                break;
            }
            default:
                LEAN_WGPU_CHECK(0, "an unknown kind");
            }
            memcpy(data + at + offset, &pointer, sizeof pointer);
        }
    }
}

void lean_wgpu_fill_struct(
        uint8_t * data, size_t size, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets) {
    size_t cursor = 0;
    lean_wgpu_fill(data, size, tables, table, targets, &cursor);
    LEAN_WGPU_CHECK(cursor == lean_array_size(targets), "targets left over");
}
