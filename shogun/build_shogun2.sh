#!/bin/bash

source ../build_pkg.sh

ver=2.1.0

prepare_pkg shogun http://shogun-toolbox.org/archives/shogun/releases/${ver%.*}/sources/shogun-$ver.tar.bz2 $ver install_dir
echo $install_dir

cd $ver/src
./configure --prefix=$install_dir \
    --interfaces=python_static \
    --disable-lapack \
    --enable-hmm-parallel
make -j8
make check
make install
