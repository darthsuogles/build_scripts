#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

BUILD_GLOG=yes
guess_build_pkg glog https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
guess_print_modfile glog ${glog_ver}
