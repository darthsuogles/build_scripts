#!/bin/bash

ver=4.4

source ../build_pkg.sh

build_dir=/scratch1/phi/cgal
install_dir=$PWD/$ver

mkdir -p $build_dir; cd $build_dir
update_pkg https://gforge.inria.fr/frs/download.php/33525/CGAL-$ver.tar.gz $ver
mkdir -p $install_dir; ln -s $build_dir/$ver $install_dir/src

cd $build_dir/$ver
cmake -DCMAKE_INSTALL_PREFIX=$install_dir \
    -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DWITH_CGAL_Qt3=OFF \
    -DWITH_Eigen3=ON \
    -DWITH_LAPACK=ON
make -j8 
make install

