import WebGPUGen

/-!
# webgpu-gen

Generates the Lean bindings from the vendored spec:

    lake exe webgpu-gen generate

writes `WebGPU/Raw/Enums.lean` in the bindings package. Each file starts with a
banner recording when it was generated, from which commit of this repository
(and whether it had uncommitted changes), and which spec it was generated from.
A spec with problems stops the generator before anything is written.
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
  }

/-- Decode, resolve and lower the vendored spec, or report every problem. -/
def loadSpec (root : System.FilePath) : IO Lowered.Spec := do
  let node ← Yaml.parseFile (root / "vendor/webgpu-headers/webgpu.yml")
  let parsed ← match (Parsed.Spec.codec.decode node).run with
    | .ok parsed => pure parsed
    | .error e   => throw (IO.userError (toString e))
  match Resolved.resolve parsed with
  | .ok resolved => return Lowered.lower resolved
  | .error problems =>
    for p in problems do IO.eprintln p
    throw (IO.userError s!"{problems.length} problems in the spec")

/-- Write every generated file. -/
def generate : IO Unit := do
  let root ← repoRoot
  let spec ← loadSpec root
  let p ← provenance root
  let path := root / "WebGPU" / "Raw" / "Enums.lean"
  IO.FS.writeFile path (Emit.Lean.enumsFile p spec)
  IO.println s!"wrote {path}"

def main (args : List String) : IO UInt32 := do
  match args with
  | ["generate"] => generate; return 0
  | _ =>
    IO.eprintln "usage: webgpu-gen generate"
    return 1
