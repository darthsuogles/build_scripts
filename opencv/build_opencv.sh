#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_OPENCV=yes

module load python

function configure_fn() {
    local python_dir="$(python3-config --prefix)"
    local python_ver=$(python3 --version | awk '{print $2}')
    mkdir -p build-tree && cd $_
    cmake \
        -D CMAKE_PREFIX_PATH=${install_dir} \
        -D CMAKE_INSTALL_PREFIX:PATH=${install_dir} \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D BUILD_PYTHON_SUPPORT:BOOL=ON \
        -D PYTHON_LIBRARY:PATH=${python_basedir}/lib \
        -D PYTHON_INCLUDE_DIR:PATH=$python_basedir/include/python${python_ver%.*} \
        -D USE_CUDA:BOOL=ON \
        ..
}

guess_build_pkg opencv https://github.com/Itseez/opencv/archive/3.1.0.zip \
                -c "configure_fn"
guess_print_modfile opencv ${opencv_ver}
