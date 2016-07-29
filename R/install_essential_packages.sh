#!/bin/bash

module load openmpi hdf5 szlib
export LD_LIBRARY_PATH="${HDF5_ROOT}/lib:${OPENMPI_ROOT}/lib:$(brew --prefix)/lib"

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
                        "LDFLAGS='-Wl,-rpath -Wl,${OPENMPI_ROOT}/lib -L${OPENMPI_ROOT}/lib'",
                        "--with-Rmpi-type=OPENMPI", 
                        "--with-Rmpi-libpath=${OPENMPI_ROOT}/lib", 
                        "--with-Rmpi-include=${OPENMPI_ROOT}/include"))
EOF

cat <<EOF | tee -a "${_fname}"
install.packages(c("Rcpp", "RcppEigen", "RcppArmadillo", "RInside", "RcppCNPy"))
install.packages(c('glmnet', 'lmtest', 'portes', 'forecast', 'rugarch', 'FinTS', 'Rserve')
EOF

Rscript "${_fname}"

