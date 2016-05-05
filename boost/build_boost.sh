#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_BOOST=no

set -ex

function build_boost() {
    local url_prefix="http://www.boost.org/users/history/"
    local ver=$(curl -sL ${url_prefix} | \
                       perl -ne 'print "$1\n" if /version_(\d+(_\d+)*)\.html/' | \
                       tr '_' '.' | sort -V | tail -n1)
    [ -z "${ver}" ] && quit_with "failed to find version"
    boost_ver=${ver}
    get_pkg_install_dir boost ${ver}
    [ "yes" == "${BUILD_BOOST}" ] || return 0

    local file_ver="$(echo ${ver} | tr '.' '_')"
    local url=$(curl -sL "${url_prefix}/version_${file_ver}.html" | \
                       perl -ne "print \"\$1\n\" if /(https?:\/(\/[^\/]+)+?\/${ver}\/boost_${file_ver}\.tar\.(gz|bz2))/" | \
                       head -n1)
    prepare_pkg boost ${url} ${ver} install_dir

    cd ${ver}
    echo -e "Bootstrapping ... patience"
    ./bootstrap.sh --prefix=${install_dir}
    echo -e "Building ... patience"
    ./b2 install
}
build_boost

print_header boost ${boost_ver}
print_modline "setenv BOOST_VER ${boost_ver}"
print_modline "setenv BOOST_ROOT ${boost_dir}"
print_modline "setenv BOOST_LIBDIR ${boost_dir}/lib"
