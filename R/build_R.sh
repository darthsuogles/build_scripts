#!/bin/bash

#ver=2.15.3
ver=3.0.3

# Specify the path to MKL installation
MKL_LIB_PATH=/opt/common/intel/composerxe-2011.1.107/mkl/lib/intel64

# Specify build dir and install dir
tmp_dir=/scratch1/phi/R
base_dir=$PWD

R_ARCH=opt-iomp-mkl
R_HOME=$base_dir/$ver/$R_ARCH

function download_pkg()
{
    ver=$1
    fname=R-$ver
    tarball=$fname.tar.gz
    wget http://watson.nci.nih.gov/cran_mirror/src/base/R-3/$tarball
    echo "unpacking R $ver, patience..."
    tar -zxf $tarball
    mv $fname $ver
    rm $tarball
}

if [ ! -d $ver ]; then
    mkdir -p $tmp_dir; cd $tmp_dir
    download_pkg $ver
    ln -s $tmp_dir/$ver $base_dir/$ver
    cd $base_dir
fi

cd $ver

OPT_FLAGS="-O3 -funroll-loops -march=native"
#MKL_LIB_PATH=/opt/stow/intel/composer_xe_2013_sp1.1.106/mkl/lib/intel64
#MKL_LIB_PATH=/opt/common/intel/composerxe-2011.1.107/mkl/lib/intel64
MKL=" -L${MKL_LIB_PATH}                         \
      -Wl,--start-group                         \
          -lmkl_gf_lp64       \
          -lmkl_gnu_thread    \
          -lmkl_core          \
      -Wl,--end-group                           \
      -lgomp -lpthread"

#./configure --prefix=$PWD/build-tree/opt-iomp-mkl \
./configure --prefix=$R_HOME \
    --build=x86_64-redhat-linux-gnu \
    --enable-R-shlib \
    --with-blas="$MKL" --with-lapack \
    CXX="g++" CXXFLAGS="$OPT_FLAGS" \
    F77="gfortran" FFLAGS="$OPT_FLAGS" \
    FC="gfortran" FCFLAGS="$OPT_FLAGS" \
    --with-x=yes

make -j8
make install

cd ..

function gen_modulefile()
{
    echo "#%Module 1.0"
    echo "#"
    echo "#  R $ver"
    echo "#"

    echo "prepend-path	PATH		$R_HOME/bin"
    echo "prepend-path	MANPATH		$R_HOME/share/man"
}

MODULE_DIR=$HOME/.modulefiles
if [ ! -d $MODULE_DIR/R ]; then
    mkdir $MODULE_DIR/R
fi
gen_modulefile >$MODULE_DIR/R/$ver
