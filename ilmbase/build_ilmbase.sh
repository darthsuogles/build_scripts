#!/bin/bash

ver=2.2.0
pkg=ilmbase

url=http://download.savannah.nongnu.org/releases/openexr/$pkg-$ver.tar.gz 

source ../build_pkg.sh
prepare_pkg $pkg $url $ver install_dir

cd $ver
./configure --prefix=$install_dir
make
make install
cd ..
