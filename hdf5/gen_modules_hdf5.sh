#!/bin/bash

pkg=HDF5
ver=1.8.13
install_dir=$PWD/$ver

function gen_modules()
{
    echo "#%Module 1.0"
    echo "#"
    echo "# $pkg $ver"
    echo "#"
    echo 

    printf "setenv ${pkg}_HOME\t $install_dir\n"
    printf "setenv ${pkg}_VER\t $ver\n"
    if [ -d $install_dir/bin ]; then
	printf "prepend-path PATH\t $install_dir/bin\n"
    fi    

    # include_dir=`find $install_dir -name '*.h' | sed -e '1{h;d;}' -e 'G;s,\(.*\).*\n\1.*,\1,;h;$!d'`
    # if [ ! -z "$include_dir" ]; then
    # 	printf "prepend-path CPATH\t $include_dir\n"
    # fi
    printf "prepend-path CPATH\t $install_dir/include\n"
    printf "prepend-path LIBRARY_PATH\t $install_dir/lib\n"
    printf "prepend-path LD_LIBRARY_PATH\t $install_dir/lib\n"

    if [ -d $install_dir/share/hdf5_examples ]; then
	printf "setenv ${pkg}_EXAMPLES\t $install_dir/share/hdf5_examples\n"
    fi
}

gen_modules 
