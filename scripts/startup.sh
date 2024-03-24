#!/bin/sh
# https://www.linkedin.com/pulse/cross-compiling-gcc-toolchain-arm-cortex-m-processors-ijaz-ahmad
# https://gist.github.com/badcf00d/2f6054441375d9c94896aaa8e878ab4f

PREFIX=/opt/arm-none-eabi
HOST="86_64-pc-linux-gnu"

echo "********************************************************************************"
echo "Downloading source files ..."
echo "********************************************************************************"

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

echo "********************************************************************************"
echo "Building binutils..."
echo "********************************************************************************"
mkdir -p binutils-build
cd binutils-build
../binutils-2.42/configure \
    --target=arm-none-eabi \
    --host=$HOST \
    --prefix=$PREFIX \
    --enable-multilib \
    --enable-lto

make all install 2>&1 | tee /project/binutils-build-logs.log
cd ..

echo "********************************************************************************"
echo "Building gcc stage1 ..."
echo "********************************************************************************"
mkdir -p gcc-build
cd gcc-build
../gcc-13.2.0/configure \
    --target=arm-none-eabi \
    --with-pkgversion=stage1-my-custom-$(date -I) \
    --prefix=$PREFIX \
    --host=$HOST \
    --with-cpu=cortex-m4 \
    --enable-languages=c \
    --with-isl \
    --without-headers \
    --with-multilib-list=rmprofile \
    --with-newlib \
    --with-no-thumb-interwork \
    --with-mode=thumb \
    --enable-lto \
    --enable-multiarch \
    --disable-libssp \
    --disable-nls \
    --disable-tls \
    --disable-threads \
    --disable-shared

make all-gcc install-gcc 2>&1 | tee /project/gcc-build-stage1-logs.log
cd ..

echo "********************************************************************************"
echo "Building newlib..."
echo "********************************************************************************"
mkdir -p newlib-build
cd newlib-build
../newlib-4.4.0.20231231/configure \
    --host=$HOST \
    --target=arm-none-eabi \
    --prefix=$PREFIX \
    --disable-newlib-supplied-syscalls \
    --disable-newlib-io-float \
    --disable-newlib-io-long-double \
    --disable-newlib-io-pos-args \
    --disable-newlib-io-c99-formats \
    --disable-newlib-io-long-long \
    --disable-newlib-multithread \
    --disable-newlib-retargetable-locking \
    --disable-newlib-wide-orient \
    --disable-newlib-fseek-optimization \
    --disable-newlib-fvwrite-in-streamio \
    --disable-newlib-unbuf-stream-opt \
    --disable-newlib-atexit-dynamic-alloc \
    --enable-libssp \
    --enable-newlib-nano-malloc \
    --enable-newlib-nano-formatted-io \
    --enable-newlib-global-atexit \
    --enable-lite-exit \
    --enable-newlib-reent-small \
    --enable-target-optspace

make all install 2>&1 | tee /project/newlib-build-logs.log
cd ..

echo "********************************************************************************"
echo "Building gcc stage2 ..."
echo "********************************************************************************"
mkdir -p gcc-build
cd gcc-build
../gcc-13.2.0/configure \
    --host=$HOST \
    --prefix=$PREFIX \
    --enable-languages=c,c++ \
    --target=arm-none-eabi \
    --with-pkgversion=my-custom-$(date -I) \
    --with-newlib \
    --with-sysroot=$PREFIX/arm-none-eabi \
    --with-native-system-header-dir=/include \
    --with-multilib-list=rmprofile \
    --enable-lto \
    --enable-target-optspace \
    --enable-multiarch \
    --disable-nls \
    --disable-tls \
    --disable-threads \
    --disable-shared

make all-gcc install-gcc 2>&1 | tee /project/gcc-build-withnewlib-logs.log
cd ..

echo "********************************************************************************"
echo "Building gdb with python"
echo "********************************************************************************"
mkdir -p gdb-build
cd gdb-build
../gdb-14.2/configure --target=arm-none-eabi \
    --prefix=/opt/arm-none-eabi \
    --with-python=/usr/bin/python3 \
    --with-expat \
    --with-lzma \
    --with-sysroot \
    --with-zstd \
    --with-isl \
    --enable-ld=yes \
    --enable-plugins \
    --enable-multilib \
    --enable-source-highlight \
    --disable-werror \
    --disable-nls \
    --disable-warn-rwx-segments

make all install 2>&1 | tee /project/gdb-build-logs.log
cd ..

mkdir -p /project/opt
cp -r /opt/* /project/opt/
