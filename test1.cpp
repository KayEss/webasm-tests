#include <felspar/memory/sizes.hpp>

#include <numeric>
#include <vector>


extern unsigned char __heap_base;


std::size_t base = {};
void *operator new(std::size_t bytes, std::align_val_t a) {
    base = felspar::memory::aligned_offset(base, static_cast<std::size_t>(a));
    unsigned char *ptr = &__heap_base + base;
    base += bytes;
    return ptr;
}
void *operator new(std::size_t bytes) {
    return ::operator new(bytes, std::align_val_t{4});
}
void operator delete(void *) noexcept {}
void operator delete(void *, std::align_val_t) noexcept {}


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


extern "C" int add(int a, int b) {
    std::vector<int> v;
    v.push_back(a);
    v.push_back(b);
    auto const s = std::accumulate(v.begin(), v.end(), 0);
    return s;
}
