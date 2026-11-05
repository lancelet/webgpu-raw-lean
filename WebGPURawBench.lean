import WebGPU.Raw
import WebGPU.Raw.Encoders

/-!
# The benchmark

How long the bindings take to pass a struct to C, against C filling the same
struct on the stack: for a buffer descriptor (a label and scalars), an instance
descriptor (an array of enums, and limits behind a pointer), and a bind group
layout descriptor (an array of four structs, each with structs nested by
value). For each:

- C: filling it on the stack, the baseline;
- encode: encoding the Lean value (`toBytes`);
- targets: encoding it, and making its targets (`toTargets`), blocks included;
- marshal: encoding it, making its targets, and C filling in its pointers:
  all a shim does but call WebGPU.

The Lean values are made before the timing, 1024 of them, used in turn: making
one is the caller's, as making C's struct on the stack is free. Each figure is
nanoseconds an iteration of its loop, the fastest of five runs, with the cost
of the loop itself, which is shown. Encode is the top-level struct alone: its
arrays and the structs it points to are encoded as its targets are made.

Run it with `lake exe webgpu-raw-bench`, after `lake build -R` (not the checked
build); it takes the number of iterations, a million by default.
-/

open WebGPU.Raw WebGPU.Raw.Reloc

namespace WebGPURawBench

@[extern "lean_wgpu_bench_c_loop"]
opaque cLoop (n : USize) : IO UInt64

@[extern "lean_wgpu_bench_c_buffer"]
opaque cBuffer (n : USize) : IO UInt64

@[extern "lean_wgpu_bench_c_instance"]
opaque cInstance (n : USize) : IO UInt64

@[extern "lean_wgpu_bench_c_layout"]
opaque cLayout (n : USize) : IO UInt64

/-- `n` calls' brackets, as every shim makes around its call, with nothing in
them. -/
@[extern "lean_wgpu_bench_bracket"]
opaque cBracket (n : USize) : IO UInt64

/-- How many times each loop runs: the fastest run is the figure. -/
def runs : Nat := 5

/--
The fewest nanoseconds C takes, of `runs` runs, as `run n` fills `n` structs.
-/
@[noinline]
def timeC (run : USize → IO UInt64) (n : Nat) : IO UInt64 := do
  let mut best : UInt64 := UInt64.ofNat (2 ^ 63)
  for _ in [0:runs] do
    let start ← IO.monoNanosNow
    let done ← run n.toUSize
    let stop ← IO.monoNanosNow
    if done != n.toUInt64 then IO.println ""
    best := min best (stop - start).toUInt64
  return best

/-- Fill in an encoded argument as a shim does; its first word. -/
@[extern "lean_wgpu_bench_fill"]
opaque fill (bytes : @& ByteArray) (tables : @& Array ByteArray) (table : USize)
  (targets : @& Array Target) : UInt64

/-- A buffer descriptor, its size `i`. -/
def buffer (i : Nat) : BufferDescriptor := {
  label            := "vertices"
  usage            := ⟨0x28⟩
  size             := i.toUInt64
  mappedAtCreation := true
}

/-- An instance descriptor: two features, and limits, its count `i`. -/
def instance' (i : Nat) : InstanceDescriptor := {
  requiredFeatures := #[.timedWaitAny, .shaderSourceSPIRV]
  requiredLimits   := some { timedWaitAnyMaxCount := i.toUInt64 }
}

/-- A bind group layout descriptor: four entries, from binding `i`. -/
def layout (i : Nat) : BindGroupLayoutDescriptor := {
  label   := "layout"
  entries := (List.range 4).toArray.map fun k => {
    binding    := (i + k).toUInt32
    visibility := .fragment
  }
}

/--
The fewest nanoseconds `body` takes over `n` iterations, of `runs` runs, and
what it sums to.
-/
@[inline]
def time (n : Nat) (body : Nat → UInt64) : IO (UInt64 × UInt64) := do
  let mut best : UInt64 := UInt64.ofNat (2 ^ 63)
  let mut sum : UInt64 := 0
  for _ in [0:runs] do
    let start ← IO.monoNanosNow
    for i in [0:n] do
      sum := sum + body i
    let stop ← IO.monoNanosNow
    best := min best (stop - start).toUInt64
  return (best, sum)

/-- How many Lean values the loops use in turn. -/
def pool : Nat := 1024

/--
The Lean side's loops, for structs made by `make`: the loop alone, encoding,
and marshalling. Inlined, so each is for its struct, as a shim's call is.
-/
@[inline]
def measure {T : Type} [CStruct T] (n : Nat) (make : Nat → T) :
    IO (UInt64 × UInt64 × UInt64 × UInt64) := do
  let ds := (List.range pool).toArray.map make
  -- The `i`th value, in turn: never the default, as `i % pool` is in range.
  let first := make 0
  let nth (i : Nat) : T := ds.getD (i % pool) first
  let (loop, s1) ← time n fun i => (i % pool).toUInt64
  let (encode, s2) ← time n fun i => (CStruct.toBytes (nth i)).size.toUInt64
  let (targets, s3) ← time n fun i =>
    let d := nth i
    (CStruct.toBytes d).size.toUInt64 + (CStruct.toTargets d).size.toUInt64
  let (marshal, s4) ← time n fun i =>
    let d := nth i
    fill (CStruct.toBytes d) currentTables (CStruct.tableIndex T).toUSize
      (CStruct.toTargets d)
  -- So that no loop is left out as unused.
  if s1 + s2 + s3 + s4 == 42 then IO.println ""
  return (loop, encode, targets, marshal)

/-- Nanoseconds an iteration, to a tenth. -/
def perStruct (n : Nat) (total : UInt64) : String :=
  let tenths := total.toNat * 10 / n
  s!"{tenths / 10}.{tenths % 10}"

/-- A row of the table: the struct, then each measure, right-aligned. -/
def row (cells : List String) : String :=
  let widths := [24, 8, 8, 8, 8, 8]
  String.intercalate " " ((cells.zip widths).map fun (c, w) =>
    String.ofList (List.replicate (w - min w c.length) ' ') ++ c)

end WebGPURawBench

open WebGPURawBench in
def main (args : List String) : IO Unit := do
  let n := (args.head? >>= String.toNat?).getD 1000000
  let cOverhead ← timeC cLoop n
  IO.println s!"ns an iteration, the fastest of {runs} runs of {n}; an empty \
    loop takes {perStruct n cOverhead} in C, and in Lean the last column"
  IO.println (row ["", "C", "encode", "targets", "marshal", "loop"])
  let report (name : String) (c : UInt64)
      (lean : UInt64 × UInt64 × UInt64 × UInt64) :=
    let (loop, encode, targets, marshal) := lean
    IO.println (row [name, perStruct n c, perStruct n encode,
      perStruct n targets, perStruct n marshal, perStruct n loop])
  report "buffer descriptor" (← timeC cBuffer n) (← measure n buffer)
  report "instance descriptor" (← timeC cInstance n) (← measure n instance')
  report "bind group layout" (← timeC cLayout n) (← measure n layout)
  IO.println s!"bracketing a call, as every shim does: \
    {perStruct n (← timeC cBracket n)} ns, the loop's cost included"
