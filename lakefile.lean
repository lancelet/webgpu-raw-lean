import Lake
open Lake DSL System

/-!
Raw Lean bindings to WebGPU (`webgpu.h`), generated from upstream's
`webgpu.yml` by `webgpu-gen`, and linked against prebuilt wgpu-native.

The build fetches wgpu-native itself, the first time something needs it
(`vendor/wgpu-native/fetch.sh`, which downloads this platform's release into
`vendor/wgpu-native/<platform>/`). The C shims need a C compiler with the C
library's headers (`webgpu.h` includes `<math.h>`), which Lean's bundled
compiler lacks: the build uses `cc`, or the compiler `CC` names. On Windows,
use MinGW's: `CC=gcc`, with `sh` on `PATH` (Git Bash's), which runs the fetch
scripts.

Every program that imports the bindings, in this package or one depending on
it, is linked with the shims and wgpu-native. The build copies wgpu-native's
shared library (and SDL3's, for the window library) into the `bin` directory
of the package being built, beside its programs, which find it there: on Linux
and macOS by an rpath to their own directory, on Windows because a program's
own directory is searched first. So programs need no library path, and the
checkout can move.

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
Run the fetch script at `path` in the package at `dir`. Each does nothing
if what it fetches is already there.
-/
def runFetch (dir : FilePath) (path : String) : LogIO Unit :=
  proc { cmd := "sh", args := #[(dir / path).toString] } (quiet := true)

/--
Copy the shared library `file` into each of `bins`, with the names it has by
its version beside it: on Linux, `libSDL3.so.0`, which programs linked with
`libSDL3.so` load; on macOS, `libSDL3.0.dylib`. Each is copied unless its
copy has its contents already (not by timestamp: unzip gives an older
release its own), to a temporary file renamed into place, so that nothing
sees half a library. Returns the copy of `file` in the first of `bins`.
-/
def copyShared (file : FilePath) (bins : List FilePath) : IO FilePath := do
  let some dir  := file.parent   | return file
  let some name := file.fileName | return file
  let stem := file.fileStem.getD name
  let shared (n : String) : Bool :=
    if n == name then true
    else if System.Platform.isWindows then false
    else if System.Platform.isOSX then
      n.startsWith s!"{stem}." && n.endsWith ".dylib"
    else n.startsWith s!"{name}."
  for entry in ← dir.readDir do
    unless shared entry.fileName do continue
    let bytes ← IO.FS.readBinFile entry.path
    for bin in bins do
      IO.FS.createDirAll bin
      let copy := bin / entry.fileName
      if ← copy.pathExists then
        if (← IO.FS.readBinFile copy) == bytes then continue
      let tmp := bin / s!"{entry.fileName}.tmp"
      IO.FS.writeBinFile tmp bytes
      IO.FS.rename tmp copy
  return (bins.headD dir) / name

/--
What a program linking the shared libraries needs, as one linker argument: on
Linux and macOS, an rpath to its own directory, where the build copies them;
on Linux, also let it refer to the C library's newer symbols (Lean links
against its own, older, C library, but SDL3, built on the system, against the
system's, which the program meets at run time). None on Windows.
-/
def runPathArg : Option String :=
  if System.Platform.isWindows then none
  else if System.Platform.isOSX then some "-Wl,-rpath,@executable_path"
  else some "-Wl,-rpath,$ORIGIN,--allow-shlib-undefined"

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
  moreLeancArgs := #[checkPoke]
  license       := "Apache-2.0 OR MIT"
  licenseFiles  := #["LICENSE-APACHE", "LICENSE-MIT"]

/--
`runPathArg`, as a link object: Lake passes a library's link objects on to
every program that imports it, in any package, but a package's link
arguments only to its own programs.
-/
target runPath : FilePath := Job.async do
  let some arg := runPathArg | error "no run-path argument on Windows"
  addPureTrace arg "runPath"
  return FilePath.mk arg

/--
A library's link objects `objs`, with `runPath` where there is one: for
`WebGPURaw` alone, which every program with a window imports too, and Lake
repeats a link object given twice (the linker then warns of the second
rpath). Lake gives link objects to a library's static and shared builds too,
which do not want it: `lake build WebGPURaw:static` fails (`ar` finds no
such file), and the shared libraries look beside themselves. Nothing here
builds them.
-/
def withRunPath (objs : TargetArray FilePath) : TargetArray FilePath :=
  if runPathArg.isSome then objs.push runPath else objs

/-- wgpu-native, fetched if missing: its directory, once there. -/
target wgpuFetch pkg : FilePath := Job.async do
  runFetch pkg.dir "vendor/wgpu-native/fetch.sh"
  return wgpuDir pkg.dir

/--
wgpu-native's shared library, copied into the `bin` directories of the
package being built and of this one, where their programs find it (a program
of a third package between them, built from the first, would not). Programs
that link it are linked again when it changes.
-/
target wgpuNative pkg : Dynlib := do
  let dir ← (← wgpuFetch.fetch).await
  let bins := [(← getRootPackage).binDir, pkg.binDir].eraseDups
  let file := dir / "lib" / nameToSharedLib "wgpu_native"
  (← inputBinFile file).mapM fun file => do
    return { path := ← copyShared file bins, name := "wgpu_native" }

/--
The C shims, generated into `c/generated/` by `webgpu-gen`, and the hand-written
C beside them in `c/`: every `.c` file in either, compiled with the system C
compiler (`cc`, or `CC`) into one static library. Each is rebuilt when it, or
any header in either or in wgpu-native's `include/webgpu/`, changes.
-/
target wgpuShim pkg : FilePath := do
  let handWritten := pkg.dir / "c"
  let sources := handWritten / "generated"
  let wgpuInclude := (← (← wgpuFetch.fetch).await) / "include"
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
  moreLinkObjs := withRunPath #[wgpuShim]
  moreLinkLibs := #[wgpuNative]

/--
C helpers for the tests only, every `.c` file in `WebGPURawTest/c/`: structs
as C lays them out, to compare encoding with; pointers filled in and read back;
a fake library that runs callbacks as WebGPU does; and, for the web self-test,
whether the page has WebGPU.
-/
target testHelpers pkg : FilePath := do
  let dir := pkg.dir / "WebGPURawTest" / "c"
  let _ ← (← wgpuFetch.fetch).await
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
which the build fetches into `vendor/sdl3/<platform>/` the first time it
builds the window library (`vendor/sdl3/fetch.sh`: on Linux and macOS, it
builds SDL3 from source, with cmake). Not a default target: the bindings need
no SDL. Programs find SDL3 at run time as they find wgpu-native.
-/

/-- Where this platform's SDL3 is, in the package at `dir`. -/
def sdlDir (dir : FilePath) : FilePath :=
  dir / "vendor" / "sdl3" / wgpuPlatform

/-- SDL3, fetched (or built) if missing: its directory, once there. -/
target sdlFetch pkg : FilePath := Job.async do
  runFetch pkg.dir "vendor/sdl3/fetch.sh"
  return sdlDir pkg.dir

/--
SDL3's shared library, copied as wgpu-native's is.
-/
target sdl3 pkg : Dynlib := do
  let dir ← (← sdlFetch.fetch).await
  let bins := [(← getRootPackage).binDir, pkg.binDir].eraseDups
  let file := if System.Platform.isWindows then dir / "bin" / "SDL3.dll"
    else dir / "lib" / nameToSharedLib "SDL3"
  (← inputBinFile file).mapM fun file => do
    return { path := ← copyShared file bins, name := "SDL3" }

/--
The window library's C (`window/c/*.c`, with `stb_truetype.h`, which draws
text), compiled with the system C compiler against SDL3, the bindings'
headers and wgpu-native's.
-/
target windowShim pkg : FilePath := do
  let dir := pkg.dir / "window" / "c"
  let srcs := ((← dir.readDir).map (·.path)).qsort (·.toString < ·.toString)
    |>.filter (·.extension == some "c")
  let includes := #[
    "-I", (← getLeanIncludeDir).toString,
    "-I", ((← (← wgpuFetch.fetch).await) / "include").toString,
    "-I", ((← (← sdlFetch.fetch).await) / "include").toString,
    "-I", (pkg.dir / "c").toString
  ]
  let headers ← [
    pkg.dir / "c" / "generated" / "objects.h",
    pkg.dir / "c" / "callback.h",
    pkg.dir / "c" / "family.h",
    pkg.dir / "window" / "c" / "stb_truetype.h"
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

/--
The examples (`Examples/`), each a program of its own: `Examples.Triangle`,
a triangle in a window, natively (`lake exe triangle`) and on the web
(`web/build.sh` builds `triangle.html`).
-/
lean_lib Examples where
  globs := #[.submodules `Examples]

/-- The triangle example: `lake exe triangle [frames]`. -/
lean_exe triangle where
  root := `Examples.Triangle
