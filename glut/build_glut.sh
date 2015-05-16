#!/bin/bash

ver=${1:-3.0.0}
pkg=freeglut
url=http://downloads.sourceforge.net/project/freeglut/freeglut/$ver/freeglut-$ver.tar.gz

source ../build_pkg.sh
prepare_pkg $pkg $url $ver install_dir

cd $ver
rm -fr build-tree; mkdir build-tree; cd build-tree
CC=gcc CXX=g++ cmake \
    -D CMAKE_INSTALL_PREFIX=$install_dir \
    ..
make -j8
make install
