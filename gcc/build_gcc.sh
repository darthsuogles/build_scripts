#!/bin/bash

ver=${1:-4.9.1}

valid_keys=(
    "745C015A"
    "B75C61B8"
    "902C9419"
    "F71EDF1C"
    "FC26A641"
    "C3C45C06"
)

function use_latest_version()
{
    local latest_ver=$(curl -sL http://gcc.gnu.org/releases.html | perl -ne 'print "$1\n" if /gcc\s+((\d+\.?)+)/i' | sort -n | tail -n1)
    if [[ "$ver" < "$latest_ver" ]]; then
	printf "Choosing the latest version: $ver\n"
	ver=$latest_ver
    fi
}

source ../build_pkg.sh
use_latest_version 
prepare_pkg gcc ftp://gcc.gnu.org/pub/gcc/releases/gcc-$ver/gcc-$ver.tar.bz2 $ver install_dir
echo "Packages will be installed at: $install_dir"

echo "Download prerequisite packages into the source tree"
cd $ver; ./contrib/download_prerequisites; cd ..

src_dir=$PWD/$ver
mkdir -p build-tree-$ver; cd build-tree-$ver

$src_dir/configure --prefix=$install_dir \
    --build=x86_64-redhat-linux \
    --host=x86_64-redhat-linux \
    --target=x86_64-redhat-linux \
    --enable-languages=c,c++,fortran \
    --enable-threads=posix \
    --enable-tls \
    --enable-__cxa_atexit \
    --enable-shared

#make profiledbootstrap
make -j 16
make install
