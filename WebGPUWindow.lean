module

public import WebGPU.Raw

/-!
# A window to draw in

A window, its events, its size in pixels, filling the screen or not, a
WebGPU surface on it, a frame loop, and text drawn as pixels (to draw with
WebGPU): natively on SDL3 (`window/c/window_sdl.c`, fetched by
`vendor/sdl3/fetch.sh`), and on the web on the page's canvas
(`window/c/window_web.c`). It is not part of the raw bindings: they bind
WebGPU alone.

A surface is made on a window here, in C, from the handles the window
system gives of it, which never reach Lean (the raw bindings leave
`Instance.createSurface` unbound, as its sources are handles any number
could pass for). The surface holds its window until it is gone, so the
window outlives it.

Natively, SDL wants its windows made, polled and destroyed on the main
thread: so does this, which a window's finalizer, run where its last
reference goes, may not be.
-/

@[expose] public section

namespace WebGPU.Window

open WebGPU.Raw

/-- The handle that carries the type `Window`, not API. -/
opaque Internal.WindowHandle : NonemptyType

/-- A window, with a surface WebGPU can draw in. -/
def Window : Type := NonemptyType.type Internal.WindowHandle

instance : Nonempty Window := Subtype.property Internal.WindowHandle

/-- What happens to a window, or in it. -/
inductive Event where
  /-- Asked to close, or the program to quit. -/
  | quit
  /-- Resized: its size in pixels, now. -/
  | resized (width height : UInt32)
  /-- The mouse moved: where it is, in the window's units. -/
  | mouseMoved (x y : Float)
  /-- A mouse button pressed, or released: which, and where. -/
  | mouseButton (button : UInt8) (pressed : Bool) (x y : Float)
  /-- The wheel turned: by how much, across and down. -/
  | wheel (x y : Float)
  /-- A key pressed (perhaps repeating), or released: its key code. -/
  | key (code : UInt32) (pressed repeated : Bool)
  deriving Repr, Inhabited

/-- An event from its five values as C gives them, if of a kind known. -/
def Event.ofValues (v : Array Float) : Option Event :=
  let at' (k : Nat) := v.getD k 0
  match (at' 0).toUInt8 with
  | 1 => some .quit
  | 2 => some (.resized (at' 1).toUInt32 (at' 2).toUInt32)
  | 3 => some (.mouseMoved (at' 1) (at' 2))
  | 4 => some (.mouseButton (at' 1).toUInt8 (at' 2 != 0) (at' 3) (at' 4))
  | 5 => some (.wheel (at' 1) (at' 2))
  | 6 => some (.key (at' 1).toUInt32 (at' 2 != 0) (at' 3 != 0))
  | _ => none

/--
A new window titled `title`, `width` by `height` (in the window system's
units, which may be fewer than its pixels), which can be resized. On the web,
the page's canvas, `width` by `height` pixels.

With `fullscreen`, natively, it fills the screen, at the desktop's mode (no
mode change), and is `width` by `height` when it leaves it. On the web, the
canvas fills the page, its pixels following its size on the screen (with the
device's pixel ratio), each change a `resized` event; a browser lets a page
fill the screen itself only on a key press or a click (`setFullscreen`).
-/
@[extern "lean_wgpu_window_create"]
opaque Window.create (title : @& String) (width height : UInt32)
    (fullscreen : Bool := false) : IO Window

/--
Fill the screen with the window, or leave it. Natively, at once, at the
desktop's mode. On the web, the canvas: a browser allows it only while it
handles a key press or a click, so it waits till the next one (a key
released, at the latest, of the press that asked for it); the browser leaves
it on Escape. A headless window has no screen: nothing happens.
-/
@[extern "lean_wgpu_window_set_fullscreen"]
opaque Window.setFullscreen (self : @& Window) (fullscreen : Bool) : IO Unit

/-- Whether the window fills the screen. -/
@[extern "lean_wgpu_window_is_fullscreen"]
opaque Window.isFullscreen (self : @& Window) : IO Bool

/-- The shim behind `onWeb`. -/
@[extern "lean_wgpu_window_on_web"]
opaque Internal.onWeb : Unit → Bool

/--
Whether the program runs in a browser, where the browser keeps some keys
(Escape, to leave fullscreen), and a program never exits by itself.
-/
def onWeb : Bool := Internal.onWeb ()

/-- Text as pixels, `width` by `height`, by `textImage`. -/
structure TextImage where
  width  : UInt32
  height : UInt32
  /--
  Its pixels, row by row from the top, four bytes each, RGBA (not
  premultiplied): white, the alpha the text's.
  -/
  pixels : ByteArray

/-- The shim behind `textImage`: the width, and the pixels. -/
@[extern "lean_wgpu_text_image"]
opaque Internal.textImage (text : @& String) (size : UInt32) :
    IO (UInt32 × ByteArray)

/--
`text` as pixels, a line for each of its lines, about `size` pixels high,
as wide as the widest: to draw text with WebGPU, as a texture. Natively,
SDL3's own font (`SDL_RenderDebugText`: 8 by 8 pixels, ASCII), at the
whole multiple of its size that is at most `size` (at least 1), with a
software renderer; on the web, a canvas's monospace font. Empty if `text` is.
-/
def textImage (text : String) (size : UInt32) : IO TextImage := do
  let (width, pixels) ← Internal.textImage text size
  let height := if width == 0 then 0 else pixels.size.toUInt32 / (4 * width)
  return { width, height, pixels }

/--
A window with no window, `width` by `height` pixels, to draw in with no
display (as on CI's macOS runners): on macOS, a Metal layer of its own, a
surface on which presents to nothing; it has no events. Elsewhere, an `IO`
error.
-/
@[extern "lean_wgpu_window_create_headless"]
opaque Window.createHeadless (width height : UInt32) : IO Window

/-- The shim behind `Window.poll`: five values for each event. -/
@[extern "lean_wgpu_window_poll"]
opaque Internal.Window.poll (self : @& Window) : IO FloatArray

/--
The events since the last poll, in order: the program's, of every window it
has (as SDL gives them), not this one's alone.
-/
def Window.poll (self : Window) : IO (Array Event) := do
  let values := (← Internal.Window.poll self).data
  return (Array.range (values.size / 5)).filterMap fun k =>
    Event.ofValues (values.extract (5 * k) (5 * k + 5))

/-- The window's size in pixels: what a surface on it is configured to. -/
@[extern "lean_wgpu_window_size"]
opaque Window.size (self : @& Window) : IO (UInt32 × UInt32)

/--
A surface of `wgpu` on the window, which holds the window until it is gone.
-/
@[extern "lean_wgpu_window_create_surface"]
opaque Window.createSurface (self : @& Window) (wgpu : @& Instance) :
    IO Surface

/-- The shim behind `run`. -/
@[extern "lean_wgpu_window_run"]
opaque Internal.run (frame : @& (Float → IO Bool)) : IO Unit

/--
Run `frame` once a frame, given the seconds since the first, until it
returns `false`, or raises an error. Natively, in a loop, as fast as `frame`
returns (presenting a surface, configured `fifo`, waits for the display),
then returns, with `frame`'s error, if any. In a browser, from its event
loop, once a frame, after `main` has returned: this returns at once, the
program kept alive while the frames run. There, `frame` must never call
`IO.Process.exit`, which would wait for the frames to end, which it stops:
the program would hang. It ends the frames by returning `false`; the program
then ends with `main`'s code, if nothing else is pending, or exits from a
later request's callback (`web/README.md`). An error `frame` raises ends it.
-/
def run (frame : Float → IO Bool) : IO Unit :=
  Internal.run frame

end WebGPU.Window
