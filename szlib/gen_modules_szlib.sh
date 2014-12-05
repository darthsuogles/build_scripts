#!/bin/bash

ver=${1:-2.1}
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header szlib $ver
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
