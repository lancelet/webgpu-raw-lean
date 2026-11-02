// Serves a directory over HTTP, for the web build's page: a browser will not
// load WebAssembly from a file: URL.
//
//   node web/serve.mjs [directory] [port]     (default .lake/web/site, 8000)
import http from "node:http";
import fs from "node:fs";
import path from "node:path";

const root = path.resolve(process.argv[2] ?? ".lake/web/site");
const port = Number(process.argv[3] ?? 8000);
const types = {
  ".html": "text/html",
  ".js": "text/javascript",
  ".wasm": "application/wasm",
};

http.createServer((request, response) => {
  const url = new URL(request.url, "http://localhost");
  const file = path.join(root, url.pathname === "/" ? "index.html" : url.pathname);
  // Nothing outside the directory.
  if (!file.startsWith(root + path.sep)) {
    response.writeHead(403);
    response.end();
    return;
  }
  fs.readFile(file, (error, data) => {
    if (error) {
      response.writeHead(404);
      response.end();
      return;
    }
    const type = types[path.extname(file)] ?? "application/octet-stream";
    response.writeHead(200, { "content-type": type });
    response.end(data);
  });
}).listen(port, () => console.log(`Serving ${root} at http://localhost:${port}/`));
