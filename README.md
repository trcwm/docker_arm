# Building ARM-NONE-EABI-GCC and GDB using Docker

For Ubuntu 22.04 with GDB Python support.

## Build artifacts

Artifacts are compiled and installed to /opt/arm-none-eabi within the container. A copy is made to ./project outside the container.

* GCC 13.2.0
* GDB 14.2
* Binutils 2.42
* Newlib 4.4.0

