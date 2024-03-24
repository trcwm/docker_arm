# Docker container for building ARM-NONE-EABI-GCC and GDB

For Ubuntu 22.04 with GDB Python support.

## Build artifacts

Artifacts are compiled and installed to /opt/arm-none-eabi within the container. A copy is made to ./project outside the container.

* GCC
* GDB
* Binutils
* Newlib
