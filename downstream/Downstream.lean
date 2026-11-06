import WebGPUWindow

/-!
A program in a package depending on the bindings: it creates an instance,
which needs no adapter, and so runs anywhere, natively and on the web. The
window library is imported, so the program links with it and with SDL3.
-/

open WebGPU.Raw

def main : IO UInt32 := do
  let _ ← createInstance none
  IO.println "A package depending on the bindings created an instance."
  return 0
