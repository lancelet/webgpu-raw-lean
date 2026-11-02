#!/usr/bin/env sh
# Checks the built page in a headless browser: serves .lake/web/site, loads the
# page, and passes if it reports that all checks passed. (Node runs the program
# too, but only a browser runs the page around it.) Chrome or Chromium is
# $CHROME, by default the first of google-chrome, chromium found.
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

port=8765
node web/serve.mjs .lake/web/site "$port" >/dev/null &
server=$!
trap 'kill "$server"' EXIT
sleep 1

page=$("$chrome" --headless=new --no-sandbox --enable-unsafe-webgpu \
  --virtual-time-budget=30000 --dump-dom "http://localhost:$port/" 2>/dev/null)
# The page's output, as text.
echo "$page" | sed -n '/<pre id="out">/,/<\/pre>/p' | sed 's/<[^>]*>//g'
if echo "$page" | grep -q '<p id="status" class="ok">All checks passed.</p>'; then
  echo "OK: the page ran, and all its checks passed"
else
  echo "FAIL: the page did not report that all checks passed" >&2
  exit 1
fi
