#!/bin/bash

ver=${1:-0.3.3}

tarball=glog-$ver.tar.gz
[ -f $tarball ] || curl -O -k https://google-glog.googlecode.com/files/$tarball

source ../build_pkg.sh
prepare_pkg glog $PWD/$tarball $ver install_dir

cd $ver
./configure --prefix=$install_dir
make -j16
make install
