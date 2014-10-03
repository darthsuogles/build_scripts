#!/bin/bash

# Build a python distribution with Intel MKL
ver=2.7.8
arch=gnu
intel_root=/opt/stow/intel/composer_xe_2013/
mkl_root=$intel_root/mkl

tmp_dir=/tmp/phi/python
base_dir=$PWD
script_name=`basename $0`

function usage()
{    
    echo -e "$script_name [-v version] [-a arch]\n"
    exit
}

function quit_with()
{
    echo "Error: [ $script_name ]"
    printf "     $@\n"
    exit
}

while getopts "hv:a:y" opt; do
    case "$opt" in
	h) usage;;
	v) ver=$OPTARG;;
	h) arch=$OPTARG;;
	y) agreed="yes";;
	\?) usage;;
    esac
done
echo "------------------------------------------"
echo "Building python"
echo ">> version: $ver"
echo ">>    arch: $arch"
echo ">> mkl dir: $mkl_root"
echo "------------------------------------------"
while :
do
    printf "Are these the intended options [y]es or [n]o: "
    if [ ! -z $agreed ]; then echo "yes"; break; fi
    read -n 1 confirmed
    echo
    case "$confirmed" in
	y) break;;
	n) exit;;
	\?) echo ">> quit, bye"; exit;;
    esac    
    echo ">> must choose [y|n]"
done

#export PYTHONHOME=$PWD/$ver/build-tree/$arch
export PYTHONHOME=$PWD/install/$ver/$arch
export PYTHON_ARCH=$arch
export PYTHON_VER=$ver
export PYTHON_INTEL_ROOT=$intel_root
export PYTHON_MKL_ROOT=$mkl_root

mkdir -p $tmp_dir; cd $tmp_dir
if [ ! -d $ver ]; then
    fname=Python-$ver
    tarball=$fname.tgz
    if [ ! -r $tarball ]; then
	url=http://www.python.org/ftp/python/$ver/$tarball
	wget $url || wget --no-check-certificate $url
    fi    
    echo "Uncompressing ... might take a while ... please be patient"
    fname=`tar -xvzf $tarball | sed -e 's@/.*@@' | uniq`
    echo "filename: $fname"
    if [ -z $fname ]; then quit_with "cannot uncompress file"; fi
    mv $fname $ver
    rm -fr $tarball
fi
ln -s $tmp_dir/$ver $base_dir/$ver
cd $base_dir


if [[ $arch == "intel" ]]; then
    echo "building python with intel"
    module load intel/13.1.1
    export CFLAGS="-m64 -O3 -g -fPIC -fp-model strict -fomit-frame-pointer -openmp -pthread -xhost"
    export LDFLAGS="-openmp -pthread"
else
    module unload intel
    export CLFAGS="-mtune=native -O3 -g"
fi

cd $ver
make clean; make distclean; 
./configure \
    --prefix=$PYTHONHOME \
    --enable-shared \
    --with-thread \
    --enable-ipv6 \
    || quit_with "failed to configure the source code"
make -j8 || quit_with "failed to build"
make install || quit_with "failed to install"
cd ..

echo "generating module file"
mkdir -p $HOME/.modulefiles/python
./gen_modules.sh >$HOME/.modulefiles/python/$ver-$arch
module load python/$ver-$arch

echo "building auxiliary packages"
./build_aux_pkgs.sh

echo "buiding plots"
./build_plot.sh
