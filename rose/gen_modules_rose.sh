#!/bin/bash

rose_ver=current
boost_ver=1.47.0
java_libdir=/usr/lib/jvm/java-1.7.0-oracle.x86_64/jre/lib/amd64/server

rose_root=$PWD
rose_ver_num=`readlink $rose_root/$rose_ver | xargs basename`
boost_install_dir=$rose_root/boost/$boost_ver
rose_install_dir=$rose_root/$rose_ver

function quit_with() 
{ 
    echo "Error: >> $@"
    exit 
}

[ -d $rose_root ] || quit_with "rose root directory not found"
[ -d $boost_install_dir ] || quit_with "boost install directory not found"
[ -d $rose_install_dir ] || quit_with "rose install directory not found"

echo "#%Modules 1.0"
echo "# "
echo "# ROSE source-to-source translator"
echo "# "
echo 
echo "setenv       ROSE_VER        $rose_ver_num"
echo "setenv       ROSE_ROOT       $rose_root"
echo "prepend-path LD_LIBRARY_PATH $rose_install_dir/lib:$boost_install_dir/lib:$java_libdir"
echo "prepend-path LIBRARY_PATH    $rose_install_dir/lib"
echo "prepend-path CPATH           $rose_install_dir/include:$boost_install_dir/include"
echo "prepend-path PATH            $rose_install_dir/bin"
echo "prepend-path MANPATH         $rose_install_dir/man"
