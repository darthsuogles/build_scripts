
_bsd_="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${_bsd_}/../lib_pprint.sh

drgscl_root="${_bsd_}/.."
drgscl_local="${HOME}/.drgscl"

# Find Locations
function get_drgscl_root() { echo ${drgscl_root}; }
function get_build_root { echo "${drgscl_local}/__build/"; }
function get_install_root { echo "${drgscl_local}/cellar/"; }
function get_modulefiles_root { echo "${drgscl_local}/modulefiles"; }
function get_pkg_install_dir() {
    [[ $# -eq 2 ]] || quit_with "params: <pkg> <ver>"
    local pkg=$1
    local ver=$2
    local install_dir="$(get_install_root)/${pkg}/${ver}"
    eval ${pkg}_dir=${install_dir}
    echo ${install_dir}
}

