#!/bin/bash

#ver=2.15.3
#ver=3.0.3
ver=3.1.0
#ver=3.1.1
R_ARCH=opt-iomp-mkl

# Specify the path to MKL installation
#MKL_LIB_PATH=/opt/common/intel/composerxe-2011.1.107/mkl/lib/intel64
MKL_LIB_PATH=/opt/stow/intel/composer_xe_2013_sp1.1.106/mkl/lib/intel64
export LD_LIBRARY_PATH=$MKL_LIB_PATH:$LD_LIBRARY_PATH

# Specify build dir and install dir
tmp_dir=/tmp/phi/R
base_dir=$PWD
R_HOME=$base_dir/$ver/$R_ARCH

function download_pkg()
{
    ver=$1
    fname=R-$ver
    tarball=$fname.tar.gz
    
    ver_major=${ver%%.*}
    url_suffix=src/base/R-$ver_major/$tarball
    [ -f $tarball ] ||  \
	wget http://watson.nci.nih.gov/cran_mirror/$url_suffix || \
	wget http://cran.wustl.edu/$url_suffix
    echo "unpacking R $ver, patience..."
    tar -zxf $tarball
    mv $fname $ver
    rm $tarball
}

if [ ! -d $ver ]; then
    mkdir -p $tmp_dir; cd $tmp_dir
    download_pkg $ver
    mkdir -p $base_dir/$ver
    ln -s $tmp_dir/$ver $base_dir/$ver/src
    cd $base_dir
fi
cd $ver/src

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
    CC="gcc -m64 -mtune=native" \
    CXX="g++ -m64 -mtune=native" \
    F77="gfortran -m64 -mtune=native" \
    FC="gfortran -m64 -mtune=native" \
    --with-x=yes

make -j8
make check-all
make install

cd $base_dir/$ver

function gen_modulefile()
{
    echo "#%Module 1.0"
    echo "#"
    echo "#  R $ver"
    echo "#"

    echo "prepend-path	PATH		$R_HOME/bin"
    echo "prepend-path	MANPATH		$R_HOME/share/man"
    echo "prepend-path  LD_LIBRARY_PATH $MKL_LIB_PATH"
}

MODULE_DIR=$HOME/.modulefiles
if [ ! -d $MODULE_DIR/R ]; then
    mkdir $MODULE_DIR/R
fi
gen_modulefile >$MODULE_DIR/R/$ver
