/-!
# Where the spec came from

`vendor/webgpu-headers/SOURCE`, written by `fetch.sh`, records the repository
and commit the vendored spec was fetched from, one field per line:

    repo: https://github.com/webgpu-native/webgpu-headers
    commit: 673658bc2bd70ec39fc55ebe6bb0173cf6d0a603

The generator copies both into the banner of every file it writes.
-/

namespace WebGPUGen

/-- The repository and commit the vendored spec was fetched from. -/
structure Source where
  repo   : String
  commit : String
  deriving Repr, DecidableEq

/-- Read a `SOURCE` file: a `repo:` and a `commit:` line, in any order. -/
def Source.parse (text : String) : Except String Source := do
  let fields := (text.splitOn "\n").filterMap fun line =>
    match line.splitOn ": " with
    | [key, value] => some (key.trimAscii.toString, value.trimAscii.toString)
    | _            => none
  let field (key : String) : Except String String :=
    match fields.lookup key with
    | some value => pure value
    | none       => throw s!"SOURCE has no {key} line"
  return { repo := ← field "repo", commit := ← field "commit" }

end WebGPUGen
