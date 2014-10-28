#!/bin/bash

ver=4.0.3

source ../build_pkg.sh

function use_latest_version()
{
    latest_ver=$(curl -s http://download.zeromq.org | \
	perl -ne 'if ( $_ =~ /zeromq-(\d+\.\d+\.\d+)+?.tar.gz/ ) { print "$1\n" }' | \
	sort -n | tail -n1)
    if [[ $latest_ver > $ver ]]; then
	echo "Latest version $latest_ver"
	ver=$latest_ver
    fi
}

use_latest_version

prepare_pkg zmq http://download.zeromq.org/zeromq-$ver.tar.gz $ver install_dir

echo $install_dir
 
cd $ver
./configure --prefix=$install_dir
make -j8
make install
