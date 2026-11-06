// The window library on the web (`WebGPUWindow.lean`): the window is the
// page's canvas, `#canvas`; its events come from Emscripten's HTML5
// callbacks, queued till polled; a surface is made on it by its selector;
// and the frame loop is the browser's animation frames. The native one is
// `window_sdl.c`.
//
// A surface never outlives its window: it joins a family (`c/family.c`) that
// holds the Lean window, as natively.

#ifdef __EMSCRIPTEN__

#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <emscripten.h>
#include <emscripten/eventloop.h>
#include <emscripten/html5.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "callback.h"
#include "family.h"
#include "generated/objects.h"

// The canvas a window is.
static char const lean_wgpu_canvas[] = "#canvas";

static lean_external_class * lean_wgpu_window_class = NULL;

// A window holds nothing of its own: the canvas is the page's.
static void lean_wgpu_window_finalize(void * data) {
    (void)data;
}

static void lean_wgpu_window_visit(void * data, b_lean_obj_arg visitor) {
    (void)data;
    (void)visitor;
}

// An IO error with `message`.
static lean_obj_res lean_wgpu_window_error(char const * message) {
    return lean_io_result_mk_error(
        lean_mk_io_user_error(lean_mk_string(message)));
}

// The events queued since the last poll, five values each, as natively.
static double * lean_wgpu_events = NULL;
static size_t lean_wgpu_event_count = 0;
static size_t lean_wgpu_event_capacity = 0;

// Queue an event; dropped if out of memory, or if 65536 wait (as SDL caps
// its queue), as when nothing polls.
static void lean_wgpu_queue(double a, double b, double c, double d,
        double e) {
    if (lean_wgpu_event_count >= 65536) {
        return;
    }
    if (lean_wgpu_event_count == lean_wgpu_event_capacity) {
        size_t capacity =
            lean_wgpu_event_capacity == 0 ? 16 : 2 * lean_wgpu_event_capacity;
        double * grown =
            realloc(lean_wgpu_events, capacity * 5 * sizeof *grown);
        if (grown == NULL) {
            return;
        }
        lean_wgpu_events = grown;
        lean_wgpu_event_capacity = capacity;
    }
    double * v = lean_wgpu_events + 5 * lean_wgpu_event_count++;
    v[0] = a;
    v[1] = b;
    v[2] = c;
    v[3] = d;
    v[4] = e;
}

// The mouse's events over the canvas, in its CSS pixels (as a stylesheet
// scales it, not the canvas's): handled, so the page does not scroll, nor
// show its menu, over it. The wheel's are as the browser gives them (in
// its `deltaMode`'s units). The keys' go on to the page.
static bool lean_wgpu_on_mouse(int type, EmscriptenMouseEvent const * e,
        void * data) {
    (void)data;
    if (type == EMSCRIPTEN_EVENT_MOUSEMOVE) {
        lean_wgpu_queue(3, e->targetX, e->targetY, 0, 0);
    } else {
        // DOM buttons count from 0 (the main); SDL's, and so ours, from 1.
        lean_wgpu_queue(4, e->button + 1,
            type == EMSCRIPTEN_EVENT_MOUSEDOWN ? 1 : 0,
            e->targetX, e->targetY);
    }
    return true;
}

static bool lean_wgpu_on_wheel(int type, EmscriptenWheelEvent const * e,
        void * data) {
    (void)type;
    (void)data;
    // The DOM's down is positive, SDL's negative: as SDL, natively.
    lean_wgpu_queue(5, e->deltaX, -e->deltaY, 0, 0);
    return true;
}

static bool lean_wgpu_on_key(int type, EmscriptenKeyboardEvent const * e,
        void * data) {
    (void)data;
    // A key's code, as SDL's: its character's code point, for a key one
    // character names (`e->key`, in UTF-8); those of a few named keys; else
    // 0 (arrows, function keys, modifiers and the like).
    static struct { char const * name; uint32_t code; } const named[] = {
        {"Enter", 13}, {"Escape", 27}, {"Backspace", 8}, {"Tab", 9},
        {"Delete", 127}
    };
    uint32_t code = 0;
    unsigned char const * k = (unsigned char const *)e->key;
    size_t length = strlen(e->key);
    if (length == 1 && k[0] < 0x80) {
        code = k[0];
    } else if (length == 2 && (k[0] & 0xE0) == 0xC0) {
        code = ((uint32_t)(k[0] & 0x1F) << 6) | (k[1] & 0x3F);
    } else if (length == 3 && (k[0] & 0xF0) == 0xE0) {
        code = ((uint32_t)(k[0] & 0x0F) << 12) | ((k[1] & 0x3F) << 6)
            | (k[2] & 0x3F);
    } else if (length == 4 && (k[0] & 0xF8) == 0xF0) {
        code = ((uint32_t)(k[0] & 0x07) << 18) | ((k[1] & 0x3F) << 12)
            | ((k[2] & 0x3F) << 6) | (k[3] & 0x3F);
    } else {
        for (size_t i = 0; i < sizeof named / sizeof named[0]; i++) {
            if (strcmp(e->key, named[i].name) == 0) {
                code = named[i].code;
            }
        }
    }
    lean_wgpu_queue(6, code, type == EMSCRIPTEN_EVENT_KEYDOWN ? 1 : 0,
        e->repeat ? 1 : 0, 0);
    return false;
}

