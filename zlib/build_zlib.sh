
ver=1.2.8

tmp_dir=/scratch1/phi/zlib
base_dir=$PWD

script=`basedir $0`

function quit_with()
{
    printf "Error [ $script ]:\n"
    printf ">>>   $@"
    exit
}

function update_pkg()
{
    ver=$1
    if [ ! -d $ver ]; then
	fname=zlib-$ver
	tarball=$fname.tar.gz
	if [ ! -d $ver ]; then
	    curl -O http://zlib.net/zlib-1.2.8.tar.gz
	fi
	fname=`tar -zxvf $tarball | sed -e 's@/.*@@' | uniq`
	mv $fname $ver        
    fi
}


mkdir -p $tmp_dir; cd $tmp_dir
update_pkg $ver || quit_with "failed to update the package of version $ver"
ln -s $tmp_dir/$ver $base_dir/$ver

cd $ver
./configure --prefix=$HOME/local
make -j8
make install
