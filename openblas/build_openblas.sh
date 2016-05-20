#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_OPENBLAS=no

set -ex
function configure_fn() { log_info "no need to configure"; }
function build_fn() {    
    make FC=gfortran libs netlib shared
    make FC=gfortran tests
}
function install_fn() {
    make PREFIX=$install_dir install
    echo "Creating a symlink for libblas.so"
    ln -s $install_dir/lib/libopenblas.so $install_dir/lib/libblas.so
}

guess_build_pkg openblas http://github.com/xianyi/OpenBLAS/archive/v0.2.18.tar.gz \
                -c "configure_fn" -b "build_fn" -i "install_fn"
guess_print_modfile openblas ${openblas_ver}
