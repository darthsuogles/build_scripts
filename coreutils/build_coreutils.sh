#!/bin/bash

url_prefix=http://ftp.gnu.org/gnu/coreutils
tarball=$(curl -sL $url_prefix/ | \
    perl -ne 'print "$7 $6 $5\t$1\n" if /(coreutils-(\d+\.?)+?\.tar\.(gz|bz2|xz)).*\s+((\d{2})-(\w{3})-(\d{4}))/' | \
    sort -gM | tail -n1 | awk '{print $NF}')
ver=$(echo $tarball | perl -ne 'print $1 if /-((\d+\.?)+?)\.tar/')

wget http://ftp.gnu.org/gnu/coreutils/$tarball 
xz -d $tarball
gzip ${tarball%.*}
tarball=${tarball%.*}.gz

source ../build_pkg.sh
prepare_pkg coreutils $PWD/$tarball $ver install_dir
echo $install_dir

cd $ver
make clean
CC=`which gcc` CXX=`which g++` ./configure --prefix=$HOME/local
make -j8
make check
make install
make installcheck
