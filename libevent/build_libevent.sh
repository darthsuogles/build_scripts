#!/bin/bash

source ../build_pkg.sh

url=https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
guess_build_pkg libevent ${url}
