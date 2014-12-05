#!/bin/bash

ver=${1:-1.15.0}

source ../build_pkg.sh
prepare_pkg leveldb https://leveldb.googlecode.com/files/leveldb-$ver.tar.gz $ver install_dir

cd $ver
CC=gcc CXX=g++ CXXFLAGS="-std=c++11" make -j16
echo "Installing the whole source directory"
rm -fr $install_dir
cp -r $PWD $install_dir
