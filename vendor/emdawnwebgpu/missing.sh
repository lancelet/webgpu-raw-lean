#!/usr/bin/env sh
# Write vendor/emdawnwebgpu/missing: the functions upstream's webgpu.h (the
# one wgpu-native pins, vendor/webgpu-headers) declares, which the
# emdawnwebgpu port of the pinned Emscripten (web/emscripten-version) does
# not, or aborts in (its JavaScript, `abort(...)`), one per line. The
# bindings' shims raise an IO error for them instead, when built for the
# web. The port is in the build's Emscripten cache ($EM_CACHE, as
# web/build.sh has it): run web/build.sh first. Run it again when either
# version changes, and commit the result.
set -eu
cd "$(dirname "$0")/../.."

dawn=${EM_CACHE:-.lake/web/emscripten-cache}/ports/emdawnwebgpu
port=$dawn/emdawnwebgpu_pkg/webgpu
dawn=$port/include/webgpu/webgpu.h
js=$port/src/library_webgpu.js
if [ ! -f "$dawn" ]; then
  echo "FAIL: no emdawnwebgpu header at $dawn: run web/build.sh first" >&2
  exit 1
fi
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# The functions a header declares, sorted, one per line.
names() {
  grep -oE '^WGPU_EXPORT [^(]*[ *]wgpu[A-Za-z0-9]+\(' "$1" \
    | grep -oE 'wgpu[A-Za-z0-9]+\($' | tr -d '(' | LC_ALL=C sort -u
}
names vendor/webgpu-headers/webgpu.h > "$tmp/upstream"
names "$dawn" > "$tmp/dawn"
# Those the port declares, but whose JavaScript aborts, ending the program,
# as its first statements: a function `wgpuX: (...) => {` whose next few
# lines call `abort(`.
awk '
  /^  wgpu[A-Za-z0-9]+: \(/ {
    match($0, /wgpu[A-Za-z0-9]+/); name = substr($0, RSTART, RLENGTH); n = 0
    next
  }
  name != "" && n < 3 {
    n++
    if ($0 ~ /abort\(/) { print name; name = "" }
  }
' "$js" | LC_ALL=C sort -u > "$tmp/aborting"
{
  echo "# The webgpu.h functions the emdawnwebgpu port of Emscripten" \
    "$(cat web/emscripten-version) does"
  echo "# not declare, or aborts in. Written by missing.sh; do not edit by hand."
  LC_ALL=C comm -23 "$tmp/upstream" "$tmp/dawn"
  LC_ALL=C comm -12 "$tmp/upstream" "$tmp/aborting"
} > vendor/emdawnwebgpu/missing
