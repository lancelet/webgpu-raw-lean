import WebGPUGen.Source
import WebGPUGenTest.Literal

/-!
# Tests for reading `SOURCE`
-/

namespace WebGPUGenTest.Source
open WebGPUGen

-- All four fields, as `fetch.sh` writes them.
#guard
  let input := dedent "
    repo: https://github.com/webgpu-native/webgpu-headers
    commit: 673658bc2bd70ec39fc55ebe6bb0173cf6d0a603
    date: 2026-05-07
    pinned-by: wgpu-native v29.0.1.1
    "
  let expected : Source := {
    repo     := "https://github.com/webgpu-native/webgpu-headers"
    commit   := "673658bc2bd70ec39fc55ebe6bb0173cf6d0a603"
    date     := "2026-05-07"
    pinnedBy := "wgpu-native v29.0.1.1"
  }
  match Source.parse input with
  | .ok source => source == expected
  | .error _   => false

-- A missing field is an error that names it.
#guard
  let input := "repo: https://github.com/webgpu-native/webgpu-headers\n"
  match Source.parse input with
  | .ok _          => false
  | .error message => message == "SOURCE has no commit line"

end WebGPUGenTest.Source
