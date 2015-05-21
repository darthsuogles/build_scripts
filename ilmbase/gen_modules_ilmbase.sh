#!/bin/bash

ver=${1:-2.2.0}
pkg=ilmbase
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv ILMBASE_HOME $install_dir"
print_modline "setenv ILMBASE_VER $ver"
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path PKG_CONFIG_PATH $install_dir/lib/pkgconfig"
