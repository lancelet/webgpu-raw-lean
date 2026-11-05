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
since every result is a `lean_object *`. The runtime test boxes an object
result, `createInstance`'s, but no scalar one yet, as wgpu-native leaves those
it could call unimplemented.)

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
- **The raw `@[extern]` declarations under `Internal` are not API**: only
  their generated functions call them. They are public, as the functions,
  which inline into their callers, must name them; but code that called one
  itself could pass bytes it still holds, which C would write into. *Checked
  by:* review; the module's documentation says so.
- **A struct argument crosses as its bytes, its targets and its table's
  index**, with the Lean value itself and the tables: each typed as exactly
  the value's own (`BytesOf d`, a subtype, which is its one field at run
  time), so the raw `@[extern]` cannot be called with another's. The bytes
  are borrowed, and C fills in their pointers in place, before the call
  (`lean_wgpu_fill_arg`): they are fresh, as what makes them is
  `@[never_extract]`, and held by the call alone; an optional struct that is
  none is empty bytes, a null pointer. Before the call, the Lean function
  checks the struct's `size_t`s fit (`sizesFit`). *Checked by:* proof (the
  types; and that the table is the struct's, `CStruct.Fills`); test
  (`createInstance`, with and without a descriptor, natively and on the web;
  a constant descriptor too, a regression test); and CI runs the tests in the
  checked build, where every argument's bytes are checked unshared and one
  struct.
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
  `Option`. *Checked by:* proof of lowering (`nullable_of_callbackArgValue`),
  and of agreement: the trampoline boxes only an `Option` object, and the
  closure's type in Lean is the one its arguments are lowered to
  (`decls_of_functionShim`).

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
- **C keeps no memory of an input after the call.** Upstream implies this
  (only outputs belong to the application) but does not state it; Dawn and
  wgpu-native, as far as we have read them, copy what they need during the
  call. An object C keeps, it holds a reference to itself: nothing it keeps is
  memory Lean owns. The exceptions are not bound: a device descriptor's
  callbacks, which live as long as the device, and a surface source's OS
  handles, which live as long as the surface. A callback and a mutable
  `void *` lower to unsupported; a struct with an unsupported member is not
  bound, nor any that holds one, nor offered as an extension in a chain.
  *Checked by:* proof (a bound struct has no unsupported member, and every
  struct it refers to is bound), and test (a handle C keeps is unsupported;
  each of those structs of the spec, by name, is unsupported for its reason
  and not bound; and an extension that refers to one is not offered, nor
  keeps its base from being bound); and a function taking a struct is bound
  only if the struct is (test). That C keeps nothing else is
  not checked.
- **C writes into an input only through a mutable pointer, and no mutable
  pointer argument is bound**: not `wait_any`'s futures, which it writes back
  to, nor the outputs of the `get_` functions. *Checked by:* test (a mutable
  pointer argument, an array or a struct, is unsupported).
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
- **C fills in a struct's pointers only where its table says, from targets
  of the kinds it says.** One C function (`lean_wgpu_fill`, `c/reloc.c`)
  walks a struct's table of relocations over its encoded bytes, writing
  each pointer from the next target: a string's bytes, an object's handle,
  or a block of bytes it fills in first, a struct pointed to or an array's
  elements (of structs, each by its table; of enums, numbers with no pointers;
  of objects, handles, each from an object target), or a chain: blocks it fills
  in first, each by its own table, then links, each element's first pointer,
  its `next`, to the next element, the last's left null. Each element is one
  of its table's structs, whose first pointer is that `next`, so the link
  is written within it; and it is an extension's bytes, which its encoder
  starts with its `sType`, a constant of the extension, as the chain's type,
  a sum of the struct's extensions, offers only those. Or a callback's closure:
  held by the family the shim filling the struct set, at the ordinal the table
  gives, the pointer that family's ID (`c/family.c`). It trusts the table,
  the targets and the bytes to agree: offsets within the struct, targets of
  the kinds the table says, as many as it needs, blocks of whole elements,
  held by nothing else and aligned; and an array's count, a field of its
  struct, to be its block's length in elements, as the generator writes
  both from the same array. Whatever a pointer points into is a target,
  held by the call's targets, so borrowed for the call (see above: C keeps
  no input after it); but a callback's closure, which its family holds with
  a reference of its own until the family is gone (Families, below). A block
  C writes into must never be a constant Lean computes once (an empty one,
  which C does not write into, may: an optional struct that is none is
  the one `ByteArray.empty`), so what makes one is `@[never_extract]`:
  the encoders, and what makes the targets and a chain's links. *Checked
  by:* proof, of every generated table, that its relocations are exactly
  its struct's pointers, each within the struct, and that its bytes are
  their serialization; a check, as the tests build, that every encoder and
  maker of targets is `@[never_extract]`; test, natively and on the web,
  of every kind of pointer, none and some, blocks two deep, empty and of
  two elements, chains empty and of two elements, and of generated tables
  against C; and CI runs the tests in the checked build, where the walker
  checks every one of the above, stopping the program if not. And proof,
  of every generated struct, that the walker's Lean specification (`walk`),
  walking its table over its bytes, takes exactly its targets, each of the
  kind its relocation needs, and each chain's element one of its table's
  structs, its `next` first: the agreement the checked build checks. That
  C implements the specification is by review and test.

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

