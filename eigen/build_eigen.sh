#!/bin/bash

ver=3.2.4
pkg=eigen

source ../build_pkg.sh

prepare_pkg $pkg http://bitbucket.org/eigen/eigen/get/$ver.tar.bz2 $ver install_dir

cd $ver
rm -fr build-tree; mkdir -p build-tree; cd build-tree
CC=gcc CXX=g++ cmake \
    -D CMAKE_INSTALL_PREFIX=$install_dir \
    ..
make install
