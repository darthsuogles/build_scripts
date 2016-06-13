#!/bin/bash

BUILD_CMAKE=yes

source ../build_pkg.sh
source ../gen_modules.sh

function build_cmake() {
    local latest_ver=$(curl -sL https://cmake.org/download/ | \
                              perl -ne 'print "$1\n" if /cmake-(\d+(\.\d+)*)\.tar\.gz/' | head -n1)
    [ -z "${latest_ver}" ] || local ver=${latest_ver}
    local ver_major=${ver%.*}
    local url="http://www.cmake.org/files/v$ver_major/cmake-$ver.tar.gz"
    prepare_pkg cmake ${url} ${ver} install_dir
    [ "yes" == "${USE_MUSL_CROSS}" ] && local install_dir=${install_dir}-musl
    cmake_ver=${ver}
    cmake_dir=${install_dir}
    
    [ "yes" == "${BUILD_CMAKE}" ] || return
    cd $ver        
    ./bootstrap --prefix=${install_dir} \
                --parallel=32
    make -j32
    make install
}
#build_cmake

guess_print_modfile cmake 3.5.2
