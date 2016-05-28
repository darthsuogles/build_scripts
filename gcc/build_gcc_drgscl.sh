#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

set -ex

BUILD_TYPE=gcc6-drgscl

toolchain_root="$(get_install_root)/toolchain"
mkdir -p ${toolchain_root}

log_info "Initial build using system gcc"
toolchain_install_dir=${toolchain_root}/${BUILD_TYPE}

gcc_url=http://www.netgull.com/gcc/releases/gcc-6.1.0/gcc-6.1.0.tar.bz2
binutils_url=http://ftp.gnu.org/gnu/binutils/binutils-2.26.tar.bz2

function c_fn() {

    log_info "Packages will be installed at: ${toolchain_install_dir}"
    (
        log_info "Download prerequisite packages into the source tree"
        ./contrib/download_prerequisites

        log_info "Linking binutils to the top-level source directory"
        curl -sLO ${binutils_url}
        tarball=$(basename "${binutils_url}")
        if [ "binutils-${binutils_ver}.tar.bz2" != "${tarball}" ]; then
            log_warn "mismatched tarball names ${tarball}"
        fi
        extracted_dir=$(tar -jxvf ${tarball} | sed -e 's@/.*@@' | uniq)
        binutils_pkglist=("bfd" "binutils" "gas" "gprof" "ld" "opcodes"
                          "addr2line" "ar" "c++filt" "nm"
                          "gold" "nlmconv" "readelf" "strip" 
                          "objcopy" "objdump" "ranlib" 
                          "size" "strings")

        for pkg in ${binutils_pkglist[@]}; do
            if [ -d "${extracted_dir}/${pkg}/" ]; then
                log_info "linking ${pkg} from [binutils] to gcc src root"
                ln -s ${extracted_dir}/${pkg} .
            else
                log_warn "cannot find ${pkg} from [binutils], skip"
            fi
        done
    )

    local src_dir=$PWD
    mkdir -p "${src_dir}/../build-tree-${gcc_ver}" && cd "$_"

    $src_dir/configure \
        --prefix=${toolchain_install_dir} \
        CC=gcc CXX=g++ \
        --enable-checking=release \
        --enable-languages=c,c++,fortran \
        --enable-threads \
        --enable-lto \
        --enable-gold \
        --enable-tls \
        --disable-werror \
        --disable-nls \
        --disable-multilib
}

function b_fn() { make -j 32 profiledbootstrap; }

guess_build_pkg toolchain ${gcc_url} -t drgscl -c "c_fn" -b "b_fn" -d "linuxbrew"
