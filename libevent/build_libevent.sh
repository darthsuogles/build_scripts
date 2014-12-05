#!/bin/bash

#ver=2.0.21

source ../build_pkg.sh

# Download the package and store it somewhere
build_dir=`find_scratch_dir`/phi/libevent
install_dir=$PWD/dev
mkdir -p $build_dir; cd $build_dir
git clone https://github.com/libevent/libevent.git
#tarball=release-$ver-stable.tar.gz
#curl -o $tarball -kL https://github.com/libevent/libevent/archive/$tarball
#prepare_pkg libevent $PWD/$tarball $ver install_dir

cd libevent
[ -f configure ] || ./autogen.sh
./configure --prefix=$install_dir
make 
make verify
make install
