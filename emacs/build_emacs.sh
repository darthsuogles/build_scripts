#!/bin/bash

source ../build_pkg.sh

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
url=http://gnu.mirrors.hoobly.com/gnu/emacs/emacs-24.5.tar.xz
guess_build_pkg emacs ${url} -c "configure_fn"
cat <<EOF > ${emacs_module_file}
setalias("emacs-server", "${install_dir}/bin/emacs")
setalias("emacs-client", "${install_dir}/bin/emacsclient")
setalias("emacs", "${install_dir}/bin/emacs")
EOF
