#!/usr/bin/env sh
# Fetch SDL3, which the window library (WebGPUWindow) uses natively, into
# vendor/sdl3/<platform>/: its headers in include/, and the shared library in
# lib/ (on Windows, SDL3.dll in bin/ and its import library in lib/). On
# Linux and macOS it is built from the release's source, with cmake; on
# Windows, MinGW's prebuilt release is unpacked. The download is gitignored.
# Lake runs this before building the window library; it does nothing if this
# version is already there.
#
# On Linux, SDL needs the headers of the window systems it talks to at build
# time (it loads their libraries at run time): X11's and Wayland's, as CI
# installs them (see .github/workflows/ci.yml). On NixOS:
#
#     nix develop nixpkgs#sdl3 -c vendor/sdl3/fetch.sh
set -eu

version=3.4.18
# The build's options' version, below: changed when they change, so that a
# checkout builds SDL3 again.
options=2
dir=$(cd "$(dirname "$0")" && pwd)

case "$(uname -s)" in
  Linux)                os=linux ;;
  Darwin)               os=macos ;;
  MINGW*|MSYS*|CYGWIN*) os=windows ;;
  *) echo "FAIL: no SDL3 for $(uname -s)" >&2; exit 1 ;;
esac
case "$(uname -m)" in
  aarch64|arm64) arch=aarch64 ;;
  *)             arch=x86_64 ;;
esac
out="$dir/$os-$arch"

if [ -f "$out/.complete-$version-$options" ]; then
  echo "SDL3 $version already in $out"
  exit 0
fi

release=https://github.com/libsdl-org/SDL/releases/download/release-$version
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
rm -rf "$out"
mkdir -p "$out"

if [ "$os" = windows ]; then
  url=$release/SDL3-devel-$version-mingw.tar.gz
  echo "Downloading $url"
  curl -fsSL --retry 3 "$url" -o "$tmp/sdl3.tar.gz"
  tar -xzf "$tmp/sdl3.tar.gz" -C "$tmp"
  cp -R "$tmp/SDL3-$version/x86_64-w64-mingw32/include" "$out/"
  cp -R "$tmp/SDL3-$version/x86_64-w64-mingw32/lib" "$out/"
  cp -R "$tmp/SDL3-$version/x86_64-w64-mingw32/bin" "$out/"
else
  url=$release/SDL3-$version.tar.gz
  echo "Downloading $url"
  curl -fsSL --retry 3 "$url" -o "$tmp/sdl3.tar.gz"
  tar -xzf "$tmp/sdl3.tar.gz" -C "$tmp"
  # Only what a window needs: no audio, cameras, joysticks and the like,
  # whose system libraries a program would otherwise need too; and the 2D
  # renderer, for its software renderer alone (`textImage`), with none of
  # its GPU backends.
  cmake -S "$tmp/SDL3-$version" -B "$tmp/build" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$out" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DSDL_SHARED=ON -DSDL_STATIC=OFF -DSDL_TEST_LIBRARY=OFF \
    -DSDL_EXAMPLES=OFF -DSDL_TESTS=OFF \
    -DSDL_AUDIO=OFF -DSDL_CAMERA=OFF -DSDL_JOYSTICK=OFF -DSDL_HAPTIC=OFF \
    -DSDL_HIDAPI=OFF -DSDL_SENSOR=OFF -DSDL_POWER=OFF -DSDL_GPU=OFF \
    -DSDL_RENDER=ON -DSDL_RENDER_GPU=OFF -DSDL_RENDER_VULKAN=OFF \
    -DSDL_RENDER_METAL=OFF -DSDL_DIALOG=OFF -DSDL_TRAY=OFF
  cmake --build "$tmp/build" --parallel
  cmake --install "$tmp/build"
fi
touch "$out/.complete-$version-$options"
echo "SDL3 $version in $out"
