#!/bin/bash

source ./sysroot.sh
source ../build_pkg.sh
source ../gen_modules.sh 

IS_EXPRNL=no

CC_PASS1=gcc-5
CXX_PASS1=g++-5
BUILD_BINUTILS_PASS1=no
BUILD_GCC_PASS1=yes

BUILD_BINUTILS=yes
BUILD_GCC=yes
BUILD_GLIBC=yes
BUILD_MUSL=yes

ARCH="$(uname -m)"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
XRS_TGT="${ARCH}-qphi-${OS}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "yes" == "${IS_EXPRNL}" ]; then
    log_info "Conducting [EXPRNL] build"
    toolchain_install_dir="${toolchain_install_dir}-exprnl"
fi

function build_binutils_pass1() {
    prepare_pkg binutils ${binutils_url} ${binutils_ver} install_dir

    [ "yes" == "${BUILD_BINUTILS_PASS1}" ] || return
    cd ${binutils_ver}
    CC="${CC_PASS1}" CXX="${CXX_PASS1}" \
      ./configure --prefix=${toolchain_install_dir} \
      --with-sysroot=${SYSROOT} \
      --with-lib-path=${toolchain_install_dir}/lib \
      --target=${XRS_TGT} \
      --disable-nls \
      --disable-werror
    make -j32
    make install
}
build_binutils_pass1


function build_gcc_pass1() {
    prepare_pkg gcc ${gcc_url} ${gcc_ver} install_dir

    [ "yes" == "${BUILD_GCC}" ] || return
    log_info "Packages will be installed at: ${toolchain_install_dir}"
    log_info "Download prerequisite packages into the source tree"
    (cd ${gcc_ver} && ./contrib/download_prerequisites)
    
    log_info "Modifying GCC's default search path"
    (
        cd ${gcc_ver}
        for file in \
            $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
        do
            cp -uv $file{,.orig}
            sed -e "s@/lib\\(32\|64\\)\?/ld@${toolchain_install_dir}&@g" \
                -e "s@/usr@${toolchain_install_dir}@g" ${file}.orig > ${file}
            # sed -e "s@/lib\(64\)\?\(32\)\?/ld@${toolchain_install_dir}&@g" \
            #     -e "s@/usr@${toolchain_install_dir}@g" $file.orig > $file
            cat <<EOSTR >> $file
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "${toolchain_install_dir}/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""
EOSTR
            touch $file.orig
        done
    )

    [ "yes" == "${BUILD_GCC_PASS1}" ] || return
    mkdir -p build-tree-${gcc_ver} && cd $_
    ../${gcc_ver}/configure --prefix=${toolchain_install_dir} \
       --target=${XRS_TGT}                            \
       --with-glibc-version=2.11                      \
       --with-sysroot=${SYSROOT}                      \
       --with-newlib                                  \
       --without-headers                              \
       --with-local-prefix=${toolchain_install_dir}                     \
       --with-native-system-header-dir=${toolchain_install_dir}/include \
       --disable-nls                                  \
       --disable-shared                               \
       --disable-multilib                             \
       --disable-decimal-float                        \
       --disable-threads                              \
       --disable-libatomic                            \
       --disable-libgomp                              \
       --disable-libmpx                               \
       --disable-libquadmath                          \
       --disable-libssp                               \
       --disable-libvtv                               \
       --disable-libstdcxx                            \
       --enable-languages=c,c++    
    
    make -j32
    make install
}
build_gcc_pass1
exit

function build_gcc() {
    prepare_pkg gcc ${gcc_url} ${gcc_ver} install_dir
    
    [ "yes" == "${BUILD_GCC}" ] || return
    echo "Packages will be installed at: ${toolchain_install_dir}"
    echo "Download prerequisite packages into the source tree"
    (cd ${gcc_ver} && ./contrib/download_prerequisites)

    local src_dir=$PWD/${gcc_ver}
    mkdir -p build-tree-${gcc_ver}; cd build-tree-${gcc_ver}

    $src_dir/configure \
        --prefix=${toolchain_install_dir} \
        --enable-languages=c,c++,fortran \
        --enable-threads \
        --enable-lto \
        --enable-tls \
        --disable-multilib \
        --enable-gold

    make profiledbootstrap -j32
    make install
}
build_gcc

function build_glibc() {
    prepare_pkg glibc ${glibc_url} ${glibc_ver} install_dir

    [ "yes" == "${BUILD_GLIBC}" ] || return
    mkdir -p build-tree-${glibc_ver} && cd $_
    ../${glibc_ver}/configure --prefix=${toolchain_install_dir} \
       --with-binutils=${toolchain_install_dir} \
       --disable-werror \
       --enable-profile
    make -j32
    make install
}
build_glibc

function build_musl() {
    prepare_pkg musl ${musl_url} ${musl_ver} install_dir
    
    [ "yes" == "${BUILD_MUSL}" ] || return
    mkdir -p build-tree-${musl_ver} && cd $_
    ../${musl_ver}/configure --prefix=${toolchain_install_dir} \
       --syslibdir=${toolchain_install_dir}/lib
    make -j32
    make install
}
build_musl

print_header toolchain "${toolchain_ver}"
print_modline "setenv TOOLCHAIN_ROOT         ${toolchain_install_dir}"
print_modline "prepend-path PATH             ${toolchain_install_dir}/bin"
print_modline "prepend-path MANPATH          ${toolchain_install_dir}/share/man"
print_modline "prepend-path INFOPATH         ${toolchain_install_dir}/share/info"
