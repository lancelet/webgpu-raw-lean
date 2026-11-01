import WebGPUGen.Decode
import WebGPUGen.Parsed

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

open WebGPUGen.Common in
/-- Write spec names in expected values as plain strings. The name is checked
when the test runs: an invalid one prints a panic message and becomes the
default name, so the test then fails with a mismatch. -/
instance : Coe String Name where
  coe text := if h : isName text then ⟨text, h⟩ else panic! s!"invalid name {text.quote}"

open WebGPUGen.Common in
instance : Inhabited Paragraph := ⟨⟨"x", by decide⟩⟩

open WebGPUGen.Common in
/-- Write single-paragraph docs as plain strings, checked in the same way. -/
instance : Coe String Paragraph where
  coe text :=
    if h : isSingleParagraph text then ⟨text, h⟩
    else panic! s!"not a single paragraph: {text.quote}"

end WebGPUGenTest
