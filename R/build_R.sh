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

function configure_lto() {
    local opt_flags="-O3 -funroll-loops -mtune=native -ffat-lto-objects"
    local brew_ldflags="-Wl,-rpath=$(brew --prefix)/lib -L$(brew --prefix)/lib -Wl,-rpath=$(brew --prefix)/lib64 -L$(brew --prefix)/lib64"

    alias gcc-ar="gcc-ar-6"
    alias gcc-nm="gcc-nm-6"
    alias gcc-ranlib="gcc-ranlib-6"

    # Currently not LTO
    ./configure --prefix=$install_dir \
                --enable-R-profiling \
                --enable-static \
                --enable-shared \
                --with-blas --with-lapack \
                --enable-lto \
                CC=gcc CFLAGS="${CFLAGS} ${opt_flags}" \
                CXX=g++ CXXFLAGS="${CXXFLAGS} ${opt_flags}" \
                CXX1X=g++ CXX1XSTD="-std=c++11" \
                F77=gfortran FFLAGS="${opt_flags}" \
                FC=gfortran FCFLAGS="${opt_flags}" \
                CPPFLAGS="${CPPFLAGS} -I$(brew --prefix)/include" \
                LDFLAGS="${LDFLAGS} ${brew_ldflags}" \
                JAVA_HOME="/usr/lib/jvm/java-7-oracle/" \
                --with-x=no
}

function configure_drgscl() {
    local opt_flags="-O3 -mtune=native -fgraphite -fgraphite-identity -floop-block -floop-interchange -floop-strip-mine -floop-parallelize-all -floop-unroll-and-jam -ftree-loop-linear"

    local brew_ldflags="-Wl,-rpath=$(brew --prefix)/lib -L$(brew --prefix)/lib -Wl,-rpath=$(brew --prefix)/lib64 -L$(brew --prefix)/lib64"

    # Currently not LTO
    ./configure --prefix=$install_dir \
                --enable-R-profiling \
                --enable-static \
                --enable-shared \
                --with-blas --with-lapack \
                CC=gcc CFLAGS="${CFLAGS} ${opt_flags}" \
                CXX=g++ CXXFLAGS="${CXXFLAGS} ${opt_flags}" \
                CXX1X=g++ CXX1XSTD="-std=c++11" \
                F77=gfortran FFLAGS="${opt_flags}" \
                FC=gfortran FCFLAGS="${opt_flags}" \
                CPPFLAGS="${CPPFLAGS} -I$(brew --prefix)/include" \
                LDFLAGS="${LDFLAGS} ${brew_ldflags}" \
                JAVA_HOME="/usr/lib/jvm/java-7-oracle/" \
                --with-x=no
}

module purge
url="https://cran.cnr.berkeley.edu/src/base/R-3/R-3.3.0.tar.gz"
guess_build_pkg R "${url}" -t "lto" -c "configure_lto" -d "linuxbrew openblas fftw zlib bzip2 pcre curl"
#guess_build_pkg R "${url}" -t "drgscl" -c "configure_drgscl" -d "linuxbrew toolchain openblas fftw zlib bzip2"
#guess_build_pkg R "${url}" -c "configure_R_openblas" -d "linuxbrew openblas fftw zlib bzip2"
