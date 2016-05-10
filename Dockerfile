FROM debian:jessie

# install debian dependencies before we lose root privileges [2]
RUN apt-get update \
&& apt-get install -y sudo git build-essential file wget curl python libjemalloc1 llvm pkg-config;

# add cross-compilation support for armhf [3]
RUN echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/crosstools.list;
RUN curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -;
RUN dpkg --add-architecture armhf && apt-get update && apt-get install -y crossbuild-essential-armhf

# create & get cross user and drop root privileges [2]
RUN groupadd --system cross \
&& useradd --create-home --system --gid cross --groups sudo --uid 1000 cross;
USER cross
ENV HOME=/home/cross


# [1] http://hackaday.com/2016/02/03/code-craft-cross-compiling-for-the-raspberry-pi/
# [2] https://github.com/Ogeon/rust-on-raspberry-pi
# [3] https://wiki.debian.org/CrossToolchains
