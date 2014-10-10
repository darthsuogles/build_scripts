#!/bin/bash

ver=4.300.8

if [ ! -d $ver ]; then
    fname=armadillo-$ver
    tarball=$fname.tar.gz
    if [ ! -f $tarball ]; then
	wget http://sourceforge.net/projects/arma/files/$tarball
    fi
    echo "Uncompressing ... might take a while ... please be patient"
    fname=`tar -zxvf $tarball | sed -e 's@/.*@@' | uniq`
    if [ $fname != $ver ]; then mv $fname $ver; fi
fi
