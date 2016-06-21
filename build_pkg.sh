#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_script_dir_="${script_dir}"
source ${script_dir}/common.sh
source "$(get_install_root)/Lmod/dev/lmod/lmod/init/bash"

function search_scratch_dirs() {   
    [[ $# != 1 ]] && quit_with "search_scratch_dirs <artifact_name>"
    local artifact="$1"
    #local res=$(find /scratch/ -mindepth 2 -maxdepth 4 -name "${artifact}" -type f)
    for dnm in /scratch/*/.drgscl/*/; do         
        if [ -f "${dnm}/${artifact}" ]; then 
            echo "${dnm}/${artifact}" && return 0
        fi
    done
}

function find_scratch_dir() {
    local scratch_dir=$(find /scratch/ -mindepth 2 -maxdepth 2 \
                             -name '*.drgscl' -type d \
                             -exec /bin/bash -c 'df {} | tail -n1' \; | \
                               sort -k3 | awk '{print $NF}' | head -n1)
    [ -d "${scratch_dir}" ] || local scratch_dir="${HOME}/local/.drgscl/__build"
    echo ${scratch_dir}
}

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

# Mimicking a human user
function _wisper_fetch() {    
    which wget &>/dev/null  && unalias wget || log_info "wget not found?"
    which curl &>/dev/null  && unalias wget || log_info "curl not found?"
    local user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17"
    local header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    local cmd=$1; shift
    
    case "$cmd" in
        wget) wget --header="${header}" --user-agent="${user_agent}" "$@"
              ;;
        curl) curl -A "${user_agent}" "$@"
              ;;
        \?) return 1
            ;;
    esac
}
alias wget='_wisper_fetch wget'
alias curl='_wisper_fetch curl'

