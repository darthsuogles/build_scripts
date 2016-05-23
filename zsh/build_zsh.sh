#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_ZSH=no

set -ex

function build_zsh() {

    local ver=$(curl -sL http://sourceforge.net/projects/zsh/files/zsh | \
                       perl -ne 'print "$1\n" if /\/projects\/zsh\/files\/zsh\/(\d+(\.\d+)*)\//' | \
                       sort -V | tail -n1)
    [ -n "${ver}" ] || quit_with "cannot find a valid version"
    zsh_ver=${ver}
    get_pkg_install_dir zsh ${ver}
    [ "yes" == "${BUILD_ZSH}" ] || return 0
    local tarball=zsh-${ver}.tar.xz
    local url=http://sourceforge.net/projects/zsh/files/zsh/${ver}/${tarball}
    prepare_pkg zsh ${url} ${ver} install_dir

    cd ${ver}
    ./configure --prefix=${install_dir}
    make -j8 && make install
}
build_zsh

print_header zsh "${zsh_ver}"
print_modline "prepend-path PATH ${zsh_dir}/bin"
