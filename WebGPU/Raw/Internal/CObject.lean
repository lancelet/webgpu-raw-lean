module

/-!
# The `c_object` command

A helper for the generated bindings, not part of the API: the bindings import
this module privately, so it never reaches their users.

    c_object Device

declares `Device`, the type of a handle to a WebGPU object (a `WGPUDevice`):
Lean code can hold one and pass it on, but only the C side can make one or look
inside it. It is Lean's usual way to refer to a foreign object:

    opaque Internal.DeviceHandle : NonemptyType
    def Device : Type := Internal.DeviceHandle.type
    instance : Nonempty Device := Internal.DeviceHandle.property

The handle that carries the type is declared under `Internal`, so the API shows
only `Device`. (Lean's own library makes such handles `private`, but a public
definition cannot refer to a private one under the module system.) Nothing here
needs a proof: the type has no values Lean can build.
-/

public section

namespace WebGPU.Raw.Internal
open Lean

/-- `c_object T`: the opaque type `T` of handles to a WebGPU object. -/
syntax (docComment)? "c_object " ident : command

macro_rules
  | `($[$doc?]? c_object $T:ident) => do
    let handle := mkIdentFrom T (`Internal ++ T.getId.appendAfter "Handle")
    let type ← `($[$doc?]? def $T:ident : Type := NonemptyType.type $handle)
    `(opaque $handle:ident : NonemptyType
      $type:command
      instance : Nonempty $T := Subtype.property $handle)

end WebGPU.Raw.Internal

end
