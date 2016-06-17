#!/bin/bash

source ../build_pkg.sh

set -ex

guess_build_pkg szlib "http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz" -d "openmpi"

function c_fn() {
    module load szlib
    ./configure --prefix=${install_dir} \
                --enable-build-mode=production \
                --disable-dependency-tracking \
                --enable-cxx \
                --enable-parallel \
                --with-szlib=${SZLIB_ROOT} \
                --enable-filters=all \
                --enable-static=yes \
                --enable-shared=yes \
                --enable-unsupported \
                CC=mpicc CXX=mpicxx \
                CPPFLAGS="-I${OPENMPI_ROOT}/include -I${SZLIB_ROOT}/include" \
                LDFLAGS="-Wl,-rpath=${OPENMPI_ROOT}/lib -L${OPENMPI_ROOT}/lib -Wl,-rpath=${SZLIB_ROOT}/lib -L${SZLIB_ROOT}/lib"
}

function b_fn() {
    make -j64
    #make check    
}

function i_fn() {
    make install
    make check-install
}

USE_LATEST_VERSION=no
guess_build_pkg hdf5 "https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0/src/hdf5-1.10.0.tar.bz2" \
                -c "c_fn" -b "b_fn" -i "i_fn" -d "openmpi szlib"
