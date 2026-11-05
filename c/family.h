// Families: the objects made, directly or not, from one device, and the Lean
// closures its callbacks run (device lost, uncaptured error), kept until the
// last of them is gone. See docs/Safety.md.
//
// A family is named by an ID, never a pointer: an index into the families
// and a generation, so a callback that names a family already gone finds
// nothing, rather than freed memory. A family's count is of what keeps it:
// whoever made it, each Lean object of it, and anything else that takes a
// reference. At 0, its closures are released, and its ID names nothing more.
//
// Every function is safe from any thread. None runs Lean code while it holds
// the families' lock: closures are released after it is let go, as releasing
// one can run finalizers that use the families too.

#ifndef LEAN_WGPU_FAMILY_H
#define LEAN_WGPU_FAMILY_H

#include <stddef.h>
#include <stdint.h>
#include <lean/lean.h>

// A family's ID; 0 is none.
typedef uintptr_t lean_wgpu_family;

// How many closures a family can hold, each at its ordinal.
#define LEAN_WGPU_FAMILY_CLOSURES 4

// What a surface's family holds, at its ordinal: the window the surface is on
// (the window library's, `window/c/`), till the surface is gone.
#define LEAN_WGPU_SURFACE_WINDOW 0

// A new family, its count 1, for the caller to release.
lean_wgpu_family lean_wgpu_family_new(void);

// Take a reference to the family `f`; nothing if it is none or gone.
void lean_wgpu_family_retain(lean_wgpu_family f);

// Give back a reference to `f`: at 0, its closures are released. Nothing if
// it is none or gone.
void lean_wgpu_family_release(lean_wgpu_family f);

// Hold `closure` (borrowed) in `f` at `ordinal`, until `f` is gone; one held
// there before is released. Nothing if `f` is none or gone, or `ordinal` is
// out of range.
void lean_wgpu_family_hold(
    lean_wgpu_family f, size_t ordinal, b_lean_obj_arg closure);

// A reference to the closure `f` holds at `ordinal`, for the caller to apply
// or release; NULL if there is none, or `f` is none or gone.
lean_object * lean_wgpu_family_closure(lean_wgpu_family f, size_t ordinal);

// A Lean object of the handle `handle` joins `f`, taking a reference to it.
// Several objects of one handle each join. Nothing if `f` is none or gone, or
// `handle` is NULL. A handle of another family stops the program: counted
// into `f`, it would leave the other, over-released.
void lean_wgpu_family_join(void const * handle, lean_wgpu_family f);

// The family of the handle `handle`, or none.
lean_wgpu_family lean_wgpu_family_of(void const * handle);

// A Lean object of the handle `handle` is gone: it leaves its family, whose
// ID is returned, still with its reference, for the caller to release once
// it has released the handle; none if it is of no family. Leaving first means
// a new object C makes at the same address never meets the old entry.
lean_wgpu_family lean_wgpu_family_leave(void const * handle);

// The family a struct being filled in joins its closures to (`c/reloc.c`):
// set by the shim that fills it, on this thread, around the fill. Setting it
// returns the one it replaces, for the shim to set again after, so that a fill
// inside another (in a callback) leaves the outer one's as it was.
lean_wgpu_family lean_wgpu_family_set_filling(lean_wgpu_family f);
lean_wgpu_family lean_wgpu_family_filling(void);

#endif
