#!/bin/bash

source ../gen_modules.sh

ver=`latest_version`
module_file=$HOME/.modulefiles/erlang/$ver

dirname $module_file | xargs mkdir -p 

print_header "Erlang $ver" | tee $module_file
print_modline "conflict erlang"
print_modline "prepend-path PATH $PWD/$ver/bin"

