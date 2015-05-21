#!/bin/bash

pkg=metis
ver=${1:-5.1.0}
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv METIS_HOME $install_dir"
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path CPATH $install_dir/include"
