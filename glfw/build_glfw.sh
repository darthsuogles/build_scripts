#!/bin/bash

ver=3.0.4

build_dir=/tmp/phi/glfw
install_dir=$PWD/$ver

source ../build_pkg.sh

mkdir -p $build_dir; cd $build_dir
if [ ! -d $ver ]; then
    fname=glfw-$ver
    tarball=$fname.zip
    [ -f $tarball ] || wget http://downloads.sourceforge.net/project/glfw/glfw/$ver/$tarball
    unzip $tarball; mv $fname $ver
    [ -d $ver ] || quit_with "cannot download and unzip the file"
    mkdir -p $install_dir; 
    [ -d $install_dir/src ] || ln -s $build_dir/$ver $install_dir/src
fi

cd $ver
mkdir -p build-tree; cd build-tree
CC=gcc CXX=g++ cmake ..
make -j8
make install
