#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_LIBGSASL=yes
guess_build_pkg libgsasl ftp://ftp.gnu.org/gnu/gsasl/
guess_print_modfile libgsasl ${libgsasl_ver}
