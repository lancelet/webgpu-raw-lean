#!/usr/bin/env sh
# Fetch Lean's source, at the version lean-toolchain names, into
# vendor/lean4/<version>/. The web build compiles Lean's runtime from it, since
# Lean ships no WebAssembly build. The download is gitignored; web/build.sh runs
# this when it is missing.
set -eu

dir=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$dir/../.." && pwd)
# lean-toolchain is `leanprover/lean4:v4.31.0`: the version is after the colon.
version=$(sed 's/.*://' "$root/lean-toolchain")
out="$dir/$version"

if [ -f "$out/.complete" ]; then
  echo "Lean $version source already in $out"
  exit 0
fi

url="https://github.com/leanprover/lean4/archive/refs/tags/$version.tar.gz"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Downloading $url"
curl -fsSL "$url" -o "$tmp/lean4.tar.gz"
rm -rf "$out"
mkdir -p "$out"
tar -xzf "$tmp/lean4.tar.gz" -C "$out" --strip-components=1
touch "$out/.complete"
echo "Fetched Lean $version source into $out"
