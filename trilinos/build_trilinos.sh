#!/bin/bash

BUILD_TRILINOS=yes
#USE_LATEST_VERSION=no

source ../build_pkg.sh 
source ../gen_modules.sh 

module load openmpi python cmake boost swig

function configure_fn() {    
    rm -fr build-tree && mkdir build-tree && cd $_
    cmake -D CMAKE_INSTALL_PREFIX=${install_dir} \
          -D TPL_ENABLE_MPI=ON -D MPI_BASE_DIR="${MPI_HOME}" \
          -D MPI_C_COMPILER:FILEPATH=mpicc \
          -D MPI_CXX_COMPILER:FILEPATH=mpic++ \
          -D MPI_Fortan_COMPILER:FILEPATH=mpif77 \
          -D TPL_ENABLE_Netcdf=OFF \
          -D TPL_ENABLE_BoostLib=OFF \
          -D Trilinos_ENABLE_PyTrilinos=ON \
          -DTrilinos_ENABLE_Epetra=ON \
          -DTrilinos_ENABLE_AztecOO=ON \
          -DTrilinos_ENABLE_Ifpack=ON \
          -D BUILD_SHARED_LIBS=ON \
          ..
}

url="http://trilinos.csbsju.edu/download/files/trilinos-12.6.3-Source.tar.bz2"
guess_build_pkg trilinos ${url} -c "configure_fn"
                
