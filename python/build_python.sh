#!/bin/bash

source ../build_pkg.sh 
function configure_fn() {
    module load linuxbrew sqlite
    brew install sqlite3 bzip2 xz

    local gcc6_flags="-static-libgcc -static-libstdc++"
    local linuxbrew_flags="-Wl,-rpath=$(brew --prefix)/lib -L$(brew --prefix)/lib"
    ./configure --prefix=${install_dir} \
	--enable-shared --enable-profiling --with-thread \
	--enable-loadable-sqlite-extensions \
	CC=gcc CXX=g++ \
        CFLAGS="-mtune=native -O3 -g" \
        CPPFLAGS="-I$(brew --prefix)/include $(pkg-config sqlite3 --cflags)" \
	LDFLAGS="${gcc6_flags} ${linuxbrew_flags} $(pkg-config sqlite3 --libs) -Wl,-rpath=${install_dir}/lib"
}

USE_LATEST_VERSION=no
guess_build_pkg python http://www.python.org/ftp/python/3.5.1/Python-3.5.1.tgz \
    -c "configure_fn" -d "linuxbrew sqlite"
