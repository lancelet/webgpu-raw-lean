import WebGPUGen.Lowered
import WebGPUGen.Lowered.BoundStructs
import WebGPUGen.Emit.C.Objects

/-!
# Function shims

The C side of the bound functions: for each function and method the bindings
can pass every value of (`Lowered.Function.unsupported` is empty), a shim that
Lean calls through a raw `@[extern]` declaration. The shim converts each
argument from its Lean ABI type (`Lowered.Value.abiCType`) to its C type, calls
the function, and returns its result boxed in an `IO` result:

    LEAN_EXPORT lean_obj_res lean_wgpuDeviceGetQueue(b_lean_obj_arg self) {
        WGPUQueue result = wgpuDeviceGetQueue(lean_wgpu_device_unbox(self));
        return lean_io_result_mk_ok(lean_wgpu_queue_box(result));
    }

The shim is named `lean_` and the C function's name. A method's object is its
first argument, `self`. Every object argument is borrowed, and a result object
is owned: the rules are in `docs/Safety.md`. A struct passed by pointer
crosses as its encoded bytes, targets and table's index (`argCrossing`), which
the shim fills in, by the tables, into the pointer it passes.
-/

namespace WebGPUGen.Emit.C
open WebGPUGen.Lowered WebGPUGen.Emit

/-- The shim's name for a function: `lean_wgpuDeviceGetQueue`. -/
def functionShimName (f : Lowered.Function) : String := "lean_" ++ f.names.c

/-! ## Helpers -/

/-- The C function that views a Lean string as a `WGPUStringView`. -/
def stringViewName : String := "lean_wgpu_string_view"

/--
The C function that views a Lean `Option String`: `none` is the null view.
-/
def optionStringViewName : String := "lean_wgpu_option_string_view"

/--
The C function that converts a size from Lean to a `size_t`: the largest
`UInt64` stands for `SIZE_MAX`, which is 32 bits on the web.
-/
def sizeName : String := "lean_wgpu_size"

/--
The C function that converts a `size_t` to a Lean size: `SIZE_MAX` is the
largest `UInt64`.
-/
def sizeToLeanName : String := "lean_wgpu_size_to_lean"

/-- The C function that makes an `IO` error with a message. -/
def ioErrorName : String := "lean_wgpu_io_error"

/--
Whether a shim must check the value, failing with an `IO` error: a `size_t`
argument must fit, and an object result that is not optional must not be NULL.
-/
def Value.checked : Value → Bool
  | .usize          => true
  | .object _ false => true
  | _               => false

/-- Whether `f` takes or returns a value `p` holds of. -/
def takes (p : Value → Bool) (f : Lowered.Function) : Bool :=
  f.args.any (p ·.value) || f.result.any p

/-- Whether a shim for `f` checks a value (`Value.checked`). -/
def checksAValue (f : Lowered.Function) : Bool := takes Value.checked f

/--
The helpers shims use, defined once at the top of the file: each with which
functions need it. A helper no shim uses is left out, since C warns of it. They
are `static inline`, since in a build where an implementation leaves some
functions unimplemented, the shims that would use one may not be compiled.
-/
def helpers : List ((Lowered.Function → Bool) × Decl) := [
  (takes (· matches .string _), .function {
    doc    := "A view of the bytes of the Lean string `s`, which stays alive \
      while the string is borrowed. Its length leaves out the terminating NUL."
    attrs  := ["static", "inline"]
    result := "WGPUStringView"
    name   := stringViewName
    params := [⟨"b_lean_obj_arg", "s"⟩]
    body   := [
      .decl "WGPUStringView" "view" (some (.init [
        ("data",   .call "lean_string_cstr" [.name "s"]),
        ("length",
          .binary "-" (.call "lean_string_size" [.name "s"]) (.lit "1"))
      ])),
      .ret (some (.name "view"))
    ]
  }),
  (takes (· == .string true), .function {
    doc    := "A view of the string a Lean `Option String` holds, or the null \
      view for `none`."
    attrs  := ["static", "inline"]
    result := "WGPUStringView"
    name   := optionStringViewName
    params := [⟨"b_lean_obj_arg", "option"⟩]
    body   := [
      .ifElse (.call "lean_is_scalar" [.name "option"]) [
        .decl "WGPUStringView" "null" (some (.name "WGPU_STRING_VIEW_INIT")),
        .ret (some (.name "null"))
      ] [],
      .ret (some (.call stringViewName
        [.call "lean_ctor_get" [.name "option", .lit "0"]]))
    ]
  }),
  (takes (· == .usize), .function {
    doc    := "A size from Lean as a `size_t`, checked to fit: the largest \
      `UInt64` stands for `SIZE_MAX`, which is 32 bits on the web."
    attrs  := ["static", "inline"]
    result := "size_t"
    name   := sizeName
    params := [⟨"uint64_t", "size"⟩]
    body   := [
      .ifElse (.binary "==" (.name "size") (.name "UINT64_MAX"))
        [.ret (some (.name "SIZE_MAX"))] [],
      .ret (some (.cast "size_t" (.name "size")))
    ]
  }),
  (takes (· == .usize), .function {
    doc    := "A `size_t` as a size in Lean: `SIZE_MAX` is the largest \
      `UInt64`."
    attrs  := ["static", "inline"]
    result := "uint64_t"
    name   := sizeToLeanName
    params := [⟨"size_t", "size"⟩]
    body   := [
      .ifElse (.binary "==" (.name "size") (.name "SIZE_MAX"))
        [.ret (some (.name "UINT64_MAX"))] [],
      .ret (some (.cast "uint64_t" (.name "size")))
    ]
  }),
  (fun f => !f.notImplementedBy.isEmpty || checksAValue f, .function {
    doc    := "An `IO` error saying `message`, for a check a shim makes, or a \
      function an implementation does not implement."
    attrs  := ["static", "inline"]
    result := "lean_obj_res"
    name   := ioErrorName
    params := [⟨"char const *", "message"⟩]
    body   := [
      .ret (some (.call "lean_io_result_mk_error" [
        .call "lean_mk_io_user_error" [.call "lean_mk_string" [.name "message"]]
      ]))
    ]
  })
]

