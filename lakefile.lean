import Lake
open Lake DSL

/-! Raw Lean bindings to WebGPU (`webgpu.h`), generated from upstream's
`webgpu.yml` by `webgpu-gen`. -/
package WebGPURaw where
  leanOptions := #[⟨`autoImplicit, false⟩]

/--
The bindings. Modules under `WebGPU.Raw.Internal` are helpers for the generated
code: the bindings import them privately, so users never see them.
-/
@[default_target]
lean_lib WebGPURaw where
  roots := #[`WebGPU.Raw]

/-- Tests. `#guard` checks run while this library builds: run `lake test`. -/
@[test_driver]
lean_lib WebGPURawTest
