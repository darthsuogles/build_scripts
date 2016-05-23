#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_PROTOBUF=yes

function configure_fn() {
    ./autogen.sh
    ./configure --prefix=${install_dir}
}
guess_build_pkg protobuf https://github.com/google/protobuf/archive/v3.0.0-beta-2.tar.gz -c "configure_fn"
# https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz

guess_print_modfile protobuf ${protobuf_ver}
