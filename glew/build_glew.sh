#!/bin/bash

pkg=glew
ver=1.12.0

#    http://downloads.sourceforge.net/project/glew/glew/1.12.0/glew-1.12.0.tgz
url=http://downloads.sourceforge.net/project/$pkg/$pkg/$ver/$pkg-$ver.tgz
source ../build_pkg.sh

prepare_pkg $pkg $url $ver install_dir

cd $ver
make distclean; make clean
GLEW_PREFIX=$install_dir GLEW_DEST=$install_dir make extensions
GLEW_PREFIX=$install_dir GLEW_DEST=$install_dir make -j8
GLEW_PREFIX=$install_dir GLEW_DEST=$install_dir make install
