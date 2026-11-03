#!/bin/sh
# Checks the build itself: the C types of every function Lean calls through an
# @[extern] agree with how Lean calls it. Lean declares each @[extern] it calls
# in the C it compiles a module to; this compiles those declarations together
# with the C that defines them, so any disagreement is a "conflicting types"
# error. It also checks that the two declare the same number of functions. It
# checks the generated shims (WebGPU.Raw.Functions, c/generated/functions.c)
# and the byte writers (WebGPU.Raw.Internal.Bytes, c/bytes.c).
set -eu
cd "$(dirname "$0")/.."

# Any fetched platform's headers will do: they are the same on every platform.
for wgpu_include in vendor/wgpu-native/*/include; do break; done
if [ ! -d "$wgpu_include" ]; then
  echo "FAIL: no wgpu-native fetched: run vendor/wgpu-native/fetch.sh" >&2
  exit 1
fi
lean_include="$(lean --print-prefix)/include"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# check MODULE SOURCE NAMES WHAT: the @[extern]s of the Lean module MODULE whose
# names match NAMES, an extended regular expression, against their definitions
# in the C file SOURCE. A module declares every @[extern] it calls, so NAMES
# picks out those SOURCE defines.
check() {
  module=$1
  source=$2
  names=$3
  what=$4
  ir=.lake/build/ir/$(echo "$module" | tr . /).c
  lake build "+$module:c" >/dev/null

  grep -E "^lean_object\\* $names\\(.*\\);\$" "$ir" \
    > "$tmp/lean.h.inc" || true
  declared=$(wc -l < "$tmp/lean.h.inc")
  if [ "$declared" -eq 0 ]; then
    echo "FAIL: no declarations found in $ir: has Lean's format changed?" >&2
    exit 1
  fi
  defined=$(grep -cE "^LEAN_EXPORT lean_obj_res $names\\(" \
    "$source" || true)
  if [ "$declared" -ne "$defined" ]; then
    echo "FAIL: Lean declares $declared $what, but $source defines $defined" >&2
    exit 1
  fi

  {
    echo '#include <lean/lean.h>'
    cat "$tmp/lean.h.inc"
    echo "#include \"$PWD/$source\""
  } > "$tmp/check.c"
  # -Wmissing-prototypes: every definition must have Lean's declaration of it.
  ${CC:-cc} -fsyntax-only -std=c11 -Wall -Wextra -Wmissing-prototypes \
    -Werror -I "$lean_include" -I "$wgpu_include" \
    -I c/generated "$tmp/check.c"
  echo "OK: the $defined $what agree with how Lean calls them"
}

check WebGPU.Raw.Functions c/generated/functions.c \
  'lean_wgpu[A-Z][A-Za-z0-9]*' shims
check WebGPU.Raw.Internal.Bytes c/bytes.c \
  'lean_wgpu_bytes_[a-z0-9_]*' "byte writers"
