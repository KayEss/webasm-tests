#!/usr/bin/env bash
set -ex

./libs/SoftFloat.sh
./stdlib/stdlib.sh

mkdir -p celt silk/float src

OPUS=""
for FILE in \
    src/analysis.c \
    src/mapping_matrix.c \
    src/mlp.c \
    src/mlp_data.c \
    src/opus.c \
    src/opus_decoder.c \
    src/opus_encoder.c \
    src/opus_multistream.c \
    src/opus_multistream_encoder.c \
    src/opus_multistream_decoder.c \
    src/opus_projection_encoder.c \
    src/opus_projection_decoder.c \
    src/repacketizer.c \
    celt/bands.c \
    celt/celt.c \
    celt/celt_decoder.c \
    celt/celt_encoder.c \
    celt/celt_lpc.c \
    celt/cwrs.c \
    celt/entcode.c \
    celt/entdec.c \
    celt/entenc.c \
    celt/kiss_fft.c \
    celt/laplace.c \
    celt/mathops.c \
    celt/mdct.c \
    celt/modes.c \
    celt/pitch.c \
    celt/quant_bands.c \
    celt/rate.c \
    celt/vq.c \
    silk/A2NLSF.c \
    silk/CNG.c \
    silk/HP_variable_cutoff.c \
    silk/LPC_analysis_filter.c \
    silk/LPC_fit.c \
    silk/LPC_inv_pred_gain.c \
    silk/LP_variable_cutoff.c \
    silk/NLSF2A.c \
    silk/NLSF_VQ.c \
    silk/NLSF_VQ_weights_laroia.c \
    silk/NLSF_decode.c \
    silk/NLSF_del_dec_quant.c \
    silk/NLSF_encode.c \
    silk/NLSF_stabilize.c \
    silk/NLSF_unpack.c \
    silk/NSQ.c \
    silk/NSQ_del_dec.c \
    silk/PLC.c \
    silk/VAD.c \
    silk/VQ_WMat_EC.c \
    silk/ana_filt_bank_1.c \
    silk/biquad_alt.c \
    silk/bwexpander.c \
    silk/bwexpander_32.c \
    silk/check_control_input.c \
    silk/code_signs.c \
    silk/control_SNR.c \
    silk/control_audio_bandwidth.c \
    silk/control_codec.c \
    silk/debug.c \
    silk/dec_API.c \
    silk/decode_core.c \
    silk/decode_frame.c \
    silk/decode_indices.c \
    silk/decode_parameters.c \
    silk/decode_pitch.c \
    silk/decode_pulses.c \
    silk/decoder_set_fs.c \
    silk/enc_API.c \
    silk/encode_indices.c \
    silk/encode_pulses.c \
    silk/float/apply_sine_window_FLP.c \
    silk/gain_quant.c \
    silk/init_decoder.c \
    silk/init_encoder.c \
    silk/inner_prod_aligned.c \
    silk/interpolate.c \
    silk/lin2log.c \
    silk/log2lin.c \
    silk/pitch_est_tables.c \
    silk/process_NLSFs.c \
    silk/quant_LTP_gains.c \
    silk/resampler.c \
    silk/resampler_down2.c \
    silk/resampler_down2_3.c \
    silk/resampler_private_AR2.c \
    silk/resampler_private_IIR_FIR.c \
    silk/resampler_private_down_FIR.c \
    silk/resampler_private_up2_HQ.c \
    silk/resampler_rom.c \
    silk/shell_coder.c \
    silk/sigm_Q15.c \
    silk/sort.c \
    silk/stereo_LR_to_MS.c \
    silk/stereo_MS_to_LR.c \
    silk/stereo_decode_pred.c \
    silk/stereo_encode_pred.c \
    silk/stereo_find_predictor.c \
    silk/stereo_quant_pred.c \
    silk/sum_sqr_shift.c \
    silk/table_LSF_cos.c \
    silk/tables_LTP.c \
    silk/tables_NLSF_CB_NB_MB.c \
    silk/tables_NLSF_CB_WB.c \
    silk/tables_gain.c \
    silk/tables_other.c \
    silk/tables_pitch_lag.c \
    silk/tables_pulses_per_block.c \
    silk/float/LPC_analysis_filter_FLP.c \
    silk/float/LPC_inv_pred_gain_FLP.c \
    silk/float/LTP_analysis_filter_FLP.c \
    silk/float/LTP_scale_ctrl_FLP.c \
    silk/float/autocorrelation_FLP.c \
    silk/float/burg_modified_FLP.c \
    silk/float/bwexpander_FLP.c \
    silk/float/corrMatrix_FLP.c \
    silk/float/encode_frame_FLP.c \
    silk/float/energy_FLP.c \
    silk/float/find_LPC_FLP.c \
    silk/float/find_LTP_FLP.c \
    silk/float/find_pitch_lags_FLP.c \
    silk/float/find_pred_coefs_FLP.c \
    silk/float/inner_product_FLP.c \
    silk/float/k2a_FLP.c \
    silk/float/noise_shape_analysis_FLP.c \
    silk/float/pitch_analysis_core_FLP.c \
    silk/float/process_gains_FLP.c \
    silk/float/regularize_correlations_FLP.c \
    silk/float/residual_energy_FLP.c \
    silk/float/scale_copy_vector_FLP.c \
    silk/float/scale_vector_FLP.c \
    silk/float/schur_FLP.c \
    silk/float/sort_FLP.c \
    silk/float/warped_autocorrelation_FLP.c \
    silk/float/wrappers_FLP.c
do {
    clang \
        --target=wasm32 -emit-llvm -c \
        -nostdlib -ffreestanding -fno-exceptions \
        -O3 -ffast-math \
        -DFLOAT_APPROX \
        -DOPUS_BUILD=1 \
        -DVAR_ARRAYS=1 \
        -DHAVE_LRINT \
        -DHAVE_LRINTF \
        -I/usr/lib/llvm-13/include/c++/v1/ \
        -I/usr/include \
        -I/usr/include/x86_64-linux-gnu/ \
        -Ilibs/opus/celt \
        -Ilibs/opus/include \
        -Ilibs/opus/silk \
        -Ilibs/opus/silk/float \
        libs/opus/$FILE \
        -o $FILE.bc
    OPUS="$OPUS $FILE.bc"
}
done

clang++ \
    --target=wasm32 \
    -nostdlib -ffreestanding -fno-exceptions \
    --std=c++20 \
    -O3 -ffast-math \
    -DFLOAT_APPROX \
    -D_LIBCPP_HAS_NO_THREADS \
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
    -Wl,--export=decoder_error \
    -Wl,--export=decode_float \
    -Wl,--export=free_decoder \
    -Wl,--export=sqrt \
    -Wl,--export=cos \
    -Wl,--export=exp \
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
