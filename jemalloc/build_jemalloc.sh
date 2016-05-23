#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_JEMALLOC=yes
guess_build_pkg jemalloc https://github.com/jemalloc/jemalloc/releases/download/4.1.1/jemalloc-4.1.1.tar.bz2
guess_print_modfile jemalloc ${jemalloc_ver}
