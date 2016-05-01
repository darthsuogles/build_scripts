#!/bin/bash

ver=1.8.19

BUILD_SZLIB=no
BUILD_HDF5=no

source ../build_pkg.sh
source ../gen_modules.sh 

# Prerequisites
module load openmpi

function build_szlib() {
    local ver=2.1
    local url="http://www.hdfgroup.org/ftp/lib-external/szip/$ver/src/szip-$ver.tar.gz"
    prepare_pkg szlib $url $ver install_dir
    szlib_ver=${ver}
    szlib_dir=${install_dir}

    [ "yes" == "${BUILD_SZLIB}" ] || return
    cd $ver
    ./configure --prefix="${install_dir}"
    make -j32
    make check
    make install
}
build_szlib

function build_hdf5() {
    local latest_ver=$(curl -s www.hdfgroup.org/HDF5/release/obtainsrc.html | \
	                          perl -ne 'print "$1\n" if /hdf5-(\d+(\.\d+)*)\.tar\.bz2/' | \
                              head -n1)
    [ -z "${latest_ver}" ] || ver="${latest_ver}"

    local url="http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-${ver}/src/hdf5-${ver}.tar.bz2"
    prepare_pkg hdf5 ${url} ${ver} install_dir
    hdf5_ver=${ver}
    hdf5_dir=${install_dir}

    [ "yes" == "${BUILD_HDF5}" ] || return
    cd $ver
    ./configure --prefix=${install_dir} \
                --enable-production --enable-debug=no \
                --disable-dependency-tracking \
                --enable-fortran \
                --enable-cxx \
                --with-szlib=$szlib_dir \
                --enable-filters=all \
                --enable-static=yes \
                --enable-shared=yes \
                --enable-parallel
    make -j8
    make check
    make install
    make check-install
}
build_hdf5

print_header hdf5 ${hdf5_ver}
print_modline "prepend-path PATH ${hdf5_dir}/bin"
print_modline "prepend-path CPATH ${hdf5_dir}/include"
print_modline "prepend-path LIBRARY_PATH ${hdf5_dir}/lib"
print_modline "setenv HDF5_EXAMPLES ${hdf5_dir}/share/hdf5_examples"
