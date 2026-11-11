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

// The events queued since the last poll, six values each, as natively.
static double * lean_wgpu_events = NULL;
static size_t lean_wgpu_event_count = 0;
static size_t lean_wgpu_event_capacity = 0;

// Queue an event; dropped if out of memory, or if 65536 wait (as SDL caps
// its queue), as when nothing polls.
static void lean_wgpu_queue(double a, double b, double c, double d,
        double e, double mods) {
    if (lean_wgpu_event_count >= 65536) {
        return;
    }
    if (lean_wgpu_event_count == lean_wgpu_event_capacity) {
        size_t capacity =
            lean_wgpu_event_capacity == 0 ? 16 : 2 * lean_wgpu_event_capacity;
        double * grown =
            realloc(lean_wgpu_events, capacity * 6 * sizeof *grown);
        if (grown == NULL) {
            return;
        }
        lean_wgpu_events = grown;
        lean_wgpu_event_capacity = capacity;
    }
    double * v = lean_wgpu_events + 6 * lean_wgpu_event_count++;
    v[0] = a;
    v[1] = b;
    v[2] = c;
    v[3] = d;
    v[4] = e;
    v[5] = mods;
}

// The modifier keys an event says were held, as bits, as natively: Shift 1,
// Ctrl 2, Alt 4, Meta 8.
static double lean_wgpu_mod_bits(bool shift, bool ctrl, bool alt, bool meta) {
    return (shift ? 1 : 0) | (ctrl ? 2 : 0) | (alt ? 4 : 0) | (meta ? 8 : 0);
}

static double lean_wgpu_mouse_mods(EmscriptenMouseEvent const * e) {
    return lean_wgpu_mod_bits(e->shiftKey, e->ctrlKey, e->altKey, e->metaKey);
}

// The mouse's events over the canvas, in its CSS pixels (as a stylesheet
// scales it, not the canvas's): handled, so the page does not scroll, nor
// show its menu, over it. The wheel's are as the browser gives them (in
// its `deltaMode`'s units). The keys' go on to the page.
static bool lean_wgpu_on_mouse(int type, EmscriptenMouseEvent const * e,
        void * data) {
    (void)data;
    if (type == EMSCRIPTEN_EVENT_MOUSEMOVE) {
        lean_wgpu_queue(3, e->targetX, e->targetY, 0, 0,
            lean_wgpu_mouse_mods(e));
    } else {
        // DOM buttons count from 0 (the main); SDL's, and so ours, from 1.
        lean_wgpu_queue(4, e->button + 1,
            type == EMSCRIPTEN_EVENT_MOUSEDOWN ? 1 : 0,
            e->targetX, e->targetY, lean_wgpu_mouse_mods(e));
    }
    return true;
}

static bool lean_wgpu_on_wheel(int type, EmscriptenWheelEvent const * e,
        void * data) {
    (void)type;
    (void)data;
    // The DOM's down is positive, SDL's negative: as SDL, natively. A pinch
    // on a trackpad is the wheel with Ctrl, which the modifiers say.
    lean_wgpu_queue(5, e->deltaX, -e->deltaY, 0, 0,
        lean_wgpu_mouse_mods(&e->mouse));
    return true;
}

// SDL's code of a key no character names: its scancode, marked.
#define LEAN_WGPU_SCANCODE(n) (0x40000000u | (n))

