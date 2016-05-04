
drgscl_root=${script_dir}/..
drgscl_local=${HOME}/local/.drgscl

function get_drgscl_root() { echo ${drgscl_root}; }
function get_build_root { echo "${drgscl_local}/__build/"; }
function get_install_root { echo "${drgscl_local}/cellar/"; }
function get_modulefiles_root { echo "${drgscl_local}/modulefiles"; }

function _log_msg() { >&2 printf "$(date '+%D %T %a (%Z)') [$1] [drgscl]:"; shift; >&2 echo "${@}\n"; }
function log_info() { _log_msg "INFO" "${@}"; }
function log_warn() { _log_msg "WARNING" "${@}"; }
function log_warn() { _log_msg "ERROR" "${@}"; }
function quit_with() { _log_msg "ERROR => quit" "${@}"; exit; }
