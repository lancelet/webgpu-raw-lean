import WebGPUGen.Stubs
import WebGPUGenTest.Literal

/-! # Tests for reading lists of stubs -/

namespace WebGPUGenTest.Stubs
open WebGPUGen

-- One name per line; comments, blank lines and surrounding spaces ignored.
#guard
  let input := dedent "
    # The webgpu.h functions wgpu-native leaves unimplemented.
    wgpuBufferGetMapState

      wgpuHasInstanceFeature
    "
  parseStubs input == ["wgpuBufferGetMapState", "wgpuHasInstanceFeature"]

end WebGPUGenTest.Stubs
