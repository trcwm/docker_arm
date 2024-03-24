# Container image that runs your code
# https://www.linkedin.com/pulse/cross-compiling-gcc-toolchain-arm-cortex-m-processors-ijaz-ahmad
FROM ubuntu:22.04

ARG USER_ID
ARG GROUP_ID

#WORKDIR /tmp
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

USER user

COPY --chown=user:user ./scripts/startup.sh /home/user/startup.sh
RUN chmod +x /home/user/startup.sh
