#!/bin/bash

ver=3.4.0

source ../build_pkg.sh

[ ! -z $PETSC_DIR ] || quit_with "PETSC_DIR environment variable must be defined"

function use_latest_version()
{
    # local latest_ver=$(curl -s http://www.grycap.upv.es/slepc/download/changes.htm | \
    # 	perl -ne 'if ( $_ =~ /Changes\s+in\s+Version\s+(.+)\</ ) { print "$1\n" }' | \
    # 	sort -n | tail -n1)
    local latest_ver=$(curl -s http://www.grycap.upv.es/slepc/download/download.htm | \
	perl -ne 'if ( $_ =~ /filename=slepc-(\d[\d\.]+(\-.+)*)\.tar\.gz/ ) { print "$1\n" }' | \
	sort -n | tail -n1)
    if [[ $latest_ver > $ver ]]; then
	echo "Using latest version $latest_ver"
	ver=$latest_ver
    fi
}

use_latest_version

prepare_pkg slepc \
    http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-$ver.tar.gz \
    $ver install_dir

cd $ver
export SLEPC_VER=$ver
export SLEPC_DIR=$PWD
echo "Temporarily set SLEPC_DIR to the build dir $SLEPC_DIR"

./configure --prefix=$install_dir
make all
make test
make install
export SLEPC_DIR=$install_dir
