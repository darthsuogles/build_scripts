#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

ver=0.2.2b

function build_bazel() {
    shfnm=bazel-${ver}-jdk7-installer-linux-x86_64.sh
    
    url=https://github.com/bazelbuild/bazel/releases/download/${ver}/${shfnm}
    
    ./bazel-0.2.2b-jdk7-installer-linux-x86_64.sh
    prepare_pkg bazel ${url} ${ver} install_dir
    chmod +x ${shfnm}
    ${shfnm} --prefix=$HOME/local/.drgscl/bazel/0.2.2b --bazelrc=$HOME/bazelrc
}

bazel_ver=${ver}
bazel_dir=$(get_install_root)/bazel/0.2.2b

source ${bazel_dir}/lib/bazel/bin/bazel-complete.bash
print_header bazel "${bazel_ver}"
print_modline "prepend-path PATH ${bazel_dir}/bin"
