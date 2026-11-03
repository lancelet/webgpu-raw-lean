// Filling in pointers (c/reloc.c), for the tests to check: each helper fills
// bytes Lean gives it by a table Lean gives it, then checks, or returns, what
// it filled them with.

#include <string.h>
#include <lean/lean.h>
#include <webgpu/webgpu.h>
#include "reloc.h"

// The pointer at `offset` in `data`.
static void * lean_wgpu_test_pointer(uint8_t const * data, size_t offset) {
    void * pointer;
    memcpy(&pointer, data + offset, sizeof pointer);
    return pointer;
}

// A string target's string, of target `i`.
static char const * lean_wgpu_test_string(b_lean_obj_arg targets, size_t i) {
    lean_object * value = lean_ctor_get(lean_array_get_core(targets, i), 0);
    if (!lean_is_string(value)) {
        value = lean_ctor_get(value, 0);  // an optional string's some
    }
    return lean_string_cstr(value);
}

// The bytes of target `i`, a block.
static uint8_t * lean_wgpu_test_block(b_lean_obj_arg targets, size_t i) {
    return lean_sarray_cptr(
        lean_ctor_get(lean_array_get_core(targets, i), 0));
}

// Fill `bytes` by table 0 of `WebGPURawTest.Internal.Reloc.everyKind`: a
// pointer every 8 bytes, to a string, an optional string, an object, an
// optional object, and a block of two elements of 32 bytes (table 1), each a
// string, an optional object, a block of 16 bytes with no pointers (table 2),
// and a pointer left null, which takes no target. If `some`, each optional is
// some but the second element's, and the second element's block empty; if not,
// each optional is none and the first block empty. The message of the first
// pointer that is not what it should be, or "".
LEAN_EXPORT lean_obj_res lean_wgpu_test_fill_every_kind(
        lean_obj_arg bytes, b_lean_obj_arg tables, b_lean_obj_arg targets,
        b_lean_obj_arg instance, uint8_t some) {
    size_t cursor = 0;
    uint8_t * data = lean_sarray_cptr(bytes);
    lean_wgpu_fill(data, lean_sarray_size(bytes), tables, 0, targets, &cursor);
    void * handle = lean_get_external_data(instance);
    char const * problem = "";
    uint8_t const * block = lean_wgpu_test_pointer(data, 32);
    if (lean_wgpu_test_pointer(data, 0) != lean_wgpu_test_string(targets, 0)) {
        problem = "the string";
    } else if (lean_wgpu_test_pointer(data, 8)
            != (some ? lean_wgpu_test_string(targets, 1) : NULL)) {
        problem = "the optional string";
    } else if (lean_wgpu_test_pointer(data, 16) != handle) {
        problem = "the object";
    } else if (lean_wgpu_test_pointer(data, 24) != (some ? handle : NULL)) {
        problem = "the optional object";
    } else if (!some) {
        if (block != NULL) {
            problem = "the empty block, not null";
        }
    } else if (block != lean_wgpu_test_block(targets, 4)) {
        problem = "the block";
    } else if (lean_wgpu_test_pointer(block, 0)
            != lean_wgpu_test_string(targets, 5)
            || lean_wgpu_test_pointer(block, 32)
                != lean_wgpu_test_string(targets, 8)) {
        problem = "the elements' strings";
    } else if (lean_wgpu_test_pointer(block, 8) != handle
            || lean_wgpu_test_pointer(block, 40) != NULL) {
        problem = "the elements' optional objects";
    } else if (lean_wgpu_test_pointer(block, 16)
            != lean_wgpu_test_block(targets, 7)
            || lean_wgpu_test_pointer(block, 48) != NULL) {
        problem = "the elements' blocks";
    } else if (lean_wgpu_test_pointer(block, 24) != NULL
            || lean_wgpu_test_pointer(block, 56) != NULL) {
        problem = "the elements' null pointers";
    }
    if (*problem == '\0' && cursor != lean_array_size(targets)) {
        problem = "the targets, not all taken";
    }
    lean_dec(bytes);
    return lean_mk_string(problem);
}

