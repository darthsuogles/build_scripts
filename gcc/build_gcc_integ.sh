#!/bin/bash

source ./sysroot.sh
source ../build_pkg.sh
source ../gen_modules.sh 

set -ex

BUILD_TYPE=native-integ
BUILD_GCC=yes

toolchain_root="${SYSROOT}/${BUILD_TYPE}"
mkdir -p ${toolchain_root}

log_info "Initial build using system gcc"
toolchain_install_dir=${toolchain_root}/decc5

module load texinfo
# sudo apt-get install -y libc6-dev-i386
# sudo apt-get install -y linux-headers-generic

function build_gcc() {
    prepare_pkg gcc ${gcc_url} ${gcc_ver} install_dir
    
    [ "yes" == "${BUILD_GCC}" ] || return
    log_info "Packages will be installed at: ${toolchain_install_dir}"
    (
        log_info "Download prerequisite packages into the source tree"
        cd ${gcc_ver}
        ./contrib/download_prerequisites

        log_info "Downloading bison"
        bison_ver=3.0.4
        bison_tarball=bison-${bison_ver}.tar.xz
        curl -sLO http://ftp.gnu.org/gnu/bison/${bison_tarball}
        tar -Jxf ${bison_tarball}

        log_info "Linking binutils to the top-level source directory"
        curl -sLO ${binutils_url}
        tarball=$(basename "${binutils_url}")
        if [ "binutils-${binutils_ver}.tar.bz2" != "${tarball}" ]; then
            quit_with "mismatched tarball names ${tarball}"
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

    local src_dir=$PWD/${gcc_ver}
    mkdir -p build-tree-${gcc_ver}; cd build-tree-${gcc_ver}

    $src_dir/configure \
        --prefix=${toolchain_install_dir} \
        --enable-checking=release \
        --enable-languages=c,c++,fortran \
        --enable-threads \
        --enable-lto \
        --enable-gold \
        --enable-tls \
        --disable-werror \
        --disable-nls \
        --disable-multilib

    #make -j 32 bootstrap
    make -j 32 profiledbootstrap
    make install
}
build_gcc
log_info "Done building gcc ${gcc_ver}"

function gen_modules_gcc() {
    print_header toolchain "${toolchain_ver}-${BUILD_TYPE}"
    print_modline "setenv TOOLCHAIN_ROOT         ${toolchain_install_dir}"
    print_modline "prepend-path PATH             ${toolchain_install_dir}/bin"
    print_modline "prepend-path MANPATH          ${toolchain_install_dir}/share/man"
    print_modline "prepend-path INFOPATH         ${toolchain_install_dir}/share/info"
}
gen_modules_gcc

