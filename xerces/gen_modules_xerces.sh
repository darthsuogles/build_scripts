#!/bin/bash

pkg=xerces
ver=${1:-3.1.2}

install_dir=$PWD/$ver
source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv XERCES_HOME $install_dir"
print_modline "setenv XERCES_VER $ver"
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path PKG_CONFIG_PATH $install_dir/lib/pkgconfig"
