#!/bin/bash

source ../gen_modules.sh

ver=0.84

print_header elemental $ver

bin_dir=$(find $PWD/$ver -type d -name bin)
[ -z $bin_dir ] || print_modline "prepend-path PATH $bin_dir"

inc_dir=$(find $PWD/$ver -type d -name include)
[ -z $inc_dir ] || print_modline "prepend-path CPATH $inc_dir"

lib_dir=$(find $PWD/$ver -type d -name lib)
[ -z $lib_dir ] || print_modline "prepend-path LD_LIBRARY_PATH $lib_dir"

man_dir=$(find $PWD/$ver -type d -name man)
[ -z $man_dir ] || print_modline "prepend-path MANPATH $man_dir"

info_dir=$(find $PWD/$ver -type d -name info)
[ -z $info_dir ] || print_modline "prepend-path INFOPATH $info_dir"

print_modline "setenv ELEMENTAL_HOME $PWD/$ver"
