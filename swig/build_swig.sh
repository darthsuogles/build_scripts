#!/bin/bash

source ../build_pkg.sh

pkg_url=$(curl -sL http://www.swig.org/download.html | perl -ne 'print $1 if /(http:\/\/.*?\/swig-(\d+\.?)+?\.tar\.gz)/' | uniq)
ver=$(basename $pkg_url | perl -ne 'print $1 if /swig-((\d+\.?)+?)\.tar\.gz/')

echo $pkg_url $ver

prepare_pkg swig $pkg_url $ver install_dir
echo $install_dir

echo "Warning: this package will be installed under ~/local"
cd $ver
./configure --prefix=$HOME/local
make -j8
make install
