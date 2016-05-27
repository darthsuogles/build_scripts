#!/bin/bash

source ../build_pkg.sh
#source ../gen_modules.sh

ver=2.2
url=https://github.com/tmux/tmux/releases/download/${ver}/tmux-${ver}.tar.gz
#module load libevent readline
guess_build_pkg tmux "${url}" -d "libevent readline"
