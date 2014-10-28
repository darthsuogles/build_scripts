#!/bin/bash

ver=3.5.0

# Include the auxiliary functions
source ../build_pkg.sh 

function get_latest_version()
{
    local latest_ver=$(curl -sl ftp://ftp.mcs.anl.gov/pub/petsc/release-snapshots/ | \
	perl -ne 'if ($_ =~ /^petsc-lite-(.+).tar.gz/) { print "$1\n" }' | sort | tail -n1)
    if [[ "$latest_ver" > "$ver" ]]; then
	echo "Latest version $latest_ver is available"
	ver=$latest_ver
    fi
}

get_latest_version

export PETSC_VER=$ver
export BUILD_PYTHON_PKG=0
base_dir=$(dirname ${BASH_SOURCE[0]})

[ $# -le 1 ] || quit_with  "[build_petsc]: usage [petsc_arch]"
arch=${1:-linux-gnu}

module load cuda
CUSP_DIR=$HOME/cuda/cusplibrary
[ -d $CUSP_DIR ] || quit_with "cusp must be installed in the system"
if [ "$arch" == "linux-cuda-base" ]; then    
    echo "Building PETSc with CUDA"
    CUDA_CONFIG="--with-cuda=1 --with-cuda-dir=$CUDA_HOME --with-cuda-only=1 --with-cuda-arch=sm_13"
elif [ "$arch" == "linux-cuda-all" ]; then
    echo "Building PETSc with CUDA and CUSP support"
    echo ">>> CUSP is installed in the CUDA_SDK directory at $CUSP_DIR"
    CUDA_CONFIG="--with-cuda=1 --with-cuda-dir=$CUDA_HOME --with-thrust=1 --with-cusp=1 --with-cusp-dir=$CUSP_DIR --with-cuda-arch=sm_13"    
fi

# Download the tarball and prepare the build directory
prepare_pkg petsc http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-$ver.tar.gz $ver install_dir
echo "PETSc will be installed to $install_dir"
[ "$base_dir" != "PWD" ] || quit_with "[build_petsc] failed to get to a temporary build dir"

# Add the version string to PETSC_ARCH
cd $ver
export PETSC_ARCH=$PETSC_VER-$arch
export PETSC_DIR=$PWD
echo "Temporarily setting up PETSC_DIR to the tmp build dir $PETSC_DIR"

./configure --prefix=$install_dir \
    --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpif90 \
    --with-shared-libraries \
    --with-debugging=no \
    --with-openmpi=1 \
    --download-fblaslapack \
    --download-scalapack \
    ${CUDA_CONFIG}
make all test
make install

export PETSC_DIR=$install_dir
echo "Moving PETSC_DIR to the install dir $PETSC_DIR"

cd $base_dir
echo "Building SLEPc"
cd slepc
./build_slepc.sh
cd ..

echo "Building TAO"
cd tao
./build_tao.sh
cd ..

if [[ $BUILD_PYTHON_PKG -ne 0 ]]; then
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
./gen_modules.sh | tee ~/.modulefiles/petsc/$module_file
