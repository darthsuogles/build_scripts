#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh

set -ex

function build_emacs() {
    local url_prefix=http://ftp.gnu.org/gnu/emacs
    local tarball=$(curl -sL $url_prefix/ | \
	perl -ne 'print "$1\n" if /(emacs-(\d+(\.\d+)*)\.tar\.(gz|bz2))/' | \
	sort -V | tail -n1)
    local url="$url_prefix/${tarball}"
    local ver="$(echo "${tarball}" | perl -pe 's/emacs-(\d+(\.\d+)*)\.tar\.(gz|bz2)/$1/')"
    [ -n $ver ] || local ver=29.99    
    prepare_pkg emacs $url $ver install_dir
    emacs_ver=${ver}
    emacs_dir=${install_dir}
    echo ${install_dir}; exit

    cd $ver
    ./configure --prefix=$install_dir \
	--without-jpeg \
	--without-png \
	--without-tiff \
	--without-gif \
	--without-xpm \
	--with-x-toolkit=no \
	--without-x
    make -j32
    make install

# export CC=gcc
# export CXX=g++
# export CFLAGS='-g -O3 -gdwarf-2'
}
build_emacs

print_header emacs ${emacs_ver}
print_modline "prepend-path PATH ${emacs_dir}/bin"
print_modline "prepend-path MANPATH ${emacs_dir}/share/man"
