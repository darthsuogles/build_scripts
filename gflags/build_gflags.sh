#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_GFLAGS=yes

function build_gflags() {

    local ver=2.1.2
    local url="https://github.com/schuhschuh/gflags/archive/v${ver}.tar.gz"
    prepare_pkg gflags ${url} ${ver} install_dir
    gflags_ver=${ver}
    gflags_dir=${install_dir}

    [ "yes" == "${BUILD_GFLAGS}" ] || return
    cd $ver
    mkdir -p build-tree; cd build-tree
    CC=gcc CXX=g++ CXXFLAGS="-fPIC" cmake .. \
      -DCMAKE_INSTALL_PREFIX=${install_dir}
    make -j32
    make install
}
build_gflags
