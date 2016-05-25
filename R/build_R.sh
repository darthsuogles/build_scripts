#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh

BUILD_R=yes
ver=3.2.5
R_ARCH=opt

function sudo_build_deps() {
    sudo apt-get install libz-dev libbz2-dev libtre-dev liblzma-dev tcl-dev tk-dev \
         libcairo-dev libjpeg-dev libpng-dev libtiff-dev libpcre3-dev \
         libfftw3-dev libopenblas-dev
}

function configure_R_mkl() {
    OPT_FLAGS="-O3 -funroll-loops -march=native"

    # Specify build dir and install dir
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
                --enable-R-shlib \
                --with-blas="$MKL" --with-lapack \
                CC="gcc -m64 -mtune=native" \
                CXX="g++ -m64 -mtune=native" \
                F77="gfortran -m64 -mtune=native" \
                FC="gfortran -m64 -mtune=native" \
                --with-x=yes
}

function configure_R_openblas() {
    module load linuxbrew
    # brew install bzip2 zlib tre xz 
    # brew install tcl-tk tre pcre
    # brew install cairo jpeg jpeg-turbo libpng libtiff 
    module load openblas fftw
    OPT_FLAGS="-O3 -funroll-loops -march=native"

    export CPATH="$(brew --prefix)/include"
    export LIBRARY_PATH="$(brew --prefix)/lib"
    ./configure --prefix=$install_dir \
                --enable-R-profiling \
                --enable-memory-profiling \
                --enable-lto \
                --with-blas --with-lapack \
                CC="gcc -m64 -mtune=native" \
                CXX="g++ -m64 -mtune=native" \
                F77="gfortran -m64 -mtune=native" \
                FC="gfortran -m64 -mtune=native" \
                CPPFLAGS="${CPPFLAGS} -I$(brew --prefix)/include" \
                LDFLAGS="${LDFLAGS} -Wl,-rpath=$(brew --prefix)/lib -L$(brew --prefix)/lib" \
                --with-x=no
}

guess_build_pkg R https://cran.cnr.berkeley.edu/src/base/R-3/R-3.3.0.tar.gz -c "configure_R_openblas"
guess_print_modfile R ${R_ver}
