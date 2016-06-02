#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh 

guess_build_pkg curl http://curl.haxx.se/download/curl-7.37.0.tar.bz2
guess_print_modfile curl ${curl_ver}
