# webgpu-headers (vendored spec)

The WebGPU native API specification these bindings are generated from.

- Source: <https://github.com/webgpu-native/webgpu-headers>
- Commit: `673658bc2bd70ec39fc55ebe6bb0173cf6d0a603` (2026-05-07), as pinned by wgpu-native v29.0.1.1

| File          | Purpose                                         |
|---------------|-------------------------------------------------|
| `webgpu.yml`  | The API definition: the source of truth         |
| `schema.json` | JSON Schema that `webgpu.yml` conforms to       |
| `LICENSE`     | Upstream licence (BSD-3-Clause)                 |

Do not edit these files by hand. To move to a new commit, edit
`WEBGPU_HEADERS_COMMIT` in `fetch.sh`, run it, review the diff, and update the
commit line above.
