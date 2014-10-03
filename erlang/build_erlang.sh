#!/bin/bash

ver=17.1

#export dtrace='~/dtrace'

source ../build_pkg.sh

scratch_dir=`find_scratch_dir`
build_dir=$scratch_dir/phi/erlang
install_dir=$PWD/$ver
script_name=`dirname $0`

mkdir -p $build_dir; cd $build_dir
update_pkg "http://www.erlang.org/download/otp_src_$ver.tar.gz" $ver
mkdir -p $install_dir; ln -sfn $build_dir/$ver $install_dir/src

cp dtrace $HOME/local/bin/.

# Run the build script
cd $ver
./configure \
    --prefix=$install_dir \
    --build=x86_64-redhat-linux-gnu \
    --enable-m64-build
    #--enable-native-libs \
    #--enable-dirty-schedulers \
    #--with-dynamic-trace=systemtap
make distclean; make clean
make -j8
make install
cd ..
