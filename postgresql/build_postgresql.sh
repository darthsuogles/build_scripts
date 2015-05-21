#!/bin/bash
ver=9.4.1
pkg=postgresql

source ../build_pkg.sh

prepare_pkg $pkg http://ftp.$pkg.org/pub/source/v$ver/$pkg-$ver.tar.bz2 $ver install_dir

cd $ver
./configure --prefix=$install_dir
make -j8
make install
