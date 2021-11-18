#!/usr/bin/env bash


clang++ \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -emit-llvm -c \
    --std=c++20 \
    -D_LIBCPP_HAS_NO_THREADS \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Ilibs/memory/include/ \
    new.cpp memcpy.cpp


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
    -Wl,--no-entry \
    -Wl,--export=add \
    -Wl,--lto-O3 \
    -Wl,-z,stack-size=$[8 * 1024 * 1024] \
    -o test1.wasm \
    new.bc memcpy.bc test1.cpp
