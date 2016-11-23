#!/bin/bash

source ../build_pkg.sh 
function configure_fn() {
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

# https://github.com/Linuxbrew/homebrew-core/blob/master/Formula/python3.rb
USE_LATEST_VERSION=no
ver=3.5.2
guess_build_pkg python "http://www.python.org/ftp/python/${ver}/Python-${ver}.tgz" \
    -c "configure_fn" -d "linuxbrew sqlite"
