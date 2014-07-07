#!/bin/bash

rose_major=0.9.5a
rose_minor=20584
rose_magic_num=852
ver=$rose_major-$rose_minor
JAVA_HOME=/usr/lib/jvm/java-1.7.0-oracle-1.7.0.55.x86_64
build_dir=/tmp/rose
install_dir=$PWD

module unload gcc

if [ $# -lt 1 ]; then
    echo "usage: build_rose.sh <release|git> [--download-boost]"
    exit
fi

function quit_with()
{
    echo "Error: $@"
    exit
}

num_procs=$(cat /proc/cpuinfo | grep processor | wc -l)
echo "build in parallel with $num_procs cores"
#BASE=$PWD

# compiler info
# export CC=icc
# export CXX=icpc
# export FC=/usr/bin/gfortran
# export CXXFLAGS=-override-limits
#source $HOME/phi/gcc/4.4.7/build-redhat/setenv.sh
export CC=gcc44
export CXX=g++44
export FC=gfortran44
echo ">> gcc info"
$CC -v
#exit

echo "Moving to $build_dir"
mkdir -p $build_dir; cd $build_dir

# boost
BOOST_MAJOR=1
BOOST_MINOR=47
BOOST_VERSION=$BOOST_MAJOR.$BOOST_MINOR.0
BOOST_DIR=$build_dir/boost/$BOOST_VERSION
BOOST_INSTALL_DIR=$install_dir/boost/$BOOST_VERSION
#BOOST_LIBDIR=$BOOST_DIR/lib
BOOST_LIBDIR=$BOOST_INSTALL_DIR/lib
export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$BOOST_LIBDIR:$LD_LIBRARY_PATH

if [ "$2" == "--download-boost" ]; then
    echo "build Boost C++ library $BOOST_VERSION"
    boost_local=$build_dir/boost
    if [ ! -d $boost_local ]; then
	mkdir $boost_local
    fi
    cd $boost_local

    if [ ! -d $BOOST_VERSION ]; then
	boost_file=boost_${BOOST_MAJOR}_${BOOST_MINOR}_0
	boost_tarball=$boost_file.tar.bz2
	if [ ! -f ./$boost_tarball ]; then
	    echo -e "\tdownloading $boost_tarball"
	    wget http://downloads.sourceforge.net/project/boost/boost/$BOOST_VERSION/$boost_tarball
	fi
	echo -e "\textracting $boost_tarball"
	tar -jxf $boost_tarball
	mv $boost_file $BOOST_VERSION
    fi

    cd $BOOST_VERSION
    if [ -e build/BOOST_BUILT ]; then
	echo "boost already built"
    else
	echo -e "\tbuilding ... patience"
	./bootstrap.sh --prefix=$BOOST_INSTALL_DIR
	#--with-toolset=$GCC_ROOT
	./b2 -j$num_procs 
	mkdir build
	./b2 install
	echo -e "\tinstalling ... patience"
	echo "boost installation finished"
	touch build/BOOST_BUILT
    fi
    cd $build_dir
fi

cd $build_dir
if [ "$1" == "git" ]; then
    if [ ! -d rose-dev ]; then
	echo "grabbing the source from git repository"
	git clone git://github.com/rose-compiler/rose.git
	mv rose rose-dev
	cd rose-dev
    else
	cd rose-dev
	git pull
	git update
	echo "updating rose "
    fi
    ./build
    git submodule init
    git submodule update
elif [ "$1" == "release" ]; then
    rose_dir=$rose_major-$rose_minor
    if [ ! -d $rose_dir ]; then
	rose_release=rose-$rose_major-$rose_minor
	rose_tarball=rose-$rose_major-without-EDG-$rose_minor.tar.gz
	echo "dowload a release $rose_release"
	#https://outreach.scidac.gov/frs/download.php/852/rose-0.9.5a-without-EDG-20584.tar.gz
	if [ ! -f $rose_tarball ]; then
	    wget --no-check-certificate https://outreach.scidac.gov/frs/download.php/$rose_magic_num/$rose_tarball
	    [ -f $rose_tarball ] || quit_with "failed to download the tarball $tarball"
	fi
	fname=`tar -zxvf $rose_tarball | sed 's@/.*@@' | uniq`
	if [ $fname != $rose_dir ]; then mv $rose_release $rose_dir; fi
	[ -d $rose_dir ] || quit_with "failed to decompress rose"
	rm $rose_tarball
    else
	echo "directory $rose_dir already exists"
    fi
    cd $rose_dir
else
    echo "option $1 not recognized (neither 'git' or 'release'), exit"
    exit
fi

echo "build rose in build-tree, with $num_proc threads"
mkdir build-tree
cd build-tree
echo ">>boost-libdir: $BOOST_LIBDIR"
echo ">>build-tree: $PWD"
#echo ">>comment: ignore the fact that libboost_regex can't be found"
#exit
../configure --prefix=$install_dir/$ver \
    --with-boost=$BOOST_INSTALL_DIR \
    --with-boost-libdir=$BOOST_LIBDIR \
    --enable-cuda --enable-opencl \
    --with-gcc-omp --with-java    
    #--with-boost=$BOOST_DIR --with-boost-libdir=$BOOST_LIBDIR \
echo "configuration done"
make -j$num_procs
make install

