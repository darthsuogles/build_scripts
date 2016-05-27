#!/bin/bash

source ../build_pkg.sh 

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
    OPT_FLAGS="-O3 -funroll-loops -march=native"

    ./configure --prefix=$install_dir \
                --enable-R-profiling \
                --enable-memory-profiling \
                --enable-lto \
                --with-tcltk=no \
                --with-cairo=no \
                --with-libpng=no \
                --with-jpeglib=no \
                --with-libtiff=no \
                --with-system-zlib=yes \
                --with-system-bzlib=yes \
                --with-system-pcre=yes \
                --with-system-tre=yes \
                --with-system-xz=yes \
                --with-blas --with-lapack \
                CC="gcc -m64 -mtune=native" \
                CXX="g++ -m64 -mtune=native" \
                F77="gfortran -m64 -mtune=native" \
                FC="gfortran -m64 -mtune=native" \
                CPPFLAGS="-I$(brew --prefix)/include ${CPPFLAGS}" \
                LDFLAGS="-L$(brew --prefix)/lib ${LDFLAGS}" \
                --with-x=no
}

url="https://cran.cnr.berkeley.edu/src/base/R-3/R-3.3.0.tar.gz"
guess_build_pkg R "${url}" -c "configure_R_openblas" -d "openblas fftw zlib bzip2 linuxbrew"