// Fill an encoded buffer descriptor by table `table`, then read its label back,
// as WebGPU would, by its pointer and length; "(not a buffer descriptor)" if
// its other fields are not those of `WebGPURawTest.Internal.Encode.descriptor`.
LEAN_EXPORT lean_obj_res lean_wgpu_test_buffer_descriptor_label(
        lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets) {
    lean_wgpu_fill_struct(lean_sarray_cptr(bytes), lean_sarray_size(bytes),
        tables, table, targets);
    WGPUBufferDescriptor descriptor;
    memcpy(&descriptor, lean_sarray_cptr(bytes), sizeof descriptor);
    lean_obj_res label =
        descriptor.nextInChain != NULL || descriptor.usage != 0x28
            || descriptor.size != 0x10000 || !descriptor.mappedAtCreation
        ? lean_mk_string("(not a buffer descriptor)")
        : lean_mk_string_from_bytes(descriptor.label.data,
            descriptor.label.length);
    lean_dec(bytes);
    return label;
}

// Fill an encoded color target state by table `table`, then check it as
// WebGPU would read it: `WebGPURawTest.Internal.Reloc.colorTarget`, its blend
// state behind its pointer if `some`, else null. The first field that is not
// what it should be, or "".
LEAN_EXPORT lean_obj_res lean_wgpu_test_color_target_state(
        lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets, uint8_t some) {
    lean_wgpu_fill_struct(lean_sarray_cptr(bytes), lean_sarray_size(bytes),
        tables, table, targets);
    WGPUColorTargetState state;
    memcpy(&state, lean_sarray_cptr(bytes), sizeof state);
    WGPUBlendState const * blend = state.blend;
    char const * problem = "";
    if (state.nextInChain != NULL) {
        problem = "the chain";
    } else if (state.format != WGPUTextureFormat_RGBA8Unorm
            || state.writeMask != WGPUColorWriteMask_All) {
        problem = "the format or write mask";
    } else if (!some) {
        if (blend != NULL) {
            problem = "the blend state, not null";
        }
    } else if (blend == NULL) {
        problem = "the blend state, null";
    } else if (blend->color.operation != WGPUBlendOperation_Subtract
            || blend->color.srcFactor != WGPUBlendFactor_SrcAlpha
            || blend->color.dstFactor != WGPUBlendFactor_OneMinusSrcAlpha) {
        problem = "the blend state's color";
    } else if (blend->alpha.operation != WGPUBlendOperation_Max
            || blend->alpha.srcFactor != WGPUBlendFactor_One
            || blend->alpha.dstFactor != WGPUBlendFactor_Zero) {
        problem = "the blend state's alpha";
    }
    lean_dec(bytes);
    return lean_mk_string(problem);
}

// Fill an encoded bind group entry by table `table`, then check it as WebGPU
// would read it: `WebGPURawTest.Internal.Reloc.bindGroupEntry`, its three
// optional objects none, each a target, so all three taken. The first field
// that is not what it should be, or "".
LEAN_EXPORT lean_obj_res lean_wgpu_test_bind_group_entry(
        lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets) {
    size_t cursor = 0;
    lean_wgpu_fill(lean_sarray_cptr(bytes), lean_sarray_size(bytes), tables,
        table, targets, &cursor);
    WGPUBindGroupEntry entry;
    memcpy(&entry, lean_sarray_cptr(bytes), sizeof entry);
    char const * problem = "";
    if (entry.nextInChain != NULL) {
        problem = "the chain";
    } else if (entry.binding != 3 || entry.offset != 256
            || entry.size != 1024) {
        problem = "the binding, offset or size";
    } else if (entry.buffer != NULL || entry.sampler != NULL
            || entry.textureView != NULL) {
        problem = "the objects, not null";
    } else if (cursor != 3) {
        problem = "the targets, not the three objects";
    }
    lean_dec(bytes);
    return lean_mk_string(problem);
}

