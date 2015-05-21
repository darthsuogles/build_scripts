#!/bin/bash

pkg=ncurses
ver=5.9

source ../build_pkg.sh

prepare_pkg $pkg http://ftp.gnu.org/pub/gnu/$pkg/$pkg-$ver.tar.gz $ver install_dir
echo $install_dir

cd $ver
./configure --prefix=$install_dir \
    --with-shared
make -j8 
make install
