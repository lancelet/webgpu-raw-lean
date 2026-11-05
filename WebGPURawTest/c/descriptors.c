// Structs as C lays them out, for the tests to compare encoding with: each is
// filled in C, its pointers NULL, and returned as its bytes.

#include <string.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>

// The bytes of `size` bytes at `data`, as a new Lean byte array.
static lean_obj_res lean_wgpu_test_bytes(void const * data, size_t size) {
    lean_obj_res bytes = lean_alloc_sarray(1, size, size);
    memcpy(lean_sarray_cptr(bytes), data, size);
    return bytes;
}

// A buffer descriptor with these fields, no chain, and a label of `labelLength`
// bytes at NULL; its padding zero, as encoding leaves it.
LEAN_EXPORT lean_obj_res lean_wgpu_test_buffer_descriptor(
        uint64_t usage, uint64_t size, uint32_t mappedAtCreation,
        size_t labelLength) {
    WGPUBufferDescriptor descriptor;
    memset(&descriptor, 0, sizeof descriptor);
    descriptor.nextInChain = NULL;
    descriptor.label.data = NULL;
    descriptor.label.length = labelLength;
    descriptor.usage = usage;
    descriptor.size = size;
    descriptor.mappedAtCreation = mappedAtCreation;
    return lean_wgpu_test_bytes(&descriptor, sizeof descriptor);
}

// A depth-stencil state with every kind of field but a pointer: enums, an
// optional bool, nested structs, a negative integer and floats; no chain.
LEAN_EXPORT lean_obj_res lean_wgpu_test_depth_stencil_state(lean_obj_arg unit) {
    (void) unit;
    WGPUDepthStencilState state;
    memset(&state, 0, sizeof state);
    state.nextInChain              = NULL;
    state.format                   = WGPUTextureFormat_Depth24PlusStencil8;
    state.depthWriteEnabled        = WGPUOptionalBool_True;
    state.depthCompare             = WGPUCompareFunction_Less;
    state.stencilFront.compare     = WGPUCompareFunction_Always;
    state.stencilFront.failOp      = WGPUStencilOperation_Keep;
    state.stencilFront.depthFailOp = WGPUStencilOperation_Replace;
    state.stencilFront.passOp      = WGPUStencilOperation_IncrementClamp;
    state.stencilBack.compare      = WGPUCompareFunction_Never;
    state.stencilBack.failOp       = WGPUStencilOperation_Zero;
    state.stencilBack.depthFailOp  = WGPUStencilOperation_Invert;
    state.stencilBack.passOp       = WGPUStencilOperation_DecrementWrap;
    state.stencilReadMask          = 0xFF;
    state.stencilWriteMask         = 0x0F;
    state.depthBias                = -3;
    state.depthBiasSlopeScale      = 1.5f;
    state.depthBiasClamp           = -0.25f;
    return lean_wgpu_test_bytes(&state, sizeof state);
}

// A WGSL source: its chain's sType, no next, and code of `codeLength` bytes
// at NULL.
LEAN_EXPORT lean_obj_res lean_wgpu_test_shader_source_wgsl(size_t codeLength) {
    WGPUShaderSourceWGSL source;
    memset(&source, 0, sizeof source);
    source.chain.next  = NULL;
    source.chain.sType = WGPUSType_ShaderSourceWGSL;
    source.code.data   = NULL;
    source.code.length = codeLength;
    return lean_wgpu_test_bytes(&source, sizeof source);
}

// Instance limits with this count, no chain.
LEAN_EXPORT lean_obj_res lean_wgpu_test_instance_limits(
        size_t timedWaitAnyMaxCount) {
    WGPUInstanceLimits limits;
    memset(&limits, 0, sizeof limits);
    limits.nextInChain          = NULL;
    limits.timedWaitAnyMaxCount = timedWaitAnyMaxCount;
    return lean_wgpu_test_bytes(&limits, sizeof limits);
}

// The addresses the generated bindings give of the device's callbacks'
// trampolines, and of their own uncaptured-error handler (0 on the web).
uint64_t lean_WGPUDeviceLostCallback_address(b_lean_obj_arg unit);
uint64_t lean_WGPUUncapturedErrorCallback_address(b_lean_obj_arg unit);
uint64_t lean_WGPUUncapturedErrorCallback_default_address(b_lean_obj_arg unit);

// A device descriptor of defaults, its labels empty, no chain, with both
// callbacks if `withCallbacks` (lost registered `allowSpontaneous`), as the
// encoder writes it, its pointers NULL: each callback's function its
// trampoline, its second userdata its ordinal (lost 0, uncaptured error 1);
// with none, the uncaptured error's function the bindings' own handler.
LEAN_EXPORT lean_obj_res lean_wgpu_test_device_descriptor(
        uint8_t withCallbacks) {
    WGPUDeviceDescriptor descriptor;
    memset(&descriptor, 0, sizeof descriptor);
    if (withCallbacks) {
        descriptor.deviceLostCallbackInfo.mode =
            WGPUCallbackMode_AllowSpontaneous;
        descriptor.deviceLostCallbackInfo.callback = (WGPUDeviceLostCallback)
            (uintptr_t)lean_WGPUDeviceLostCallback_address(lean_box(0));
        descriptor.uncapturedErrorCallbackInfo.callback =
            (WGPUUncapturedErrorCallback)(uintptr_t)
                lean_WGPUUncapturedErrorCallback_address(lean_box(0));
        descriptor.uncapturedErrorCallbackInfo.userdata2 = (void *)1;
    } else {
        descriptor.uncapturedErrorCallbackInfo.callback =
            (WGPUUncapturedErrorCallback)(uintptr_t)
                lean_WGPUUncapturedErrorCallback_default_address(lean_box(0));
    }
    return lean_wgpu_test_bytes(&descriptor, sizeof descriptor);
}
