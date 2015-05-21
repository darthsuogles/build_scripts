#!/bin/bash

pkg=fftw
ver=3.3.4

source ../build_pkg.sh
prepare_pkg $pkg ftp://ftp.$pkg.org/pub/$pkg/$pkg-$ver.tar.gz $ver install_dir

cd $ver
./configure --prefix=$install_dir \
    --enable-shared --enable-fma \
    --enable-threads --enable-openmp
make -j8
make install
