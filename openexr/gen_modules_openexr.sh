#!/bin/bash

ver=${1:-2.2.0}
pkg=openexr
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv OPENEXR_BASE $install_dir"
print_modline "setenv OPENEXR_VER $ver"
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path PKG_CONFIG_PATH $install_dir/lib/pkgconfig"
print_modline "prepend-path CPATH $install_dir/include"
