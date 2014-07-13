#!/bin/bash

ver=2.0.21
build_dir=/tmp/phi/libevent
install_dir=$PWD

source ../build_pkg.sh

# Download the package and store it somewhere
mkdir -p $build_dir; cd $build_dir
update_pkg https://github.com/downloads/libevent/libevent/libevent-$ver-stable.tar.gz $ver
mkdir -p $install_dir/$ver
ln -s $build_dir/$ver $install_dir/$ver/src


