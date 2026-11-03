import WebGPUGen.Emit.C.Functions
import WebGPUGen.Lowered.CFields
import WebGPUGen.Lowered.BoundStructs

/-!
# Layout checks

`layouts.c`: assertions, checked by the C compiler, that every bound struct of
`webgpu.h` is laid out as the layout model (`CLayout`) says, on the target it is
compiled for. Each field's offset, and each struct's size and alignment, is
compared with what the model gives for 64-bit targets and for wasm32; so are
the scalars the model assumes, such as an enum's 4 bytes. As every scalar is
at its field's offset (`flatten_struct`), this checks where packing writes
each, however deeply nested. A wrong layout fails the build. On the web, the
checks are of emdawnwebgpu's `webgpu.h`, which is the one linked there.

    // WGPUBufferDescriptor
    FIELD(WGPUBufferDescriptor, nextInChain,      0,  0);
    FIELD(WGPUBufferDescriptor, label,            8,  4);
    ...
    STRUCT(WGPUBufferDescriptor, 48, 40, 8, 8);
-/

namespace WebGPUGen.Emit.C
open WebGPUGen.Lowered WebGPUGen.CLayout

/--
The macros the checks use, each a `_Static_assert`; short, as this file has
nothing else.
-/
def layoutMacros : List Decl := [
  .define "BY_WIDTH" ["bits64", "bits32"]
    ["(sizeof(void *) == 8 ? (bits64) : (bits32))"],
  .define "FIELD" ["T", "f", "bits64", "bits32"] [
    "_Static_assert(offsetof(T, f) == BY_WIDTH(bits64, bits32),",
    "    #T \".\" #f \" is where the layout model puts it\")"
  ],
  .define "STRUCT" ["T", "size64", "size32", "align64", "align32"] [
    "_Static_assert(sizeof(T) == BY_WIDTH(size64, size32),",
    "    #T \" has the size the layout model gives it\");",
    "_Static_assert(_Alignof(T) == BY_WIDTH(align64, align32),",
    "    #T \" has the alignment the layout model gives it\")"
  ],
  .define "SCALAR" ["T", "bytes"] [
    "_Static_assert(sizeof(T) == (bytes) && _Alignof(T) == (bytes),",
    "    #T \" has the size and alignment the layout model gives it\")"
  ]
]

/-- What the model assumes of the target: its pointers, `size_t` and scalars. -/
def targetChecks : List Decl := [
  .comment "The target: pointers and size_t of 8 bytes or 4, and every scalar \
    aligned to its size.",
  .invocations "_Static_assert" [
    ["sizeof(void *) == 8 || sizeof(void *) == 4",
      "\"pointer size\""],
    ["_Alignof(void *) == sizeof(void *)", "\"pointer alignment\""],
    ["sizeof(size_t) == sizeof(void *)", "\"size_t size\""],
    ["_Alignof(size_t) == sizeof(size_t)", "\"size_t alignment\""]
  ],
  .invocations "SCALAR" [
    ["uint16_t", "2"],
    ["uint32_t", "4"],
    ["uint64_t", "8"],
    ["float", "4"],
    ["double", "8"],
    ["WGPUBool", "4"],
    ["WGPUFlags", "8"]
  ]
]

/-- One struct's checks: each field's offset, then its size and alignment. -/
def structChecks (name : String) (fields : List (String × CType)) : List Decl :=
  let types := fields.map (·.2)
  let at64 := offsets .bits64 types
  let at32 := offsets .bits32 types
  let t := CType.struct types
  [
    .comment name,
    .invocations "FIELD" ((fields.zip (at64.zip at32)).map
      fun ((field, _), (o64, o32)) =>
        [name, field, toString o64, toString o32]),
    .invocations "STRUCT" [[
      name,
      toString (t.size .bits64),
      toString (t.size .bits32),
      toString (t.align .bits64),
      toString (t.align .bits32)
    ]]
  ]

/-- The checks of every scalar type of the spec: each enum and flag type. -/
def scalarChecks (spec : Lowered.Spec) : List Decl :=
  let enums := spec.enums.toList.map fun e => [e.names.c, "4"]
  let flags := spec.bitflags.toList.map fun b => [b.names.c, "8"]
  [
    .comment "Each enum, of 4 bytes, and each flag type, of 8.",
    .invocations "SCALAR" (enums ++ flags)
  ]

/-- The source: the macros, then the checks of the target, types and structs. -/
def layoutsSource (spec : Lowered.Spec) : List Decl :=
  let structs := spec.structs.toList
  let bound := boundStructs structs
  [.include "stddef.h", .include "stdint.h", .include "webgpu/webgpu.h"]
    ++ layoutMacros ++ targetChecks ++ scalarChecks spec
    ++ structChecks "WGPUStringView" stringViewFields
    ++ structChecks "WGPUChainedStruct" chainedStructFields
    ++ bound.flatMap fun s =>
      match s.cFields structs with
      | some fields => structChecks s.names.c fields
      | none        => []

/-- The layout checks' source, `layouts.c`. -/
def layoutsFiles (p : Provenance) (spec : Lowered.Spec) :
    List (String × String) :=
  [("layouts.c", cFile p (layoutsSource spec))]

end WebGPUGen.Emit.C