# Download and decompress a package specified by an url containing the tarball
# e.g. http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.5.0.tar.gz
function fetch_tarball()
{
    [[ $# -eq 3 ]] || quit_with "[fectch_tarball] usage: <url> <ver> <tarball_var>"
    local url=$1
    local ver=$2
    local _res_var=$3

    tarball=$(echo $url | perl -pe '/.*\.(gz|bz2|tgz|tbz2|xz|zip)/')
    [ -n "$tarball" ] || \
        tarball=$(_wisper_fetch curl -sIkL $url | perl -ne 'print $1 if (/\/([^\/]+?\.(gz|bz2|tgz|tbz2|xz|zip))/)')
    tarball=$(basename $tarball)
    log_info "tarball name resolved as $tarball"

    ext=${tarball##*.}
    prefix=${tarball%.*}

    case "${ext}" in 
        tgz)
	        args=zxvf
            ;;
        gz) [ "tar" != "${prefix##*.}" ] && quit_with "unrecognized tarball ${tarball}"
            args=zxvf
	        prefix=${prefix%.*}
            ;;
        bz2) [ "tar" != "${prefix##*.}" ] && quit_with "unrecognized tarball ${tarball}"
             args=jxvf
	         prefix=${prefix%.*}
             ;;
        xz) [ "tar" != "${prefix##*.}" ] && quit_with "unrecognized tarball ${tarball}"            
	        which unxz &> /dev/null || quit_with "xz extension is not supported"
            local postproc_flag="xz"
	        args=xvf
            ;;
        zip)           
	        log_warn "[fetch_tarball]: zip file supported via creating an intermediary tarball"
            local postproc_flag="zip"
	        args=xvf
            ;;
        \?)            
	        quit_with "unknown compressed tarball extension: $ext"
            ;;
    esac
    
    echo "$prefix, $ext, $args"
    fname=$prefix
    echo $fname | perl -ne 'if ( $_ =~ /\d+.*/ ) { print $1 }'

    if [ "yes" != FORCE_DOWNLOAD_TARBALL ]; then
        log_info "searching directories to see if the tarball has been downloaded"
        local existing_tarball=$(search_scratch_dirs ${tarball})
        [ -f "${existing_tarball}" ] && mv ${existing_tarball} .
    fi
    if [ ! -f $tarball ]; then
	    url_protocol=${url%%://*} 
        _wisper_fetch wget "${url}" \
            || _wisper_fetch wget --no-check-certificate "${url}" \
            || _wisper_fetch curl --sslv3 -kL -O "${url}" \
            || _wisper_fetch wget --ca-certificate=/etc/pki/tls/cert.pem "${url}"
	    [ -f ${tarball} ] || log_warn "failed to download [ $tarball ] 1st attemp"
        [ -n "$(file "${tarball}" | grep -Ei 'compressed data')" ] || (rm -f "${tarball}" && wget "${url}")
        [ -f ${tarball} ] || quit_with "failed to download [ $tarball ] 2nd attemp"
    fi

    case "${postproc_flag}" in
        zip)
	        log_warn "[fetch_tarball]: after download, transform the zip file"
	        local zip_fnm=$(unzip -ql $tarball | \
	                               perl -ne 'if ( $_ =~ /\s+([^\/\s]+?)\/.*/) { print "$1\n"; exit }')
	        log_info "[fetch_tarball]: unzipped file name: [$zip_fnm]"
	        [ ! -z "$zip_fnm" ] || quit_with "[fetch_tarball] zip: failed to extract file name"
	        unzip $tarball
	        tar -cvf $prefix.tar $zip_fnm
	        rm -fr $zip_fnm
	        tarball=$prefix.tar
            ;;
        xz)
            log_info "postprocessing xz tarball ${tarball}"
            unxz < ${tarball} > ${prefix}
	        tarball=$prefix
	        prefix=${prefix%.*}
            ;;
        \?)
            log_info "standard tarball, no more postprocessing"
            ;;
    esac

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
    [[ $# -eq 2 ]] || quit_with "[update_pkg] usage: <fpath> <ver>"
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
    [ "yes" == "${FORCE_REMOVE_TARBALL}" ] && rm $tarball
    return 0
}

function get_pkg_install_dir() {
    [[ $# -eq 2 ]] || quit_with "Usage: get_pkg_install_dir <pkg> <ver>"
    local pkg=$1
    local ver=$2

    _install_dir=${drgscl_local}/cellar/${pkg}/${ver}
    eval ${pkg}_ver="'${ver}'"
    eval ${pkg}_dir="'${_install_dir}'"
    echo ${_install_dir}
}

function prepare_pkg()
{
    [[ $# -eq 4 ]] || quit_with "Usage: build_pkg <pkg> <fpath> <ver> <install_dir_var>"
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
    # Warinig: this variable cannot be local
    _install_dir=${drgscl_local}/cellar/${pkg_name}/${pkg_ver} && mkdir -p ${_install_dir}

    log_info "Moving to build dir $build_dir"
    cd ${build_dir}
    update_pkg $pkg_fpath $pkg_ver
    rm -f "${_install_dir}/src"
    ln -s "${build_dir}/${ver}" "${_install_dir}/src"

    # Set the install dir to the return value
    eval $_res_var="'${_install_dir}'"
    eval ${pkg_name}_install_dir="'${_install_dir}'"
}

function find_tarball_name() {
    perl -ne 'print "$1\n" if /\/?((\w+?[_\-]?)*?(\d+(\.\d+)*)([_\-]+\w+?)*?\.(tar(\.gz|\.bz2|\.xz)*|tgz|tbz2|zip))/'
}

function load_or_build_pkgs() {
    [[ $# -ne 2 ]] || quit_with "usage: $0 <pkg>"
    for _i_pkg in ${@}; do
        if module load ${_i_pkg} &>/dev/null; then
            log_info "module ${_i_pkg} already exists"
        else
            log_info "building the package ${_i_pkg}"
            cd ${_script_dir_}/${_i_pkg} && ./build_${_i_pkg}.sh
            module load ${_i_pkg}
        fi
    done
}

function guess_build_pkg() {
    [[ $# -lt 2 ]] && cat <<EOF && quit_with "require at least two arguments"
usage: $0 <pkg> <url>
       -t <build_type>
       -c <configure_fn>
       -b <build_fn>
       -i <install_fn>
       -d <pkg> [...]

EOF
    set -ex

    local pkg=$1; local _pkg_="${pkg}"
    local url=$2; local _url_="${url}"    
    shift 2
    while getopts ":c:b:i:d:t:v:" opt "$@"; do
        case "${opt}" in 
            t) local build_type="${OPTARG}"
               ;;
            c) local configure_fn="${OPTARG}"
               ;;
            b) local build_fn="${OPTARG}"
               ;;
            i) local install_fn="${OPTARG}"       
               ;;
            d) local deps_list="${OPTARG}"
               ;;
            v) local forced_version="${OPTARG}"
               ;;
            \?) quit_with "usage: guess_build_pkg <pkg> <url> [configure_fn] [make_fn] [make_install_fn]"
                ;;
        esac
    done
    

    cat <<__EOF__
     pkg          : ${pkg}
     url          : ${url}
     configure_fn : ${configure_fn}
     build_fn     : ${build_fn}
     install_fn   : ${install_fn}
     dependencies : ${deps_list}
__EOF__

    local _curr_pkg="${pkg}"
    log_info "${deps_list}"
    local pkg="NO_SUCH_PKG"
    load_or_build_pkgs "${deps_list}"
    local pkg="${_curr_pkg}"
    log_info "restored name: ${pkg}"

    local tarball=$(echo $(basename ${url}) | find_tarball_name)
    local _provided_tarball=${tarball}
    [ -z "${tarball}" ] || local url=${url%/*}

    if [ -z "${forced_version}" ] && [ "no" != "${USE_LATEST_VERSION}" ]; then
        log_info "attempt to get the latest version from the provided url"
        local _tb_list=($(_wisper_fetch curl -sL ${url} | find_tarball_name | sort -rV))
        local latest_tarball=${_tb_list[0]}
	    if [ -n "${latest_tarball}" ]; then
            local _resp_code="$(_wisper_fetch curl -sLi -o /dev/null -w "%{http_code}" "${url}/${latest_tarball}")"
            if [ "200" == "${_resp_code}" ]; then
                _resp_type=$(_wisper_fetch curl -sLI "${url}/${latest_tarball}" | \
		                            perl -ne 'print $1 if /Content-Type:\s+([^\s;]+);?/')
                if [ "text/html" != "${_resp_type}" ]; then
		            local latest_ver=$(echo ${latest_tarball} | perl -ne 'print $1 if /(\d+([\._]\d+)*)\.\w+/')
                fi
	        fi
	    fi
    fi

    if [ -n "${forced_version}" ]; then
        log_info "using forced version ${forced_version}"
        local ver=${forced_version}
    elif [ -n "${latest_ver}" ]; then
        log_info "found version ${latest_ver} from user provided url"
        local ver=${latest_ver}
        local tarball=${latest_tarball}
    else
        # greedy match: e.g. hdf5-1.10.1.tar.bz2 => ver=1.10.1
        local ver=$(echo ${_provided_tarball} | perl -ne 'print $1 if /(\d+([\._]\d+)*)\.\w+/')
    fi
    [ -n "${ver}" ] || quit_with "cannot get the correct version"
    local ver="$(echo "${ver}" | tr '_' '.')"

    [ -n "${build_type}" ] && local ver=${ver}-${build_type}
    local _ver_=${ver}
    eval "${pkg}_ver=${ver}"    

    local PKG=$(echo ${pkg} | tr '[:lower:]' '[:upper:]')
    [ "no" == "$(eval "echo \$BUILD_${PKG}")" ] && return 0    
    local _url_="${url}/${tarball}"
    eval "${pkg}_url=${_url_}"
    prepare_pkg ${pkg} ${url}/${tarball} ${ver} install_dir
    eval "${pkg}_dir=${install_dir}"

    cd $ver
    if [ -n "${configure_fn}" ]; then        
        eval ${configure_fn} "${install_dir}"
    else
        ./configure --prefix="${install_dir}"
    fi
    if [ -n "${build_fn}" ]; then
        eval ${build_fn}
    else
        make -j32
    fi
    if [ -n "${install_fn}" ]; then
        eval ${install_fn}
    else
        make install
    fi

    cat <<EOF
      =======================================
      The package ${pkg} ${ver} is built in
         ${PWD}
      =======================================
EOF

    source ${_script_dir_}/gen_modules.sh
    guess_print_lua_modfile ${_pkg_} ${_ver_} ${_url_} "${deps_list}"
    return 0
}
