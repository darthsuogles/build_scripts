#!/bin/bash

ver=${1:-1.15.0}
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header leveldb $ver
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path LIBRARY_PATH $install_dir"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir"
