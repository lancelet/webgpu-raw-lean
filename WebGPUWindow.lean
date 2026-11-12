module

public import WebGPU.Raw

/-!
# A window to draw in

A window, its events, its size in pixels, filling the screen or not, a
WebGPU surface on it, and a frame loop: natively on SDL3
(`window/c/window_sdl.c`, fetched by `vendor/sdl3/fetch.sh`), and on the web
on the page's canvas (`window/c/window_web.c`); and text drawn as pixels, in
a font of the program's, to draw with WebGPU, the same on both
(`window/c/text.c`, by stb_truetype). It is not part of the raw bindings:
they bind WebGPU alone.

A surface is made on a window here, in C, from the handles the window
system gives of it, which never reach Lean (the raw bindings leave
`Instance.createSurface` unbound, as its sources are handles any number
could pass for). The surface holds its window until it is gone, so the
window outlives it.

Natively, SDL wants its windows made, polled and destroyed on the main
thread: so does this, which a window's finalizer, run where its last
reference goes, may not be. On macOS nothing of a window works on any other
thread, and Lean's runtime (from 4.31) runs a program's `main` on a thread
of its own unless `LEAN_MAIN_USE_THREAD` is `0` when the program starts: so
the library sets it, as the program loads, before the runtime reads it,
unless it is set already. On any other thread, `Window.create` fails,
saying so.
-/

@[expose] public section

namespace WebGPU.Window

open WebGPU.Raw

/-- The handle that carries the type `Window`, not API. -/
opaque Internal.WindowHandle : NonemptyType

/-- A window, with a surface WebGPU can draw in. -/
def Window : Type := NonemptyType.type Internal.WindowHandle

instance : Nonempty Window := Subtype.property Internal.WindowHandle

/-- The modifier keys held as something happened: an event's `mods`. -/
structure Modifiers where
  shift : Bool := false
  ctrl  : Bool := false
  alt   : Bool := false
  /-- Command on macOS; the Windows key, elsewhere (the DOM's Meta). -/
  cmd   : Bool := false
  deriving Repr, Inhabited, BEq

/-- The modifiers from their bits as C gives them: Shift 1, Ctrl 2, Alt 4,
Command 8. -/
def Modifiers.ofBits (bits : UInt32) : Modifiers := {
  shift := bits &&& 1 != 0
  ctrl  := bits &&& 2 != 0
  alt   := bits &&& 4 != 0
  cmd   := bits &&& 8 != 0
}

/--
What happens to a window, or in it. Each of the mouse's and the keys' events
says which modifier keys were held (`mods`): a pinch on a trackpad arrives
as the wheel with Ctrl, on both platforms.
-/
inductive Event where
  /-- Asked to close, or the program to quit. -/
  | quit
  /-- Resized: its size in pixels, now. -/
  | resized (width height : UInt32)
  /-- The mouse moved: where it is, in the window's units. -/
  | mouseMoved (x y : Float) (mods : Modifiers)
  /-- A mouse button pressed, or released: which (1 the main), and where. -/
  | mouseButton (button : UInt8) (pressed : Bool) (x y : Float)
      (mods : Modifiers)
  /--
  The wheel turned, or two fingers moved on a trackpad: by how much, across
  and up (down is negative), in the window system's units (natively, SDL's,
  a tenth of a pixel; in a browser, the browser's, which differ between a
  wheel and a trackpad). On macOS the events go on after the fingers lift,
  with the scroll's momentum, natively as in a browser. A pinch on a
  trackpad is the wheel with Ctrl, up for spreading, on both: a browser
  gives it so, and natively SDL's pinch is given so, by the scale's
  logarithm, 100 pixels an e-fold as a browser.
  -/
  | wheel (x y : Float) (mods : Modifiers)
  /-- A key pressed (perhaps repeating), or released: its code (`Key`). -/
  | key (code : UInt32) (pressed repeated : Bool) (mods : Modifiers)
  deriving Repr, Inhabited, BEq

/--
wgpu-native's status when a window is hidden, behind others or minimised:
no texture, till it shows. `Surface.presentFrame` gives it as
`.error occluded`, a code the standard has no name for. A program then
draws nothing, and waits a little rather than spin.
-/
def occluded : UInt32 := 0x00030001

