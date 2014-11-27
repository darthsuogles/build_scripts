#!/bin/bash

ver=3.10.2

source ../build_pkg.sh
prepare_pkg atlas http://sourceforge.net/projects/math-atlas/files/Stable/${ver}/atlas${ver}.tar.bz2 $ver install_dir

cd $ver
mkdir -f build-tre ; cd build-tree
../configure --prefix=$HOME/local --shared
make              # tune and compile library
make check        # perform sanity tests
make ptcheck      # checks of threaded code for multiprocessor systems
make time         # provide performance summary as % of clock rate
make install      # Copy library and include files to other directories
