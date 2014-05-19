#!/bin/bash

ver=2013.2.0.0
ghc_ver=7.6.3

base_dir=$PWD
tmp_dir=/scratch1/phi/haskell

function quit_with()
{
    script=`basename $0`
    printf "Error [$script]:\n"
    printf ">> %s\n" $@
    exit
}

mkdir -p $tmp_dir

# Download the platform
if [ ! -d $ver ]; then
    fname=haskell-platform
    tarball=$fname-$ver.tar.gz

    cd $tmp_dir
    if [ ! -f $tarball ]; then
	wget http://lambda.haskell.org/platform/download/$ver/$tarball || \
	    quit_with "cannot download $tarball"
    fi
    echo "Uncompressing ... might take a while ... please be patient"
    fname=`tar -zxvf $tarball | sed -e 's@/.*@@' | uniq`
    if [ -z $fname ] || [ ! -d $fname ]; then
	quit_with "failed to decompress $tarball"
    fi
    mv $fname $ver
    ln -s $tmp_dir/$ver $base_dir/$ver
    rm $tarball
    cd $base_dir
fi

# Download the Glasgow compiler
if [ ! -d $ghc_ver ]; then
    fname=ghc-${ghc_ver}-x86_64-unknown-linux
    tarball=$fname.tar.bz2

    cd $tmp_dir
    if [ ! -f $tarball ]; then
	wget http://www.haskell.org/ghc/dist/$ghc_ver/$tarball || \
	    quit_with "cannot download $tarball"
    fi
    echo "Uncompressing ... might take a while ... please be patient"
    fname=`tar -jxvf $tarball | sed -e 's@/.*@@' | uniq`
    if [ -z $fname ] || [ ! -d $fname ]; then
	quit_with "failed to decompress $tarball"
    fi    
    mv $fname $ghc_ver
    ln -s $tmp_dir/$ghc_ver $base_dir/$ghc_ver
    rm $tarball
    cd $base_dir
fi

cd $base_dir
echo "Building ghc $ghc_ver"
cd $ghc_ver
./configure --prefix=$HOME/local
make
make install
cd ..

echo "Building haskell platform $ver"
cd $ver
./configure --prefix=$HOME/local
make 
make install
cd ..
