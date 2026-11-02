#!/usr/bin/env sh
# Checks the built page in a headless browser: serves .lake/web/site, loads the
# page, and passes if it reports that all checks passed. (Node runs the program
# too, but only a browser runs the page around it.) Chrome or Chromium is
# $CHROME, by default the first of google-chrome, chromium found; the server's
# port is $PORT, by default 8765.
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
tmp=$(mktemp -d)
node web/serve.mjs .lake/web/site "$port" >/dev/null &
server=$!
trap 'kill "$server"; rm -rf "$tmp"' EXIT

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

"$chrome" --headless=new --no-sandbox --enable-unsafe-webgpu \
  --virtual-time-budget=30000 --dump-dom "$url" \
  > "$tmp/page.html" 2> "$tmp/chrome.log" || true
# The page's output, as text.
sed -n '/<pre id="out">/,/<\/pre>/p' "$tmp/page.html" \
  | sed 's/<pre id="out">//; s/<[^>]*>//g'
passed='<p id="status" class="ok">All checks passed.</p>'
if grep -q "$passed" "$tmp/page.html"; then
  echo "OK: the page ran, and all its checks passed"
else
  echo "FAIL: the page did not report that all checks passed" >&2
  echo "Chrome's log:" >&2
  cat "$tmp/chrome.log" >&2
  exit 1
fi
