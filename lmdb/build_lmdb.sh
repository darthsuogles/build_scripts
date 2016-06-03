#!/bin/bash

source ../build_pkg.sh

function c_fn() { 
    ./configure --prefix=${install_dir} \
                --enable-bdb=no \
                --enable-hdb=no
}
function b_fn() { make -j32; make test; }
guess_build_pkg lmdb ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.40.tgz \
                -c "c_fn" -b "b_fn"
