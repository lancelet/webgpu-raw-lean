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
How a function the shims use is declared, by the macro `helperMacro`
defines: `static inline`, and marked as perhaps unused, as in a build against
an implementation that leaves some functions unimplemented, the shims that
would use it are not compiled (gcc allows an unused `static inline` function;
clang warns of it).
-/
def helperAttrs : List String := ["LEAN_WGPU_HELPER"]

/-- The definition of the macro `helperAttrs` names, with what it is for. -/
def helperMacro : List Decl := [
  .comment "A function the shims use, which some builds may not.",
  .define "LEAN_WGPU_HELPER" [] ["static inline __attribute__((unused))"]
]

/--
The helpers shims use, defined once at the top of the file: each with which
functions need it. A helper no shim uses is left out, as C warns of it; one
only some builds use is declared so (`helperAttrs`).
-/

def helpers : List ((Lowered.Function → Bool) × Decl) := [
  (takes (· matches .string _), .function {
    doc    := "A view of the bytes of the Lean string `s`, which stays alive \
      while the string is borrowed. Its length leaves out the terminating NUL."
    attrs  := helperAttrs
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
    attrs  := helperAttrs
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
    attrs  := helperAttrs
    result := "size_t"
    name   := sizeName
    params := [⟨"uint64_t", "size"⟩]
    body   := [
      .ifElse (.binary "==" (.name "size") (.name "UINT64_MAX"))
        [.ret (some (.name "SIZE_MAX"))] [],
      .ret (some (.cast "size_t" (.name "size")))
    ]
  }),
  (fun f => f.result == some .usize, .function {
    doc    := "A `size_t` as a size in Lean: `SIZE_MAX` is the largest \
      `UInt64`."
    attrs  := helperAttrs
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
    attrs  := helperAttrs
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
  -- Not one parameter: a struct behind a pointer, or an array, crosses as
  -- several (`argCrossing`). Not passed to functions yet: a nullable float
  -- or a struct by value. A future is only ever a result, and a callback's
  -- info in a struct.
  | .nullableFloat32 | .struct _ | .structPointer .. | .array .. | .bytes
  | .future
  | .callbackInfo .. | .lentObject _ => none
  | .unsupported _     => none

/-- The C function that fills in a struct argument's pointers (`c/reloc.c`). -/
def fillArgName : String := "lean_wgpu_fill_arg"

/--
The C function that gives the pointer to pass for an array argument whose
elements are `element` (`c/reloc.c`): filling an array of objects' block with
their handles, or giving an array of `uint32_t`s' block as it is. None for
other elements, which the bindings do not pass yet.
-/
def arrayArgName : Value → Option String
  | .object _ false => some "lean_wgpu_fill_objects"
  | .uint32         => some "lean_wgpu_u32s_arg"
  | _               => none

/--
How an argument crosses into C: the shim's parameters for it, statements
before the call, and the C values the function takes for it, in order: one,
or an array's count and pointer.
-/
structure Crossing where
  params : List Param
  before : List Stmt
  values : List Expr

/--
How an argument `x` of the value `v` crosses, none if it cannot. Most cross as
one parameter, converted (`argExpr`). A struct behind a pointer crosses as
four: the Lean value, unused, which the proofs about the others are of; its
bytes, as C lays it out (borrowed: Lean releases them after the call); what C
fills in its pointers from; and its table's index. Before the call they are
filled in, by the tables (the shim's `tables`), into a pointer to pass, as
`void const *`, which C converts to the struct's pointer type. Bytes cross
as one, their `ByteArray`, passed as a pointer to them and their size. An
array crosses as two: the Lean array, and its block (`arrayArgName`), whose
pointer C passes after the array's size.
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
      values := [.name filled]
    }
  | .bytes => some {
      params := [⟨"b_lean_obj_arg", x⟩]
      before := []
      values := [.call "lean_sarray_cptr" [.name x],
        .call "lean_sarray_size" [.name x]]
    }
  | .array element _ => do
    let fill ← arrayArgName element
    let data := x ++ "_data"
    pure {
      params := [⟨"b_lean_obj_arg", x⟩, ⟨"b_lean_obj_arg", x ++ "_block"⟩]
      before := [.decl "void const *" data
        (some (.call fill [.name (x ++ "_block"), .name x]))]
      values := [.call "lean_array_size" [.name x], .name data]
    }
  | v => do
    let type ← v.abiCType
    let e ← argExpr objects x v
    pure { params := [⟨type, x⟩], before := [], values := [e] }

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
  | .nullableFloat32 | .struct _ | .structPointer .. | .array .. | .bytes =>
    none
  -- A future as its ID.
  | .future         => some (box "lean_box_uint64" (.member result "id"))
  | .string _ | .callbackInfo .. | .lentObject _ => none
  | .unsupported _  => none
where
  result : Expr := .name "result"
  box (f : String) (e : Expr) : Expr := .call f [e]

/--
A check of the result `result` of `f`, after the call: an object that is not
optional must not be NULL, or the shim returns an `IO` error rather than make a
Lean value of nothing, by `ret`, through the call's bracket.
-/
def resultCheck (f : Lowered.Function) (ret : Expr → Stmt) : Value → List Stmt
  | .object _ false => [
    .ifElse (.binary "==" (.name "result") (.lit "NULL"))
      [ret (.call ioErrorName [.lit message])]
      []
  ]
  | _ => []
where
  message := s!"\"{f.names.lean} returned NULL\""

/-! ## Callbacks

A callback's closure is its C userdata (`userdata1`), held until it is called
(`c/callback.c`). Its trampoline, one for each callback type, boxes each
argument as the closure takes it and applies the closure, which releases it:

    LEAN_WGPU_HELPER void lean_WGPUQueueWorkDoneCallback(
        WGPUQueueWorkDoneStatus status,
        WGPUStringView          message,
        void *                  userdata1,
        void *                  userdata2
    ) {
        (void)userdata2;
        lean_wgpu_callback_done(lean_apply_3(
            (lean_object *)userdata1,
            lean_box_uint32((uint32_t)status),
            lean_wgpu_string_of_view(message),
            lean_io_mk_world()
        ));
    }
-/

/--
The trampoline for callbacks of type `c`: `lean_WGPUQueueWorkDoneCallback`.
-/
def trampolineName (c : Lowered.Callback) : String := "lean_" ++ c.names.c

/--
A callback's argument `x`, of the value `v`, as the Lean value its closure
takes (`Value.callbackRawType`): an enum as its code, an object boxed with the
reference C gives it, as an `Option`, and a string copied. None if it cannot
be.
-/
def callbackArgExpr (objects : List Lowered.Object) (x : String) :
    Value → Option Expr
  | .enum _            =>
    some (.call "lean_box_uint32" [.cast "uint32_t" (.name x)])
  | .object names true => (objectNamed objects names.c).map fun o =>
    .call (shimName o "box_option") [.name x]
  | .string false      => some (.call "lean_wgpu_string_of_view" [.name x])
  | _                  => none

/--
The trampoline for callbacks of type `c`, if the bindings can pass each of its
arguments: it takes them as C passes them, then the two userdata pointers, and
applies the closure to those it passes Lean (`Callback.passed`), marking those
C lends unused. A callback a function takes is called once: its closure is
`userdata1`, which applying releases. One a struct keeps (`held`) may be
called again: its closure is the one the family `userdata1` holds at
`userdata2`, a reference to which applying releases; nothing is done if the
family is gone. It takes no object with its reference, which it would have to
release then.
-/
def trampoline (objects : List Lowered.Object) (c : Lowered.Callback)
    (held : Bool := false) : Option Function := do
  -- An argument named like a userdata pointer, or the closure, would hide it.
  guard (c.args.all fun a =>
    !["userdata1", "userdata2", "closure", "family"].contains a.names.c)
  guard (!held || c.passed.all fun a => !(a.value matches .object ..))
  let params ← c.args.toList.mapM fun a =>
    a.value.cType.map fun type => (⟨type, a.names.c⟩ : Param)
  let boxed ← c.passed.mapM fun a => callbackArgExpr objects a.names.c a.value
  -- `lean.h` applies a closure to at most 16 arguments, its world among them.
  guard (boxed.length < 16)
  let lent := c.args.toList.filterMap fun a => match a.value with
    | .lentObject _ => some (Stmt.expr (.cast "void" (.name a.names.c)))
    | _             => none
  let world := Expr.call "lean_io_mk_world" []
  let apply (closure : Expr) : Stmt :=
    .expr (.call "lean_wgpu_callback_done" [
      .call s!"lean_apply_{boxed.length + 1}" (closure :: boxed ++ [world])])
  let userdata (x type : String) := Expr.cast type (.cast "uintptr_t" (.name x))
  -- The objects it gives Lean join the family `userdata2` names.
  let joins := c.passed.filterMap fun a => match a.value with
    | .object .. => some (Stmt.expr
      (.call "lean_wgpu_family_join" [.name a.names.c, .name "family"]))
    | _ => none
  let family (x : String) := Stmt.decl "lean_wgpu_family" "family"
    (some (userdata x "lean_wgpu_family"))
  -- On the web, one with a mode is called once, giving back the reference
  -- its family took for it then (`familyAround`).
  let once := if c.style == .callbackMode then
    [Stmt.ifDefined ["WEBGPU_RAW_DAWN"]
      [.expr (.call "lean_wgpu_family_release" [.name "family"])] []]
    else []
  pure {
    doc    := if held then s!"Calls the closure the family `userdata1` holds \
      at `userdata2`, as a `{c.names.lean}`, keeping it, as C may call it \
      again; nothing if the family is gone."
      else s!"Calls the Lean closure `userdata1` as a `{c.names.lean}`, \
        releasing it; each object it gives Lean joins the family `userdata2` \
        names, whose reference it gives back."
    attrs  := helperAttrs
    result := "void"
    name   := trampolineName c
    params := params ++ [⟨"void *", "userdata1"⟩, ⟨"void *", "userdata2"⟩]
    -- The reference for a call Dawn makes once is given back before the
    -- closure is looked up: it is the family's, wherever the closure is.
    body   := lent ++ if held then [
      family "userdata1",
      .decl "lean_object *" "closure" (some (.call "lean_wgpu_family_closure"
        [.name "family", userdata "userdata2" "size_t"]))
    ] ++ once ++ [
      .ifElse (.binary "==" (.name "closure") (.lit "NULL")) [.ret none] [],
      apply (.name "closure")
    ] else [family "userdata2"] ++ joins ++ [
      .expr (.call "lean_wgpu_family_release" [.name "family"]),
      apply (.cast "lean_object *" (.name "userdata1"))
    ]
  }

/--
The C function that gives the address of the trampoline for callbacks of type
`c`, which Lean writes into a struct that keeps one:
`lean_WGPUDeviceLostCallback_address`.
-/
def addressName (c : Lowered.Callback) : String :=
  s!"lean_{c.names.c}_address"

/-- The function `addressName` names, for a callback a struct keeps. -/
def addressFunction (c : Lowered.Callback) : Function := {
  doc    := s!"The address of `{c.names.lean}`'s trampoline, for Lean to \
    write into a struct."
  attrs  := ["LEAN_EXPORT"]
  result := "uint64_t"
  name   := addressName c
  params := [⟨"b_lean_obj_arg", "unit"⟩]
  body   := [
    .expr (.cast "void" (.name "unit")),
    .ret (some
      (.cast "uint64_t" (.cast "uintptr_t" (.name (trampolineName c)))))
  ]
}

/--
The callback types for which the bindings install a handler of their own when
a struct keeps none, as wgpu-native's default would end the program at once:
an uncaptured error raises an `IO` error of the call that made it instead, as
every shim brackets its call (`c/callback.c`). Its address is
`lean_X_default_address` (0 on the web, where Dawn's default logs).
-/
def defaultHandled : List String := ["WGPUUncapturedErrorCallback"]

/--
The shim's parameters for a callback of type `c`: its mode's code, if it is
registered with one, and its closure, borrowed, which the shim holds.
-/
def callbackParams (c : Lowered.Callback) : List Param :=
  (if c.style == .callbackMode then [⟨"uint32_t", "callbackMode"⟩] else [])
    ++ [⟨"b_lean_obj_arg", "callback"⟩]

/--
The callback info the shim passes for a callback of type `c`, `callbackInfo`:
its trampoline, the closure, held, as its first userdata, and the family the
objects it gives Lean join, `family`, as its second.
-/
def callbackInfo (c : Lowered.Callback) : Stmt :=
  .decl (c.names.c ++ "Info") "callbackInfo" (some (.init (
    [("nextInChain", .lit "NULL")]
      ++ (if c.style == .callbackMode then
        [("mode", .cast "WGPUCallbackMode" (.name "callbackMode"))] else [])
      ++ [("callback", .name (trampolineName c)),
        ("userdata1", .call "lean_wgpu_closure_hold" [.name "callback"]),
        ("userdata2", .cast "void *" (.name "family"))])))

/--
The family a shim's callback carries (`family`), for the objects it gives Lean
to join: a new one, if the structs `f` takes keep callbacks, which the fill
holds the closures of (`filling` is the one it replaces); otherwise the
family of its object, if any, a reference to it taken for the callback. The
statements before the fill, and after it: on the web, a reference for each
callback with a mode the structs keep and are given, which Dawn calls once,
and its trampoline gives back.
-/
def familyAround (f : Lowered.Function) (receiver : Option Expr) :
    List Stmt × List Stmt :=
  if f.heldInfos.isEmpty then
    match f.callback, receiver with
    | some _, some handle => ([
      .decl "lean_wgpu_family" "family"
        (some (.call "lean_wgpu_family_of" [handle])),
      .expr (.call "lean_wgpu_family_retain" [.name "family"])], [])
    | some _, none => ([.decl "lean_wgpu_family" "family" (some (.lit "0"))],
      [])
    | none, _ => ([], [])
  else
    let once := f.heldInfos.filter (·.hasMode)
    -- For each struct argument that keeps one: if given, its pointer typed,
    -- `held`, and a reference for each such callback it is given.
    let onceOf (a : Arg) : List Stmt := match a.value with
      | .structPointer names _ =>
        let mine := once.filter (·.arg == a.names.c)
        if mine.isEmpty then [] else
        let filled := Expr.name (a.names.c ++ "_struct")
        [.ifElse (.binary "!=" filled (.lit "NULL"))
          ([.decl s!"{names.c} const *" "held" (some filled)]
            ++ mine.map fun h => .ifElse
              -- Its first userdata is the family's ID exactly when the fill
              -- held a closure: not its function, which may be a default.
              (.binary "!=" (.member (.arrow (.name "held") h.member)
                "userdata1") (.lit "NULL"))
              [.expr (.call "lean_wgpu_family_retain" [.name "family"])] [])
          []]
      | _ => []
    ([.decl "lean_wgpu_family" "family"
        (some (.call "lean_wgpu_family_new" [])),
      .decl "lean_wgpu_family" "filling"
        (some (.call "lean_wgpu_family_set_filling" [.name "family"]))],
    [.expr (.call "lean_wgpu_family_set_filling" [.name "filling"])]
      ++ if once.isEmpty then [] else [.ifDefined ["WEBGPU_RAW_DAWN"]
        (f.args.toList.flatMap onceOf) []])

/-! ## Shims -/

/--
The macro a build defines to say it builds against the implementation `impl`:
`WEBGPU_RAW_DAWN` for `dawn`, `WEBGPU_RAW_WGPU_NATIVE` for `wgpu-native`.
-/
def implementationMacro (impl : String) : String :=
  let symbol (c : Char) := if c.isAlphanum then c.toUpper else '_'
  "WEBGPU_RAW_" ++ impl.map symbol

/--
The implementations a build can say it is against, each by defining its macro
(`implementationMacro`): the web build defines `WEBGPU_RAW_DAWN`, and the
native build, against wgpu-native, `WEBGPU_RAW_WGPU_NATIVE`.
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
    !["self", "result", "tables", "callbackMode", "callback", "callbackInfo",
        "saved", "family", "filling"].contains a.names.c
      && !["callbackMode", "callback"].contains a.names.lean
      && !(["_struct", "_bytes", "_targets", "_table"].any
        (a.names.c.endsWith ·))
      && !(["Bytes", "Targets", "Table"].any (a.names.lean.endsWith ·)))
  let shim := functionShimName f
  -- Its callback's trampoline, if it takes one. The function its closure
  -- calls back takes each of its arguments, by its Lean name (`wrapperDecl`).
  let _ ← f.callback.mapM (trampoline objects)
  guard (f.callback.all fun c => c.args.all (·.names.lean != "callback"))
  -- A shim that makes a family gives its reference to its callback, which it
  -- must take; and the closures it holds are each at an ordinal of their own.
  guard (f.heldInfos.isEmpty || f.callback.isSome)
  guard ((f.heldInfos.map (·.ordinal)).eraseDups.length == f.heldInfos.length)
  -- Every argument is borrowed, so a check that fails returns before any
  -- reference is taken, and nothing needs releasing.
  let receiver ← receiverArg objects f.receiver
  let args ← f.args.toList.mapM fun a => argCrossing objects a.names.c a.value
  let checks :=
    f.args.toList.flatMap fun a => argCheck f.names.lean a.names.c a.value
  let call := Expr.call f.names.c (receiver.map (·.2) ++ args.flatMap (·.values)
    ++ (if f.callback.isSome then [.name "callbackInfo"] else []))
  let (familyBefore, familyAfter) :=
    familyAround f ((receiver.head?).map (·.2))
  -- Every call is bracketed, so that the first error a callback in it raised
  -- is its result: any call can run callbacks, those it takes, those of
  -- others it completes (`processEvents`, `Buffer.unmap`), and a device's
  -- own (wgpu-native calls the uncaptured-error callback in the call that
  -- made the error). It costs about 2 ns (`lake exe webgpu-raw-bench`).
  let enter := Stmt.decl "lean_object *" "saved"
    (some (.call "lean_wgpu_callbacks_enter" []))
  let callbacks := (f.callback.map callbackInfo).toList ++ [enter]
  let ret (ok : Expr) : Stmt :=
    .ret (some (.call "lean_wgpu_callbacks_leave" [.name "saved", ok]))
  let body ← match f.result with
    | none => pure [
      .expr call,
      ret (.call "lean_io_result_mk_ok" [.call "lean_box" [.lit "0"]])
    ]
    | some v => do
      let cType ← v.cType
      let boxed ← resultExpr objects v
      -- An object made from another joins its family, if it has one
      -- (`c/family.c`): a device's, as all made from a device are.
      let join := match v, receiver with
        | .object .., (_, handle) :: _ => [.expr (.call "lean_wgpu_family_join"
          [.name "result", .call "lean_wgpu_family_of" [handle]])]
        | _, _ => []
      pure ([.decl cType "result" (some call)] ++ resultCheck f ret v ++ join
        ++ [ret (.call "lean_io_result_mk_ok" [boxed])])
  let params := receiver.map (·.1) ++ args.flatMap (·.params)
    ++ (f.callback.map callbackParams).getD [] ++ tablesParams f
  pure {
    doc    := s!"Lean's `{f.names.lean}`: calls `{f.names.c}`."
    attrs  := ["LEAN_EXPORT"]
    result := "lean_obj_res"
    name   := shim
    params := params
    body   := guardStubs f params
      -- No statement between making a family and the call returns: the checks
      -- that may come first.
      (checks ++ familyBefore ++ args.flatMap (·.before) ++ familyAfter
        ++ callbacks ++ body)
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

/--
The callback types the bound functions take, each once, in the order the
functions first take them.
-/
def boundCallbacks (spec : Lowered.Spec) : List Lowered.Callback :=
  ((boundFunctions spec).filterMap (·.1.callback)).eraseDups

/--
The callback types the bound structs keep (`Value.callbackInfo`), each once,
with whether it has a mode, in the order the structs first keep them: those
whose trampoline can be made, and that no bound function takes, whose
trampoline, of the same name, is another kind. The test driver checks none of
the spec's is left out.
-/
def heldCallbacks (spec : Lowered.Spec) : List (Lowered.Callback × Bool) :=
  let held := (boundStructs spec.structs.toList).flatMap fun s =>
    s.members.toList.filterMap fun m => match m.value with
      | .callbackInfo names hasMode _ => some (names, hasMode)
      | _                            => none
  let taken := (boundCallbacks spec).map (·.names)
  held.eraseDups.filterMap fun (names, hasMode) => do
    let c ← spec.callbacks.find? (·.names == names)
    guard (!taken.contains names)
    let _ ← trampoline spec.objects.toList c (held := true)
    pure (c, hasMode)

/--
The source: the helpers the shims use, the trampolines of the callbacks they
take, those of the callbacks the bound structs keep with their addresses,
then the shims.
-/
def functionsSource (spec : Lowered.Spec) : List Decl :=
  let bound := boundFunctions spec
  let callbacks := boundCallbacks spec
  let held := heldCallbacks spec
  [.include "stdint.h", .includeLocal "objects.h"]
    ++ (if bound.any (takesStruct ·.1) then [.includeLocal "reloc.h"] else [])
    ++ (if bound.isEmpty && held.isEmpty then []
      else [.includeLocal "callback.h"])
    -- Families, for an object made from another, and for any callback.
    ++ (if held.isEmpty && !bound.any (fun (f, _) => f.callback.isSome
        || f.receiver.isSome && f.result.any (· matches .object ..))
      then [] else [.includeLocal "family.h"])
    ++ helperMacro
    ++ helpers.filterMap (fun (needs, d) =>
      if bound.any (needs ·.1) then some d else none)
    ++ callbacks.filterMap (fun c =>
      (trampoline spec.objects.toList c).map .function)
    ++ held.flatMap (fun (c, _) =>
      ((trampoline spec.objects.toList c (held := true)).map fun t =>
        [.function t, .function (addressFunction c)]).getD [])
    ++ bound.map fun (_, shim) => .function shim

/-- The function shims' source, `functions.c`. -/
def functionsFiles (p : Provenance) (spec : Lowered.Spec) :
    List (String × String) :=
  [("functions.c", cFile p (functionsSource spec))]

end WebGPUGen.Emit.C