## Callbacks

A callback is a Lean closure, run by C through a trampoline and the callback
runtime (`c/callback.c`). Six functions take one: `requestAdapter`,
`mapAsync`, `onSubmittedWorkDone`, `popErrorScope`, and the two
`create…PipelineAsync` (`requestDevice` waits on its descriptor, whose
callbacks live as long as the device). Each is generated with its trampoline
(`Emit/C/Functions.lean`). The runtime is tested with a fake library that
runs callbacks as WebGPU does (`WebGPURawTest/Internal/Callback.lean`), and
`requestAdapter` through its shim and trampoline, natively and under Node.

- **A callback's closure is held by C until it runs, then released, exactly
  once.** C takes its own reference to the closure (`lean_wgpu_closure_hold`)
  as the callback's userdata; the trampoline applies it, which consumes that
  reference. *Checked by:* test (a callback run during its call, in a pump
  and in a finalizer, each once; and its closure released once it has run,
  not before).
- **Every callback is called exactly once**, with a cancelled status if it
  cannot complete, so every closure is released, whatever the status:
  upstream's contract (`webgpu.h`), assumed. *Checked by:* test, of
  `requestAdapter`, on wgpu-native and on emdawnwebgpu under Node (called
  back once by the next `processEvents`, in each mode, its closure
  released), and in a browser (called back from its event loop); not of the
  others yet.
- **A callback can run inside a finalizer**, as releasing an instance runs
  its waiting callbacks, cancelled: the Lean runtime allows Lean code in an
  external object's finalizer (`lean_dec_ref_cold` frees each object after
  its finalizer returns). *Checked by:* review, and test (a callback a
  finalizer runs). On emdawnwebgpu a spontaneous callback outlives its
  instance: releasing the instance completes only the other modes', as shut
  down (`UnregisterInstance` in its `webgpu.cpp`). *Checked by:* review; and
  the self-test relies on it in a browser, its instance released when `main`
  returns.
- **A closure may run on another thread than the one that made it**, as a
  Lean `Task` may run `processEvents`: so it is marked as shared between
  threads when C takes it (`lean_mark_mt`), and its reference counts are
  atomic. *Checked by:* review.
- **An error a callback raises is the error of the call into WebGPU that ran
  it**: the call that takes it, if it runs it before returning, as
  wgpu-native's `requestAdapter` does, or `processEvents` or `waitAny`. Each
  such call keeps, on its thread, the first error any callback in it raised,
  and raises it once WebGPU returns; the rest still run, their errors
  dropped. If a callback calls into WebGPU in turn, that call keeps its own,
  and its caller's are kept apart (whether an implementation allows such a
  call is its own: wgpu-native holds a device's error lock while it runs
  `popErrorScope`'s callback, so a callback that calls a function of that
  device that can report an error deadlocks). *Checked by:* test. So every
  shim brackets its call (`lean_wgpu_callbacks_enter` and `_leave`), as any
  call can run callbacks: those it takes; those of others it completes
  (`processEvents`, `waitAny`, and in wgpu-native `Buffer.unmap` and
  `destroy`, which call back a pending `mapAsync`, aborted, and
  `Queue.submit`); and a device's own (wgpu-native calls the
  uncaptured-error callback in the call that made the error, almost any
  call on a device). A check of a call's result returns through the bracket
  too; a result a call made, when a callback in it raised an error, is
  released with the result the error replaces. A bracket costs under 2 ns
  (`lake exe webgpu-raw-bench`). On the web, Dawn calls the uncaptured-error
  callback from the browser's event loop, outside every call (below). A
  release, which can run waiting callbacks, cancelled, is not bracketed: it
  runs in a finalizer, and a callback's error there is the call's the
  finalizer runs in, if any (as a trampoline's, or `_leave`'s, release of
  what it is done with), after any first error; outside every call, it ends
  the program. *Checked by:* test,
  of the shims printed; under Node, where `requestAdapter`'s callback runs
  in `processEvents` (a regression test: it ran outside every call, ending
  the program); and natively, with an adapter (in CI, on every OS),
  where an uncaptured-error closure's error, and the bindings' own
  handler's, are `createBuffer`'s, and a map callback's, the call's that
  ran it (wgpu-native completes a map with nothing pending on the buffer in
  `mapAsync` itself). That `unmap` and `destroy` run a pending map's
  callback, aborted, is not tested: a map is rarely still pending then.
