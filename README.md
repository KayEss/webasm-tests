# Playing with freestanding webasm

Requires a good clang compiler. All tests were done using using clang-13.

You may need some extra packages installed:
* `libc6-dev-i386` -- for some 32 bit stuff the compiler wants

I also needed to soft link the linker in my `~/bin` folder with:
```bash
ln -s /usr/bin/wasm-ld-13 wasm-ld
```

## Compiling and running

To compile a test run its `.sh` file:

```bash
./test1.sh
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
