#!/bin/bash

source ../gen_modules.sh

#ver=`latest_version`
ver=$1
[ ! -z "$ver" ] || ver=`latest_version`

#export module_file=$HOME/.modulefiles/erlang/$ver
#dirname $module_file | xargs mkdir -p 

print_header erlang "$ver" 
print_modline "setenv ERLANG_VER $ver"
print_modline "setenv ERLANG_HOME $PWD/$ver"
print_modline "prepend-path PATH $PWD/$ver/bin" 
