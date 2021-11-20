#include <array>
#include <iostream>
#include <map>
#include <memory>

extern "C" {
#if __has_include(<opus.h>)
#include <opus.h>
#else
#include <opus/opus.h>
#endif
}


namespace {
    struct decoder {
        decoder() {
            dec = opus_decoder_create(48'000, 2, &err);
        }
        ~decoder() {
        }

        opus_int32 err = {};
        OpusDecoder *dec = nullptr;
    };

    std::map<int, std::unique_ptr<decoder>> g_decoders;
    int g_next_handle = {};
}


extern "C" int create_decoder() {
    auto handle = ++g_next_handle;
    g_decoders[handle] = std::make_unique<decoder>();
    return handle;
}


extern "C" opus_int32 decoder_error(int handle) {
    return g_decoders[handle]->err;
}


extern "C" int decode_float(int decoder, unsigned char const *packet, std::size_t packet_length, float*into, std::size_t length, int fec) {
    return opus_decode_float(g_decoders[decoder]->dec, packet, packet_length, into, length, fec);
}


extern "C" bool free_decoder(int const handle) {
    if (auto pos = g_decoders.find(handle); pos != g_decoders.end()) {
        g_decoders.erase(pos);
        return true;
    } else {
        return false;
    }
}


/// Test main with
///     clang++ -std=c++20 opus.cpp -Wl,-lopus -o opus && ./opus
int main() {
    std::array<unsigned char, 217> opus_packet = {244, 159, 180, 234, 75, 206, 75, 250, 226, 234, 230, 56, 147, 240, 103, 120, 207, 99, 168, 153, 247, 5, 126, 92, 209, 193, 218, 99, 15, 207, 158, 233, 65, 37, 39, 232, 177, 170, 45, 183, 80, 102, 212, 165, 79, 72, 81, 48, 187, 56, 120, 84, 60, 190, 180, 228, 182, 250, 90, 121, 241, 217, 125, 151, 3, 37, 92, 2, 40, 182, 186, 77, 141, 103, 70, 119, 161, 231, 65, 65, 61, 153, 221, 80, 82, 209, 18, 184, 55, 90, 21, 37, 185, 51, 252, 176, 63, 68, 110, 234, 208, 16, 0, 0, 0, 0, 0, 0, 0, 51, 3, 207, 60, 60, 233, 159, 8, 6, 147, 193, 139, 168, 114, 203, 196, 219, 91, 90, 182, 16, 102, 103, 104, 135, 62, 136, 135, 62, 139, 90, 246, 119, 170, 68, 183, 98, 245, 10, 197, 161, 139, 79, 134, 20, 148, 75, 122, 191, 156, 159, 69, 146, 211, 130, 14, 157, 222, 7, 12, 33, 200, 166, 62, 82, 68, 255, 132, 250, 191, 50, 183, 33, 99, 95, 91, 52, 180, 206, 46, 121, 53, 10, 11, 211, 148, 98, 63, 8, 45, 178, 40, 131, 161, 68, 182, 75, 244, 137, 181, 191, 254, 149, 64, 10, 15, 85, 145};

    auto dec = create_decoder();

    std::array<float, 960> output = {};
    std::cout << decode_float(dec, opus_packet.data(), opus_packet.size(), output.data(), output.size(), 0) << " " << decoder_error(dec) << '\n';


    bool first = true;
    std::cout << '[';
    for (auto s : output) {
        if (not first) {
            std::cout << ", ";
        } else {
            first = false;
        }
        std::cout << s; }
    std::cout << "]\n";

    return 0;
}
