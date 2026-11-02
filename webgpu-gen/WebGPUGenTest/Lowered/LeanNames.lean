import Lean
import WebGPUGen.Lowered.LeanNames
import WebGPUGenTest.Check

/-!
# Tests for Lean names

Tables pairing spec names with their Lean names, and two checks that ask Lean
itself: that `leanKeywords` is exactly Lean's keywords, and that the names
generated here parse as single identifiers.
-/

namespace WebGPUGenTest.Lowered.LeanNames
open WebGPUGen.Common WebGPUGen.Lowered

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- Does `f` turn each input into the output paired with it? -/
def converts {α} (f : α → String) (cases : List (α × String)) : Bool :=
  cases.all fun (input, expected) => f input == expected

open Lean in
/-- The identifier-like tokens (keywords) of an environment's syntax. -/
def keywords (env : Environment) : List String :=
  let tokens := (Parser.getTokenTable env).values.toList
  tokens.filter fun t =>
    !t.isEmpty && t.front.isAlpha && t.all fun c => c.isAlphanum || c == '_'

open Lean in
/-- Does `text` parse as a single identifier? -/
def isIdent (env : Environment) (text : String) : Bool :=
  match Parser.runParserCategory env `term text with
  | .ok stx => stx.isIdent
  | .error _ => false

/-! ## Names -/

-- Types: upstream's PascalCase.
#guard converts leanTypeName [
  ("texture_format", "TextureFormat"),
  ("buffer_descriptor", "BufferDescriptor"),
  ("request_adapter_WebXR_options", "RequestAdapterWebXROptions")
]

-- Everything else: the first word in lower case, then camelCase, acronyms kept.
#guard converts leanName [
  ("create_buffer", "createBuffer"),
  ("mapped_at_creation", "mappedAtCreation"),
  ("r8_unorm", "r8Unorm"),
  ("RGBA8_unorm", "rgba8Unorm"),
  ("BC1_RGBA_unorm", "bc1RGBAUnorm"),
  ("ETC2_RGB8A1_unorm", "etc2RGB8A1Unorm"),
  ("CCW", "ccw"),
  ("D3D12", "d3d12"),
  ("WGSL_language_feature_name", "wgslLanguageFeatureName")
]

-- A first word upstream writes in mixed case keeps its later capitals: only an
-- all-capitals first word is an acronym to lower. (A regression test: these
-- were `opengl`, `opengles`, `workgroupcountx` and `webgpu`.)
#guard converts leanName [
  ("openGL", "openGL"),
  ("openGLES", "openGLES"),
  ("workgroupCountX", "workgroupCountX"),
  ("WebGPU", "webGPU")
]

-- Names Lean cannot read as identifiers are quoted: a leading digit, or a
-- keyword. All four keywords here are real spec names.
#guard converts leanName [
  ("2D", "«2d»"),
  ("2D_array", "«2dArray»"),
  ("repeat", "«repeat»"),
  ("opaque", "«opaque»"),
  ("instance", "«instance»"),
  ("end", "«end»")
]

/-! ## Asking Lean -/

open Lean Elab Command in
-- `leanKeywords` is exactly the keywords of this file's environment, which
-- imports all of `Lean`, so a Lean upgrade that adds one fails here. (Importing
-- `Init` afresh would load only the built-in tokens, missing those declared with
-- `syntax`, such as `at` and `calc`.)
#eval show CommandElabM Unit from do
  let actual := (keywords (← getEnv)).mergeSort (· ≤ ·)
  unless actual == leanKeywords do
    throwError m!"leanKeywords differs from Lean's keywords: {actual}"

open Lean Elab Command in
-- Quoted names parse as identifiers; unquoted, a keyword or a leading digit
-- would not.
#eval show CommandElabM Unit from do
  let env ← getEnv
  let names := ["createBuffer", "bc1RGBAUnorm", "«2d»", "«repeat»", "«end»", "«at»"]
  for name in names do
    unless isIdent env name do throwError m!"{name} does not parse as an identifier"
  for name in ["2d", "repeat", "end", "at"] do
    if isIdent env name then throwError m!"{name} unexpectedly parses as an identifier"

end WebGPUGenTest.Lowered.LeanNames
