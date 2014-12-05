#!/bin/bash

ver=${1:-2.1.1}

tarball=v$ver.tar.gz
if [ ! -f $tarball ]; then
    wget -L https://github.com/schuhschuh/gflags/archive/$tarball
    [ -f $tarball ] || mv v$ver $tarball
fi

source ../build_pkg.sh
prepare_pkg gflags $PWD/$tarball $ver install_dir

cd $ver
mkdir -p build-tree; cd build-tree
CC=gcc CXX=g++ CXXFLAGS="-fPIC" cmake .. \
    -DCMAKE_INSTALL_PREFIX=$install_dir -DGFLAGS_NAMESPACE=google
make -j16
make install
