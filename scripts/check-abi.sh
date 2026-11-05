#!/bin/sh
# Checks the build itself: the C types of every function Lean calls through an
# @[extern] agree with how Lean calls it. Lean declares each @[extern] it calls
# in the C it compiles a module to; this compiles those declarations together
# with the C that defines them, so any disagreement is a "conflicting types"
# error. It also checks that the two declare the same number of functions. It
# checks the generated shims (WebGPU.Raw.Functions, c/generated/functions.c),
# the addresses of callbacks' trampolines (WebGPU.Raw.Callbacks), and the
# shims written by hand (WebGPU.Raw.Wait, Mapped, Queries and Surface, in
# c/wait.c, mapped.c, queries.c and surface.c); each as built against
# wgpu-native (-DWEBGPU_RAW_WGPU_NATIVE), against Dawn (-DWEBGPU_RAW_DAWN),
# and against neither, as each calls what the other leaves unimplemented.
# (The byte writers' C is pasted into Lean's own, so its compiler checks it.)
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

  # The functions that give the addresses of callbacks' trampolines, which
  # the callbacks module declares (each returning a `UInt64`), with the shims;
  # not the bindings' own handler's, `_default_address`, which c/callback.c
  # defines, and so no ``.
  if [ "$module" = WebGPU.Raw.Functions ]; then
    callbacks=.lake/build/ir/WebGPU/Raw/Callbacks.c
    lake build "+WebGPU.Raw.Callbacks:c" >/dev/null
    grep -E '^uint64_t lean_WGPU[A-Za-z]*_address\(.*\);$' "$callbacks" \
      > "$tmp/addresses.h.inc" || true
    addresses=$(wc -l < "$tmp/addresses.h.inc")
    given=$(grep -cE '^LEAN_EXPORT uint64_t lean_WGPU[A-Za-z]*_address\(' \
      "$source" || true)
    if [ "$addresses" -ne "$given" ]; then
      echo "FAIL: Lean declares $addresses addresses, $source gives $given" >&2
      exit 1
    fi
    cat "$tmp/addresses.h.inc" >> "$tmp/lean.h.inc"
  fi

  {
    echo '#include <lean/lean.h>'
    cat "$tmp/lean.h.inc"
    echo "#include \"$PWD/$source\""
  } > "$tmp/check.c"
  # -Wmissing-prototypes: every definition must have Lean's declaration of it.
  for build in "" -DWEBGPU_RAW_WGPU_NATIVE -DWEBGPU_RAW_DAWN; do
    ${CC:-cc} -fsyntax-only -std=c11 -Wall -Wextra -Wmissing-prototypes \
      -Werror -I "$lean_include" -I "$wgpu_include" $build \
      -I c/generated -I c "$tmp/check.c"
  done
  echo "OK: $what ($defined) agree with how Lean calls them"
}

check WebGPU.Raw.Functions c/generated/functions.c \
  'lean_wgpu[A-Z][A-Za-z0-9]*' shims
check WebGPU.Raw.Wait c/wait.c 'lean_wgpuInstanceWaitAny' "hand-written shims"
check WebGPU.Raw.Mapped c/mapped.c 'lean_wgpu_buffer_(read|write)_mapped' \
  "hand-written shims"
check WebGPU.Raw.Queries c/queries.c 'lean_wgpu_[a-z_]*get_[a-z_]+' \
  "hand-written shims"
check WebGPU.Raw.Surface c/surface.c 'lean_wgpu_surface_get_[a-z_]+' \
  "hand-written shims"
