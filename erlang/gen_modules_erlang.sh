#!/bin/bash

source ../gen_modules.sh

ver=`latest_version`
export module_file=$HOME/.modulefiles/erlang/$ver

dirname $module_file | xargs mkdir -p 

function print_module_file()
{
    print_header "Erlang $ver" 
    echo "conflict erlang"
    echo "prepend-path PATH $PWD/$ver/bin" 
}

print_module_file | tee $module_file

