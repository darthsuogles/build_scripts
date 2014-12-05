#!/bin/bash

# Ref: http://www.remotesensing.org/libtiff/
ver=4.0.3

source ../../build_pkg.sh
prepare_pkg libtiff ftp://ftp.remotesensing.org/pub/libtiff/tiff-$ver.tar.gz $ver install_dir

cd $ver
./configure --prefix=$HOME/local
make -j16
make install
