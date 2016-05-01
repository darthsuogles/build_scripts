#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_PYTHON=yes

module load gcc

function build_python3() {
    local latest_ver=$(curl -sL http://www.python.org/ftp/python | \
                              perl -ne 'print "$1\n" if /(3(\.\d+)+)/' | \
                              tail -n1)
    [ -z "${latest_ver}" ] || local ver="${latest_ver}"
    local cflags="-mtune=native -O3 -g"

    local url="http://www.python.org/ftp/python/$ver/Python-${ver}.tgz"
    prepare_pkg python ${url} ${ver} install_dir
    python3_ver=${ver}
    python3_dir=${install_dir}

    [ "yes" == "${BUILD_PYTHON}" ] || return
    cd $ver
    make clean; make distclean; 
    ./configure --prefix=${install_dir} \
          --enable-shared --with-thread \
          CC=gcc CXX=g++ CFLAGS="${cflags}" \
          LDFLAGS="-Wl,--rpath=${install_dir}/lib"
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
print_modline    "set-alias      python3         \"LD_LIBRARY_PATH=${python_dir}/lib ${python_dir}/bin/python3\""
print_modline    "prepend-path   PATH            ${python_dir}/bin"
print_modline    "prepend-path   MANPATH         ${python_dir}/share/man"
print_modline    "prepend-path   PKG_CONFIG_PATH ${python_dir}/lib/pkgconfig"
