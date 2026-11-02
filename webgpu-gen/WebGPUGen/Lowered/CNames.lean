import WebGPUGen.Common

/-!
# C names

The names `webgpu.h` gives each part of the spec, as upstream's generator
writes them (`gen/utils.go`, `gen/gen.go` and `gen/cheader.tmpl` in
webgpu-headers).

Upstream can also prefix a name with its namespace, but only for extension
namespaces, and only when asked to. For `webgpu.h` every prefix is empty, so
prefixes, and the spec's `namespace` fields, are left out here.

Only the names of spec parts are here. Names upstream derives in other ways
come later, with the parts that need them: array counts (`entryCount`),
initialiser macros (`WGPU_..._INIT`), and the `AddRef`/`Release` methods
upstream adds to every object.
-/

namespace WebGPUGen.Lowered
open WebGPUGen.Common

/-! ## Case conversion

Character by character, as upstream does. Spec names are ASCII, so Lean's
`Char.toUpper` agrees with Go's `unicode.ToUpper` on them. -/

/--
Write `cs` with the character after each underscore in upper case and the
underscore dropped; `upper` says whether the first character is upper case too.
Like upstream, the character after an underscore is upper-cased even if it is
another underscore, which is then kept.
-/
def joinWords : Bool → List Char → List Char
  | true,  c :: cs   => c.toUpper :: joinWords false cs
  | false, '_' :: cs => joinWords true cs
  | false, c :: cs   => c :: joinWords false cs
  | _,     []        => []

/--
Upstream's `PascalCase`: words joined, each starting in upper case. The rest of
each word is kept as written, so `BC1_RGBA_unorm` is `BC1RGBAUnorm`.
-/
def pascalCase (s : String) : String := String.ofList (joinWords true s.toList)

/--
Upstream's `CamelCase`: the same, but the first word kept as written, so
`next_in_chain` is `nextInChain`.
-/
def camelCase (s : String) : String := String.ofList (joinWords false s.toList)

/-- Upstream's `ConstantCase`: all in upper case, underscores kept. -/
def constantCase (s : String) : String := s.toUpper

/-! ## Names in `webgpu.h` -/

/-- A type: `adapter_info` is `WGPUAdapterInfo`. -/
def typeName (n : Name) : String := "WGPU" ++ pascalCase n.text

/-- A callback's function pointer type: `WGPURequestDeviceCallback`. -/
def callbackTypeName (n : Name) : String := typeName n ++ "Callback"

/--
A callback's info struct, which carries the callback and its mode:
`WGPURequestDeviceCallbackInfo`.
-/
def callbackInfoName (n : Name) : String := typeName n ++ "CallbackInfo"

/-- An enum entry or flag: `WGPUBufferUsage_MapRead`. -/
def entryName (type entry : Name) : String := typeName type ++ "_" ++ pascalCase entry.text

/-- A constant: `whole_size` is `WGPU_WHOLE_SIZE`. -/
def constantName (n : Name) : String := "WGPU_" ++ constantCase n.text

/-- A struct member or argument: `next_in_chain` is `nextInChain`. -/
def memberName (n : Name) : String := camelCase n.text

/-- A free function: `create_instance` is `wgpuCreateInstance`. -/
def functionName (f : Name) : String := "wgpu" ++ pascalCase f.text

/-- A method: `wgpuAdapterRequestDevice`. -/
def methodName (object method : Name) : String :=
  "wgpu" ++ pascalCase object.text ++ pascalCase method.text

/-- A free function's pointer type: `WGPUProcCreateInstance`. -/
def functionProcName (f : Name) : String := "WGPUProc" ++ pascalCase f.text

/-- A method's pointer type: `WGPUProcAdapterRequestDevice`. -/
def methodProcName (object method : Name) : String :=
  "WGPUProc" ++ pascalCase object.text ++ pascalCase method.text

/-! ## The bindings' own names -/

/--
The C function that starts the bindings: it registers the object types' classes.
The Lean side runs it, with `builtin_initialize`, when a program starts.
-/
def objectsInitName : String := "lean_wgpu_objects_init"

end WebGPUGen.Lowered
