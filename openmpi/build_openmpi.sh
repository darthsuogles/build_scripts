#!/bin/bash

ver_major=1.6
ver_minor=5
ver=$ver_major.$ver_minor

base_dir=$PWD
build_dir=/scratch1/phi/openmpi

function quit_with()
{
    echo "Error [ $0 ]: version $ver"
    printf ">> $@\n"
    exit
}

function update_pkg()
{
    if [ -d $ver ]; then return; fi

    fname=openmpi-$ver
    tarball=$fname.tar.bz2
    if [ ! -f $tarball ]; then
	wget http://www.open-mpi.org/software/ompi/v$ver_major/downloads/$tarball
    fi
    fname=`tar -jxvf $tarball | sed -e 's@/.*@@' | uniq`
    if [ $fname != $ver ]; then mv $fname $ver; fi
    if [ ! -d $ver ]; then
	quit_with "failed to decompress the tarball $tarball"
    fi
    rm $tarball
}


mkdir -p $build_dir; cd $build_dir
update_pkg || quit_with "failed to update the package to version $ver"

cd $ver
./configure --prefix=$base_dir/$ver \
    --disable-vt    
make -j8 all
make install

cd $base_dir

