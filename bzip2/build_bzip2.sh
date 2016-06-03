#!/bin/bash

source ../build_pkg.sh 

function c_fn() { echo "no configure"; }
function b_fn() { make; } #make -f Makefile-libbz2_so; }
function i_fn() { make install PREFIX=${install_dir}; }
guess_build_pkg bzip2 "http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz" \
                -c "c_fn" -b "b_fn" -i "i_fn"
