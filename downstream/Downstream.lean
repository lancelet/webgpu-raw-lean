import WebGPU.Raw

/-!
A program in a package depending on the bindings alone: it creates an
instance, which needs no adapter, and so runs anywhere, natively and on the
web.
-/

open WebGPU.Raw

def main : IO UInt32 := do
  let _ ← createInstance none
  IO.println "A package depending on the bindings created an instance."
  return 0
