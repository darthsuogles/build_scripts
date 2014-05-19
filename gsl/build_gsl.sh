#!/bin/bash

ver=1.16

tmp_dir=/scratch1/phi/gsl
base_dir=$PWD

function quit_with()
{
    printf "Error [ $0 ]: \n"
    printf "      $@\n"
    exit
}

function update_pkg()
{
    if [ -d $ver ]; then return; fi
    
    fname=gsl-$ver
    tarball=$fname.tar.gz
    if [ ! -f $tarball ]; then
	curl -O http://mirror.team-cymru.org/gnu/gsl/$tarball
    fi
    fname=`tar -zxvf $tarball | sed -e 's@/.*@@' | uniq`
    if [ $fname != $ver ]; then mv $fname $ver; fi
    rm $tarball
}

mkdir -p $tmp_dir; cd $tmp_dir
update_pkg
ln -s $tmp_dir/$ver $base_dir/${ver}.src

cd $ver
./configure --prefix=$HOME/local
make -j8
make install
cd $base_dir
