import WebGPU.Raw
import WebGPURawTest

/-!
# Test driver

Building this program builds every test (`#guard` checks run as their modules
build), and the bindings with their C shims, linked against wgpu-native.
Running it shows a program importing the bindings starts.

The linker leaves out shims a program does not use, so this does not yet check
that every C function they call is in wgpu-native; the first bound functions
will use them.
-/

def main : IO Unit :=
  IO.println "The WebGPU bindings loaded."
