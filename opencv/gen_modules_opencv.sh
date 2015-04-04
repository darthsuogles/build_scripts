#!/bin/bash

ver=2.4.10
install_dir=$PWD/$ver/vanilla

source ../gen_modules.sh

print_header opencv $ver
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path PKG_CONFIG_PATH $install_dir/lib/pkgconfig"

