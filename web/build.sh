#!/usr/bin/env bash
# Build the web self-test for WebAssembly, with Emscripten (emcc, em++, emar
# and emcmake on PATH, with cmake), into .lake/web/site/: the page, and the
# program it runs.
#
# Lean does not support WebAssembly (web/README.md), so this assembles what Lean
# would otherwise ship, once per Lean version, under .lake/web/<version>/:
#
#   * Lean's runtime, compiled from Lean's source (vendor/lean4/fetch.sh);
#   * Init, Lean's core library, as C: each module compiled again with `lean -c`,
#     since the toolchain ships Init's sources but not its C;
#   * libuv, which the runtime uses, patched as Lean patches it.
#
# Then Lake compiles the bindings and the self-test to C, and this compiles
# that C with the shims and links it all.
#
# Usage: web/build.sh
set -euo pipefail
cd "$(dirname "$0")/.."
root=$PWD

for tool in emcc em++ emar emcmake cmake lean lake; do
  command -v "$tool" >/dev/null || { echo "web/build.sh: no $tool on PATH" >&2; exit 1; }
done

version=$(sed 's/.*://' lean-toolchain)
prefix=$(lean --print-prefix)
jobs=$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)
web=$root/.lake/web
cache=$web/$version
app=$web/app
site=$web/site

# Emscripten writes its cache, and builds its ports (emdawnwebgpu) there.
export EM_CACHE=${EM_CACHE:-$web/emscripten-cache}

vendor/lean4/fetch.sh
vendor/libuv/fetch.sh
lean_src=$root/vendor/lean4/$version
libuv_src=$root/vendor/libuv/v1.48.0

# One exception model for everything: WebAssembly's own exceptions.
eh=-fwasm-exceptions
# LEAN_EMSCRIPTEN on all of Lean's C is required, not optional: without it,
# 32-bit targets silently miscompile static constants (lean4#15816).
lean_flags=(-O2 "$eh" -DLEAN_EMSCRIPTEN -DNDEBUG
  -I "$cache/include" -I "$lean_src/src/include")

# --- Lean's headers: its source's, with our config.h and its version --------
mkdir -p "$cache/include/lean"
cp web/include/lean/config.h "$cache/include/lean/config.h"
cp "$prefix/include/lean/version.h" "$cache/include/lean/version.h"
printf '#define LEAN_GITHASH "%s"\n' "$(lean --githash)" > "$cache/include/githash.h"

# --- libuv ----------------------------------------------------------------------
if [ ! -f "$cache/lib/libuv.a" ]; then
  echo "== libuv"
  rm -rf "$cache/libuv"
  emcmake cmake -S "$libuv_src" -B "$cache/libuv" -DCMAKE_BUILD_TYPE=Release \
    -DLIBUV_BUILD_TESTS=OFF -DLIBUV_BUILD_SHARED=OFF \
    -DCMAKE_C_FLAGS="-O2 $eh" >/dev/null
  cmake --build "$cache/libuv" --target uv_a -j "$jobs" >/dev/null
  mkdir -p "$cache/lib"
  cp "$cache/libuv/libuv.a" "$cache/lib/libuv.a"
fi

# Each step below runs once per file, in parallel: xargs calls this script's
# functions through bash, each with one file. These are what they need.
export cache lean_src prefix libuv_src
export lean_flags_text="${lean_flags[*]}"

# Compile one source of Lean's runtime, like `uv/foo.cpp`.
compile_runtime() {
  local flags
  read -r -a flags <<< "$lean_flags_text"
  em++ "${flags[@]}" -std=c++20 -DLEAN_EXPORTING -w \
    -I "$lean_src/src" -I "$libuv_src/include" \
    -c "$lean_src/src/runtime/$1" -o "$cache/runtime/${1//\//_}.o"
}

# Compile one module of Init, like `Init/Data/List`, to C, as Lean's own build
# does: with the option it gives (LEAN_EXTRA_OPTS in Lean's src/CMakeLists.txt),
# which changes how `do` elaborates; its imports read from the toolchain's
# .olean files; and the toolchain's `lean` named by path, since in Lean's
# source tree its own lean-toolchain would choose another.
init_to_c() {
  mkdir -p "$(dirname "$cache/init-c/$1")"
  if ! (cd "$prefix/src/lean" \
        && LEAN_PATH="$prefix/lib/lean" "$prefix/bin/lean" \
          -Dbackward.do.legacy=false -R . \
          -c "$cache/init-c/$1.c" "$1.lean" > "$cache/init-c/$1.log" 2>&1); then
    echo "lean -c $1 failed:" >&2
    cat "$cache/init-c/$1.log" >&2
    return 1
  fi
}

