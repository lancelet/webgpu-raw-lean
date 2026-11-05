// Families: see family.h.
//
// The families are an array of records, each its generation, count and
// closures, with a list of free ones; the members are an open-addressing hash
// table from a handle to its family and how many Lean objects of it there are.
// One lock guards both: a spin lock, as each critical section is short and
// runs no Lean code, and C11's atomics are on every target (the web build has
// one thread, where it is never contended).

#include <stdatomic.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#if defined(_WIN32)
#include <windows.h>
#elif !defined(__EMSCRIPTEN__)
#include <sched.h>
#endif
#include "family.h"

// An ID is the index plus 1, in its low half, and the generation, in its high
// half: 32 bits each on 64-bit targets, 16 on wasm32.
#define LEAN_WGPU_FAMILY_HALF (sizeof(uintptr_t) * 4)
#define LEAN_WGPU_FAMILY_MASK (((uintptr_t)1 << LEAN_WGPU_FAMILY_HALF) - 1)

typedef struct {
    uintptr_t generation;  // never 0, so no ID is 0
    size_t count;          // 0: free
    lean_object * closures[LEAN_WGPU_FAMILY_CLOSURES];
} lean_wgpu_family_record;

typedef struct {
    void const * handle;   // NULL: empty
    lean_wgpu_family family;
    size_t objects;
    bool removed;          // a tombstone: a lookup goes on past it
} lean_wgpu_member;

static atomic_flag lean_wgpu_families_lock = ATOMIC_FLAG_INIT;
static lean_wgpu_family_record * lean_wgpu_families;
static size_t lean_wgpu_families_size;
static size_t * lean_wgpu_families_free;
static size_t lean_wgpu_families_free_count;
static lean_wgpu_member * lean_wgpu_members;
static size_t lean_wgpu_members_size;   // a power of 2, or 0
static size_t lean_wgpu_members_used;   // entries and tombstones
static _Thread_local lean_wgpu_family lean_wgpu_family_being_filled;

// Take the families' lock: spinning a while, then giving up the thread's
// time slice between tries, as the holder may have been preempted.
static void lean_wgpu_families_acquire(void) {
    unsigned spins = 0;
    while (atomic_flag_test_and_set_explicit(
            &lean_wgpu_families_lock, memory_order_acquire)) {
        if (++spins >= 64) {
#if defined(_WIN32)
            SwitchToThread();
#elif !defined(__EMSCRIPTEN__)
            sched_yield();
#endif
        }
    }
}

static void lean_wgpu_families_release(void) {
    atomic_flag_clear_explicit(&lean_wgpu_families_lock, memory_order_release);
}

// Out of memory: as Lean does. Reached with the lock held, which is fine only
// because it ends the program.
static void * lean_wgpu_family_alloc(void * p, size_t size) {
    void * q = realloc(p, size);
    if (q == NULL) {
        lean_internal_panic_out_of_memory();
    }
    return q;
}

// The record `f` names, if it is live; with the lock held.
static lean_wgpu_family_record * lean_wgpu_record(lean_wgpu_family f) {
    size_t index = (size_t)(f & LEAN_WGPU_FAMILY_MASK);
    uintptr_t generation = f >> LEAN_WGPU_FAMILY_HALF;
    if (index == 0 || index > lean_wgpu_families_size) {
        return NULL;
    }
    lean_wgpu_family_record * r = &lean_wgpu_families[index - 1];
    return r->count > 0 && r->generation == generation ? r : NULL;
}