// Fill an encoded instance descriptor by table `table`, then check it as
// WebGPU would read it: `WebGPURawTest.Internal.Reloc.instanceDescriptor`, its
// features an array of enums and its limits a block, if `full`; else none of
// either. The first field that is not what it should be, or "".
LEAN_EXPORT lean_obj_res lean_wgpu_test_instance_descriptor(
        lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets, uint8_t full) {
    lean_wgpu_fill_struct(lean_sarray_cptr(bytes), lean_sarray_size(bytes),
        tables, table, targets);
    WGPUInstanceDescriptor descriptor;
    memcpy(&descriptor, lean_sarray_cptr(bytes), sizeof descriptor);
    WGPUInstanceFeatureName const * features = descriptor.requiredFeatures;
    WGPUInstanceLimits const * limits = descriptor.requiredLimits;
    char const * problem = "";
    if (descriptor.nextInChain != NULL) {
        problem = "the chain";
    } else if (!full) {
        if (descriptor.requiredFeatureCount != 0 || features != NULL) {
            problem = "the features, not none";
        } else if (limits != NULL) {
            problem = "the limits, not null";
        }
    } else if (descriptor.requiredFeatureCount != 2 || features == NULL
            || features[0] != WGPUInstanceFeatureName_ShaderSourceSPIRV
            || features[1] != WGPUInstanceFeatureName_TimedWaitAny) {
        problem = "the features";
    } else if (limits == NULL || limits->nextInChain != NULL
            || limits->timedWaitAnyMaxCount != 7) {
        problem = "the limits";
    }
    lean_dec(bytes);
    return lean_mk_string(problem);
}

// Fill an encoded bind group layout descriptor by table `table`, then check it
// as WebGPU would read it: `WebGPURawTest.Internal.Reloc.bindGroupLayout`, its
// label and its two entries, an array of structs. The first field that is not
// what it should be, or "".
LEAN_EXPORT lean_obj_res lean_wgpu_test_bind_group_layout(
        lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets) {
    lean_wgpu_fill_struct(lean_sarray_cptr(bytes), lean_sarray_size(bytes),
        tables, table, targets);
    WGPUBindGroupLayoutDescriptor descriptor;
    memcpy(&descriptor, lean_sarray_cptr(bytes), sizeof descriptor);
    WGPUBindGroupLayoutEntry const * entries = descriptor.entries;
    char const * problem = "";
    if (descriptor.nextInChain != NULL) {
        problem = "the chain";
    } else if (descriptor.label.length != 6
            || memcmp(descriptor.label.data, "layout", 6) != 0) {
        problem = "the label";
    } else if (descriptor.entryCount != 2 || entries == NULL) {
        problem = "the entries";
    } else if (entries[0].nextInChain != NULL || entries[0].binding != 0
            || entries[0].visibility != WGPUShaderStage_Fragment) {
        problem = "the first entry";
    } else if (entries[1].nextInChain != NULL || entries[1].binding != 5
            || entries[1].visibility != WGPUShaderStage_Vertex
            || entries[1].bindingArraySize != 3) {
        problem = "the second entry";
    }
    lean_dec(bytes);
    return lean_mk_string(problem);
}

// Fill `bytes` by table 1 of `WebGPURawTest.Internal.Reloc.objectTables`: a
// pointer to a block of two handles, each `instance`'s. The first pointer that
// is not what it should be, or "".
LEAN_EXPORT lean_obj_res lean_wgpu_test_fill_objects(
        lean_obj_arg bytes, b_lean_obj_arg tables, b_lean_obj_arg targets,
        b_lean_obj_arg instance) {
    size_t cursor = 0;
    uint8_t * data = lean_sarray_cptr(bytes);
    lean_wgpu_fill(data, lean_sarray_size(bytes), tables, 1, targets, &cursor);
    void * handle = lean_get_external_data(instance);
    void * const * handles = lean_wgpu_test_pointer(data, 0);
    char const * problem = "";
    if (handles == NULL) {
        problem = "the block of handles, null";
    } else if (handles[0] != handle || handles[1] != handle) {
        problem = "the handles";
    } else if (cursor != lean_array_size(targets)) {
        problem = "the targets, not all taken";
    }
    lean_dec(bytes);
    return lean_mk_string(problem);
}

