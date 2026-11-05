import WebGPUGen.Emit.C.Functions
import WebGPUGenTest.Literal

/-!
# Tests for the function shims

Shims for functions written out in the lowered model, compared with the exact C
expected. The test driver also compiles the shims for every function of the
real spec against `webgpu.h` and `lean.h`.
-/

namespace WebGPUGenTest.Emit.C.Functions
open WebGPUGen WebGPUGen.Lowered WebGPUGen.Emit.C

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- The buffer object type, as lowering gives it. -/
def buffer : Lowered.Object := {
  names    := {
    c    := "WGPUBuffer"
    lean := "Buffer"
  }
  doc      := ""
  release  := "wgpuBufferRelease"
  shim     := "lean_wgpu_buffer"
  extended := false
  methods  := #[]
}

/-- An undocumented argument whose name is the same on both sides. -/
def arg (name : String) (value : Value) : Arg := {
  names := {
    c    := name
    lean := name
  }
  doc   := ""
  value := value
}

/-- A function of no object type, with the arguments and result given. -/
def function (args : Array Arg) (result : Option Value) : Lowered.Function := {
  names    := {
    c    := "wgpuDoIt"
    lean := "doIt"
  }
  doc      := ""
  receiver := none
  args     := args
  result   := result
  callback := none
}

/-- The shim for `f`, printed, if it has one. -/
def shimText (f : Lowered.Function) : Option String :=
  (functionShim [buffer] [] f).map fun s => file [.function s]

/-! ## Shims -/

-- A method with every kind of value: its object first, as `self`; each
-- argument converted from its Lean ABI type, a `size_t` checked to fit first;
-- and an optional object result, boxed with its reference.
#guard
  let input : Lowered.Function := {
    names    := {
      c    := "wgpuBufferDoAll"
      lean := "Buffer.doAll"
    }
    doc      := ""
    receiver := some buffer.names
    args     := #[
      arg "flag" .bool,
      arg "count" .int32,
      arg "size" .usize,
      arg "mode" (.enum ⟨"WGPUMode", "Mode"⟩),
      arg "usage" (.bitflag ⟨"WGPUBufferUsage", "BufferUsage"⟩),
      arg "other" (.object buffer.names true),
      arg "label" (.string true)
    ]
    result   := some (.object buffer.names true)
    callback := none
  }
  let expected := dedent "
    // Lean's `Buffer.doAll`: calls `wgpuBufferDoAll`.
    LEAN_EXPORT lean_obj_res lean_wgpuBufferDoAll(
        b_lean_obj_arg self,
        uint8_t        flag,
        uint32_t       count,
        uint64_t       size,
        uint32_t       mode,
        uint64_t       usage,
        b_lean_obj_arg other,
        b_lean_obj_arg label
    ) {
        if ((size != UINT64_MAX) && (((uint64_t)((size_t)size)) != size)) {
            return lean_wgpu_io_error(
                \"Buffer.doAll: size is too large for a size_t\"
            );
        }
        WGPUBuffer result = wgpuBufferDoAll(
            lean_wgpu_buffer_unbox(self),
            (WGPUBool)flag,
            (int32_t)count,
            lean_wgpu_size(size),
            (WGPUMode)mode,
            (WGPUBufferUsage)usage,
            lean_wgpu_buffer_unbox_option(other),
            lean_wgpu_option_string_view(label)
        );
        return lean_io_result_mk_ok(lean_wgpu_buffer_box_option(result));
    }
    "
  shimText input == some expected

-- A function of no object type that returns nothing returns `()`; a string
-- argument is viewed in place.
#guard
  let input := function #[arg "label" (.string false)] none
  let expected := dedent "
    // Lean's `doIt`: calls `wgpuDoIt`.
    LEAN_EXPORT lean_obj_res lean_wgpuDoIt(b_lean_obj_arg label) {
        wgpuDoIt(lean_wgpu_string_view(label));
        return lean_io_result_mk_ok(lean_box(0));
    }
    "
  shimText input == some expected

