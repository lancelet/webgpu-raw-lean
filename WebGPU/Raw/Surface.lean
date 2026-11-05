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
surface: wgpu-native ends the program if not. The window library's
`Surface.presentFrame` does both.
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

end WebGPU.Raw
