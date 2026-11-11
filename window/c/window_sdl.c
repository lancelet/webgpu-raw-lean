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
    // A headless window's (`Window.createHeadless`, on macOS): no window,
    // a Metal layer of its own (retained), and its size.
    void * layer;
    int width;
    int height;
} lean_wgpu_window;

#ifdef __APPLE__
#include <dlfcn.h>

// The Objective-C runtime's functions, found where SDL has loaded them (it
// links the runtime, and QuartzCore, whose CAMetalLayer this makes), so
// that nothing more need be linked.
typedef void * (*lean_wgpu_objc_get_class)(char const *);
typedef void * (*lean_wgpu_sel_register_name)(char const *);
typedef void * (*lean_wgpu_objc_send)(void *, void *);

static void * lean_wgpu_objc_send_named(void * receiver, char const * name) {
    lean_wgpu_sel_register_name selector =
        (lean_wgpu_sel_register_name)dlsym(RTLD_DEFAULT, "sel_registerName");
    lean_wgpu_objc_send send =
        (lean_wgpu_objc_send)dlsym(RTLD_DEFAULT, "objc_msgSend");
    if (selector == NULL || send == NULL || receiver == NULL) {
        return NULL;
    }
    return send(receiver, selector(name));
}

// A new CAMetalLayer, retained (`+new`); NULL if there is none.
static void * lean_wgpu_metal_layer_new(void) {
    lean_wgpu_objc_get_class get_class =
        (lean_wgpu_objc_get_class)dlsym(RTLD_DEFAULT, "objc_getClass");
    if (get_class == NULL) {
        return NULL;
    }
    return lean_wgpu_objc_send_named(get_class("CAMetalLayer"), "new");
}
#endif

static lean_external_class * lean_wgpu_window_class = NULL;

