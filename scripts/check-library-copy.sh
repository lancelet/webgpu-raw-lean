#!/bin/sh
# Checks the build itself: when wgpu-native's library changes, even to one
# whose timestamp is older (as unzip gives an older release's), the copy
# beside the programs must change with it, or they would link and load the
# old one. (A regression test: copies were once kept while newer than their
# source.) Linux only.
set -eu
cd "$(dirname "$0")/.."
lib=vendor/wgpu-native/linux-x86_64/lib/libwgpu_native.so
copy=.lake/build/bin/libwgpu_native.so
lake build webgpu-raw-test >/dev/null
cp -p "$lib" "$lib.orig"
trap 'mv "$lib.orig" "$lib"; lake build webgpu-raw-test >/dev/null' EXIT
echo "edited" >> "$lib"
touch -d 2000-01-01 "$lib"
# The edited library no longer links; only the copy matters here.
lake build webgpu-raw-test >/dev/null 2>&1 || true
if ! cmp -s "$lib" "$copy"; then
  echo "FAIL: $copy is not $lib after it changed" >&2
  exit 1
fi
echo "A changed library is copied beside the programs."
