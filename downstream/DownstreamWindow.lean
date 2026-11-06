import WebGPUWindow

/-!
A program in a package depending on the bindings that imports the window
library too, so that it links with it and with SDL3: it creates an
instance, as `Downstream` does, and opens no window, so runs anywhere.
-/

open WebGPU.Raw

def main : IO UInt32 := do
  let _ ← createInstance none
  IO.println "A package depending on the window library created an instance."
  return 0
