#!/bin/bash

source ../build_pkg.sh

url_prefix=ftp://xmlsoft.org/libxml2
tarball=$(curl -sL $url_prefix/ | perl -ne 'print "$1\n" if /(libxml2-sources-(\d+\.?)+?\.tar\.gz)/' | sort -n | tail -n1)
[ ! -z $tarball ] || quit_with "package tarball $tarball must be found"
ver=$(echo $tarball | perl -ne 'print $1 if /((\d+\.?)+?)\.tar\.gz/')

prepare_pkg libxml2 $url_prefix/$tarball $ver install_dir
echo $install_dir

cd $ver
./configure --prefix=$HOME/local \
    CC="`which gcc` -march=native" \
    LIBS="-L$PYTHONHOME/lib -lpython2.7"
make 
make check
make install
