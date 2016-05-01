#!/bin/bash

ver_major=1.8
ver_minor=3 # prev: 1
ver=$ver_major.$ver_minor

SKIP_BUILD=no

source ../build_pkg.sh 
source ../gen_modules.sh 

ver=$(curl -sL http://www.open-mpi.org/software/ompi/ | \
             perl -ne 'print "$1\n" if /openmpi-(\d+(\.\d+)+)\.tar\.bz2/' | head -n1)
[ -n "${ver}" ] || ver=1.19.0
ver_major=${ver%.*}
ver_minor=${ver##*.}

url="http://www.open-mpi.org/software/ompi/v${ver_major}/downloads/openmpi-${ver}.tar.bz2"
prepare_pkg openmpi $url $ver install_dir

if [ "yes" != "${SKIP_BUILD}" ]; then
    cd $ver
    CFLAGS="-fgnu89-inline" ./configure --prefix="${install_dir}" --disable-vt
    make -j8 all
    make install
fi

print_header openmpi ${ver}
print_modline "prepend-path PATH ${install_dir}/bin"
print_modline "prepend-path MANPATH ${install_dir}/share/man"
print_modline "prepend-path LD_RUN_PATH        ${install_dir}/lib"
print_modline "prepend-path PKG_CONFIG_PATH    ${install_dir}/lib/pkgconfig"
print_modline "setenv  MPI_HOME       ${install_dir}"
