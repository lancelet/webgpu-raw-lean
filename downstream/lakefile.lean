import Lake
open Lake DSL

/-!
A package depending on the bindings, as another repository would, to check in
CI that one can: that its programs link, with the bindings alone and with the
window library too, and run, natively; and that the first builds for the web.
Another repository requires the bindings from git instead:

    require WebGPURaw from git
      "https://github.com/lancelet/webgpu-raw-lean" @ "v0.1.0"
-/

package Downstream

require WebGPURaw from ".."

lean_lib Downstream

lean_lib DownstreamWindow

/-- The bindings alone: `lake exe downstream`. -/
lean_exe downstream where
  root := `Downstream

/-- The window library too: `lake exe downstream-window`. -/
lean_exe «downstream-window» where
  root := `DownstreamWindow
