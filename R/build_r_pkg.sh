#!/bin/bash



_fname=$(mktemp "/tmp/__r_pkg_install.XXXXXXX.R")
touch ${_fname}

cat <<_EOF_R_PKG_ | tee -a ${_fname}
local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.r-project.org" 
       options(repos=r)
})
require(devtools)
require(Rcpp)

_EOF_R_PKG_

module load hdf5/5
config_args="LIBS=-L${HDF5_ROOT}/lib CPPFLAGS=-I${HDF5_ROOT}/include"

cat <<EOF | tee -a ${_fname}
install.packages('h5', configure.args = ${config_args})
EOF

echo "Output fname: ${_fname}"
Rscript ${_fname}

#install_github("mannau/h5", args = "--configure-vars='LIBS=-L/home/philip/local/.drgscl/cellar//hdf5/1.8.17/lib CPPFLAGS=-I/include'")
