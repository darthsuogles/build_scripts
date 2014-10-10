#!/bin/bash

#export SLEPC_VER=3.3-p4
export SLEPC_VER=3.4.0
export SLEPC_DIR=$PWD/$SLEPC_VER

function download_pkg()
{
    if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <version>"
	exit
    fi
    ver=$1

    fname=slepc-$ver
    tarball=$fname.tar.gz
    wget http://www.grycap.upv.es/slepc/download/download.php?filename=$tarball
    tar -zxf $tarball
    mv $fname $ver
    rm $tarball
}

if [ ! -d $SLEPC_VER ]; then
    download_pkg $SLEPC_VER    
fi

cd $SLEPC_DIR

./configure
make
make test
make install

cd ..
