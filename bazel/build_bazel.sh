#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

# guess_print_lua_modfile bazel dev ${url}
# cat <<EOF
# EOF | tee -a ${linuxbrew_module_file}
# setenv("HOMEBREW_BUILD_FROM_SOURCE", "yes")
# EOF
# EOF

ver=0.2.2b
shfnm=bazel-${ver}-jdk7-installer-linux-x86_64.sh    
url=https://github.com/bazelbuild/bazel/releases/download/${ver}/${shfnm}

(cd $(get_install_root)
 mkdir -p bazel/${ver} && cd $_
 curl -sL -O ${url} || wget ${url}
 chmod a+x ${shfnm}
 ./${shfnm} --prefix=${PWD} --bazelrc=$HOME/bazelrc 
)

bazel_dir=$(get_install_root)/bazel/${ver}
cat <<EOF >> ~/.bashrc
source ${bazel_dir}/lib/bazel/bin/bazel-complete.bash
EOF
guess_print_lua_modfile bazel ${ver} ${url}

