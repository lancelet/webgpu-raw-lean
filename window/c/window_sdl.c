// The window library natively (`WebGPUWindow.lean`), on SDL3: a window, its
// events, its size in pixels, a WebGPU surface on it, and a frame loop. The
// web's is `window_web.c`.
//
// A surface never outlives its window: it joins a family (`c/family.c`) that
// holds the Lean window, which the family releases only once every Lean
// object of the surface is gone, after the surface itself is released.

#ifndef __EMSCRIPTEN__

#include <stdlib.h>
#include <string.h>
#include <SDL3/SDL.h>
#include <SDL3/SDL_metal.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "callback.h"
#include "family.h"
#include "generated/objects.h"

// A window: SDL's, and on macOS the Metal view a surface is made on.
typedef struct {
    SDL_Window * window;
    SDL_MetalView view;
} lean_wgpu_window;

static lean_external_class * lean_wgpu_window_class = NULL;

static void lean_wgpu_window_finalize(void * data) {
    lean_wgpu_window * w = data;
    if (w->view != NULL) {
        SDL_Metal_DestroyView(w->view);
    }
    SDL_DestroyWindow(w->window);
    free(w);
}

static void lean_wgpu_window_visit(void * data, b_lean_obj_arg visitor) {
    (void)data;
    (void)visitor;
}

static lean_wgpu_window * lean_wgpu_window_of(b_lean_obj_arg window) {
    return lean_get_external_data(window);
}

// An IO error with `message`, and SDL's error after it, if `sdl`.
static lean_obj_res lean_wgpu_window_error(char const * message, int sdl) {
    lean_object * text = lean_mk_string(message);
    if (sdl) {
        // The second argument is borrowed.
        lean_object * colon = lean_mk_string(": ");
        text = lean_string_append(text, colon);
        lean_dec(colon);
        lean_object * why = lean_mk_string(SDL_GetError());
        text = lean_string_append(text, why);
        lean_dec(why);
    }
    return lean_io_result_mk_error(lean_mk_io_user_error(text));
}

// A new window titled `title`, `width` by `height` (in the window system's
// units), which can be resized.
LEAN_EXPORT lean_obj_res lean_wgpu_window_create(
        b_lean_obj_arg title, uint32_t width, uint32_t height) {
    if (!SDL_WasInit(SDL_INIT_VIDEO) && !SDL_Init(SDL_INIT_VIDEO)) {
        return lean_wgpu_window_error("Window.create: no video", 1);
    }
    if (lean_wgpu_window_class == NULL) {
        lean_wgpu_window_class = lean_register_external_class(
            lean_wgpu_window_finalize, lean_wgpu_window_visit);
    }
    SDL_WindowFlags flags = SDL_WINDOW_RESIZABLE;
#ifdef __APPLE__
    flags |= SDL_WINDOW_METAL;
#endif
    SDL_Window * window = SDL_CreateWindow(
        lean_string_cstr(title), (int)width, (int)height, flags);
    if (window == NULL) {
        return lean_wgpu_window_error("Window.create", 1);
    }
    lean_wgpu_window * w = malloc(sizeof *w);
    if (w == NULL) {
        SDL_DestroyWindow(window);
        return lean_wgpu_window_error("Window.create: out of memory", 0);
    }
    w->window = window;
    w->view = NULL;
    return lean_io_result_mk_ok(
        lean_alloc_external(lean_wgpu_window_class, w));
}

// The events since the last poll, five floats each: a kind, then its values
// (`WebGPUWindow.lean` reads them).
LEAN_EXPORT lean_obj_res lean_wgpu_window_poll(b_lean_obj_arg window) {
    (void)window;
    size_t count = 0;
    size_t capacity = 16;
    double * values = malloc(capacity * 5 * sizeof *values);
    SDL_Event event;
    while (values != NULL && SDL_PollEvent(&event)) {
        double v[5] = {0, 0, 0, 0, 0};
        switch (event.type) {
        case SDL_EVENT_QUIT:
        case SDL_EVENT_WINDOW_CLOSE_REQUESTED:
            v[0] = 1;
            break;
        case SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED:
            v[0] = 2;
            v[1] = event.window.data1;
            v[2] = event.window.data2;
            break;
        case SDL_EVENT_MOUSE_MOTION:
            v[0] = 3;
            v[1] = event.motion.x;
            v[2] = event.motion.y;
            break;
        case SDL_EVENT_MOUSE_BUTTON_DOWN:
        case SDL_EVENT_MOUSE_BUTTON_UP:
            v[0] = 4;
            v[1] = event.button.button;
            v[2] = event.button.down ? 1 : 0;
            v[3] = event.button.x;
            v[4] = event.button.y;
            break;
        case SDL_EVENT_MOUSE_WHEEL:
            v[0] = 5;
            v[1] = event.wheel.x;
            v[2] = event.wheel.y;
            break;
        case SDL_EVENT_KEY_DOWN:
        case SDL_EVENT_KEY_UP:
            v[0] = 6;
            v[1] = event.key.key;
            v[2] = event.key.down ? 1 : 0;
            v[3] = event.key.repeat ? 1 : 0;
            break;
        default:
            continue;
        }
        if (count == capacity) {
            capacity *= 2;
            double * grown = realloc(values, capacity * 5 * sizeof *values);
            if (grown == NULL) {
                free(values);
                values = NULL;
                break;
            }
            values = grown;
        }
        memcpy(values + count * 5, v, sizeof v);
        count++;
    }
    if (values == NULL) {
        return lean_wgpu_window_error("Window.poll: out of memory", 0);
    }
    lean_object * array = lean_alloc_sarray(sizeof(double), count * 5,
        count * 5);
    memcpy(lean_float_array_cptr(array), values, count * 5 * sizeof(double));
    free(values);
    return lean_io_result_mk_ok(array);
}

