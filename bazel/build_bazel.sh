#!/bin/bash

source ../build_pkg.sh 
source ../gen_modules.sh 
source ../common.sh

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ver=0.5.2
shfnm="bazel-${ver}-installer-linux-x86_64.sh"
url=https://github.com/bazelbuild/bazel/releases/download/${ver}/${shfnm}

BAZEL_ROOT="$(get_install_root)/bazel/${ver}"

(mkdir -p "${BAZEL_ROOT}" && cd $_
 if [[ ! -f "${shfnm}" ]]; then curl -sL -O ${url} || wget ${url}; fi
 chmod a+x ${shfnm} 
 ./${shfnm} --prefix="${BAZEL_ROOT}"
)

cat <<'EOF' >> ~/.bashrc
module load bazel
source "${BAZEL_ROOT}/lib/bazel/bin/bazel-complete.bash"
EOF

guess_print_lua_modfile bazel ${ver} ${url}
