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
python_include_dir=$PYTHONHOME/include/python${python_ver}l

cd $ver
if [ -d build-tree ]; then
    cd build-tree; make clean; cd ..
    rm -fr build-tree
fi
mkdir build-tree; cd build-tree
CC=gcc CXX=g++ CFLAGS='-O3 -gdwarf-2 -gstrict-dwarf' LDFLAGS='-lxml2' cmake .. -DCMAKE_INSTALL_PREFIX=${install_dir} \
    -DCMAKE_INCLUDE_PATH=$HOME/local/include \
    -DCMAKE_LIBRARY_PATH=$HOME/local/lib \
    -DCMAKE_BUILD_TYPE=Release \
    -DPYTHON_EXECUTABLE=$python_exec_fpath \
    -DPYTHON_LIBRARY=$python_lib_fpath \
    -DPYTHON_INCLUDE_DIR=$python_include_dir \
    -DPython_ADDITIONAL_VERSIONS=$PYTHON_VER 
#    -DPythonModular=ON -DRModular=ON

make -j GoogleMock # only needed on first build: fetch and compile GoogleMock
make -j all # compiling everything
make -j install # install required for "make test"
make -j test # compile and run all tests and examples
