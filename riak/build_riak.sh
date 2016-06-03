#!/bin/bash

source ../build_pkg.sh 

MODULE_INFER_LAYOUT=no

function c_fn() { echo "no config"; }
function b_fn() { make locked-deps; }
function i_fn() { make rel; cp -r rel/* ${install_dir}/. ; }

# require 'libpam-dev' on ubuntu
module purge
guess_build_pkg riak http://s3.amazonaws.com/downloads.basho.com/riak/2.1/2.1.4/riak-2.1.4.tar.gz \
                -c "c_fn" -b "b_fn" -i "i_fn" -d "linuxbrew git erlang/17.5"

cat <<__EOF__ | tee -a "${riak_module_file}"
prepend_path("PATH", "${install_dir}/riak/bin")
__EOF__
