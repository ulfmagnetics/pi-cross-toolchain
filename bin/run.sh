#!/bin/bash

# Extract dependent libraries:
echo "SYSROOT=$SYSROOT";
cd $SYSROOT;
for i in `find $HOME/deb-deps -name '*.deb' -type f`; do
echo "Extracting: $i";
/bin/bash -c "ar p $i data.tar.xz | unxz | tar x";
done

# Patch the portaudio pkg-config file to fix some linking issues
# (see https://lists.columbia.edu/pipermail/portaudio/2015-October/000099.html)
pkgconfig=$SYSROOT/usr/lib/arm-linux-gnueabihf/pkgconfig/portaudio-2.0.pc;
echo "Patching: $pkgconfig";
sed -i '/^Libs:/s/$/ -ljack -ldb/' $pkgconfig;
