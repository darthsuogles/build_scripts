#!/bin/bash

#ver=2.1-p1
ver=2.2.2
export TAO_DIR=$PWD/$ver

function logging()
{
    echo "##----------------------------------------"
    echo "## Logging: $1"
}

if [ ! -d $ver ]; then
    logging "Downloading package tao version $ver"
    fname=tao-$ver
    tarball=$fname.tar.gz
    if [ ! -f $tarball ]; then
	wget http://www.mcs.anl.gov/research/projects/tao/download/$tarball
	[ -f $tarball ] || quit_with "failed to download $tarball"
    fi
    tar -zxvf $tarball
    mv $fname $ver
    rm $tarball
fi

cd $ver
logging "Building the package"
make all
cd ..
