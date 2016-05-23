#!/bin/bash

BUILD_OPENMPI=yes

source ../build_pkg.sh 
source ../gen_modules.sh 

guess_build_pkg openmpi https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.2.tar.bz2
guess_print_modfile openmpi ${openmpi_ver}
print_modline "setenv  MPI_HOME       ${install_dir}"
