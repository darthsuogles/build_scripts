#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh

export JAVA_HOME=/usr/lib/jvm/java-7-oracle/
BUILD_MAVEN=yes
ver=3.3.9
pkg=maven

ver_major=${ver%%.*}
ver_minor=${ver#*.}

function configure_fn() { log_info "binary only"; }
function build_fn() { log_info "binary only"; }
function install_fn() {
    cp -r * ${install_dir}/.
}

url="http://download.nextag.com/apache/${pkg}/${pkg}-${ver_major}/${ver}/binaries/apache-${pkg}-${ver}-bin.tar.gz"
guess_build_pkg maven "${url}" -c "configure_fn" -b "build_fn" -i "install_fn"
guess_print_modfile maven ${maven_ver}
print_modline "setenv JAVA_HOME ${JAVA_HOME}"
