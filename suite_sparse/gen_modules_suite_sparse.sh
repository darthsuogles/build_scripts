#!/bin/bash

pkg=suite_sparse
ver=${1:-4.4.4}
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv SUITE_SPARSE_HOME $install_dir"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path CPATH $install_dir/include"