static void lean_wgpu_window_finalize(void * data) {
    lean_wgpu_window * w = data;
    if (w->view != NULL) {
        SDL_Metal_DestroyView(w->view);
    }
    if (w->window != NULL) {
        SDL_DestroyWindow(w->window);
    }
#ifdef __APPLE__
    if (w->layer != NULL) {
        lean_wgpu_objc_send_named(w->layer, "release");
    }
#endif
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
// units), which can be resized; filling the screen, at the desktop's mode,
// if `fullscreen`.
LEAN_EXPORT lean_obj_res lean_wgpu_window_create(
        b_lean_obj_arg title, uint32_t width, uint32_t height,
        uint8_t fullscreen) {
    if (!SDL_WasInit(SDL_INIT_VIDEO) && !SDL_Init(SDL_INIT_VIDEO)) {
        return lean_wgpu_window_error("Window.create: no video", 1);
    }
    if (lean_wgpu_window_class == NULL) {
        lean_wgpu_window_class = lean_register_external_class(
            lean_wgpu_window_finalize, lean_wgpu_window_visit);
    }
    SDL_WindowFlags flags = SDL_WINDOW_RESIZABLE;
    if (fullscreen) {
        flags |= SDL_WINDOW_FULLSCREEN;
    }
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
    w->layer = NULL;
    w->width = 0;
    w->height = 0;
    return lean_io_result_mk_ok(
        lean_alloc_external(lean_wgpu_window_class, w));
}

// A window with no window: on macOS, a Metal layer of its own, `width` by
// `height` pixels, to make a surface on with no display (as on CI's
// runners), and no events; elsewhere, an IO error.
LEAN_EXPORT lean_obj_res lean_wgpu_window_create_headless(
        uint32_t width, uint32_t height) {
#ifdef __APPLE__
    void * layer = lean_wgpu_metal_layer_new();
    if (layer == NULL) {
        return lean_wgpu_window_error(
            "Window.createHeadless: no Metal layer", 0);
    }
    if (lean_wgpu_window_class == NULL) {
        lean_wgpu_window_class = lean_register_external_class(
            lean_wgpu_window_finalize, lean_wgpu_window_visit);
    }
    lean_wgpu_window * w = malloc(sizeof *w);
    if (w == NULL) {
        lean_wgpu_objc_send_named(layer, "release");
        return lean_wgpu_window_error(
            "Window.createHeadless: out of memory", 0);
    }
    w->window = NULL;
    w->view = NULL;
    w->layer = layer;
    w->width = (int)width;
    w->height = (int)height;
    return lean_io_result_mk_ok(
        lean_alloc_external(lean_wgpu_window_class, w));
#else
    (void)width;
    (void)height;
    return lean_wgpu_window_error(
        "Window.createHeadless: only on macOS", 0);
#endif
}

// The modifier keys held, as the last key event said (exact, where
// SDL's mouse events say nothing of them): as bits, Shift 1, Ctrl 2, Alt 4,
// Meta (GUI) 8, for every event's last value.
static SDL_Keymod lean_wgpu_mods = 0;
static bool lean_wgpu_mods_known = false;

static double lean_wgpu_mod_bits(SDL_Keymod mods) {
    return ((mods & SDL_KMOD_SHIFT) ? 1 : 0) | ((mods & SDL_KMOD_CTRL) ? 2 : 0)
        | ((mods & SDL_KMOD_ALT) ? 4 : 0) | ((mods & SDL_KMOD_GUI) ? 8 : 0);
}

// The events since the last poll, six floats each: a kind, its values, and
// the modifiers held (`WebGPUWindow.lean` reads them).
LEAN_EXPORT lean_obj_res lean_wgpu_window_poll(b_lean_obj_arg window) {
    (void)window;
    size_t count = 0;
    size_t capacity = 16;
    double * values = malloc(capacity * 6 * sizeof *values);
    SDL_Event event;
    // With no window made yet (a headless one only), SDL is not started,
    // and there are no events.
    if (!lean_wgpu_mods_known && SDL_WasInit(SDL_INIT_VIDEO)) {
        lean_wgpu_mods = SDL_GetModState();
        lean_wgpu_mods_known = true;
    }
    while (values != NULL && SDL_WasInit(SDL_INIT_VIDEO)
            && SDL_PollEvent(&event)) {
        double v[6] = {0, 0, 0, 0, 0, 0};
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
            lean_wgpu_mods = event.key.mod;
            break;
        default:
            continue;
        }
        v[5] = lean_wgpu_mod_bits(lean_wgpu_mods);
        if (count == capacity) {
            capacity *= 2;
            double * grown = realloc(values, capacity * 6 * sizeof *values);
            if (grown == NULL) {
                free(values);
                values = NULL;
                break;
            }
            values = grown;
        }
        memcpy(values + count * 6, v, sizeof v);
        count++;
    }
    if (values == NULL) {
        return lean_wgpu_window_error("Window.poll: out of memory", 0);
    }
    lean_object * array = lean_alloc_sarray(sizeof(double), count * 6,
        count * 6);
    memcpy(lean_float_array_cptr(array), values, count * 6 * sizeof(double));
    free(values);
    return lean_io_result_mk_ok(array);
}

