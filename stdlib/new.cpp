#include <felspar/memory/sizes.hpp>

#include <new>


extern unsigned char __heap_base;


namespace {
    std::size_t base = {};
}
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

