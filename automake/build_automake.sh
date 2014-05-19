#!/bin/bash

ver=1.14

if [ ! -d $ver ]; then
    fname=automake-$ver
    tarball=$fname.tar.gz
    if [ ! -r $tarball ]; then
	wget http://ftp.gnu.org/gnu/automake/$tarball
    fi
    fname=`tar -zxvf $tarball | sed -e 's@/.*@@' | uniq`
    mv $fname $ver
    rm -fr $tarball
fi

cd $ver
./configure --prefix=$HOME/local
make -j8
make install
cd ..
