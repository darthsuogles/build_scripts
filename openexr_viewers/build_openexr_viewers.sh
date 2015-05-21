#!/bin/bash

ver=${1:-2.2.0}
pkg=openexr_viewers

source ../build_pkg.sh

fltk_ver=1.3.3
fltk_url=http://fltk.org/pub/fltk/${fltk_ver}/fltk-${fltk_ver}-source.tar.gz
prepare_pkg fltk ${fltk_url} ${fltk_ver} install_dir
rm -fr ${install_dir}
fltk_install_dir=$(dirname ${install_dir})/fltk-${fltk_ver}
echo $fltk_install_dir

cd $fltk_ver
./configure --prefix=${fltk_install_dir}
make -j8
make install

# Build the real project
prepare_pkg $pkg http://download.savannah.nongnu.org/releases/openexr/$pkg-$ver.tar.gz $ver install_dir
install_dir=$HOME/local/src/openexr_viewers/$ver
cd $ver
./configure --prefix=$install_dir \
    --with-fltk-config=${fltk_install_dir}/bin/fltk-config \
    --without-cg
make -j8
make install

# Require NVIDIA Cg to run the display
cg_tarball=Cg-3.1_April2012_x86_64.tgz
wget http://developer.download.nvidia.com/cg/Cg_3.1/$cg_tarball
tar -zxvf $cg_tarball
cp -r usr $install_dir/cg
