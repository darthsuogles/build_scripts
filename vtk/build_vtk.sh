#!/bin/bash

ver_major=5.8
ver_minor=0
ver=$ver_major.$ver_minor

if [ ! -d $ver ]; then
    fname=VTK$ver
    tarball=vtk-$ver.tar.gz
    if [ ! -e $tarball ]; then
	wget http://www.vtk.org/files/release/$ver_major/$tarball
    fi
    tar -zxvf $tarball
    mv $fname $ver
    rm $tarball
fi

cd $ver
mkdir build-tree
cd build-tree
#cmake ..
make
cd ../..
