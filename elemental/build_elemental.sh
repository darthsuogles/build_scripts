#!/bin/bash

source ../build_pkg.sh 

function c_fn() {
    mkdir -p build-tree && cd $_

    CC=gcc CXX=g++ FC=gfortran cmake \
      -D CMAKE_INSTALL_PREFIX="${install_dir}" \
      -D CMAKE_CXX_COMPILER=g++ \
      -D CMAKE_C_COMPILER=gcc \
      -D CMAKE_Fortran_COMPILER=gfortran \
      -D CMAKE_BUILD_TYPE=HybridRelease \
      ..
}

url=https://github.com/elemental/Elemental.git
guess_build_pkg elemental ${url} -c "c_fn" -d "linuxbrew openblas openmpi"
