#!/bin/bash

ver=${1:-2.2.0}
pkg=openexr_viewers
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "prepend-path PATH $install_dir/bin:$install_dir/cg/bin"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/cg/lib64"

