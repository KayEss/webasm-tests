#include <felspar/memory/sizes.hpp>

#include <new>


void *operator new(std::size_t bytes, std::align_val_t /*a*/) {
    return ::malloc(bytes);
}
void *operator new(std::size_t bytes) {
    return ::malloc(bytes);
}
void operator delete(void *ptr) noexcept { ::free(ptr); }
void operator delete(void *ptr, std::align_val_t) noexcept { ::free(ptr); }
