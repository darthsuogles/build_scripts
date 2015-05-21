#!/bin/bash

pkg=gnuplot
ver=5.0.0
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path MANPATH $install_dir/share/man"

