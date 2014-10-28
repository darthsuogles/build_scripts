#!/bin/bash

url=$(curl -sL http://julialang.org/downloads/ | perl -ne 'print "$1\n" if /(https:\/\/(.*?)-linux-x86_64\.tar\.(bz2|gz))/')
tarball=$(basename $url)
ver=$(echo $tarball | perl -ne 'print $1 if /((\d+\.?)+?)-linux/')

source ../build_pkg.sh

prepare_pkg julia $url $ver install_dir

echo $install_dir
echo "Warning: this package is pre-built, we will just copy everything to the install directory"
cp -r $ver/* $install_dir/.
