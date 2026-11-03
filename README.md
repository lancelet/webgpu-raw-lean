# webgpu-raw-lean

[![CI][ci-badge]][ci]
[![Lean][lean-badge]][lean]
[![Platforms][platforms-badge]][ci]
[![webgpu-headers][headers-badge]][headers]

[ci]: https://github.com/lancelet/webgpu-raw-lean/actions/workflows/ci.yml
[ci-badge]: https://img.shields.io/github/actions/workflow/status/lancelet/webgpu-raw-lean/ci.yml?branch=main&style=flat-square&logo=githubactions&logoColor=white&label=CI
[lean]: https://lean-lang.org
[lean-badge]: https://img.shields.io/badge/Lean-v4.31.0-0073a3?style=flat-square
[platforms-badge]: https://img.shields.io/badge/platforms-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20Web-555?style=flat-square
[headers]: https://github.com/webgpu-native/webgpu-headers
[headers-badge]: https://img.shields.io/badge/webgpu--headers-673658b-6f42c1?style=flat-square

On the web: a [self-test that runs in your browser][pages]. Lean does not
support WebAssembly; the web build is a workaround whose lifespan is unknown
([web/README.md](web/README.md)).

[pages]: https://lancelet.github.io/webgpu-raw-lean/

## Proofs

The generator's are in [its README](webgpu-gen/README.md#proofs). The
bindings prove, in Lean:

- **Enum codes.** Every enum's C codes and its values correspond one to one
  (`CEnum`), checked by Lean's kernel for every enum.
- **Byte writers.** Writing a number into a `ByteArray` little-endian, as C lays
  it out, keeps the array's size; reading it back gives the number; and every
  byte outside it is left as it was (`WebGPU/Raw/Internal/Bytes.lean`). Each
  integer writer runs as inline C, a bounds check and one store; that the C
  agrees with the Lean definition is tested, natively and on the web, not
  proved. A float is written as its bits, so any NaN is written as Lean's one
  NaN.
- **Packing structs.** For a well-formed layout (scalars in order, aligned,
  none overlapping, all within the struct), packing a struct gives bytes of
  its size in which every scalar reads back as its value, and each pointer is
  a slot, its bytes 0 for C to fill in: aligned, and apart from every other
  scalar and slot (`WebGPU/Raw/Internal/Pack.lean`). A `size_t` that does not
  fit the target is refused, as for a function's argument. A packed buffer
  descriptor is tested to be byte for byte one C fills in.

Status: WIP: approximately 60% complete.