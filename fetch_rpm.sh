#!/bin/bash
###########################################################################
## 
## Download pre-built packages from a RHEL mirror site (UMD)
## 
###########################################################################

script=`readlink -f $0`
basedir=`dirname $script`

rhel_ver=`uname -a | perl -ne 'if ($_ =~ /\.(el\d)/) { print "$1" }'`
rhel_arch=`uname -m`
rpm_suffix=$rhel_ver.$rhel_arch.rpm
url="rsync://mirror.umd.edu/fedora/epel/${rhel_ver:2}Server/$rhel_arch"
echo $rpm_suffix $url
#exit

# Find the directory in which the script resides
# REF: http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
script_dir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -h "$script_dir" ]; then script_dir=`readlink -f $script_dir`;fi
#echo $script_dir; exit

function usage()
{
    echo "`basename $0` [options] <pkg_name>"
    echo "   fetch the rpms associated with a package"
    echo "   package name could be a regex pattern"
    echo 
    echo "   options: "
    echo "   -l    (default) fetch a list of arguments"
    echo "   -y    download the package"
    echo "   -m    architecture (default: x86_64)"
    echo
    exit
}

# Default values
pkg='wordnet'
list_only=true
arch=$rhel_arch

# Process input arguments
while getopts hs:lym: opt; do
    case "$opt" in
	h) usage;;
	s) pkg=$OPTARG;;
	l) list_only=true;;
	y) list_only=false;;
	m) arch=$OPTARG;;
	/?) usage;;
    esac
done

# Shift the arguments
shift $((OPTIND-1))
if [[ $# < 1 ]]; then
    echo -e "Error: package name is required\n"
    usage
fi

pkg=$1; shift;
if [[ $# > 0 ]]; then
    echo -e "Warning: additional arguments (after >>)"
    echo -e "         >> $@"
    echo -e "         not recognized\n";
    usage
fi

# First list the files and check the version
#ver_list=(`rsync -rvz rsync://mirror.umd.edu/fedora/epel/6Server/x86_64/${pkg}*.el6.x86_64.rpm | perl -ne 'chomp($line = $_); if ($line =~ m/${pkg}-(\d\S+).el6.x86_64.rpm/i) {print "$1\n";}' | sort -ur`)
ver_list=(`rsync -rvz ${url}/${pkg}*.${rpm_suffix} | perl -ne 'if ( $_ =~ m/${pkg}-(\d\S+?)\.${rpm_suffix}/ ) {print "$1\n";}' | sort -ur`)

ver=${ver_list[0]}
#echo $ver; exit
if $list_only; then
    #rsync -rvz rsync://mirror.umd.edu/fedora/epel/6Server/x86_64/${pkg}*${ver}*.el6.x86_64.rpm
    rsync -rvz ${url}/${pkg}*${ver}*.${rpm_suffix}
    echo "The latest version is $ver"
    if [[ ${#ver_list[@]} > 1 ]]; then
	echo "older versions are: ${ver_list[@]:1}"
    fi
    echo "Install dir: $basedir/${pkg}/${ver}"
    if [ -d $basedir/${pkg}/${ver} ]; then
	echo "Package already installed"
    fi
    exit
fi

# Create the package directory if not exists
curr_dir=$PWD
pkg_dir=$basedir/$pkg
if [ ! -d $pkg_dir ]; then mkdir $pkg_dir; fi
cd $pkg_dir

# Update the package in the repo, delete extra files in local repo
if [ -d $ver ]; then
    echo "Warning: [$pkg] version [$ver] already existsm skipped"
else
    # Fetch the packages
    mkdir -p .repo; cd .repo
    #rsync -rvz rsync://mirror.umd.edu/fedora/epel/6Server/x86_64/${pkg}*${ver}*.el6.x86_64.rpm .
    rsync -rvz $url/${pkg}*${ver}*.$rpm_suffix .
    cd ..; 

    # Unpack the packages
    mkdir $ver; cd $ver
    for f in `ls ../.repo/*.rpm`; do rpm2cpio $f | cpio -idmv; done
    cd ..; cd $curr_dir
fi


echo "The package [$pkg] of version [$ver] is installed in the following directory"
echo "--------------------------------------------------------"
echo "    $basedir/$pkg/$ver   "
echo "--------------------------------------------------------"
echo "Please use module load $pkg/$ver to load it into the system"
echo "We will return to directory: $PWD"

echo "Building the package modulefile"
ls $pkg_dir/$ver
$script_dir/build_rpm_modulefile.sh $pkg
