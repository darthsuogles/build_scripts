#!/bin/bash

BUILD_OPENMPI=yes

source ../build_pkg.sh 
source ../gen_modules.sh 

module load toolchain/gcc6.1.0-glibc2.23-binutils2.26

function build_openmpi() {
    ver=$(curl -sL http://www.open-mpi.org/software/ompi/ | \
                 perl -ne 'print "$1\n" if /openmpi-(\d+(\.\d+)+)\.tar\.bz2/' | head -n1)
    [ -n "${ver}" ] || ver=1.19.0
    ver_major=${ver%.*}
    ver_minor=${ver##*.}

    url="http://www.open-mpi.org/software/ompi/v${ver_major}/downloads/openmpi-${ver}.tar.bz2"
    prepare_pkg openmpi $url $ver install_dir
    [ "yes" == "${BUILD_OPENMPI}" ] || return 0

    cd $ver
    
    local ldflags="-static-libgcc -static-libstdc++"
    LDFLAGS="${ldflags}" ./configure --prefix=${install_dir} \
                --enable-static
    #CFLAGS="-fgnu89-inline" ./configure --prefix="${install_dir}" --disable-vt
    make -j32 all
    make install
}
build_openmpi

print_header openmpi ${ver}
print_modline "prepend-path PATH ${install_dir}/bin"
print_modline "prepend-path MANPATH ${install_dir}/share/man"
#print_modline "prepend-path LD_RUN_PATH        ${install_dir}/lib"
print_modline "prepend-path PKG_CONFIG_PATH    ${install_dir}/lib/pkgconfig"
print_modline "setenv  MPI_HOME       ${install_dir}"
