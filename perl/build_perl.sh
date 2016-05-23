#!/bin/bash

source ../build_pkg.sh
source ../gen_modules.sh

BUILD_PERL=no
INSTALLER_PERL_VERSION=5.20.1

function build_perl() {
    BASHR=~/.zshrc.perl
    CPANMTMP=~/.cpanm

    perlbrew_dir=$(get_pkg_install_dir perlbrew dev)
    export PERLBREW_ROOT=${perlbrew_dir}
    export PERLBREW_HOME=${perlbrew_dir}

    log_info "Installing perlbrew"
    curl -k -L http://xrl.us/perlbrewinstall | bash

    source ${PERLBREW_ROOT}/etc/bashrc
    perlbrew -n install perl-${INSTALLER_PERL_VERSION}
    perlbrew switch perl-${INSTALLER_PERL_VERSION}
    perlbrew install-cpanm
}
[ "no" == "${BUILD_PERL}" ] || build_perl

echo "source ${PERLBREW_ROOT}/etc/bashrc" >> ~/.zshrc.perl
guess_print_modfile perlbrew dev
