#!/bin/bash

source ../build_pkg.sh
#source ../gen_modules.sh 

function c_fn() {
    export SLEPC_DIR=${install_dir}
    ./configure --prefix=${install_dir}
}
function i_fn() {
    make install
    make test
}

url=http://slepc.upv.es/download/distrib/slepc-3.7.1.tar.gz
guess_build_pkg slepc "${url}" -c "c_fn" -i "i_fn" -d "petsc openblas"

