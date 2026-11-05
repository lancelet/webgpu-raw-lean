import WebGPUWindow
import WebGPURawTest.Internal.Device

/-!
# The window library's test

A window, a surface on it, configured as its capabilities allow, and a
triangle drawn in it, frame by frame, by `run` and `Surface.presentFrame`:
the first frame read back, where the surface allows copying from its
textures, red inside the triangle and blue outside. It needs a display, and
an adapter: with neither it says so, and checks nothing, unless
`WEBGPU_RAW_REQUIRE_WINDOW` is set (as in CI, on Linux, under a virtual
display), when that is a failure.
-/

open WebGPU.Raw WebGPU.Window
open WebGPURawTest.Internal.Device (adapter? device? mapNow pumpUntil
  triangleWGSL texel)

/-- Fail with `message`. -/
def fail {α : Type} (message : String) : IO α :=
  throw (IO.userError s!"FAIL: {message}")

/-- Whether `usage` has `flag`. -/
def has (usage flag : TextureUsage) : Bool := usage.bits &&& flag.bits != 0

/--
A render pipeline that draws the triangle to a texture of `format`.
-/
def pipeline (device : Device) (format : TextureFormat) :
    IO RenderPipeline := do
  let module ← device.createShaderModule {
    chain := #[.shaderSourceWGSL { code := triangleWGSL }]
  }
  device.createRenderPipeline {
    vertex   := { module := module, entryPoint := some "vs" }
    fragment := some {
      module     := module
      entryPoint := some "fs"
      targets    := #[{ format := format }]
    }
  }

/-- Red and blue, as a texel of `format` holds them, if one of 8 bits. -/
def colours : TextureFormat → Option (List UInt8 × List UInt8)
  | .rgba8Unorm | .rgba8UnormSrgb => some ([255, 0, 0, 255], [0, 0, 255, 255])
  | .bgra8Unorm | .bgra8UnormSrgb => some ([0, 0, 255, 255], [255, 0, 0, 255])
  | _                             => none

/-- Draw a frame: the triangle on blue, in `texture`, read back if `read`. -/
def frame (wgpu : Instance) (device : Device) (draw : RenderPipeline)
    (texture : Texture) (width height : UInt32) (read : Bool) :
    IO (Option ByteArray) := do
  let view ← texture.createView none
  let encoder ← device.createCommandEncoder none
  let pass ← encoder.beginRenderPass { colorAttachments := #[{
    view       := some view
    loadOp     := .clear
    storeOp    := .store
    clearValue := { r := 0, g := 0, b := 1, a := 1 }
  }] }
  pass.setPipeline draw
  pass.draw 3 1 0 0
  pass.«end»
  -- A row of the copy, a multiple of 256 bytes.
  let row := (width.toNat * 4 + 255) / 256 * 256
  let size := (row * height.toNat).toUInt64
  let copy ← if read then
      device.createBuffer { size := size, usage := .mapRead ||| .copyDst }
    else pure none
  if let some buffer := copy then
    encoder.copyTextureToBuffer { texture := texture }
      { layout := { bytesPerRow := row.toUInt32, rowsPerImage := height },
        buffer := buffer }
      { width := width, height := height }
  (← device.getQueue).submit #[← encoder.finish none]
  match copy with
  | none => return none
  | some buffer =>
    unless ← mapNow wgpu buffer .read size do fail "the copy not mapped"
    some <$> buffer.readMapped 0 size

def main : IO UInt32 := do
  let required := (← IO.getEnv "WEBGPU_RAW_REQUIRE_WINDOW").isSome
  let skip (why : String) : IO UInt32 := do
    if required then fail s!"{why}, though a window is required"
    IO.println s!"note: {why}, so no window checked"
    return 0
  let window ← try Window.create "webgpu-window-test" 64 64
    catch e => return ← skip s!"no window ({e})"
  let wgpu ← createInstance none
  let some adapter ← adapter? wgpu | skip "no adapter"
  let device ← match ← device? wgpu adapter none with
    | .ok device => pure device
    | .error e   => fail e
  let surface ← window.createSurface wgpu
  let (status, capabilities) ← surface.getCapabilities adapter
  unless status matches .ok .success do
    fail s!"capabilities: {repr status |>.pretty}"
  let some format := capabilities.formats[0]? | fail "no format"
  let read := has capabilities.usages .copySrc && (colours format).isSome
  let (width, height) ← window.size
  surface.configure {
    device      := device
    format      := format
    usage       := if read then .renderAttachment ||| .copySrc
      else .renderAttachment
    width       := width
    height      := height
    presentMode := .fifo
    alphaMode   := capabilities.alphaModes.getD 0 .auto
  }
  let draw ← pipeline device format
  let frames ← IO.mkRef 0
  let checked ← IO.mkRef (none : Option String)
  run fun _ => do
    let _ ← window.poll
    let first := (← frames.get) == 0
    let missing ← surface.presentFrame fun texture => do
      if let some texels ← frame wgpu device draw texture width height
          (read && first) then
        if let some (red, blue) := colours format then
          let row := (width.toNat * 4 + 255) / 256 * 256
          let at' (x y : Nat) :=
            (texels.extract (y * row + x * 4) (y * row + x * 4 + 4)).toList
          let inside := at' 2 (height.toNat - 3)
          let outside := at' (width.toNat - 3) 2
          unless inside == red && outside == blue do
            fail s!"drawn: inside {inside}, outside {outside}"
          checked.set (some s!"{repr format |>.pretty}, {width}x{height}")
    if let some status := missing then
      fail s!"no texture: {repr status |>.pretty}"
    frames.modify (· + 1)
    return (← frames.get) < 3
  match ← checked.get with
  | some what =>
    IO.println s!"A window drew a triangle, read back ({what})."
  | none =>
    IO.println s!"A window drew a triangle ({repr format |>.pretty}; its \
      textures not copied from)."
  return 0
