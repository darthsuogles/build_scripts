#!/bin/bash

ver=3.2.5
R_ARCH=opt

function get_latest() {
    local latest_ver=$(curl https://cran.r-project.org/src/base/R-3/ \
                              | perl -ne 'print "$1\n" if /(R-(\d+(\.\d+)*)\.tar\.gz)/' | sort -nr | head -n1)
    ver=$latest_ver
}

# Specify build dir and install dir
OPT_FLAGS="-O3 -funroll-loops -march=native"
if [ "opt-iomp-mkl" == "${ver}" ]; then
    MKL_LIB_PATH=/opt/stow/intel/composer_xe_2013_sp1/mkl/lib/intel64
    export LD_LIBRARY_PATH=$MKL_LIB_PATH:$LD_LIBRARY_PATH
    MKL=" -L${MKL_LIB_PATH}                         \
      -Wl,--start-group                         \
          -lmkl_gf_lp64       \
          -lmkl_gnu_thread    \
          -lmkl_core          \
      -Wl,--end-group                           \
      -lgomp -lpthread"
fi

source ../build_pkg.sh
prepare_pkg R http://watson.nci.nih.gov/cran_mirror/src/base/R-latest.tar.gz $ver install_dir
cd $ver

if [ "opt-iomp-mkl" == "${ver}" ]; then
    ./configure --prefix=$install_dir \
                --build=x86_64-redhat-linux-gnu \
                --enable-R-shlib \
                --with-blas="$MKL" --with-lapack \
                CC="gcc -m64 -mtune=native" \
                CXX="g++ -m64 -mtune=native" \
                F77="gfortran -m64 -mtune=native" \
                FC="gfortran -m64 -mtune=native" \
                --with-x=yes
else
    sudo apt-get install libz-dev libbz2-dev libtre-dev liblzma-dev tcl-dev tk-dev \
         libcairo-dev libjpeg-dev libpng-dev libtiff-dev libpcre3-dev \
         libfftw3-dev libopenblas-dev

    ./configure --prefix=$install_dir \
                --enable-R-profiling \
                --enable-memory-profiling \
                --enable-lto \
                --with-tcltk=no \
                --with-cairo=yes \
                --with-libpng=yes \
                --with-jpeglib=yes \
                --with-libtiff=yes \
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
                --with-x=no
fi

make -j8
make check-all
make install
