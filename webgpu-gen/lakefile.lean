import Lake
open Lake DSL

/-! Reads the WebGPU spec (vendor/webgpu-headers/webgpu.yml) and generates the
raw bindings. A development tool: the bindings library does not depend on it. -/
package WebGPUGen where
  leanOptions := #[⟨`autoImplicit, false⟩]

require L4YAML from git
  "https://github.com/nasa-jpl/L4YAML" @ "c558fda35b06e05a93078c6c12c18ea598b9ea47" -- v0.5.2

lean_lib WebGPUGen

/--
Tests. `#guard` checks run while this library builds; the driver then runs the
checks that need IO. Run with `lake test` from this directory.
-/
lean_lib WebGPUGenTest

/-- The generator: `lake exe webgpu-gen generate` writes the generated bindings. -/
lean_exe «webgpu-gen» where
  root := `Main

@[test_driver]
lean_exe «webgpu-gen-test» where
  root := `WebGPUGenTest.Main
