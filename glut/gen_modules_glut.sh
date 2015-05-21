#!/bin/bash

ver=3.0.0
pkg=glut
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib64"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib64"
print_modline "prepend-path PKG_CONFIG_PATH $install_dir/lib64/pkgconfig"
