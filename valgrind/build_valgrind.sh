#!/bin/bash

BUILD_VALGRIND=yes

source ../build_pkg.sh
source ../gen_modules.sh    

function build_valgrind() {
    local ver=$(curl -sL http://valgrind.org/downloads/current.html | \
                       perl -ne 'print "$1\n" if /valgrind-((\d+\.?)+?)\.tar\.bz2/' | \
                       head -n1)
    [ -n "${ver}" ] || local ver=3.12.2
    
    valgrind_ver=${ver}
    local url="http://valgrind.org/downloads/valgrind-${ver}.tar.bz2"    
    prepare_pkg valgrind ${url} ${ver} install_dir

    [ "yes" == "${BUILD_VALGRIND}" ] || return
    cd $ver
    ./configure --prefix=${install_dir} \
                --enable-only64bit \
                --enable-ubsan \
                --enable-tls
    make -j8
    make check
    make install
}
build_valgrind

guess_print_modfile valgrind ${valgrind_ver}
