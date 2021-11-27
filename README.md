# Playing with freestanding webasm

**This is only proof-of-concept stuff. Nothing here is suitable for real world production use, but it could be adapted to be so**

Requires a good clang compiler. All tests were done using using clang-13.

You may need some extra packages installed:
* `clang-13` -- for the compiler
* `libc6-dev-i386` -- for some 32 bit stuff the compiler wants

I also needed to soft link the linker in my `~/bin` folder with:
```bash
ln -s /usr/bin/wasm-ld-13 wasm-ld
```

## Compiling and running

To compile all libraries and examples use the configure script followed by Ninja:

```bash
./config-build
ninja -C build.tmp
```

To serve the pages you can use the built in Python web server:

```bash
python3 -m http.server
```

Recent versions of Firefox at least won't load the pages from the file system due to new security barriers.

To look at the symbols produced (useful to make sure everything is as it should be and the output doesn't contain things that aren't needed):

```bash
wasm-objdump -x test1.wasm
```

## OPUS example

For something more adventurous there is an OPUS decoder. The [`./opus.sh`](./opus.sh) script will build the example code along with the bits of libopus and SoftFloat that are required. The file [`opus.html`](./opus.html) contains some numerical analysis of decoding a single test OPUS packet (again, look in the console log).

The file [`opus_long_decode.html`](./opus_long_decode.html) contains a play button where you can hear the output from the decoder.
