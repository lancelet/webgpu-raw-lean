// The web self-test's entry point, as Lean's own generated main does it, but
// running the program on this thread: Lean's main starts a thread for a large
// stack, which single-threaded WebAssembly cannot.

#include <lean/lean.h>

// Lean's runtime (src/runtime/init_module.cpp); lean.h does not declare it.
void lean_initialize_runtime_module(void);

lean_object * initialize_WebGPURaw_WebGPURawWebTest(uint8_t builtin);

// `WebGPURawWebTest.main : IO UInt32`, exported as `web_main`.
lean_object * web_main(void);

int main(void) {
    lean_initialize_runtime_module();
    lean_object * res = initialize_WebGPURaw_WebGPURawWebTest(1);
    lean_io_mark_end_initialization();
    if (lean_io_result_is_ok(res)) {
        lean_dec_ref(res);
        lean_init_task_manager();
        res = web_main();
    }
    lean_finalize_task_manager();
    int code = 1;
    if (lean_io_result_is_ok(res)) {
        code = (int)lean_unbox_uint32(lean_io_result_get_value(res));
    } else {
        lean_io_result_show_error(res);
    }
    lean_dec_ref(res);
    return code;
}
