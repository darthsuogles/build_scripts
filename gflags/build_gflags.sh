#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_GFLAGS=yes
guess_build_pkg gflags https://github.com/schuhschuh/gflags/archive/gflags-2.1.2.tar.gz
guess_print_modfile gflags ${gflags_ver}
