#!/bin/bash

pkg=cmake
#ver=${1:-2.8.12.2}
ver=${1:-3.2.2}
ver_major=${ver%.*}

source ../build_pkg.sh

url=http://www.cmake.org/files/v$ver_major/cmake-$ver.tar.gz
prepare_pkg $pkg $url $ver install_dir


cd $ver
#./configure --prefix=$HOME/local
./configure --prefix=$install_dir
make -j8
make install
cd ..
