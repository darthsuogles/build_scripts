#!/bin/bash

pkg=cmake
ver=${1:-3.2.2}
ver_major=${ver%.*}
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path CMAKE_SYSTEM_PREFIX_PATH $HOME/local"
print_modline "prepend-path CMAKE_MODULE_PATH $install_dir/share/cmake-$ver_major/Modules"

