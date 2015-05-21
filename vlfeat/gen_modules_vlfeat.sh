#!/bin/bash

ver=${1:-0.9.20}
pkg=vlfeat
install_dir=$PWD/$ver
arch=`ls $install_dir/bin | grep -Ei *64 | head -n1`

source ../gen_modules.sh

print_header $pkg $ver
print_modline "# To use the C interface, refer to http://www.vlfeat.org/install-c.html"
print_modline "prepend-path PATH $install_dir/bin/$arch"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/bin/$arch"
print_modline "setenv VLFEATROOT $install_dir"

