import Lean
import WebGPU.Raw.Encoders

/-!
# The generated encoders' attributes

Every generated encoder is `@[noinline]`, as the pokes in it require: inlined
into a function that encoded two values of a struct, its fresh blocks could be
merged into one. This checks every one as it builds. (A module of its own, as it
needs `Lean`, which the web build does not have.)
-/

namespace WebGPURawTest.Internal.EncodeAttrs
open Lean Elab Command

run_cmd do
  let env ← getEnv
  let raw := `WebGPU.Raw
  let encoders := env.constants.fold (init := #[]) fun found n _ =>
    match n with
    | .str _ s =>
      if raw.isPrefixOf n && (s == "encode64" || s == "encode32") then
        found.push n
      else found
    | _ => found
  if encoders.isEmpty then throwError "no generated encoders found"
  for n in encoders do
    unless Compiler.hasNoInlineAttribute env n do
      throwError m!"{n} is not @[noinline]"

end WebGPURawTest.Internal.EncodeAttrs
