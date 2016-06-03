#!/bin/bash

source ../build_pkg.sh

function configure_fn() {
    local python_dir="$(python3-config --prefix)"
    local python_ver=$(python3 --version | awk '{print $2}')
    mkdir -p build-tree && cd $_
    cmake \
        -D CMAKE_PREFIX_PATH=${install_dir} \
        -D CMAKE_INSTALL_PREFIX:PATH=${install_dir} \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D BUILD_PYTHON_SUPPORT:BOOL=ON \
        -D BUILD_opencv_python2:BOOL=OFF \
        -D PYTHON_LIBRARY:PATH=${python_basedir}/lib \
        -D PYTHON_INCLUDE_DIR:PATH=$python_basedir/include/python${python_ver%.*} \
        -D WITH_IPP:BOOL=OFF -D WITH_IPP_A:BOOL=OFF \
        -D USE_CUDA:BOOL=OFF \
        ..
}

function build_fn() {
    LD_LIBRARY_PATH="$(brew --prefix)/lib" make -j64
}

guess_build_pkg opencv https://github.com/Itseez/opencv/archive/3.1.0.zip \
                -c "configure_fn" -b "build_fn" -d "python openblas"
