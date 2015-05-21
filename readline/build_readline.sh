#!/bin/bash

ver=6.3

source ../build_pkg.sh

prepare_pkg readline ftp://ftp.cwru.edu/pub/bash/readline-$ver.tar.gz $ver install_dir
echo $install_dir

cd $ver
CC=gcc ./configure --prefix=$install_dir \
    --with-curses
make -j8
make install
