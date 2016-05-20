#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

BUILD_ZMQ=yes
BUILD_LIBSODIUM=no

guess_build_pkg libsodium $PWD/libsodium-1.0.9.tar.gz
guess_print_modfile libsodium ${libsodium_ver}
module load libsodium

guess_build_pkg zmq $PWD/zeromq-4.1.4.tar.gz
guess_print_modfile zmq ${zmq_ver}
