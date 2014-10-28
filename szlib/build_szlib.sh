#!/bin/bash

ver=2.1

source ../build_pkg.sh

prepare_pkg szlib http://www.hdfgroup.org/ftp/lib-external/szip/$ver/src/szip-$ver.tar.gz $ver install_dir
echo $install_dir

cd $ver
./configure --prefix=$install_dir
make -j8
make check
make install
