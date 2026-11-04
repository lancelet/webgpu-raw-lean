import Lean
import WebGPU.Raw.Encoders

/-!
# The generated encoders' attributes

Every generated encoder is `@[noinline]`, as the pokes in it require: inlined
into a function that encoded two values of a struct, its fresh blocks could be
merged into one; and so are the encoders of arrays, and of the blocks of
objects. And every encoder, and everything that makes the blocks C fills in
(`targets64`, `block64`, `targetsAll64`, `array64`, and the 32-bit ones), is
`@[never_extract]`: applied to a constant, it could otherwise be computed
once, as the module loads, and C would fill in a block every call shares. This
checks every one as it builds. (A module of its own, as it needs `Lean`, which
the web build does not have.)
-/

namespace WebGPURawTest.Internal.EncodeAttrs
open Lean Elab Command

/-- The declarations under `WebGPU.Raw` whose last part is one of `lasts`. -/
def generated (env : Environment) (lasts : List String) : Array Name :=
  let raw := `WebGPU.Raw
  env.constants.fold (init := #[]) fun found n _ =>
    match n with
    | .str _ s =>
      if raw.isPrefixOf n && lasts.contains s then found.push n else found
    | _ => found

run_cmd do
  let env ← getEnv
  let encoders := generated env
    ["encode64", "encode32", "encodeAll64", "encodeAll32"]
    ++ #[``WebGPU.Raw.Encode.encodeU32s, ``WebGPU.Raw.Reloc.objectsBlock]
  let makers := encoders ++ generated env
    ["targets64", "targets32", "block64", "block32", "targetsAll64",
      "targetsAll32", "array64", "array32"]
    ++ #[``WebGPU.Raw.Reloc.CStruct.optBytes,
      ``WebGPU.Raw.Reloc.CStruct.optTargets]
  if encoders.isEmpty then throwError "no generated encoders found"
  if makers.size == encoders.size then throwError "no generated targets found"
  for n in encoders do
    unless Compiler.hasNoInlineAttribute env n do
      throwError m!"{n} is not @[noinline]"
  for n in makers do
    unless hasNeverExtractAttribute env n do
      throwError m!"{n} is not @[never_extract]"

end WebGPURawTest.Internal.EncodeAttrs
