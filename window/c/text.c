// Text as pixels, for the window library natively and on the web alike
// (`WebGPUWindow.lean`): a font from the bytes of a TrueType file
// (`Font.ofBytes`), and text drawn with it, anti-aliased (`textImage`), by
// stb_truetype (`stb_truetype.h`, vendored: public domain). The same on
// both, pixel for pixel.

#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <lean/lean.h>

#define STB_TRUETYPE_IMPLEMENTATION
#define STBTT_STATIC
#include "stb_truetype.h"

// A font: its file's bytes (stb_truetype reads them as it draws), and what
// stb_truetype found in them.
typedef struct {
    unsigned char * data;
    stbtt_fontinfo info;
    int ascent;
    int descent;
} lean_wgpu_font;

static lean_external_class * lean_wgpu_font_class = NULL;

static void lean_wgpu_font_finalize(void * data) {
    lean_wgpu_font * f = data;
    free(f->data);
    free(f);
}

static void lean_wgpu_font_visit(void * data, b_lean_obj_arg visitor) {
    (void)data;
    (void)visitor;
}

// An IO error with `message`.
static lean_obj_res lean_wgpu_text_error(char const * message) {
    return lean_io_result_mk_error(
        lean_mk_io_user_error(lean_mk_string(message)));
}

// A font from `bytes`, a TrueType file's (copied): an IO error if they are
// not one, by their header; past it, they are not checked.
LEAN_EXPORT lean_obj_res lean_wgpu_font_create(b_lean_obj_arg bytes) {
    size_t size = lean_sarray_size(bytes);
    unsigned char * data = malloc(size > 0 ? size : 1);
    lean_wgpu_font * f = malloc(sizeof *f);
    if (data == NULL || f == NULL) {
        free(data);
        free(f);
        return lean_wgpu_text_error("Font.ofBytes: out of memory");
    }
    memcpy(data, lean_sarray_cptr(bytes), size);
    f->data = data;
    // The header: a TrueType file's tag, and its tables' offsets, in range.
    if (size < 12 || !stbtt__isfont(data)
            || stbtt_GetFontOffsetForIndex(data, 0) != 0
            || !stbtt_InitFont(&f->info, data, 0)) {
        free(data);
        free(f);
        return lean_wgpu_text_error("Font.ofBytes: not a TrueType font");
    }
    int gap;
    stbtt_GetFontVMetrics(&f->info, &f->ascent, &f->descent, &gap);
    if (lean_wgpu_font_class == NULL) {
        lean_wgpu_font_class = lean_register_external_class(
            lean_wgpu_font_finalize, lean_wgpu_font_visit);
    }
    return lean_io_result_mk_ok(lean_alloc_external(lean_wgpu_font_class, f));
}

// The next code point of the UTF-8 at `*p`, before `end` (Lean's strings are
// valid UTF-8), `*p` moved past it.
static uint32_t lean_wgpu_next_codepoint(unsigned char const ** p,
        unsigned char const * end) {
    unsigned char const * s = *p;
    uint32_t c = s[0];
    size_t length = c < 0x80 ? 1 : (c & 0xE0) == 0xC0 ? 2
        : (c & 0xF0) == 0xE0 ? 3 : 4;
    if (length > (size_t)(end - s)) {
        length = (size_t)(end - s);
    }
    if (length == 2) {
        c = ((c & 0x1F) << 6) | (s[1] & 0x3F);
    } else if (length == 3) {
        c = ((c & 0x0F) << 12) | ((s[1] & 0x3F) << 6) | (s[2] & 0x3F);
    } else if (length == 4) {
        c = ((c & 0x07) << 18) | ((s[1] & 0x3F) << 12) | ((s[2] & 0x3F) << 6)
            | (s[3] & 0x3F);
    }
    *p = s + length;
    return c;
}

// A glyph's place, in a pass over `text`: `visit` is called for each with
// its code point, its left edge in pixels, and its line; the lines, and the
// width in pixels (the furthest right any glyph's pixels reach), are
// returned through `lines` and `width`.
typedef void (*lean_wgpu_glyph_visitor)(void * data, uint32_t codepoint,
    int x, int line);

