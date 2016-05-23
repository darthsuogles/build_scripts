#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_SQLITE=yes

guess_build_pkg sqlite https://www.sqlite.org/2016/sqlite-autoconf-3120200.tar.gz
guess_print_modfile sqlite ${sqlite_ver}

# print_header sqlite3 "${sqlite3_ver}"
# print_modline "prepend-path PATH ${sqlite3_dir}/bin"
# print_modline "prepend-path CPATH ${sqlite3_dir}/include"
# print_modline "prepend-path PKG_CONFIG_PATH  ${sqlite3_dir}/lib/pkgconfig"
# print_modline "prepend-path MANPATH ${sqlite3_dir}/share/man"

