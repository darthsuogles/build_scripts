#!/bin/bash

source ../build_pkg.sh

set -ex

function c_fn() {
    echo -e "Bootstrapping ... patience"
    ./bootstrap.sh --prefix=${install_dir}
}

function b_fn() {
    echo -e "Building ... patience"
    ./b2 install
}

url=http://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2 
guess_build_pkg boost "${url}" -c "c_fn" -b "b_fn"
