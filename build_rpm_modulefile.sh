#!/bin/bash

script=`readlink -f $0`
basedir=`dirname $script`
#pkg="wordnet"

function usage()
{
    echo "usage: `basename $script` [options] -p <package_name>"
    echo 
    echo "  options:"
    echo "          -p <package_name>"
    exit
}

while getopts hp: opt; do
    case "$opt" in
	h) usage;;
	p) pkg=$OPTARG;;	
	?) usage;;
    esac
done

if [ -z "$pkg" ]; then
    # try with the last argument if any
    shift $((OPTIND - 1))
    if [[ $# < 1 ]]; then
	echo "Error: must provide a package name with -p"
	usage
    fi
    pkg=$1; shift
    if [[ $# > 0 ]]; then
	echo "Warning: unknown input parameters: $@"	
    fi
fi

# Now get the directory of the package
#vers=(`ls $basedir/$pkg | sort -hr`)
vers=(`ls $basedir/$pkg | sort -r`)
ver=${vers[0]}

echo "found the latest version: $ver"

function gen_modulefile()
{
    echo "#%Module 1.0"
    echo "#"
    echo "# $pkg $ver from RedHat (automatically generated)"
    echo "#"
    echo
    for d in `ls -d $basedir/$pkg/$ver/*/`; do
	if [ -d $d/lib ]; then
	    echo "prepend-path    LIBRARY_PATH       $d/lib"
	    echo "prepend-path    LD_LIBRARY_PATH    $d/lib"
	fi	
	if [ -d $d/lib64 ]; then
	    echo "prepend-path    LIBRARY_PATH       $d/lib64"
	    echo "prepend-path    LD_LIBRARY_PATH    $d/lib64"
	fi
	if [ -d $d/include ]; then
	    echo "prepend-path    CPATH              $d/include"	
	fi
	if [ -d $d/bin ]; then
	    echo "prepend-path    PATH               $d/bin"	
	fi
	if [ -d $d/share/man ]; then
	    echo "prepend-path    MANPATH            $d/share/man"
	fi
	echo "# End: $d"
	echo
    done

}

mkdir -p $basedir/.modulefiles/$pkg
gen_modulefile | tee $basedir/.modulefiles/$pkg/$ver
