#!/bin/bash

ver=${1:-2.4.11}

source ../build_pkg.sh

tmp_dir=`find_scratch_dir`/phi/opencv
base_dir=$PWD
install_dir=$base_dir/$ver/vanilla
python_basedir=`dirname $(which python)`/../

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
cmake \
    -D CMAKE_PREFIX_PATH=$HOME/local \
    -D CMAKE_INSTALL_PREFIX:PATH=$install_dir \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D BUILD_PYTHON_SUPPORT:BOOL=ON \
    -D PYTHON_LIBRARY:PATH=$python_basedir/lib \
    -D PYTHON_INCLUDE_DIR:PATH=$python_basedir/include/python2.7 \
    -D USE_CUDA:BOOL=ON \
    ..

make -j16
make install
