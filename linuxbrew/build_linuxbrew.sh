#!/bin/bash

source ../gen_modules.sh

module load git
(cd $(get_install_root)
    mkdir -p linuxbrew && cd $_
    [ -d dev ] || git clone https://github.com/Linuxbrew/linuxbrew.git dev
    cd dev && git pull
    git submodule update --init --remote --recursive
)

guess_print_modfile linuxbrew dev
print_modline "setenv HOMEBREW_BUILD_FROM_SOURCE yes"
