#!/bin/bash

# To be called after the new python environment is set

#module load python/2.7.5-gnu
echo `which python`

tmp_dir=/scratch1/phi/pyplot
base_dir=$PWD
script=$(basename $0)
mkdir -p $tmp_dir

function quit_with()
{
    printf "Error [ $script ]:\n"
    printf ">>>   $@\n"
    exit
}

function download_pkg()
{
    url=$1
    tarball=$(basename "$url")
    ext=`echo $tarball | perl -ne 'if ($_ =~ /.*(\.tar\.bz2|\.tar\.gz)$/) {print $1;}'`
    if [ -z $ext ]; then quit_with "cannot find a supported extension"; fi
    fname=$(basename "$tarball" "$ext")
    echo "$tarball, $ext, $fname"
    case "$ext" in
	".tar.gz") tar_flag="-zxvf";;
	".tar.bz2") tar_flag="-jxvf";;
    esac
    
    ver=$fname
    if [ ! -d $ver ]; then
	if [ ! -f $tarball ]; then wget $url; fi
	echo "Uncompressing ... might take a while ... be patient"	
	fname=`tar $tar_flag $tarball | sed -e 's@/.*@@' | uniq`
	if [ "$fname" != "$ver" ]; then mv $fname $ver; fi
	rm $tarball
    fi

    local __retval=$2
    eval $__retval="$PWD/$ver"
}


# Build sip
sip_ver=4.15.4
sip_url=http://sourceforge.net/projects/pyqt/files/sip/sip-$sip_ver/sip-$sip_ver.tar.gz
cd $tmp_dir
download_pkg $sip_url sip_dir

cd $sip_dir
make clean; make distclean
python configure.py
make 
make install
cd $base_dir


# Build PyQt
pyqt_ver=4.10.3
pyqt_url=http://sourceforge.net/projects/pyqt/files/PyQt4/PyQt-$pyqt_ver/PyQt-x11-gpl-$pyqt_ver.tar.gz
cd $tmp_dir
download_pkg $pyqt_url pyqt_dir

echo $pyqt_dir; cd $pyqt_dir
module load qt
make clean; make distclean
python configure-ng.py --confirm-license
make -j8
make install
cd $base_dir
exit

# Build matplotlib from the git repository
cd matplotlib/dev
git pull
python setup.py clean
python setup.py build
python setup.py install
cd ../..

# pip install ipython
# pip install mayavi
