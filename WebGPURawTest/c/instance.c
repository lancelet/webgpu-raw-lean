// For the tests only: an instance, until the bindings can create one.
// wgpuCreateInstance takes a descriptor, which the bindings cannot pass yet;
// with no descriptor it needs no GPU, so the tests can call functions on it
// anywhere.

#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "objects.h"

// A new instance, owning its reference, or an IO error if there is none.
LEAN_EXPORT lean_obj_res lean_wgpu_test_create_instance(void) {
    WGPUInstance instance = wgpuCreateInstance(NULL);
    if (instance == NULL) {
        return lean_io_result_mk_error(
            lean_mk_io_user_error(lean_mk_string("wgpuCreateInstance failed"))
        );
    }
    return lean_io_result_mk_ok(lean_wgpu_instance_box(instance));
}
