#include <felspar/memory/sizes.hpp>

#include <stdlib.h>


extern unsigned char __heap_base;


namespace {
    std::size_t base = {};
}


extern "C" void *malloc(std::size_t bytes) {
    base = felspar::memory::aligned_offset(base, 4u);
    unsigned char *ptr = &__heap_base + base;
    base += bytes;
    return ptr;
}


extern "C" void free(void*) {
}
