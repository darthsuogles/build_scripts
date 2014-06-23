#!/bin/bash

ver=17.0

export dtrace='~/dtrace'
tmp_dir=/scratch1/phi/erlang
base_dir=$PWD
script_name=`dirname $0`

function quit_with()
{
    printf "Error [ $script_name ]: \n"
    printf "      $@\n"
    exit
}

function update_pkg()
{
    if [ ! -d $ver ]; then
	fname=otp_src_$ver
	tarball=$fname.tar.gz
	if [ ! -e $tarball ]; then
	    wget http://www.erlang.org/download/$tarball
	fi
	tar -zxf $tarball 
	mv $fname $ver
	rm $tarball
    fi
}

mkdir -p $tmp_dir; cd $tmp_dir
update_pkg
ln -s $tmp_dir/$ver $base_dir/${ver}.build-tree

cd $ver

./configure \
    --prefix=$base_dir/$ver \
    --build=x86_64-redhat-linux-gnu
#    --with-dynamic-trace=systemtap
make
make install
cd ..
