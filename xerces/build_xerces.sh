
pkg=xerces
ver=3.1.2

ver_major=${ver%%.*}
url=http://mirror.olnevhost.net/pub/apache/$pkg/c/${ver_major}/sources/$pkg-c-$ver.tar.bz2

source ../build_pkg.sh

prepare_pkg $pkg $url $ver install_dir

cd $ver
CC=gcc CXX=g++ ./configure --prefix=$install_dir
make -j8
make install
