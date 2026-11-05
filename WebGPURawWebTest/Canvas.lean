import WebGPUWindow
import WebGPURawTest.Internal.Callback
import WebGPURawTest.Internal.Device

/-!
# The canvas, in a browser

The window library on the web (`window/c/window_web.c`): the page's canvas
as a window, a surface on it, and the triangle drawn in it, frame by frame,
by the browser's animation frames (`WebGPU.Window.run`) and
`Surface.presentFrame`, with no error. Each step goes on in the callback of
the one before, as the device's do (`Device.lean`).
-/

namespace WebGPURawWebTest.Canvas
open WebGPU.Raw WebGPU.Window
open WebGPURawTest.Internal.Callback (problemUnless errorOf)
open WebGPURawTest.Internal.Device (triangleWGSL)

/-- A check's line, as the self-test prints it. -/
def line (what problem : String) : String :=
  if problem.isEmpty then s!"ok   {what}" else s!"FAIL {what}: {problem}"

/-- Red and blue, as a texel of `format` holds them, if one of 8 bits. -/
def colours : TextureFormat → Option (List UInt8 × List UInt8)
  | .rgba8Unorm | .rgba8UnormSrgb => some ([255, 0, 0, 255], [0, 0, 255, 255])
  | .bgra8Unorm | .bgra8UnormSrgb => some ([0, 0, 255, 255], [255, 0, 0, 255])
  | _                             => none

/-- The canvas's side, in pixels. -/
def side : UInt32 := 64

/--
Draw in the canvas, on `device`, with a surface of `wgpu`, three frames:
`report` is given the line, once they are drawn, with the errors `device`
gave its uncaptured-error callback (`errors`), if any. (Not read back: a
headless browser has no canvas to copy from; the triangle drawn offscreen
is read back among the device's checks.)
-/
def draw (wgpu : Instance) (adapter : Adapter) (device : Device)
    (errors : IO.Ref (Array String)) (report : List String → IO Unit) :
    IO Unit := do
  let window ← Window.create "webgpu-raw-lean" side side
  let surface ← window.createSurface wgpu
  let (status, capabilities) ← surface.getCapabilities adapter
  let some format := capabilities.formats[0]?
    | report [line "a canvas's surface" s!"no format, {repr status |>.pretty}"]
  surface.configure {
    device    := device
    format    := format
    width     := side
    height    := side
    alphaMode := capabilities.alphaModes.getD 0 .auto
  }
  let module ← device.createShaderModule {
    chain := #[.shaderSourceWGSL { code := triangleWGSL }]
  }
  let pipeline ← device.createRenderPipeline {
    vertex   := { module := module, entryPoint := some "vs" }
    fragment := some {
      module     := module
      entryPoint := some "fs"
      targets    := #[{ format := format }]
    }
  }
  -- `report` from a later turn of the event loop, once the frames have
  -- ended: it ends the program, which waits while they run.
  let reportLater (problem : String) : IO Unit := do
    let _ ← wgpu.requestAdapter none .allowSpontaneous fun _ _ _ =>
      report [line "the canvas drawn in, by animation frames" problem]
  let frames ← IO.mkRef 0
  run fun _ => do
    let _ ← window.poll
    let missing ← surface.presentFrame fun texture => do
      let view ← texture.createView none
      let encoder ← device.createCommandEncoder none
      let pass ← encoder.beginRenderPass { colorAttachments := #[{
        view       := some view
        loadOp     := .clear
        storeOp    := .store
        clearValue := { r := 0, g := 0, b := 1, a := 1 }
      }] }
      pass.setPipeline pipeline
      pass.draw 3 1 0 0
      pass.«end»
      (← device.getQueue).submit #[← encoder.finish none]
    if let some status := missing then
      reportLater s!"no texture, {repr status |>.pretty}"
      return false
    frames.modify (· + 1)
    if (← frames.get) < 3 then return true
    let got ← errors.get
    reportLater (problemUnless got.isEmpty s!"errors {got}")
    return false

/--
Request an adapter of `wgpu`, and a device of it (a browser's adapter makes
one device, so not the device checks'), its uncaptured errors kept, then
draw in the canvas with it: `report` is given the lines.
-/
def run (wgpu : Instance) (report : List String → IO Unit) : IO Unit := do
  let errors ← IO.mkRef #[]
  let _ ← wgpu.requestAdapter none .allowSpontaneous fun _ adapter _ =>
    match adapter with
    | none => report [line "a canvas's adapter" "none"]
    | some adapter => do
      let _ ← adapter.requestDevice (some {
          uncapturedErrorCallbackInfo := some {
            callback := fun _ message => errors.modify (·.push message)
          }
        }) .allowSpontaneous fun status made message =>
          match status, made with
          | .ok .success, some device => do
            let e ← errorOf (draw wgpu adapter device errors report)
            unless e.isEmpty do report [line "a canvas drawn in" e]
          | _, _ => report [line "a canvas's device" s!"none: {message}"]

end WebGPURawWebTest.Canvas
