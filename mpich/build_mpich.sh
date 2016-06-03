#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh

BUILD_MPICH=yes

guess_build_pkg mpich http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz
guess_print_modfile mpich ${mpich_ver}
