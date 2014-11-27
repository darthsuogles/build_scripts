#!/bin/bash

ver=3.4.2

url_prefix=http://www.rabbitmq.com/releases/rabbitmq-server/v$ver/
tarball=rabbitmq-server-$ver.tar.gz

source ../build_pkg.sh

prepare_pkg rabbitmq $url_prefix/$tarball $ver install_dir
echo $install_dir

# Installation is different from standard packages
cd $ver
export TARGET_DIR=$install_dir
export SBIN_DIR=$install_dir/sbin
export MAN_DIR=$install_dir/share/man
export DOC_INSTALL_DIR=$install_dir/share/doc
make 
make install
