#!/bin/bash

ver=2.8.12.2

tmp_dir=/scratch1/phi/cmake
base_dir=$PWD

if [ ! -d $ver ]; then
    fname=cmake-$ver
    tarball=$fname.tar.gz

    mkdir -p $tmp_dir; cd $tmp_dir
    if [ ! -e $tarball ]; then
	wget http://www.cmake.org/files/v2.8/cmake-2.8.12.2.tar.gz
    fi
    fname=`tar -zxvf $tarball | sed -e 's@/.*@@' | uniq`
    mv $fname $ver
    rm $tarball
    ln -s $tmp_dir/$ver $base_dir/$ver    
    cd $base_dir
fi

cd $ver
./configure --prefix=$HOME/local
make -j8
make install
cd ..
