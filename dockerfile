# Container image that runs your code
# https://www.linkedin.com/pulse/cross-compiling-gcc-toolchain-arm-cortex-m-processors-ijaz-ahmad
FROM ubuntu:22.04

ARG USER_ID
ARG GROUP_ID

WORKDIR /home/user
VOLUME ./project /project

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
RUN chgrp user /opt
RUN chmod g+s /opt

RUN apt-get update  && apt-get -y upgrade
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y gcc
RUN apt-get install -y make
RUN apt-get install -y libmpc-dev
RUN apt-get install -y libmpfr-dev
RUN apt-get install -y libgmp3-dev
RUN apt-get install -y libexpat-dev
RUN apt-get install -y libdebuginfod-dev
RUN apt-get install -y libpython3-dev
RUN apt-get install -y python-is-python3
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y diffutils
RUN apt-get install -y pkg-config
RUN apt-get install -y libsource-highlight-dev
RUN apt-get install -y liblzma-dev
RUN apt-get install -y libisl-dev
RUN apt-get install -y libzstd-dev
RUN apt-get install -y libbabeltrace-dev
RUN apt-get install -y flex
RUN apt-get install -y bison
RUN apt-get install -y autoconf
RUN apt-get install -y automake
RUN apt-get install -y texinfo
RUN apt-get install -y xz-utils

RUN mkdir /opt/arm-none-eabi
RUN chown :user /opt/arm-none-eabi
RUN chmod g+rwx /opt/arm-none-eabi

RUN mkdir /home/user/toolchain
RUN chown user:user /home/user
RUN chown user:user /home/user/toolchain
USER user

RUN wget https://gcc.gnu.org/ftp/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.xz -O /home/user/toolchain/gcc-13.2.0.tar.xz
RUN wget https://sourceware.org/pub/binutils/releases/binutils-2.42.tar.xz -O /home/user/toolchain/binutils-2.42.tar.xz
RUN wget ftp://sourceware.org/pub/newlib/newlib-4.4.0.20231231.tar.gz -O /home/user/toolchain/newlib-4.4.0.20231231.tar.gz
RUN wget https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.xz -O /home/user/toolchain/gdb-14.2.tar.xz

RUN cd /home/user/toolchain && tar -xf gcc-13.2.0.tar.xz
RUN cd /home/user/toolchain && tar -xf binutils-2.42.tar.xz
RUN cd /home/user/toolchain && tar -xzf newlib-4.4.0.20231231.tar.gz
RUN cd /home/user/toolchain && tar -xf gdb-14.2.tar.xz

COPY --chown=user:user ./scripts/startup.sh /home/user/startup.sh
RUN chmod +x /home/user/startup.sh
