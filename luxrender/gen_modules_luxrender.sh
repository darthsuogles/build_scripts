#!/bin/bash

pkg=luxrender
ver=${1:-1.4}
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "prepend-path PATH $install_dir"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir"
print_modline "prepend-path LIBRARY_PATH $install_dir"
print_modline "prepend-path PYTHONPATH $install_dir"
