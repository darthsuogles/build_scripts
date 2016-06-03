#!/bin/bash

source ../build_pkg.sh

pkg=fftw
ver=3.3.4

function c_fn() {
    ./configure --prefix=$install_dir \
                --enable-shared --enable-fma \
                --enable-threads --enable-openmp
}

guess_build_pkg $pkg ftp://ftp.$pkg.org/pub/$pkg/$pkg-$ver.tar.gz -c "c_fn"
