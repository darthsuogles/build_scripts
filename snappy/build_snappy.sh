#!/bin/bash

ver=${1:-1.1.1}

source ../build_pkg.sh
prepare_pkg snappy https://snappy.googlecode.com/files/snappy-$ver.tar.gz $ver install_dir

cd $ver
./configure --prefix=$install_dir
make -j16
make install
