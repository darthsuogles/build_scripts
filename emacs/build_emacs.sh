#!/bin/bash

ver=24.3

base_dir=$PWD
tmp_dir=/scratch0/phi/build_tmp

export CFLAGS='-g -gdwarf-2'

function quit_with()
{
    printf "Error: [ build_emacs.sh ]"
    printf ">>     $@"
}

if [ ! -d $ver ]; then
    fname=emacs-$ver
    tarball=$fname.tar.gz

    mkdir -p $tmp_dir/emacs; cd $tmp_dir/emacs
    if [ ! -f $tarball ]; then
	wget http://mirror.sdunix.com/gnu/emacs/emacs-24.3.tar.gz
    fi
    fname=`tar -zxvf $tarball | sed -e 's@/.*@@' | uniq`
    if [ -z $fname ]; then quit_with "failed to extract tarball"; fi
    mv $fname $ver || quit_with "failed to rename file directory"
    rm $tarball
    ln -s $tmp_dir/emacs/$ver $base_dir/$ver || quit_with "cannot create symlink"
fi

cd $ver
./configure --prefix=$HOME/local \
    --without-jpeg \
    --without-png \
    --without-tiff \
    --without-gif \
    --without-xpm \
    --with-x-toolkit=no \
    --without-x
make -j8
make install
cd ..
