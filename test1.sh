#!/usr/bin/env bash

./stdlib/stdlib.sh

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
    stdlib/new.cpp.bc \
    stdlib/malloc.cpp.bc \
    stdlib/memcpy.cpp.bc \
    test1.cpp
