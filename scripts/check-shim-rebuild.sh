#!/bin/sh
# Checks the build itself: editing a header the C shims include must rebuild
# them, or shims built against an old header would be linked silently.
# (A regression test: the headers' traces were once dropped.) Linux only.
set -eu
cd "$(dirname "$0")/.."
obj=.lake/build/c/generated/objects.o
header=c/generated/objects.h
lake build webgpu-raw-test >/dev/null
before=$(stat -c %Y "$obj")
sleep 1
cp "$header" "$header.orig"
trap 'mv "$header.orig" "$header"' EXIT
echo "// edited" >> "$header"
lake build webgpu-raw-test >/dev/null
after=$(stat -c %Y "$obj")
if [ "$before" = "$after" ]; then
  echo "FAIL: editing $header did not rebuild $obj" >&2
  exit 1
fi
echo "OK: editing $header rebuilt $obj"
