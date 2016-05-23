#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_STAN=yes

function configure_fn() { log_info "no configure needed"; }
function build_fn() { make build -j32; }
function install_fn() { log_info "moving the whole directory"; cp -r * ${install_dir}/. ; }
guess_build_pkg stan https://github.com/stan-dev/cmdstan/releases/download/v2.9.0/cmdstan-2.9.0.tar.gz \
                -c "configure_fn" -b "build_fn" -i "install_fn"
guess_print_modfile stan ${stan_ver}
