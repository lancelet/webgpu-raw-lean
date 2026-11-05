module

public import WebGPU.Raw.Functions

/-!
# A buffer's mapped memory

Reading and writing it, written by hand (`c/mapped.c`). A mapped range is a
pointer into memory the buffer owns only until it is unmapped, which C may
free then: so the bindings never give Lean one (`getMappedRange` and
`getConstMappedRange` are not bound), and copy out of it, or into it, in
the call instead. Each copy asks C for exactly the range it copies, and
copies only if C gives one.

What is refused, and how, differs (`docs/Safety.md`):

* A range misaligned (an offset not a multiple of 8, a size not of 4), or
  outside the buffer: an `IO` error, everywhere.
* A buffer not mapped there (not mapped, its mapping pending, or destroyed):
  an `IO` error in a browser; natively, wgpu-native ends the program, and
  cannot be asked first.
* In a browser, each byte of a mapping can be asked for once, till the
  buffer is unmapped: ask for disjoint ranges. A range asked for again is
  an `IO` error; natively, it is given again.
* Natively, a write into a buffer mapped for reading is accepted and lost;
  in a browser, an `IO` error.
-/

@[expose] public section

namespace WebGPU.Raw

/-- The shim behind `Buffer.readMapped`. -/
@[extern "lean_wgpu_buffer_read_mapped"]
opaque Internal.Buffer.readMapped
    (self   : @& Buffer)
    (offset : UInt64)
    (size   : UInt64) :
    IO ByteArray

/--
A copy of the `size` bytes at `offset` of the buffer's mapped memory, mapped
for reading or writing; refused as the module's documentation says.
-/
@[inline]
def Buffer.readMapped (self : Buffer) (offset size : UInt64) : IO ByteArray :=
  Internal.Buffer.readMapped self offset size

/-- The shim behind `Buffer.writeMapped`. -/
@[extern "lean_wgpu_buffer_write_mapped"]
opaque Internal.Buffer.writeMapped
    (self   : @& Buffer)
    (offset : UInt64)
    (data   : @& ByteArray) :
    IO Unit

/--
Copy `data` into the buffer's mapped memory at `offset`, mapped for writing
(as at creation); refused as the module's documentation says. The buffer
takes it when it is unmapped.
-/
@[inline]
def Buffer.writeMapped (self : Buffer) (offset : UInt64) (data : ByteArray) :
    IO Unit :=
  Internal.Buffer.writeMapped self offset data

end WebGPU.Raw
