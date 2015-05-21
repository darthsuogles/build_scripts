#!/bin/bash

pkg=gnuplot
ver=5.0.0

source ../build_pkg.sh

prepare_pkg $pkg http://downloads.sourceforge.net/project/$pkg/$pkg/$ver/$pkg-$ver.tar.gz $ver install_dir
echo $install_dir

cd $ver
./configure --prefix=$install_dir
make -j8
make install
