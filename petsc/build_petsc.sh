#!/bin/bash

# Include the auxiliary functions
source build_pkg.sh 

update_pkg http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.5.0.tar.gz
exit

#export PETSC_VER=3.3-p7
export PETSC_VER=3.5.0

export PETSC_DIR=$PWD/$PETSC_VER
export BUILD_PYTHON_PKG=0

if [[ $# -gt 1 ]]; then
    echo "Usage $0 [petsc_arch]"
    exit
elif [[ $# -eq 1 ]]; then
    arch=$1
else
    arch=linux-gnu
fi

function quit_with()
{
    echo "Error: $@"
    exit
}


if [[ $arch == "linux-cuda-base" ]]; then    
    CUSP_DIR=$HOME/cuda_sdk/cusplibrary
    echo "Building PETSc with CUDA"
    CUDA_CONFIG="--with-cuda=1 --with-cuda-dir=$CUDA_HOME --with-cuda-only=1 --with-cuda-arch=sm_13"
elif [[ $arch == "linux-cuda-all" ]]; then
    CUSP_DIR=$HOME/cuda_sdk/cusplibrary
    echo "Building PETSc with CUDA and CUSP support"
    echo ">>> CUSP is installed in the CUDA_SDK directory at $CUSP_DIR"
    CUDA_CONFIG="--with-cuda=1 --with-cuda-dir=$CUDA_HOME --with-thrust=1 --with-cusp=1 --with-cusp-dir=$CUSP_DIR --with-cuda-arch=sm_13"    
fi

# Add the version string to PETSC_ARCH
export PETSC_ARCH=$PETSC_VER-$arch


CONFIG_OPTIONS="--with-debugging=no --with-openmpi=1 --download-openmpi --download-f-blas-lapack $CUDA_CONFIG"
echo "Configuring PETSc with the following options"
echo "$CONFIG_OPTIONS"

# Check if petsc is in the directory
if [ ! -d $PETSC_VER ]; then
    fname=petsc-$PETSC_VER
    tarball=$fname.tar.gz
    if [ ! -f $tarball ]; then
	wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/$tarball
	[ -d $tarball ] || quit_with "failed to download $tarball"
    fi    
    echo "extracting the tarball, patience"
    tar -zxf $tarball
    mv $fname $PETSC_VER
    rm $tarball
fi
   
cd $PETSC_DIR

./configure --with-shared-libraries $CONFIG_OPTIONS
make all 
make test
#make install

cd ..

echo "Building SLEPc"
cd slepc
./build_slepc.sh
cd ..

echo "Building TAO"
cd tao
./build_tao.sh
cd ..

if [[ $BUILD_PYTHON_PKG -gt 0 ]]; then
    echo "Building petsc4py"
    pip uninstall -qy petsc4py
    pip install petsc4py

    echo "Building slepc4py"
    pip uninstall -qy slepc4py
    pip install slepc4py

    echo "Building tao4py"
    pip uninstall -qy tao4py
    pip install tao4py
fi

echo "Generating module file"
module_file=$PETSC_ARCH-openmpi
./gen_modules.sh >$module_file
cp $module_file ~/.modulefiles/petsc/.
