#!/bin/bash

function quit_with()
{
    echo "Error: $@"
    exit
}

# Download and decompress a package specified by an url containing the tarball
# e.g. http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.5.0.tar.gz
function update_pkg()
{
    #url=http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.5.0.tar.gz
    url=$1
    ver=$2

    tarball=`basename $url`
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
	[ -f $tarball ] || quit_with "failed to download $tarball"
    fi
    echo "Uncompressing ... might take a while ... please be patient"
    fname=`tar -$args $tarball | sed -e 's@/.*@@' | uniq`    
    [ -d $fname ] || quit_with "cannot find the extracted directory"
    if [ "$fname" != "$ver" ]; then mv $fname $ver; fi
    [ -d $ver ] || quit_with "failed to create directory $PWD/$ver"
}


# update_pkg http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.5.0.tar.gz
