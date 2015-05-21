#!/bin/bash

ver=${1:-3.3.4}
pkg=fftw
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv FFTW_HOME $install_dir"
print_modline "setenv FFTW_VER $ver"
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path PKG_CONFIG_PATH $install_dir/lib/pkgconfig"
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path MANPATH $install_dir/share/man"
print_modline "prepend-path INFOPATH $install_dir/share/info"
