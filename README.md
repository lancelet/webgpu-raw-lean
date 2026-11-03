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
- **Encoding structs.** A struct is encoded field by field: each field an
  offset, a kind of scalar, and the number its bytes hold. For well-formed
  fields (in order, apart, within the struct), every field reads back as its
  number, and every other byte, the pointers and padding, as 0
  (`WebGPU/Raw/Internal/Encode.lean`). The encoders that run are straight-line
  pokes into a fresh block, generated for every bound struct and both widths
  (`WebGPU/Raw/Encoders.lean`), each proved the same as the general encoding,
  with its fields well-formed and its pointers 0, so these hold of every one;
  their bounds are proved, and that their block is unshared is checked in CI
  (see `docs/Safety.md`). Encoded structs of every kind of field are tested to
  be byte for byte ones C fills in, natively and on the web.
- **Filling in pointers.** Each struct's pointers are a table of relocations,
  each an offset and what C fills it in from, for one C walker
  (`WebGPU/Raw/Internal/Reloc.lean`, `c/reloc.c`). For every struct with a
  table, both widths, it is proved that its relocations are exactly its
  pointers, each within the struct, that the bytes C reads are their
  serialization, and that its index finds its table. And the walker is
  specified in Lean (`walk`), which C implements (by review and test): for
  every such struct, both widths, it is proved that walking its table over its
  bytes takes exactly its targets, each of the kind its relocation needs, a
  nested struct's by its own table: so C never meets a target of the wrong
  kind, nor runs out of them.

Status: WIP: approximately 65% complete.