/-- An event from its six values as C gives them, if of a kind known. -/
def Event.ofValues (v : Array Float) : Option Event :=
  let at' (k : Nat) := v.getD k 0
  let mods := Modifiers.ofBits (at' 5).toUInt32
  match (at' 0).toUInt8 with
  | 1 => some .quit
  | 2 => some (.resized (at' 1).toUInt32 (at' 2).toUInt32)
  | 3 => some (.mouseMoved (at' 1) (at' 2) mods)
  | 4 => some (.mouseButton (at' 1).toUInt8 (at' 2 != 0) (at' 3) (at' 4) mods)
  | 5 => some (.wheel (at' 1) (at' 2) mods)
  | 6 => some (.key (at' 1).toUInt32 (at' 2 != 0) (at' 3 != 0) mods)
  | _ => none

namespace Key

/-!
The keys' codes, the same natively and in a browser: SDL's. A key that one
character names has that character's code point, a letter's in lower case
whether or not Shift is held (the event's `mods` says): `'f'.toNat.toUInt32`
is F. Other characters are as the keyboard's layout gives them. The keys
that no character names have the codes here (SDL's, its scancodes marked);
any other is 0.
-/

def backspace : UInt32 := 8
def tab       : UInt32 := 9
def enter     : UInt32 := 13
def escape    : UInt32 := 27
def space     : UInt32 := 32
def delete    : UInt32 := 127

/-- SDL's code of a key no character names: its scancode, marked. -/
def scancode (n : UInt32) : UInt32 := 0x40000000 ||| n

def capsLock   : UInt32 := scancode 0x39
/-- F1 to F12: `f 1` to `f 12`. -/
def f (n : Nat) : UInt32 := scancode (0x39 + n.toUInt32)
def insert     : UInt32 := scancode 0x49
def home       : UInt32 := scancode 0x4a
def pageUp     : UInt32 := scancode 0x4b
def «end»      : UInt32 := scancode 0x4d
def pageDown   : UInt32 := scancode 0x4e
def right      : UInt32 := scancode 0x4f
def left       : UInt32 := scancode 0x50
def down       : UInt32 := scancode 0x51
def up         : UInt32 := scancode 0x52
def leftCtrl   : UInt32 := scancode 0xe0
def leftShift  : UInt32 := scancode 0xe1
def leftAlt    : UInt32 := scancode 0xe2
def leftCmd    : UInt32 := scancode 0xe3
def rightCtrl  : UInt32 := scancode 0xe4
def rightShift : UInt32 := scancode 0xe5
def rightAlt   : UInt32 := scancode 0xe6
def rightCmd   : UInt32 := scancode 0xe7

/-- Whether `code` is a Shift key, left or right. -/
def isShift (code : UInt32) : Bool := code == leftShift || code == rightShift
/-- Whether `code` is a Ctrl key, left or right. -/
def isCtrl (code : UInt32) : Bool := code == leftCtrl || code == rightCtrl
/-- Whether `code` is an Alt key, left or right. -/
def isAlt (code : UInt32) : Bool := code == leftAlt || code == rightAlt
/-- Whether `code` is a Command (or Windows) key, left or right. -/
def isCmd (code : UInt32) : Bool := code == leftCmd || code == rightCmd

end Key

/--
A new window titled `title`, `width` by `height` (in the window system's
units, which may be fewer than its pixels: on a high-density screen it has
as many pixels as the screen does, which `Window.size` counts), which can be
resized. On the web,
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

/-- The handle that carries the type `Font`, not API. -/
opaque Internal.FontHandle : NonemptyType

/-- A font, from a TrueType file's bytes: what `textImage` draws with. -/
def Font : Type := NonemptyType.type Internal.FontHandle

instance : Nonempty Font := Subtype.property Internal.FontHandle

/--
A font from `bytes`, a TrueType file's (`.ttf`; an OpenType file with
TrueType outlines too), copied: an `IO` error if they are not one, by their
header. Past it they are not checked, so a font to trust, as one a program
embeds. A program makes its font once, and keeps it.
-/
@[extern "lean_wgpu_font_create"]
opaque Font.ofBytes (bytes : @& ByteArray) : IO Font

/-- Text as pixels, `width` by `height`, by `textImage`. -/
structure TextImage where
  width  : UInt32
  height : UInt32
  /--
  Its pixels, row by row from the top, four bytes each, RGBA (not
  premultiplied): white, the alpha the text's coverage, anti-aliased.
  -/
  pixels : ByteArray

/-- The shim behind `textImage`: the width, and the pixels. -/
@[extern "lean_wgpu_text_image"]
opaque Internal.textImage (font : @& Font) (text : @& String)
    (size : UInt32) : IO (UInt32 × ByteArray)

/--
`text` as pixels in `font`, a line for each of its lines, `size` pixels a
line (the font's ascent and descent fitted to it; at least 1), as wide as
the widest, anti-aliased, with the font's kerning: to draw text with WebGPU,
as a texture. The same natively and in a browser, pixel for pixel. Empty if
`text` is.
-/
def textImage (font : Font) (text : String) (size : UInt32) :
    IO TextImage := do
  let (width, pixels) ← Internal.textImage font text size
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

/-- The shim behind `Window.poll`: six values for each event. -/
@[extern "lean_wgpu_window_poll"]
opaque Internal.Window.poll (self : @& Window) : IO FloatArray

/--
The events since the last poll, in order: the program's, of every window it
has (as SDL gives them), not this one's alone.
-/
def Window.poll (self : Window) : IO (Array Event) := do
  let values := (← Internal.Window.poll self).data
  return (Array.range (values.size / 6)).filterMap fun k =>
    Event.ofValues (values.extract (6 * k) (6 * k + 6))

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
