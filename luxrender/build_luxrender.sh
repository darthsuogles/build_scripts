#!/bin/bash

BUILD_LUXRENDER=yes

set -ex

source ../build_pkg.sh 
source ../gen_modules.sh 

function build_luxrender() {
    local ver=$(_wisper_fetch curl -sL http://www.luxrender.net/release/luxrender | \
                       perl -ne 'print "$1\n" if /(\d+(\.\d+)*)\//' | tail -n1)
    [ -n "${ver}" ] || local ver=1.9
    
    local tarball=$(_wisper_fetch curl -sL http://www.luxrender.net/release/luxrender/$ver/linux | \
                           perl -ne 'print "$1\n" if /(lux-v\d+(\.\d+)*.*-x86_64-sse2\.tar\.bz2)/' | tail -n1)
    [ -n "${tarball}" ] || quit_with "failed to sense a valid tarball"
    url=http://www.luxrender.net/release/luxrender/$ver/linux/${tarball}
    _wisper_fetch curl -sIL ${url} || quit_with "cannot download ${tarball}"

    prepare_pkg luxrender $url $ver install_dir

    [ "yes" == "${BUILD_LUXRENDER}" ] || return 0
    log_info "The package is a pre-built version, copy all the file"
    rm -fr ${install_dir}
    cp -r ${ver} ${install_dir}
}
build_luxrender
