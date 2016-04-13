#!/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source ${script_dir}/common.sh

function print_header()
{
    [[ $# -eq 2 ]] || quit_with "usage: print_header <pkg> <ver>"
    local pkg=$1
    local ver=$2
    export module_file=$(get_modulefiles_root)/$pkg/$ver
    local dnm=$(dirname $module_file)
    [ -d $dnm ] || mkdir -p $dnm

    echo "#%Module 1.0"                    | tee $module_file
    echo "#"                                | tee -a $module_file
    echo "# $pkg $ver "                     | tee -a $module_file
    echo "#"                                | tee -a $module_file
    echo " "                                | tee -a $module_file
    echo "conflict $pkg"                    | tee -a $module_file
    echo " "                                | tee -a $module_file
}

function latest_version()
{
    [[ $# -eq 1 ]] || quit_with "usage: latest_version <dir>"
    echo $(ls -d "${1}/*/" | xargs basename | sort -n | tail -n1)
}

function print_modline()
{
    [[ $# -eq 1 ]] || quit_with "usage: print_modline <content>"
    if [ -z $module_file ]; then
	echo $@
    else
	echo $@ | tee -a $module_file
    fi
}
