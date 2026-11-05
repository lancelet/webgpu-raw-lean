import WebGPUGen.Emit.C.Objects
import WebGPUGenTest.Literal

/-!
# Tests for the object shims

The header and source for one object type, compared with the exact C expected.
The test driver also compiles the shims for every object type of the real spec
against `webgpu.h` and `lean.h`.
-/

namespace WebGPUGenTest.Emit.C.Objects
open WebGPUGen WebGPUGen.Emit.C

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- The device object type, as lowering gives it. -/
def device : Lowered.Object := {
  names    := {
    c    := "WGPUDevice"
    lean := "Device"
  }
  doc      := ""
  release  := "wgpuDeviceRelease"
  shim     := "lean_wgpu_device"
  extended := false
  methods  := #[]
}

/-- The queue object type, as lowering gives it. -/
def queue : Lowered.Object := {
  names    := {
    c    := "WGPUQueue"
    lean := "Queue"
  }
  doc      := ""
  release  := "wgpuQueueRelease"
  shim     := "lean_wgpu_queue"
  extended := false
  methods  := #[]
}

/-! ## The header -/

-- What other shims include: boxing and unboxing.
#guard
  let expected := dedent "
    #pragma once

    #include <lean/lean.h>
    #include <webgpu/webgpu.h>

    // A Lean `Device` owning the reference `handle`, which it releases when Lean
    // frees it.
    lean_obj_res lean_wgpu_device_box(WGPUDevice handle);

    // The `WGPUDevice` a Lean `Device` holds; the Lean value keeps the reference.
    WGPUDevice lean_wgpu_device_unbox(b_lean_obj_arg object);

    // A Lean `Option Device`: `none` for NULL, and otherwise owning the reference
    // `handle`.
    lean_obj_res lean_wgpu_device_box_option(WGPUDevice handle);

    // The `WGPUDevice` a Lean `Option Device` holds, or NULL for `none`; the Lean
    // value keeps the reference.
    WGPUDevice lean_wgpu_device_unbox_option(b_lean_obj_arg option);
    "
  file (objectsHeader [device]) == expected

/-! ## The source -/

-- A class per object type, registered by the bindings' start-up, whose
-- finalizer releases the handle, leaving its family first (a new object at
-- the address meets no entry of it) and giving back its reference after;
-- boxing takes the reference, and stops the
-- program on a NULL handle (a regression test: releasing NULL crashes) or
-- before start-up; unboxing borrows it.
#guard
  let expected := dedent "
    #include \"family.h\"
    #include \"objects.h\"

    // An object holds no Lean values, so there are none to visit.
    static void lean_wgpu_visit_nothing(
        void *         data,
        b_lean_obj_arg visitor
    ) {
        (void)data;
        (void)visitor;
    }

    static lean_external_class * lean_wgpu_device_class = NULL;

    // Release the reference a Lean `Device` owned, when Lean frees it: it leaves
    // its family first, and gives back its reference after.
    static void lean_wgpu_device_finalize(void * data) {
        lean_wgpu_family family = lean_wgpu_family_leave(data);
        wgpuDeviceRelease((WGPUDevice)data);
        lean_wgpu_family_release(family);
    }

    // The bindings' start-up, run by Lean when a program using them starts:
    // register every object type's external class.
    LEAN_EXPORT lean_obj_res lean_wgpu_objects_init(void) {
        lean_wgpu_device_class = lean_register_external_class(
            lean_wgpu_device_finalize,
            lean_wgpu_visit_nothing
        );
        return lean_io_result_mk_ok(lean_box(0));
    }

    // A Lean `Device` owning the reference `handle`, which it releases when Lean
    // frees it.
    lean_obj_res lean_wgpu_device_box(WGPUDevice handle) {
        if (handle == NULL) {
            lean_internal_panic(\"lean_wgpu_device_box: a NULL WGPUDevice\");
        }
        if (lean_wgpu_device_class == NULL) {
            lean_internal_panic(
                \"lean_wgpu_device_box: before the bindings started\"
            );
        }
        return lean_alloc_external(lean_wgpu_device_class, handle);
    }

    // The `WGPUDevice` a Lean `Device` holds; the Lean value keeps the reference.
    WGPUDevice lean_wgpu_device_unbox(b_lean_obj_arg object) {
        return (WGPUDevice)lean_get_external_data(object);
    }

    // A Lean `Option Device`: `none` for NULL, and otherwise owning the reference
    // `handle`.
    lean_obj_res lean_wgpu_device_box_option(WGPUDevice handle) {
        if (handle == NULL) {
            return lean_box(0);
        }
        lean_object * some = lean_alloc_ctor(1, 1, 0);
        lean_ctor_set(some, 0, lean_wgpu_device_box(handle));
        return some;
    }

    // The `WGPUDevice` a Lean `Option Device` holds, or NULL for `none`; the Lean
    // value keeps the reference.
    WGPUDevice lean_wgpu_device_unbox_option(b_lean_obj_arg option) {
        if (lean_is_scalar(option)) {
            return NULL;
        }
        return lean_wgpu_device_unbox(lean_ctor_get(option, 0));
    }
    "
  file (objectsSource [device]) == expected

-- Several object types: their class variables stay together, aligned.
#guard
  let expected := dedent "
    static lean_external_class * lean_wgpu_device_class = NULL;
    static lean_external_class * lean_wgpu_queue_class  = NULL;
    "
  (file (objectsSource [device, queue])).splitOn "\n\n" |>.any (· ++ "\n" == expected)

end WebGPUGenTest.Emit.C.Objects
