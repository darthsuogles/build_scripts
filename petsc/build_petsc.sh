#!/bin/bash

# Include the auxiliary functions
source ../build_pkg.sh 
source ../gen_modules.sh 

ARCH=linux-gnu

function configure_fn() {
    export PETSC_ARCH=${petsc_ver}-${ARCH}
    export PETSC_DIR=${PWD}

    ./configure --prefix=$install_dir \
	COPTFLAGS="-g -O3 -mtune=native" \
	CXXOPTFLAGS="-g -O3 -mtune=native" \
	FOPTFLAGS="-g -O3 -mtune=native" \
        --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpif90 \
        --with-cxx-dialect=C++11 \
        --with-shared-libraries \
        --with-debugging=no \
        --with-openmpi=1 \
        --with-hdf5=1 \
        --with-elemental=1 \
        --download-fblaslapack \
        --download-scalapack \
        --download-metis --download-parmetis    
}
function build_fn() { make all test; }

url=http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.7.0.tar.gz
guess_build_pkg petsc ${url} -c "configure_fn" -b "build_fn" -d "openblas openmpi python hdf5 elemental"

cat <<EOF | tee -a "${petsc_module_file}"
setenv("PETSC_DIR", "${petsc_dir}")
setenv("PETSC_ARCH", "${petsc_ver}-linux-gnu")
EOF

module load petsc
pip3 install -U petsc4py
