#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh

BUILD_FFTW=yes

function configure_fn() {
    CC=gcc CXX=g++ FC=gfortran ./configure --prefix=$install_dir \
      --enable-shared --enable-fma --enable-threads --enable-openmp
}

guess_build_pkg fftw ftp://ftp.fftw.org/pub/fftw/fftw-3.3.4.tar.gz -c "configure_fn"
guess_print_modfile fftw ${fftw_ver}
