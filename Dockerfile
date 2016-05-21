FROM debian:jessie

# install debian dependencies before we lose root privileges [2]
RUN apt-get update \
&& apt-get install -y sudo git build-essential unzip vim file wget curl python libjemalloc1 llvm pkg-config;

# create & get cross user and drop root privileges [2]
RUN groupadd --system cross \
&& useradd --create-home --system --gid cross --groups sudo --uid 1000 cross;
RUN echo "cross:pi-cross" | chpasswd;
USER cross
ENV HOME=/home/cross
ENV USER=cross
WORKDIR /home/cross

# install rust via rustup and configure cross-compilation for raspberry pi [4]
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN /bin/bash -c 'source $HOME/.cargo/env && rustup target add arm-unknown-linux-gnueabihf'
COPY cargo-config $HOME/.cargo/config
COPY bin $HOME/bin

# download the raspberry pi tools from github and set up the toolchain
RUN wget -nv https://github.com/raspberrypi/tools/archive/master.zip && unzip master.zip && mv tools-master pi-tools
ENV PITOOLS_ROOT=$HOME/pi-tools
ENV TOOLCHAIN=$PITOOLS_ROOT/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin
ENV SYSROOT=$PITOOLS_ROOT/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/arm-linux-gnueabihf/sysroot
ENV CPP=$TOOLCHAIN/arm-linux-gnueabihf-cpp
ENV CXX=$TOOLCHAIN/arm-linux-gnueabihf-g++
ENV AR=$TOOLCHAIN/arm-linux-gnueabihf-ar
COPY bin/gcc-sysroot $TOOLCHAIN
ENV CC=$TOOLCHAIN/gcc-sysroot
COPY bin/pi-cross-pkg-config $TOOLCHAIN
ENV PKG_CONFIG=$TOOLCHAIN/pi-cross-pkg-config
ENV PKG_CONFIG_ALLOW_CROSS=1

ENV PATH $HOME/.cargo/bin:$HOME/bin:$TOOLCHAIN:$PATH
ENTRYPOINT ["run.sh"]

# [1] http://hackaday.com/2016/02/03/code-craft-cross-compiling-for-the-raspberry-pi/
# [2] https://github.com/Ogeon/rust-on-raspberry-pi
# [3] https://wiki.debian.org/CrossToolchains
# [4] https://github.com/rust-lang-nursery/rustup.rs
