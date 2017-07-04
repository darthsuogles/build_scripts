#!/bin/bash

source ../build_pkg.sh

ver=2.2
function c_fn() {
    module load linuxbrew
    brew install ncurses
    ncurses_cflags="-I$(brew --prefix)/include"
    ncurses_ldflags="-L$(brew --prefix)/lib"
    ./configure --prefix=${install_dir} \
	CPPFLAGS="${CPPFLAGS:-} ${ncurses_cflags}" \
	LDFLAGS="${LDFLAGS:-} ${ncurses_ldflags}"
}
url=https://github.com/tmux/tmux/releases/download/${ver}/tmux-${ver}.tar.gz
guess_build_pkg tmux "${url}" -c "c_fn" -d "linuxbrew libevent readline"
