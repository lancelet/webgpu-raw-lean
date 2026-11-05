#!/usr/bin/env sh
# Checks the built page in a headless browser: serves .lake/web/site, loads the
# page, and passes if it reports that all checks passed. (Node runs the program
# too, but only a browser runs the page around it.) Chrome or Chromium is
# $CHROME, by default the first of google-chrome, chromium found; the server's
# port is $PORT, by default 8765. If $WEBGPU_RAW_REQUIRE_ADAPTER is set (as in
# CI), the browser must have found an adapter, and checked a device.
set -eu
cd "$(dirname "$0")/.."

chrome=${CHROME:-}
if [ -z "$chrome" ]; then
  for c in google-chrome chromium; do
    if command -v "$c" >/dev/null; then chrome=$c; break; fi
  done
fi
if [ -z "$chrome" ]; then
  echo "FAIL: no Chrome or Chromium found (set CHROME)" >&2
  exit 1
fi

port=${PORT:-8765}
url="http://localhost:$port/"
tmp=$(mktemp)
node web/serve.mjs .lake/web/site "$port" >/dev/null &
server=$!
trap 'kill "$server"; rm -f "$tmp"' EXIT

# Wait for the server: up to ten seconds.
tries=0
until node -e "fetch('$url').then(() => {}, () => process.exit(1))"; do
  tries=$((tries + 1))
  if [ "$tries" -ge 50 ]; then
    echo "FAIL: the server did not start at $url" >&2
    exit 1
  fi
  sleep 0.2
done

# The page, until its program ends: its output and status, and a failure
# unless it reports that all checks passed (web/load-page.mjs).
loaded=0
node web/load-page.mjs "$chrome" "$url" > "$tmp" 2>&1 || loaded=$?
cat "$tmp"
if [ "$loaded" -ne 0 ]; then
  exit 1
fi
if [ -n "${WEBGPU_RAW_REQUIRE_ADAPTER:-}" ] \
    && grep -q "^note: no adapter" "$tmp"; then
  echo "FAIL: no adapter, though one is required" >&2
  exit 1
fi
echo "OK: the page ran, and all its checks passed"
