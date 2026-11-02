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
  names   := {
    c    := "WGPUDevice"
    lean := "Device"
  }
  doc     := ""
  release := "wgpuDeviceRelease"
  shim    := "lean_wgpu_device"
}

/-! ## The header -/

-- What other shims include: registering the classes, boxing and unboxing.
#guard
  let expected := dedent "
    #pragma once

    #include <lean/lean.h>
    #include <webgpu/webgpu.h>

    // Register the external class of every object type. Called once, when the
    // bindings are loaded, before any object is boxed.
    void lean_wgpu_register_object_classes(void);

    // A Lean `Device` owning the reference `handle`, which it releases when Lean
    // frees it.
    lean_obj_res lean_wgpu_device_box(WGPUDevice handle);

    // The `WGPUDevice` a Lean `Device` holds; the Lean value keeps the reference.
    WGPUDevice lean_wgpu_device_unbox(b_lean_obj_arg object);
    "
  file (objectsHeader [device]) == expected

/-! ## The source -/

-- A class per object type whose finalizer releases the handle; boxing takes the
-- reference, unboxing borrows it. Boxing stops the program, loudly, on a NULL
-- handle (whose release would crash) or before the classes are registered (a
-- value without a class would crash when freed): regression tests, both.
#guard
  let expected := dedent "
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

    // Release the reference a Lean `Device` owned, when Lean frees it.
    static void lean_wgpu_device_finalize(void * data) {
        wgpuDeviceRelease((WGPUDevice)data);
    }

    // Register the external class of every object type. Called once, when the
    // bindings are loaded, before any object is boxed.
    void lean_wgpu_register_object_classes(void) {
        lean_wgpu_device_class = lean_register_external_class(
            lean_wgpu_device_finalize,
            lean_wgpu_visit_nothing
        );
    }

    // A Lean `Device` owning the reference `handle`, which it releases when Lean
    // frees it.
    lean_obj_res lean_wgpu_device_box(WGPUDevice handle) {
        if (handle == NULL) {
            lean_internal_panic(\"lean_wgpu_device_box: a NULL WGPUDevice\");
        }
        if (lean_wgpu_device_class == NULL) {
            lean_internal_panic(
                \"lean_wgpu_device_box: object classes not registered\"
            );
        }
        return lean_alloc_external(lean_wgpu_device_class, handle);
    }

    // The `WGPUDevice` a Lean `Device` holds; the Lean value keeps the reference.
    WGPUDevice lean_wgpu_device_unbox(b_lean_obj_arg object) {
        return (WGPUDevice)lean_get_external_data(object);
    }
    "
  file (objectsSource [device]) == expected

-- Several object types: their class variables stay together, aligned.
#guard
  let queue : Lowered.Object := {
    names   := {
      c    := "WGPUQueue"
      lean := "Queue"
    }
    doc     := ""
    release := "wgpuQueueRelease"
    shim    := "lean_wgpu_queue"
  }
  let expected := dedent "
    static lean_external_class * lean_wgpu_device_class = NULL;
    static lean_external_class * lean_wgpu_queue_class  = NULL;
    "
  (file (objectsSource [device, queue])).splitOn "\n\n" |>.any (· ++ "\n" == expected)

end WebGPUGenTest.Emit.C.Objects
