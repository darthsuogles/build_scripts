#!/bin/bash

source ../build_pkg.sh

# boost
BOOST_MAJOR=1
BOOST_MINOR=55
BOOST_VERSION=$BOOST_MAJOR.$BOOST_MINOR.0

build_dir=/scratch0/phi/boost
install_dir=$PWD/$BOOST_VERSION

BOOST_LIBDIR=$install_dir/lib
export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$LD_LIBRARY_PATH

boost_file=boost_${BOOST_MAJOR}_${BOOST_MINOR}_0
boost_tarball=$boost_file.tar.bz2
mkdir -p $build_dir; cd $build_dir
update_pkg http://downloads.sourceforge.net/project/boost/boost/$BOOST_VERSION/$boost_tarball $BOOST_VERSION
mkdir -p $install_dir; ln -s $build_dir/$BOOST_VERSION $install_dir/src

cd $build_dir/$BOOST_VERSION
echo -e "Bootstrapping ... patience"
./bootstrap.sh --prefix=$install_dir
echo -e "Building ... patience"
./b2 install

mkdir -p ~/.modulefiles/boost
./gen_modules_boost.sh | tee ~/.modulefiles/boost/$ver
