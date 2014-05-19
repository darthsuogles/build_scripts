#!/bin/bash

ver=2.5.2
url_prefix="http://download.savannah.gnu.org/releases/freetype"
build_dir="/scratch1/phi/freetype"

function quit_with()
{
    script=`basename $0`
    printf "Error [$script]:\n"
    printf ">> %s\n" $@
    exit
}

src_dir=$PWD
mkdir -p $build_dir || quit_with "cannot build the directory"
cd $build_dir

if [ ! -d $ver ]; then
    fname=freetype-$ver
    tarball=$fname.tar.bz2
    if [ ! -f $tarball ]; then
	wget $url_prefix/$tarball || quit_with "cannot download $tarball"
    fi
    echo "Uncompressing ... might take a while ... please be patient"
    fname=`tar -jxvf $tarball | sed -e 's@/.*@@' | uniq`
    if [ -z $fname ] || [ ! -d $fname ]; then
	quit_with "failed to decompress $tarball"
    fi
    mv $fname $ver    
    rm $tarball
fi

cd $ver
./configure --prefix=$HOME/local
make -j8
make install
cd ..
cd $src_dir
