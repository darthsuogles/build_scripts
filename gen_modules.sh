#!/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source ${script_dir}/common.sh

set -ex

function print_header()
{
    [[ $# -lt 2 ]] && quit_with "usage: print_header <pkg> <ver>"
    local pkg=$1; shift
    local ver=$1; shift
    local deps_str="${@}"

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
    
    if [ -n "${deps_str}" ]; then
        echo "load ${deps_str}" | tee -a "${module_file}"
    fi

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
    [[ $# -lt 2 ]] && quit_with "usage: guess_print_modfile <pkg> <ver> [deps ...]"
    local pkg=$1; shift
    local ver=$1; shift
    local deps_list="${@}"    

    local pkg_dir="$(get_pkg_install_dir ${pkg} ${ver})"
    if [ -z "${pkg_dir}" ] || [ ! -d "${pkg_dir}/" ]; then
        quit_with "cannot locate install location for ${pkg}/${ver}"
    fi
    
    print_header ${pkg} ${ver}
    
    
    local PKG="$(echo ${pkg} | tr '[:lower:]' '[:upper:]')"
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

function guess_print_lua_modfile() {
    [[ $# -lt 3 ]] && quit_with "usage: $0 <pkg> <ver> <url> [deps ...]"
    local pkg=$1
    local ver=$2
    local url=$3
    shift 3
    local deps_str="${@}"
    local module_file="$(get_modulefiles_root)/${pkg}/${ver}.lua"
    if [ -z "${LUA_MODFILE_PKG_INSTALL_DIR}" ]; then
        local pkg_dir="$(get_pkg_install_dir ${pkg} ${ver})"
    else
        log_info "using custom module install directory"
        local pkg_dir="${LUA_MODFILE_PKG_INSTALL_DIR}"
    fi
    if [ -z "${pkg_dir}" ] || [ ! -d "${pkg_dir}/" ]; then
        quit_with "cannot locate install location for ${pkg}/${ver}"
    fi

    rm -f ${module_file}
    local dnm=$(dirname $module_file)
    [ -d $dnm ] || mkdir -p $dnm
    touch ${module_file}

    cat <<EOF | tee -a ${module_file}
help([[     
    _/}  {\_
  _/ /    \ \_
 /   \ ^\\ \  \_ 
(   __\ / *\/  [\ 
 \ <   / /\>    )| 
  \ \___/\     // 
   \_|\\\ \___// 
      ''\\____/ 
         '' 
==> drgscl module management   
    package ${pkg} built on $(date)
    tarball extracted from
     ++ ${url}
]])
whatis("Version: ${ver}")
whatis("URL: ${url}")
whatis("Description: package ${pkg}")

EOF

    if [ -n "${deps_str}" ]; then
        deps_list=($(echo ${deps_str} | tr ' ' '\n'))
        for dep in ${deps_list[@]}; do
            cat <<EOF | tee -a  ${module_file}
load("${dep}")
EOF
        done
    fi

    local PKG="$(echo ${pkg} | tr '[:lower:]' '[:upper:]')"
    cat <<EOF | tee -a ${module_file}
setenv("${PKG}_ROOT", "${pkg_dir}")
EOF

    eval "${pkg}_module_file=${module_file}"
    [ "no" == "MODULE_INFER_LAYOUT" ] && return 0

    [ -d "${pkg_dir}/bin/" ] && cat <<EOF | tee -a ${module_file}
prepend_path("PATH", "${pkg_dir}/bin")
EOF

    [ -d "${pkg_dir}/include" ] && cat <<EOF | tee -a ${module_file}
prepend_path("CPATH", "${pkg_dir}/include")
EOF

    if [ -d "${pkg_dir}/lib" ]; then
        if find "${pkg_dir}/lib/" -name '*.so' -or -name '*.dylib' -type f &>/dev/null;  then
            cat <<EOF | tee -a ${module_file}
prepend_path("LIBRARY_PATH", "${pkg_dir}/lib")
EOF
        fi
    fi

    [ -d "${pkg_dir}/share/man" ] && cat <<EOF | tee -a ${module_file}
prepend_path("MANPATH", "${pkg_dir}/share/man")
EOF

    [ -d "${pkg_dir}/share/info" ] && cat <<EOF | tee -a ${module_file}
prepend_path("INFOPATH", "${pkg_dir}/share/info")
prepend_path("INFO_PATH", "${pkg_dir}/share/info")
EOF

    [ -d "${pkg_dir}/lib/pkgconfig" ] && cat <<EOF | tee -a ${module_file}
prepend_path("PKG_CONFIG_PATH", "${pkg_dir}/lib/pkgconfig")
EOF

    return 0
}
