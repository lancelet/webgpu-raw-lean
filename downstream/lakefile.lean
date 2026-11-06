import Lake
open Lake DSL

/-!
A package depending on the bindings, as another repository would, to check in
CI that one can: that its program links with the bindings and the window
library, and runs, natively, and builds for the web. Another repository
requires the bindings from git instead:

    require WebGPURaw from git
      "https://github.com/lancelet/webgpu-raw-lean" @ "v0.1.0"
-/

package Downstream

require WebGPURaw from ".."

lean_lib Downstream

/-- The program: `lake exe downstream`. -/
lean_exe downstream where
  root := `Downstream
