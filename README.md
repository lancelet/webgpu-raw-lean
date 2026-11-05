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
- **Filling in pointers.** Each struct's pointers are a table of
  relocations, each an offset and what C fills it in from, for one C walker
  (`WebGPU/Raw/Internal/Reloc.lean`, `c/reloc.c`). For every struct with
  a table, both widths, it is proved that its relocations are exactly
  its pointers, each within the struct, that the bytes C reads are their
  serialization, and that its index finds its table. And the walker is
  specified in Lean (`walk`), which C implements (by review and test):
  for every such struct, both widths, it is proved that walking its table
  over its bytes takes exactly its targets, each of the kind its relocation
  needs, a nested struct's by its own table, an array's element by element,
  a chain's extension by extension, each by its own table and exactly one
  of its structs, its `next` first, where C links it: so C never meets
  a target of the wrong kind, nor runs out of them, nor links outside an
  element. A callback's closure is a target of its own kind, as an object
  is. Every bound struct has a table: arrays of enums, of objects and of
  structs included. And each is a `CStruct`, its bytes, targets, table and
  those proofs together, for the target the program runs on: its bytes proved
  one struct, the size its table is for, and the tables C reads proved to be
  those the walk reads. A function that takes a struct passes it to its shim
  as its bytes, targets and table's index, each typed as exactly its own:
  so the walk the proofs are of is the one C makes.

## Performance

What passing a struct to C costs, measured by `lake exe webgpu-raw-bench`
(`WebGPURawBench.lean`), against C filling the same struct on the stack. In
nanoseconds a struct, the fastest of five runs of a million, each including
its loop's own cost (about 1 ns, within which C's figures mostly fall), on an
AMD Ryzen AI 9 HX 370 (2026-11-05):

| Struct              |   C | Lean: encoding | Lean: all a shim does |
|---------------------|----:|---------------:|----------------------:|
| Buffer descriptor   | 1.8 |           19.5 |                  23.8 |
| Instance descriptor | 1.0 |           73.9 |                  78.6 |
| Bind group layout   | 6.4 |           79.0 |                 107.6 |

A buffer descriptor is a label and scalars; an instance descriptor, an array
of enums and limits behind a pointer; a bind group layout, an array of four
structs, each with structs nested by value.

Encoding is the struct's bytes and its targets, its arrays and the structs it
points to among them, each a block of bytes of its own; all a shim does adds C
filling in its pointers, but not calling WebGPU. Most of the cost is in
allocating: a block for each array and each struct pointed to, a target for
each pointer, and the arrays that hold them. An array of structs is one block,
each element poked into it at its offset.
Making the Lean value is not counted, as C's struct on the stack is free.

Every shim also brackets its call into WebGPU, so that an error a callback
raises in it is the call's (`docs/Safety.md`): under 2 ns a call, which the
benchmark reports too.

Status: WIP: approximately 85% complete.