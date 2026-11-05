// Filling in an encoded struct's pointers: see WebGPU/Raw/Internal/Reloc.lean.

#ifndef LEAN_WGPU_RELOC_H
#define LEAN_WGPU_RELOC_H

#include <stddef.h>
#include <stdint.h>
#include <lean/lean.h>

// Fill in the pointers of the `size` bytes at `data`, the elements of the
// struct of table `table` in `tables` (an `Array ByteArray`), each from the
// next target in `targets` (an `Array Target`), from `*cursor` on, advancing
// it. A block is filled in by its own table first, its targets next in order.
// Everything is borrowed; the pointers are valid while the targets are.
void lean_wgpu_fill(
    uint8_t * data, size_t size, b_lean_obj_arg tables, size_t table,
    b_lean_obj_arg targets, size_t * cursor);

// Fill in the pointers of a struct, or the elements of an array, from every
// target in `targets`, as `lean_wgpu_fill` does from the first.
void lean_wgpu_fill_struct(
    uint8_t * data, size_t size, b_lean_obj_arg tables, size_t table,
    b_lean_obj_arg targets);

// Fill in the encoded struct `bytes`, an argument passed by pointer, by table
// `table` from every target in `targets`, in place: it is fresh, and held by
// the call alone. The pointer to pass: to the bytes, or NULL if they are empty,
// an optional struct that is none.
void const * lean_wgpu_fill_arg(
    b_lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
    b_lean_obj_arg targets);

// Fill in `block`, the zeroed block of an array argument of objects
// (`objects`, an `Array` of them), with their handles, a pointer wide each,
// in place: it is fresh, and held by the call alone. The pointer to pass: to
// the handles, or NULL if there are none.
void const * lean_wgpu_fill_objects(
    b_lean_obj_arg block, b_lean_obj_arg objects);

// The pointer to pass for an array argument of `uint32_t`s (`words`, an
// `Array UInt32`) whose block, as C lays them out, is `block`: to it, or NULL
// if there are none. C only reads it.
void const * lean_wgpu_u32s_arg(b_lean_obj_arg block, b_lean_obj_arg words);

#endif
