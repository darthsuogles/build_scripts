#!/bin/bash

source ../build_pkg.sh

set -ex

module load szlib || \
    guess_build_pkg szlib "http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz" -d "openmpi"

function apply_flock_patch {    
    if [[ -n "${APPLY_FLOCK_PATCH_V110}" ]]; then
        local url_prefix="https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0-patch1"
        local patch_diff="file-lock-removal.diff"
        wget "${url_prefix}/patch/${patch_diff}"
        patch -p0 < "${patch_diff}"
    fi
}

function c_fn_mpi() {
    apply_flock_patch
    module load szlib    
    ./configure --prefix=${install_dir} \
                --enable-build-mode=production \
                --enable-optimization=high \
                --enable-parallel \
                --with-szlib=${SZLIB_ROOT} \
                --enable-shared=yes \
                CC=mpicc CXX=mpicxx \
                CPPFLAGS="-I${OPENMPI_ROOT}/include -I${SZLIB_ROOT}/include" \
                LDFLAGS="-Wl,-rpath=${OPENMPI_ROOT}/lib -L${OPENMPI_ROOT}/lib -Wl,-rpath=${SZLIB_ROOT}/lib -L${SZLIB_ROOT}/lib"
}

function c_fn_cxx() {
    apply_flock_patch
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

if [ -n "${BUILD_PYTABLES}" ]; then
    url=http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.17.tar.bz2
    guess_build_pkg hdf5 "${url}" -t "pytables" -c "c_fn_mpi" -b "b_fn" -i "i_fn" -d "openmpi szlib"
elif [ -n "${BUILD_PARALLEL}" ]; then
    log_info "Building HDF5 1.10 Parallel"
    APPLY_FLOCK_PATCH_V110=yes
    url=http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0-patch1/src/hdf5-1.10.0-patch1.tar.bz2
    guess_build_pkg hdf5 "${url}" -t "parallel" -c "c_fn_mpi" -b "b_fn" -i "i_fn" -d "openmpi szlib"
else
    log_info "Building HDF5 1.10 C++"
    APPLY_FLOCK_PATCH_V110=yes
    url=http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0-patch1/src/hdf5-1.10.0-patch1.tar.bz2
    guess_build_pkg hdf5 "${url}" -t "cxx" -c "c_fn_cxx" -b "b_fn" -i "i_fn" -d "openmpi szlib"
fi
