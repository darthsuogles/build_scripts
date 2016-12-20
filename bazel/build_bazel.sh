#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ver=0.4.2
shfnm=bazel-${ver}-installer-linux-x86_64.sh    
url=https://github.com/bazelbuild/bazel/releases/download/${ver}/${shfnm}

(cd $(get_install_root)
    mkdir -p bazel/${ver} && cd $_
    if [ ! -f "${shfnm}" ]; then curl -sL -O ${url} || wget ${url}; fi
    chmod a+x ${shfnm}
    ./${shfnm} --prefix=${PWD} --bazelrc=$HOME/bazelrc 
)

cat <<'EOF' >> ~/.bashrc
module load bazel
source "${BAZEL_ROOT}/lib/bazel/bin/bazel-complete.bash"
EOF

guess_print_lua_modfile bazel ${ver} ${url}
