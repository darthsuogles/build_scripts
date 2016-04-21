#!/bin/bash

ver=3.2.5

source ../gen_modules.sh

print_header R $ver
print_modline "prepend-path PATH ${drgscl_local}/cellar/R/$ver/bin"

man_dir=$(find ${drgscl_local}/cellar/R/$ver -type d -name man)
[ -z $man_dir ] || print_modline "prepend-path MANPATH $man_dir"

pkg_config_dir=$(find ${drgscl_local}/cellar/R/$ver -type d -name pkgconfig)
[ -z $pkg_config_dir ] || print_modline "prepend-path PKG_CONFIG_PATH $pkg_config_dir"

#print_modline "prepend-path LD_LIBRARY_PATH /opt/stow/intel/composer_xe_2013_sp1/mkl/lib/intel64"
