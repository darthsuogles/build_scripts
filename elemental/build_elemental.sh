#!/bin/bash

ver=0.84

module load intel
BLAS_LIBS="-L$MKLROOT/lib/intel64  -lmkl_rt -lpthread -lm"
BLAS_INC="-I$MKLROOT/include"
module unload intel

source ../build_pkg.sh
prepare_pkg elemental http://libelemental.org/pub/releases/Elemental-$ver.tgz $ver install_dir

mkdir -p build-tree-$ver; cd build-tree-$ver

CC=gcc CXX=g++ FC=gfortran cmake ../$ver \
    -DCMAKE_INSTALL_PREFIX=$install_dir \
    -DCFLAGS="$BLAS_INC" \
    -DCXX_FLAGS="-std=c++11 $BLAS_INC" \
    -DMATH_LIBS="$BLAS_LIBS -lgfortran"

make -j8
make install
