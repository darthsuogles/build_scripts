#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_NCURSES=yes

set -ex

function build_ncurses() {
    local ver=$(curl -sL http://ftp.gnu.org/gnu/ncurses/ | \
                       perl -ne 'print "$1\n" if /ncurses-(\d+(\.\d+)*)\.tar\.gz/' | \
                       sort -V | tail -n1)    
    [ -n "${ver}" ] || quit_with "cannot find version"
    get_pkg_install_dir ncurses ${ver}
    ncurses_ver=${ver}
    [ "yes" == "${BUILD_NCURSES}" ] || return 0
    local url="http://ftp.gnu.org/pub/gnu/ncurses/ncurses-${ver}.tar.gz"
    prepare_pkg ncurses ${url} ${ver} install_dir
    echo $install_dir

    cd $ver
    ./configure --prefix=$install_dir \
                --with-shared
    make -j8 
    make install
}
build_ncurses

guess_print_modfile ncurses ${ncurses_ver}
