import WebGPUGen.Lowered
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
is owned: the rules are in `docs/Safety.md`.
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

/--
The helpers shims use, defined once at the top of the file: each with which
values need it. A helper no shim uses is left out, since C warns of it.
-/
def helpers : List ((Value → Bool) × Decl) := [
  ((· matches .string _), .function {
    doc    := "A view of the bytes of the Lean string `s`, which stays alive \
      while the string is borrowed. Its length leaves out the terminating NUL."
    attrs  := ["static"]
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
  ((· == .string true), .function {
    doc    := "A view of the string a Lean `Option String` holds, or the null \
      view for `none`."
    attrs  := ["static"]
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
  (Value.checked, .function {
    doc    := "An `IO` error saying `message`, for a check a shim makes."
    attrs  := ["static"]
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
  | .usize             => some (.cast "size_t" (.name x))
  | .enum names        => some (.cast names.c (.name x))
  | .bitflag names     => some (.cast names.c (.name x))
  | .object names b    => (objectNamed objects names.c).map fun o =>
    .call (shimName o (if b then "unbox_option" else "unbox")) [.name x]
  | .string b          =>
    some (.call (if b then optionStringViewName else stringViewName) [.name x])
  | .unsupported _     => none

/--
A check that must pass before the call, for an argument `x` of the Lean
function `function`: a `size_t` must fit, or the shim returns an `IO` error
naming them.
-/
def argCheck (function x : String) : Value → List Stmt
  | .usize => [
    let roundTrip := Expr.cast "uint64_t" (.cast "size_t" (.name x))
    .ifElse (.binary "!=" roundTrip (.name x))
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
  | .usize          => some (box "lean_box_uint64" (.cast "uint64_t" result))
  | .enum _         => some (box "lean_box_uint32" (.cast "uint32_t" result))
  | .bitflag _      => some (box "lean_box_uint64" (.cast "uint64_t" result))
  | .object names b => (objectNamed objects names.c).map fun o =>
    box (shimName o (if b then "box_option" else "box")) result
  | .string _       => none
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
so a function that is not understood is not bound.
-/
def functionShim (objects : List Lowered.Object) (f : Lowered.Function) :
    Option Function := do
  guard f.unsupported.isEmpty
  -- An argument named like a shim's own variable would hide it.
  guard (f.args.all fun a => !["self", "result"].contains a.names.c)
  let shim := functionShimName f
  -- Every argument is borrowed, so a check that fails returns before any
  -- reference is taken, and nothing needs releasing.
  let receiver ← receiverArg objects f.receiver
  let args ← f.args.toList.mapM fun a => do
    let type ← a.value.abiCType
    let e ← argExpr objects a.names.c a.value
    pure ((⟨type, a.names.c⟩ : Param), e)
  let checks :=
    f.args.toList.flatMap fun a => argCheck f.names.lean a.names.c a.value
  let call := Expr.call f.names.c ((receiver ++ args).map (·.2))
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
  pure {
    doc    := s!"Lean's `{f.names.lean}`: calls `{f.names.c}`."
    attrs  := ["LEAN_EXPORT"]
    result := "lean_obj_res"
    name   := shim
    params := (receiver ++ args).map (·.1)
    body   := checks ++ body
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
  (allFunctions spec).filterMap fun f =>
    (functionShim spec.objects.toList f).map (f, ·)

/-- The source: the helpers the shims use, then the shims. -/
def functionsSource (spec : Lowered.Spec) : List Decl :=
  let bound := boundFunctions spec
  let values := bound.flatMap fun (f, _) =>
    f.args.toList.map (·.value) ++ f.result.toList
  [.include "stdint.h", .includeLocal "objects.h"]
    ++ helpers.filterMap (fun (needs, d) =>
      if values.any needs then some d else none)
    ++ bound.map fun (_, shim) => .function shim

/-- The function shims' source, `functions.c`. -/
def functionsFiles (p : Provenance) (spec : Lowered.Spec) :
    List (String × String) :=
  [("functions.c", cFile p (functionsSource spec))]

end WebGPUGen.Emit.C
