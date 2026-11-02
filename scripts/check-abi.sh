#!/bin/sh
# Checks the build itself: the C types of every function shim agree with how
# Lean calls it. Lean declares each @[extern] it calls in the C it compiles
# WebGPU.Raw.Functions to; this compiles those declarations and the shims'
# definitions together, so any disagreement is a "conflicting types" error. It
# also checks that the two declare the same number of functions.
set -eu
cd "$(dirname "$0")/.."

ir=.lake/build/ir/WebGPU/Raw/Functions.c
shims=c/generated/functions.c
lake build +WebGPU.Raw.Functions:c >/dev/null

# Any fetched platform's headers will do: they are the same on every platform.
for wgpu_include in vendor/wgpu-native/*/include; do break; done
if [ ! -d "$wgpu_include" ]; then
  echo "FAIL: no wgpu-native fetched: run vendor/wgpu-native/fetch.sh" >&2
  exit 1
fi
lean_include="$(lean --print-prefix)/include"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

grep -E '^lean_object\* lean_wgpu[A-Za-z0-9]*\(.*\);$' "$ir" \
  > "$tmp/lean.h.inc" || true
declared=$(wc -l < "$tmp/lean.h.inc")
if [ "$declared" -eq 0 ]; then
  echo "FAIL: no shim declarations found in $ir: has Lean's format changed?" >&2
  exit 1
fi
defined=$(grep -c '^LEAN_EXPORT lean_obj_res lean_wgpu[A-Za-z0-9]*(' "$shims" \
  || true)
if [ "$declared" -ne "$defined" ]; then
  echo "FAIL: Lean declares $declared shims, but $shims defines $defined" >&2
  exit 1
fi

{
  echo '#include <lean/lean.h>'
  cat "$tmp/lean.h.inc"
  echo "#include \"$PWD/$shims\""
} > "$tmp/check.c"
# -Wmissing-prototypes: every shim must have the declaration Lean made of it.
${CC:-cc} -fsyntax-only -std=c11 -Wall -Wextra -Wmissing-prototypes -Werror \
  -I "$lean_include" -I "$wgpu_include" \
  -I c/generated "$tmp/check.c"
echo "OK: the $defined shims agree with how Lean calls them"