// Fill an encoded bind group layout descriptor with no entries by table
// `table`: its entries an empty array, a null pointer and a count of 0. The
// first field that is not what it should be, or "".
LEAN_EXPORT lean_obj_res lean_wgpu_test_empty_bind_group_layout(
        lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets) {
    lean_wgpu_fill_struct(lean_sarray_cptr(bytes), lean_sarray_size(bytes),
        tables, table, targets);
    WGPUBindGroupLayoutDescriptor descriptor;
    memcpy(&descriptor, lean_sarray_cptr(bytes), sizeof descriptor);
    char const * problem = "";
    if (descriptor.entryCount != 0 || descriptor.entries != NULL) {
        problem = "the entries, not none";
    }
    lean_dec(bytes);
    return lean_mk_string(problem);
}

// Fill an encoded pipeline layout descriptor with no bind group layouts by
// table `table`: its layouts an empty array of objects, a null pointer and a
// count of 0, through the generated table. The first field that is not what
// it should be, or "".
LEAN_EXPORT lean_obj_res lean_wgpu_test_pipeline_layout(
        lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets) {
    lean_wgpu_fill_struct(lean_sarray_cptr(bytes), lean_sarray_size(bytes),
        tables, table, targets);
    WGPUPipelineLayoutDescriptor descriptor;
    memcpy(&descriptor, lean_sarray_cptr(bytes), sizeof descriptor);
    char const * problem = "";
    if (descriptor.nextInChain != NULL) {
        problem = "the chain";
    } else if (descriptor.bindGroupLayoutCount != 0
            || descriptor.bindGroupLayouts != NULL) {
        problem = "the bind group layouts, not none";
    } else if (descriptor.immediateSize != 16) {
        problem = "the immediate size";
    }
    lean_dec(bytes);
    return lean_mk_string(problem);
}

// Fill an encoded vertex buffer layout by table `table`, then check it as
// WebGPU would read it: `WebGPURawTest.Internal.Reloc.vertexBuffer`, its two
// attributes an array of structs. The first field that is not what it should
// be, or "".
LEAN_EXPORT lean_obj_res lean_wgpu_test_vertex_buffer_layout(
        lean_obj_arg bytes, b_lean_obj_arg tables, size_t table,
        b_lean_obj_arg targets) {
    lean_wgpu_fill_struct(lean_sarray_cptr(bytes), lean_sarray_size(bytes),
        tables, table, targets);
    WGPUVertexBufferLayout layout;
    memcpy(&layout, lean_sarray_cptr(bytes), sizeof layout);
    WGPUVertexAttribute const * attributes = layout.attributes;
    char const * problem = "";
    if (layout.nextInChain != NULL) {
        problem = "the chain";
    } else if (layout.stepMode != WGPUVertexStepMode_Vertex
            || layout.arrayStride != 24) {
        problem = "the step mode or stride";
    } else if (layout.attributeCount != 2 || attributes == NULL) {
        problem = "the attributes";
    } else if (attributes[0].nextInChain != NULL
            || attributes[0].format != WGPUVertexFormat_Float32x2
            || attributes[0].offset != 0
            || attributes[0].shaderLocation != 0
            || attributes[1].format != WGPUVertexFormat_Float32x4
            || attributes[1].offset != 8
            || attributes[1].shaderLocation != 1) {
        problem = "the attributes' fields";
    }
    lean_dec(bytes);
    return lean_mk_string(problem);
}
