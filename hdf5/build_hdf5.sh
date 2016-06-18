#!/bin/bash

source ../build_pkg.sh

set -ex

#guess_build_pkg szlib "http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz" -d "openmpi"

function c_fn_mpi() {
    module load szlib
    ./configure --prefix=${install_dir} \
                --enable-build-mode=production \
                --enable-optimization=high \
                --enable-parallel \
                --with-szlib=${SZLIB_ROOT} \
                --enable-shared=yes \
                CXX=mpicxx \
                CPPFLAGS="-I${OPENMPI_ROOT}/include -I${SZLIB_ROOT}/include" \
                LDFLAGS="-Wl,-rpath=${OPENMPI_ROOT}/lib -L${OPENMPI_ROOT}/lib -Wl,-rpath=${SZLIB_ROOT}/lib -L${SZLIB_ROOT}/lib"
}

function c_fn_cxx() {
    module load szlib
    ./configure --prefix=${install_dir} \
                --enable-build-mode=production \
                --enable-optimization=high \
                --enable-cxx \
                --with-szlib=${SZLIB_ROOT} \
                --enable-shared=yes \
                CC=gcc CXX=g++ \
                CPPFLAGS="-I${SZLIB_ROOT}/include" \
                LDFLAGS="-Wl,-rpath=${SZLIB_ROOT}/lib -L${SZLIB_ROOT}/lib" 
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
                -t "parallel" -c "c_fn_mpi" -b "b_fn" -i "i_fn" -d "openmpi szlib"

guess_build_pkg hdf5 "https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0/src/hdf5-1.10.0.tar.bz2" \
                -t "cxx" -c "c_fn_cxx" -b "b_fn" -i "i_fn" -d "openmpi szlib"
