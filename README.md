# pi-cross-toolchain

This is an attempt to create a dockerized process for cross-compiling code
for the Raspberry Pi's ARM architecture. The docker image is based on debian
jessie.

See Dockerfile for more information, sources, etc.

## Installation

To build the docker image:

`docker build --tag pi-cross .`

## Usage

To open a login shell:

`docker run -i -t --entrypoint=/bin/bash pi-cross`
