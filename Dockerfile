# pi tools depend on a 32-bit architecture :(
FROM 32bit/debian:jessie

# install debian dependencies before we lose root privileges [2]
RUN apt-get update \
&& apt-get install -y sudo git build-essential unzip vim file wget curl python libjemalloc1 llvm pkg-config;

# download the raspberry pi tools from github and set ENV vars
RUN cd /opt && wget -nv https://github.com/raspberrypi/tools/archive/master.zip && unzip master.zip && mv tools-master pi-tools
ENV PITOOLS_ROOT=/opt/pi-tools
ENV CPP=$PITOOLS_ROOT/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-g++
ENV CC=$PITOOLS_ROOT/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-gcc

# create & get cross user and drop root privileges [2]
RUN groupadd --system cross \
&& useradd --create-home --system --gid cross --groups sudo --uid 1000 cross;
RUN echo "cross:pi-cross" | chpasswd;
USER cross
ENV HOME=/home/cross
ENV USER=cross

# install rust via rustup and configure cross-compilation for raspberry pi [4]
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN /bin/bash -c 'source $HOME/.cargo/env && rustup target add arm-unknown-linux-gnueabi'
COPY cargo-config $HOME/.cargo/config

ENV PATH $HOME/.cargo/bin:$PATH
WORKDIR /home/cross
ENTRYPOINT ["/bin/bash"]

# [1] http://hackaday.com/2016/02/03/code-craft-cross-compiling-for-the-raspberry-pi/
# [2] https://github.com/Ogeon/rust-on-raspberry-pi
# [3] https://wiki.debian.org/CrossToolchains
# [4] https://github.com/rust-lang-nursery/rustup.rs
