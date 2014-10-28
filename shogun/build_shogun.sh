#!/bin/bash

source ../build_pkg.sh

#url_prefix=ftp://shogun-toolbox.org/shogun/releases
pkg_url=$(curl -sL http://www.shogun-toolbox.org/page/news/onenew | \
    perl -ne 'print "$1\n" if /(ftp:\/\/(.*)shogun-(\d+\.?)*?\.tar\.bz2)/' | uniq)

ver=$(echo $pkg_url | perl -ne 'print $1 if /shogun-((\d+\.?)+?)\.tar/')
module load cplex

prepare_pkg shogun $pkg_url $ver install_dir
echo $install_dir

[ -d $PYTHONHOME ] || quit_with "python home variable not defined"
python_exec_fpath=$(which python)
python_ver=${PYTHON_VER%.*}
python_lib_path=$PYTHONHOME/lib
python_lib_fpath=$PYTHONHOME/lib/libpython${python_ver}.so
python_include_dir=$PYTHONHOME/include/python${python_ver}

cd $ver
rm -fr build-tree; mkdir build-tree; cd build-tree
CC=gcc CXX=g++ cmake .. -DCMAKE_INSTALL_PREFIX=${install_dir} \
    -DCMAKE_INCLUDE_PATH=$HOME/local/include \
    -DCMAKE_LIBRARY_PATH=$HOME/local/lib \
    -DCMAKE_BUILD_TYPE=Release \
    -DPYTHON_EXECUTABLE=$python_exec_fpath \
    -DPYTHON_LIBRARY=$python_lib_fpath \
    -DPYTHON_INCLUDE_DIR=$python_include_dir \
    -DPython_ADDITIONAL_VERSIONS=$PYTHON_VER \
    -DCPLEX_ROOT_DIR=${CPLEX_ROOT} \
    -DPythonModular=ON -DRModular=ON

make -j8
make install
