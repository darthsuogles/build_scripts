#!/bin/bash

source ../build_pkg.sh

url=https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
guess_build_pkg libsodium ${url}

url=https://github.com/zeromq/zeromq4-1/releases/download/v4.1.4/zeromq-4.1.4.tar.gz
guess_build_pkg zmq ${url} -d "linuxbrew libsodium"

