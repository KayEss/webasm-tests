#!/usr/bin/env bash
set -ex

clang++ \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -emit-llvm -c \
    -D_LIBCPP_HAS_NO_THREADS \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    memset.cpp
