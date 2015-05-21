#!/bin/bash

ver=1.4
url=http://www.luxrender.net/release/luxrender/$ver/linux/64/lux-v$ver-x86_64-sse2-OpenCL.tar.bz2

source ../build_pkg.sh
prepare_pkg luxrender $url $ver install_dir

cp -r $ver/* $install_dir/.
unlink $install_dir/src

