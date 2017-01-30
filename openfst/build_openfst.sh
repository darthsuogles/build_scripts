#!/bin/bash

source ../build_pkg.sh

# Does not work for gcc 6
function c_fn {
    CC=clang CXX=clang++ ./configure --prefix=${install_dir} --enable-grm
}

guess_build_pkg openfst \
                http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.6.0.tar.gz \
                -c 'c_fn' -d "python linuxbrew"
