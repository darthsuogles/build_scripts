#!/bin/bash

ver=${1:-2.84}
pkg=transmission
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "setenv TRANSMISSION_HOME $HOME/phi_data_dir/.transmission.config"
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path MANPATH $install_dir/share/man"
