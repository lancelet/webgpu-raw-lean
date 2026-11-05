import Lake
open Lake DSL System

/-!
Raw Lean bindings to WebGPU (`webgpu.h`), generated from upstream's
`webgpu.yml` by `webgpu-gen`, and linked against prebuilt wgpu-native.

Run `vendor/wgpu-native/fetch.sh` once before building: it downloads the
wgpu-native release for this platform into `vendor/wgpu-native/<platform>/`.
The C shims need a C compiler with the C library's headers (`webgpu.h`
includes `<math.h>`), which Lean's bundled compiler lacks: the build uses `cc`,
or the compiler `CC` names. On Windows, use MinGW's: `CC=gcc`.

Every program that imports the bindings, in this package or one depending on
it, is linked with the shims and wgpu-native. Programs built here find
wgpu-native at run time by a path relative to themselves, so the checkout can
move. Elsewhere, a program needs wgpu-native on its library path: on Linux and
macOS, an rpath or `LD_LIBRARY_PATH` / `DYLD_LIBRARY_PATH`; on Windows,
`wgpu_native.dll` on `PATH` (for programs built here too:
`vendor/wgpu-native/windows-<arch>/lib`).

Nothing here records an absolute path: Lake keeps the configuration it
elaborated from this file, and a path in it would go stale when the checkout
moved.
-/

/-- The `vendor/wgpu-native/<platform>` directory name for the build host. -/
def wgpuPlatform : String :=
  let arch :=
    let t := System.Platform.target
    if t.startsWith "aarch64" || t.startsWith "arm64" then "aarch64"
    else "x86_64"
  if System.Platform.isWindows then s!"windows-{arch}"
  else if System.Platform.isOSX then s!"macos-{arch}"
  else s!"linux-{arch}"

/-- Where this platform's wgpu-native release is, in the package at `dir`. -/
def wgpuDir (dir : FilePath) : FilePath :=
  dir / "vendor" / "wgpu-native" / wgpuPlatform

/--
Where programs built here (in `.lake/build/bin/`) find wgpu-native, and
SDL3, at run time: an rpath relative to the program itself. (Windows has no
rpath.)
-/
def wgpuRpath : Array String :=
  let libs := #[s!"../../../vendor/wgpu-native/{wgpuPlatform}/lib",
    s!"../../../vendor/sdl3/{wgpuPlatform}/lib"]
  if System.Platform.isWindows then #[]
  else if System.Platform.isOSX then
    libs.map (s!"-Wl,-rpath,@executable_path/{·}")
  else libs.map (s!"-Wl,-rpath,$ORIGIN/{·}")

/-- The C compiler: `cc`, or the one `CC` names. -/
def cCompiler : IO String := return (← IO.getEnv "CC").getD "cc"

/-- Position-independent code, for any C linked into a shared library. -/
def picArgs : Array String :=
  if System.Platform.isWindows then #[] else #["-fPIC"]

/--
What a poke (`WebGPU.Raw.Internal.Bytes`) checks, as C the pokes call: nothing,
unless built with `-K checkPokes=true` (and `-R`, so Lake applies it), when it
stops the program if the array is held by anything else, or the store does not
fit. The tests run so in CI. Lake keeps the option until the next `-R`.
-/
def checkPoke : String :=
  if get_config? checkPokes == some "true" then
    "-DLEAN_WGPU_CHECK_POKE(b,o,w)=(lean_is_exclusive(b) \
      && (o) <= lean_sarray_size(b) && (w) <= lean_sarray_size(b) - (o) \
      ? (void)0 : lean_internal_panic(\"a poke into a shared array, \
      or past its end\"))"
  else
    "-DLEAN_WGPU_CHECK_POKE(b,o,w)=((void)0)"

/--
What the hand-written C (`c/*.c`) checks of its Lean specification, as the
pokes do: nothing, unless built with `-K checkPokes=true`, when
`LEAN_WGPU_CHECKED` compiles its checks in.
-/
def checkedArgs : Array String :=
  if get_config? checkPokes == some "true" then #["-DLEAN_WGPU_CHECKED"]
  else #[]

package WebGPURaw where
  leanOptions   := #[⟨`autoImplicit, false⟩]
  moreLinkArgs  := wgpuRpath
  moreLeancArgs := #[checkPoke]

