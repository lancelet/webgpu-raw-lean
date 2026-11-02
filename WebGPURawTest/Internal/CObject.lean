import WebGPU.Raw.Internal.CObject

/-!
# Tests for `c_object`

A type declared with `c_object` is a type with no values Lean can build, known
to be non-empty, with its handle hidden under `Internal`.
-/

namespace WebGPURawTest.Internal.CObject
open WebGPU.Raw.Internal

/-- An example object. -/
c_object Thing

-- It is a type, and Lean knows it has values, so a C function returning one can
-- be declared `@[extern]`, as the bindings will.
example : Type := Thing
example : Nonempty Thing := inferInstance
@[extern "make_thing"] opaque makeThing : Unit → Thing

-- Its handle is under `Internal`, not beside the type.
example : NonemptyType := Internal.ThingHandle

end WebGPURawTest.Internal.CObject
