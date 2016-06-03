#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh

url=https://github.com/Linuxbrew/linuxbrew.git

load_or_build_pkgs git

(cd $(get_install_root)
    mkdir -p linuxbrew && cd $_
    [ -d dev ] || git clone ${url} dev
    cd dev && git pull
    git submodule update --init --remote --recursive
    export HOMEBREW_BUILD_FROM_SOURCE=yes
    export PATH=$PWD/bin:$PATH
    brew tap homebrew/dupes 
    brew tap homebrew/science 
    brew tap homebrew/python
    brew install zlib bzip2 xz readline pcre
)

guess_print_lua_modfile linuxbrew dev ${url}
cat <<EOF | tee -a ${linuxbrew_module_file}
setenv("HOMEBREW_BUILD_FROM_SOURCE", "yes")
EOF

