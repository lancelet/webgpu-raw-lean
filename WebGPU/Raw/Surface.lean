module

public import WebGPU.Raw.Functions

/-!
# A surface's textures and capabilities

Written by hand (`c/surface.c`): structs C fills, given Lean as an object and
words; those whose members C allocates are freed in the call. A surface is
made by the window library (`WebGPUWindow`), from the window system's
handles, which never reach Lean.

A surface's texture is of no family: it is the surface's, and its errors
after the device is gone are not the device's callbacks' (`docs/Safety.md`).
-/

@[expose] public section

namespace WebGPU.Raw

/-- The shim behind `Surface.getCurrentTexture`. -/
@[extern "lean_wgpu_surface_get_current_texture"]
opaque Internal.Surface.getCurrentTexture (self : @& Surface) :
    IO (UInt32 × Option Texture)

/--
The texture to draw in this frame, and the status of getting it: present it
with `Surface.present`. None if the surface gave none (its status says why:
as `outdated`, when the window was resized, and the surface must be
configured again).

Hold the texture till it is presented: Lean releases it after its last use,
which may be well before, and releasing a surface's texture destroys it, in
wgpu-native, though its view, and the work drawing in it, live on (then the
submission ends the program, or the present fails). Release it before its
surface: wgpu-native ends the program if not. `Surface.presentFrame` does
both.
-/
def Surface.getCurrentTexture (self : Surface) :
    IO (Except UInt32 SurfaceGetCurrentTextureStatus × Option Texture) := do
  let (status, texture) ← Internal.Surface.getCurrentTexture self
  pure (CEnum.decode status, texture)

/-- The shim behind `Surface.getCapabilities`. -/
@[extern "lean_wgpu_surface_get_capabilities"]
opaque Internal.Surface.getCapabilities (self : @& Surface)
    (adapter : @& Adapter) :
    IO (UInt32 × UInt64 × Array UInt32 × Array UInt32 × Array UInt32)

/--
What the surface can be configured with, for `adapter`, and the status of
asking: its usages, formats (the first preferred), present modes and alpha
modes. A code no value has, an implementation's own, is left out.
-/
def Surface.getCapabilities (self : Surface) (adapter : Adapter) :
    IO (Except UInt32 Status × SurfaceCapabilities) := do
  let (status, usages, formats, presentModes, alphaModes) ←
    Internal.Surface.getCapabilities self adapter
  pure (CEnum.decode status, {
    usages       := ⟨usages⟩
    formats      := formats.filterMap CEnum.ofC?
    presentModes := presentModes.filterMap CEnum.ofC?
    alphaModes   := alphaModes.filterMap CEnum.ofC?
  })

/--
Whether a surface is presented by `Surface.present`: natively. In a browser,
the canvas presents what was drawn in a frame at its end, and refuses
`present` (Dawn would end the program; the bindings raise an `IO` error).
-/
@[extern "lean_wgpu_surface_presents"]
opaque Surface.presents : Unit → Bool

/--
Draw a frame: get the surface's current texture, `draw` in it, and present
it (natively; in a browser, the frame's end does), the texture held till
presented, and released before this returns (both as
`Surface.getCurrentTexture` says it must be). The status, if the surface
gave no texture, nothing drawn: configure it again if `outdated`, as when
its window was resized; `none` once drawn.
-/
def Surface.presentFrame (surface : Surface) (draw : Texture → IO Unit) :
    IO (Option (Except UInt32 SurfaceGetCurrentTextureStatus)) := do
  let (status, texture) ← surface.getCurrentTexture
  let some texture := texture | return some status
  -- Held till presented, then let go, before the surface can be: `draw`
  -- may well use the texture last, and `surface` is borrowed (it is only
  -- ever passed on borrowed), so the caller keeps it alive till this
  -- returns. A use of `surface` that took it would break that.
  let held ← IO.mkRef (some texture)
  draw texture
  if Surface.presents () then
    let presented ← surface.present
    unless presented matches .ok .success do
      throw (IO.userError s!"Surface.present: {repr presented |>.pretty}")
  held.set none
  return none

end WebGPU.Raw
