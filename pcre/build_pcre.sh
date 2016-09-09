#!/bin/bash

source ../build_pkg.sh 

function c_fn() {
    ./configure --prefix=${install_dir} \
                --enable-utf \
                --enable-pcre8 \
                --enable-pcre16 \
                --enable-pcre32 \
                --enable-unicode-properties \
                --enable-pcregrep-libz \
                --enable-pcregrep-libbz2 \
                --enable-jit \
                --disable-cpp    
}

url=https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2 
guess_build_pkg pcre ${url} -c "c_fn" -d "bzip2 zlib"
