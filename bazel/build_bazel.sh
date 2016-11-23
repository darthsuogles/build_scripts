#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

export JAVA_HOME=/usr/lib/jvm/java-7-oracle
#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# guess_print_lua_modfile bazel dev ${url}
# cat <<EOF
# EOF | tee -a ${linuxbrew_module_file}
# setenv("HOMEBREW_BUILD_FROM_SOURCE", "yes")
# EOF
# EOF

ver=0.4.0
shfnm=bazel-${ver}-jdk7-installer-linux-x86_64.sh    
url=https://github.com/bazelbuild/bazel/releases/download/${ver}/${shfnm}

(cd $(get_install_root)
    mkdir -p bazel/${ver} && cd $_
    if [ ! -f "${shfnm}" ]; then curl -sL -O ${url} || wget ${url}; fi
    chmod a+x ${shfnm}
    ./${shfnm} --prefix=${PWD} --bazelrc=$HOME/bazelrc 
)

bazel_dir=$(get_install_root)/bazel/${ver}

cat <<EOF >> ~/.bashrc
source ${bazel_dir}/lib/bazel/bin/bazel-complete.bash
EOF

guess_print_lua_modfile bazel ${ver} ${url}
