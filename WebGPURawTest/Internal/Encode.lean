import WebGPU.Raw
import WebGPU.Raw.Encoders

/-!
# Tests for encoding

The generated encoders (`WebGPU.Raw.Encoders`), compared with structs C fills
in, at run time, natively and on the web: a buffer descriptor, its label full
and empty; a depth-stencil state, with enums, an optional bool, nested structs,
a negative integer and floats; a WGSL source, a chained struct; and instance
limits, a `size_t` at its largest. Their proofs are checked as the generated
module builds; `EncodeAttrs` checks each is `@[noinline]`.
-/

namespace WebGPURawTest.Internal.Encode
open WebGPU.Raw WebGPU.Raw.Encode

/-! ## Values as C holds them -/

#guard wgpuBool true == 1
#guard wgpuBool false == 0
#guard viewLength64 none == 0xFFFFFFFFFFFFFFFF
#guard viewLength64 (some "abc") == 3
#guard viewLength32 none == 0xFFFFFFFF
#guard viewLength32 (some "é") == 2
#guard nanOr none == 0x7FC00000
#guard nanOr (some 1.5) == (1.5 : Float32).toBits
#guard sizeFits 0xFFFFFFFF
#guard !sizeFits 0x100000000
#guard sizeFits 0xFFFFFFFFFFFFFFFF
#guard size32 0xFFFFFFFFFFFFFFFF == 0xFFFFFFFF
#guard size32 0x1234 == 0x1234

/-! ## Structs, against C -/

/--
A buffer descriptor C fills in: no chain, a label of `labelLength` bytes at
NULL, these fields, and its padding zero.
-/
@[extern "lean_wgpu_test_buffer_descriptor"]
opaque cBufferDescriptor (usage size : UInt64) (mappedAtCreation : UInt32)
  (labelLength : USize) : ByteArray

/-- A depth-stencil state C fills in: see `descriptors.c`. -/
@[extern "lean_wgpu_test_depth_stencil_state"]
opaque cDepthStencilState : Unit → ByteArray

/-- A WGSL source C fills in, with code of `codeLength` bytes at NULL. -/
@[extern "lean_wgpu_test_shader_source_wgsl"]
opaque cShaderSourceWGSL (codeLength : USize) : ByteArray

/--
The words C's reader gives of limits encoded as `bytes` (`descriptors.c`), as
`Limits.ofWords` takes them.
-/
@[extern "lean_wgpu_test_limits_words"]
opaque cLimitsWords (bytes : @& ByteArray) : Array UInt64

/--
Limits of a distinct value in each member, `k + 1` for the `k`th, as
`Limits.ofWords` takes them: encoded (its layout proved), and read by C's
reader of each member by name, they are the same words, in the same order.
So the generated reader and `ofWords` agree on every member.
-/
def limitsWordsAgree : Bool :=
  let words := (Array.range 32).map (·.toUInt64 + 1)
  cLimitsWords (Limits.toBytes (Limits.ofWords words)) == words

/-- Instance limits C fills in, with this count. -/
@[extern "lean_wgpu_test_instance_limits"]
opaque cInstanceLimits (timedWaitAnyMaxCount : USize) : ByteArray

/--
A device descriptor C lays out: of defaults, with both callbacks if
`withCallbacks`, else none; see `descriptors.c`.
-/
@[extern "lean_wgpu_test_device_descriptor"]
opaque cDeviceDescriptor (withCallbacks : Bool) : ByteArray

/-- A device descriptor with both callbacks, which do nothing. -/
def withCallbacks : DeviceDescriptor := {
  deviceLostCallbackInfo      := some { callback := fun _ _ => pure () }
  uncapturedErrorCallbackInfo := some { callback := fun _ _ => pure () }
}

/-- A buffer descriptor's values for the comparison with C. -/
def descriptor : BufferDescriptor := {
  label            := "vertices"
  usage            := ⟨0x28⟩
  size             := 0x10000
  mappedAtCreation := true
}

/-- The same as C's in `descriptors.c`. -/
def depthStencil : DepthStencilState := {
  format              := .depth24PlusStencil8
  depthWriteEnabled   := .true
  depthCompare        := .less
  stencilFront        := {
    compare     := .always
    failOp      := .keep
    depthFailOp := .replace
    passOp      := .incrementClamp
  }
  stencilBack         := {
    compare     := .never
    failOp      := .zero
    depthFailOp := .invert
    passOp      := .decrementWrap
  }
  stencilReadMask     := 0xFF
  stencilWriteMask    := 0x0F
  depthBias           := -3
  depthBiasSlopeScale := 1.5
  depthBiasClamp      := -0.25
}

/-- Whether two byte arrays hold the same bytes. -/
def same (a b : ByteArray) : Bool :=
  a.data.toList == b.data.toList

/-- Each check: what it is, and whether it held. -/
@[noinline]
def checks : List (String × Bool) := [
  ("limits read by C, member by member, as ofWords takes them",
    limitsWordsAgree),
  ("a buffer descriptor encodes as C lays it out",
    same (BufferDescriptor.toBytes descriptor)
      (cBufferDescriptor 0x28 0x10000 1 8)),
  ("a buffer descriptor's empty label encodes as C's, of length 0",
    same (BufferDescriptor.toBytes { descriptor with label := "" })
      (cBufferDescriptor 0x28 0x10000 1 0)),
  ("a depth-stencil state encodes as C lays it out",
    same (DepthStencilState.toBytes depthStencil) (cDepthStencilState ())),
  ("a WGSL source encodes as C lays it out, with its chain's sType",
    same (ShaderSourceWGSL.toBytes { code := "fn main() {}" })
      (cShaderSourceWGSL 12)),
  ("instance limits encode as C lays them out",
    same (InstanceLimits.toBytes { timedWaitAnyMaxCount := 64 })
      (cInstanceLimits 64)),
  ("instance limits' largest count encodes as C's SIZE_MAX",
    same (InstanceLimits.toBytes { timedWaitAnyMaxCount := UInt64.ofNat 0 - 1 })
      (cInstanceLimits (USize.ofNat 0 - 1))),
  ("a count past 32 bits fits only on 64-bit targets",
    InstanceLimits.sizesFit { timedWaitAnyMaxCount := 0x100000000 }
      == (System.Platform.numBits == 64)),
  ("a device descriptor encodes as C lays it out, its callbacks none",
    same (DeviceDescriptor.toBytes {}) (cDeviceDescriptor false)),
  ("and with both callbacks, each its trampoline and its ordinal",
    same (DeviceDescriptor.toBytes withCallbacks) (cDeviceDescriptor true)),
  -- A regression test: `sizesFit` missed a `size_t` behind a pointer.
  ("and so does one behind a pointer",
    InstanceDescriptor.sizesFit
      { requiredLimits := some { timedWaitAnyMaxCount := 0x100000000 } }
      == (System.Platform.numBits == 64))
]

end WebGPURawTest.Internal.Encode
