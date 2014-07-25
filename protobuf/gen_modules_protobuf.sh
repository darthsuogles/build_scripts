#!/bin/bash

#ver=${1=2.5.0}
ver=2.5.0
install_dir=$PWD/$ver

echo "#%Module 1.0"
echo "#"
echo "# Google Protocol Buffer $ver"
echo "#"
echo 
echo "prepend-path PATH $install_dir/bin"
echo "prepend-path LIBRARY_PATH $install_dir/lib"
echo "prepend-path LD_LIBRARY_PATH $install_dir/lib"
echo "prepend-path CPATH $install_dir/include"
