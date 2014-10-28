#!/bin/bash

ver=1.8.13
szlib_ver=2.1
szlib_dir=$HOME/local/src/szlib/$szlib_ver

source ../build_pkg.sh

# Prerequisites
#module load mpi 
function use_latest_version()
{
    latest_ver=$(curl -s www.hdfgroup.org/HDF5/release/obtainsrc.html | \
	perl -ne 'if ($_ =~ /hdf5-((\d+\.?)+?)\.tar\.bz2/) { print "$1\n" }')
    if [ "$latest_ver" > "$ver" ]; then
	echo "Using latest version $latest_ver"
	ver=$latest_ver
    fi
}

use_latest_version
prepare_pkg hdf5 http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-$ver/src/hdf5-$ver.tar.bz2 $ver install_dir
echo $install_dir

cd $ver
./configure --prefix=$install_dir \
    --enable-production --enable-debug=no \
    --disable-dependency-tracking \
    --enable-fortran \
    --enable-cxx \
    --with-szlib=$szlib_dir \
    --enable-filters=all \
    --enable-static=yes \
    --enable-shared=yes \
    --enable-parallel
make -j8
make check
make install
make check-install

