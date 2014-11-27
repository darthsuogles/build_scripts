#!/bin/bash

ver=2.3.2

source ../build_pkg.sh

prepare_pkg unixodbc ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-$ver.tar.gz $ver install_dir
echo $install_dir

cd $ver
./configure --prefix=$HOME/local
make 
make install
