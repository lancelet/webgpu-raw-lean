/-!
# Stubs

The functions an implementation leaves unimplemented, read from its list of
stubs (`vendor/wgpu-native/stubs`, which `stubs.sh` writes): one C function
name per line, with blank lines and `#` comments ignored.
-/

namespace WebGPUGen

/-- The names in a list of stubs. -/
def parseStubs (text : String) : List String :=
  (text.splitOn "\n").filterMap fun line =>
    let line := line.trimAscii.toString
    if line.isEmpty || line.startsWith "#" then none else some line

end WebGPUGen