# Compile one module of Init's C, like `Init/Data/List.c`, to WebAssembly.
compile_init() {
  local flags out
  read -r -a flags <<< "$lean_flags_text"
  out=${1//\//_}
  emcc "${flags[@]}" -w -c "$cache/init-c/$1" -o "$cache/init-o/${out%.c}.o"
}
export -f compile_runtime init_to_c compile_init

# --- Lean's runtime ---------------------------------------------------------------
# The sources src/runtime/CMakeLists.txt lists, without mimalloc, and without
# uv/*: those only back Std.Internal.UV, which nothing here uses, and their
# WebAssembly stubs do not compile (lean4#15181).
if [ ! -f "$cache/lib/libleanrt.a" ]; then
  echo "== Lean's runtime"
  rm -rf "$cache/runtime"
  mkdir -p "$cache/runtime" "$cache/lib"
  # shellcheck disable=SC2016 # the $1 is the inner bash's
  sed -n '/^set($/,/^)$/p' "$lean_src/src/runtime/CMakeLists.txt" \
    | grep '\.cpp$' | grep -v 'uv/' | tr -d ' ' \
    | xargs -P "$jobs" -n 1 bash -c 'compile_runtime "$1"' _
  rm -f "$cache/lib/libleanrt.a"
  emar rcs "$cache/lib/libleanrt.a" "$cache"/runtime/*.o
fi

# --- Init, as C, then compiled ----------------------------------------------------
if [ ! -f "$cache/lib/libInit.a" ]; then
  echo "== Init: Lean to C"
  rm -rf "$cache/init-c" "$cache/init-o"
  mkdir -p "$cache/init-c" "$cache/init-o" "$cache/lib"
  # shellcheck disable=SC2016 # the $1 is the inner bash's
  (cd "$prefix/src/lean" && { echo Init.lean; find Init -name '*.lean'; }) \
    | sed 's/\.lean$//' \
    | xargs -P "$jobs" -n 1 bash -c 'init_to_c "$1"' _
  echo "== Init: C to WebAssembly"
  # shellcheck disable=SC2016 # the $1 is the inner bash's
  (cd "$cache/init-c" && find . -name '*.c' | sed 's|^\./||') \
    | xargs -P "$jobs" -n 1 bash -c 'compile_init "$1"' _
  rm -f "$cache/lib/libInit.a"
  emar rcs "$cache/lib/libInit.a" "$cache"/init-o/*.o
fi

# --- The bindings and the self-test ---------------------------------------------
echo "== the bindings and the self-test"
lake build WebGPURawWebTest >/dev/null
rm -rf "$app"
mkdir -p "$app" "$site"
# Compile one module's C, like `WebGPU/Raw/Enums`, from Lake's output.
compile_module() {
  local flags
  read -r -a flags <<< "$lean_flags_text"
  emcc "${flags[@]}" -w -c ".lake/build/ir/$1.c" -o "$app/${1//\//_}.o"
}
export -f compile_module
export app
# The modules in the sources, not every C file in .lake/build/ir, which may
# hold C of modules since removed.
# shellcheck disable=SC2016 # the $1 is the inner bash's
{ find WebGPU WebGPURawWebTest -name '*.lean'; echo WebGPURawWebTest.lean; } \
  | sed 's/\.lean$//' \
  | xargs -P "$jobs" -n 1 bash -c 'compile_module "$1"' _
port=--use-port=emdawnwebgpu
for f in c/generated/*.c WebGPURawTest/c/instance.c web/main.c; do
  emcc "${lean_flags[@]}" "$port" -I c/generated -c "$f" \
    -o "$app/shim_$(basename "$f" .c).o"
done

echo "== link"
em++ -o "$site/webgpu-raw-web-test.js" "$app"/*.o \
  "$cache/lib/libInit.a" "$cache/lib/libleanrt.a" "$cache/lib/libuv.a" \
  -O2 "$eh" "$port" -sENVIRONMENT=web,node -sEXIT_RUNTIME=1 \
  -sALLOW_MEMORY_GROWTH=1 -sSTACK_SIZE=8388608
cp web/index.html "$site/index.html"
echo "Built $site"
