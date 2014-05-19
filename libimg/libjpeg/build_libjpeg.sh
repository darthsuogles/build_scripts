#!/bin/bash

ver=9

if [ ! -d $ver ]; then
    fname=jpeg-$ver
    tarball=jpegsrc.v$ver.tar.gz
    wget http://www.ijg.org/files/$tarball
    tar -zxvf $tarball
    mv $fname $ver
    rm $tarball
fi

cd $ver
make clean; make distclean
./configure --prefix=$HOME/local
make 
make install
cd ..

