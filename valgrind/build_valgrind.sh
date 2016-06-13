#!/bin/bash

source ../build_pkg.sh

function c_fn() {
    ./configure --prefix=${install_dir} \
                --enable-only64bit \
                --enable-ubsan \
                --enable-tls
}

function b_fn() {
    make -j32
    make check
}

USE_LATEST_VERSION=no
guess_build_pkg valgrind http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2 \
                -c "c_fn" -b "b_fn"

