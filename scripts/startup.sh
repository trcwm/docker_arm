#!/bin/sh
# https://www.linkedin.com/pulse/cross-compiling-gcc-toolchain-arm-cortex-m-processors-ijaz-ahmad

mkdir -p toolchain
cd toolchain
wget https://gcc.gnu.org/ftp/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.xz -O ./gcc-13.2.0.tar.xz
wget https://sourceware.org/pub/binutils/releases/binutils-2.42.tar.xz -O ./binutils-2.42.tar.xz
wget ftp://sourceware.org/pub/newlib/newlib-4.4.0.20231231.tar.gz -O ./newlib-4.4.0.20231231.tar.gz
wget https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.xz -O ./gdb-14.2.tar.xz
tar -xf gcc-13.2.0.tar.xz
tar -xf binutils-2.42.tar.xz
tar -xzf newlib-4.4.0.20231231.tar.gz
tar -xf gdb-14.2.tar.xz

echo "Building binutils..."
mkdir -p binutils-build
cd binutils-build
../binutils-2.42/configure --target=arm-none-eabi --prefix=/opt/arm-none-eabi --with-cpu=cortex-m4 --with-no-thumb-interwork --with-mode=thumb
make all install 2>&1 | tee ./binutils-build-logs.log
cd ..

echo "Building gcc..."
mkdir -p gcc-build
cd gcc-build
../gcc-13.2.0/configure --target=arm-none-eabi --prefix=/opt/arm-none-eabi --with-cpu=cortex-m4 \
--enable-languages=c,c++,lto --without-headers --with-newlib --with-no-thumb-interwork --with-mode=thumb
make all-gcc install-gcc 2>&1 | tee ./gcc-build-withoutnewlib-logs.log
cd ..

echo "Building newlib..."
mkdir -p newlib-build
cd newlib-build
../newlib-4.4.0.20231231/configure --target=arm-none-eabi --prefix=/opt/arm-none-eabi \
--disable-newlib-supplied-syscalls
make all install 2>&1 | tee ./newlib-build-logs.log
cd ..

echo "Building gcc with newlib..."
mkdir -p gcc-build
cd gcc-build
../gcc-13.2.0/configure --target=arm-none-eabi --prefix=/opt/arm-none-eabi --with-cpu=cortex-m4 \
--enable-languages=c,c++,lto --without-headers --with-newlib --with-no-thumb-interwork --with-mode=thumb
make all-gcc install-gcc 2>&1 | tee ./gcc-build-withnewlib-logs.log
cd ..

echo "Building gdb with python"
mkdir -p gdb-build
cd gdb-build
../gdb-14.2/configure --target=arm-none-eabi --prefix=/opt/arm-none-eabi \
--with-python=/usr/bin/python3
make all install 2>&1 | tee ./gdb-build-logs.log
cd ..
