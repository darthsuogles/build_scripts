#!/bin/bash

ver=${1:-2.4.10}

source ../build_pkg.sh

tmp_dir=`find_scratch_dir`/phi/opencv
base_dir=$PWD
install_dir=$base_dir/$ver/vanilla

cd $tmp_dir
if [ ! -d $ver ]; then
    fname=opencv-$ver
    tarball=$fname.zip

    mkdir -p $tmp_dir; cd $tmp_dir
    if [ ! -f $tarball ]; then
	wget http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/$ver/$tarball
    fi
    unzip $tarball
    mv $fname $ver
    rm $tarball
    mkdir -p $base_dir/$ver
    ln -s $tmp_dir/$ver $base_dir/$ver/src
fi


cd $ver

rm -fr build-tree; mkdir -p build-tree; cd build-tree
cmake .. \
    -DCMAKE_PREFIX_PATH=$HOME/local \
    -DCMAKE_INSTALL_PREFIX:PATH=$install_dir \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DBUILD_PYTHON_SUPPORT=ON \
    -DUSE_CUDA=ON 
make -j16
make install
