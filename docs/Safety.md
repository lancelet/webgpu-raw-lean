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
such `@[extern]` declarations. (`scripts/check-abi.sh` cannot check boxing,
since every result is a `lean_object *`; the runtime test calls a shim, but
none with a result yet, as wgpu-native leaves those it could call
unimplemented.)

- **Integers are unboxed** at the boundary, `UInt64` included, on 32-bit
  platforms too. *Checked by:* `scripts/check-abi.sh`, which compiles each
  shim with the declaration Lean makes of it, so their C types must agree.
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
  32 bits on the web. The largest `UInt64` stands for `SIZE_MAX`, both ways:
  passed to C as `SIZE_MAX` rather than refused, and `SIZE_MAX` from C becomes
  it; so `wholeMapSize` means the same on every platform. A `size_t` in a struct
  follows the same rule, but a struct's encoder cannot refuse one: it has its
  `sizesFit`, which checks every `size_t` in the struct, behind its pointers
  and in its arrays too, for the caller to check first; on wasm32 the encoder
  cuts one that does not fit to its low 32 bits.
  *Checked by:* compile (a probe of every conversion), and test.
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
- **A byte writer changes a byte array in place only if nothing else holds
  it**, and only within it: a shared array is copied first, and a value that
  does not fit is not written. *Checked by:* proof that the Lean definitions
  each C writer implements write only within the array, and whole or not at
  all; and test that each C writer agrees with its definition, in place and on
  shared arrays, natively and on the web.
- **A poke writes only into a block nothing else holds, and only within it.**
  The encoders write a struct's fields with pokes: unchecked stores, for
  speed. Each poke's bounds are proved, as its last argument. That its block
  is held by nothing else is so by how the encoders are made: each allocates a
  fresh block once (`freshZeros`, which Lean's compiler may not compute once
  and share, but may merge with a like call in the same function, so there is
  one), passes it straight from poke to poke, using it for nothing else, and
  is `@[noinline]`, so that no function holds two of its calls. A poke into a
  block anything else held would change that too. *Checked by:* proof (the
  bounds), and test: CI runs the tests in a build where every poke also checks
  its block is unshared and its store fits (`-K checkPokes=true`, and on the web
  `WEBGPU_RAW_CHECK_POKES=1`), stopping the program if not.
- **C fills in a struct's pointers only where its table says, from targets of
  the kinds it says.** One C function (`lean_wgpu_fill`, `c/reloc.c`) walks a
  struct's table of relocations over its encoded bytes, writing each pointer
  from the next target: a string's bytes, an object's handle, or a block of
  bytes it fills in first. It trusts the table, the targets and the bytes to
  agree: offsets within the struct, targets of the kinds the table says, as
  many as it needs, blocks of whole elements, held by nothing else and aligned.
  Whatever a pointer points into is a target, held by the call's targets, so
  borrowed for the call (see above: C keeps no input after it). A block must
  never be a constant Lean computes once, so what makes one is to be
  `@[never_extract]`, as the tests' are. *Checked by:* test, natively and on
  the web, of every kind of pointer, none and some, and blocks two deep, empty
  and of two elements; and CI runs the tests in the checked build, where the
  walker checks every one of the above, stopping the program if not. Generated
  tables, with proofs that they agree with their targets, and that every
  pointer of a struct has a relocation, are to follow.

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

The checked build's test that an array is held by nothing else
(`lean_is_exclusive`, for pokes and blocks) also fails for one Lean has marked
as shared between threads, though nothing else holds it: so a test that hands
encoded structs between tasks would stop the checked build without cause.

## Functions an implementation does not implement

wgpu-native v29.0.1.1 leaves 40 `webgpu.h` functions unimplemented: calling one
aborts the program (a Rust panic that cannot unwind into C). 25 of them are
bound: every bound `setLabel` method (21), `hasInstanceFeature`,
`Instance.hasWGSLLanguageFeature`, `Buffer.getMapState` and
`Texture.getTextureBindingViewDimension`. Dawn, used on the web, implements
them.

- **Their shims call them only when built against an implementation known to
  implement them**, which the build says by defining a macro: the web build
  defines `WEBGPU_RAW_DAWN`. Otherwise, as in the native build, which defines
  nothing, they raise an `IO` error ("not implemented by wgpu-native"). So a
  build that says nothing, or the wrong thing, gets the error, never the abort.
  *Checked by:* test, on both: natively, a function and a method raise the
  error; on the web, both are called.
- **The list is read from wgpu-native's source** at the pinned version, by
  `vendor/wgpu-native/stubs.sh`, into `vendor/wgpu-native/stubs`, which the
  generator reads: each exported function whose first statement is
  `unimplemented!`. *Checked by:* CI, which runs it again and fails if the list
  differs, and the test driver, which fails if a name in it is not a function
  `webgpu.h` declares (one renamed would lose its guard). A function that
  always aborts through a helper would not be found.

On the web, emdawnwebgpu needs the browser's WebGPU for some functions, such as
`Instance.hasWGSLLanguageFeature`: where there is none, as under Node, it
throws a JavaScript error, which ends the program. *Checked by:* not checked;
the web self-test calls such functions only where WebGPU exists.

On WebAssembly, a function called with a C type other than its own traps when
called. `web/build.sh` fails if the linker warns of one, except the two in
Lean v4.31.0's runtime (lean4#16089), which nothing calls. *Checked by:* the
web build, every time.

wgpu-native also aborts on some inputs that WebGPU treats as validation errors,
such as a `bytesPerRow` of 0 in a texture copy; an enum code it does not know
is another, which the bindings never pass. *Checked by:* not checked; a later
layer can validate such inputs.

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
- A struct's string is passed as a view of its bytes, so `""` is `{ptr, 0}`,
  the empty string, and never the null view; an `Option String` that is `none`
  is the null view, `{NULL, WGPU_STRLEN}`.
- An `Option Float32` (upstream's `nullable_float32`) that is `none` is passed
  as NaN, and `some x` as `x`; NaN from C becomes `none`. So `some` of a NaN
  means `none` too, which C accepts: no float is invalid to pass.
- A struct C fills in (one whose members C frees, as `SurfaceTexture` or
  `Limits`) can be built in Lean but is never read as an input: the bindings
  pass C zeroed memory for it, and read it back.

[abi]: https://lean-lang.org/doc/reference/latest/Run-Time-Code/Foreign-Function-Interface/
[repr]: https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/
