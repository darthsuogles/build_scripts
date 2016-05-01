#!/bin/bash

ver=1.2.8

SKIP_BUILD=yes

source ../build_pkg.sh 
source ../gen_modules.sh 

prepare_pkg zlib "http://zlib.net/zlib-${ver}.tar.gz" ${ver} install_dir

if [ "yes" != "${SKIP_BUILD}" ]; then    
    cd $ver
    ./configure --prefix=${install_dir}
    make -j8
    make install
fi

print_header zlib ${ver}
print_modline "prepend-path CPATH ${install_dir}/include"
print_modline "prepend-path LIBRARY_PATH ${install_dir}/lib"
print_modline "prepend-path MANPATH ${install_dir}/share/man"