/-! ## Conversions -/

/--
The object type with the C name `c` in `objects`, for its box and unbox
functions.
-/
def objectNamed (objects : List Lowered.Object) (c : String) :
    Option Lowered.Object :=
  objects.find? (·.names.c == c)

/--
An argument `x`, as Lean passes it, converted to the C value the function
takes; none if it cannot be. An enum or bitflag value comes as its code or
bits, which only need their C type.
-/
def argExpr (objects : List Lowered.Object) (x : String) : Value → Option Expr
  | .bool              => some (.cast "WGPUBool" (.name x))
  | .uint16 | .uint32 | .uint64 | .float32 | .float64 => some (.name x)
  | .int16             => some (.cast "int16_t" (.name x))
  | .int32             => some (.cast "int32_t" (.name x))
  | .usize             => some (.call sizeName [.name x])
  | .enum names        => some (.cast names.c (.name x))
  | .bitflag names     => some (.cast names.c (.name x))
  | .object names b    => (objectNamed objects names.c).map fun o =>
    .call (shimName o (if b then "unbox_option" else "unbox")) [.name x]
  | .string b          =>
    some (.call (if b then optionStringViewName else stringViewName) [.name x])
  -- Not passed to functions yet: their conversions come with descriptors,
  -- and a future with callbacks.
  | .nullableFloat32 | .struct _ | .structPointer .. | .array .. | .future =>
    none
  | .unsupported _     => none

/-- The C function that fills in a struct argument's pointers (`c/reloc.c`). -/
def fillArgName : String := "lean_wgpu_fill_arg"

/--
How an argument crosses into C: the shim's parameters for it, statements
before the call, and the C value the function takes.
-/
structure Crossing where
  params : List Param
  before : List Stmt
  value  : Expr

