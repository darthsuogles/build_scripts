#!/bin/bash

pkg=metis
ver=${1:-5.1.0}

#url=http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-$ver.tar.gz
ver=4.0.1
url=http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-${ver}.tar.gz

source ../build_pkg.sh

prepare_pkg $pkg $url $ver install_dir

cd $ver
#make config shared=1 cc=gcc prefix=$install_dir
make config cc=gcc prefix=$install_dir
make -j8
make install
