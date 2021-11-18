#include <map>

extern "C" {
#include <opus.h>
}


namespace {
    struct decoder {
        decoder() {
            opus_int32 err;
            dec = opus_decoder_create(48'000, 2, &err);
        }
        ~decoder() {
        }
    private:
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


extern "C" bool free_decoder(int const handle) {
    if (auto pos = g_decoders.find(handle); pos != g_decoders.end()) {
        g_decoders.erase(pos);
        return true;
    } else {
        return false;
    }
}
