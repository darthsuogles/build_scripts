#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_AUTOMAKE=yes

function build_automake() {
    local ver=$(curl -sL http://ftp.gnu.org/gnu/automake | \
                       perl -ne 'print "$1\n" if /automake-(\d+(\.\d+)*)/' | \
                       sort -V | tail -n1)
    automake_ver=${ver}
    [ "yes" == "${BUILD_AUTOMAKE}" ] || return 0    
    local fname=automake-$ver
    local tarball=$fname.tar.gz
    local url=http://ftp.gnu.org/gnu/automake/$tarball
    prepare_pkg automake ${url} ${ver} install_dir
        
    cd $ver
    ./configure --prefix=${install_dir}
    make -j8
    make install
}
build_automake

guess_print_modfile automake ${automake_ver}
