#!/usr/bin/env bash

clang \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -D_LIBCPP_HAS_NO_THREADS \
    -DOPUS_BUILD=1 \
    -DUSE_ALLOCA=1 \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Wl,--no-entry \
    -Wl,--export=opus_decoder_create \
    -Ilibs/opus/celt \
    -Ilibs/opus/include \
    -Ilibs/opus/silk \
    libs/opus/src/opus_decoder.c \
    memset.cpp \
    -o opus.wasm


clang++ \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    --std=c++20 \
    -D_LIBCPP_HAS_NO_THREADS \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Ilibs/memory/include/ \
    -Ilibs/opus/include \
    -Wl,--no-entry \
    -Wl,--export=__wasm_call_ctors \
    -Wl,--export=create_decoder \
    -Wl,--export=free_decoder \
    -Wl,--lto-O3 \
    -Wl,-z,stack-size=$[8 * 1024 * 1024] \
    atexit.cpp new.cpp \
    opus.cpp opus.wasm \
    -o opus.wasm
