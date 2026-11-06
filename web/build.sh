#!/usr/bin/env bash
# Build Lean programs that use the bindings for WebAssembly, with Emscripten
# (emcc, em++, emar and emcmake on PATH, with cmake and make): this
# repository's self-test and examples, or, from a package depending on this
# one, that package's program.
#
# Lean does not support WebAssembly (web/README.md), so this assembles what Lean
# would otherwise ship, under .lake/web/<version>-<stamp>/ in this repository
# (in a dependent, its copy in .lake/packages/):
#
#   * Lean's runtime, compiled from Lean's source (vendor/lean4/fetch.sh);
#   * Init, Lean's core library, as C: each module compiled again with
#     `lean -c`, since the toolchain ships Init's sources but not its C;
#   * libuv, which the runtime uses, patched as Lean patches it.
#
# These take a few minutes, and are built again only when the Lean version or
# the stamp changes: the stamp is of everything they are built with (this
# script, our config.h, Emscripten's version), so that nothing built one way is
# linked with things built another.
#
# Then Lake compiles the bindings and the program to C, and this compiles that
# C with the shims and links it all.
#
# Usage:
#
#   web/build.sh
#
# builds this repository's self-test and examples into .lake/web/site/.
#
#   .lake/packages/WebGPURaw/web/build.sh --app ROOT --page PAGE --out DIR
#
# run from the root of a package depending on this one, builds its program:
# `lake build ROOT`, then the modules ROOT.lean and ROOT/**.lean (one of which
# has `main`), linked with the bindings, the window library and their C, into
# DIR/NAME.js and DIR/NAME.wasm, where PAGE, copied into DIR, is NAME.html.
# The package must use this one's Lean version.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)

usage() {
  echo "usage: web/build.sh" >&2
  echo "       web/build.sh --app ROOT --page PAGE --out DIR" >&2
  exit 2
}
app_root=
page=
out=
while [ $# -gt 0 ]; do
  case "$1" in
    --app)  [ $# -ge 2 ] || usage; app_root=$2; shift 2 ;;
    --page) [ $# -ge 2 ] || usage; page=$2; shift 2 ;;
    --out)  [ $# -ge 2 ] || usage; out=$2; shift 2 ;;
    *) usage ;;
  esac
done
if [ -n "$app_root$page$out" ]; then
  [ -n "$app_root" ] && [ -n "$page" ] && [ -n "$out" ] || usage
  if [ ! -f "$page" ]; then
    echo "web/build.sh: no page $page" >&2
    exit 1
  fi
  if ! cmp -s lean-toolchain "$root/lean-toolchain"; then
    echo "web/build.sh: this package's lean-toolchain is not the bindings'" \
      "($(cat "$root/lean-toolchain"))" >&2
    exit 1
  fi
  page=$(cd "$(dirname "$page")" && pwd)/$(basename "$page")
  mkdir -p "$out"
  out=$(cd "$out" && pwd)
else
  cd "$root"
fi

for tool in emcc em++ emar emcmake cmake make lean lake; do
  if ! command -v "$tool" >/dev/null; then
    echo "web/build.sh: no $tool on PATH" >&2
    exit 1
  fi
done

# CI builds with the Emscripten version in web/emscripten-version; another
# probably works, but is not what CI checks.
wanted=$(cat "$root/web/emscripten-version")
if ! emcc --version | head -n 1 | grep -q " $wanted"; then
  echo "web/build.sh: warning: Emscripten is not $wanted, which CI uses:" >&2
  emcc --version | head -n 1 >&2
fi

version=$(sed 's/.*://' "$root/lean-toolchain")
prefix=$(lean --print-prefix)
jobs=$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)
web=$root/.lake/web
stamp=$({
  cat "$root/web/build.sh" "$root/web/include/lean/config.h"
  emcc --version | head -n 1
} | cksum | cut -d ' ' -f 1)
cache=$web/$version-$stamp
# Objects, in the package being built.
app=$PWD/.lake/web/app
site=${out:-$web/site}

