#!/bin/bash

ver=2.84
pkg=transmission

source ../build_pkg.sh
prepare_pkg $pkg https://$pkg.cachefly.net/$pkg-$ver.tar.xz $ver install_dir

module load libevent

cd $ver
./configure --prefix=$install_dir
make -j8
make install
