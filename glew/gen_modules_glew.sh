#!/bin/bash

pkg=glew
ver=${1:-1.12.0}

install_dir=$PWD/$ver
source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv GLEW_HOME $install_dir"
print_modline "setenv GLEW_VER $ver"
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib64"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib64"
print_modline "prepend-path PKG_CONFIG_PATH $install_dir/lib64/pkgconfig"
