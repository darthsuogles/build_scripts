#!/bin/bash

source ./sysroot.sh
source ../build_pkg.sh
source ../gen_modules.sh 

set -ex

BUILD_TYPE=native-exprnl

BUILD_BINUTILS=no
BUILD_BINUTILS_NATIVE=yes
BUILD_GCC=no
BUILD_GLIBC=no
BUILD_GLIBC_NATIVE=no

toolchain_root="${SYSROOT}/${BUILD_TYPE}"
mkdir -p ${toolchain_root}

log_info "Initial build using system gcc"
export CC=gcc-5
export CXX=g++-5
toolchain_install_dir=${toolchain_root}/base

function build_binutils() {
    [ "yes" == "${BUILD_BINUTILS}" ] || return 0
    prepare_pkg binutils ${binutils_url} ${binutils_ver} install_dir
    
    cd ${binutils_ver}
    ./configure --prefix=${toolchain_install_dir} \
                --disable-nls \
                --disable-werror
    make -j32
    make install
}
build_binutils

function build_gcc() {
    [ "yes" == "${BUILD_GCC}" ] || return 0
    prepare_pkg gcc ${gcc_url} ${gcc_ver} install_dir
    
    log_info "Packages will be installed at: ${toolchain_install_dir}"
    log_info "Download prerequisite packages into the source tree"
    (
        cd ${gcc_ver} 
        ./contrib/download_prerequisites
        log_info "We build binutils-${binutils_ver} individually"
    )

    local src_dir=$PWD/${gcc_ver}
    mkdir -p build-tree-${gcc_ver}; cd build-tree-${gcc_ver}

    $src_dir/configure \
        --prefix=${toolchain_install_dir} \
        --enable-languages=c,c++ \
        --disable-multilib \
        --disable-multilib \
        --disable-decimal-float \
        --disable-threads \
        --disable-libatomic \
        --disable-libgomp \
        --disable-libmpx \
        --disable-libquadmath \
        --disable-libssp \
        --disable-nls

    make bootstrap -j32
    make install
}
build_gcc

function build_glibc() {
    [ "yes" == "${BUILD_GLIBC}" ] || return 0
    prepare_pkg glibc ${glibc_url} ${glibc_ver} install_dir
    
    mkdir -p build-tree-${glibc_ver} && cd $_
    ../${glibc_ver}/configure --prefix=${toolchain_install_dir} \
       --with-binutils=${toolchain_install_dir} \
       --disable-werror
    make -j32
    make install
}
build_glibc

# Now build an optimized verions from the newly built gcc
function gen_modules_gcc_base() {
    print_header toolchain "${toolchain_ver}-base"
    print_modline "setenv TOOLCHAIN_ROOT         ${toolchain_install_dir}"
    print_modline "prepend-path PATH             ${toolchain_install_dir}/bin"
    print_modline "prepend-path MANPATH          ${toolchain_install_dir}/share/man"
    print_modline "prepend-path INFOPATH         ${toolchain_install_dir}/share/info"
}
gen_modules_gcc_base
module load toolchain/${toolchain_ver}-base
export CC=gcc
export CXX=g++

toolchain_install_dir="${toolchain_root}/opt"

function build_binutils_native() {
    [ "yes" == "${BUILD_BINUTILS_NATIVE}" ] || return 0
    log_info "Buidling native version shipped with gcc"
    prepare_pkg binutils ${binutils_url} ${binutils_ver} install_dir

    cd ${binutils_ver}
    ./configure --prefix=${toolchain_install_dir} \
                --disable-nls \
                --disable-werror
    make -j32
    make install
}
build_binutils_native

function build_gcc_opt() {
    [ "yes" == "${BUILD_GCC}" ] || return 0
    prepare_pkg gcc ${gcc_url} ${gcc_ver} install_dir
    
    log_info "Packages will be installed at: ${toolchain_install_dir}"
    log_info "Download prerequisite packages into the source tree"
    (
        cd ${gcc_ver} 
        ./contrib/download_prerequisites
    )

    local src_dir=$PWD/${gcc_ver}
    mkdir -p build-tree-${gcc_ver}; cd build-tree-${gcc_ver}

    $src_dir/configure \
        --prefix=${toolchain_install_dir} \
        --enable-languages=c,c++,fortran \
        --enable-threads \
        --enable-lto \
        --enable-tls \
        --enable-gold \
        --disable-multilib \
        --disable-nls

    make profiledbootstrap -j32
    make install
}
build_gcc_opt

function build_glibc_native() {
    [ "yes" == "${BUILD_GLIBC_NATIVE}" ] || return 0
    prepare_pkg glibc ${glibc_url} ${glibc_ver} install_dir
    
    mkdir -p build-tree-${glibc_ver} && cd $_
    ../${glibc_ver}/configure --prefix=${toolchain_install_dir} \
       --with-binutils=${toolchain_install_dir} \
       --disable-werror \
       --enable-profile

    make -j32
    make install
}
build_glibc_native

function gen_modules_gcc() {
    print_header toolchain "${toolchain_ver}"
    print_modline "setenv TOOLCHAIN_ROOT         ${toolchain_install_dir}"
    print_modline "prepend-path PATH             ${toolchain_install_dir}/bin"
    print_modline "prepend-path MANPATH          ${toolchain_install_dir}/share/man"
    print_modline "prepend-path INFOPATH         ${toolchain_install_dir}/share/info"    
}
gen_modules_gcc