# Emscripten writes its cache, and builds its ports (emdawnwebgpu) there.
export EM_CACHE=${EM_CACHE:-$web/emscripten-cache}

"$root/vendor/lean4/fetch.sh"
"$root/vendor/libuv/fetch.sh"
lean_src=$root/vendor/lean4/$version
libuv_src=$root/vendor/libuv/v1.48.0

# The flags all of Lean's C is compiled with: one exception model for
# everything (WebAssembly's own), and LEAN_EMSCRIPTEN, which is required, not
# optional: without it, 32-bit targets silently miscompile static constants
# (lean4#15816).
export cache lean_src prefix libuv_src
lean_flags() {
  printf '%s\n' -O2 -fwasm-exceptions -DLEAN_EMSCRIPTEN -DNDEBUG \
    -I "$cache/include" -I "$lean_src/src/include"
}
export -f lean_flags

# The flags, as an array: one flag per line, so a path may hold spaces.
read_flags() {
  flags=()
  while IFS= read -r flag; do
    flags+=("$flag")
  done < <(lean_flags)
}
export -f read_flags

# `emar` the objects into the archive $1 atomically: an archive that exists is
# complete, so an interrupted build is not mistaken for a finished one.
archive() {
  local out=$1
  shift
  rm -f "$out.tmp"
  emar rcs "$out.tmp" "$@"
  mv "$out.tmp" "$out"
}

# --- Lean's headers: its source's, with our config.h and its version ----------
mkdir -p "$cache/include/lean" "$cache/lib"
cp "$root/web/include/lean/config.h" "$cache/include/lean/config.h"
cp "$prefix/include/lean/version.h" "$cache/include/lean/version.h"
printf '#define LEAN_GITHASH "%s"\n' "$(lean --githash)" \
  > "$cache/include/githash.h"

# --- libuv --------------------------------------------------------------------
if [ ! -f "$cache/lib/libuv.a" ]; then
  echo "== libuv"
  rm -rf "$cache/libuv"
  emcmake cmake -S "$libuv_src" -B "$cache/libuv" -DCMAKE_BUILD_TYPE=Release \
    -DLIBUV_BUILD_TESTS=OFF -DLIBUV_BUILD_SHARED=OFF \
    -DCMAKE_C_FLAGS="-O2 -fwasm-exceptions -w" >/dev/null
  cmake --build "$cache/libuv" --target uv_a -j "$jobs" >/dev/null
  cp "$cache/libuv/libuv.a" "$cache/lib/libuv.a.tmp"
  mv "$cache/lib/libuv.a.tmp" "$cache/lib/libuv.a"
  rm -rf "$cache/libuv"
fi

# Each step below runs once per file, in parallel: xargs calls this script's
# functions through bash, each with one file.

