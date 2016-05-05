#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_LIBTOOL=yes

function build_libtool() {
    local ver=$(curl -sL http://mirror.team-cymru.org/gnu/libtool | \
                 perl -ne 'print "$1\n" if /libtool-(\d+(\.\d+)*).tar.gz/' | \
                 sort -V | tail -n1)
    libtool_ver=${ver}
    [ "yes" == "${BUILD_LIBTOOL}" ] || return 0
    local url=http://mirror.team-cymru.org/gnu/libtool/libtool-$ver.tar.gz
    prepare_pkg libtool ${url} ${ver} install_dir

    cd $ver
    ./configure --prefix=$install_dir
    make -j8
    make install
}
build_libtool

guess_print_modfile libtool ${libtool_ver}
