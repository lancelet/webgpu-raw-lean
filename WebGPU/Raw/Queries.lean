module

public import WebGPU.Raw.Functions

/-!
# What an adapter, a device or the instance supports

Their limits, features and information, written by hand (`c/queries.c`):
structs C fills, given Lean as words and strings; those whose members C
allocates are freed in the call. Each is given with its chain empty, so
wgpu-native's own limits (`WGPUNativeLimits`), chained to them, are not
read. Each status, beside what it is of, is a success unless C refused a
chain, which these give none of. A limits struct is made of its words by its
`ofWords`, which the generator emits from the same members as the C that
gives them (`lean_wgpu_Limits_words`). An enum C gives keeps a code no value
has (`CEnum.decode`).

wgpu-native leaves the instance's features, its WGSL language features and
a device's adapter information unimplemented: built against it, each raises
an `IO` error, as the generated functions it leaves unimplemented do.
-/

@[expose] public section

namespace WebGPU.Raw

/-! ### Limits -/

/-- The shim behind `Adapter.getLimits`: the status's code, and the words. -/
@[extern "lean_wgpu_adapter_get_limits"]
opaque Internal.Adapter.getLimits (self : @& Adapter) :
    IO (UInt32 × Array UInt64)

/-- The adapter's limits, and the status of getting them. -/
def Adapter.getLimits (self : Adapter) :
    IO (Except UInt32 Status × Limits) := do
  let (status, words) ← Internal.Adapter.getLimits self
  pure (CEnum.decode status, Limits.ofWords words)

/-- The shim behind `Device.getLimits`: the status's code, and the words. -/
@[extern "lean_wgpu_device_get_limits"]
opaque Internal.Device.getLimits (self : @& Device) :
    IO (UInt32 × Array UInt64)

/-- The device's limits, and the status of getting them. -/
def Device.getLimits (self : Device) :
    IO (Except UInt32 Status × Limits) := do
  let (status, words) ← Internal.Device.getLimits self
  pure (CEnum.decode status, Limits.ofWords words)

/-- The shim behind `getInstanceLimits`: the status's code, and the words. -/
@[extern "lean_wgpu_get_instance_limits"]
opaque Internal.getInstanceLimits : Unit → IO (UInt32 × Array UInt64)

/-- The limits an instance can be created with, and the status. -/
def getInstanceLimits : IO (Except UInt32 Status × InstanceLimits) := do
  let (status, words) ← Internal.getInstanceLimits ()
  pure (CEnum.decode status, InstanceLimits.ofWords words)

/-! ### Features -/

/-- The shim behind `Adapter.getFeatures`: the codes. -/
@[extern "lean_wgpu_adapter_get_features"]
opaque Internal.Adapter.getFeatures (self : @& Adapter) : IO (Array UInt32)

/-- The features the adapter supports. -/
def Adapter.getFeatures (self : Adapter) :
    IO (Array (Except UInt32 FeatureName)) :=
  (·.map CEnum.decode) <$> Internal.Adapter.getFeatures self

/-- The shim behind `Device.getFeatures`: the codes. -/
@[extern "lean_wgpu_device_get_features"]
opaque Internal.Device.getFeatures (self : @& Device) : IO (Array UInt32)

/-- The features the device was created with. -/
def Device.getFeatures (self : Device) :
    IO (Array (Except UInt32 FeatureName)) :=
  (·.map CEnum.decode) <$> Internal.Device.getFeatures self

/-- The shim behind `getInstanceFeatures`: the codes. -/
@[extern "lean_wgpu_get_instance_features"]
opaque Internal.getInstanceFeatures : Unit → IO (Array UInt32)

/-- The features an instance can be created with. -/
def getInstanceFeatures : IO (Array (Except UInt32 InstanceFeatureName)) :=
  (·.map CEnum.decode) <$> Internal.getInstanceFeatures ()

/-- The shim behind `Instance.getWGSLLanguageFeatures`: the codes. -/
@[extern "lean_wgpu_instance_get_wgsl_language_features"]
opaque Internal.Instance.getWGSLLanguageFeatures (self : @& Instance) :
    IO (Array UInt32)

/-- The WGSL language features the instance supports. -/
def Instance.getWGSLLanguageFeatures (self : Instance) :
    IO (Array (Except UInt32 WGSLLanguageFeatureName)) :=
  (·.map CEnum.decode) <$> Internal.Instance.getWGSLLanguageFeatures self

/-! ### An adapter's information -/

/-- What an adapter says of itself. -/
structure AdapterInfo where
  vendor          : String
  architecture    : String
  device          : String
  description     : String
  backendType     : Except UInt32 BackendType
  adapterType     : Except UInt32 AdapterType
  vendorID        : UInt32
  deviceID        : UInt32
  subgroupMinSize : UInt32
  subgroupMaxSize : UInt32

/--
An `AdapterInfo` from its strings and words as C gives them, in order
(`c/queries.c`).
-/
def AdapterInfo.ofParts (strings : Array String) (words : Array UInt32) :
    AdapterInfo where
  vendor          := strings.getD 0 ""
  architecture    := strings.getD 1 ""
  device          := strings.getD 2 ""
  description     := strings.getD 3 ""
  backendType     := CEnum.decode (words.getD 0 0)
  adapterType     := CEnum.decode (words.getD 1 0)
  vendorID        := words.getD 2 0
  deviceID        := words.getD 3 0
  subgroupMinSize := words.getD 4 0
  subgroupMaxSize := words.getD 5 0

/-- The shim behind `Adapter.getInfo`: the status's code, strings and words. -/
@[extern "lean_wgpu_adapter_get_info"]
opaque Internal.Adapter.getInfo (self : @& Adapter) :
    IO (UInt32 × Array String × Array UInt32)

/-- What the adapter says of itself, and the status of asking. -/
def Adapter.getInfo (self : Adapter) :
    IO (Except UInt32 Status × AdapterInfo) := do
  let (status, strings, words) ← Internal.Adapter.getInfo self
  pure (CEnum.decode status, AdapterInfo.ofParts strings words)

/-- The shim behind `Device.getAdapterInfo`, as `Adapter.getInfo`'s. -/
@[extern "lean_wgpu_device_get_adapter_info"]
opaque Internal.Device.getAdapterInfo (self : @& Device) :
    IO (UInt32 × Array String × Array UInt32)

/-- What the device's adapter says of itself, and the status of asking. -/
def Device.getAdapterInfo (self : Device) :
    IO (Except UInt32 Status × AdapterInfo) := do
  let (status, strings, words) ← Internal.Device.getAdapterInfo self
  pure (CEnum.decode status, AdapterInfo.ofParts strings words)

end WebGPU.Raw
