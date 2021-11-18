#!/usr/bin/env bash
cd $(dirname $0)
set -ex

for FILE in $(ls -1 *.cpp)
do {
    clang++ \
        --target=wasm32 \
        -nostdlib -ffreestanding -fno-exceptions \
        --std=c++20 \
        -emit-llvm -c \
        -D_LIBCPP_HAS_NO_THREADS \
        -O3 \
        -I/usr/lib/llvm-13/include/c++/v1/ \
        -I/usr/include \
        -I/usr/include/x86_64-linux-gnu/ \
        -I../libs/memory/include/ \
        $FILE
}
done