lean_wgpu_family lean_wgpu_family_new(void) {
    lean_wgpu_families_acquire();
    size_t index;
    if (lean_wgpu_families_free_count > 0) {
        index = lean_wgpu_families_free[--lean_wgpu_families_free_count];
    } else {
        if (lean_wgpu_families_size >= LEAN_WGPU_FAMILY_MASK - 1) {
            // As out of memory: it ends the program, the lock held.
            lean_internal_panic("lean_wgpu_family_new: too many families");
        }
        index = lean_wgpu_families_size++;
        lean_wgpu_families = lean_wgpu_family_alloc(lean_wgpu_families,
            lean_wgpu_families_size * sizeof *lean_wgpu_families);
        lean_wgpu_families_free = lean_wgpu_family_alloc(
            lean_wgpu_families_free,
            lean_wgpu_families_size * sizeof *lean_wgpu_families_free);
        lean_wgpu_families[index].generation = 1;
    }
    lean_wgpu_family_record * r = &lean_wgpu_families[index];
    r->count = 1;
    memset(r->closures, 0, sizeof r->closures);
    lean_wgpu_family f =
        (r->generation << LEAN_WGPU_FAMILY_HALF) | (uintptr_t)(index + 1);
    lean_wgpu_families_release();
    return f;
}

void lean_wgpu_family_retain(lean_wgpu_family f) {
    lean_wgpu_families_acquire();
    lean_wgpu_family_record * r = lean_wgpu_record(f);
    if (r != NULL) {
        r->count++;
    }
    lean_wgpu_families_release();
}

// Release the closures a family held, taken out of it with the lock held.
static void lean_wgpu_release_closures(lean_object ** closures) {
    for (size_t k = 0; k < LEAN_WGPU_FAMILY_CLOSURES; k++) {
        if (closures[k] != NULL) {
            lean_dec(closures[k]);
        }
    }
}

void lean_wgpu_family_release(lean_wgpu_family f) {
    lean_object * closures[LEAN_WGPU_FAMILY_CLOSURES] = {NULL};
    lean_wgpu_families_acquire();
    lean_wgpu_family_record * r = lean_wgpu_record(f);
    if (r != NULL && --r->count == 0) {
        // Gone: its ID names nothing more, and its index is free.
        memcpy(closures, r->closures, sizeof closures);
        r->generation = (r->generation + 1) & LEAN_WGPU_FAMILY_MASK;
        if (r->generation == 0) {
            r->generation = 1;
        }
        lean_wgpu_families_free[lean_wgpu_families_free_count++] =
            (size_t)(f & LEAN_WGPU_FAMILY_MASK) - 1;
    }
    lean_wgpu_families_release();
    lean_wgpu_release_closures(closures);
}

void lean_wgpu_family_hold(
        lean_wgpu_family f, size_t ordinal, b_lean_obj_arg closure) {
    // With no family, not even marked as shared between threads.
    if (f == 0 || ordinal >= LEAN_WGPU_FAMILY_CLOSURES) {
        return;
    }
    lean_mark_mt(closure);
    lean_inc(closure);
    lean_object * old = closure;
    lean_wgpu_families_acquire();
    lean_wgpu_family_record * r = lean_wgpu_record(f);
    if (r != NULL) {
        old = r->closures[ordinal];
        r->closures[ordinal] = closure;
    }
    lean_wgpu_families_release();
    // The one held before; or, with no family, the reference just taken.
    if (old != NULL) {
        lean_dec(old);
    }
}

lean_object * lean_wgpu_family_closure(lean_wgpu_family f, size_t ordinal) {
    lean_object * closure = NULL;
    lean_wgpu_families_acquire();
    lean_wgpu_family_record * r = lean_wgpu_record(f);
    if (r != NULL && ordinal < LEAN_WGPU_FAMILY_CLOSURES) {
        closure = r->closures[ordinal];
        if (closure != NULL) {
            lean_inc(closure);
        }
    }
    lean_wgpu_families_release();
    return closure;
}

// Where `handle` is; or, if absent, where to put it: the first tombstone its
// probe passed, if any, else the empty slot it ended at. With the lock held,
// the table not empty, and `handle` not NULL, as an empty slot's is.
static lean_wgpu_member * lean_wgpu_member_slot(void const * handle) {
    size_t mask = lean_wgpu_members_size - 1;
    // Mixed, so that aligned handles, whose low bits are all 0, spread.
    uintptr_t x = (uintptr_t)handle;
    x ^= x >> 16;
    x *= 0x45D9F3Bu;
    x ^= x >> 16;
    size_t k = (size_t)x & mask;
    lean_wgpu_member * tombstone = NULL;
    for (;; k = (k + 1) & mask) {
        lean_wgpu_member * m = &lean_wgpu_members[k];
        if (m->handle == handle && !m->removed) {
            return m;
        }
        if (m->handle == NULL) {
            return tombstone != NULL ? tombstone : m;
        }
        if (m->removed && tombstone == NULL) {
            tombstone = m;
        }
    }
}

