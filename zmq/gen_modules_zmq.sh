#!/bin/bash

base_dir=$(dirname ${BASH_SOURCE[0]})/..
base_dir=$(readlink -f $base_dir)
pkg_dir=$base_dir/zmq

source $base_dir/gen_modules.sh

ver=`latest_version $pkg_dir`

print_header zmq $ver
print_modline "setenv ZMQ_VER $ver"
print_modline "setenv ZMQ_HOME $pkg_dir/$ver"
print_modline "prepend-path PATH $pkg_dir/$ver/bin"
print_modline "prepend-path CPATH $pkg_dir/$ver/include"
print_modline "prepend-path LD_LIBRARY_PATH $pkg_dir/$ver/lib"
print_modline "prepend-path LD_RUN_PATH $pkg_dir/$ver/lib"
print_modline "prepend-path PKG_CONFIG_PATH $pkg_dir/$ver/lib/pkgconfig"
print_modline "prepend-path MANPATH $pkg_dir/$ver/share/man"
