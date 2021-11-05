#include <memory>


void* memcpy( void* dest, const void* src, std::size_t count ) {
    unsigned char const *s = reinterpret_cast<unsigned char const *>(src);
    unsigned char *d = reinterpret_cast<unsigned char *>(dest);
    if (d != nullptr and s != nullptr) {
        while (count--) {
            *d++ = *s++;
        }
    }
    return dest;
}
