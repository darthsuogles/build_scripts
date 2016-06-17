#!/bin/bash

__pwd__="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${__pwd__}/../build_pkg.sh 

module load linuxbrew

function c_fn() {
    ./configure --prefix=${install_dir} \
        --with-expat --with-curl --with-openssl
}

url="https://www.kernel.org/pub/software/scm/git/git-2.8.4.tar.xz"
guess_build_pkg git "${url}" -d "linuxbrew curl"
