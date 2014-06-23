#!/bin/bash

ver=1.8.13

base_dir=$PWD
build_dir=/tmp/hdf5
install_dir=$PWD/$ver

# Prerequisites
#module load mpi 

function update_package()
{
    if [ ! -d $ver ]; then
	fname=hdf5-$ver
	tarball=$fname.tar.bz2
	if [ ! -f $tarball ]; then
	    wget http://www.hdfgroup.org/ftp/HDF5/releases/$fname/src/$tarball
	fi	
	fname=`tar -jxvf $tarball | sed -e 's@/.*@@' | uniq`
	if [ $fname != $ver ]; then mv $fname $ver; fi
	rm $tarball
    fi       
}

mkdir -p $build_dir; cd $build_dir
update_package; cd $ver

./configure --prefix=${install_dir} \
    --enable-production --enable-debug=no \
    --disable-dependency-tracking \
    --enable-filters=all \
    --enable-static=yes \
    --enable-shared=yes
    #--enable-parallel
make -j8; 
make check
make install; 
make check-install
cd $base_dir