// The window's size in pixels: what a surface on it is configured to.
LEAN_EXPORT lean_obj_res lean_wgpu_window_size(b_lean_obj_arg window) {
    lean_wgpu_window * w = lean_wgpu_window_of(window);
    int width = w->width;
    int height = w->height;
    if (w->window != NULL) {
        SDL_GetWindowSizeInPixels(w->window, &width, &height);
    }
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
    if (w->window != NULL && w->view == NULL) {
        w->view = SDL_Metal_CreateView(w->window);
    }
    WGPUSurfaceSourceMetalLayer source = WGPU_SURFACE_SOURCE_METAL_LAYER_INIT;
    source.layer = w->layer != NULL ? w->layer
        : w->view == NULL ? NULL : SDL_Metal_GetLayer(w->view);
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
        if (wayland.display == NULL || wayland.surface == NULL) {
            return lean_wgpu_window_error(
                "Window.createSurface: no Wayland surface", 1);
        }
        descriptor.nextInChain = &wayland.chain;
    } else if (driver != NULL && strcmp(driver, "x11") == 0) {
        xlib.display = SDL_GetPointerProperty(
            props, SDL_PROP_WINDOW_X11_DISPLAY_POINTER, NULL);
        xlib.window = (uint64_t)SDL_GetNumberProperty(
            props, SDL_PROP_WINDOW_X11_WINDOW_NUMBER, 0);
        if (xlib.display == NULL || xlib.window == 0) {
            return lean_wgpu_window_error(
                "Window.createSurface: no X11 window", 1);
        }
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

// Fill the screen with the window, at the desktop's mode (none was set), or
// leave it; a headless window has no screen, and nothing happens.
LEAN_EXPORT lean_obj_res lean_wgpu_window_set_fullscreen(
        b_lean_obj_arg window, uint8_t fullscreen) {
    lean_wgpu_window * w = lean_wgpu_window_of(window);
    if (w->window != NULL
            && !SDL_SetWindowFullscreen(w->window, fullscreen != 0)) {
        return lean_wgpu_window_error("Window.setFullscreen", 1);
    }
    return lean_io_result_mk_ok(lean_box(0));
}

// Whether the window fills the screen.
LEAN_EXPORT lean_obj_res lean_wgpu_window_is_fullscreen(
        b_lean_obj_arg window) {
    lean_wgpu_window * w = lean_wgpu_window_of(window);
    bool fullscreen = w->window != NULL
        && (SDL_GetWindowFlags(w->window) & SDL_WINDOW_FULLSCREEN) != 0;
    return lean_io_result_mk_ok(lean_box(fullscreen ? 1 : 0));
}

// Not in a browser.
LEAN_EXPORT uint8_t lean_wgpu_window_on_web(lean_obj_arg unit) {
    (void)unit;
    return 0;
}

// `text` as pixels, RGBA, white on nothing: a line for each of its lines, in
// SDL's own font (8 by 8 pixels a character, as UTF-8 counts them), at
// `size / 8` times its size (at least once), drawn by a software renderer
// into a surface. The width, and the pixels: none if the text is empty.
LEAN_EXPORT lean_obj_res lean_wgpu_text_image(
        b_lean_obj_arg text, uint32_t size) {
    char const * s = lean_string_cstr(text);
    size_t bytes = lean_string_size(text) - 1;
    int scale = size / SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE;
    if (scale < 1) {
        scale = 1;
    }
    // The lines, as C strings, in a copy; the widest, in characters.
    char * lines = malloc(bytes + 1);
    if (lines == NULL) {
        return lean_wgpu_window_error("textImage: out of memory", 0);
    }
    memcpy(lines, s, bytes + 1);
    int rows = 1;
    int columns = 0;
    int column = 0;
    for (size_t i = 0; i < bytes; i++) {
        if (lines[i] == '\n') {
            lines[i] = '\0';
            rows++;
            column = 0;
        } else if (((unsigned char)lines[i] & 0xC0) != 0x80) {
            column++;
            if (column > columns) {
                columns = column;
            }
        }
    }
    int cell = SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE * scale;
    int width = columns * cell;
    int height = rows * cell;
    lean_object * pair = lean_alloc_ctor(0, 2, 0);
    if (width == 0) {
        free(lines);
        lean_ctor_set(pair, 0, lean_box_uint32(0));
        lean_ctor_set(pair, 1, lean_alloc_sarray(1, 0, 0));
        return lean_io_result_mk_ok(pair);
    }
    SDL_Surface * surface =
        SDL_CreateSurface(width, height, SDL_PIXELFORMAT_RGBA32);
    SDL_Renderer * renderer =
        surface == NULL ? NULL : SDL_CreateSoftwareRenderer(surface);
    if (renderer == NULL) {
        free(lines);
        lean_free_object(pair);
        if (surface != NULL) {
            SDL_DestroySurface(surface);
        }
        return lean_wgpu_window_error("textImage", 1);
    }
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);
    SDL_RenderClear(renderer);
    SDL_SetRenderScale(renderer, (float)scale, (float)scale);
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    char const * line = lines;
    for (int row = 0; row < rows; row++) {
        SDL_RenderDebugText(renderer, 0,
            (float)(row * SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE), line);
        line += strlen(line) + 1;
    }
    SDL_FlushRenderer(renderer);
    size_t stride = (size_t)width * 4;
    lean_object * pixels = lean_alloc_sarray(1, stride * height,
        stride * height);
    for (int y = 0; y < height; y++) {
        memcpy(lean_sarray_cptr(pixels) + y * stride,
            (unsigned char const *)surface->pixels + y * surface->pitch,
            stride);
    }
    SDL_DestroyRenderer(renderer);
    SDL_DestroySurface(surface);
    free(lines);
    lean_ctor_set(pair, 0, lean_box_uint32((uint32_t)width));
    lean_ctor_set(pair, 1, pixels);
    return lean_io_result_mk_ok(pair);
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
