import WebGPU.Raw

/-!
# The web self-test

A program that checks Lean runs correctly as WebAssembly, then calls the
bindings. The checks are of what can go wrong silently there, rather than fail
to build: Lean does not support WebAssembly, and 32-bit targets have
miscompiled static constants before (lean4#15816), such as a name literal whose
hash differs from the same name built at run time.

Every check's inputs pass through `runtime`, which Lean cannot see through, so
that the check runs on the target rather than in the compiler. `web/build.sh`
builds it for WebAssembly, and CI runs it under Node and in a browser; GitHub
Pages publishes it.
-/

namespace WebGPURawWebTest
open WebGPU.Raw

/-- A new instance, from the test helper (`WebGPURawTest/c/instance.c`). -/
@[extern "lean_wgpu_test_create_instance"]
opaque createInstance : IO Instance

/--
`x`, but out of the compiler's sight: it cannot compute a check from it at
compile time, so the check runs where the program does.
-/
@[noinline]
def runtime {α : Type} (x : α) : α := x

/-- A name built at run time from its parts, so it is not a static constant. -/
@[noinline]
def runtimeName (parts : List String) : Lean.Name :=
  parts.foldl (fun n s => .str n s) .anonymous

/-- Each check: what it is, and whether it held. -/
def checks : List (String × Bool) :=
  let literal := `WebGPU.Raw.Device
  let built := runtimeName (runtime ["WebGPU", "Raw", "Device"])
  let big := runtime (2 : Nat) ^ 100
  [
    ("name literal equals the name built at run time", literal == built),
    ("their hashes agree", hash literal == hash built),
    ("a 32-bit platform", System.Platform.numBits == 32),
    ("USize is 32 bits", runtime (0 : USize) - 1 == 0xFFFF_FFFF),
    ("a string's length", (runtime "WebGPU in Lean").length == 14),
    ("UTF-8 sizes", (runtime "λ→").utf8ByteSize == 5),
    ("a bignum", toString big == "1267650600228229401496703205376"),
    ("bignum arithmetic", big / runtime (2 ^ 99) == 2),
    ("64-bit integers", runtime (0xFFFF_FFFF : UInt64) + 1 == 0x1_0000_0000),
    ("64-bit overflow",
      runtime (0 : UInt64) - 1 == 0xFFFF_FFFF_FFFF_FFFF),
    ("an enum's code",
      CEnum.toC (runtime TextureFormat.rgba8Unorm) == 0x00000016),
    ("an enum decoded",
      (CEnum.decode (runtime 0x00000016) : Except UInt32 TextureFormat)
        matches .ok .rgba8Unorm),
    ("an unknown code kept",
      (CEnum.decode (runtime 0x7FFF0000) : Except UInt32 TextureFormat)
        matches .error 0x7FFF0000)
  ]

end WebGPURawWebTest

/-- Run the checks, then call the bindings; print what happens. -/
def main : IO UInt32 := do
  let results := WebGPURawWebTest.checks
  for (what, ok) in results do
    IO.println s!"{if ok then "ok  " else "FAIL"} {what}"
  let failed := results.filter (!·.2)
  -- The bindings: an instance, and a method called through its shim.
  let bindings ← try
      let wgpu ← WebGPURawWebTest.createInstance
      wgpu.processEvents
      pure "ok   an instance created, and a method called on it"
    catch e => pure s!"FAIL the bindings: {e}"
  IO.println bindings
  let bindingsFailed := if bindings.startsWith "ok" then 0 else 1
  if failed.isEmpty && bindingsFailed == 0 then
    IO.println "All checks passed."
    return 0
  else
    IO.println s!"{failed.length + bindingsFailed} checks failed."
    return 1
