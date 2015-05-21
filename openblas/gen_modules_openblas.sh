#!/bin/bash

pkg=openblas
ver=${1:-0.2.14}
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv OPENBLAS_HOME $install_dir"
print_modline "setenv BLAS $install_dir/lib/libblas.so"
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"

