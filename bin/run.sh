#!/bin/bash

echo "SYSROOT=$SYSROOT";
cd $SYSROOT;
for i in `find $HOME/deb-deps -name '*.deb' -type f`; do
echo "Extracting: $i";
/bin/bash -c "ar p $i data.tar.xz | unxz | tar x";
done
