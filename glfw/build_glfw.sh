#!/bin/bash

ver=3.1.1
pkg=glfw

source ../build_pkg.sh

url=http://downloads.sourceforge.net/project/$pkg/$pkg/$ver/$pkg-$ver.zip
prepare_pkg $pkg $url $ver install_dir

cd $ver
rm -fr build-tree; mkdir -p build-tree; cd build-tree
CC=gcc CXX=g++ cmake \
    -D CMAKE_INSTALL_PREFIX:PATH=$install_dir \
    ..
make -j8
make install