/--
How an argument `x` of the value `v` crosses, none if it cannot. Most cross as
one parameter, converted (`argExpr`). A struct behind a pointer crosses as
four: the Lean value, unused, which the proofs about the others are of; its
bytes, as C lays it out (borrowed: Lean releases them after the call); what C
fills in its pointers from; and its table's index. Before the call they are
filled in, by the tables (the shim's `tables`), into a pointer to pass, as
`void const *`, which C converts to the struct's pointer type.
-/
def argCrossing (objects : List Lowered.Object) (x : String) (v : Value) :
    Option Crossing :=
  match v with
  | .structPointer .. =>
    let filled := x ++ "_struct"
    some {
      params := [⟨"b_lean_obj_arg", x⟩, ⟨"b_lean_obj_arg", x ++ "_bytes"⟩,
        ⟨"b_lean_obj_arg", x ++ "_targets"⟩, ⟨"b_lean_obj_arg", x ++ "_table"⟩]
      before := [
        .expr (.cast "void" (.name x)),
        .decl "void const *" filled (some (.call fillArgName [
          .name (x ++ "_bytes"), .name "tables",
          .call "lean_usize_of_nat" [.name (x ++ "_table")],
          .name (x ++ "_targets")]))]
      value  := .name filled
    }
  | v => do
    let type ← v.abiCType
    let e ← argExpr objects x v
    pure { params := [⟨type, x⟩], before := [], value := e }

/-- Whether `f` takes a struct behind a pointer: its shim takes the tables. -/
def takesStruct (f : Lowered.Function) : Bool :=
  f.args.any (·.value matches .structPointer ..)

/-- The shim's parameter for the tables, if `f` takes a struct. -/
def tablesParams (f : Lowered.Function) : List Param :=
  if takesStruct f then [⟨"b_lean_obj_arg", "tables"⟩] else []

/--
A check that must pass before the call, for an argument `x` of the Lean
function `function`: a `size_t` must fit, or be the largest `UInt64`, which
stands for `SIZE_MAX`; otherwise the shim returns an `IO` error naming them.
-/
def argCheck (function x : String) : Value → List Stmt
  | .usize => [
    let roundTrip := Expr.cast "uint64_t" (.cast "size_t" (.name x))
    let notMax := Expr.binary "!=" (.name x) (.name "UINT64_MAX")
    .ifElse (.binary "&&" notMax (.binary "!=" roundTrip (.name x)))
      [.ret (some (.call ioErrorName [.lit message]))]
      []
  ]
  | _ => []
where
  message := s!"\"{function}: {x} is too large for a size_t\""

/--
The result `result`, of the C type the function returns, boxed as the value of
the `IO` result; none if it cannot be. A result object takes the reference the
function returned.
-/
def resultExpr (objects : List Lowered.Object) : Value → Option Expr
  | .bool           => some (box "lean_box" (.binary "!=" result (.lit "0")))
  | .uint16         => some (box "lean_box" result)
  | .uint32         => some (box "lean_box_uint32" result)
  | .uint64         => some (box "lean_box_uint64" result)
  | .int16          => some (box "lean_box" (.cast "uint16_t" result))
  | .int32          => some (box "lean_box_uint32" (.cast "uint32_t" result))
  | .float32        => some (box "lean_box_float32" result)
  | .float64        => some (box "lean_box_float" result)
  | .usize          =>
    some (box "lean_box_uint64" (.call sizeToLeanName [result]))
  | .enum _         => some (box "lean_box_uint32" (.cast "uint32_t" result))
  | .bitflag _      => some (box "lean_box_uint64" (.cast "uint64_t" result))
  | .object names b => (objectNamed objects names.c).map fun o =>
    box (shimName o (if b then "box_option" else "box")) result
  | .nullableFloat32 | .struct _ | .structPointer .. | .array .. => none
  -- A future is boxed with callbacks.
  | .string _ | .future => none
  | .unsupported _  => none
where
  result : Expr := .name "result"
  box (f : String) (e : Expr) : Expr := .call f [e]

/--
A check of the result `result` of `f`, after the call: an object that is not
optional must not be NULL, or the shim returns an `IO` error rather than make a
Lean value of nothing.
-/
def resultCheck (f : Lowered.Function) : Value → List Stmt
  | .object _ false => [
    .ifElse (.binary "==" (.name "result") (.lit "NULL"))
      [.ret (some (.call ioErrorName [.lit message]))]
      []
  ]
  | _ => []
where
  message := s!"\"{f.names.lean} returned NULL\""

/-! ## Shims -/

/--
The macro a build defines to say it builds against the implementation `impl`:
`WEBGPU_RAW_DAWN` for `dawn`.
-/
def implementationMacro (impl : String) : String :=
  let symbol (c : Char) := if c.isAlphanum then c.toUpper else '_'
  "WEBGPU_RAW_" ++ impl.map symbol

/--
The implementations a build can say it is against, each by defining its macro
(`implementationMacro`): the web build defines `WEBGPU_RAW_DAWN`. The native
build, against wgpu-native, defines none, so needs none.
-/
def implementations : List String := ["wgpu-native", "dawn"]

/--
The body of a shim for `f`, given its usual body and parameters. If an
implementation leaves `f` unimplemented, the shim calls it only when built
against one that implements it, and otherwise raises an `IO` error, its
parameters marked as used: so a build that says nothing, or the wrong thing,
gets the error, never the call that would abort.
-/
def guardStubs (f : Lowered.Function) (params : List Param) (body : List Stmt) :
    List Stmt :=
  if f.notImplementedBy.isEmpty then body else
  let unused := params.map fun p => Stmt.expr (.cast "void" (.name p.name))
  let missing := ", ".intercalate f.notImplementedBy
  let message := s!"\"{f.names.lean}: not implemented by {missing}\""
  let error := unused ++ [.ret (some (.call ioErrorName [.lit message]))]
  match implementations.filter (!f.notImplementedBy.contains ·) with
  | []           => error
  | implementing =>
    [.ifDefined (implementing.map implementationMacro) body error]


/--
A method's object, as the shim's first parameter `self` and the handle it
holds; nothing for a function of no object type. None if the object type is
not known.
-/
def receiverArg (objects : List Lowered.Object) :
    Option Names → Option (List (Param × Expr))
  | none       => some []
  | some names => (objectNamed objects names.c).map fun o =>
    [(⟨"b_lean_obj_arg", "self"⟩, .call (shimName o "unbox") [.name "self"])]

/--
The shim for `f`, if the bindings can pass all of its values: none otherwise,
so a function that is not understood is not bound; nor one that takes a
struct not among the bound `structs`, which has no table.
-/
def functionShim (objects : List Lowered.Object) (structs : List Names)
    (f : Lowered.Function) : Option Function := do
  guard f.unsupported.isEmpty
  guard (f.args.all fun a => match a.value with
    | .structPointer names _ => structs.contains names
    | _                      => true)
  -- An argument named like a shim's own variable, or like the parameters a
  -- struct crosses as, on either side, would hide it.
  guard (f.args.all fun a =>
    !["self", "result", "tables"].contains a.names.c
      && !(["_struct", "_bytes", "_targets", "_table"].any
        (a.names.c.endsWith ·))
      && !(["Bytes", "Targets", "Table"].any (a.names.lean.endsWith ·)))
  let shim := functionShimName f
  -- Every argument is borrowed, so a check that fails returns before any
  -- reference is taken, and nothing needs releasing.
  let receiver ← receiverArg objects f.receiver
  let args ← f.args.toList.mapM fun a => argCrossing objects a.names.c a.value
  let checks :=
    f.args.toList.flatMap fun a => argCheck f.names.lean a.names.c a.value
  let call := Expr.call f.names.c
    (receiver.map (·.2) ++ args.map (·.value))
  let body ← match f.result with
    | none => pure [
      .expr call,
      .ret (some (.call "lean_io_result_mk_ok" [.call "lean_box" [.lit "0"]]))
    ]
    | some v => do
      let cType ← v.cType
      let boxed ← resultExpr objects v
      pure ([.decl cType "result" (some call)] ++ resultCheck f v
        ++ [.ret (some (.call "lean_io_result_mk_ok" [boxed]))])
  let params := receiver.map (·.1) ++ args.flatMap (·.params)
    ++ tablesParams f
  pure {
    doc    := s!"Lean's `{f.names.lean}`: calls `{f.names.c}`."
    attrs  := ["LEAN_EXPORT"]
    result := "lean_obj_res"
    name   := shim
    params := params
    body   := guardStubs f params
      (checks ++ args.flatMap (·.before) ++ body)
  }

/-- Every function and method of the spec, in its order. -/
def allFunctions (spec : Lowered.Spec) : List Lowered.Function :=
  spec.functions.toList ++ spec.objects.toList.flatMap (·.methods.toList)

/--
The functions the bindings bind, each with its shim: those `functionShim` makes
a shim for. This is the one definition of what is bound, which the Lean side
uses too, so no `@[extern]` is declared without its shim.
-/
def boundFunctions (spec : Lowered.Spec) : List (Lowered.Function × Function) :=
  -- The bound structs a function can pass: not one that needs its chain.
  let all := spec.structs.toList
  let structs := ((boundStructs all).filter (!·.needsChain all)).map (·.names)
  (allFunctions spec).filterMap fun f =>
    (functionShim spec.objects.toList structs f).map (f, ·)

/-- The source: the helpers the shims use, then the shims. -/
def functionsSource (spec : Lowered.Spec) : List Decl :=
  let bound := boundFunctions spec
  [.include "stdint.h", .includeLocal "objects.h"]
    ++ (if bound.any (takesStruct ·.1) then [.includeLocal "reloc.h"] else [])
    ++ helpers.filterMap (fun (needs, d) =>
      if bound.any (needs ·.1) then some d else none)
    ++ bound.map fun (_, shim) => .function shim

/-- The function shims' source, `functions.c`. -/
def functionsFiles (p : Provenance) (spec : Lowered.Spec) :
    List (String × String) :=
  [("functions.c", cFile p (functionsSource spec))]

end WebGPUGen.Emit.C
