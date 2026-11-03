import WebGPU.Raw
import WebGPURawTest.Commands

/-!
# Tests for the structs

The generated structures take the defaults C's initialisers give, so a value
needs only the fields that differ; the generator's tests check those defaults
against `webgpu.h`.
-/

namespace WebGPURawTest.Structs
open WebGPU.Raw

-- Only the fields that differ from the defaults.
#guard
  let d : BufferDescriptor := { size := 64, usage := BufferUsage.vertex }
  d.label == "" && d.size == 64 && d.usage == BufferUsage.vertex
    && !d.mappedAtCreation

-- A sentinel default, from the constants.
#guard
  let copy : TexelCopyBufferLayout := {}
  copy.bytesPerRow == copyStrideUndefined && copy.offset == 0

-- An enum's default is its `undefined` entry.
#guard
  let view : TextureViewDescriptor := {}
  view.format matches .undefined

-- A bind group layout entry's slots default to every byte zero: unused, not
-- undefined, as C's initialiser has them.
#guard
  let entry : BindGroupLayoutEntry := { binding := 0 }
  entry.buffer.type matches .bindingNotUsed
    && entry.sampler.type matches .bindingNotUsed
    && entry.texture.sampleType matches .bindingNotUsed
    && entry.storageTexture.access matches .bindingNotUsed

-- A nullable float is an `Option Float32`; the depth clear value's default, C's
-- NaN, is `none`.
example (view : TextureView) :
    ({ view } : RenderPassDepthStencilAttachment).depthClearValue = none := rfl

-- A value is `some`; so is the constant for C's NaN, which also means `none`.
#accepts example (view : TextureView) : RenderPassDepthStencilAttachment :=
  { view, depthClearValue := some 1.0 }
#accepts example (view : TextureView) : RenderPassDepthStencilAttachment :=
  { view, depthClearValue := some depthClearValueUndefined }

-- A render pass needs nothing given: no attachments, no depth.
#guard
  let pass : RenderPassDescriptor := {}
  pass.colorAttachments.isEmpty && pass.depthStencilAttachment.isNone

-- A field with no valid default must be given: here, a vertex attribute's
-- format, whose enum has no `undefined` entry.
#rejects example : VertexAttribute := { offset := 0, shaderLocation := 0 }
#accepts example : VertexAttribute :=
  { format := .float32x2, offset := 0, shaderLocation := 0 }

end WebGPURawTest.Structs
