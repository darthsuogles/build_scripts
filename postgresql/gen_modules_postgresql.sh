#!/bin/bash

ver=${1:-9.4.1}
pkg=postgresql
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header $pkg $ver
print_modline "prepend-path PATH $install_dir/bin"
print_modline "prepend-path LD_LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path LIBRARY_PATH $install_dir/lib"
print_modline "prepend-path CPATH $install_dir/include"
print_modline "setenv PSQL_DATAPATH $HOME/phi_data_dir/psql_data"
