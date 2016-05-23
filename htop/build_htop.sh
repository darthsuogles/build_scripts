#!/bin/bash

BUILD_HTOP=no

source ../build_pkg.sh 
source ../gen_modules.sh 

function build_htop() {
    local ver=$(curl -sL http://hisham.hm/htop/releases/ | \
                 perl -ne 'print "$1\n" if /(\d+(\.\d+)*)\//' | \
                 sort -V | tail -n1)
    [ -n "${ver}" ] || quit_with "cannot find version"
    get_pkg_install_dir htop ${ver}
    htop_ver=${ver}
    [ "yes" == "${BUILD_HTOP}" ] || return 0

    local url="http://hisham.hm/htop/releases/${ver}/htop-${ver}.tar.gz"
    prepare_pkg htop ${url} ${ver} install_dir
    cd ${ver}
    ./configure --prefix=${install_dir} \
                --disable-unicode
    make -j32
    make install
}
build_htop

guess_print_modfile htop ${htop_ver}
