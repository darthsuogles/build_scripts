#!/bin/bash

source ../build_pkg.sh

ver=${1:-1.56.0}
base_dir=$(readlink -f ${BASH_SOURCE[0]} | xargs dirname)

# boost
BOOST_MAJOR=${ver%%.*}
BOOST_MINOR=${ver#*.}; BOOST_MINOR=${BOOST_MINOR%.*}
BOOST_VERSION=$ver

#build_dir=/scratch0/phi/boost
build_dir=`find_scratch_dir`
install_dir=$PWD/$BOOST_VERSION

BOOST_LIBDIR=$install_dir/lib
export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$LD_LIBRARY_PATH

boost_file=boost_$(echo $BOOST_VERSION | tr '.' '_')
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
${base_dir}/gen_modules_boost.sh | tee ~/.modulefiles/boost/$ver
