#!/bin/bash

#module load toolchain/gcc6-drgscl
#export LD_LIBRARY_PATH="${TOOLCHAIN_ROOT}/lib64:${TOOLCHAIN_ROOT}/lib"
module load openmpi hdf5

_fname=$(mktemp "/tmp/__r_pkg_install.XXXXXXX.R")
touch ${_fname}

cat <<EOF | tee -a "${_fname}"
local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.r-project.org" 
       options(repos=r)
})
EOF

cat <<EOF | tee -a "${_fname}"
install.packages("Rmpi", configure.args=c(
                        "--with-Rmpi-type=OPENMPI", 
                        "--with-Rmpi-libpath=${OPENMPI_ROOT}/lib", 
                        "--with-Rmpi-include=${OPENMPI_ROOT}/include"))
EOF

cat <<EOF | tee -a "${_fname}"
install.packages(c("Rcpp", "RcppEigen", "RcppArmadillo", "RInside", "RcppCNPy"))
EOF

cat <<EOF | tee -a "${_fname}"
require(devtools)
install_github("mannau/h5", args = "--configure-vars='LIBS=-L${HDF5_ROOT}/lib CPPFLAGS=-I${HDF5}/include'")
EOF

Rscript "${_fname}"

