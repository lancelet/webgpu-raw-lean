#!/usr/bin/env sh
# Write vendor/emdawnwebgpu/missing: the functions upstream's webgpu.h (the
# one wgpu-native pins, vendor/webgpu-headers) declares, which the
# emdawnwebgpu port of the pinned Emscripten (web/emscripten-version) does
# not, one per line. The bindings' shims raise an IO error for them instead,
# when built for the web. The port's header is in the build's Emscripten
# cache ($EM_CACHE, as web/build.sh has it): run web/build.sh first. Run
# it again when either version changes, and commit the result.
set -eu
cd "$(dirname "$0")/../.."

dawn=${EM_CACHE:-.lake/web/emscripten-cache}/ports/emdawnwebgpu
dawn=$dawn/emdawnwebgpu_pkg/webgpu
dawn=$dawn/include/webgpu/webgpu.h
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
{
  echo "# The webgpu.h functions the emdawnwebgpu port of Emscripten" \
    "$(cat web/emscripten-version) does"
  echo "# not declare. Written by missing.sh; do not edit by hand."
  LC_ALL=C comm -23 "$tmp/upstream" "$tmp/dawn"
} > vendor/emdawnwebgpu/missing