// A key's code, as SDL's natively (`WebGPUWindow.lean`'s `Key`): its
// character's code point, for a key one character names (`e->key`, in
// UTF-8), a letter's in lower case, whether or not Shift is held (SDL's
// are; the modifiers say); SDL's codes for the keys no character names
// (modifiers, by their side; arrows; and the like); else 0.
static uint32_t lean_wgpu_key_code(EmscriptenKeyboardEvent const * e) {
    static struct { char const * name; uint32_t code; } const named[] = {
        {"Enter", 13}, {"Escape", 27}, {"Backspace", 8}, {"Tab", 9},
        {"Delete", 127},
        {"CapsLock", LEAN_WGPU_SCANCODE(0x39)},
        {"Insert", LEAN_WGPU_SCANCODE(0x49)},
        {"Home", LEAN_WGPU_SCANCODE(0x4a)},
        {"PageUp", LEAN_WGPU_SCANCODE(0x4b)},
        {"End", LEAN_WGPU_SCANCODE(0x4d)},
        {"PageDown", LEAN_WGPU_SCANCODE(0x4e)},
        {"ArrowRight", LEAN_WGPU_SCANCODE(0x4f)},
        {"ArrowLeft", LEAN_WGPU_SCANCODE(0x50)},
        {"ArrowDown", LEAN_WGPU_SCANCODE(0x51)},
        {"ArrowUp", LEAN_WGPU_SCANCODE(0x52)},
    };
    // The modifiers: left, or right, as the key's location says.
    static struct { char const * name; uint32_t left; } const sided[] = {
        {"Control", 0xe0}, {"Shift", 0xe1}, {"Alt", 0xe2}, {"Meta", 0xe3},
        {"OS", 0xe3}
    };
    unsigned char const * k = (unsigned char const *)e->key;
    size_t length = strlen(e->key);
    if (length == 1 && k[0] < 0x80) {
        return k[0] >= 'A' && k[0] <= 'Z' ? k[0] + ('a' - 'A') : k[0];
    } else if (length == 2 && (k[0] & 0xE0) == 0xC0) {
        return ((uint32_t)(k[0] & 0x1F) << 6) | (k[1] & 0x3F);
    } else if (length == 3 && (k[0] & 0xF0) == 0xE0) {
        return ((uint32_t)(k[0] & 0x0F) << 12) | ((k[1] & 0x3F) << 6)
            | (k[2] & 0x3F);
    } else if (length == 4 && (k[0] & 0xF8) == 0xF0) {
        return ((uint32_t)(k[0] & 0x07) << 18) | ((k[1] & 0x3F) << 12)
            | ((k[2] & 0x3F) << 6) | (k[3] & 0x3F);
    }
    for (size_t i = 0; i < sizeof named / sizeof named[0]; i++) {
        if (strcmp(e->key, named[i].name) == 0) {
            return named[i].code;
        }
    }
    for (size_t i = 0; i < sizeof sided / sizeof sided[0]; i++) {
        if (strcmp(e->key, sided[i].name) == 0) {
            return LEAN_WGPU_SCANCODE(sided[i].left
                + (e->location == DOM_KEY_LOCATION_RIGHT ? 4 : 0));
        }
    }
    // F1 to F12: SDL's F1 is 0x3a.
    if (k[0] == 'F' && length >= 2 && length <= 3) {
        uint32_t n = 0;
        for (size_t i = 1; i < length; i++) {
            if (k[i] < '0' || k[i] > '9') {
                return 0;
            }
            n = n * 10 + (k[i] - '0');
        }
        return n >= 1 && n <= 12 ? LEAN_WGPU_SCANCODE(0x39 + n) : 0;
    }
    return 0;
}

static bool lean_wgpu_on_key(int type, EmscriptenKeyboardEvent const * e,
        void * data) {
    (void)data;
    lean_wgpu_queue(6, lean_wgpu_key_code(e),
        type == EMSCRIPTEN_EVENT_KEYDOWN ? 1 : 0, e->repeat ? 1 : 0, 0,
        lean_wgpu_mod_bits(e->shiftKey, e->ctrlKey, e->altKey, e->metaKey));
    return false;
}

// Whether the canvas fills the page (`Window.create`'s `fullscreen`), its
// pixels following its size on the screen.
static bool lean_wgpu_fill = false;

// Style the canvas to fill the page.
EM_JS(void, lean_wgpu_fill_page, (void), {
    const canvas = document.querySelector("#canvas");
    if (canvas) {
        Object.assign(canvas.style, {
            position: "fixed", left: "0", top: "0",
            width: "100%", height: "100%", display: "block"
        });
    }
});

// If the canvas fills the page, give it as many pixels as it covers on the
// screen (its size in CSS pixels, by the device's pixel ratio); if that is a
// change, and `queue`, queue a `resized` event.
static void lean_wgpu_fit(bool queue) {
    if (!lean_wgpu_fill) {
        return;
    }
    double css_width = 0;
    double css_height = 0;
    emscripten_get_element_css_size(lean_wgpu_canvas, &css_width,
        &css_height);
    double ratio = emscripten_get_device_pixel_ratio();
    int width = (int)(css_width * ratio + 0.5);
    int height = (int)(css_height * ratio + 0.5);
    width = width < 1 ? 1 : width;
    height = height < 1 ? 1 : height;
    int old_width = 0;
    int old_height = 0;
    emscripten_get_canvas_element_size(lean_wgpu_canvas, &old_width,
        &old_height);
    if (width != old_width || height != old_height) {
        emscripten_set_canvas_element_size(lean_wgpu_canvas, width, height);
        if (queue) {
            lean_wgpu_queue(2, width, height, 0, 0, 0);
        }
    }
}

