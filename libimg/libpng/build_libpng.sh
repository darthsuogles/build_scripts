#!/bin/bash

ver_major=1.2
ver_minor=51
ver=$ver_major.$ver_minor

tmp_dir=/scratch1/phi/libpng
base_dir=$PWD
script_name=`basename $0`

function quit_with()
{
    printf "Error [ $script_name ]:\n"
    printf "      $@\n"
    exit
}

function update_pkg()
{
    if [ ! -d $ver ]; then
	fname=libpng-$ver
	tarball=$fname.tar.gz
	if [ ! -e $tarball ]; then
	    wget http://prdownloads.sourceforge.net/libpng/$tarball
	fi
	tar -zxvf $tarball
	mv $fname $ver
	rm $tarball
    fi
}

mkdir -p $tmp_dir; cd $tmp_dir
update_pkg || quit_with "failed to update the package with version $ver"
ln -s $tmp_dir/$ver $base_dir/$ver

cd $ver
make clean; make distclean
./configure --prefix=$HOME/local
make -j8
make install
cd ..
