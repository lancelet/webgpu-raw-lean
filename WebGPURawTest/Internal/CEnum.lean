import Lean
import WebGPU.Raw.Internal.CEnum

/-!
# Tests for `c_enum`

An enum declared with `c_enum` converts both ways as written, its laws are the
class's, and an enum whose codes are not distinct is rejected.
-/

namespace WebGPURawTest.Internal.CEnum
open WebGPU.Raw WebGPU.Raw.Internal

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

open Lean Elab Command in
/-- `#rejects cmd` passes if `cmd` reports an error, and fails otherwise. The
errors themselves are not shown: their wording is Lean's, not ours. -/
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

/-! ## A declared enum -/

-- Codes need not be consecutive: a gap, as a reserved slot leaves, and a code
-- in another block, as a namespaced entry has. A keyword is quoted.
/-- An example mode. -/
c_enum Mode where
  /-- The first mode. -/
  | first  = 0x00000001
  | third  = 0x00000003
  | compat = 0x20000001
  | «end»  = 0x00000004

#guard
  let expected : List UInt32 := [
    0x00000001,
    0x00000003,
    0x20000001,
    0x00000004
  ]
  [Mode.first, .third, .compat, .«end»].map CEnum.toC == expected

#guard
  let expected : List (Option Mode) := [
    some .first,
    none,
    some .third,
    some .compat,
    none
  ]
  [0x00000001, 0x00000002, 0x00000003, 0x20000001, 0x7FFFFFFF].map CEnum.ofC? == expected

-- The laws hold for it, as the class's theorems.
example (m : Mode) : CEnum.ofC? (CEnum.toC m) = some m := CEnum.ofC_toC m

/-! ## Several enums -/

-- Documented enums one after another: each doc comment belongs to its own
-- declaration, not to the enum before it.
/-- A first kind. -/
c_enum Kind1 where
  /-- One. -/
  | one = 1

/-- A second kind. -/
c_enum Kind2 where
  | two = 2

#guard CEnum.toC Kind1.one == 1 && CEnum.toC Kind2.two == 2

/-! ## A rejected enum -/

-- Two values with one code cannot be told apart, so the command's proof fails
-- and the enum is not declared.
#rejects c_enum Bad where
  | x = 1
  | y = 1

-- A code must fit in 32 bits; a larger one would otherwise wrap round.
#rejects c_enum Wide where
  | x = 0x100000000

end WebGPURawTest.Internal.CEnum
