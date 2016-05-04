#!/bin/bash

ver=2.2
pkg=tmux

source ../build_pkg.sh
source ../gen_modules.sh

prepare_pkg $pkg https://github.com/tmux/tmux/releases/download/${ver}/${pkg}-${ver}.tar.gz $ver install_dir
log_info $install_dir

cd ${ver}
./configure --prefix=${install_dir}
make -j8 && make install

print_header $pkg $ver
print_modline "prepend-path PATH ${install_dir}/bin"
print_modline "prepend-path MANPATH ${install_dir}/share"
