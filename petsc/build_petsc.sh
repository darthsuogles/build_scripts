#!/bin/bash

# Include the auxiliary functions
source ../build_pkg.sh 
source ../gen_modules.sh 

module load python openmpi
BUILD_PETSC=no
BUILD_SLEPC=yes
ARCH=linux-gnu

function configure_fn() {
    export PETSC_ARCH=${petsc_ver}-${ARCH}
    export PETSC_DIR=${PWD}

    ./configure --prefix=$install_dir \
                --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpif90 \
                --with-shared-libraries \
                --with-debugging=no \
                --with-openmpi=1 \
                --download-fblaslapack \
                --download-scalapack \
                --download-metis --download-parmetis    
}
function build_fn() { make all test; }

# http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.7.0.tar.gz
guess_build_pkg petsc $PWD/petsc-lite-3.7.0.tar.gz \
                -c "configure_fn" -b "build_fn"

guess_print_modfile petsc ${petsc_ver}
petsc_dir="$(get_pkg_install_dir petsc ${petsc_ver})"
print_modline "setenv PETSC_DIR ${petsc_dir}"
print_modline "setenv PETSC_ARCH ${petsc_ver}-linux-gnu"
module load petsc
pip3 install petsc4py

export PETSC_DIR=${petsc_dir}
export PETSC_ARCH=${petsc_ver}-${ARCH}
log_info "Moving PETSC_DIR to the install dir $PETSC_DIR"

guess_build_pkg slepc ${PWD}/slepc-3.6.3.tar.gz
guess_print_modfile slepc ${slepc_ver}
