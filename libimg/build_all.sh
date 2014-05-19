#!/bin/bash

for pkg in libpng libjpeg; do
    cd $pkg
    ./build_$pkg.sh
    cd ..
done
