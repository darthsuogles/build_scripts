#!/bin/bash

ver=3.3.1
pkg=maven

ver_major=${ver%%.*}
ver_minor=${ver#*.}

source ../build_pkg.sh
url=http://download.nextag.com/apache/${pkg}/${pkg}-${ver_major}/${ver}/binaries/apache-${pkg}-${ver}-bin.tar.gz
prepare_pkg $pkg $url $ver install_dir

cp -r $ver/* $install_dir/.
