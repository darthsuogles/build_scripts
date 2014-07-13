#!/bin/bash

#ver=2.38.0-1
ver=2.38.0
build_dir=/tmp/graphviz
install_dir=$PWD/$ver

rhel_ver=`uname -a | perl -ne 'if ($_ =~ /\.(el\d)/) { print "$1" }'`

source ../build_pkg.sh

mkdir -p $build_dir; cd $build_dir
update_pkg http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-$ver.tar.gz $ver
[ -d $build_dir/$ver ] || quit_with "cannot find source diretory $build_dir"

mkdir -p $install_dir; ln -s $build_dir/$ver $install_dir/src
cd $build_dir/$ver
./configure --prefix=$install_dir \
    --disable-perl --disable-swig
make -j8
make install

