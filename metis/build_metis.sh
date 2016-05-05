#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_METIS=yes
function configure_fn() { make config prefix=$1 shared=1; }
function build_fn() { LDFLAGS='-Wl,-rpath=${install_dir}/lib' make -j32; }

guess_build_pkg \
    metis http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz \
    -c "configure_fn" -b "build_fn"

guess_print_modfile metis ${metis_ver}
    
