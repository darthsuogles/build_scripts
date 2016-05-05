#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_PROTOBUF=yes
guess_build_pkg protobuf https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz

guess_print_modfile protobuf ${protobuf_ver}
