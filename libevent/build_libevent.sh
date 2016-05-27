#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh

BUILD_LIBEVENT=no

url=https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
guess_build_pkg libevent ${url}
guess_print_lua_modfile libevent ${libevent_ver} ${url}
