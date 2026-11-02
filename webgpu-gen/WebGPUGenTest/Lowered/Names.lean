import WebGPUGen.Lowered.Names
import WebGPUGenTest.Check

/-!
# Tests for C names

Each table pairs a spec name with the name `webgpu.h` gives it; every expected
name is copied from the header. The test driver also checks that every name
generated for the real spec is declared in `webgpu.h`.
-/

namespace WebGPUGenTest.Lowered.Names
open WebGPUGen.Common WebGPUGen.Lowered

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- Does `f` turn each input into the output paired with it? -/
def converts {α} (f : α → String) (cases : List (α × String)) : Bool :=
  cases.all fun (input, expected) => f input == expected

/-! ## Case conversion -/

-- Words start in upper case; the rest of each word is kept as written, so
-- acronyms and digits pass through.
#guard converts pascalCase [
  ("adapter_info", "AdapterInfo"),
  ("BC1_RGBA_unorm_srgb", "BC1RGBAUnormSrgb"),
  ("request_adapter_WebXR_options", "RequestAdapterWebXROptions"),
  ("2D", "2D"),
  ("r8_unorm", "R8Unorm"),
  ("", "")
]

-- The first word is kept as written.
#guard converts camelCase [
  ("next_in_chain", "nextInChain"),
  ("label", "label"),
  ("max_texture_dimension_1D", "maxTextureDimension1D"),
  ("", "")
]

-- Upstream's quirk, kept: after an underscore the next character is upper-cased
-- even if it is another underscore, so a doubled underscore leaves one behind.
-- Spec names never contain one, but the conversion matches upstream exactly.
#guard converts pascalCase [
  ("a__b", "A_b")
]

#guard converts constantCase [
  ("whole_size", "WHOLE_SIZE"),
  ("array_layer_count_undefined", "ARRAY_LAYER_COUNT_UNDEFINED")
]

/-! ## Names in `webgpu.h` -/

#guard converts typeName [
  ("adapter_info", "WGPUAdapterInfo"),
  ("texture_format", "WGPUTextureFormat")
]

#guard converts callbackTypeName [
  ("request_device", "WGPURequestDeviceCallback")
]

#guard converts callbackInfoName [
  ("request_device", "WGPURequestDeviceCallbackInfo")
]

#guard converts (fun (type, entry) => entryName type entry) [
  (("buffer_usage", "map_read"), "WGPUBufferUsage_MapRead"),
  (("texture_view_dimension", "2D"), "WGPUTextureViewDimension_2D"),
  (("texture_format", "BC1_RGBA_unorm_srgb"), "WGPUTextureFormat_BC1RGBAUnormSrgb")
]

#guard converts constantName [
  ("whole_size", "WGPU_WHOLE_SIZE")
]

#guard converts memberName [
  ("next_in_chain", "nextInChain")
]

#guard converts functionName [
  ("create_instance", "wgpuCreateInstance")
]

#guard converts (fun (object, method) => methodName object method) [
  (("adapter", "request_device"), "wgpuAdapterRequestDevice")
]

#guard converts functionProcName [
  ("create_instance", "WGPUProcCreateInstance")
]

#guard converts (fun (object, method) => methodProcName object method) [
  (("adapter", "request_device"), "WGPUProcAdapterRequestDevice")
]

end WebGPUGenTest.Lowered.Names
