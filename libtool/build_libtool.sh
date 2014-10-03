#!/bin/bash

source ../build_pkg.sh

ver=2.4.2

build_dir=/scratch0/phi/libtool
install_dir=$HOME/local

mkdir -p $build_dir; cd $build_dir
update_pkg http://mirror.team-cymru.org/gnu/libtool/libtool-$ver.tar.gz $ver
mkdir -p $install_dir; ln -s $build_dir/$ver $install_dir/src

cd $ver
./configure --prefix=$install_dir
make -j8
make install