-- Numbers are boxed as Lean boxes their types: an enum as its code, a `Bool`
-- from a `WGPUBool` that may be any nonzero value.
#guard
  let results := [
    (.bool,                   "lean_box(result != 0)"),
    (.uint32,                 "lean_box_uint32(result)"),
    (.uint64,                 "lean_box_uint64(result)"),
    (.usize,
      "lean_box_uint64(lean_wgpu_size_to_lean(result))"),
    (.int32,                  "lean_box_uint32((uint32_t)result)"),
    (.float32,                "lean_box_float32(result)"),
    (.float64,                "lean_box_float(result)"),
    (.enum ⟨"WGPUMode", "M"⟩, "lean_box_uint32((uint32_t)result)"),
    (.object buffer.names false, "lean_wgpu_buffer_box(result)")
  ]
  -- (Compared without spaces or line breaks: a long return breaks.)
  let squeeze (s : String) := String.ofList (s.toList.filter (!·.isWhitespace))
  results.all fun (v, boxed) =>
    let text := shimText (function #[] (some v))
    let expected := squeeze ("lean_io_result_mk_ok(" ++ boxed)
    text.any fun t => (squeeze t).contains expected

-- An object result that is not optional must not be NULL: if it is, the shim
-- returns an `IO` error, rather than make a Lean value of nothing.
#guard
  let input := function #[] (some (.object buffer.names false))
  let expected := dedent "
    // Lean's `doIt`: calls `wgpuDoIt`.
    LEAN_EXPORT lean_obj_res lean_wgpuDoIt(void) {
        WGPUBuffer result = wgpuDoIt();
        if (result == NULL) {
            return lean_wgpu_io_error(\"doIt returned NULL\");
        }
        return lean_io_result_mk_ok(lean_wgpu_buffer_box(result));
    }
    "
  shimText input == some expected

-- A function an implementation leaves unimplemented: its shim calls it only
-- when built against one that implements it, and otherwise raises an IO error
-- (calling it would abort), its parameters marked used. So a build that says
-- nothing gets the error, never the abort.
#guard
  let input := { function #[arg "count" .uint32] none with
    notImplementedBy := ["wgpu-native"] }
  let expected := dedent "
    // Lean's `doIt`: calls `wgpuDoIt`.
    LEAN_EXPORT lean_obj_res lean_wgpuDoIt(uint32_t count) {
        #ifdef WEBGPU_RAW_DAWN
        wgpuDoIt(count);
        return lean_io_result_mk_ok(lean_box(0));
        #else
        (void)count;
        return lean_wgpu_io_error(\"doIt: not implemented by wgpu-native\");
        #endif
    }
    "
  shimText input == some expected

-- A function no implementation implements is the error alone.
#guard
  let input := { function #[] none with
    notImplementedBy := ["wgpu-native", "dawn"] }
  (shimText input).any fun text =>
    !text.contains "#if" && text.contains "not implemented by wgpu-native, dawn"

-- The macro for an implementation is its name, in capitals.
#guard implementationMacro "dawn" == "WEBGPU_RAW_DAWN"

/-! ## Callbacks -/

/-- A callback of every kind of argument a callback can pass. -/
def found : Lowered.Callback := {
  names := {
    c    := "WGPUFoundCallback"
    lean := "FoundCallback"
  }
  doc   := ""
  style := .callbackMode
  args  := #[
    arg "status" (.enum ⟨"WGPUMode", "Mode"⟩),
    arg "buffer" (.object buffer.names true),
    arg "message" (.string false)
  ]
}

-- A callback's trampoline: each argument boxed as the closure takes it, an
-- enum as its code, an object with the reference C gives it, as an `Option`,
-- a string copied; then the closure applied, releasing it, its result given
-- to the call running it.
#guard
  let expected := dedent "
    // Calls the Lean closure `userdata1` as a `FoundCallback`, releasing it.
    static inline void lean_WGPUFoundCallback(
        WGPUMode       status,
        WGPUBuffer     buffer,
        WGPUStringView message,
        void *         userdata1,
        void *         userdata2
    ) {
        (void)userdata2;
        lean_wgpu_callback_done(
            lean_apply_4(
                (lean_object *)userdata1,
                lean_box_uint32((uint32_t)status),
                lean_wgpu_buffer_box_option(buffer),
                lean_wgpu_string_of_view(message),
                lean_io_mk_world()
            )
        );
    }
    "
  (trampoline [buffer] found).map (file [.function ·]) == some expected

-- A function that takes a callback: its mode's code and its closure, which
-- the shim holds as the callback's userdata, passing its trampoline; the call
-- bracketed, so that the first error a callback in it raised is its result;
-- and its future returned as its ID.
#guard
  let input :=
    { function #[arg "name" (.string false)] (some .future) with
      callback := some found }
  let expected := dedent "
    // Lean's `doIt`: calls `wgpuDoIt`.
    LEAN_EXPORT lean_obj_res lean_wgpuDoIt(
        b_lean_obj_arg name,
        uint32_t       callbackMode,
        b_lean_obj_arg callback
    ) {
        WGPUFoundCallbackInfo callbackInfo = {
            .nextInChain = NULL,
            .mode        = (WGPUCallbackMode)callbackMode,
            .callback    = lean_WGPUFoundCallback,
            .userdata1   = lean_wgpu_closure_hold(callback),
            .userdata2   = NULL,
        };
        lean_object * saved = lean_wgpu_callbacks_enter();
        WGPUFuture result = wgpuDoIt(lean_wgpu_string_view(name), callbackInfo);
        return lean_wgpu_callbacks_leave(
            saved,
            lean_io_result_mk_ok(lean_box_uint64(result.id))
        );
    }
    "
  shimText input == some expected

-- Not one with an argument named like the shim's own variables for its
-- callback, nor a callback argument named like its closure.
#guard
  let named (x : String) :=
    { function #[arg x .uint32] (some .future) with callback := some found }
  let calledCallback :=
    { found with args := #[arg "callback" (.string false)] }
  ["callbackMode", "callback", "callbackInfo", "saved"].all
      (fun x => shimText (named x) == none)
    && shimText { function #[] (some .future) with
      callback := some calledCallback } == none

-- A function that runs other calls' callbacks, as `processEvents` does, is
-- bracketed too, so that the first error one raised is its result, not the
-- end of the program. (A regression test: under Node, `requestAdapter`'s
-- callback ran in `processEvents`, outside every call.)
#guard
  let input : Lowered.Function := {
    names    := {
      c    := "wgpuInstanceProcessEvents"
      lean := "Instance.processEvents"
    }
    doc      := ""
    receiver := none
    args     := #[]
    result   := none
    callback := none
  }
  let expected := dedent "
    // Lean's `Instance.processEvents`: calls `wgpuInstanceProcessEvents`.
    LEAN_EXPORT lean_obj_res lean_wgpuInstanceProcessEvents(void) {
        lean_object * saved = lean_wgpu_callbacks_enter();
        wgpuInstanceProcessEvents();
        return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(lean_box(0)));
    }
    "
  shimText input == some expected

-- So is one that can run a callback another call took, as unmapping a buffer
-- runs its `mapAsync`'s, aborted. (A regression test: the shims of
-- `Buffer.unmap` and `Buffer.destroy` were not bracketed.)
#guard
  let method (c lean : String) : Lowered.Function := {
    names    := ⟨c, lean⟩
    doc      := ""
    receiver := some buffer.names
    args     := #[]
    result   := none
    callback := none
  }
  [("wgpuBufferUnmap", "Buffer.unmap"), ("wgpuBufferDestroy", "Buffer.destroy"),
    ("wgpuQueueSubmit", "Queue.submit")].all fun (c, lean) =>
      runsCallbacks (method c lean)
        && (shimText (method c lean)).map
          (·.splitOn "lean_wgpu_callbacks_enter()" |>.length) == some 2

/-! ## Not bound -/

-- A function the bindings cannot pass every value of has no shim.
#guard
  let input := function #[arg "descriptor" (.unsupported "struct")] none
  shimText input == none

-- Nor a function with an argument named like a shim's own variable, which
-- would hide it; the test driver checks no function of the spec is lost so.
#guard
  shimText (function #[arg "result" .uint32] none) == none
    && shimText (function #[arg "self" .uint32] none) == none

-- Nor a method of an object type the shims do not know.
#guard
  let other : Names := ⟨"WGPUOther", "Other"⟩
  let input := { function #[] none with receiver := some other }
  shimText input == none

/-! ## The file -/

-- Only the helpers some shim uses are defined: C warns of the others.
#guard
  let spec : Lowered.Spec := {
    constants := #[]
    enums     := #[]
    bitflags  := #[]
    structs   := #[]
    objects   := #[]
    functions := #[function #[arg "label" (.string false)] none]
  }
  let source := file (functionsSource spec)
  source.contains "lean_wgpu_string_view(b_lean_obj_arg s)"
    && !source.contains "lean_wgpu_option_string_view(b_lean_obj_arg"
    && !source.contains "lean_wgpu_too_large(char const"

-- A struct behind a pointer crosses as itself, its bytes, its targets and its
-- table's index, the shim taking the tables too; C fills it in, into a pointer
-- to pass. Only a bound struct: one that is not has no table, so no shim.
#guard
  let descriptor : Names := ⟨"WGPUDescriptor", "Descriptor"⟩
  let f := function #[arg "desc" (.structPointer descriptor true)] none
  let bound := (functionShim [buffer] [descriptor] f).map fun s =>
    file [.function s]
  (functionShim [buffer] [] f).isNone && bound == some (dedent "
    // Lean's `doIt`: calls `wgpuDoIt`.
    LEAN_EXPORT lean_obj_res lean_wgpuDoIt(
        b_lean_obj_arg desc,
        b_lean_obj_arg desc_bytes,
        b_lean_obj_arg desc_targets,
        b_lean_obj_arg desc_table,
        b_lean_obj_arg tables
    ) {
        (void)desc;
        void const * desc_struct = lean_wgpu_fill_arg(
            desc_bytes,
            tables,
            lean_usize_of_nat(desc_table),
            desc_targets
        );
        wgpuDoIt(desc_struct);
        return lean_io_result_mk_ok(lean_box(0));
    }
    ")

end WebGPUGenTest.Emit.C.Functions
