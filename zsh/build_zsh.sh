#!/bin/bash

source ../build_pkg.sh

ver=5.2
tarball=zsh-${ver}.tar.xz
guess_build_pkg zsh http://sourceforge.net/projects/zsh/files/zsh/${ver}/${tarball}
