#!/bin/bash

ver_major=5
ver_minor=18.2
version=$ver_major.$ver_minor

base_dir=$PWD
build_dir=/scratch1/phi/perl

if [ ! -d $version ]; then
    fname=perl-$version
    tarball=$fname.tar.gz

    mkdir -p $build_dir; cd $build_dir
    if [ ! -f $tarball ]; then
	wget http://www.cpan.org/src/$ver_major.0/$tarball
    fi
    fname=`tar -xzvf $tarball | sed -e 's@/.*@@' | uniq` 
    mv $fname $version
    ln -s $build_dir/$version $base_dir/$version
    rm $tarball
    cd $base_dir
fi
 
cd $version
./Configure -des -Dprefix=$HOME/phi/local
make -j8
make test
make install
