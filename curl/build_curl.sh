#!/bin/bash

ver=7.37.0
build_dir=/tmp/phi/curl
install_dir=$HOME/local

source ../build_pkg.sh

mkdir -p $build_dir; cd $build_dir
update_pkg http://curl.haxx.se/download/curl-$ver.tar.bz2 $ver
mkdir $PWD/$ver; ln -s $build_dir/$ver $PWD/$ver/src

cd $build_dir/$ver
./configure --prefix=$install_dir
make -j8
make install
