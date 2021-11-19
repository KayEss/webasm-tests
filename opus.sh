#!/usr/bin/env bash
set -ex

./libs/SoftFloat.sh
./stdlib/stdlib.sh

mkdir -p celt silk src

OPUS=""
for FILE in src/opus.c src/opus_decoder.c \
    celt/bands.c \
    celt/celt.c \
    celt/celt_decoder.c \
    celt/celt_lpc.c \
    celt/cwrs.c \
    celt/entcode.c \
    celt/entdec.c \
    celt/entenc.c \
    celt/kiss_fft.c \
    celt/laplace.c \
    celt/mdct.c \
    celt/mathops.c \
    celt/modes.c \
    celt/pitch.c \
    celt/quant_bands.c \
    celt/rate.c \
    celt/vq.c \
    silk/bwexpander.c \
    silk/bwexpander_32.c \
    silk/CNG.c \
    silk/code_signs.c \
    silk/dec_API.c \
    silk/decode_core.c \
    silk/decode_frame.c \
    silk/decode_indices.c \
    silk/decode_parameters.c \
    silk/decode_pitch.c \
    silk/decode_pulses.c \
    silk/decoder_set_fs.c \
    silk/gain_quant.c \
    silk/init_decoder.c \
    silk/log2lin.c \
    silk/LPC_analysis_filter.c \
    silk/LPC_fit.c \
    silk/LPC_inv_pred_gain.c \
    silk/NLSF_decode.c \
    silk/NLSF_stabilize.c \
    silk/NLSF_unpack.c \
    silk/NLSF2A.c \
    silk/pitch_est_tables.c \
    silk/PLC.c \
    silk/resampler.c \
    silk/resampler_private_AR2.c \
    silk/resampler_private_down_FIR.c \
    silk/resampler_private_IIR_FIR.c \
    silk/resampler_private_up2_HQ.c \
    silk/resampler_rom.c \
    silk/shell_coder.c \
    silk/sort.c \
    silk/stereo_decode_pred.c \
    silk/stereo_MS_to_LR.c \
    silk/sum_sqr_shift.c \
    silk/table_LSF_cos.c \
    silk/tables_gain.c \
    silk/tables_LTP.c \
    silk/tables_NLSF_CB_NB_MB.c \
    silk/tables_NLSF_CB_WB.c \
    silk/tables_other.c \
    silk/tables_pitch_lag.c \
    silk/tables_pulses_per_block.c
do {
    clang \
        --target=wasm32 \
        -nostdlib -ffreestanding -fno-exceptions \
        -emit-llvm -c \
        -DOPUS_BUILD=1 \
        -DUSE_ALLOCA=1 \
        -DHAVE_LRINT \
        -DHAVE_LRINTF \
        -O3 \
        -I/usr/lib/llvm-13/include/c++/v1/ \
        -I/usr/include \
        -I/usr/include/x86_64-linux-gnu/ \
        -Ilibs/opus/celt \
        -Ilibs/opus/include \
        -Ilibs/opus/silk \
        libs/opus/$FILE \
        -o $FILE.bc
    OPUS="$OPUS $FILE.bc"
}
done

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
    -Wl,-error-limit=0 \
    -Wl,--no-entry \
    -Wl,--export=__wasm_call_ctors \
    -Wl,--export=malloc \
    -Wl,--export=free \
    -Wl,--export=create_decoder \
    -Wl,--export=decode_float \
    -Wl,--export=free_decoder \
    -Wl,--export=sqrt \
    -Wl,--lto-O3 \
    -Wl,-z,stack-size=$[8 * 1024 * 1024] \
    libs/SoftFloat/source/8086/softfloat_raiseFlags.c.bc \
    libs/SoftFloat/source/8086/s_propagateNaNF64UI.c.bc \
    libs/SoftFloat/source/f64_sqrt.c.bc \
    libs/SoftFloat/source/s_countLeadingZeros8.c.bc \
    libs/SoftFloat/source/s_countLeadingZeros64.c.bc \
    libs/SoftFloat/source/s_approxRecipSqrt_1Ks.c.bc \
    libs/SoftFloat/source/s_approxRecipSqrt32_1.c.bc \
    libs/SoftFloat/source/s_normSubnormalF64Sig.c.bc \
    libs/SoftFloat/source/s_roundPackToF64.c.bc \
    libs/SoftFloat/source/s_shiftRightJam64.c.bc \
    libs/SoftFloat/source/softfloat_state.c.bc \
    stdlib/atexit.cpp.bc \
    stdlib/malloc.cpp.bc \
    stdlib/maths.cpp.bc \
    stdlib/memcpy.cpp.bc \
    stdlib/memmove.cpp.bc \
    stdlib/memset.cpp.bc \
    stdlib/new.cpp.bc \
    $OPUS \
    ./opus.cpp \
    -o opus.wasm
