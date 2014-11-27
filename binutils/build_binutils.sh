#!/bin/bash

#curl -sL http://ftp.gnu.org/gnu/binutils/ | perl -ne 'print "$4\t$1\n" if /(binutils-(\d+\.?)+?\.tar\.(gz|bz2)).*\s+((\d{2})-(\w{3})-(\d{4}))/'
#ver=$(curl -sL http://ftp.gnu.org/gnu/binutils/ | perl -ne 'print "$1\n" if /binutils-((\d+\.?)+?)\.tar\.(gz|bz2)/' | sort -t '.' | tail -n1)

url_prefix=http://ftp.gnu.org/gnu/binutils
tarball=$(curl -sL $url_prefix/ | \
    perl -ne 'print "$7-$6-$5\t$1\n" if /(binutils-(\d+\.?)+?\.tar\.(gz|bz2)).*\s+((\d{2})-(\w{3})-(\d{4}))/' | \
    sort | tail -n1 | awk '{print $2}')
ver=$(echo $tarball | perl -ne 'print $1 if /binutils-((\d+\.?)+)\.tar/')

source ../build_pkg.sh
prepare_pkg binutils $url_prefix/$tarball $ver install_dir
echo $install_dir

cd $ver
./configure --prefix=$HOME/local
make 
make install
