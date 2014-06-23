#!/bin/bash

ver=5.8.0
install_dir=$PWD/$ver

function gen_modules()
{
    echo "#%Module 1.0"
    echo "#"
    echo "# VTK $ver"
    echo "#"
    echo 

    printf "setenv VTK_HOME\t $install_dir\n"
    printf "setenv VTK_VER\t $ver\n"
    if [ -d $install_dir/bin ]; then
	printf "prepend-path PATH\t $install_dir/bin\n"
    fi

    include_dir=`find $install_dir -name '*.h' | sed -e '1{h;d;}' -e 'G;s,\(.*\).*\n\1.*,\1,;h;$!d'`
    if [ ! -z "$include_dir" ]; then
	printf "prepend-path CPATH\t $include_dir\n"
    fi
    
    static_lib_dir=(`find $install_dir -name '*.a' | sed -e '1{h;d;}' -e 'G;s,\(.*\).*\n\1.*,\1,;h;$!d'`)
    if [ ! -z "$static_lib_dir" ]; then
	printf "prepend-path LIBRARY_PATH\t $static_lib_dir\n"
    fi
    
    dynamic_lib_dir=(`find $install_dir -name '*.so' | sed -e '1{h;d;}' -e 'G;s,\(.*\).*\n\1.*,\1,;h;$!d'`)
    if [ ! -z "$dynamic_lib_dir" ]; then
	printf "prepend-path LIBRARY_PATH\t $dynamic_lib_dir\n"
	printf "prepend-path LD_LIBRARY_PATH\t $dynamic_lib_dir\n"
    fi
}

gen_modules 
