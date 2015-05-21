#!/bin/bash

pkg=ncurses
ver=${1:-5.9}
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path MANPATH $install_dir/man"
print_modline "setenv NCURSES_ROOT $install_dir"
#print_modline "prepend-path PKG_CONFIG_PATH $install_dir/lib/pkgconfig"

