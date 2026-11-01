import WebGPUGen.Decode
import WebGPUGen.Spec

/-!
# Checks for decoder tests

Scaffolding shared by the decoder tests; not tests themselves. Each check parses
YAML text and decodes it, so a test reads as "this YAML gives this value" or
"this YAML fails with this message".
-/

namespace WebGPUGenTest
open WebGPUGen.Yaml WebGPUGen.Decode

/-- Parse `input` and decode it with `decoder`. Errors become their message. -/
def decodeText {α} (decoder : Node → Decode α) (input : String) : Except String α :=
  match parse input with
  | .error e => .error s!"parse error: {e}"
  | .ok node => ((decoder node).run).mapError toString

/-- Does `input` decode to exactly `expected`? -/
def decodesTo {α} [BEq α] (decoder : Node → Decode α) (input : String) (expected : α) : Bool :=
  match decodeText decoder input with
  | .ok actual => actual == expected
  | .error _ => false

/-- Does decoding `input` fail with exactly `message` (path included)? -/
def decodeFails {α} (decoder : Node → Decode α) (input : String) (message : String) : Bool :=
  match decodeText decoder input with
  | .ok _ => false
  | .error actual => actual == message

/-- Write spec names in expected values as plain strings. Tests only: the
decoder validates names, this does not. -/
instance : Coe String WebGPUGen.Spec.Name := ⟨fun text => { text }⟩

end WebGPUGenTest
