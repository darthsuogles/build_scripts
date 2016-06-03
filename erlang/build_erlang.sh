#!/bin/bash

USE_LATEST_VERSION=no

source ../build_pkg.sh
# Ref: http://www.erlang.org/doc/installation_guide/INSTALL.html

#url=http://www.erlang.org/download/otp_src_18.3.tar.gz
url=http://erlang.org/download/otp_src_17.5.tar.gz
guess_build_pkg erlang ${url}

