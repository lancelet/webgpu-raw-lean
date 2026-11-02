/-!
# Where the spec came from

`vendor/webgpu-headers/SOURCE`, written by `fetch.sh`, records the repository
and commit the vendored spec was fetched from, one field per line:

    repo: https://github.com/webgpu-native/webgpu-headers
    commit: 673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
    date: 2026-05-07
    pinned-by: wgpu-native v29.0.1.1

webgpu-headers has no version numbers, so the record also says when the commit
was made, and which wgpu-native release pins it. The generator copies all four
into the banner of every file it writes.
-/

namespace WebGPUGen

/-- Where the vendored spec was fetched from, and what pins that commit. -/
structure Source where
  repo     : String
  commit   : String
  /-- The commit's date: `2026-05-07`. -/
  date     : String
  /-- The implementation release that pins the commit. -/
  pinnedBy : String
  deriving Repr, DecidableEq

/--
Read a `SOURCE` file: `repo:`, `commit:`, `date:` and `pinned-by:` lines, in
any order.
-/
def Source.parse (text : String) : Except String Source := do
  let fields := (text.splitOn "\n").filterMap fun line =>
    match line.splitOn ": " with
    | [key, value] => some (key.trimAscii.toString, value.trimAscii.toString)
    | _            => none
  let field (key : String) : Except String String :=
    match fields.lookup key with
    | some value => pure value
    | none       => throw s!"SOURCE has no {key} line"
  return {
    repo     := ← field "repo"
    commit   := ← field "commit"
    date     := ← field "date"
    pinnedBy := ← field "pinned-by"
  }

end WebGPUGen
