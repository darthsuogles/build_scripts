
drgscl_root=${script_dir}/..
drgscl_local=${HOME}/local/.drgscl

# Logging Utilities
function _log_msg() { >&2 printf "$(date '+%D %T %a (%Z)') [$1] [drgscl]:"; shift; >&2 echo "${@}\n"; }
function log_info() { _log_msg "INFO" "${@}"; }
function log_warn() { _log_msg "WARNING" "${@}"; }
function log_warn() { _log_msg "ERROR" "${@}"; }
function quit_with() { _log_msg "ERROR => quit" "${@}"; exit; }

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

