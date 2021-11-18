#!/usr/bin/env bash
set -ex

./stdlib/stdlib.sh

clang \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -emit-llvm -c \
    -DOPUS_BUILD=1 \
    -DUSE_ALLOCA=1 \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Ilibs/opus/celt \
    -Ilibs/opus/include \
    -Ilibs/opus/silk \
    libs/opus/celt/celt.c \
    -o celt.bc

clang \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -emit-llvm -c \
    -DOPUS_BUILD=1 \
    -DUSE_ALLOCA=1 \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Ilibs/opus/celt \
    -Ilibs/opus/include \
    -Ilibs/opus/silk \
    libs/opus/silk/CNG.c \
    -o CNG.bc

clang \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -emit-llvm -c \
    -DOPUS_BUILD=1 \
    -DUSE_ALLOCA=1 \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Ilibs/opus/celt \
    -Ilibs/opus/include \
    -Ilibs/opus/silk \
    libs/opus/celt/celt_decoder.c \
    -o celt_decoder.bc

clang \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -emit-llvm -c \
    -DOPUS_BUILD=1 \
    -DUSE_ALLOCA=1 \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Ilibs/opus/celt \
    -Ilibs/opus/include \
    -Ilibs/opus/silk \
    libs/opus/silk/dec_API.c \
    -o dec_API.bc

clang \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -emit-llvm -c \
    -DOPUS_BUILD=1 \
    -DUSE_ALLOCA=1 \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Ilibs/opus/celt \
    -Ilibs/opus/include \
    -Ilibs/opus/silk \
    libs/opus/silk/init_decoder.c \
    -o init_decoder.bc

clang \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -emit-llvm -c \
    -DOPUS_BUILD=1 \
    -DUSE_ALLOCA=1 \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Ilibs/opus/celt \
    -Ilibs/opus/include \
    -Ilibs/opus/silk \
    libs/opus/celt/modes.c \
    -o modes.bc

clang \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -emit-llvm -c \
    -DOPUS_BUILD=1 \
    -DUSE_ALLOCA=1 \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Ilibs/opus/celt \
    -Ilibs/opus/include \
    -Ilibs/opus/silk \
    libs/opus/src/opus_decoder.c \
    -o opus_decoder.bc

clang \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    -emit-llvm -c \
    -DOPUS_BUILD=1 \
    -DUSE_ALLOCA=1 \
    -O3 \
    -I/usr/lib/llvm-13/include/c++/v1/ \
    -I/usr/include \
    -I/usr/include/x86_64-linux-gnu/ \
    -Ilibs/opus/celt \
    -Ilibs/opus/include \
    -Ilibs/opus/silk \
    libs/opus/silk/PLC.c \
    -o PLC.bc

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
    -Wl,--export=malloc \
    -Wl,--export=free \
    -Wl,--export=create_decoder \
    -Wl,--export=decode_float \
    -Wl,--export=free_decoder \
    -Wl,--lto-O3 \
    -Wl,-z,stack-size=$[8 * 1024 * 1024] \
    stdlib/atexit.bc stdlib/malloc.bc stdlib/memset.bc stdlib/new.bc \
    celt.bc celt_decoder.bc CNG.bc dec_API.bc init_decoder.bc opus_decoder.bc modes.bc PLC.bc \
    ./opus.cpp \
    -o opus.wasm