// The canvas, `width` by `height` pixels, titled `title` (the page's title),
// its events queued.
LEAN_EXPORT lean_obj_res lean_wgpu_window_create(
        b_lean_obj_arg title, uint32_t width, uint32_t height) {
    if (emscripten_set_canvas_element_size(
            lean_wgpu_canvas, (int)width, (int)height)
            != EMSCRIPTEN_RESULT_SUCCESS) {
        return lean_wgpu_window_error("Window.create: no canvas");
    }
    emscripten_set_window_title(lean_string_cstr(title));
    // The canvas's events, registered once: a second window is the same
    // canvas, and registering again would queue each event twice.
    if (lean_wgpu_window_class == NULL) {
        emscripten_set_mousemove_callback(
            lean_wgpu_canvas, NULL, false, lean_wgpu_on_mouse);
        emscripten_set_mousedown_callback(
            lean_wgpu_canvas, NULL, false, lean_wgpu_on_mouse);
        emscripten_set_mouseup_callback(
            lean_wgpu_canvas, NULL, false, lean_wgpu_on_mouse);
        emscripten_set_wheel_callback(
            lean_wgpu_canvas, NULL, false, lean_wgpu_on_wheel);
        emscripten_set_keydown_callback(
            EMSCRIPTEN_EVENT_TARGET_WINDOW, NULL, false, lean_wgpu_on_key);
        emscripten_set_keyup_callback(
            EMSCRIPTEN_EVENT_TARGET_WINDOW, NULL, false, lean_wgpu_on_key);
        lean_wgpu_window_class = lean_register_external_class(
            lean_wgpu_window_finalize, lean_wgpu_window_visit);
    }
    return lean_io_result_mk_ok(
        lean_alloc_external(lean_wgpu_window_class, NULL));
}

// A window with no window, on macOS only: here an IO error.
LEAN_EXPORT lean_obj_res lean_wgpu_window_create_headless(
        uint32_t width, uint32_t height) {
    (void)width;
    (void)height;
    return lean_wgpu_window_error("Window.createHeadless: only on macOS");
}

// The events since the last poll, five values each.
LEAN_EXPORT lean_obj_res lean_wgpu_window_poll(b_lean_obj_arg window) {
    (void)window;
    size_t count = lean_wgpu_event_count * 5;
    lean_object * array = lean_alloc_sarray(sizeof(double), count, count);
    if (count > 0) {
        memcpy(lean_float_array_cptr(array), lean_wgpu_events,
            count * sizeof(double));
    }
    lean_wgpu_event_count = 0;
    return lean_io_result_mk_ok(array);
}

// The canvas's size in pixels.
LEAN_EXPORT lean_obj_res lean_wgpu_window_size(b_lean_obj_arg window) {
    (void)window;
    int width = 0;
    int height = 0;
    emscripten_get_canvas_element_size(lean_wgpu_canvas, &width, &height);
    lean_object * pair = lean_alloc_ctor(0, 2, 0);
    lean_ctor_set(pair, 0, lean_box_uint32((uint32_t)width));
    lean_ctor_set(pair, 1, lean_box_uint32((uint32_t)height));
    return lean_io_result_mk_ok(pair);
}

// A surface of `instance` on the canvas, by its selector; it holds the
// window till it is gone.
LEAN_EXPORT lean_obj_res lean_wgpu_window_create_surface(
        b_lean_obj_arg window, b_lean_obj_arg instance) {
    WGPUEmscriptenSurfaceSourceCanvasHTMLSelector source =
        WGPU_EMSCRIPTEN_SURFACE_SOURCE_CANVAS_HTML_SELECTOR_INIT;
    source.selector = (WGPUStringView){lean_wgpu_canvas, WGPU_STRLEN};
    WGPUSurfaceDescriptor descriptor = WGPU_SURFACE_DESCRIPTOR_INIT;
    descriptor.nextInChain = &source.chain;
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUSurface surface = wgpuInstanceCreateSurface(
        lean_wgpu_instance_unbox(instance), &descriptor);
    if (surface == NULL) {
        return lean_wgpu_callbacks_leave(saved,
            lean_wgpu_window_error("Window.createSurface: no surface"));
    }
    lean_wgpu_family family = lean_wgpu_family_new();
    lean_wgpu_family_hold(family, LEAN_WGPU_SURFACE_WINDOW, window);
    lean_object * object = lean_wgpu_surface_box(surface);
    lean_wgpu_family_join(surface, family);
    lean_wgpu_family_release(family);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(object));
}

// An animation frame: apply the frame closure (`data`, held) to the seconds
// since the first; go on while it returns true. An error it raises, from the
// event loop, outside every call, ends the program (`c/callback.c`).
static double lean_wgpu_first_frame = -1;

static bool lean_wgpu_on_frame(double milliseconds, void * data) {
    lean_object * frame = data;
    if (lean_wgpu_first_frame < 0) {
        lean_wgpu_first_frame = milliseconds;
    }
    double seconds = (milliseconds - lean_wgpu_first_frame) / 1000;
    lean_inc(frame);
    lean_object * result = lean_apply_2(
        frame, lean_box_float(seconds), lean_io_mk_world());
    if (lean_io_result_is_error(result)) {
        lean_dec(frame);
        emscripten_runtime_keepalive_pop();
        lean_wgpu_callback_done(result);
        return false;
    }
    uint8_t go_on = lean_unbox(lean_io_result_get_value(result));
    lean_dec(result);
    if (!go_on) {
        lean_dec(frame);
        emscripten_runtime_keepalive_pop();
    }
    return go_on ? true : false;
}

// Run `frame` (borrowed) once an animation frame, from the event loop, from
// now on: this returns at once. The program is kept alive till the loop
// ends, as animation frames are not requests, which keep it so.
LEAN_EXPORT lean_obj_res lean_wgpu_window_run(b_lean_obj_arg frame) {
    emscripten_runtime_keepalive_push();
    lean_wgpu_first_frame = -1;
    emscripten_request_animation_frame_loop(
        lean_wgpu_on_frame, lean_wgpu_closure_hold(frame));
    return lean_io_result_mk_ok(lean_box(0));
}

#endif
