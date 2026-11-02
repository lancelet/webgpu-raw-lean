import Lean

/-!
# Test commands

Commands for checking what other commands do. Each elaborates its command in a
scratch environment, discarded afterwards, so nothing it declares reaches the
compiled tests: a declaration of a C function no one defines can be checked
without leaving a call to it for the linker.
-/

namespace WebGPURawTest
open Lean Elab Command

/--
`#accepts cmd` passes if `cmd` succeeds, and fails with its errors otherwise.
Whatever `cmd` declares is discarded.
-/
elab "#accepts " cmd:command : command => do
  withoutModifyingEnv (elabCommand cmd)

/--
`#rejects cmd` passes if `cmd` reports an error, and fails otherwise. The errors
themselves are not shown: their wording is Lean's, not ours.
-/
elab "#rejects " cmd:command : command => do
  let before := (← get).messages
  modify fun s => { s with messages := {} }
  -- Undo whatever the command declared before it failed.
  let failed ← withoutModifyingEnv do
    elabCommand cmd
    return (← get).messages.hasErrors
  modify fun s => { s with messages := before }
  unless failed do
    throwError "expected an error, but the command succeeded"

end WebGPURawTest
