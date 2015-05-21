#!/bin/bash

ver=${1:-3.2.4}
pkg=eigen
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv EIGEN_ROOT_DIR $install_dir"
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path PKG_CONFIG_PATH $install_dir/share/pkgconfig"
