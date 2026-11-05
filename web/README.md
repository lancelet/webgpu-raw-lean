# The web build

The bindings, compiled to WebAssembly, call WebGPU in the browser through
[emdawnwebgpu], Dawn's implementation of `webgpu.h` for Emscripten. So far
this builds a self-test, which CI runs under Node and publishes to
[GitHub Pages][pages].

## Lean does not support WebAssembly

Lean has published no WebAssembly build since v4.15, and its WebAssembly CI is
disabled. This build is a workaround: it assembles what Lean would otherwise
ship. It works for Lean v4.31.0, but each Lean upgrade can break it, and how
long it will keep working is unknown. It takes the route (Lean's C, compiled
with Emscripten) that other projects running compiled Lean in the browser have
taken; we know of no maintained alternative.

## Building

You need the [Emscripten SDK][emsdk] at the version in `emscripten-version`
(`emcc`, `em++`, `emar` and `emcmake` on `PATH`), `cmake` and `make`, and
Lean through elan as usual. Then, from the repository root:

    web/build.sh
    node .lake/web/site/webgpu-raw-web-test.js

The build writes the page and its program to `.lake/web/site/`. To open the
page, serve that directory (a browser will not load WebAssembly from a `file:`
URL) with `node web/serve.mjs`, then open http://localhost:8000/.
`web/check-page.sh` loads it in headless Chrome or Chromium (with Node 22 or
later, for its WebSocket), and passes if it reports that all checks passed;
CI runs both checks.

## What it does

`build.sh` builds:

- **Lean's runtime**, compiled from Lean's source at the version in
  `lean-toolchain` (`vendor/lean4/fetch.sh`), with `include/lean/config.h` in
  place of the one Lean's own build writes;
- **`Init`**, Lean's core library: the toolchain ships its sources but not its
  C, so each module is compiled to C again with `lean -c`, with the option
  Lean's own build uses;
- **libuv**, which the runtime uses, at the version and with the patch Lean's
  own WebAssembly build uses (`vendor/libuv/fetch.sh`).

These are cached under `.lake/web/<version>-<stamp>/`, the stamp being of
everything they are built with, so a change to any of it builds them again.
Then Lake compiles the bindings and the self-test to C, and `build.sh`
compiles that C and the generated shims, and links them.

## Writing a program for the web

A browser runs WebGPU's callbacks from its event loop, once the program has
returned to it: a Lean program cannot wait for one, as `main` is synchronous
and the build has no Asyncify or JSPI (Asyncify would instrument all of
Lean's runtime; JSPI is Chrome's alone so far). So a program goes on in its
callbacks, each step in the last one's callback:

```lean
open WebGPU.Raw in
def main : IO UInt32 := do
  let wgpu ← createInstance none
  let _ ← wgpu.requestAdapter none .allowSpontaneous fun _ adapter _ => do
    -- ... request a device from `adapter`, and so on
    IO.Process.exit 0
  return 1
```

`main` returns while the request is pending, and the program is kept alive:
the build links with `-sEXIT_RUNTIME=1`, and emdawnwebgpu keeps it alive
while a request is pending. The browser runs the callback; the program ends
when a callback calls `IO.Process.exit`, with its code, or, once the last
pending callback returns without exiting, with `main`'s. So `main` returns 1:
a program whose callbacks forget to end it fails. The same code runs
natively, where wgpu-native calls back during the request.

- **Register every step `allowSpontaneous`.** The instance may be released
  before its callbacks run, as `wgpu` here is when `main` returns:
  emdawnwebgpu then still runs a spontaneous callback, but completes the
  others at once, as shut down, and there is no `processEvents` to run them.
- **An exit is deferred while another request is pending:** `IO.Process.exit`,
  or an error a callback the browser runs raises (`docs/Safety.md`), ends the
  program at once only when no other request is pending; otherwise it ends
  once those callbacks have run, which they still do.
- **A device's own callbacks keep nothing alive.** Its device-lost and
  uncaptured-error callbacks are not requests: a program waiting only for
  them ends first, unless it keeps itself alive meanwhile (the self-test
  does, by `emscripten_runtime_keepalive_push`).
- **The window library's window is the page's canvas** (`#canvas`), and
  its frame loop (`WebGPU.Window.run`) the browser's animation frames, which
  keep the program alive while they run. A program ends from a frame only
  once the frames have ended (by a request's callback, after the frame that
  ends them returns): an exit waits while they run. The browser presents a
  frame at its end; `Surface.present` is refused (`Surface.presentFrame`
  knows).
- **In headless Chrome, a device's uncaptured error reached its callback
  only while a request was pending** (observed, not documented): the
  self-test keeps one pending, the queue's `onSubmittedWorkDone`.

The self-test (`WebGPURawWebTest/SelfTest.lean`) is written this way: in a
browser it goes on in `requestAdapter`'s callback, then, with an adapter,
through a device's (`WebGPURawWebTest/Device.lean`), and finishes in the
last.

## What to know

- **`-DLEAN_EMSCRIPTEN` on all of Lean's C is required.** Without it, Lean
  4.29 and later silently miscompile static constants on 32-bit targets
  ([lean4#15816]; fixed after v4.31.0). The self-test checks this: without
  the flag, a name literal no longer equals the same name built at run time.
- **Single-threaded.** The runtime is built without threads: a `Task` runs at
  once, on the thread that starts it, but `IO.Promise` and `IO.CancelToken`
  stop the program.
- **WebAssembly exceptions** (`-fwasm-exceptions`), for the runtime's C++.
- **Not built:** the runtime's `uv/` sources, which back `Std.Internal.UV`
  and whose WebAssembly stubs do not compile in v4.31.0 ([lean4#15181]).
- **Two runtime functions would trap if called:** `lean_io_create_tempfile`
  and `lean_io_create_tempdir` disagree with the C Lean generates for them
  ([lean4#16089]; fixed after v4.31.0); the linker warns of both. Nothing here
  calls them.
- **wasm32, not wasm64:** stable Safari does not support 64-bit WebAssembly
  memory.

[emdawnwebgpu]: https://dawn.googlesource.com/dawn/+/refs/heads/main/src/emdawnwebgpu/
[pages]: https://lancelet.github.io/webgpu-raw-lean/
[emsdk]: https://emscripten.org/docs/getting_started/downloads.html
[lean4#15816]: https://github.com/leanprover/lean4/pull/15816
[lean4#15181]: https://github.com/leanprover/lean4/issues/15181
[lean4#16089]: https://github.com/leanprover/lean4/issues/16089
