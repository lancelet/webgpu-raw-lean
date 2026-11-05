import WebGPUWindow

/-!
# A triangle

The smallest program that draws with the bindings, natively and in a
browser alike: an adapter and a device, requested, a window and a surface
on it, and a red triangle drawn on blue in every frame, till the window is
closed. The surface is configured again when the window is resized, or the
surface says it must be.

Natively, `lake exe triangle` (after `vendor/sdl3/fetch.sh`); `lake exe
triangle 3` draws three frames, then ends. In a browser, `web/build.sh`
builds `triangle.html`.

Each step goes on in the callback of the one before: natively, wgpu-native
calls back during the request, so it runs as a program of steps in order
would; in a browser, the browser calls back from its event loop, after
`main` has returned (`web/README.md`). A frame ends the program by returning
`false`, never by `IO.Process.exit`, which in a browser would hang it: the
program then ends with `main`'s code.
-/

open WebGPU.Raw WebGPU.Window

namespace Examples.Triangle

/--
A red triangle over the lower-left half of what it is drawn to: its vertices
the corners of clip space at the bottom left, bottom right and top left.
-/
def wgsl : String :=
  "@vertex fn vs(@builtin(vertex_index) i : u32) -> @builtin(position) vec4f {
     var corners = array<vec2f, 3>(
       vec2f(-1.0, -1.0), vec2f(1.0, -1.0), vec2f(-1.0, 1.0));
     return vec4f(corners[i], 0.0, 1.0);
   }
   @fragment fn fs() -> @location(0) vec4f {
     return vec4f(1.0, 0.0, 0.0, 1.0);
   }"

/-- What a frame needs. -/
structure Scene where
  window   : Window
  surface  : Surface
  device   : Device
  format   : TextureFormat
  alpha    : CompositeAlphaMode
  pipeline : RenderPipeline

/-- Configure the surface to the window's size in pixels. -/
def Scene.configure (s : Scene) : IO Unit := do
  let (width, height) ← s.window.size
  s.surface.configure {
    device      := s.device
    format      := s.format
    width       := width
    height      := height
    presentMode := .fifo
    alphaMode   := s.alpha
  }

/-- Draw the triangle on blue in `texture`. -/
def Scene.draw (s : Scene) (texture : Texture) : IO Unit := do
  let view ← texture.createView none
  let encoder ← s.device.createCommandEncoder none
  let pass ← encoder.beginRenderPass { colorAttachments := #[{
    view       := some view
    loadOp     := .clear
    storeOp    := .store
    clearValue := { r := 0, g := 0, b := 1, a := 1 }
  }] }
  pass.setPipeline s.pipeline
  pass.draw 3 1 0 0
  pass.«end»
  (← s.device.getQueue).submit #[← encoder.finish none]

/-- A window and its scene, on `device`; the frames, `frames` of them if any. -/
def start (frames : Option Nat) (wgpu : Instance) (adapter : Adapter)
    (device : Device) : IO Unit := do
  let window ← Window.create "A triangle" 640 480
  let surface ← window.createSurface wgpu
  let (status, capabilities) ← surface.getCapabilities adapter
  let some format := capabilities.formats[0]?
    | throw (IO.userError s!"the surface has no format: {repr status}")
  let module ← device.createShaderModule {
    chain := #[.shaderSourceWGSL { code := wgsl }]
  }
  let pipeline ← device.createRenderPipeline {
    vertex   := { module := module, entryPoint := some "vs" }
    fragment := some {
      module     := module
      entryPoint := some "fs"
      targets    := #[{ format := format }]
    }
  }
  let scene : Scene := {
    window, surface, device, format, pipeline
    alpha := capabilities.alphaModes.getD 0 .auto
  }
  scene.configure
  let drawn ← IO.mkRef 0
  run fun _ => do
    for event in ← window.poll do
      match event with
      | .quit         => return false
      | .resized ..   => scene.configure
      | _             => pure ()
    -- No texture: outdated, by a resize not yet seen, or lost, configure
    -- again; timed out, try again; and draw in the next frame.
    match ← surface.presentFrame scene.draw with
    | none => drawn.modify (· + 1)
    | some (.ok .outdated) | some (.ok .lost) => scene.configure
    | some (.ok .timeout) => pure ()
    | some status =>
      throw (IO.userError s!"no texture to draw in: {repr status}")
    return frames.all ((← drawn.get) < ·)

end Examples.Triangle

open Examples.Triangle in
/-- Draw the triangle: in `n` frames, given `n`; else till the window closes. -/
def main (args : List String) : IO UInt32 := do
  let frames := args.head? >>= String.toNat?
  let wgpu ← createInstance none
  let _ ← wgpu.requestAdapter none .allowSpontaneous
    fun _ adapter message => do
      let some adapter := adapter
        | throw (IO.userError s!"no adapter: {message}")
      let _ ← adapter.requestDevice none .allowSpontaneous
        fun _ device message => do
          let some device := device
            | throw (IO.userError s!"no device: {message}")
          start frames wgpu adapter device
  return 0
