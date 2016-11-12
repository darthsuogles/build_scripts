#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

# "http://llvm.org/git/llvm.git" 
# "http://llvm.org/git/clang.git" 
# "http://llvm.org/git/clang-tools-extra.git" 
# "http://llvm.org/git/compiler-rt.git" 
# "http://llvm.org/git/polly.git" 
# "http://llvm.org/git/lld.git"
# "http://llvm.org/git/libcxx.git" 

llvm_ver=3.8.1

function download() {
    local url=$1
    local extract_path=$2
    fetch_tarball ${url} 1987 tarball
    check_tarball ${tarball} tar_args
    local fname=$(tar "-${tar_args}" "${tarball}" | sed -e 's@/.*@@' | uniq)
    if [ "${fname}" != "${extract_path}" ]; then mv ${fname} ${extract_path}; fi
}

function build_llvm() {
    (cd tools
     download "http://llvm.org/releases/${llvm_ver}/cfe-${llvm_ver}.src.tar.xz" clang
     #download "http://llvm.org/releases/${llvm_ver}/lld-${llvm_ver}.src.tar.xz" lld
     download "http://llvm.org/releases/${llvm_ver}/polly-${llvm_ver}.src.tar.xz" polly
    )
    (cd tools/clang/tools
     download "http://llvm.org/releases/${llvm_ver}/clang-tools-extra-${llvm_ver}.src.tar.xz" extra
     )
    (cd projects
     download "http://llvm.org/releases/${llvm_ver}/compiler-rt-${llvm_ver}.src.tar.xz" compiler-rt
     #download "http://llvm.org/releases/${llvm_ver}/libcxx-${llvm_ver}.src.tar.xz" libcxx
    )    
    local llvm_src_dir=${PWD}
    mkdir -p ../llvm-build-tree && cd $_
    cmake -D CMAKE_INSTALL_PREFIX=${install_dir} \
          -D CMAKE_BUILD_TYPE=Release \
          -D CMAKE_C_COMPILER=gcc \
          -D CMAKE_CXX_COMPILER=g++ \
          -D BUILD_SHARED_LIBS:BOOL=ON \
          "${llvm_src_dir}"
}

USE_LATEST_VERSION=no
guess_build_pkg llvm http://llvm.org/releases/${llvm_ver}/llvm-${llvm_ver}.src.tar.xz \
                -c "build_llvm"
