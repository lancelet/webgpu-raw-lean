// Filling in an encoded struct's pointers: see WebGPU/Raw/Internal/Reloc.lean,
// whose `walk` this implements. That the table, the targets and the bytes
// agree is proved there of every generated table; this checks it only when the
// bindings are built with `-K checkPokes=true` (LEAN_WGPU_CHECKED), as the
// tests are in CI.

#include <string.h>
#include "family.h"
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
    LEAN_WGPU_CHAIN      = 5,
    LEAN_WGPU_CLOSURE    = 6,
    LEAN_WGPU_NULL       = 7,
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
    LEAN_WGPU_CHECK(stride > 0 && size % stride == 0,
        "bytes not a whole number of elements");
    LEAN_WGPU_CHECK(((uintptr_t)data & 7) == 0, "bytes out of alignment");
    for (size_t at = 0; at < size; at += stride) {
        for (uint32_t i = 0; i < count; i++) {
            uint8_t const * reloc = header + 8 + 12 * (size_t)i;
            uint32_t offset = lean_wgpu_u32(reloc);
            uint8_t kind = reloc[4];
            LEAN_WGPU_CHECK(stride >= sizeof(void *)
                && offset <= stride - sizeof(void *),
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
            case LEAN_WGPU_CLOSURE:
                // Held by the family being filled, at the ordinal the table
                // gives, and the pointer that family's ID; null for none.
                value = lean_wgpu_some(value);
                if (value != NULL) {
                    lean_wgpu_family family = lean_wgpu_family_filling();
                    size_t ordinal = lean_wgpu_u32(reloc + 8);
                    LEAN_WGPU_CHECK(family != 0
                        && ordinal < LEAN_WGPU_FAMILY_CLOSURES,
                        "a closure with no family, or out of range");
                    lean_wgpu_family_hold(family, ordinal, value);
                    pointer = (void *)family;
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
            case LEAN_WGPU_CHAIN: {
                // Each element, of `links` (an `Array (ByteArray × Nat)`),
                // filled in by its own table, its targets in turn; then each
                // linked to the next by its first pointer, its chain's `next`.
                // Linking must come after filling: each element's table
                // writes its `next` null. The walk (`walkLinks`) refuses a
                // link that is not one element of its table, its `next` at
                // 0, so this write is within it.
                size_t count = lean_array_size(value);
                for (size_t k = 0; k < count; k++) {
                    lean_object * link = lean_array_get_core(value, k);
                    lean_object * element = lean_ctor_get(link, 0);
                    size_t length = lean_sarray_size(element);
                    LEAN_WGPU_CHECK(length >= sizeof(void *)
                        && lean_is_exclusive(element),
                        "a chain's element empty, or held by anything else");
                    lean_wgpu_fill(lean_sarray_cptr(element), length, tables,
                        lean_usize_of_nat(lean_ctor_get(link, 1)), targets,
                        cursor);
                }
                for (size_t k = count; k-- > 0;) {
                    uint8_t * element = lean_sarray_cptr(lean_ctor_get(
                        lean_array_get_core(value, k), 0));
                    memcpy(element, &pointer, sizeof pointer);
                    pointer = element;
                }
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

void const * lean_wgpu_fill_arg(
        b_lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets) {
    size_t size = lean_sarray_size(bytes);
    if (size == 0) {
        LEAN_WGPU_CHECK(lean_array_size(targets) == 0,
            "targets for an empty argument");
        return NULL;
    }
    // Written into in place: the bytes are fresh, held by the call alone.
    LEAN_WGPU_CHECK(lean_is_exclusive(bytes),
        "an argument's bytes held by anything else");
    LEAN_WGPU_CHECK(table < lean_array_size(tables)
        && size == lean_wgpu_u32(
            lean_sarray_cptr(lean_array_get_core(tables, table))),
        "an argument's bytes not one struct");
    uint8_t * data = lean_sarray_cptr(bytes);
    lean_wgpu_fill_struct(data, size, tables, table, targets);
    return data;
}

void const * lean_wgpu_fill_objects(
        b_lean_obj_arg block, b_lean_obj_arg objects) {
    size_t count = lean_array_size(objects);
    LEAN_WGPU_CHECK(lean_sarray_size(block) == count * sizeof(void *),
        "an array's block not a pointer wide an object");
    if (count == 0) {
        return NULL;
    }
    // Written into in place: the block is fresh, held by the call alone.
    LEAN_WGPU_CHECK(lean_is_exclusive(block),
        "an array's block held by anything else");
    uint8_t * data = lean_sarray_cptr(block);
    for (size_t k = 0; k < count; k++) {
        void * handle = lean_get_external_data(lean_array_get_core(objects, k));
        memcpy(data + k * sizeof handle, &handle, sizeof handle);
    }
    return data;
}

void const * lean_wgpu_u32s_arg(b_lean_obj_arg block, b_lean_obj_arg words) {
    size_t count = lean_array_size(words);
    LEAN_WGPU_CHECK(lean_sarray_size(block) == count * sizeof(uint32_t),
        "an array's block not 4 bytes an element");
    return count == 0 ? NULL : lean_sarray_cptr(block);
}
