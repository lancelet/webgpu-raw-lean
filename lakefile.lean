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

Programs built here find wgpu-native where `fetch.sh` put it: on Linux and
macOS, the link records its directory (an rpath), so a program moved elsewhere
needs `LD_LIBRARY_PATH` or the library beside it; on Windows, programs find
`wgpu_native.dll` through `PATH`, so add `vendor/wgpu-native/windows-<arch>/lib`
to it before running them.

A package that depends on this one gets the C shims, but not how to link
wgpu-native, since Lake does not pass `moreLinkArgs` on to dependents: for now,
it must give the same link arguments as `wgpuLinkArgs` itself.
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

/-- Where this platform's wgpu-native release is. -/
def wgpuDir (pkgDir : FilePath) : FilePath :=
  pkgDir / "vendor" / "wgpu-native" / wgpuPlatform

/--
How to link wgpu-native: its shared library, with its directory recorded as an
rpath, so programs run in place without setting a library path.
-/
def wgpuLinkArgs (pkgDir : FilePath) : Array String :=
  let lib := (wgpuDir pkgDir / "lib").toString
  if System.Platform.isWindows then #[s!"-L{lib}", "-lwgpu_native"]
  else #[s!"-L{lib}", "-lwgpu_native", s!"-Wl,-rpath,{lib}"]

package WebGPURaw where
  leanOptions  := #[⟨`autoImplicit, false⟩]
  moreLinkArgs := wgpuLinkArgs __dir__

/--
The bindings. Modules under `WebGPU.Raw.Internal` are helpers for the generated
code: the bindings import them privately, so users never see them.
-/
@[default_target]
lean_lib WebGPURaw where
  roots := #[`WebGPU.Raw]

/--
The C shims, generated into `c/generated/` by `webgpu-gen`: every `.c` file
there, compiled with the system C compiler (`cc`, or `CC`) into one static
library linked into programs that use the bindings. Each is rebuilt when it,
or any header beside it or in wgpu-native's `include/webgpu/`, changes.
-/
extern_lib wgpushim pkg := do
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

/-- Tests. `#guard` checks run while this library builds. -/
lean_lib WebGPURawTest

/--
The test driver: builds the tests, then builds and runs a program that imports
the bindings, linked against the shims and wgpu-native. Run with `lake test`.
-/
@[test_driver]
lean_exe «webgpu-raw-test» where
  root := `WebGPURawTest.Main