// The canvas, `width` by `height` pixels, titled `title` (the page's title),
// its events queued; filling the page, if `fullscreen`, its pixels as many
// as it covers.
LEAN_EXPORT lean_obj_res lean_wgpu_window_create(
        b_lean_obj_arg title, uint32_t width, uint32_t height,
        uint8_t fullscreen) {
    if (emscripten_set_canvas_element_size(
            lean_wgpu_canvas, (int)width, (int)height)
            != EMSCRIPTEN_RESULT_SUCCESS) {
        return lean_wgpu_window_error("Window.create: no canvas");
    }
    if (fullscreen) {
        lean_wgpu_fill = true;
        lean_wgpu_fill_page();
        lean_wgpu_fit(false);
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

// The events since the last poll, six values each: a `resized` last, if
// the canvas fills the page, and its size on the screen has changed.
LEAN_EXPORT lean_obj_res lean_wgpu_window_poll(b_lean_obj_arg window) {
    (void)window;
    lean_wgpu_fit(true);
    size_t count = lean_wgpu_event_count * 6;
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

// Fill the screen with the canvas, or leave it. The browser allows it only
// in a handler of a key press or a click: Emscripten defers it till the next
// of its handlers of one runs (here, the keys' and the mouse buttons'). An
// IO error if the browser refuses it at once.
LEAN_EXPORT lean_obj_res lean_wgpu_window_set_fullscreen(
        b_lean_obj_arg window, uint8_t fullscreen) {
    (void)window;
    EmscriptenFullscreenChangeEvent status;
    if (emscripten_get_fullscreen_status(&status)
            != EMSCRIPTEN_RESULT_SUCCESS || !status.fullscreenEnabled) {
        return lean_wgpu_window_error(
            "Window.setFullscreen: not in this browser");
    }
    if ((fullscreen != 0) == status.isFullscreen) {
        return lean_io_result_mk_ok(lean_box(0));
    }
    EMSCRIPTEN_RESULT result = fullscreen
        ? emscripten_request_fullscreen(lean_wgpu_canvas, true)
        : emscripten_exit_fullscreen();
    if (result != EMSCRIPTEN_RESULT_SUCCESS
            && result != EMSCRIPTEN_RESULT_DEFERRED) {
        return lean_wgpu_window_error("Window.setFullscreen: refused");
    }
    return lean_io_result_mk_ok(lean_box(0));
}

// Whether something (the canvas) fills the screen.
LEAN_EXPORT lean_obj_res lean_wgpu_window_is_fullscreen(
        b_lean_obj_arg window) {
    (void)window;
    EmscriptenFullscreenChangeEvent status;
    bool fullscreen =
        emscripten_get_fullscreen_status(&status) == EMSCRIPTEN_RESULT_SUCCESS
        && status.isFullscreen;
    return lean_io_result_mk_ok(lean_box(fullscreen ? 1 : 0));
}

// In a browser.
LEAN_EXPORT uint8_t lean_wgpu_window_on_web(lean_obj_arg unit) {
    (void)unit;
    return 1;
}

// Text as pixels, in a canvas's monospace font, a line `size` pixels high:
// measured (its width, and its height into `height`), then drawn, white on
// nothing, into `pixels`, RGBA, width by height. One canvas, off the page,
// for all text.
EM_JS_DEPS(lean_wgpu_text, "$UTF8ToString");

EM_JS(int, lean_wgpu_text_measure,
        (char const * text, int size, int * height), {
    if (!Module.leanWgpuText) {
        Module.leanWgpuText = new OffscreenCanvas(1, 1).getContext("2d");
    }
    const context = Module.leanWgpuText;
    const lines = UTF8ToString(text).split("\n");
    context.font = Math.round(size * 0.8) + "px monospace";
    let width = 0;
    for (const line of lines) {
        width = Math.max(width, Math.ceil(context.measureText(line).width));
    }
    HEAP32[height >> 2] = width === 0 ? 0 : lines.length * size;
    return width;
});

EM_JS(void, lean_wgpu_text_draw, (char const * text, int size, int width,
        int height, unsigned char * pixels), {
    const context = Module.leanWgpuText;
    const lines = UTF8ToString(text).split("\n");
    // Setting the size clears the canvas, and its state.
    context.canvas.width = width;
    context.canvas.height = height;
    context.font = Math.round(size * 0.8) + "px monospace";
    context.textBaseline = "middle";
    context.fillStyle = "white";
    lines.forEach((line, i) => context.fillText(line, 0, (i + 0.5) * size));
    HEAPU8.set(context.getImageData(0, 0, width, height).data, pixels);
});

// `text` as pixels: the width, and the pixels, none if the text is empty.
LEAN_EXPORT lean_obj_res lean_wgpu_text_image(
        b_lean_obj_arg text, uint32_t size) {
    int height = 0;
    int width = lean_wgpu_text_measure(lean_string_cstr(text),
        size < 1 ? 1 : (int)size, &height);
    size_t bytes = (size_t)width * (size_t)height * 4;
    lean_object * pixels = lean_alloc_sarray(1, bytes, bytes);
    if (bytes > 0) {
        lean_wgpu_text_draw(lean_string_cstr(text), size < 1 ? 1 : (int)size,
            width, height, lean_sarray_cptr(pixels));
    }
    lean_object * pair = lean_alloc_ctor(0, 2, 0);
    lean_ctor_set(pair, 0, lean_box_uint32(bytes > 0 ? (uint32_t)width : 0));
    lean_ctor_set(pair, 1, pixels);
    return lean_io_result_mk_ok(pair);
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