/--
wgpu-native's shared library, from `fetch.sh`. Programs that link it are linked
again when it changes.
-/
target wgpuNative pkg : Dynlib := do
  let dir := wgpuDir pkg.dir
  let file := dir / "lib" / nameToSharedLib "wgpu_native"
  unless ← file.pathExists do
    error s!"no wgpu-native in {dir}: run vendor/wgpu-native/fetch.sh first"
  return (← inputBinFile file).map fun path => { path, name := "wgpu_native" }

/--
The C shims, generated into `c/generated/` by `webgpu-gen`, and the hand-written
C beside them in `c/`: every `.c` file in either, compiled with the system C
compiler (`cc`, or `CC`) into one static library. Each is rebuilt when it, or
any header in either or in wgpu-native's `include/webgpu/`, changes.
-/
target wgpuShim pkg : FilePath := do
  let handWritten := pkg.dir / "c"
  let sources := handWritten / "generated"
  let wgpuInclude := wgpuDir pkg.dir / "include"
  unless ← wgpuInclude.isDir do
    error s!"no wgpu-native in {wgpuDir pkg.dir}: \
      run vendor/wgpu-native/fetch.sh first"
  -- Sorted, since directory order varies, and the traces depend on the order.
  let paths (dir : FilePath) : IO (Array FilePath) := do
    return ((← dir.readDir).map (·.path)).qsort (·.toString < ·.toString)
  -- (`generated`, having no extension, is neither a source nor a header.)
  let files := (← paths handWritten) ++ (← paths sources)
  let wgpuHeaders ← paths (wgpuInclude / "webgpu")
  let headers := (files ++ wgpuHeaders).filter (·.extension == some "h")
  let headerJobs ← headers.mapM fun h => inputTextFile h
  let cc ← cCompiler
  let leanInclude ← getLeanIncludeDir
  let includes := #["-I", leanInclude.toString, "-I", wgpuInclude.toString,
    "-I", handWritten.toString]
  let objs ← (files.filter (·.extension == some "c")).mapM fun src => do
    let stem := src.fileStem.getD "shim"
    -- The source, with the headers' traces mixed into its own.
    let srcJob := (← inputTextFile src).zipWith (fun src _ => src)
      (Job.mixArray headerJobs "headers")
    let out := if src.parent == some handWritten then pkg.buildDir / "c"
      else pkg.buildDir / "c" / "generated"
    buildO (out / s!"{stem}.o") srcJob
      includes (#["-O2", "-DWEBGPU_RAW_WGPU_NATIVE"] ++ picArgs ++ checkedArgs)
      cc getLeanTrace
  buildStaticLib (pkg.staticLibDir / nameToStaticLib "wgpushim") objs

/--
The bindings. Modules under `WebGPU.Raw.Internal` are helpers for the generated
code: the bindings import them privately, so users never see them. Programs
that import the bindings are linked with the shims and wgpu-native.
-/
@[default_target]
lean_lib WebGPURaw where
  roots        := #[`WebGPU.Raw]
  moreLinkObjs := #[wgpuShim]
  moreLinkLibs := #[wgpuNative]

/--
C helpers for the tests only, every `.c` file in `WebGPURawTest/c/`: structs
as C lays them out, to compare encoding with; pointers filled in and read back;
a fake library that runs callbacks as WebGPU does; and, for the web self-test,
whether the page has WebGPU.
-/
target testHelpers pkg : FilePath := do
  let dir := pkg.dir / "WebGPURawTest" / "c"
  -- Sorted, since directory order varies, and the traces depend on the order.
  let srcs := ((← dir.readDir).map (·.path)).qsort (·.toString < ·.toString)
    |>.filter (·.extension == some "c")
  let includes := #[
    "-I", (← getLeanIncludeDir).toString,
    "-I", (wgpuDir pkg.dir / "include").toString,
    "-I", (pkg.dir / "c" / "generated").toString,
    "-I", (pkg.dir / "c").toString
  ]
  let headers ← [
    pkg.dir / "c" / "generated" / "objects.h",
    pkg.dir / "c" / "reloc.h",
    pkg.dir / "c" / "callback.h",
    pkg.dir / "c" / "family.h",
    wgpuDir pkg.dir / "include" / "webgpu" / "webgpu.h"
  ].mapM fun h => inputTextFile h
  let cc ← cCompiler
  let objs ← srcs.mapM fun src => do
    -- The source, with the headers' traces mixed into its own.
    let srcJob := (← inputTextFile src).zipWith (fun src _ => src)
      (Job.mixArray headers.toArray "headers")
    let stem := src.fileStem.getD "test"
    buildO (pkg.buildDir / "c" / "test" / s!"{stem}.o") srcJob
      includes (#["-O2"] ++ picArgs ++ checkedArgs) cc getLeanTrace
  buildStaticLib (pkg.staticLibDir / nameToStaticLib "wgpurawtest") objs

/-- Tests. `#guard` checks run while this library builds. -/
lean_lib WebGPURawTest where
  -- The shims again after the helpers, which call the walker in them: a static
  -- library resolves only what those before it need.
  moreLinkObjs := #[testHelpers, wgpuShim]

/--
The test driver: builds the tests, then builds and runs a program that imports
the bindings, linked against the shims and wgpu-native. Run with `lake test`.
-/
@[test_driver]
lean_exe «webgpu-raw-test» where
  root := `WebGPURawTest.Main

/--
The benchmark (`WebGPURawBench.lean`): how long the bindings take to pass a
struct to C, against C filling it. Run with `lake exe webgpu-raw-bench`.
-/
lean_exe «webgpu-raw-bench» where
  root         := `WebGPURawBench
  moreLinkObjs := #[testHelpers, wgpuShim]

/--
The web self-test (`WebGPURawWebTest/SelfTest.lean`): Lake compiles it to C,
which `web/build.sh` compiles to WebAssembly with the test helpers.
-/
lean_lib WebGPURawWebTest where
  moreLinkObjs := #[testHelpers]

/-! ## The window library

`WebGPUWindow`: a window, its events and a surface on it, natively on SDL3,
which `vendor/sdl3/fetch.sh` fetches into `vendor/sdl3/<platform>/`. Not a
default target: the bindings need no SDL. Programs built here find SDL3 at
run time as they find wgpu-native (on Windows, `SDL3.dll` on `PATH`).
-/

/-- Where this platform's SDL3 is, in the package at `dir`. -/
def sdlDir (dir : FilePath) : FilePath :=
  dir / "vendor" / "sdl3" / wgpuPlatform

/-- SDL3's shared library, from `fetch.sh`. -/
target sdl3 pkg : Dynlib := do
  let dir := sdlDir pkg.dir
  let file := if System.Platform.isWindows then dir / "bin" / "SDL3.dll"
    else dir / "lib" / nameToSharedLib "SDL3"
  unless ← file.pathExists do
    error s!"no SDL3 in {dir}: run vendor/sdl3/fetch.sh first"
  return (← inputBinFile file).map fun path => { path, name := "SDL3" }

/--
The window library's C (`window/c/*.c`), compiled with the system C compiler
against SDL3, the bindings' headers and wgpu-native's.
-/
target windowShim pkg : FilePath := do
  let dir := pkg.dir / "window" / "c"
  let srcs := ((← dir.readDir).map (·.path)).qsort (·.toString < ·.toString)
    |>.filter (·.extension == some "c")
  let includes := #[
    "-I", (← getLeanIncludeDir).toString,
    "-I", (wgpuDir pkg.dir / "include").toString,
    "-I", (sdlDir pkg.dir / "include").toString,
    "-I", (pkg.dir / "c").toString
  ]
  let headers ← [
    pkg.dir / "c" / "generated" / "objects.h",
    pkg.dir / "c" / "callback.h",
    pkg.dir / "c" / "family.h"
  ].mapM fun h => inputTextFile h
  let cc ← cCompiler
  let objs ← srcs.mapM fun src => do
    let srcJob := (← inputTextFile src).zipWith (fun src _ => src)
      (Job.mixArray headers.toArray "headers")
    let stem := src.fileStem.getD "window"
    buildO (pkg.buildDir / "c" / "window" / s!"{stem}.o") srcJob
      includes (#["-O2"] ++ picArgs ++ checkedArgs) cc getLeanTrace
  buildStaticLib (pkg.staticLibDir / nameToStaticLib "webgpuwindow") objs

/-- The window library (`WebGPUWindow.lean`). -/
lean_lib WebGPUWindow where
  moreLinkObjs := #[windowShim, wgpuShim]
  moreLinkLibs := #[sdl3, wgpuNative]

/--
The window library's test: a window, a surface on it, a triangle drawn in
it, read back where the surface allows. Run with
`lake exe webgpu-window-test`; it needs a display, and an adapter.
-/
lean_exe «webgpu-window-test» where
  root := `WebGPUWindowTest
