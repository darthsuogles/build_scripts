#!/bin/bash

install_dir=$PWD/dev

source ../gen_modules.sh

print_header libevent dev
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path CPATH $install_dir/include"
print_modline "prepend-path PKG_CONFIG_PATH $install_dir/lib/pkgconfig"
