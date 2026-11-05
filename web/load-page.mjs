// Loads a page in headless Chrome and waits, in real time, until the program
// on it has ended: prints the page's output, then its status, and exits 0 if
// the status is a success. For web/check-page.sh; needs Node 22 or later.
//
//   node web/load-page.mjs chrome url [seconds]       (default 60 seconds)
//
// Not Chrome's --dump-dom with --virtual-time-budget: virtual time runs on
// while the page waits for the GPU, whose replies come in real time, so the
// page is dumped before a device's own callbacks have run.
import { spawn } from "node:child_process";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";

const [chrome, url, given] = process.argv.slice(2);
const seconds = Number(given ?? 60) || 60;
const deadline = Date.now() + seconds * 1000;
const profile = fs.mkdtempSync(path.join(os.tmpdir(), "load-page-"));
const browser = spawn(chrome, [
  "--headless=new", "--no-sandbox", "--enable-unsafe-webgpu",
  "--remote-debugging-port=0", `--user-data-dir=${profile}`, url,
], { stdio: ["ignore", "ignore", "pipe"] });
let log = "";
let exited = false;
let ending = false;
let socket;
browser.stderr.on("data", (chunk) => { log += chunk; });
browser.on("exit", () => { exited = true; });
browser.on("error", (error) => fail(`Chrome did not start: ${error}`));

const sleep = (ms) => new Promise((done) => setTimeout(done, ms));

// The end, once: close the connection, stop Chrome, remove its profile, and
// exit with `code`.
async function end(code) {
  if (ending) return;
  ending = true;
  socket?.close();
  if (!exited) {
    const gone = new Promise((done) => browser.once("exit", done));
    browser.kill();
    await Promise.race([gone, sleep(5000)]);
  }
  fs.rmSync(profile, { recursive: true, force: true });
  process.exit(code);
}

// Fail with `why`, and Chrome's log.
async function fail(why) {
  if (ending) return;
  console.error(`FAIL: ${why}`);
  console.error("Chrome's log:");
  console.error(log);
  await end(1);
}

// Wait until `found` gives something, failing with `what` at the deadline or
// if Chrome ends first.
async function until(what, found) {
  for (;;) {
    const value = await found();
    if (value) return value;
    if (exited) await fail(`Chrome ended before ${what}`);
    if (Date.now() > deadline) await fail(`no ${what} in ${seconds} seconds`);
    await sleep(200);
  }
}

// What `expression` evaluates to in the page, as JSON.
let next = 0;
const replies = new Map();
function evaluate(expression) {
  const id = ++next;
  socket.send(JSON.stringify({
    id, method: "Runtime.evaluate",
    params: { expression, returnByValue: true },
  }));
  return new Promise((done) => replies.set(id, done));
}

// The page's output and status, once the program's end gives the status a
// class (before, it may say only that the browser has no WebGPU).
const read = `(() => {
  const status = document.getElementById("status");
  return status && status.className && {
    output: document.getElementById("out").textContent,
    status: status.textContent,
    ok: status.className === "ok",
  };
})()`;

try {
  // Chrome's DevTools port, which it prints once listening.
  const port = await until("DevTools port", () =>
    log.match(/DevTools listening on ws:\/\/[^:]+:(\d+)\//)?.[1]);
  // The page's own connection, to evaluate expressions in it.
  const page = await until("page", async () => {
    const list = await fetch(`http://127.0.0.1:${port}/json/list`);
    return (await list.json())
      .find((t) => t.type === "page" && t.url.startsWith(url));
  });
  socket = new WebSocket(page.webSocketDebuggerUrl);
  await new Promise((done, failed) => {
    socket.onopen = done;
    socket.onerror = () => failed(new Error("no DevTools connection"));
  });
  socket.onclose = () => fail("the DevTools connection closed");
  socket.onmessage = (event) => {
    const message = JSON.parse(event.data);
    replies.get(message.id)?.(message.result?.result?.value);
    replies.delete(message.id);
  };
  // Its output so far, printed if it does not end: where it stopped.
  const output = `document.getElementById("out").textContent`;
  const state = await until("end of the program", async () => {
    const value = await evaluate(read);
    if (!value && Date.now() > deadline) {
      process.stdout.write(await evaluate(output) ?? "");
    }
    return value;
  });
  process.stdout.write(state.output);
  console.log(`Its status: ${state.status}`);
  if (!state.ok) await fail("the page did not report that all checks passed");
  await end(0);
} catch (error) {
  await fail(String(error));
}
