#!/bin/bash

ver=0.82-p1

module load intel
BLAS_LIBS="-L$MKLROOT/lib/intel64  -lmkl_rt -lpthread -lm"
BLAS_INC="-I$MKLROOT/include"
module unload intel

function exit_with()
{
    #printf "Error: %s\n" $@; 
    echo "Error: $@, quit now" 
    exit    
}

if [ ! -d $ver ]; then
    fname=elemental-$ver
    tarball=$fname.tgz
    if [ ! -e $tarball ]; then
	wget http://libelemental.org/pub/releases/$tarball || \
	    exit_with "cannot download tarball"
    fi
    fname=`tar -ztf $tarball | sed -e "s@/.*@@" | uniq`
    if [ -z $fname || ! -d $fname ]; then 
	exit_with "cannot decompress the package $tarball"
    fi
    tar -zxvf $tarball
    mv $fname $ver
fi

cd $ver
rm -fr build-tree; mkdir -p build-tree; cd build-tree

# Error: this option is no-longer available
exit_with "the required toolchain is not built yet"
module load gcc48/openmpi-openib/1.6.4

export CC=`which gcc`
export CXX=`which g++`
export FC=`which gfortran`
cmake \
    -D CMAKE_INSTALL_PREFIX=$PWD/install \
    -D CFLAGS="$BLAS_INC" \
    -D CXX_FLAGS="-std=c++11 $BLAS_INC" \
    -D MATH_LIBS="$BLAS_LIBS -lgfortran" \
    ..
make -j8
make install
cd ..
cd ..
