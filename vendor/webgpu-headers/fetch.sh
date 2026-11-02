#!/usr/bin/env sh
# Fetch the WebGPU API spec files we generate bindings from, and the C header
# upstream generates from them (to test our generated names against).
#
# To update: change WEBGPU_HEADERS_COMMIT, run this script, review the diff,
# and commit. Keep the commit in step with the one wgpu-native pins in its
# ffi/webgpu-headers submodule, so the spec matches the library we link.
set -eu

# Pinned by wgpu-native v29.0.1.1.
WEBGPU_HEADERS_COMMIT=673658bc2bd70ec39fc55ebe6bb0173cf6d0a603

base="https://raw.githubusercontent.com/webgpu-native/webgpu-headers/$WEBGPU_HEADERS_COMMIT"
dir=$(cd "$(dirname "$0")" && pwd)

for f in webgpu.yml webgpu.h schema.json LICENSE; do
  curl -fsSL "$base/$f" -o "$dir/$f"
done

# Upstream's articles, which define the documentation pages the spec's docs
# refer to (`@ref SentinelValues`); the generator links those references to them.
mkdir -p "$dir/articles"
for f in "Asynchronous Operations" BufferMapping Errors Extensions \
    FloatingPointNumbers Multithreading Ownership SentinelValues Strings \
    StructChaining Surfaces index; do
  curl -fsSL "$base/doc/articles/$(echo "$f" | sed 's/ /%20/g').md" -o "$dir/articles/$f.md"
done

# Where these files came from, for the banner of every generated file.
printf 'repo: %s\ncommit: %s\n' \
  "https://github.com/webgpu-native/webgpu-headers" "$WEBGPU_HEADERS_COMMIT" \
  > "$dir/SOURCE"

echo "Fetched webgpu-headers @ $WEBGPU_HEADERS_COMMIT"
