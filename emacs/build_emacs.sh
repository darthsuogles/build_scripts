#!/bin/bash

url_prefix=http://ftp.gnu.org/gnu/emacs
tarball=$(curl -sL $url_prefix/ | perl -ne 'print "$1\n" if /(emacs-(\d+\.?)+?\.tar\.(gz|bz2))/' | sort -n | tail -n1)

url=$url_prefix/$tarball
ver=$(echo $tarball | perl -ne 'print $1 if /emacs-((\d+\.?)+?)\.tar/')
[ ! -z $ver ] || ver=24.4

source ../build_pkg.sh

prepare_pkg emacs $url $ver install_dir
echo $install_dir

export CC=gcc
export CXX=g++
export CFLAGS='-g -O3 -gdwarf-2'

cd $ver
./configure --prefix=$install_dir \
    --without-jpeg \
    --without-png \
    --without-tiff \
    --without-gif \
    --without-xpm \
    --with-x-toolkit=no \
    --without-x
make -j8
make install
cd ..
