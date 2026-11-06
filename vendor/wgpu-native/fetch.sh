#!/usr/bin/env sh
# Fetch the prebuilt wgpu-native release for this platform into
# vendor/wgpu-native/<platform>/ (include/ and lib/). The downloads are
# gitignored. Lake runs this before building anything that needs wgpu-native;
# it does nothing if that release is already there.
#
# Usage: fetch.sh [platform]
#   platform: linux-x86_64 | linux-aarch64 | macos-x86_64 | macos-aarch64 |
#             windows-x86_64 (detected from uname if omitted)
# Set WGPU_BUILD=debug for the debug build (default: release).
#
# To update: change WGPU_NATIVE_VERSION and keep vendor/webgpu-headers in step.
set -eu

WGPU_NATIVE_VERSION=v29.0.1.1
build=${WGPU_BUILD:-release}
dir=$(cd "$(dirname "$0")" && pwd)

detect() {
  os=$(uname -s)
  arch=$(uname -m)
  case "$arch" in
    x86_64|amd64) arch=x86_64 ;;
    aarch64|arm64) arch=aarch64 ;;
    *) echo "unsupported arch: $arch" >&2; exit 1 ;;
  esac
  case "$os" in
    Linux) echo "linux-$arch" ;;
    Darwin) echo "macos-$arch" ;;
    MINGW*|MSYS*|CYGWIN*|Windows_NT) echo "windows-$arch" ;;
    *) echo "unsupported OS: $os" >&2; exit 1 ;;
  esac
}

platform=${1:-$(detect)}
case "$platform" in
  linux-x86_64|linux-aarch64|macos-x86_64|macos-aarch64)
    asset="wgpu-$platform-$build.zip" ;;
  # Lean's Windows toolchain is MinGW-based, so use the gnu build there.
  # (Lean has no Windows Arm toolchain, and wgpu-native no gnu build for it.)
  windows-x86_64) asset="wgpu-windows-x86_64-gnu-$build.zip" ;;
  *) echo "unknown platform: $platform" >&2; exit 1 ;;
esac

releases=https://github.com/gfx-rs/wgpu-native/releases/download
url="$releases/$WGPU_NATIVE_VERSION/$asset"
out="$dir/$platform"
if [ "$(cat "$out/VERSION" 2>/dev/null)" = "$WGPU_NATIVE_VERSION $asset" ]; then
  echo "wgpu-native $WGPU_NATIVE_VERSION ($asset) already in $out"
  exit 0
fi
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Downloading $url"
curl -fsSL "$url" -o "$tmp/$asset"
# Unpacked beside $out, then moved into place whole: a second build fetching
# at the same time never sees half a release (if one, briefly, none).
new=$(mktemp -d "$out.new.XXXXXX")
trap 'rm -rf "$tmp" "$new"' EXIT
# Git Bash on Windows may lack unzip; its tar (bsdtar) reads zips.
if command -v unzip >/dev/null; then
  unzip -q "$tmp/$asset" -d "$new"
else
  tar -xf "$tmp/$asset" -C "$new"
fi
echo "$WGPU_NATIVE_VERSION $asset" > "$new/VERSION"
rm -rf "$out"
mv "$new" "$out"
echo "Fetched wgpu-native $WGPU_NATIVE_VERSION ($asset) into $out"