static void lean_wgpu_layout(lean_wgpu_font const * f, float scale,
        unsigned char const * text, size_t length,
        lean_wgpu_glyph_visitor visit, void * data,
        int * lines, int * width) {
    unsigned char const * p = text;
    unsigned char const * end = text + length;
    int line = 0;
    float x = 0;
    int right = 0;
    uint32_t previous = 0;
    while (p < end) {
        uint32_t c = lean_wgpu_next_codepoint(&p, end);
        if (c == '\n') {
            line++;
            x = 0;
            previous = 0;
            continue;
        }
        if (c == '\r') {
            continue;
        }
        if (previous != 0) {
            x += scale * (float)stbtt_GetCodepointKernAdvance(&f->info,
                (int)previous, (int)c);
        }
        int left = (int)floorf(x + 0.5f);
        int x0, y0, x1, y1;
        stbtt_GetCodepointBitmapBox(&f->info, (int)c, scale, scale,
            &x0, &y0, &x1, &y1);
        if (left + x1 > right) {
            right = left + x1;
        }
        if (visit != NULL) {
            visit(data, c, left, line);
        }
        int advance, bearing;
        stbtt_GetCodepointHMetrics(&f->info, (int)c, &advance, &bearing);
        x += scale * (float)advance;
        if ((int)floorf(x + 0.5f) > right) {
            right = (int)floorf(x + 0.5f);
        }
        previous = c;
    }
    *lines = length == 0 ? 0 : line + 1;
    *width = right;
}

// What drawing a glyph needs: the image, and the font and size.
typedef struct {
    lean_wgpu_font const * font;
    float scale;
    int baseline;
    int line_height;
    unsigned char * pixels;
    int width;
    int height;
} lean_wgpu_drawing;

// Draw the glyph `c` with its left edge at `x` on `line`: its coverage into
// the image's alpha, the most of what is there and its own.
static void lean_wgpu_draw_glyph(void * data, uint32_t c, int x, int line) {
    lean_wgpu_drawing * d = data;
    int x0, y0, x1, y1;
    stbtt_GetCodepointBitmapBox(&d->font->info, (int)c, d->scale, d->scale,
        &x0, &y0, &x1, &y1);
    int w = x1 - x0;
    int h = y1 - y0;
    if (w <= 0 || h <= 0) {
        return;
    }
    unsigned char * glyph = malloc((size_t)w * (size_t)h);
    if (glyph == NULL) {
        return;
    }
    stbtt_MakeCodepointBitmap(&d->font->info, glyph, w, h, w, d->scale,
        d->scale, (int)c);
    int top = line * d->line_height + d->baseline + y0;
    for (int gy = 0; gy < h; gy++) {
        int py = top + gy;
        if (py < 0 || py >= d->height) {
            continue;
        }
        for (int gx = 0; gx < w; gx++) {
            int px = x + x0 + gx;
            if (px < 0 || px >= d->width) {
                continue;
            }
            unsigned char * alpha =
                d->pixels + ((size_t)py * (size_t)d->width + (size_t)px) * 4 + 3;
            unsigned char coverage = glyph[gy * w + gx];
            if (coverage > *alpha) {
                *alpha = coverage;
            }
        }
    }
    free(glyph);
}

// `text` as pixels in `font`, a line for each of its lines, `size` pixels a
// line (the font's ascent and descent fitted to it), as wide as the widest:
// RGBA, white, the alpha the glyphs' coverage. The width, and the pixels:
// none if the text is empty.
LEAN_EXPORT lean_obj_res lean_wgpu_text_image(b_lean_obj_arg font,
        b_lean_obj_arg text, uint32_t size) {
    lean_wgpu_font const * f = lean_get_external_data(font);
    unsigned char const * s = (unsigned char const *)lean_string_cstr(text);
    size_t length = lean_string_size(text) - 1;
    int line_height = size < 1 ? 1 : (int)size;
    float scale = stbtt_ScaleForPixelHeight(&f->info, (float)line_height);
    int lines, width;
    lean_wgpu_layout(f, scale, s, length, NULL, NULL, &lines, &width);
    if (lines == 0) {
        lean_object * pair = lean_alloc_ctor(0, 2, 0);
        lean_ctor_set(pair, 0, lean_box_uint32(0));
        lean_ctor_set(pair, 1, lean_alloc_sarray(1, 0, 0));
        return lean_io_result_mk_ok(pair);
    }
    if (width < 1) {
        width = 1;
    }
    int height = lines * line_height;
    size_t bytes = (size_t)width * (size_t)height * 4;
    lean_object * pixels = lean_alloc_sarray(1, bytes, bytes);
    unsigned char * out = lean_sarray_cptr(pixels);
    for (size_t i = 0; i < bytes; i += 4) {
        out[i] = out[i + 1] = out[i + 2] = 255;
        out[i + 3] = 0;
    }
    lean_wgpu_drawing d = {
        f, scale, (int)floorf((float)f->ascent * scale + 0.5f), line_height,
        out, width, height
    };
    lean_wgpu_layout(f, scale, s, length, lean_wgpu_draw_glyph, &d,
        &lines, &width);
    lean_object * pair = lean_alloc_ctor(0, 2, 0);
    lean_ctor_set(pair, 0, lean_box_uint32((uint32_t)width));
    lean_ctor_set(pair, 1, pixels);
    return lean_io_result_mk_ok(pair);
}
