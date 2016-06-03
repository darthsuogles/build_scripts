#!/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source ${script_dir}/common.sh

set -ex

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

function guess_print_modfile() {
    [[ $# -eq 2 ]] || quit_with "usage: guess_print_modfile <pkg> <ver>"
    local pkg=$1
    local ver=$2
    local pkg_dir="$(get_pkg_install_dir ${pkg} ${ver})"
    if [ -z "${pkg_dir}" ] || [ ! -d "${pkg_dir}/" ]; then
        quit_with "cannot locate install location for ${pkg}/${ver}"
    fi

    local PKG="$(echo ${pkg} | tr '[:lower:]' '[:upper:]')"
    print_header ${pkg} ${ver}
    export module_file=${module_file}
    print_modline "setenv ${PKG}_ROOT ${pkg_dir}"
    [ -d "${pkg_dir}/bin/" ]          && \
        print_modline "prepend-path PATH            ${pkg_dir}/bin"
    [ -d "${pkg_dir}/lib" ]           && \
	print_modline "prepend-path LIBRARY_PATH    ${pkg_dir}/lib"
    [ -d "${pkg_dir}/include" ]       && \
	print_modline "prepend-path CPATH           ${pkg_dir}/include"
    [ -d "${pkg_dir}/share/man" ]     && \
        print_modline "prepend-path MANPATH         ${pkg_dir}/share/man"
    [ -d "${pkg_dir}/share/info" ]    && \
        print_modline "prepend-path INFO_PATH       ${pkg_dir}/share/info"
    [ -d "${pkg_dir}/lib/pkgconfig" ] && \
        print_modline "prepend-path PKG_CONFIG_PATH ${pkg_dir}/lib/pkgconfig"

    log_info "Automatic package config inference done ..."
}
