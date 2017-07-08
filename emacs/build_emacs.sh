#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

function configure_fn() {
    ./configure --prefix=${install_dir} \
	            --without-jpeg \
	            --without-png \
	            --without-tiff \
	            --without-gif \
	            --without-xpm \
	            --with-x-toolkit=no \
	            --without-x
}

USE_LATEST_VERSION=no
ver=25.2
#url="http://gnu.mirrors.hoobly.com/gnu/emacs/emacs-${ver}.tar.xz"
url="http://ftp.gnu.org/gnu/emacs/emacs-${ver}.tar.gz"
guess_build_pkg emacs ${url} -c "configure_fn"
guess_print_lua_modfile emacs ${ver} ${url} 

[ -n "${emacs_dir}" ] || emacs_dir="$(get_install_root)/emacs/${ver}"
cat <<EOF | tee -a ${emacs_module_file}
set_alias("emacs-server", "${emacs_dir}/bin/emacs")
set_alias("emacs-client", "${emacs_dir}/bin/emacsclient")
EOF

cat <<'EOF' > ~/.zshrc.valkyrie 
module load emacs
if [ module load tmux ]; then
  emacs --daemon="tmux-$TMUX_PANE"
  alias emacs="emacsclient -s \"tmux-$TMUX_PANE\""
fi  
EOF
