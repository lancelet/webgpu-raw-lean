// Running Lean closures as WebGPU callbacks: see docs/Safety.md.
//
// A callback's closure is its userdata, held by C until it is called: a
// callback is called exactly once, so the call releases it. What it returns
// goes to the call into WebGPU that ran it, which raises the first error any
// callback in it raised; a callback run by no such call (from the browser's
// event loop, or a finalizer outside every call) that raises an error ends
// the program, as an error `main` raises does.

#ifndef LEAN_WGPU_CALLBACK_H
#define LEAN_WGPU_CALLBACK_H

#include <lean/lean.h>
#include <webgpu/webgpu.h>

// Before a call into WebGPU that can run callbacks: the error any callback in
// it raises is its own. What it returns is for `lean_wgpu_callbacks_leave`.
lean_object * lean_wgpu_callbacks_enter(void);

// After that call: the IO result for it to return, the first error a callback
// in it raised if any, else `ok`. Takes `ok`, and what `enter` returned.
lean_obj_res lean_wgpu_callbacks_leave(lean_object * saved, lean_obj_arg ok);

// A reference to `closure` (borrowed) for C to hold as a callback's userdata,
// until the callback releases it; marked as shared between threads, as the
// call that runs it may be on another.
void * lean_wgpu_closure_hold(b_lean_obj_arg closure);

// What a callback's closure returned, an IO result, taken: an error goes to
// the call running the callback, the first one it gets; outside every call it
// is printed, and the program ends.
void lean_wgpu_callback_done(lean_obj_arg result);

// A string C passes, copied into a new Lean string: valid UTF-8, each invalid
// byte U+FFFD. A view with NULL data, as the null view, is "".
lean_obj_res lean_wgpu_string_of_view(WGPUStringView view);

#endif
