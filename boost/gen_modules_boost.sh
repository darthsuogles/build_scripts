#!/bin/bash

ver=$1
install_dir=$2

src_dir=$(readlink -f ${BASH_SOURCE[0]} | xargs dirname)
${ver:=1.56.0}
${install_dir:=$src_dir/$ver}

echo "#%Module 1.0"
echo "#"
echo "# Boost C++ library $ver"
echo "#"
echo 
echo "conflict boost"
echo "setenv BOOST_VER         $ver"
echo "setenv BOOST_MAKEFILE_I  -I$install_dir/include"
echo "setenv BOOST_MAKEFILE_L  -L$install_dir/lib"
echo "setenv BOOST_LIBDIR      $install_dir/lib"
echo "prepend-path LIBRARY_PATH     $install_dir/lib"
echo "prepend-path LD_LIBRARY_PATH  $install_dir/lib"
echo "prepend-path CPATH            $install_dir/include"
