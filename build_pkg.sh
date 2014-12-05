#!/bin/bash

function quit_with()
{
    printf "`date` Error: $@\n"
    exit
}

# Find "scratch", a common name for the large local directory
# in a HPC environment that we can mess with
# If non is found, use /tmp
function find_scratch_dir()
{
    scratch_dir=$(df -P /scratch* /tmp* /temp* 2>/dev/null | awk '{print $4"\t"$6}' | tail -n +2 | sort | tail -n1 | awk '{print $2}') 
    [ -d $scratch_dir ] || scratch_dir='./tmp'
    echo "$scratch_dir"
}

function check_tarball()
{
    [ $# -eq 2 ] || quit_with "[check_tarball] usage: <tarball> <args_var>"
    local tarball=$1
    local _res_var=$2

    ext=${tarball##*.}
    prefix=${tarball%.*}
    if [ "$ext" == "tgz" ]; then 
	args=zxvf
    elif [ "$ext" == "gz" ] && [ ${prefix##*.} == "tar" ]; then 
	args=zxvf
	prefix=${prefix%.*}
    elif [ "$ext" == "bz2" ] && [ ${prefix##*.} == "tar" ]; then
	args=jxvf
	prefix=${prefix%.*}
    elif [ "$ext" == "xz" ]; then
	quit_with "xz extension is not supported"
    elif [ "$ext" == "zip" ]; then
	quit_with "zip format not supported"
    else
	quit_with "unknown compressed tarball extension: $ext"
    fi

    eval $_res_var="'$args'"
}

# Download and decompress a package specified by an url containing the tarball
# e.g. http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.5.0.tar.gz
#function update_pkg()
function fetch_tarball()
{
    [ $# -eq 3 ] || quit_with "[fectch_tarball] usage: <url> <ver> <tarball_var>"
    local url=$1
    local ver=$2
    local _res_var=$3

    #tarball=$(curl -sIkL $url | perl -ne 'if ($_ =~ /\/([^\/]+?\.(gz|bz2|tgz|tbz2))/) { print $1 }')
    tarball=$(echo $url | perl -pe '/.*\.(gz|bz2|tgz|tbz2)/')
    [ ! -z "$tarball" ] || tarball=$(curl -sIkL $url | perl -ne 'print $1 if (/\/([^\/]+?\.(gz|bz2|tgz|tbz2))/)')
    tarball=$(basename $tarball)
    echo "tarball name resolved as $tarball"

    ext=${tarball##*.}
    prefix=${tarball%.*}
    if [ "$ext" == "tgz" ]; then 
	args=zxvf
    elif [ "$ext" == "gz" ] && [ ${prefix##*.} == "tar" ]; then 
	args=zxvf
	prefix=${prefix%.*}
    elif [ "$ext" == "bz2" ] && [ ${prefix##*.} == "tar" ]; then
	args=jxvf
	prefix=${prefix%.*}
    elif [ "$ext" == "xz" ]; then
	quit_with "xz extension is not supported"
    elif [ "$ext" == "zip" ]; then
	quit_with "zip format not supported"
    else
	quit_with "unknown compressed tarball extension: $ext"
    fi
    
    echo "$prefix, $ext, $args"
    fname=$prefix
    echo $fname | perl -ne 'if ( $_ =~ /\d+.*/ ) { print $1 }'

    #exit
    if [ ! -f $tarball ]; then
	url_proto=${url%%://*} 
	# if [ $url_proto == "https" ]; then
	#     #wget --no-check-certificate $url 
	#     #curl --sslv3 -k -O $url
	#     # Recently github removed some ciphers
	#     # REF: https://review.openstack.org/#/c/102173/
	#     # REF: https://bugzilla.redhat.com/show_bug.cgi?id=1098711
	#     wget --ca-certificate=/etc/pki/tls/cert.pem $url
	wget $url
	[ -f $tarball ] || quit_with "failed to download [ $tarball ]"
    fi

    # Store the value of the return variable
    eval $_res_var="'$tarball'"

    # echo "Uncompressing ... might take a while ... please be patient"
    # fname=`tar -$args $tarball | sed -e 's@/.*@@' | uniq`    
    # [ -d $fname ] || quit_with "cannot find the extracted directory"
    # #if [ "$fname" != "$ver" ]; then mv $fname $ver; fi
    # mv -T $fname $ver
    # [ -d $ver ] || quit_with "failed to create directory $PWD/$ver"
}

function update_pkg()
{    
    [ $# -eq 2 ] || "[update_pkg] usage: <fpath> <ver>"
    local fpath=$1
    local ver=$2
    if [ -d $ver ]; then
	echo "$ver already exists"
	return
    fi

    if [ ! -z "$(echo $fpath | grep -Ei '^(http(s)*|ftp)\:\/\/')" ]; then
	echo "Extracting a tarball from the url address $fpath"
	fetch_tarball $fpath $ver tarball
    else # the file must already be a tarball
	echo "Extracting a locally stored tarball, version will be ignored"
	tarball_fpath=$(readlink -f $fpath)
	tarball=$(basename $tarball_fpath)
	echo $tarball_fpath
	echo $tarball
	[ -f $tarball ] || mv $tarball_fpath ./$tarball
    fi

    check_tarball $tarball tar_args
    
    echo "Uncompressing ... might take a while ... please be patient"
    fname=`tar -$tar_args $tarball | sed -e 's@/.*@@' | uniq`    
    [ -d $fname ] || quit_with "[update_pkg]: cannot find the extracted directory"
    [ "$fname" == "$ver" ] || mv $fname $ver
    [ -d $ver ] || quit_with "[update_pkg]: failed to create directory $PWD/$ver"
    rm $tarball
}

function prepare_pkg()
{
    [ $# -eq 4 ] || quit_with "Usage: build_pkg <pkg> <fpath> <ver> <install_dir_var>"
    local pkg_name=$1
    local pkg_fpath=$2
    local pkg_ver=$3
    local _res_var=$4

    tmp_dir=`find_scratch_dir`
    [ $? -eq 0 ] || quit_with "failed to find a scratch dir"
    build_dir=$tmp_dir/phi/$pkg_name
    install_dir=$PWD/$pkg_ver

    echo "Moving to build dir $build_dir"
    mkdir -p $build_dir; cd $build_dir
    update_pkg $pkg_fpath $pkg_ver
    mkdir -p $install_dir
    [ -d $install_dir/src ] || ln -sf $build_dir/$ver $install_dir/src

    # Set the install dir to the return value
    eval $_res_var="'$install_dir'"
}
