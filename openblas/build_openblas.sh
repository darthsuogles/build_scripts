#!/bin/bash

ver=0.2.9

source ../build_pkg.sh

# Set the latest version 
function set_latest_version()
{
    local url=http://www.openblas.net/Changelog.txt
    ver_list=($(curl -s $url | grep -Ei "^Version" | awk '{print $2}'))
    if [ "${ver_list[0]}" > "$ver" ]; then
	echo "A new version ${ver_list[0]} is available"
	ver=${ver_list[0]}
    fi
}

set_latest_version
tarball=$ver.tar.gz 
curl -L -o $tarball http://github.com/xianyi/OpenBLAS/tarball/v$ver
prepare_pkg openblas $PWD/$tarball $ver install_dir

cd $ver
make FC=gfortran libs netlib shared
make FC=gfortran tests
make PREFIX=$install_dir install
echo "Creating a symlink for libblas.so"
ln -s $install_dir/lib/libopenblas.so $install_dir/lib/libblas.so
cd ..

cd $install_dir
