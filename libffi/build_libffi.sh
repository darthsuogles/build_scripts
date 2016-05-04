#!/bin/bash

set -ex

source ../build_pkg.sh
source ../gen_modules.sh

BUILD_LIBFFI=no

function build_libffi() {
    local ver=$(curl -sL https://sourceware.org/libffi | \
                       perl -ne 'print "$1\n" if /libffi-(\d+(\.\d+)*)\.tar\.gz/' | \
                       head -n1)
    [ -n "${ver}" ] || local ver=3.9.1    
    local url=ftp://sourceware.org/pub/libffi/libffi-${ver}.tar.gz
    prepare_pkg libffi ${url} ${ver} install_dir
    libffi_ver=${ver}
    libffi_dir=${install_dir}
    [ "yes" != "${BUILD_LIBFFI}" ] && return 0

    cd ${ver}
    ./configure --prefix=${install_dir}
    make -j32
    make install
}
build_libffi

print_header libffi "${libffi_ver}"
print_modline "prepend-path PKG_CONFIG_PATH ${libffi_dir}/lib/pkgconfig"
print_modline "prepend-path MANPATH ${libffi_dir}/share/man"
print_modline "prepend-path INFO_PATH ${libffi_dir}/share/info"
