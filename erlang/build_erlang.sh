#!/bin/bash

USE_LATEST_VERSION=no
BUILD_ERLANG=yes

source ../build_pkg.sh
source ../gen_modules.sh
# Ref: http://www.erlang.org/doc/installation_guide/INSTALL.html

guess_build_pkg erlang http://www.erlang.org/download/otp_src_18.3.tar.gz
guess_print_modfile erlang ${erlang_ver}

