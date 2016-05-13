# pi-cross-toolchain

This is an attempt to create a dockerized process for cross-compiling code
for the Raspberry Pi's ARM architecture. The docker image is based on debian
jessie.

See Dockerfile for more information, sources, etc.

## Installation

To build the docker image:

`docker build --tag pi-cross-32bit .`

## Usage

To open a login shell with a project directory mounted:

    docker run -i -t --entrypoint=/bin/bash --volume ~/src/pizero/hello-project/:/home/cross/project pi-cross-32bit

The container will have env variables $CPP and $CC set to point to the appropriate
executables in the /opt/pi-tools directory. Use them like this:

    $ $CPP -O3 -g3 -Wall -c -fPIC hello.cpp
    $ $CPP -o hello hello.o
