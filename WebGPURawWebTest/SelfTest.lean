import WebGPU.Raw

/-!
# The web self-test

A program that checks Lean runs correctly as WebAssembly, then calls the
bindings. The checks are of what can go wrong silently there, rather than fail
to build: Lean does not support WebAssembly, and 32-bit targets have
miscompiled static constants before (lean4#15816), such as a name literal whose
hash differs from the same name built at run time.

`web/build.sh` builds it for WebAssembly, and CI runs it under Node; GitHub
Pages runs it in the browser. It is the export `web_main`, which `web/main.c`
calls: Lean's own `main` would start a thread, which single-threaded
WebAssembly cannot.
-/

namespace WebGPURawWebTest
open WebGPU.Raw

/-- A new instance, from the test helper (`WebGPURawTest/c/instance.c`). -/
@[extern "lean_wgpu_test_create_instance"]
opaque createInstance : IO Instance

/-- A name built at run time from its parts, so it is not a static constant. -/
@[noinline]
def runtimeName (parts : List String) : Lean.Name :=
  parts.foldl (fun n s => .str n s) .anonymous

/-- Each check: what it is, and whether it held. -/
def checks (parts : List String) : List (String × Bool) :=
  let literal := `WebGPU.Raw.Device
  let built := runtimeName parts
  let big := 2 ^ 100
  [
    ("name literal equals the name built at run time", literal == built),
    ("their hashes agree", hash literal == hash built),
    ("a string literal's length", "WebGPU in Lean".length == 14),
    ("UTF-8 sizes", "λ→".utf8ByteSize == 5),
    ("a bignum", toString big == "1267650600228229401496703205376"),
    ("bignum arithmetic", big / 2 ^ 99 == 2),
    ("64-bit integers", (0xFFFF_FFFF : UInt64) + 1 == 0x1_0000_0000),
    ("64-bit overflow", (0 : UInt64) - 1 == 0xFFFF_FFFF_FFFF_FFFF),
    ("an enum's code", CEnum.toC TextureFormat.rgba8Unorm == 0x00000016),
    ("an enum decoded",
      (CEnum.decode 0x00000016 : Except UInt32 TextureFormat)
        matches .ok .rgba8Unorm),
    ("an unknown code kept",
      (CEnum.decode 0x7FFF0000 : Except UInt32 TextureFormat)
        matches .error 0x7FFF0000)
  ]

/-- Run the checks, then call the bindings; print what happens. -/
@[export web_main]
def main : IO UInt32 := do
  let results := checks ["WebGPU", "Raw", "Device"]
  for (what, ok) in results do
    IO.println s!"{if ok then "ok  " else "FAIL"} {what}"
  let failed := results.filter (!·.2)
  -- The bindings: an instance, and a method called through its shim.
  let bindings ← try
      let wgpu ← createInstance
      wgpu.processEvents
      pure "ok   an instance created, and a method called on it"
    catch e => pure s!"FAIL the bindings: {e}"
  IO.println bindings
  if failed.isEmpty && bindings.startsWith "ok" then
    IO.println "All checks passed."
    return 0
  else
    IO.println s!"{failed.length + (if bindings.startsWith "ok" then 0 else 1)} \
      checks failed."
    return 1

end WebGPURawWebTest
