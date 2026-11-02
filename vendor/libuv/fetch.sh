#!/usr/bin/env sh
# Fetch libuv's source into vendor/libuv/<version>/, at the version Lean's own
# WebAssembly build uses (LIBUV in Lean's src/CMakeLists.txt), patched as Lean
# patches it: Emscripten builds also need src/unix/no-proctitle.c. Lean's
# runtime uses libuv, so the web build compiles it. The download is gitignored;
# web/build.sh runs this when it is missing.
set -eu

version=v1.48.0
dir=$(cd "$(dirname "$0")" && pwd)
out="$dir/$version"

if [ -f "$out/.complete" ]; then
  echo "libuv $version source already in $out"
  exit 0
fi

url="https://github.com/libuv/libuv/archive/refs/tags/$version.tar.gz"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Downloading $url"
curl -fsSL "$url" -o "$tmp/libuv.tar.gz"
rm -rf "$out"
mkdir -p "$out"
tar -xzf "$tmp/libuv.tar.gz" -C "$out" --strip-components=1

# Lean's patch, before the Linux section of CMakeLists.txt.
anchor='if(CMAKE_SYSTEM_NAME STREQUAL "Linux")'
awk -v anchor="$anchor" '
  $0 == anchor && !done {
    print "if(CMAKE_SYSTEM_NAME STREQUAL \"Emscripten\")"
    print "  list(APPEND uv_sources src/unix/no-proctitle.c)"
    print "endif()"
    print ""
    done = 1
  }
  { print }
  END { if (!done) exit 1 }
' "$out/CMakeLists.txt" > "$tmp/CMakeLists.txt"
mv "$tmp/CMakeLists.txt" "$out/CMakeLists.txt"

touch "$out/.complete"
echo "Fetched libuv $version source into $out"
