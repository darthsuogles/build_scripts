#!/bin/bash

pkg=julia
ver=$(ls -td */ | sort -n | tail | sed -e 's@/@@g')
[ ! -z $ver ] || ver=0.3.7
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path MANPATH $install_dir/share/man"
