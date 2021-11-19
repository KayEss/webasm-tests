#!/usr/bin/env bash
cd $(dirname $0)
set -ex

for FILE in \
    SoftFloat/source/8086/s_propagateNaNF64UI.c \
    SoftFloat/source/8086/softfloat_raiseFlags.c \
    SoftFloat/source/f64_sqrt.c \
    SoftFloat/source/s_approxRecipSqrt_1Ks.c \
    SoftFloat/source/s_approxRecipSqrt32_1.c \
    SoftFloat/source/s_countLeadingZeros8.c \
    SoftFloat/source/s_countLeadingZeros64.c \
    SoftFloat/source/s_normSubnormalF64Sig.c \
    SoftFloat/source/s_roundPackToF64.c \
    SoftFloat/source/s_shiftRightJam64.c \
    SoftFloat/source/softfloat_state.c
do {
    clang \
        --target=wasm32 \
        -nostdlib -ffreestanding -fno-exceptions \
        -emit-llvm -c \
        -D_LIBCPP_HAS_NO_THREADS \
        -O3 \
        -I/usr/lib/llvm-13/include/c++/v1/ \
        -I/usr/include \
        -I/usr/include/x86_64-linux-gnu/ \
        -ISoftFloat/source/include \
        -ISoftFloat/source/8086 \
        -I. \
        $FILE -o $FILE.bc
}
done
