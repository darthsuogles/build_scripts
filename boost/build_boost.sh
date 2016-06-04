#!/bin/bash

source ../build_pkg.sh

set -ex

function c_fn() {
    brew install icu4c
    echo -e "Bootstrapping ... patience"
    
    local python3_prefix=$(python3-config --prefix)
    local python3_includes=$(python3-config --includes | \
                                    perl -ne 'print "$1\n" if /\-I([\S]+)\s+/' | \
                                    tail -n1)
    local python3_libs=${python3_prefix}/lib

    cat <<EOF > ./project-config.jam 
import option ;
import feature ;

using gcc ;
using mpi ;

project : default-build <toolset>gcc ;

import python ;

using python : 3.5 
    : ${python3_prefix}
    : ${python3_includes}
    : ${python3_libs} ;

libraries =  ;

option.set prefix : ${install_dir} ;
option.set exec-prefix : ${install_dir} ;
option.set libdir : ${install_dir}/lib ;
option.set includedir : ${install_dir}/include ;

option.set keep-going : false ;

EOF
}

function b_fn() {
    echo -e "Building ... patience"
    ./b2 install
}

url=http://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2 
guess_build_pkg boost "${url}" -c "c_fn" -b "b_fn" -d "linuxbrew python openmpi bzip2"
