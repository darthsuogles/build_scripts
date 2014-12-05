#!/bin/bash

#ver=2.5.0
ver=${1:-2.6.1}

tarball=v$ver.tar.gz
if [ ! -f $tarball ]; then
    wget https://github.com/google/protobuf/archive/$tarball
    [ -f $tarball ] || mv v$ver $tarball
fi


source ../build_pkg.sh
prepare_pkg protobuf $PWD/v2.6.1.tar.gz $ver install_dir

cd $ver
[ -f configure ] || ./autogen.sh
./configure --prefix=$install_dir
make -j8
make install
