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
Where programs built here (in `.lake/build/bin/`) find wgpu-native at run time:
an rpath relative to the program itself. (Windows has no rpath.)
-/
def wgpuRpath : Array String :=
  let lib := s!"../../../vendor/wgpu-native/{wgpuPlatform}/lib"
  if System.Platform.isWindows then #[]
  else if System.Platform.isOSX then #[s!"-Wl,-rpath,@executable_path/{lib}"]
  else #[s!"-Wl,-rpath,$ORIGIN/{lib}"]

package WebGPURaw where
  leanOptions  := #[⟨`autoImplicit, false⟩]
  moreLinkArgs := wgpuRpath

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
The C shims, generated into `c/generated/` by `webgpu-gen`: every `.c` file
there, compiled with the system C compiler (`cc`, or `CC`) into one static
library. Each is rebuilt when it, or any header beside it or in wgpu-native's
`include/webgpu/`, changes.
-/
target wgpuShim pkg : FilePath := do
  let sources := pkg.dir / "c" / "generated"
  let wgpuInclude := wgpuDir pkg.dir / "include"
  unless ← wgpuInclude.isDir do
    error s!"no wgpu-native in {wgpuDir pkg.dir}: \
      run vendor/wgpu-native/fetch.sh first"
  -- Sorted, since directory order varies, and the traces depend on the order.
  let paths (dir : FilePath) : IO (Array FilePath) := do
    return ((← dir.readDir).map (·.path)).qsort (·.toString < ·.toString)
  let files ← paths sources
  let wgpuHeaders ← paths (wgpuInclude / "webgpu")
  let headers := (files ++ wgpuHeaders).filter (·.extension == some "h")
  let headerJobs ← headers.mapM fun h => inputTextFile h
  let cc := (← IO.getEnv "CC").getD "cc"
  let pic := if System.Platform.isWindows then #[] else #["-fPIC"]
  let leanInclude ← getLeanIncludeDir
  let includes := #["-I", leanInclude.toString, "-I", wgpuInclude.toString]
  let objs ← (files.filter (·.extension == some "c")).mapM fun src => do
    let stem := src.fileStem.getD "shim"
    -- The source, with the headers' traces mixed into its own.
    let srcJob := (← inputTextFile src).zipWith (fun src _ => src)
      (Job.mixArray headerJobs "headers")
    buildO (pkg.buildDir / "c" / s!"{stem}.o") srcJob
      includes (#["-O2"] ++ pic) cc getLeanTrace
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

/-- Tests. `#guard` checks run while this library builds. -/
lean_lib WebGPURawTest

/--
The test driver: builds the tests, then builds and runs a program that imports
the bindings, linked against the shims and wgpu-native. Run with `lake test`.
-/
@[test_driver]
lean_exe «webgpu-raw-test» where
  root := `WebGPURawTest.Main
