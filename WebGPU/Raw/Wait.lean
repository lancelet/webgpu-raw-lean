module

public import WebGPU.Raw.Functions

/-!
# Waiting on futures

`Instance.waitAny`, written by hand (`c/wait.c`): its futures are an array C
reads and writes, each future in, and whether it completed out, which the
generator does not pass.

wgpu-native leaves `wgpuInstanceWaitAny` unimplemented: built against it,
`waitAny` raises an `IO` error, as the generated functions it leaves
unimplemented do.
-/

@[expose] public section

namespace WebGPU.Raw

/--
The shim behind `Instance.waitAny`: the status's code, and a byte for each
future, 1 if it completed.
-/
@[extern "lean_wgpuInstanceWaitAny"]
opaque Internal.Instance.waitAny
    (self      : @& Instance)
    (futures   : @& Array UInt64)
    (timeoutNS : UInt64) :
    IO (UInt32 × ByteArray)

/--
Wait until any of `futures` has completed, or `timeoutNS` nanoseconds have
passed: the status, and of each future whether it has completed. Of those
that have completed, the callbacks not yet run (registered `waitAnyOnly`, or
`allowProcessEvents` before a `processEvents`) run in the call; the first
error any raises is the call's. A nonzero `timeoutNS` needs the instance
feature `timedWaitAny`, which no build here has (the web's would need
Asyncify or JSPI; wgpu-native aborts on it): without it, the status is
`.error`.
-/
def Instance.waitAny (self : Instance) (futures : Array Future)
    (timeoutNS : UInt64 := 0) :
    IO (Except UInt32 WaitStatus × Array Bool) := do
  let (status, completed) ←
    Internal.Instance.waitAny self (futures.map (·.id)) timeoutNS
  pure (CEnum.decode status, completed.data.map (· != 0))

end WebGPU.Raw