# Compile one source of Lean's runtime, like `io.cpp`. `<mutex>` is included
# first: without threads, thread.h uses it but does not include it
# (lean4#15172), and only compiles while another header happens to.
compile_runtime() {
  read_flags
  em++ "${flags[@]}" -std=c++20 -DLEAN_EXPORTING -w -include mutex \
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
  local out=${1//\//_}
  read_flags
  emcc "${flags[@]}" -w -c "$cache/init-c/$1" -o "$cache/init-o/${out%.c}.o"
}
export -f compile_runtime init_to_c compile_init

# --- Lean's runtime -----------------------------------------------------------
# The sources src/runtime/CMakeLists.txt lists, without mimalloc, and without
# uv/*: those only back Std.Internal.UV, which nothing here uses, and their
# WebAssembly stubs do not compile (lean4#15181).
if [ ! -f "$cache/lib/libleanrt.a" ]; then
  echo "== Lean's runtime"
  rm -rf "$cache/runtime"
  mkdir -p "$cache/runtime"
  # shellcheck disable=SC2016 # the $1 is the inner bash's
  sed -n '/^set($/,/^)$/p' "$lean_src/src/runtime/CMakeLists.txt" \
    | grep '\.cpp$' | grep -v 'uv/' | tr -d ' ' \
    | xargs -P "$jobs" -n 1 bash -c 'compile_runtime "$1"' _
  archive "$cache/lib/libleanrt.a" "$cache"/runtime/*.o
  rm -rf "$cache/runtime"
fi

# --- Init, as C, then compiled ------------------------------------------------
if [ ! -f "$cache/lib/libInit.a" ]; then
  echo "== Init: Lean to C"
  rm -rf "$cache/init-c" "$cache/init-o"
  mkdir -p "$cache/init-c" "$cache/init-o"
  # shellcheck disable=SC2016 # the $1 is the inner bash's
  (cd "$prefix/src/lean" && { echo Init.lean; find Init -name '*.lean'; }) \
    | sed 's/\.lean$//' \
    | xargs -P "$jobs" -n 1 bash -c 'init_to_c "$1"' _
  echo "== Init: C to WebAssembly"
  # shellcheck disable=SC2016 # the $1 is the inner bash's
  (cd "$cache/init-c" && find . -name '*.c' | sed 's|^\./||') \
    | xargs -P "$jobs" -n 1 bash -c 'compile_init "$1"' _
  archive "$cache/lib/libInit.a" "$cache"/init-o/*.o
  rm -rf "$cache/init-c" "$cache/init-o"
fi

# --- The program's C ----------------------------------------------------------
if [ -n "$app_root" ]; then
  echo "== $app_root"
  lake build "$app_root" >/dev/null
else
  echo "== the bindings and the self-test"
  lake build WebGPURawWebTest Examples >/dev/null
fi
rm -rf "$app"
mkdir -p "$app" "$site"

# What a poke (WebGPU.Raw.Internal.Bytes) checks, as the lakefile defines it:
# nothing, unless WEBGPU_RAW_CHECK_POKES=1, the web's `-K checkPokes=true`, when
# it stops the program if its array is shared, or its store does not fit.
if [ "${WEBGPU_RAW_CHECK_POKES:-0}" = 1 ]; then
  fits='(o) <= lean_sarray_size(b) && (w) <= lean_sarray_size(b) - (o)'
  panic='lean_internal_panic("a poke into a shared array, or past its end")'
  check_poke="-DLEAN_WGPU_CHECK_POKE(b,o,w)=(lean_is_exclusive(b) && $fits"
  check_poke+=" ? (void)0 : $panic)"
  # And the hand-written C's checks of its Lean specification.
  checked=(-DLEAN_WGPU_CHECKED)
else
  check_poke='-DLEAN_WGPU_CHECK_POKE(b,o,w)=((void)0)'
  checked=()
fi
export check_poke

# Compile one module's C, like `WebGPU/Raw/Enums`, from the C Lake wrote into
# $ir, its package's (which compile_modules sets).
compile_module() {
  # shellcheck disable=SC2154 # compile_modules sets ir
  local c="$ir/$1.c"
  if [ ! -f "$c" ]; then
    echo "no C for $1 in $ir: is it built?" >&2
    return 1
  fi
  read_flags
  emcc "${flags[@]}" -w "$check_poke" -c "$c" -o "$app/${1//\//_}.o"
}
export -f compile_module
export app

# Compile the modules named on standard input, one source path per line (like
# `WebGPU/Raw/Enums.lean`), from the C Lake wrote into the package at $1.
compile_modules() {
  # shellcheck disable=SC2016 # the $1 is the inner bash's
  sed 's/\.lean$//' \
    | ir=$1/.lake/build/ir xargs -P "$jobs" -n 1 bash -c 'compile_module "$1"' _
}

# The modules in the sources, not every C file in .lake/build/ir, which may
# hold C of modules since removed: the bindings' and the window library's.
(cd "$root" && { find WebGPU -name '*.lean'; echo WebGPUWindow.lean; }) \
  | compile_modules "$root"

# The shims, against emdawnwebgpu's webgpu.h. They are told they are built
# against Dawn: those of functions wgpu-native leaves unimplemented then call
# them, rather than raise an IO error. Each object is named by its source's
# path, so that two sources of one name do not clash.
port=--use-port=emdawnwebgpu
compile_shims() {
  read_flags
  local f o
  for f in "$@"; do
    o=${f%.c}
    emcc "${flags[@]}" "$port" -DWEBGPU_RAW_DAWN "${checked[@]}" \
      -I "$root/c" -I "$root/c/generated" -c "$root/$f" \
      -o "$app/shim_${o//\//_}.o"
  done
}
(cd "$root" && compile_shims c/*.c c/generated/*.c window/c/*.c)

# Link the objects after $2 into the program $1 (`name.js`, with
# `name.wasm`), for the environments $2.
link() {
  local js=$1 environment=$2 log
  shift 2
  log=$app/$(basename "$js" .js).log
  echo "== link $(basename "$js")"
  em++ -o "$js" "$@" \
    "$cache/lib/libInit.a" "$cache/lib/libleanrt.a" "$cache/lib/libuv.a" \
    -O2 -fwasm-exceptions "$port" -sENVIRONMENT="$environment" \
    -sEXIT_RUNTIME=1 -sALLOW_MEMORY_GROWTH=1 -sSTACK_SIZE=8388608 2> "$log" \
    || { cat "$log" >&2; exit 1; }
  cat "$log" >&2
  # A call to a function whose C type differs from how it is called traps on
  # WebAssembly, so the linker's warning of one is an error here, except for
  # the two Lean v4.31.0's runtime has (lean4#16089), which nothing here calls.
  if grep "function signature mismatch" "$log" \
      | grep -v -e lean_io_create_tempfile -e lean_io_create_tempdir; then
    echo "web/build.sh: a function is called with the wrong C type" >&2
    exit 1
  fi
}

# What every program is linked with: the bindings, the window library and
# their C.
objects=("$app"/WebGPU_*.o "$app"/WebGPUWindow.o "$app"/shim_c_*.o
  "$app"/shim_window_*.o)
# Each program's own objects go into a directory of their own under it.
objs=$app

# --- A dependent's program ----------------------------------------------------
if [ -n "$app_root" ]; then
  mkdir -p "$objs/program"
  app=$objs/program
  { [ ! -f "$app_root.lean" ] || echo "$app_root.lean"
    [ ! -d "$app_root" ] || find "$app_root" -name '*.lean'; } \
    | compile_modules "$PWD"
  name=$(basename "$page" .html)
  link "$site/$name.js" web "${objects[@]}" "$app"/*.o
  cp "$page" "$site/$name.html"
  echo "Built $site"
  exit 0
fi

# --- The self-test ------------------------------------------------------------
# Its modules, and the native tests' modules it shares: the byte writers'
# differential test, and the encoding, relocation and callback checks; and the
# test helpers' C.
mkdir -p "$objs/test"
app=$objs/test
{
  find WebGPURawWebTest -name '*.lean'
  echo WebGPURawWebTest.lean
  echo WebGPURawTest/Internal/Bytes.lean
  echo WebGPURawTest/Internal/Callback.lean
  echo WebGPURawTest/Internal/Device.lean
  echo WebGPURawTest/Internal/Family.lean
  echo WebGPURawTest/Internal/Encode.lean
  echo WebGPURawTest/Internal/Reloc.lean
} | compile_modules "$root"
compile_shims WebGPURawTest/c/*.c
link "$site/webgpu-raw-web-test.js" web,node "${objects[@]}" "$app"/*.o
cp web/index.html "$site/index.html"

# --- The examples -------------------------------------------------------------
# Each a program of its own: its module, linked with what every program is
# (not the tests', nor the self-test's `main`), and its page.
mkdir -p "$objs/examples"
app=$objs/examples
# shellcheck disable=SC2043 # one example, so far
for example in Examples/Triangle; do
  name=$(basename "$example" | tr '[:upper:]' '[:lower:]')
  echo "$example.lean" | compile_modules "$root"
  link "$site/$name.js" web "${objects[@]}" "$app/${example//\//_}.o"
  cp "web/$name.html" "$site/$name.html"
done
echo "Built $site"
