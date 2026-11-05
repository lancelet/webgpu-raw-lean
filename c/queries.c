// What an adapter, a device or the instance supports, written by hand
// (`WebGPU/Raw/Queries.lean`): structs C fills, which Lean is given as words
// and strings, those whose members C allocates freed by their
// `FreeMembers` in the call. Each call is bracketed, as every shim's is.

#include <stdint.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "callback.h"
#include "generated/objects.h"

// The Lean pair `(a, b)`, taking both.
static lean_obj_res lean_wgpu_pair(lean_obj_arg a, lean_obj_arg b) {
    lean_object * pair = lean_alloc_ctor(0, 2, 0);
    lean_ctor_set(pair, 0, a);
    lean_ctor_set(pair, 1, b);
    return pair;
}

// An IO error with `message`.
static lean_obj_res lean_wgpu_query_error(char const * message) {
    return lean_io_result_mk_error(
        lean_mk_io_user_error(lean_mk_string(message)));
}

// `count` codes from `codes`, an array of an enum (4 bytes each, as every
// enum has a member of 0x7FFFFFFF), as a Lean `Array UInt32`.
#define LEAN_WGPU_CODES(count, codes) \
    lean_wgpu_codes((count), (uint32_t const *)(codes))

static lean_obj_res lean_wgpu_codes(size_t count, uint32_t const * codes) {
    lean_object * array = lean_alloc_array(count, count);
    for (size_t k = 0; k < count; k++) {
        lean_array_set_core(array, k, lean_box_uint32(codes[k]));
    }
    return array;
}

// Limits: the status and the limits' words.

LEAN_EXPORT lean_obj_res lean_wgpu_adapter_get_limits(b_lean_obj_arg adapter) {
    WGPULimits limits = WGPU_LIMITS_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUStatus status =
        wgpuAdapterGetLimits(lean_wgpu_adapter_unbox(adapter), &limits);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(
        lean_wgpu_pair(lean_box_uint32((uint32_t)status),
            lean_wgpu_Limits_words(&limits))));
}

LEAN_EXPORT lean_obj_res lean_wgpu_device_get_limits(b_lean_obj_arg device) {
    WGPULimits limits = WGPU_LIMITS_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUStatus status =
        wgpuDeviceGetLimits(lean_wgpu_device_unbox(device), &limits);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(
        lean_wgpu_pair(lean_box_uint32((uint32_t)status),
            lean_wgpu_Limits_words(&limits))));
}

// Lean passes its `Unit` argument.
LEAN_EXPORT lean_obj_res lean_wgpu_get_instance_limits(b_lean_obj_arg unit) {
    (void)unit;
    WGPUInstanceLimits limits = WGPU_INSTANCE_LIMITS_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUStatus status = wgpuGetInstanceLimits(&limits);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(
        lean_wgpu_pair(lean_box_uint32((uint32_t)status),
            lean_wgpu_InstanceLimits_words(&limits))));
}

// Features: their codes.

LEAN_EXPORT lean_obj_res lean_wgpu_adapter_get_features(
        b_lean_obj_arg adapter) {
    WGPUSupportedFeatures features = WGPU_SUPPORTED_FEATURES_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuAdapterGetFeatures(lean_wgpu_adapter_unbox(adapter), &features);
    lean_object * codes =
        LEAN_WGPU_CODES(features.featureCount, features.features);
    wgpuSupportedFeaturesFreeMembers(features);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(codes));
}

LEAN_EXPORT lean_obj_res lean_wgpu_device_get_features(b_lean_obj_arg device) {
    WGPUSupportedFeatures features = WGPU_SUPPORTED_FEATURES_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuDeviceGetFeatures(lean_wgpu_device_unbox(device), &features);
    lean_object * codes =
        LEAN_WGPU_CODES(features.featureCount, features.features);
    wgpuSupportedFeaturesFreeMembers(features);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(codes));
}

