#!/bin/bash

# ver=2.4.40

# source ../build_pkg.sh
# prepare_pkg lmdb ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-$ver.tgz $ver install_dir

# cd $ver
# ./configure --prefix=$install_dir \
#     --disable-bdb
# make depend
# make -j16
# make test
# make install

# ver=dev
# source ../build_pkg.sh
# build_dir=`find_scratch_dir`/phi/lmdb
# install_dir=$PWD/dev

# mkdir -p $build_dir; cd $build_dir
# git clone https://gitorious.org/mdb/mdb.git
# mkdir -p $install_dir
# [ -d $install_dir/src ] || ln -s $build_dir/$ver $install_dir/src

# cd mdb

cd dev
make 


