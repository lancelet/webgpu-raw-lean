import WebGPUGen

/-!
# webgpu-gen

Generates the Lean bindings from the vendored spec:

    lake exe webgpu-gen generate

writes the bindings' generated Lean modules (`WebGPU/Raw/Enums.lean`,
`WebGPU/Raw/Objects.lean`) and C shims (`c/generated/objects.h` and `.c`). Each
file starts with a banner recording when it was generated, from which commit of
this repository (and whether it had uncommitted changes), and which spec it was
generated from. A spec with problems stops the generator before anything is
written.

    lake exe webgpu-gen dump [--docs]

prints what the generator read from the spec, section by section, with its docs
if asked: a view for checking the reader by eye, and for debugging.
-/

open WebGPUGen

/--
The repository root, found from this executable's location
(`webgpu-gen/.lake/build/bin/`), so the generator works from any directory.
-/
def repoRoot : IO System.FilePath := do
  let bin := (← IO.appPath).parent.getD "."
  let ancestor (n : Nat) := (List.range n).foldl (fun p _ => p.bind (·.parent)) (some bin)
  return (ancestor 4).getD "."

/-- Run a command in `dir` and return its output, failing if the command fails. -/
def run (dir : System.FilePath) (cmd : String) (args : Array String) : IO String := do
  let out ← IO.Process.output { cmd, args, cwd := some dir }
  unless out.exitCode == 0 do
    throw (IO.userError s!"{cmd} {" ".intercalate args.toList} failed: {out.stderr}")
  return out.stdout.trimAscii.toString

/--
Where the generated files come from: this repository's commit, whether its
tracked files have uncommitted changes, the time, and the spec's source.
-/
def provenance (root : System.FilePath) : IO Emit.Provenance := do
  let commit ← run root "git" #["rev-parse", "--short", "HEAD"]
  let changes ← run root "git" #["status", "--porcelain", "--untracked-files=no"]
  let time ← run root "date" #["-u", "+%Y-%m-%d %H:%M:%S UTC"]
  let source ← match Source.parse (← IO.FS.readFile (root / "vendor/webgpu-headers/SOURCE")) with
    | .ok source => pure source
    | .error e   => throw (IO.userError e)
  return {
    generator    := "webgpu-gen"
    time         := time
    commit       := commit
    dirty        := !changes.isEmpty
    source       := "vendor/webgpu-headers/webgpu.yml"
    sourceRepo   := source.repo
    sourceCommit := source.commit
    sourceDate   := source.date
    pinnedBy     := source.pinnedBy
  }

/-- Decode the vendored spec, or report where decoding failed. -/
def parseSpec (root : System.FilePath) : IO Parsed.Spec := do
  let node ← Yaml.parseFile (root / "vendor/webgpu-headers/webgpu.yml")
  match (Parsed.Spec.codec.decode node).run with
  | .ok parsed => pure parsed
  | .error e   => throw (IO.userError (toString e))

/--
The functions each implementation leaves unimplemented, from its list of stubs
(`vendor/wgpu-native/stubs`, which `stubs.sh` writes).
-/
def stubs (root : System.FilePath) : IO (List (String × List String)) := do
  let text ← IO.FS.readFile (root / "vendor/wgpu-native/stubs")
  return [("wgpu-native", parseStubs text)]

/-- Decode, resolve and lower the vendored spec, or report every problem. -/
def loadSpec (root : System.FilePath) : IO Lowered.Spec := do
  let parsed ← parseSpec root
  -- The documentation sections the spec's docs refer to, from upstream's articles.
  let articles ← (root / "vendor/webgpu-headers/articles").readDir
  let sections ← articles.toList.flatMapM fun entry => do
    return Lowered.articleSections (← IO.FS.readFile entry.path)
  match Resolved.resolve parsed with
  | .ok resolved => return Lowered.lower resolved sections (← stubs root)
  | .error problems =>
    for p in problems do IO.eprintln p
    throw (IO.userError s!"{problems.length} problems in the spec")

/-- Write every generated file. -/
def generate : IO Unit := do
  let root ← repoRoot
  let spec ← loadSpec root
  let p ← provenance root
  let lean := root / "WebGPU" / "Raw"
  let c := root / "c" / "generated"
  IO.FS.createDirAll c
  let files := [
    (lean / "Enums.lean",   Emit.Lean.enumsFile p spec),
    (lean / "Objects.lean", Emit.Lean.objectsFile p spec),
    (lean / "Functions.lean", Emit.Lean.functionsFile p spec),
    (lean / "Constants.lean", Emit.Lean.constantsFile p spec)
  ] ++ (Emit.C.objectsFiles p spec ++ Emit.C.functionsFiles p spec).map
    fun (name, text) => (c / name, text)
  for (path, text) in files do
    IO.FS.writeFile path text
    IO.println s!"wrote {path}"

/--
Print what the reader understood of the vendored spec, section by section, with
its docs if `docs` is set.
-/
def dump (docs : Bool) : IO Unit := do
  for line in Parsed.dumpSpec { docs } (← parseSpec (← repoRoot)) do
    IO.println line

def main (args : List String) : IO UInt32 := do
  match args with
  | ["generate"]       => generate; return 0
  | ["dump"]           => dump false; return 0
  | ["dump", "--docs"] => dump true; return 0
  | _ =>
    IO.eprintln "usage: webgpu-gen generate\n       webgpu-gen dump [--docs]"
    return 1
