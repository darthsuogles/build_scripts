#!/bin/bash

#curl -sL http://valgrind.org/downloads/current.html | perl -ne 'print "$1\n" if /valgrind-((\d+\.?)+?)\.tar\.bz2/' | sort | tail -n1

ver=3.10.0
source ../build_pkg.sh
prepare_pkg valgrind http://valgrind.org/downloads/valgrind-${ver}.tar.bz2 $ver install_dir
echo $install_dir

cd $ver
./configure --prefix=$install_dir
make -j8
make check
make install
