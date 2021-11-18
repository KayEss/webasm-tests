#include <cstring>


extern "C" void *memmove(void *dest, void const *src, std::size_t count) {
    auto *d = reinterpret_cast<unsigned char *>(dest);
    auto const *s = reinterpret_cast<unsigned char const *>(src);
    if (d < s) {
        while (count--) {
            *d++ = *s++;
        }
    } else {
        while (count--) {
            d[count] = s[count];
        }
    }
    return dest;
}
