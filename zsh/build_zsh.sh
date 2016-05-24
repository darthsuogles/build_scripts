#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh

BUILD_ZSH=yes

ver=5.2
tarball=zsh-${ver}.tar.xz
guess_build_pkg zsh http://sourceforge.net/projects/zsh/files/zsh/${ver}/${tarball}
guess_print_modfile zsh ${zsh_ver}
