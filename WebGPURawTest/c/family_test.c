// For the family tests (WebGPURawTest/Internal/Family.lean): the families
// (c/family.c) driven from Lean, a family's ID as a `USize`, a handle as any
// nonzero `USize`; and fake members, Lean objects of a handle whose finalizer
// leaves the handle's family, as a WebGPU object's does.

#include <lean/lean.h>
#include "family.h"

static lean_obj_res lean_wgpu_test_unit(void) {
    return lean_io_result_mk_ok(lean_box(0));
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_family_new(void) {
    return lean_io_result_mk_ok(lean_box_usize(lean_wgpu_family_new()));
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_family_retain(size_t f) {
    lean_wgpu_family_retain(f);
    return lean_wgpu_test_unit();
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_family_release(size_t f) {
    lean_wgpu_family_release(f);
    return lean_wgpu_test_unit();
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_family_hold(
        size_t f, size_t ordinal, b_lean_obj_arg closure) {
    lean_wgpu_family_hold(f, ordinal, closure);
    return lean_wgpu_test_unit();
}

// Run the closure `f` holds at `ordinal`, an `IO Unit` of `Unit`: whether
// there was one, or the error it raised.
LEAN_EXPORT lean_obj_res lean_wgpu_test_family_call(size_t f, size_t ordinal) {
    lean_object * closure = lean_wgpu_family_closure(f, ordinal);
    if (closure == NULL) {
        return lean_io_result_mk_ok(lean_box(0));
    }
    lean_object * result =
        lean_apply_2(closure, lean_box(0), lean_io_mk_world());
    if (!lean_io_result_is_ok(result)) {
        return result;
    }
    lean_dec(result);
    return lean_io_result_mk_ok(lean_box(1));
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_family_join(size_t handle, size_t f) {
    lean_wgpu_family_join((void const *)handle, f);
    return lean_wgpu_test_unit();
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_family_of(size_t handle) {
    return lean_io_result_mk_ok(
        lean_box_usize(lean_wgpu_family_of((void const *)handle)));
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_family_leave(size_t handle) {
    return lean_io_result_mk_ok(
        lean_box_usize(lean_wgpu_family_leave((void const *)handle)));
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_family_set_filling(size_t f) {
    return lean_io_result_mk_ok(
        lean_box_usize(lean_wgpu_family_set_filling(f)));
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_family_filling(void) {
    return lean_io_result_mk_ok(lean_box_usize(lean_wgpu_family_filling()));
}

// Fake members: each a handle, joined to a family when made, which leaves it
// and releases its reference when finalized, as a WebGPU object does. Their
// class is registered when the first is made, which the tests do on the main
// thread only.
static lean_external_class * lean_wgpu_test_member_class;

static void lean_wgpu_test_member_finalize(void * data) {
    lean_wgpu_family f = lean_wgpu_family_leave(data);
    lean_wgpu_family_release(f);
}

static void lean_wgpu_test_member_foreach(void * data, b_lean_obj_arg g) {
    (void)data;
    (void)g;
}

LEAN_EXPORT lean_obj_res lean_wgpu_test_family_member(size_t handle, size_t f) {
    if (lean_wgpu_test_member_class == NULL) {
        lean_wgpu_test_member_class = lean_register_external_class(
            lean_wgpu_test_member_finalize, lean_wgpu_test_member_foreach);
    }
    lean_wgpu_family_join((void const *)handle, f);
    return lean_io_result_mk_ok(
        lean_alloc_external(lean_wgpu_test_member_class, (void *)handle));
}

// Use a fake member: so a closure that does holds it.
LEAN_EXPORT lean_obj_res lean_wgpu_test_family_touch(b_lean_obj_arg m) {
    (void)m;
    return lean_wgpu_test_unit();
}
