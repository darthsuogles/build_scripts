#!/bin/bash

source ../build_pkg.sh 
function configure_fn() {
    #local opt_flags="-O3 -mtune=native -fgraphite -fgraphite-identity -floop-block -floop-interchange -floop-strip-mine -floop-parallelize-all -floop-unroll-and-jam -ftree-loop-linear"
    local opt_flags="-O3 -mtune=native"
    local brew_ldflags="-Wl,-rpath=$(brew --prefix)/lib -L$(brew --prefix)/lib -Wl,-rpath=$(brew --prefix)/lib64 -L$(brew --prefix)/lib64"
    local gcc6_ldflags="-static-libgcc -static-libstdc++"
    ./configure --prefix=${install_dir} \
	            --enable-shared --enable-profiling --with-thread \
	            --enable-loadable-sqlite-extensions \
	            CC=gcc CXX=g++ \
                CFLAGS="-g ${opt_flags}" \
                CPPFLAGS="-I${SQLITE_ROOT}/include $(pkg-config sqlite3 --cflags)" \
	            LDFLAGS="${gcc6_ldflags} ${brew_ldflags} $(pkg-config sqlite3 --libs) -Wl,-rpath=${install_dir}/lib"
}

USE_LATEST_VERSION=no
guess_build_pkg python http://www.python.org/ftp/python/3.5.1/Python-3.5.1.tgz \
    -c "configure_fn" -d "linuxbrew sqlite"
