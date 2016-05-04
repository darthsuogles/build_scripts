#!/bin/bash

BUILD_SWIG=no

source ../build_pkg.sh
source ../gen_modules.sh 

function build_swig() {
    local pkg_url=$(curl -sL http://www.swig.org/download.html | \
                     perl -ne 'print $1 if /(http:\/\/.*?\/swig-(\d+\.?)+?\.tar\.gz)/' | 
                     uniq)
    local ver=$(basename $pkg_url | perl -ne 'print $1 if /swig-((\d+\.?)+?)\.tar\.gz/')    
    prepare_pkg swig $pkg_url $ver install_dir 
    swig_ver=${ver}
    swig_dir=${install_dir}   

    [ "yes" == "${BUILD_SWIG}" ] || return 0
    cd $ver
    ./configure --prefix=$install_dir
    make -j32
    make install
}
build_swig

print_header swig "${swig_ver}"
print_modline "prepend-path PATH ${swig_dir}/bin"
