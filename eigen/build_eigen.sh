#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

function c_fn() {
    mkdir -p build-tree && cd $_
    CC=gcc CXX=g++ cmake \
      -D CMAKE_INSTALL_PREFIX=$install_dir \
      ..
}

guess_build_pkg eigen http://bitbucket.org/eigen/eigen/get/3.2.8.tar.bz2 \
                -c "c_fn"


