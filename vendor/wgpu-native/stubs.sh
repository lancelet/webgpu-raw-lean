#!/usr/bin/env sh
# Write vendor/wgpu-native/stubs: the webgpu.h functions the pinned wgpu-native
# release leaves unimplemented, one per line. Calling one aborts the program (a
# Rust panic that cannot unwind into C), so the bindings' shims raise an IO
# error for them instead, when built against wgpu-native. The list is read from
# wgpu-native's source at the version fetch.sh pins: each exported function
# whose body is `unimplemented!`. Run it again when that version changes, and
# commit the result.
set -eu

dir=$(cd "$(dirname "$0")" && pwd)
version=$(sed -n 's/^WGPU_NATIVE_VERSION=//p' "$dir/fetch.sh")
url="https://github.com/gfx-rs/wgpu-native/archive/refs/tags/$version.tar.gz"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Downloading $url"
curl -fsSL --retry 3 "$url" -o "$tmp/source.tar.gz"
mkdir "$tmp/source"
tar -xzf "$tmp/source.tar.gz" -C "$tmp/source" --strip-components=1

{
  echo "# The webgpu.h functions wgpu-native $version leaves unimplemented:"
  echo "# calling one aborts. Written by stubs.sh; do not edit by hand."
  # Each exported function whose first statement is `unimplemented!`: after
  # its signature (which may span lines) ends in `{`, the next non-blank line.
  find "$tmp/source/src" -name '*.rs' -exec awk '
    FNR == 1 { name = ""; signature = 0; first = 0 }
    /extern "C" fn wgpu[A-Za-z0-9]*\(/ {
      match($0, /fn wgpu[A-Za-z0-9]*/)
      name = substr($0, RSTART + 3, RLENGTH - 3)
      signature = 1
      first = 0
    }
    first && /[^[:space:]]/ {
      if (/^[[:space:]]*unimplemented!/) print name
      first = 0
    }
    signature && /\{[[:space:]]*$/ { signature = 0; first = 1 }
  ' {} + | LC_ALL=C sort -u
} > "$dir/stubs"
echo "Wrote $(grep -vc '^#' "$dir/stubs") stubs to $dir/stubs"
