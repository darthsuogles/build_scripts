#!/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source ${script_dir}/common.sh
source "$(get_install_root)/Lmod/dev/lmod/lmod/init/bash"

function find_scratch_dir() { mkdir -p $HOME/local/.drgscl/__build && echo "$_"; }

function check_tarball()
{
    [ $# -eq 2 ] || quit_with "[check_tarball] usage: <tarball> <args_var>"
    local tarball=$1
    local _res_var=$2

    ext=${tarball##*.}
    prefix=${tarball%.*}
    if [ "$ext" == "tar" ]; then
	args=xvf
    elif [ "$ext" == "tgz" ]; then 
	args=zxvf
    elif [ "$ext" == "gz" ] && [ ${prefix##*.} == "tar" ]; then 
	args=zxvf
	prefix=${prefix%.*}
    elif [ "$ext" == "bz2" ] && [ ${prefix##*.} == "tar" ]; then
	args=jxvf
	prefix=${prefix%.*}
    elif [ "$ext" == "xz" ] && [ ${prefix##*.} == "tar" ]; then
	[ ! -z `which unxz 2> /dev/null` ] || quit_with "xz extension is not supported"
	unxz < ${tarball} > ${prefix}
	tarball=$prefix
	args=xvf
	prefix=${prefix%.*}
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

    tarball=$(echo $url | perl -pe '/.*\.(gz|bz2|tgz|tbz2)/')
    [ ! -z "$tarball" ] || tarball=$(curl -sIkL $url | perl -ne 'print $1 if (/\/([^\/]+?\.(gz|bz2|tgz|tbz2))/)')
    tarball=$(basename $tarball)
    log_info "tarball name resolved as $tarball"

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
    elif [ "$ext" == "xz" ] && [ ${prefix##*.} == "tar" ]; then
	[ ! -z `which unxz 2> /dev/null` ] || quit_with "xz extension is not supported"
	unxz < ${tarball} > ${prefix}
	args=xvf
	tarball=$prefix
	prefix=${prefix%.*}
    elif [ "$ext" == "zip" ]; then
	#quit_with "zip format not supported"
	log_warn "[fetch_tarball]: zip file supported via creating an intermediary tarball"
	args=xvf
    else
	quit_with "unknown compressed tarball extension: $ext"
    fi
    
    echo "$prefix, $ext, $args"
    fname=$prefix
    echo $fname | perl -ne 'if ( $_ =~ /\d+.*/ ) { print $1 }'

    #exit
    if [ ! -f $tarball ]; then
	    url_protocol=${url%%://*} 
        wget $url \
            || wget --no-check-certificate $url \
            || curl --sslv3 -kL -O $url \
            || wget --ca-certificate=/etc/pki/tls/cert.pem $url
	    [ -f $tarball ] || quit_with "failed to download [ $tarball ]"
    fi

    if [ "$ext" == "zip" ]; then
	log_warn "[fetch_tarball]: after download, transform the zip file"
	local zip_fnm=$(unzip -ql $tarball | \
	    perl -ne 'if ( $_ =~ /\s+([^\/\s]+?)\/.*/) { print "$1\n"; exit }')
	log_info "[fetch_tarball]: unzipped file name: [$zip_fnm]"
	[ ! -z "$zip_fnm" ] || quit_with "[fetch_tarball] zip: failed to extract file name"
	unzip $tarball
	tar -cvf $prefix.tar $zip_fnm
	rm -fr $zip_fnm
	tarball=$prefix.tar
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
    [ $# -eq 2 ] || quit_with "[update_pkg] usage: <fpath> <ver>"
    local fpath=$1
    local ver=$2
    if [ -d $ver ]; then
	    log_info "$ver already exists"
	    return
    fi

    if [ ! -z "$(echo $fpath | grep -Ei '^(http(s)*|ftp)\:\/\/')" ]; then
	log_info "Extracting a tarball from the url address $fpath"
	fetch_tarball $fpath $ver tarball
    else # the file must already be a tarball
	log_info "Extracting a locally stored tarball, version will be ignored"
	tarball_fpath=$(readlink -f $fpath)
	tarball=$(basename $tarball_fpath)
	echo $tarball_fpath
	echo $tarball
	[ -f $tarball ] || mv $tarball_fpath ./$tarball
    fi

    check_tarball $tarball tar_args
    
    log_info "Uncompressing ... might take a while ... please be patient"
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

    # Adding a random number
    local scratch_dir=$(find /scratch/ -mindepth 2 -maxdepth 2 -name '*.drgscl' -type d \
                             -exec /bin/bash -c 'df {} | tail -n1' \; | \
                               sort -k3 | awk '{print $NF}' | head -n1)
    [ ".drgscl" == "$(basename ${scratch_dir})" ] || local scratch_dir="${scratch_dir}/.drgscl"
    if [ -d "${scratch_dir}/" ]; then
        local build_root="${scratch_dir}"
    else
        local build_root="$(get_build_root)"
    fi
    mkdir -p "${build_root}"    
    local build_dir="$(mktemp -d --suffix=.build ${build_root}/${pkg_name}.XXXXXXX)"    
    [ -d "${build_dir}/" ] || quit_with "cannot create build dir ${build_dir}"

    local install_dir=${drgscl_local}/cellar/${pkg_name}/${pkg_ver} && mkdir -p ${install_dir}

    log_info "Moving to build dir $build_dir"
    cd ${build_dir}
    update_pkg $pkg_fpath $pkg_ver
    [ -d $install_dir/src ] || ln -sf $build_dir/$ver $install_dir/src

    # Set the install dir to the return value
    eval $_res_var="'$install_dir'"
}
