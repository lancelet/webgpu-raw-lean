import WebGPUGen.Lowered
import WebGPUGen.Lowered.CNames
import WebGPUGen.Emit.C.Print

/-!
# Object shims

The C side of the object types: how a WebGPU handle becomes a Lean value and
back. Each object type gets a Lean external class whose finalizer releases the
handle's reference, and two functions:

* `lean_wgpu_device_box` wraps a `WGPUDevice` as a Lean `Device`. It takes the
  reference it is given: the Lean value now owns it, and releases it when Lean
  frees the value.
* `lean_wgpu_device_unbox` gives the `WGPUDevice` a Lean `Device` holds. It
  borrows: the Lean value keeps the reference.

The classes are registered when a program using the bindings starts, by
`lean_wgpu_objects_init`, which the Lean side runs with `builtin_initialize`:
the usual way Lean bindings to C libraries start up. (A plain `initialize`
would also run inside the compiler, whenever a file importing the bindings is
built, where there is no C code to call.)

Boxing has two conditions, and stops the program with a message if either is
broken, since both would otherwise crash later, far from the cause:

* the handle is not NULL. Releasing NULL crashes, so the shims for functions
  that can return NULL check first, and give Lean an `Option` or an error;
* the classes are registered: boxing during start-up, before the bindings'
  own start-up has run, would make a value without a class.

Boxing takes the reference it is given, which is right for every handle a
`webgpu.h` function returns: each comes with a reference of its own. A handle
the caller only borrows, such as one passed to a callback, must be given its
own reference with `wgpuXAddRef` before it is boxed.
-/

namespace WebGPUGen.Emit.C
open WebGPUGen.Lowered WebGPUGen.Emit

/-- The C function that visits the Lean values an object holds: none. -/
def visitNothing : String := "lean_wgpu_visit_nothing"

/-- A C name for object type `o`: its shim prefix, then `suffix`. -/
def shimName (o : Lowered.Object) (suffix : String) : String :=
  o.shim ++ "_" ++ suffix

/-- Stop the program with `message` if `cond` holds: a broken contract. -/
def panicIf (cond : Expr) (message : String) : Stmt :=
  .ifElse cond [.expr (.call "lean_internal_panic" [.lit ("\"" ++ message ++ "\"")])] []

/--
The bindings' start-up, which Lean runs when a program using them starts:
register every object type's external class.
-/
def initFunction (objects : List Lowered.Object) : Function where
  doc    := "The bindings' start-up, run by Lean when a program using them starts: \
    register every object type's external class."
  attrs  := ["LEAN_EXPORT"]
  result := "lean_obj_res"
  name   := objectsInitName
  params := []
  body   := objects.map (fun o =>
      .expr (.binary "=" (.name (shimName o "class"))
        (.call "lean_register_external_class" [.name (shimName o "finalize"), .name visitNothing])))
    ++ [.ret (some (.call "lean_io_result_mk_ok" [.call "lean_box" [.lit "0"]]))]

/-- The function that boxes a handle of `o` as a Lean value, taking its reference. -/
def boxFunction (o : Lowered.Object) : Function where
  doc    := s!"A Lean `{o.names.lean}` owning the reference `handle`, which it releases \
    when Lean frees it."
  attrs  := []
  result := "lean_obj_res"
  name   := shimName o "box"
  params := [⟨o.names.c, "handle"⟩]
  body   := [
    panicIf (.binary "==" (.name "handle") (.lit "NULL"))
      s!"{shimName o "box"}: a NULL {o.names.c}",
    panicIf (.binary "==" (.name (shimName o "class")) (.lit "NULL"))
      s!"{shimName o "box"}: before the bindings started",
    .ret (some (.call "lean_alloc_external" [.name (shimName o "class"), .name "handle"]))
  ]

/-- The function that gives the handle a Lean value of `o` holds, borrowing it. -/
def unboxFunction (o : Lowered.Object) : Function where
  doc    := s!"The `{o.names.c}` a Lean `{o.names.lean}` holds; the Lean value keeps \
    the reference."
  attrs  := []
  result := o.names.c
  name   := shimName o "unbox"
  params := [⟨"b_lean_obj_arg", "object"⟩]
  body   := [.ret (some (.cast o.names.c (.call "lean_get_external_data" [.name "object"])))]

/-- The header: the functions other shims use to box and unbox objects. -/
def objectsHeader (objects : List Lowered.Object) : List Decl :=
  [.pragma "once", .include "lean/lean.h", .include "webgpu/webgpu.h"]
    ++ objects.flatMap fun o => [.prototype (boxFunction o), .prototype (unboxFunction o)]

/-- The source: each object type's class and finalizer, the start-up, and the functions. -/
def objectsSource (objects : List Lowered.Object) : List Decl :=
  let visit : Function := {
    doc    := "An object holds no Lean values, so there are none to visit."
    attrs  := ["static"]
    result := "void"
    name   := visitNothing
    params := [⟨"void *", "data"⟩, ⟨"b_lean_obj_arg", "visitor"⟩]
    body   := [.expr (.cast "void" (.name "data")), .expr (.cast "void" (.name "visitor"))]
  }
  let classes := objects.map fun o =>
    Decl.variable ["static"] "lean_external_class *" (shimName o "class") (some (.lit "NULL"))
  let finalizer (o : Lowered.Object) := Decl.function {
    doc    := s!"Release the reference a Lean `{o.names.lean}` owned, when Lean frees it."
    attrs  := ["static"]
    result := "void"
    name   := shimName o "finalize"
    params := [⟨"void *", "data"⟩]
    body   := [.expr (.call o.release [.cast o.names.c (.name "data")])]
  }
  [.includeLocal "objects.h", .function visit] ++ classes ++ objects.map finalizer
    ++ [.function (initFunction objects)]
    ++ objects.flatMap fun o => [.function (boxFunction o), .function (unboxFunction o)]

/-! ## Files -/

/-- A generated C file: the banner, in a C comment, then the declarations. -/
def cFile (p : Provenance) (decls : List Decl) : String :=
  "\n".intercalate (banner p "/*" "*/") ++ "\n\n" ++ file decls

/-- The object shims' header and source, `objects.h` and `objects.c`. -/
def objectsFiles (p : Provenance) (spec : Lowered.Spec) : List (String × String) :=
  [
    ("objects.h", cFile p (objectsHeader spec.objects.toList)),
    ("objects.c", cFile p (objectsSource spec.objects.toList))
  ]

end WebGPUGen.Emit.C
