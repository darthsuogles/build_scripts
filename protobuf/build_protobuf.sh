#!/bin/bash

ver=2.5.0

build_dir=/tmp/protobuf
install_dir=$PWD/$ver

source ../build_pkg.sh

mkdir -p $build_dir; cd $build_dir
update_pkg https://protobuf.googlecode.com/files/protobuf-$ver.tar.bz2 $ver
[ -d $build_dir/$ver ] || quit_with "failed to fetch the source"

cd $ver
./configure --prefix=$install_dir
make -j8
make install

ln -s $build_dir/$ver $install_dir/src
cd $install_dir
