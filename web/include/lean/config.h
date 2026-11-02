// Lean's runtime configuration for WebAssembly, in place of the one Lean's
// CMake build writes (src/config.h.in): no mimalloc, which needs threads, and
// Lean's own small allocator off, so the runtime uses malloc.
#pragma once
#include <lean/version.h>
#define LEAN_IS_STAGE0 0
