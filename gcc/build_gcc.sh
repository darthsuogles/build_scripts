#!/bin/bash

source ./sysroot.sh
source ../build_pkg.sh

IS_SKIP_GCC=no

script_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
export CC=gcc-5
export CXX=g++-5

prepare_pkg binutils ${binutils_url} ${binutils_ver} install_dir
cd ${binutils_ver}
./configure --prefix=${toolchain_install_dir}
make -j32
make install

[ "yes" == "${IS_SKIP_GCC}" ] || (
    prepare_pkg gcc ${gcc_url} ${gcc_ver} install_dir
    echo "Packages will be installed at: ${toolchain_install_dir}"
    
    echo "Download prerequisite packages into the source tree"
    (cd ${gcc_ver} && ./contrib/download_prerequisites)

    src_dir=$PWD/${gcc_ver}
    mkdir -p build-tree-${gcc_ver}; cd build-tree-${gcc_ver}

    $src_dir/configure \
        --prefix=${toolchain_install_dir} \
        --enable-languages=c,c++,fortran \
        --enable-threads \
        --enable-lto \
        --enable-tls \
        --disable-multilib

    make profiledbootstrap -j32
    make install
)

prepare_pkg glibc ${glibc_url} ${glibc_ver} install_dir
mkdir build-tree-${glibc_ver} && cd $_
../${glibc_ver}/configure --prefix=${toolchain_install_dir} \
   --with-binutils=${toolchain_install_dir}
make -j32
make install
