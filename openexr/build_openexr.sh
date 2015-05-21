#!/bin/bash

ver=2.2.0
pkg=openexr

module load ilmbase
# Dependency check
#ilmbase_ver=$ver
#ilmbase_dir=$PWD/../ilmbase/$ilmbase_ver

url=http://download.savannah.nongnu.org/releases/$pkg/$pkg-$ver.tar.gz
source ../build_pkg.sh
prepare_pkg $pkg $url $ver install_dir

cd $ver
./configure --prefix=$install_dir
#    --with-ilmbase-prefix=$ilmbase_dir
make 
make install
cd ..
