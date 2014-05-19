#!/bin/bash

ver=3.2.10

cd $ver

echo "configure"
#./configure --prefix=$HOME/local --with-tcl=$HOME/local/src/tcl/8.6.0/unix --with-tcl-ver=8.6
./configure --prefix=$HOME/local --with-tcl=/usr/lib64 --with-tcl-ver=8.4
echo "build"
make -j8
make install

cd ..