// The window's size in pixels: what a surface on it is configured to.
LEAN_EXPORT lean_obj_res lean_wgpu_window_size(b_lean_obj_arg window) {
    int width = 0;
    int height = 0;
    SDL_GetWindowSizeInPixels(
        lean_wgpu_window_of(window)->window, &width, &height);
    lean_object * pair = lean_alloc_ctor(0, 2, 0);
    lean_ctor_set(pair, 0, lean_box_uint32((uint32_t)width));
    lean_ctor_set(pair, 1, lean_box_uint32((uint32_t)height));
    return lean_io_result_mk_ok(pair);
}

// A surface of `instance` on `window`, from the handles SDL gives of it,
// which never reach Lean; the surface holds the window till it is gone.
LEAN_EXPORT lean_obj_res lean_wgpu_window_create_surface(
        b_lean_obj_arg window, b_lean_obj_arg instance) {
    lean_wgpu_window * w = lean_wgpu_window_of(window);
    WGPUSurfaceDescriptor descriptor = WGPU_SURFACE_DESCRIPTOR_INIT;
#if defined(__APPLE__)
    if (w->view == NULL) {
        w->view = SDL_Metal_CreateView(w->window);
    }
    WGPUSurfaceSourceMetalLayer source = WGPU_SURFACE_SOURCE_METAL_LAYER_INIT;
    source.layer = w->view == NULL ? NULL : SDL_Metal_GetLayer(w->view);
    if (source.layer == NULL) {
        return lean_wgpu_window_error("Window.createSurface: no layer", 1);
    }
    descriptor.nextInChain = &source.chain;
#elif defined(_WIN32)
    SDL_PropertiesID props = SDL_GetWindowProperties(w->window);
    WGPUSurfaceSourceWindowsHWND source =
        WGPU_SURFACE_SOURCE_WINDOWS_HWND_INIT;
    source.hwnd = SDL_GetPointerProperty(
        props, SDL_PROP_WINDOW_WIN32_HWND_POINTER, NULL);
    source.hinstance = SDL_GetPointerProperty(
        props, SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER, NULL);
    if (source.hwnd == NULL) {
        return lean_wgpu_window_error("Window.createSurface: no HWND", 1);
    }
    descriptor.nextInChain = &source.chain;
#else
    SDL_PropertiesID props = SDL_GetWindowProperties(w->window);
    char const * driver = SDL_GetCurrentVideoDriver();
    WGPUSurfaceSourceWaylandSurface wayland =
        WGPU_SURFACE_SOURCE_WAYLAND_SURFACE_INIT;
    WGPUSurfaceSourceXlibWindow xlib = WGPU_SURFACE_SOURCE_XLIB_WINDOW_INIT;
    if (driver != NULL && strcmp(driver, "wayland") == 0) {
        wayland.display = SDL_GetPointerProperty(
            props, SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER, NULL);
        wayland.surface = SDL_GetPointerProperty(
            props, SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER, NULL);
        descriptor.nextInChain = &wayland.chain;
    } else if (driver != NULL && strcmp(driver, "x11") == 0) {
        xlib.display = SDL_GetPointerProperty(
            props, SDL_PROP_WINDOW_X11_DISPLAY_POINTER, NULL);
        xlib.window = (uint64_t)SDL_GetNumberProperty(
            props, SDL_PROP_WINDOW_X11_WINDOW_NUMBER, 0);
        descriptor.nextInChain = &xlib.chain;
    } else {
        return lean_wgpu_window_error(
            "Window.createSurface: a video driver neither Wayland nor X11", 0);
    }
#endif
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUSurface surface = wgpuInstanceCreateSurface(
        lean_wgpu_instance_unbox(instance), &descriptor);
    if (surface == NULL) {
        return lean_wgpu_callbacks_leave(saved, lean_wgpu_window_error(
            "Window.createSurface: no surface", 0));
    }
    lean_wgpu_family family = lean_wgpu_family_new();
    lean_wgpu_family_hold(family, LEAN_WGPU_SURFACE_WINDOW, window);
    lean_object * object = lean_wgpu_surface_box(surface);
    lean_wgpu_family_join(surface, family);
    lean_wgpu_family_release(family);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(object));
}

// Run `frame` (borrowed), an `Float → IO Bool`, with the seconds since the
// loop began, until it returns false or raises an error, which is the loop's.
LEAN_EXPORT lean_obj_res lean_wgpu_window_run(b_lean_obj_arg frame) {
    Uint64 start = SDL_GetTicksNS();
    for (;;) {
        double seconds = (double)(SDL_GetTicksNS() - start) / 1e9;
        lean_inc(frame);
        lean_object * result = lean_apply_2(
            frame, lean_box_float(seconds), lean_io_mk_world());
        if (lean_io_result_is_error(result)) {
            return result;
        }
        uint8_t go_on = lean_unbox(lean_io_result_get_value(result));
        lean_dec(result);
        if (!go_on) {
            return lean_io_result_mk_ok(lean_box(0));
        }
    }
}

#endif