- **An error a callback raises outside every call ends the program**, printed,
  as an error `main` raises does: a callback the browser's event loop runs,
  or one a finalizer runs outside every call, has no caller to raise it to.
  On the web it ends the program at once only when no other request is
  pending; otherwise once those callbacks have run, which they still do
  (emscripten defers an exit while the program is kept alive). *Checked by:*
  test, natively, in a process of its own; on the web, review (`exit` with
  `-sEXIT_RUNTIME=1` ends the program from the event loop, as the
  self-test's callback ends it in a browser).
- **On the web, a program goes on in callbacks the browser runs**, from its
  event loop once `main` has returned: the program is kept alive while a
  request is pending, and ends when a callback calls `IO.Process.exit`, or,
  once the last pending callback returns without exiting, with `main`'s code
  (`web/README.md`). A device's own callbacks are not requests, and keep
  nothing alive. *Checked by:* test: in a browser, the self-test goes on in
  `requestAdapter`'s callback, and through a device's, kept alive meanwhile,
  to the last, which ends it; `main` returns 1, so the page fails if a
  callback does not run, or the last does not end the program.
- **A string C passes a callback is copied at once** into a new Lean string,
  as it is valid only during the callback: valid UTF-8, each invalid byte
  U+FFFD; sized, or NUL-terminated (`WGPU_STRLEN`); the null view `""`.
  *Checked by:* test.

## Families

A device's own callbacks (device lost, uncaptured error) can be called as
long as anything made from it is alive, and after: in wgpu-native, every
object made from a device reports its errors through the device's, even
after the device's release; in Dawn, "lost" can come after the release. So
their closures are kept by the device's family, the objects made from it,
directly or not, until the last of them is gone (`c/family.c`). The walker
holds a callback's closure in the family the shim filling the struct sets,
which a shim taking a struct that keeps callbacks makes: a device
descriptor, which `Adapter.requestDevice` takes. The families are tested on
their own (`WebGPURawTest/Internal/Family.lean`), natively and on the web,
a closure filled in among them; and a device's, natively, where there is an
adapter, as in CI on every OS (on Linux, Mesa's software one, lavapipe)
(`WebGPURawTest/Internal/Device.lean`): its callbacks, mapping a buffer, a
queue's work done, and an error scope; and in a browser, as in CI's
headless Chrome (`WebGPURawWebTest/Device.lean`): its callbacks run by the
event loop, its loss by `destroy` once, and its family's release.

- **A family keeps its closures while anything keeps it, and releases them
  exactly once, when the last thing is gone**: its maker, and each Lean
  object of it, each with a reference it gives back once. *Checked by:* test
  (a closure holding a token, released only when the maker and every member
  have gone; many families and members, each closure released once).
- **A family is named by an ID, never a pointer**: an index and a
  generation, so a callback that names a family already gone finds nothing,
  rather than freed memory, even when its index is used again. So a mistake
  in when a family is released drops a callback, rather than reading freed
  memory. (Up to the generation's wrap: 32 bits on 64-bit targets, 16 on
  wasm32, where an index used 65536 times names a family again.) *Checked
  by:* test.
- **A handle is of one family**: joining a handle of another stops the
  program, as counting it into one but leaving the other would release that
  one's closures while in use. *Checked by:* test, in a process of its own.
- **No Lean code runs while the families' lock is held**: releasing a closure
  can run finalizers that use the families, so closures are released once it
  is let go. *Checked by:* test (releasing a closure that holds a member of
  another family, whose finalizer leaves it), and review.
- **A member leaves its family before its handle is released**, so that a new
  object C makes at the same address never meets the old entry; its
  reference to the family is given back after the release, so the family
  outlives it. *Checked by:* test, of the finalizer printed (every object
  type's does so).
- **Every object made from another joins its family**: a method's object
  result joins the family of the object it is called on, and an object a
  callback gives Lean joins the family its call carries in the callback's
  second userdata: its object's, a reference to it taken for the call, or a
  new one, if the structs it takes keep callbacks, whose closures their fill
  holds; the trampoline gives the reference back. On the web, Dawn calls a
  kept callback with a mode (device lost) exactly once, even after the
  device's release, so its family keeps a reference for it until then:
  promptly with `allowSpontaneous`, the default; with `allowProcessEvents`,
  at a `processEvents` after; with `waitAnyOnly`, only at the instance's
  shutdown, as the device's lost future is not bound, so the family
  outlives the device till then (a leak, never a use of freed memory).
  *Checked by:* test, of the shims and trampolines printed; that a device's
  objects join its family, at run time, comes with the device.
- **Every Lean object of a member's handle has joined its family**, as each
  leaves it when finalized: so a way of making an object that joins none
  must never give one of a handle another way joins. None does: the objects
  of no family (an instance, an adapter, a surface) are made only so. A
  surface's textures will be of no family, so their errors after the device
  is gone will be dropped. *Checked by:* review.
- **The families are safe from any thread**, behind one lock. *Checked by:*
  test (members joining and leaving from many tasks at once, natively).

## A device's callbacks

A device descriptor keeps two callbacks: device lost, and uncaptured error,
each an `Option` of an info, its closure and, for lost, its mode
(`allowSpontaneous` unless given). Their closures are kept by the device's
family (Families, above).

- **Neither closure is given the device**, though C passes it: in wgpu-native
  a device's objects report their errors through it after its release, when
  the device C passes is freed memory; in Dawn it is NULL after release. So
  the bindings never make a Lean value of it (`Value.lentObject`). *Checked
  by:* test (the trampolines take it and leave it unused; and each is
  declared in `webgpu.h` as lowered).
- **A closure that holds its device keeps it alive**, as its family holds
  the closure: the device is never released, as in C with a userdata
  holding a reference of its own. *Checked by:* not checked; documented.
- **A device's callback must not call into its device** where an error can
  be reported (wgpu-native calls them holding the device's error lock, so
  such a call deadlocks). *Checked by:* not checked; documented.
- **Lost can be called from a finalizer**: in wgpu-native, releasing the last
  object of a device can drop the device, which calls lost (reason dropped)
  then, at the depth of no call, where an error the closure raises ends the
  program. *Checked by:* review.
- **With no uncaptured-error callback, the bindings install their own**:
  wgpu-native's default ends the program at once; theirs raises an `IO`
  error of the call that made the error, if that call is bracketed (every
  shim is). A device requested with no descriptor is given one of defaults,
  the same to WebGPU, so that it gets the handler too. On the web, Dawn's
  default logs the error, and the bindings install nothing. *Checked by:* test
  (a descriptor of defaults encodes as C's with the handler; the uncaptured-
  error callback given its call's error, natively, with an adapter).

## Functions an implementation does not implement

wgpu-native v29.0.1.1 leaves 40 `webgpu.h` functions unimplemented: calling one
aborts the program (a Rust panic that cannot unwind into C). 27 of them are
bound: every bound `setLabel` method (21), `hasInstanceFeature`,
`Instance.hasWGSLLanguageFeature`, `Buffer.getMapState`,
`Texture.getTextureBindingViewDimension`, and
`Device.createComputePipelineAsync` and `createRenderPipelineAsync` (whose
shims hold no closure when they raise the error). Dawn, used on the web,
implements them. wgpu-native also aborts on values it does not support: a timed
`waitAny` feature or limit in an instance descriptor (`createInstance`), which
is not memory-unsafe, but ends the program; the bindings do not check for it
yet. And it aborts on a descriptor without the chain it needs, which the
bindings refuse: a struct that describes nothing but by its chain
(`Struct.chainRequired`, as a shader module descriptor), passed with an empty
one, raises an `IO` error instead (`createShaderModule`: "nothing chained to
descriptor"); and a function taking one whose extensions cannot be passed yet
is not bound (`createSurface`, whose surface sources hold OS handles).
*Checked by:* test (of the generated check, and that `createSurface` is not
bound).

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
is another, which the bindings never pass. So are `popErrorScope` with no
scope pushed (upstream calls back with `emptyStack`), and `mapAsync` with a
mode other than exactly `read` or exactly `write`. *Checked by:* not
checked; a later layer can validate such inputs.

wgpu-native also ignores a callback's mode: it calls `requestAdapter`'s and
`popErrorScope`'s back during the call, and `mapAsync`'s and
`onSubmittedWorkDone`'s only from `processEvents`, `Queue.submit`,
`Buffer.unmap` or `destroy`, or a queue's release, never spontaneously. And
every `Future` it returns has the ID 0, so a future means nothing there yet:
nor can one be waited on, as `waitAny` is unimplemented.

## Not yet bound

Rules that later parts of the bindings must follow, decided in advance:

- Strings from C are copied into new Lean strings at once, with Lean's
  validating constructor, as a callback's are: they are only valid during the
  call or callback, and may not be valid UTF-8.
- Mapped buffer memory is copied in and out, never exposed as a pointer; each
  copy asks C for the mapped range and checks its bounds.
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
