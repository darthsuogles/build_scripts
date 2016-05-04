#!/bin/bash

BUILD_TEXINFO=no

source ../build_pkg.sh 
source ../gen_modules.sh 

set -ex

function build_texinfo() {
    local ver=$(_wisper_fetch curl -sL http://ftp.gnu.org/gnu/texinfo/ | \
                       perl -ne 'print "$1\n" if /texinfo-(\d+(\.\d+)*)\.tar\.xz/' | \
                       tail -n1)
    [ -n "${ver}" ] || return 1

    local url="http://ftp.gnu.org/gnu/texinfo/texinfo-${ver}.tar.xz"
    prepare_pkg texinfo ${url} ${ver} install_dir
    texinfo_ver=${ver}
    texinfo_dir=${install_dir}

    [ "yes" != "${BUILD_TEXINFO}" ] && return 0
    cd ${ver}
    ./configure --prefix=${install_dir}
    make -j32
    make install
}
build_texinfo

print_header texinfo "${texinfo_ver}"
print_modline "prepend-path PATH ${texinfo_dir}/bin"
print_modline "prepend-path MANPATH ${texinfo_dir}/share/man"
print_modline "prepend-path INFO_PATH ${texinfo_dir}/share/info"
