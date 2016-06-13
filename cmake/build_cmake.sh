#!/bin/bash

source ../build_pkg.sh
function c_fn() {
    ./bootstrap --prefix="${install_dir}" --parallel=32
}
USE_LATEST_VERSION=no
guess_build_pkg cmake https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz -c "c_fn"
