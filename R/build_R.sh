#!/bin/bash

ver=3.1.1
R_ARCH=opt-iomp-mkl

# Specify build dir and install dir
OPT_FLAGS="-O3 -funroll-loops -march=native"
MKL_LIB_PATH=/opt/stow/intel/composer_xe_2013_sp1/mkl/lib/intel64
export LD_LIBRARY_PATH=$MKL_LIB_PATH:$LD_LIBRARY_PATH
MKL=" -L${MKL_LIB_PATH}                         \
      -Wl,--start-group                         \
          -lmkl_gf_lp64       \
          -lmkl_gnu_thread    \
          -lmkl_core          \
      -Wl,--end-group                           \
      -lgomp -lpthread"

source ../build_pkg.sh
prepare_pkg R http://watson.nci.nih.gov/cran_mirror/src/base/R-latest.tar.gz $ver install_dir
cd $ver

./configure --prefix=$install_dir \
    --build=x86_64-redhat-linux-gnu \
    --enable-R-shlib \
    --with-blas="$MKL" --with-lapack \
    CC="gcc -m64 -mtune=native" \
    CXX="g++ -m64 -mtune=native" \
    F77="gfortran -m64 -mtune=native" \
    FC="gfortran -m64 -mtune=native" \
    --with-x=yes

make -j8
make check-all
make install
