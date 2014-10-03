#!/bin/bash

ver=${1:-1.8.3}
pkg_prefix=${2:-$PWD}
pkg_dir=$pkg_prefix/$ver

# Include the modules utilities
source ../gen_modules.sh

print_header "Open MPI 1.8.3 with gcc 4.8.2"

echo "conflict mpi"
echo
echo "prepend-path PATH ${pkg_dir}/bin"
echo "prepend-path MANPATH ${pkg_dir}/share/man"
echo "prepend-path LD_RUN_PATH        ${pkg_dir}/lib"
echo "prepend-path PKG_CONFIG_PATH    ${pkg_dir}/lib/pkgconfig"
echo
echo "setenv  MPI_HOME       ${pkg_dir}"
