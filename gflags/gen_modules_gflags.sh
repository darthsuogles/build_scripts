#!/bin/bash

ver=${1:-2.1.1}
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header gflags $ver
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path CPATH $install_dir/include"
