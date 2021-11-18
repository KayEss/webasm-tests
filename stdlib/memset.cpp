#include <cstring>


extern "C" void* memset(void * const dest, int const ch, std::size_t count) {
    auto *d = reinterpret_cast<unsigned char *>(dest);
    while (count--) {
        *d++ = ch;
    }
    return dest;
}
