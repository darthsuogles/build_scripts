#!/bin/bash

source ../build_pkg.sh

if ! module load szlib; then
    guess_build_pkg szlib "http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz" -d "openmpi"
fi

function c_fn() {
    module load szlib
    ./configure --prefix=${install_dir} \
                --enable-build-mode=production \
                --disable-dependency-tracking \
                --enable-fortran \
                --with-szlib=${SZLIB_ROOT} \
                --enable-filters=all \
                --enable-static=yes \
                --enable-shared=yes \
                --enable-parallel
}

function b_fn() {
    make -j32
    #make check    
}

function i_fn() {
    make install
    make check-install
}

USE_LATEST_VERSION=no
guess_build_pkg hdf5 "https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0/src/hdf5-1.10.0.tar.bz2" \
                -c "c_fn" -b "b_fn" -i "i_fn" -d "openmpi szlib"
