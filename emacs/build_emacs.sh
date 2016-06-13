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
ver=24.5
url=http://gnu.mirrors.hoobly.com/gnu/emacs/emacs-${ver}.tar.xz
guess_build_pkg emacs ${url} -c "configure_fn"
guess_print_lua_modfile emacs ${ver} ${url} 
cat <<EOF | tee -a ${emacs_module_file}
set_alias("emacs-server", "${install_dir}/bin/emacs")
set_alias("emacs-client", "${install_dir}/bin/emacsclient")
set_alias("emacs", "${install_dir}/bin/emacs")
EOF
