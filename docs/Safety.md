# Safety

The bindings call C, so a mistake in them can corrupt memory without any error.
This document lists every rule the generated C shims rely on, and how each is
checked. A rule with no check is a known gap.

Checks are of four kinds: a **proof** in Lean; a **test**, run by `lake test`;
the **compile** check, which compiles the generated C with warnings as errors;
and **review**, by reading the generator. Each change to the shims is reviewed
against this list.

## The boundary between Lean and C

These are Lean's rules (the [Lean ABI][abi] and the
[representation of inductive types][repr]), which every shim must follow.

| Lean type                          | C type in a shim                        |
|------------------------------------|-----------------------------------------|
| `UInt16`, `UInt32`, `UInt64`       | `uint16_t`, `uint32_t`, `uint64_t`      |
| `Int16`, `Int32`                   | `uint16_t`, `uint32_t` (the same bits)  |
| `Float32`, `Float`                 | `float`, `double`                       |
| `Bool`                             | `uint8_t`: 0 or 1                       |
| an object, `String`, `Option`      | `lean_object *`                         |
| `IO α` (a result)                  | `lean_object *`, with `α` boxed in it   |

A result is boxed into the `IO` result as Lean unboxes it: `Bool`, `UInt16`
and `Int16` with `lean_box`, `UInt32` and `Int32` with `lean_box_uint32`,
`UInt64` with `lean_box_uint64`, `Float32` with `lean_box_float32`, and `Float`
with `lean_box_float`. *Checked by:* review, against the C Lean 4.31 emits for
such `@[extern]` declarations.

- **Integers are unboxed** at the boundary, `UInt64` included, on 32-bit
  platforms too. *Checked by:* review.
- **An enum crosses as its constructor's index**, not its code in `webgpu.h`.
  So no shim takes or returns a Lean enum: the Lean side converts to and from
  the C code with `CEnum`, whose conversions are proved inverse. Likewise a
  bitflag type crosses as its `UInt64` bits. *Checked by:* proof (`CEnum`),
  review.
- **Object arguments are owned unless marked `@&`.** Every object a shim takes
  is marked `@&` in Lean, and the shim never releases it. *Checked by:* review.
- **`Option`**: `none` is the scalar `lean_box(0)`; `some x` is a constructor
  object whose only field, at index 0, is `x`. The reference leaves the layout
  of constructor objects to the compiler, but with one field there is only one
  place for it. *Checked by:* review; a runtime test is planned.

## Ownership

- **One Lean value holds one reference** to a WebGPU object, released by its
  finalizer when Lean frees the value. *Checked by:* compile, review.
- **An argument object is borrowed** for the call: its reference count is not
  changed. *Checked by:* review.
- **A result object is boxed only when the spec says it comes with its own
  reference** (`passed_with_ownership: true`). Otherwise who releases it is
  unknown, and the function is not bound. *Checked by:* test.
- **A result object that is not optional should not be NULL.** If it is, the
  shim returns an `IO` error rather than make a Lean value of nothing (and
  boxing NULL stops the program, as a last defence). *Checked by:* test. Whether
  an implementation ever does so is unverified: `webgpu.h` marks every result
  that can be NULL `WGPU_NULLABLE`, and each agrees with the spec's `optional`.
- **An object C passes to a callback can be NULL** even where the spec does not
  say `optional` (the adapter in a failed `requestAdapter`), so it is always an
  `Option`. *Checked by:* not yet: callbacks are not bound.

## Values

- **Nothing is passed that the bindings do not understand.** A value the
  generator cannot classify is `unsupported`, has no type on either side, and
  its function is not bound. *Checked by:* test.
- **A `size_t` crosses as a `UInt64`** and the shim checks it fits: `size_t` is
  32 bits on the web. *Checked by:* compile (a probe of every conversion), and
  test.
- **An enum C returns can hold a code the bindings do not know**, from an
  implementation's extensions or a newer `webgpu.h`; it is kept, as
  `Except UInt32 E`. *Checked by:* test.
- **A string passed to C** is a `WGPUStringView` of the Lean string's bytes,
  which outlive the call because the string is borrowed. Lean strings are valid
  UTF-8 and their length excludes the terminating NUL. A Lean string may hold
  U+0000, which the view, being explicitly sized, passes on. *Checked by:*
  review.
- **C does not keep a string, or any other input, after the call.** Upstream
  implies this (only outputs belong to the application) but does not state it.
  *Checked by:* not checked.

## Threads

wgpu-native supports threads: every object can be used from any thread. So a
finalizer may release an object on whichever thread drops its last reference.
Upstream also allows an implementation to require that each object (except the
instance) be used only on the thread that created it; the bindings would then
need to enforce that, and do not yet.

Whatever the implementation:

- **An encoder is not thread-safe:** one encoder must not be used from two
  threads at the same time. Different encoders can be used on different threads
  at once. (On the web an encoder may also have to stay on the thread that
  created it.)
- **Error scopes belong to an OS thread:** a scope pushed on one thread is
  popped on the same thread.

A Lean `Task` may run on any thread of the pool, so an encoder must not be
shared between tasks running at the same time, and a push and pop of an error
scope must not be split between tasks. *Checked by:* not enforced; documented.

## Not yet bound

Rules that later parts of the bindings must follow, decided in advance:

- Strings from C are copied into new Lean strings at once, with Lean's
  validating constructor: they are only valid during the call or callback, and
  may not be valid UTF-8.
- Mapped buffer memory is copied in and out, never exposed as a pointer; each
  copy asks C for the mapped range and checks its bounds.
- A callback is a Lean closure held by its C userdata, released exactly once
  when the callback runs. Upstream calls every callback exactly once, with a
  cancelled status if its instance is released first; that call can then run
  inside a finalizer, which the Lean runtime allows. An error thrown by a
  callback is re-raised from the `waitAny` or `processEvents` that ran it.
- Chained structs C returns may hold entries the bindings do not know; those
  are skipped.

[abi]: https://lean-lang.org/doc/reference/latest/Run-Time-Code/Foreign-Function-Interface/
[repr]: https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/
