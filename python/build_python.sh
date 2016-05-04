#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_PYTHON=yes

module load toolchain/gcc6.1.0-glibc2.23-binutils2.26

function build_sqlite3() {
    local ver=3120200
    prepare_pkg sqlite3 https://www.sqlite.org/2016/sqlite-autoconf-${ver}.tar.gz ${ver} install_dir
    sqlite3_ver=${ver}
    sqlite3_dir=${install_dir}

    cd ${ver}
    ./configure --prefix=${install_dir}
    make -j32
    make install
}
build_sqlite3

print_header sqlite3 "${sqlite3_ver}"
print_modline "prepend-path PATH ${sqlite3_dir}/bin"
print_modline "prepend-path CPATH ${sqlite3_dir}/include"
print_modline "prepend-path PKG_CONFIG_PATH  ${sqlite3_dir}/lib/pkgconfig"
print_modline "prepend-path MANPATH ${sqlite3_dir}/share/man"

module load "sqlite3/${sqlite3_ver}"

function build_python3() {
    local latest_ver=$(curl -sL http://www.python.org/ftp/python | \
                              perl -ne 'print "$1\n" if /(3(\.\d+)+)/' | \
                              tail -n1)
    [ -z "${latest_ver}" ] || local ver="${latest_ver}"

    local url="http://www.python.org/ftp/python/$ver/Python-${ver}.tgz"
    prepare_pkg python ${url} ${ver} install_dir
    python3_ver=${ver}
    python3_dir=${install_dir}

    [ "yes" == "${BUILD_PYTHON}" ] || return
    cd $ver
    make clean; make distclean; 

    local toolchain_ldflags="-Wl,--rpath=${TOOLCHAIN_ROOT}/lib64 -L${TOOLCHAIN_ROOT}/lib64"
    local sqlite3_cflags="-I${sqlite3_dir}/include"
    local sqlite3_ldflags="-L${sqlite3_dir}/lib"

    local cflags="-mtune=native -O3 -g ${sqlite3_cflags}"
    local ldflags="${toolchain_ldflags} -static-libgcc -static-libstdc++ ${sqlite3_ldflags}"

    ./configure --prefix=${install_dir} \
          --enable-shared --with-thread \
          --enable-loadable-sqlite-extensions \
          CC=gcc CXX=g++ CFLAGS="${cflags}" \
          LDFLAGS="${ldflags} -Wl,--rpath=${install_dir}/lib"
    make -j32
    make install
}
function build_python() { 
    build_python3
    python_ver=${python3_ver} 
    python_dir=${python3_dir}     
}
build_python

print_header python "${python_ver}"
print_modline    "prepend-path   PATH            ${python_dir}/bin"
print_modline    "prepend-path   MANPATH         ${python_dir}/share/man"
print_modline    "prepend-path   PKG_CONFIG_PATH ${python_dir}/lib/pkgconfig"