// The member entry of `handle`, or NULL; with the lock held. A NULL handle is
// of no family.
static lean_wgpu_member * lean_wgpu_member_find(void const * handle) {
    if (handle == NULL || lean_wgpu_members_size == 0) {
        return NULL;
    }
    lean_wgpu_member * m = lean_wgpu_member_slot(handle);
    return m->handle == handle && !m->removed ? m : NULL;
}

// Make room for one more entry: at most half the table used, tombstones
// counted, so a lookup always ends; with the lock held.
static void lean_wgpu_members_reserve(void) {
    if (2 * (lean_wgpu_members_used + 1) <= lean_wgpu_members_size) {
        return;
    }
    lean_wgpu_member * old = lean_wgpu_members;
    size_t old_size = lean_wgpu_members_size;
    size_t live = 0;
    for (size_t k = 0; k < old_size; k++) {
        live += old[k].handle != NULL && !old[k].removed;
    }
    size_t size = old_size == 0 ? 64 : old_size;
    while (4 * (live + 1) > size) {
        size *= 2;
    }
    lean_wgpu_members = calloc(size, sizeof *lean_wgpu_members);
    if (lean_wgpu_members == NULL) {
        lean_internal_panic_out_of_memory();
    }
    lean_wgpu_members_size = size;
    lean_wgpu_members_used = live;
    for (size_t k = 0; k < old_size; k++) {
        if (old[k].handle != NULL && !old[k].removed) {
            *lean_wgpu_member_slot(old[k].handle) = old[k];
        }
    }
    free(old);
}

void lean_wgpu_family_join(void const * handle, lean_wgpu_family f) {
    if (handle == NULL) {
        return;
    }
    lean_wgpu_families_acquire();
    lean_wgpu_family_record * r = lean_wgpu_record(f);
    if (r != NULL) {
        r->count++;
        lean_wgpu_member * m = lean_wgpu_member_find(handle);
        if (m != NULL && m->family != f) {
            // Counted into its family, it would leave the other: over-released,
            // that would free its closures while in use. A bug of the bindings.
            lean_internal_panic(
                "lean_wgpu_family_join: a handle of another family");
        }
        if (m != NULL) {
            m->objects++;
        } else {
            lean_wgpu_members_reserve();
            m = lean_wgpu_member_slot(handle);
            if (m->handle == NULL) {
                lean_wgpu_members_used++;
            }
            *m = (lean_wgpu_member){handle, f, 1, false};
        }
    }
    lean_wgpu_families_release();
}

lean_wgpu_family lean_wgpu_family_of(void const * handle) {
    lean_wgpu_families_acquire();
    lean_wgpu_member * m = lean_wgpu_member_find(handle);
    lean_wgpu_family f = m != NULL ? m->family : 0;
    lean_wgpu_families_release();
    return f;
}

lean_wgpu_family lean_wgpu_family_leave(void const * handle) {
    lean_wgpu_families_acquire();
    lean_wgpu_member * m = lean_wgpu_member_find(handle);
    lean_wgpu_family f = 0;
    if (m != NULL) {
        f = m->family;
        if (--m->objects == 0) {
            m->removed = true;
        }
    }
    lean_wgpu_families_release();
    return f;
}

lean_wgpu_family lean_wgpu_family_set_filling(lean_wgpu_family f) {
    lean_wgpu_family previous = lean_wgpu_family_being_filled;
    lean_wgpu_family_being_filled = f;
    return previous;
}

lean_wgpu_family lean_wgpu_family_filling(void) {
    return lean_wgpu_family_being_filled;
}
