#!/usr/bin/env sh
# Fetch the WebGPU API spec files we generate bindings from.
#
# To update: change WEBGPU_HEADERS_COMMIT, run this script, review the diff,
# and commit. Keep the commit in step with the one wgpu-native pins in its
# ffi/webgpu-headers submodule, so the spec matches the library we link.
set -eu

# Pinned by wgpu-native v29.0.1.1.
WEBGPU_HEADERS_COMMIT=673658bc2bd70ec39fc55ebe6bb0173cf6d0a603

base="https://raw.githubusercontent.com/webgpu-native/webgpu-headers/$WEBGPU_HEADERS_COMMIT"
dir=$(cd "$(dirname "$0")" && pwd)

for f in webgpu.yml schema.json LICENSE; do
  curl -fsSL "$base/$f" -o "$dir/$f"
done

echo "Fetched webgpu-headers @ $WEBGPU_HEADERS_COMMIT"
