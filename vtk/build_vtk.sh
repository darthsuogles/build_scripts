#!/bin/bash

ver_major=5.8
ver_minor=0
ver=$ver_major.$ver_minor

# Installation directories
base_dir=$PWD
build_dir=/tmp/vtk
install_dir=$PWD/$ver

# Prerequisites
module load qt/4.8.5

# Go to the temporary build directory
mkdir -p $build_dir; cd $build_dir

function assert_dir_exist()
{
    dir_name=$1; shift; 
    err_msg=$@
    if [ ! -d $dir_name ]; then
       	echo "Error: directory $dir does not exist, quit"
	if [ ! -z $err_msg ]; then echo ">> $err_msg"; fi	    
	exit
    fi
}

if [ ! -d $ver ]; then
    fname=VTK$ver
    tarball=vtk-$ver.tar.gz
    if [ ! -e $tarball ]; then
	wget http://www.vtk.org/files/release/$ver_major/$tarball
    fi
    echo "Uncompressing ... might take a while ... be patient"
    fname=`tar -zxvf $tarball | sed -e 's@/.*@@' | uniq`
    if [ "$fname" != "$ver" ]; then mv $fname $ver; fi
    assert_dir_exist $ver
    rm $tarball
fi

cd $ver
mkdir -p build-tree; mkdir -p $install_dir
cd build-tree
cmake -DCMAKE_BUILD_TYPE=None -DCMAKE_INSTALL_PREFIX=$install_dir ..
make -j8
make install

# Now build the module file
cd $base_dir

function gen_modules()
{
    echo "#%Module 1.0"
    echo "#"
    echo "# VTK $ver"
    echo "#"

    echo "setenv VTK_HOME $install_dir"
    echo "setenv VTK_VER $ver"
    if [ -d $install_dir/bin ]; then
	echo "prepend-path PATH $install_dir/bin"
    fi

    echo "prepend-path CPATH $install_dir/include/vtk-$ver_major"
    echo "prepend-path LIBRARY_PATH $install_dir/lib/vtk-$ver_major"
}
