#!/bin/bash

ver=2.4.2

build_dir=/tmp/phi/libtool/$ver
install_dir=$PWD/$ver

function quit_with()
{
    echo "Error: $@, quit"
    exit
}

if [ ! -d $install_dir ]; then
    fname=libtool-$ver
    tarball=$fname.tar.xz
    if [ ! -f $tarball ]; then
	wget http://ftp.wayne.edu/gnu/libtool/$tarball
    fi
    fname=`tar -Jxvf $tarball | sed -e 's@/.*@@' | uniq`
    [ ! -z $fname ] || quit_with "failed to decompress the file"
    if [ $fname != $install_dir ]; then mv $fname $install_dir; fi
    rm $tarball
fi