// wgpu-native leaves this, and freeing its members, unimplemented.
LEAN_EXPORT lean_obj_res lean_wgpu_get_instance_features(b_lean_obj_arg unit) {
    (void)unit;
#ifdef WEBGPU_RAW_DAWN
    WGPUSupportedInstanceFeatures features =
        WGPU_SUPPORTED_INSTANCE_FEATURES_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuGetInstanceFeatures(&features);
    lean_object * codes =
        LEAN_WGPU_CODES(features.featureCount, features.features);
    wgpuSupportedInstanceFeaturesFreeMembers(features);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(codes));
#else
    return lean_wgpu_query_error(
        "getInstanceFeatures: not implemented by wgpu-native");
#endif
}

// wgpu-native leaves this, and freeing its members, unimplemented.
LEAN_EXPORT lean_obj_res lean_wgpu_instance_get_wgsl_language_features(
        b_lean_obj_arg instance) {
#ifdef WEBGPU_RAW_DAWN
    WGPUSupportedWGSLLanguageFeatures features =
        WGPU_SUPPORTED_WGSL_LANGUAGE_FEATURES_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    wgpuInstanceGetWGSLLanguageFeatures(
        lean_wgpu_instance_unbox(instance), &features);
    lean_object * codes =
        LEAN_WGPU_CODES(features.featureCount, features.features);
    wgpuSupportedWGSLLanguageFeaturesFreeMembers(features);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(codes));
#else
    (void)instance;
    return lean_wgpu_query_error(
        "Instance.getWGSLLanguageFeatures: not implemented by wgpu-native");
#endif
}

// An adapter's information: the status, its four strings, and its words
// (its backend type's and adapter type's codes, then its vendor's and
// device's IDs, then its subgroups' least and greatest sizes). A status
// other than success leaves the struct as `WGPU_ADAPTER_INFO_INIT` made it,
// which its `FreeMembers` frees nothing of.

static lean_obj_res lean_wgpu_info(WGPUStatus status, WGPUAdapterInfo info) {
    lean_object * strings = lean_alloc_array(4, 4);
    lean_array_set_core(strings, 0, lean_wgpu_string_of_view(info.vendor));
    lean_array_set_core(strings, 1,
        lean_wgpu_string_of_view(info.architecture));
    lean_array_set_core(strings, 2, lean_wgpu_string_of_view(info.device));
    lean_array_set_core(strings, 3,
        lean_wgpu_string_of_view(info.description));
    uint32_t values[6] = {
        (uint32_t)info.backendType, (uint32_t)info.adapterType,
        info.vendorID, info.deviceID,
        info.subgroupMinSize, info.subgroupMaxSize
    };
    lean_object * words = lean_wgpu_codes(6, values);
    return lean_wgpu_pair(lean_box_uint32((uint32_t)status),
        lean_wgpu_pair(strings, words));
}

LEAN_EXPORT lean_obj_res lean_wgpu_adapter_get_info(b_lean_obj_arg adapter) {
    WGPUAdapterInfo info = WGPU_ADAPTER_INFO_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUStatus status =
        wgpuAdapterGetInfo(lean_wgpu_adapter_unbox(adapter), &info);
    lean_object * result = lean_wgpu_info(status, info);
    wgpuAdapterInfoFreeMembers(info);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(result));
}

// wgpu-native leaves this unimplemented.
LEAN_EXPORT lean_obj_res lean_wgpu_device_get_adapter_info(
        b_lean_obj_arg device) {
#ifdef WEBGPU_RAW_DAWN
    WGPUAdapterInfo info = WGPU_ADAPTER_INFO_INIT;
    lean_object * saved = lean_wgpu_callbacks_enter();
    WGPUStatus status =
        wgpuDeviceGetAdapterInfo(lean_wgpu_device_unbox(device), &info);
    lean_object * result = lean_wgpu_info(status, info);
    wgpuAdapterInfoFreeMembers(info);
    return lean_wgpu_callbacks_leave(saved, lean_io_result_mk_ok(result));
#else
    (void)device;
    return lean_wgpu_query_error(
        "Device.getAdapterInfo: not implemented by wgpu-native");
#endif
}
