#!/bin/bash

ver_major=4.8
ver_minor=6
ver=$ver_major.$ver_minor

tmp_dir=/scratch1/phi/qt
base_dir=$PWD

if [ ! -d $ver ]; then
    fname=qt-everywhere-opensource-src-$ver
    tarball=$fname.tar.gz

    mkdir -p $tmp_dir; cd $tmp_dir
    if [ ! -e $tarball ]; then
	#wget http://download.qt-project.org/official_releases/qt/$ver_major/$ver/$tarball
	wget http://download.qt-project.org/archive/qt/$ver_major/$ver/$tarball
    fi
    echo "Uncompressing ... might take a while ... please be patient"
    fname=`tar -zxvf $tarball | sed -e 's@/.*@@' | uniq`
    if [ -z $fname ] || [ ! -d $fname ]; then 
	echo "Error: failed to decompress package, quit"
    fi
    mv $fname $ver
    rm -fr $tarball
    ln -s $tmp_dir/$ver $base_dir/$ver
    cd $base_dir
fi

cd $ver
make distclean; make clean
./configure -prefix $HOME/local/Trolltech/Qt-$ver \
    -opensource -confirm-license -fast 
make -j8
make install
cd ..
