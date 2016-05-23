#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_LIBUUID=yes
guess_build_pkg libuuid "http://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz"

guess_print_modfile libuuid ${libuuid_ver}
