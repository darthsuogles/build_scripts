#!/bin/bash

source ../build_pkg.sh

ver=2.2
url=https://github.com/tmux/tmux/releases/download/${ver}/tmux-${ver}.tar.gz
guess_build_pkg tmux "${url}" -d "libevent readline"
