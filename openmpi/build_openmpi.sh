#!/bin/bash

ver_major=1.8
ver_minor=3 # prev: 1
ver=$ver_major.$ver_minor

base_dir=$PWD
build_dir=/tmp/phi/openmpi
install_dir=$PWD

function quit_with()
{
    echo "Error [ $0 ]: version $ver" | tee build_$ver.failed
    printf ">> $@\n" | tee build_$ver.failed
    date | tee build_$ver.failed
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
mkdir -p $install_dir/$ver
ln -s $build_dir/$ver $install_dir/$ver/src

cd $ver
# ./configure --prefix=$install_dir/$ver \
#     --disable-vt    
CFLAGS="-fgnu89-inline" ./configure --prefix=$install_dir/$ver \
    --disable-vt
make -j8 all
make install

cd $base_dir

date | tee build_$ver.done
