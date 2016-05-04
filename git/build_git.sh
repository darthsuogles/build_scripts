#!/bin/bash

__pwd__="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${__pwd__}/../build_pkg.sh 
source ${__pwd__}/../gen_modules.sh 

url_prefix="https://www.kernel.org/pub/software/scm/git"
ver=$(curl -sL "${url_prefix}" | \
             perl -ne 'print "$1\n" if /git-(\d+(\.\d+)*)\.tar\.gz/' | tail -n1)
[ -n ${ver} ] || ver=2.8.8

prepare_pkg git "${url_prefix}/git-${ver}.tar.gz" ${ver} install_dir
cd ${ver}
./configure --prefix=$install_dir \
            --with-expat --with-curl --with-openssl
make -j8
make install

cd ${__pwd__}
print_header git ${ver}
print_modline "prepend-path PATH ${install_dir}/bin"
print_modline "prepend-path MANPATH ${install_dir}/share/man"
