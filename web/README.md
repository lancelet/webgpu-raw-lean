# The web build

The bindings, compiled to WebAssembly, call WebGPU in the browser through
[emdawnwebgpu], Dawn's implementation of `webgpu.h` for Emscripten. So far
this builds a self-test, which CI runs under Node and publishes to
[GitHub Pages][pages].

## Lean does not support WebAssembly

Lean has published no WebAssembly build since v4.15, and its WebAssembly CI is
disabled. This build is a workaround: it assembles what Lean would otherwise
ship. It works for Lean v4.31.0, but each Lean upgrade can break it, and how
long it will keep working is unknown. The same route (Lean's C, compiled with
Emscripten) is the one every project running compiled Lean in the browser
takes; there is no maintained alternative yet.

## Building

You need the [Emscripten SDK][emsdk] at the version in `emscripten-version`
(`emcc`, `em++`, `emar` and `emcmake` on `PATH`), `cmake` and `make`, and
Lean through elan as usual. Then, from the repository root:

    web/build.sh
    node .lake/web/site/webgpu-raw-web-test.js

The build writes the page and its program to `.lake/web/site/`. To open the
page, serve that directory (a browser will not load WebAssembly from a `file:`
URL) with `node web/serve.mjs`, then open http://localhost:8000/.
`web/check-page.sh` loads it in headless Chrome or Chromium, and passes if it
reports that all checks passed; CI runs both checks.

## What it does

`build.sh` builds, once per Lean version, into `.lake/web/<version>/`:

- **Lean's runtime**, compiled from Lean's source at the version in
  `lean-toolchain` (`vendor/lean4/fetch.sh`), with `include/lean/config.h` in
  place of the one Lean's own build writes;
- **`Init`**, Lean's core library: the toolchain ships its sources but not its
  C, so each module is compiled to C again with `lean -c`, with the option
  Lean's own build uses;
- **libuv**, which the runtime uses, at the version and with the patch Lean's
  own WebAssembly build uses (`vendor/libuv/fetch.sh`).

Then Lake compiles the bindings and the self-test to C, and `build.sh`
compiles that C, the generated shims and `main.c`, and links them.

## What to know

- **`-DLEAN_EMSCRIPTEN` on all of Lean's C is required.** Without it, Lean
  4.29 and later silently miscompile static constants on 32-bit targets
  ([lean4#15816]; fixed after v4.31.0). The self-test checks this: without
  the flag, a name literal no longer equals the same name built at run time.
- **Single-threaded.** WebAssembly here has no threads, so `main.c` runs the
  program on its own thread rather than through Lean's generated `main`, which
  starts one. A `Task` runs without a thread of its own.
- **WebAssembly exceptions** (`-fwasm-exceptions`), for the runtime's C++.
- **Not built:** the runtime's `uv/` sources, which back `Std.Internal.UV`
  and whose WebAssembly stubs do not compile in v4.31.0 ([lean4#15181]).
- **Two runtime functions would trap if called:** `lean_io_create_tempfile`
  and `lean_io_create_tempdir` disagree with the C Lean generates for them
  ([lean4#16089]; fixed after v4.31.0); the linker warns of both. Nothing here
  calls them.
- **wasm32, not wasm64:** Safari does not support 64-bit WebAssembly memory.

[emdawnwebgpu]: https://dawn.googlesource.com/dawn/+/refs/heads/main/src/emdawnwebgpu/
[pages]: https://lancelet.github.io/webgpu-raw-lean/
[emsdk]: https://emscripten.org/docs/getting_started/downloads.html
[lean4#15816]: https://github.com/leanprover/lean4/pull/15816
[lean4#15181]: https://github.com/leanprover/lean4/issues/15181
[lean4#16089]: https://github.com/leanprover/lean4/issues/16089
