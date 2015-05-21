#!/bin/bash

ver=0.9.20
pkg=vlfeat
url=http://www.${pkg}.org/download/${pkg}-$ver.tar.gz

source ../build_pkg.sh
prepare_pkg $pkg $url $ver install_dir

cd $ver
make
cp -r $PWD/* $install_dir/.
rm $install_dir/src


