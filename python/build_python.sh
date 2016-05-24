#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_PYTHON=yes

module load sqlite linuxbrew

function configure_fn() {
    local cflags="-mtune=native -O3 -g"
    export LIBRARY_PATH="$(brew --prefix)/lib"
    export CPATH="$(brew --prefix)/include"

    ./configure --prefix=${install_dir} \
		--enable-shared --with-thread \
		--enable-loadable-sqlite-extensions \
		CC=gcc CXX=g++ FC=gfortran CFLAGS="${CFLAGS} ${cflags}" \
        LDFLAGS="${LDFLAGS} -Wl,-rpath=${install_dir}/lib"
}

guess_build_pkg python http://www.python.org/ftp/python/3.5.1/Python-3.5.1.tgz -c "configure_fn"
guess_print_modfile python ${python_ver}
