#!/bin/bash

#ver_major=5.8
#ver_minor=0
ver_major=5.10
ver_minor=1
ver=$ver_major.$ver_minor

python_ver=${PYTHON_VER%.*} # we only need the major version

# Installation directories
base_dir=$PWD
build_basedir=/tmp/vtk
install_dir=$PWD/$ver

# Prerequisites
module load qt/4.8.5
module load python

# Go to the temporary build directory
mkdir -p $build_basedir; cd $build_basedir

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

build_dir=$build_basedir/$ver
cd $ver
#mkdir -p build-tree;
mkdir -p $install_dir
#cd build-tree
#cmake -LAH ..; exit

vtk_pythonpath=$install_dir/lib/python${python_ver}/site-packages
mkdir -p $vtk_pythonpath
export PYTHONPATH=$build_dir/Wrapping/Python:$vtk_pythonpath:$PYTHONPATH

cmake -DCMAKE_INSTALL_PREFIX=$install_dir \
    -DCMAKE_INCLUDE_PATH:PATH=$HOME/local/include \
    -DCMAKE_LIBRARY_PATH:PATH=$HOME/local/lib \
    -DCMAKE_BUILD_TYPE:STRING=None \
    -DCMAKE_C_COMPILER:STRING=gcc \
    -DCMAKE_CXX_COMPILER:STRING=g++ \
    -DPYTHON_INCLUDE_DIR:PATH=${PYTHONHOME}/include/python${python_ver} \
    -DPYTHON_LIBRARY:FILEPATH=${PYTHONHOME}/lib/libpython${python_ver}.so \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DVTK_USE_TK:BOOL=OFF \
    -DVTK_USE_QT:BOOL=ON \
    -DVTK_USE_GUISUPPORT:BOOL=ON \
    -DVTK_LEGACY_REMOVE:BOOL=ON \
    -DModule_vtkRenderingMatplotlib:BOOL=ON \
    -DVTK_INSTALL_PYTHON_MODULE_DIR:PATH=${PYTHONHOME}/lib/python${python_ver}/site-packages \
    -DVTK_WRAP_PYTHON:BOOL=ON \
    $PWD
make -j8
make install

#-DVTK_USE_GNU_R:BOOL=ON \
#-DVTK_INSTALL_THIRD_PARTY_LIBRARIES:BOOL=ON \

# Now build the module file
cd $base_dir
