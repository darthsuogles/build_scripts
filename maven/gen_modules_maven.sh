#!/bin/bash

ver=${1:-3.3.1}
pkg=maven
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv M2_HOME $install_dir"
print_modline "prepend-path PATH $install_dir/bin"

