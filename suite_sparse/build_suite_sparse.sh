#!/bin/bash

pkg=suite_sparse
ver=${1:-4.4.4}

source ../build_pkg.sh

# Load the basic linear algebra depedencies
module load linalg

url=http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-$ver.tar.gz
prepare_pkg $pkg $url $ver install_dir

cd $ver
echo "The build involves changing a configure file"
cd SuiteSparse_config
cp $install_dir/../SuiteSparse_config.mk $PWD/.
make purge
cd ..

if [ ! -d metis-4.0 ]; then
    echo "Download metis 4.0.1"
    local metis_tarball=metis-4.0.1.tar.gz
    wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/${metis_tarball}
    tar -zxvf $metis_tarball
    rm $metis_tarball
fi

export SUITE_SPARSE_ROOT=$install_dir
make distclean
make
mkdir -p $SUITE_SPARSE_ROOT/lib $SUITE_SPARSE_ROOT/include
make install
