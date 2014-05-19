#!/bin/bash

ver_major=2.6
ver_minor=0
ver=$ver_major.$ver_minor

if [ ! -d $ver ]; then
    fname=bzr-$ver
    tarball=$fname.tar.gz
    if [ ! -f $tarball ]; then
	wget https://launchpad.net/bzr/$ver_major/$ver/+download/$tarball
    fi
    fname=`tar -tzf $tarball | sed -e 's@/.*@@' | uniq`
    tar -zxvf $tarball
    mv $fname $ver
    rm -fr $tarball
fi

